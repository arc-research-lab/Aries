#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Analysis/Liveness.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/Dialect/Affine/Passes.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "llvm/ADT/StringMap.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::affine;
using namespace mlir::arith;

namespace {

struct AriesPLIOMaterialize : public AriesPLIOMaterializeBase<AriesPLIOMaterialize> {
public:
  AriesPLIOMaterialize() = default;
  AriesPLIOMaterialize(const AriesOptions &opts) {
    BuffSels=opts.OptBuffSels;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!IOMaterialize(mod))
      signalPassFailure();

    PassManager pm(&getContext());
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
  }

private:
  // Collect and remove the adf.cells and erase adf.io.wait
  void Preprocess(OpBuilder builder, LaunchCellOp launchcell, 
                  SmallVectorImpl<CallOp>& calls){
    launchcell.walk([&](Operation *op){
      if(auto call = dyn_cast<CallOp>(op)){
        if(call->hasAttr("adf.cell"))
          calls.push_back(call);
        call->remove();
      }else if(dyn_cast<IOWaitOp>(op) || dyn_cast<WaitLaunchCellOp>(op)){
        op->erase();
      }
    });
  }
  // Move the collected adf.cell to adf.cell.launch
  void Postprocess(OpBuilder builder, LaunchCellOp launchcell, 
                   SmallVectorImpl<CallOp>& calls){
    auto &entryBlock = launchcell.getBody().front();
    builder.setInsertionPointToStart(&entryBlock);
    for(auto call: calls)
      builder.insert(call);
  }

  // Create PL func.func and pl.launch. Create Callop inside pl.launch
  void PLFuncCreation(OpBuilder builder, FuncOp adfFunc, FuncOp& plFunc,
                      CallOp& callop, LaunchCellOp launchcell){
    SmallVector<CallOp> calls;
    Preprocess(builder, launchcell, calls);
    auto loc = builder.getUnknownLoc();
    SmallVector<Value> liveins;
    auto liveness = Liveness(launchcell);
    for (auto livein: liveness.getLiveIn(&launchcell.getBody().front()))
      if (!launchcell->isProperAncestor(livein.getParentBlock()->getParentOp()))
        liveins.push_back(livein);
    
    //reorder inputs to be correspond with the adfFunc arguments
    SmallVector<Value, 6> inputs;
    for(auto arg : adfFunc.getArguments()){
      auto it = llvm::find(liveins,arg);
      if(it != liveins.end())
        inputs.push_back(arg);
    }
    SmallVector<Attribute, 4> newMetaArray;
    addMetaData(builder, adfFunc, inputs, newMetaArray);
    for(auto livein : liveins){
      auto it = llvm::find(inputs, livein);
      if(it == inputs.end())
        inputs.push_back(livein);
    }

    // Define the dma function with the detected inputs as arguments
    builder.setInsertionPoint(adfFunc);
    auto funcName = adfFunc.getName().str() + "_pl";
    auto funcType = builder.getFunctionType(ValueRange(inputs), TypeRange({}));
    plFunc = builder.create<FuncOp>(builder.getUnknownLoc(),funcName,funcType);
    plFunc->setAttr("adf.pl",builder.getBoolAttr(true));
    if(!newMetaArray.empty()){
      auto arrayAttr = builder.getArrayAttr(newMetaArray);
      plFunc->setAttr("meta_data", arrayAttr);
    }
    auto destBlock = plFunc.addEntryBlock();
    builder.setInsertionPointToEnd(destBlock);
    auto returnOp = builder.create<ReturnOp>(builder.getUnknownLoc());
    
    // Move the operations in the adf.cell.launch before the returnOp
    builder.setInsertionPointToEnd(destBlock);
    auto &entryBlock = launchcell.getBody().front();
    for(auto &op: llvm::make_early_inc_range(entryBlock)){
      if(!dyn_cast<EndLaunchCellOp>(op))
        op.moveBefore(returnOp);
    }

    // Create LaunchPLOp and insert the CallOp
    builder.setInsertionPointAfter(launchcell);
    auto launchPLOp = builder.create<LaunchPLOp>(loc,funcName);
    auto *cellLaunchPLBlock = builder.createBlock(&launchPLOp.getBody());
    builder.setInsertionPointToEnd(cellLaunchPLBlock);
    auto endLaunchPL = builder.create<WaitLaunchPLOp>(loc);
    builder.setInsertionPoint(endLaunchPL);
    callop = builder.create<CallOp>(loc, plFunc, inputs);
    callop->setAttr("adf.pl",builder.getUnitAttr());

    // Update the references in the plFunc after move
    for (unsigned i = 0, num_arg = destBlock->getNumArguments(); 
         i < num_arg; ++i) {
      auto sourceArg = inputs[i];
      auto destArg = destBlock->getArgument(i);
      sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
          return plFunc->isProperAncestor(use.getOwner());
      });
    }
    Postprocess(builder, launchcell, calls);
  }
  
  // This is a specific function that perfectize the affine.apply ops between
  // nested for loops. May need to be extend to a general pass.
  void AffineApplyPerfectize(SmallVector<AffineForOp, 6>& band){
    // Move AffineApplyOp to the innerLoop
    auto outerLoop = band[0];
    auto innerLoop = band[band.size()-1];
    auto loopBody = innerLoop.getBody();
    SmallVector<AffineApplyOp, 6> applyOpsBefore;
    outerLoop.walk([&](AffineApplyOp op){
      applyOpsBefore.push_back(op);
    });
    std::reverse(applyOpsBefore.begin(), applyOpsBefore.end());
    for (auto applyOp :  applyOpsBefore)
      applyOp->moveBefore(&loopBody->front());
  }

  bool loopNormalize(AffineForOp plForOp, SmallVector<AffineForOp, 6>& band){
    // Get point loops in band
    getNestedLoopBand(plForOp.getRegion(),band);

    // Normalize point loops
    for (auto forOp : band){
      if(failed(normalizeAffineFor(forOp)))
        return false;
    }
    AffineApplyPerfectize(band);
    return true;
  }

  // This is a helper function that resolves the offset defined recursively by
  // nested AffineApplyOps 0) val: should be the offset of IOPush/IOPop
  // 1) operands:stores all the operands related to val & not defined by Applyop
  // 2) applyops: stores all the applyops related to val
  void resolveOffset(Value val, 
                     SmallVector<Value, 4>& operands,
                     SmallVector<AffineApplyOp, 4>& applyops){
    auto definedOp = val.getDefiningOp();
    if (!definedOp){
      operands.push_back(val);
      return;
    }else if (auto applyop = dyn_cast<AffineApplyOp>(definedOp)){
      applyops.push_back(applyop);
      for (auto operand : applyop.getOperands())
        operands.push_back(operand);
        // resolveOffset(operand, operands, applyops);
    }else{
      operands.push_back(val);
      return;
    }
  }

  // Allocate L2 memory and add data movement involving L2 mem(PL buffer)
  // including load/store data from/to L3 mem (external)
  // send/receive data to/from L1 mem (AIE local)
  WalkResult IOProcesses(OpBuilder builder, FuncOp plFunc, Operation* op, 
                         SmallVector<AffineForOp, 6> band, 
                         unsigned& loadIdx, unsigned& storeIdx, 
                         unsigned& sendIdx, unsigned& receiveIdx, 
                         SmallVector<std::pair<Value, unsigned>, 4>& loadSrcs,
                         SmallVector<std::pair<Value, unsigned>, 4>& storeDsts,
                         bool iopush){
    auto loc = builder.getUnknownLoc();
    IOPushOp iopushOp;
    IOPopOp iopopOp;
    Value src, dst;
    SmallVector<Value> offsets;
    SmallVector<Value> sizes;
    SmallVector<Value> strides;
    MemRefType type;
    if(iopush){
      iopushOp = dyn_cast<IOPushOp>(op);
      src = iopushOp.getSrc();
      type = dyn_cast<MemRefType>(src.getType());
      dst = iopushOp.getDst();
      offsets = iopushOp.getSrcOffsets();
      sizes = iopushOp.getSrcSizes();
      strides = iopushOp.getSrcStrides();
    }else{
      iopopOp = dyn_cast<IOPopOp>(op);
      src = iopopOp.getSrc();
      dst = iopopOp.getDst();
      type = dyn_cast<MemRefType>(dst.getType());
      offsets = iopopOp.getDstOffsets();
      sizes = iopopOp.getDstSizes();
      strides = iopopOp.getDstStrides();
    }

    // Get the buffer implementation selection: 0:BRAM 1:URAM
    SmallVector<std::pair<Value, unsigned>, 4> argIndeices; //Arg, sel
    for(auto arg: plFunc.getArguments()){
      if(auto memref = dyn_cast<MemRefType>(arg.getType())){
        auto memSpace = memref.getMemorySpace();
        if(memSpace){
          if(auto memIntAttr = dyn_cast<IntegerAttr>(memSpace)){
            auto memSpaceVal = memIntAttr.getInt();
            if(memSpaceVal == (int)MemorySpace::L3){
              argIndeices.push_back(std::pair(arg, 0));
            }
          }
        }else{
          argIndeices.push_back(std::pair(arg, 0));
        }
      }
    }
    for (unsigned i = 0; i < std::min(argIndeices.size(),BuffSels.size()); ++i)
        argIndeices[i].second = BuffSels[i];

    //////////////////////////TODO////////////////////////
    /*
    Need to handle more general cases of the offest in IOPushOp/IOPopOp
    Now assumes this is a rectangular tiling. 
    the size of local buffer = point loop bounds * size of IOPush/IOPop src
    the offset of the local buffer = point loop variable * size of ~ src
    the stride of the local buffer = 1 
    */
    //////////////////////////////////////////////////////
    auto outerloop = band[0];
    SmallVector<int64_t, 4> sizesInt;
    unsigned rank = offsets.size();
    SmallVector<int64_t, 4> bufSizes;
    SmallVector<unsigned, 4> loopIndices;
    SmallVector<AffineApplyOp, 4> applyops;
    // Get the buffer size of each dim
    unsigned dim = 0;
    for (auto offset: offsets){
      SmallVector<Value, 4> operands;
      SmallVector<AffineApplyOp, 4> localApplyops;
      resolveOffset(offset,operands,applyops);
      for (auto operand : operands){
        // Get the trip count of the corresponding point loop
        auto loop = getForInductionVarOwner(operand);
        if(!loop)
          continue;
        auto it = llvm::find(band, loop);
        if (it != band.end()) {
          unsigned index = std::distance(band.begin(), it);
          loopIndices.push_back(index);
          SmallVector<Value, 4> foroperands;
          AffineMap map;
          getTripCountMapAndOperands(loop, &map, &foroperands);
          auto tripCount = map.getSingleConstantResult();
          if (!tripCount){
            llvm::errs() << "Involve loops with non-consant trip count!\n";
            return WalkResult::interrupt();
          }
          auto size = sizes[dim];
          auto constantOp = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
          if(!constantOp)
            return WalkResult::interrupt();
          auto intAttr = dyn_cast<IntegerAttr>(constantOp.getValue());
          auto sizeInt = intAttr.getInt();
          sizesInt.push_back(sizeInt);
          bufSizes.push_back(tripCount*sizeInt);
          break;
        }
      }
      dim++;
    }

    // Allocate L2 buffer before the outer point loop
    builder.setInsertionPointToStart(&plFunc.getBody().front());
    auto allocOp 
         = builder.create<AllocOp>(loc, MemRefType::get(bufSizes,
                                   type.getElementType(), AffineMap(),
                                   (int)MemorySpace::L2));
    if(iopush){
      auto it = llvm::find_if(argIndeices, 
        [&](const std::pair<Value, unsigned>&p){
        return p.first == src;
      });
      unsigned sel;
      std::string bufferType;
      if(it!=argIndeices.end())
        sel = it->second;
      else
        sel = 0;
      if(sel==0)
        bufferType = "uram_t2p";
      else
        bufferType = "bram_s2p";
      allocOp->setAttr("buffer_type", builder.getStringAttr(bufferType));
    }else{
      auto it = llvm::find_if(argIndeices, 
        [&](const std::pair<Value, unsigned>&p){
        return p.first == dst;
      });
      unsigned sel;
      std::string bufferType;
      if(it!=argIndeices.end())
        sel = it->second;
      else
        sel = 0;
      if(sel==0)
        bufferType = "uram_t2p";
      else
        bufferType = "bram_s2p";
      allocOp->setAttr("buffer_type", builder.getStringAttr(bufferType));
      allocOp->setAttr("init", builder.getUnitAttr());
    }
    // Create static size and strides for dma & IOPush/IOPop
    auto indexType = builder.getIndexType();
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    auto oneValue = builder.create<arith::ConstantOp>(loc,indexType,oneAttr);
    builder.setInsertionPointAfter(oneValue);
    SmallVector<Value> localSizes;
    SmallVector<Value> localStrides;
    for(unsigned i=0; i< rank; i++){
      auto sizeAttr = builder.getIntegerAttr(indexType, sizesInt[i]);
      auto sizeValue 
           = builder.create<arith::ConstantOp>(loc, indexType, sizeAttr);
      builder.setInsertionPointAfter(sizeValue);
      localSizes.push_back(sizeValue);
      localStrides.push_back(oneValue);
    }

    // Load data from external mem to L2 buffer
    // Create loops for DMA Ops
    SmallVector<AffineForOp, 4> newDMALoops;
    if (iopush)
      builder.setInsertionPoint(outerloop);
    else
      builder.setInsertionPointAfter(outerloop);
    // loopIndices is organized in a column-major, here change it to row-major
    auto orderedIndices = loopIndices;
    for (auto loopIndex : orderedIndices){
      auto loop = band[loopIndex];
      auto newDMAForOp
           = builder.create<AffineForOp>(loc,
                                         loop.getLowerBoundOperands(),
                                         loop.getLowerBoundMap(),
                                         loop.getUpperBoundOperands(),
                                         loop.getUpperBoundMap());
      newDMALoops.push_back(newDMAForOp);
      builder.setInsertionPointToStart(newDMAForOp.getBody());
    }
    // Create loops for IOPush/IOPop Ops
    SmallVector<AffineForOp, 4> newIOLoops;
    if (iopush)
      builder.setInsertionPoint(outerloop);
    else
      builder.setInsertionPointAfter(outerloop);
    for (auto loop : band){
      auto newIOForOp 
           = builder.create<AffineForOp>(loc,
                                         loop.getLowerBoundOperands(),
                                         loop.getLowerBoundMap(),
                                         loop.getUpperBoundOperands(),
                                         loop.getUpperBoundMap());
      newIOLoops.push_back(newIOForOp);
      builder.setInsertionPointToStart(newIOForOp.getBody());
    }
    // Anotate the outer new point loops with name and index
    auto newDMAOuterloop = newDMALoops[0];
    auto newIOOuterloop = newIOLoops[0];
    auto sendAttr = builder.getIntegerAttr(indexType, sendIdx);
    auto receiveAttr = builder.getIntegerAttr(indexType, receiveIdx);
    if(iopush){
      // Check if the external memory has been read, if so then find the loadIdx
      // If not use the current loadIdx and increase it
      auto it 
          = llvm::find_if(loadSrcs, [&](const std::pair<Value, unsigned> &pair){
        return pair.first == src;
      });
      unsigned index;
      if (it != loadSrcs.end()) {
        index = it->second;
      }else{
        index = loadIdx++;
        std::pair newPair(src, index);
        loadSrcs.push_back(newPair);
      }
      auto loadAttr = builder.getIntegerAttr(indexType, index);
      newDMAOuterloop->setAttr("load", loadAttr);
      newDMAOuterloop->setAttr("send", sendAttr);
      newIOOuterloop->setAttr("send", sendAttr);
      sendIdx++;
    }else{
      // Check if the external memory has been written, if so then find the 
      // storeIdx, if not use the current storeIdx and increase it
      auto it 
        = llvm::find_if(storeDsts, [&](const std::pair<Value, unsigned> &pair){
        return pair.first == dst;
      });
      unsigned index;
      if (it != storeDsts.end()) {
        index = it->second;
      }else{
        index = storeIdx++;
        std::pair newPair(dst, index);
        storeDsts.push_back(newPair);
      }
      auto storeAttr = builder.getIntegerAttr(indexType, index);
      newDMAOuterloop->setAttr("store", storeAttr);
      newDMAOuterloop->setAttr("receive", receiveAttr);
      newIOOuterloop->setAttr("receive", receiveAttr);
      receiveIdx++;
    }
    // Create affine ApplyOps inside the innermost new loop
    auto newInnerDMALoop = newDMALoops[newDMALoops.size()-1];
    auto newInnerIOLoop = newIOLoops[newIOLoops.size()-1];
    auto newInnerDMAYiled = newInnerDMALoop.getBody()->getTerminator();
    auto newInnerIOYiled = newInnerIOLoop.getBody()->getTerminator();
    std::reverse(applyops.begin(), applyops.end());
    SmallVector<AffineApplyOp, 4> newApplyops;
    SmallVector<Value, 4> nestedOperands;
    SmallVector<unsigned, 4> ApplyOpIndex;
    for (auto applyop : applyops){
      builder.setInsertionPoint(newInnerDMAYiled);
      auto *clonedOp = applyop->clone();
      builder.insert(clonedOp);
      auto newApplyop = dyn_cast<AffineApplyOp>(clonedOp);
      newApplyops.push_back(newApplyop);
      // Get operands that defined by another AffineApplyOp
      for (auto operand : applyop.getOperands()){
        auto definedOp = operand.getDefiningOp();
        if(!definedOp)
          continue;
        if (auto nestapplyop = dyn_cast<AffineApplyOp>(definedOp)){
          if (llvm::find(nestedOperands, operand) == nestedOperands.end()){
            nestedOperands.push_back(operand);
            auto it = llvm::find(applyops, nestapplyop);
            if (it != applyops.end()) {
              unsigned index = std::distance(applyops.begin(), it);
              ApplyOpIndex.push_back(index);
            }
          }
        }
      }
    }
    // Create local buffer offset for dma & IOPush/IOPop
    SmallVector<Value, 4> localOffsets;
    SmallVector<Value, 4> IOOffsets;
    for (unsigned i = 0; i < rank; i++){
      auto sizeInt = sizesInt[i];
      auto d0 = builder.getAffineDimExpr(0);
      auto map = AffineMap::get(1, 0, d0 * sizeInt, builder.getContext());
      // Add ApplyOp for dma
      auto loopIndex = orderedIndices[i];
      auto loop = band[loopIndex];
      auto var = loop.getInductionVar();
      builder.setInsertionPoint(newInnerDMAYiled);
      auto newApplyopDMA = builder.create<AffineApplyOp>(loc, map, var);
      localOffsets.push_back(newApplyopDMA);
      // Add ApplyOp for IOPush/IOPop
      loopIndex = loopIndices[i];
      loop = band[loopIndex];
      var = loop.getInductionVar();
      builder.setInsertionPoint(newInnerIOYiled);
      auto newApplyopIO = builder.create<AffineApplyOp>(loc, map, var);
      IOOffsets.push_back(newApplyopIO);
    }
    if (iopush){
      // Create dma op to load data from external mem to L2 buffer
      // Replace IOPush: Send data from L2 buffer to L1 buffer
      builder.setInsertionPoint(newInnerDMAYiled);
      auto dmaOp = builder.create<DmaOp>(loc, src, offsets, sizes, strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        allocOp, localOffsets, localSizes, localStrides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      auto attr = iopushOp->getAttr("type");
      dmaOp->setAttr("type", attr);
      builder.setInsertionPoint(newInnerIOYiled);
      auto pushOp = builder.create<IOPushOp>(loc, allocOp, IOOffsets, 
                                             localSizes, localStrides, dst);
      pushOp->setAttr("type", attr);
    }else{
      // Create dma op to store data from L2 buffer to external mem
      // Replace IOPop: Receive data from L1 buffer to L2 buffer
      builder.setInsertionPoint(newInnerDMAYiled);
      auto dmaOp = builder.create<DmaOp>(loc,allocOp, localOffsets, localSizes,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(), 
                        localStrides, dst, offsets, sizes, strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      auto attr = iopopOp->getAttr("type");
      dmaOp->setAttr("type", attr);
      builder.setInsertionPoint(newInnerIOYiled);
      auto popOp = builder.create<IOPopOp>(loc, src, allocOp, 
                                           IOOffsets, localSizes, localStrides);
      popOp->setAttr("type", attr);
      // check if there is output buffer reuse and set an Attr
      if (loopIndices.size()!=band.size())
        popOp->setAttr("reduction", builder.getUnitAttr());
    }

    // Update the loop variable used in AffineApply in the newInnerDMALoop
    auto numVi = newDMALoops.size();
    for (unsigned i = 0; i < numVi; ++i) {
      auto oldloopIndex = orderedIndices[i];
      auto oldvi = band[oldloopIndex].getInductionVar();
      auto newvi = newDMALoops[i].getInductionVar();
      oldvi.replaceUsesWithIf(newvi,[&](OpOperand &use){
          return newInnerDMALoop->isProperAncestor(use.getOwner());
      });
    }

    // Update the loop variable used in AffineApply in the newInnerIOLoop
    numVi = newIOLoops.size();
    for (unsigned i = 0; i < numVi; ++i) {
      auto oldvi = band[i].getInductionVar();
      auto newvi = newIOLoops[i].getInductionVar();
      oldvi.replaceUsesWithIf(newvi,[&](OpOperand &use){
          return newInnerIOLoop->isProperAncestor(use.getOwner());
      });
    }

    // Update the Operands defined by AffineApply in the newInnerDMALoop
    for (unsigned i = 0; i < nestedOperands.size(); i++) {
      auto oldNestedOperand = nestedOperands[i];
      auto newNestedOperand = newApplyops[ApplyOpIndex[i]];
      oldNestedOperand.replaceUsesWithIf(newNestedOperand,[&](OpOperand &use){
          return newInnerDMALoop->isProperAncestor(use.getOwner());
      });
    }

    // Update the offsets of dma in the newInnerDMALoop
    for (unsigned i = 0; i < rank; i++) {
      auto oldOffset = offsets[i];
      auto definedOp = oldOffset.getDefiningOp();
      if(!definedOp || dyn_cast<arith::ConstantOp>(definedOp))
        continue;
      auto applyop = dyn_cast<AffineApplyOp>(definedOp);
      auto it = llvm::find(applyops, applyop);
      if (it == applyops.end()){
        llvm::errs() << "IOpushOp/IOpopOp involves offset not"
                     << "defined by AffineApplyOp & ConstantOp\n";
        return WalkResult::interrupt();
      }
      unsigned index = std::distance(applyops.begin(), it);
      auto newOffset = newApplyops[index];
      oldOffset.replaceUsesWithIf(newOffset,[&](OpOperand &use){
          return newInnerDMALoop->isProperAncestor(use.getOwner());
      });
    }
    return WalkResult::advance();
  }

  // Tranverse the IOPushOps/IOPopOps and allocate L2 buffers
  bool AllocL2Buffer(OpBuilder builder, FuncOp plFunc, AffineForOp plForOp,
                     SmallVector<AffineForOp, 6>& band){
    unsigned loadIdx = 0;
    unsigned storeIdx = 0;
    unsigned sendIdx = 0;
    unsigned receiveIdx = 0;
    SmallVector<std::pair<Value, unsigned>, 4> loadSrcs;
    SmallVector<std::pair<Value, unsigned>, 4> storeDsts;
    auto flag = plForOp.walk([&](Operation* op){
      WalkResult result;
      if(dyn_cast<IOPushOp>(op))
        result = IOProcesses(builder, plFunc, op, band, loadIdx, storeIdx,
                             sendIdx, receiveIdx, loadSrcs, storeDsts, true);
      else if(dyn_cast<IOPopOp>(op))
        result = IOProcesses(builder, plFunc, op, band, loadIdx, storeIdx,
                             sendIdx, receiveIdx, loadSrcs, storeDsts, false);
      else
        return WalkResult::advance();
      return result;
    });
    if (flag == WalkResult::interrupt()) 
      return false;

    // After Processes IOPush/IOPop in the outerloop, safe to erase outerLoop
    auto outerLoop = band[0];
    outerLoop.erase();
    return true;
  }

  // Convert adf.io.push/pop that moves data between memrefs and ios to 
  // affine load&store
  WalkResult ConvertIOToAffine(OpBuilder builder, Operation* op,  bool iopush){
    auto loc = builder.getUnknownLoc();
    IOPushOp iopushOp;
    IOPopOp iopopOp;
    Value src, dst;
    SmallVector<Value> offsets;
    SmallVector<Value> sizes;
    MemRefType type;
    if(iopush){
      iopushOp = dyn_cast<IOPushOp>(op);
      src = iopushOp.getSrc();
      type = dyn_cast<MemRefType>(src.getType());
      dst = iopushOp.getDst();
      offsets = iopushOp.getSrcOffsets();
      sizes = iopushOp.getSrcSizes();
      builder.setInsertionPoint(iopushOp);
    }else{
      iopopOp = dyn_cast<IOPopOp>(op);
      src = iopopOp.getSrc();
      dst = iopopOp.getDst();
      type = dyn_cast<MemRefType>(dst.getType());
      offsets = iopopOp.getDstOffsets();
      sizes = iopopOp.getDstSizes();
      builder.setInsertionPoint(iopopOp);
    } // Create for loops for IOPush/Pop Ops
    auto elementType = type.getElementType();
    auto width = elementType.getIntOrFloatBitWidth();
    SmallVector<AffineForOp, 4> newIOLoops;
    auto rank = offsets.size();
    auto idxType = builder.getIndexType();
    auto oneAttr = builder.getIntegerAttr(idxType, 1);
    for(unsigned i = 0; i < rank; i++){
      auto size = sizes[i];
      auto constantSize = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
      if(!constantSize)
        return WalkResult::interrupt();
      auto sizeAttr = dyn_cast<IntegerAttr>(constantSize.getValue());
      auto sizeInt = sizeAttr.getInt();
      auto newIOForOp 
           = builder.create<AffineForOp>(loc, 0, sizeInt, 1);
      newIOLoops.push_back(newIOForOp);
      builder.setInsertionPointToStart(newIOForOp.getBody());
    }// Get the access operands of affine load/store
    auto newInnerIOLoop = newIOLoops[newIOLoops.size()-1];
    newInnerIOLoop->setAttr("pipeline_ii", oneAttr);
    auto newInnerIOYiled = newInnerIOLoop.getBody()->getTerminator();
    auto d0 = builder.getAffineDimExpr(0);
    auto d1 = builder.getAffineDimExpr(1);
    auto map = AffineMap::get(2, 0, d0 + d1, builder.getContext());
    SmallVector<Value> newApplyopIOs;
    for(unsigned i = 0; i < rank; i++){
      SmallVector<Value, 2> applyOperands;
      auto newIOLoop = newIOLoops[i];
      auto var = newIOLoop.getInductionVar();
      auto offset = offsets[i];
      applyOperands.push_back(var);
      applyOperands.push_back(offset);
      builder.setInsertionPoint(newInnerIOYiled);
      auto newApplyopIO=builder.create<AffineApplyOp>(loc, map, applyOperands);
      newApplyopIOs.push_back(newApplyopIO);
    } // Replace IOPush/Pop Ops with affine.load and affine.store
    if(iopush){
      auto loadOp = builder.create<AffineLoadOp>(loc, src, newApplyopIOs);
      builder.create<IOWriteOp>(loc, loadOp, dst);
    }else{
      auto result = builder.create<IOReadOp>(loc, elementType, src);
      if(iopopOp->hasAttr("reduction")){
        auto loadOp = builder.create<AffineLoadOp>(loc, dst, newApplyopIOs);
        auto typeAttr = dyn_cast<TypeAttr>(iopopOp->getAttr("type"));
        auto originType = typeAttr.getValue();
        auto originWidth = originType.getIntOrFloatBitWidth();
        auto newType = builder.getIntegerType(originWidth);
        auto splitNum = (unsigned)(width/originWidth);
        if(splitNum==1){
          Value addOp;
          if (isa<FloatType>(elementType))
            addOp = builder.create<arith::AddFOp>(loc, loadOp, result);
          else
            addOp = builder.create<arith::AddIOp>(loc, loadOp, result);
          builder.create<AffineStoreOp>(loc, addOp, dst, newApplyopIOs);
        }else{
          auto castL = builder.create<IntToAPInt>(loc, elementType, result);
          auto castR = builder.create<IntToAPInt>(loc, elementType, loadOp);
          auto zeroAttr = builder.getIntegerAttr(elementType, 0);
          auto zeroVal
               = builder.create<arith::ConstantOp>(loc, elementType, zeroAttr);
          auto temp = builder.create<IntToAPInt>(loc, elementType, zeroVal);
          for (unsigned i = 0; i < splitNum; i++){
            auto hiAttr = builder.getIntegerAttr(idxType,originWidth*(i+1)-1);
            auto hiVal= builder.create<arith::ConstantOp>(loc,idxType,hiAttr);
            auto loAttr = builder.getIntegerAttr(idxType,originWidth*i);
            auto loVal= builder.create<arith::ConstantOp>(loc,idxType,loAttr);
            auto sliceL = builder.create<GetIntSliceOp>(loc, newType, castL,
                                                        hiVal, loVal);
            auto sliceR = builder.create<GetIntSliceOp>(loc, newType, castR,
                                                        hiVal, loVal);
            if(auto floatType = dyn_cast<FloatType>(originType)){                                       
              auto castlhs = builder.create<BitcastOp>(loc, floatType, sliceL);                                            
              auto castrhs = builder.create<BitcastOp>(loc, floatType, sliceR);
              auto addOp = builder.create<arith::AddFOp>(loc, castlhs, castrhs);
              auto castout = builder.create<BitcastOp>(loc, newType, addOp);
              builder.create<SetIntSliceOp>(loc, temp, hiVal, loVal, castout);
            }else if(auto intType = dyn_cast<IntegerType>(originType)){
              auto addOp = builder.create<arith::AddIOp>(loc, sliceL, sliceR);
              builder.create<SetIntSliceOp>(loc, temp, hiVal, loVal, addOp);
            }else{
              llvm::errs() << "Find IOPop marked by non-float/int type\n";
              return WalkResult::interrupt();
            }
          }
          auto castO = builder.create<APIntToInt>(loc, elementType, temp);
          builder.create<AffineStoreOp>(loc, castO, dst, newApplyopIOs);
        }
      }
      else{
        builder.create<AffineStoreOp>(loc, result, dst, newApplyopIOs);
      }
    }
    return WalkResult::advance();
  }

  // Convert adf.dma that moves data between two memrefs to affine load&store
  WalkResult ConvertDMAToAffine(OpBuilder builder, FuncOp plFunc, DmaOp dmaOp,
                                SmallVector<unsigned, 4>& argIdxs,
                                SmallVector<Attribute, 4>& argAttrs){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
    auto typeAttr = dmaOp->getAttr("type");
    auto src = dmaOp.getSrc();
    auto srcType = dyn_cast<MemRefType>(src.getType());
    auto dst = dmaOp.getDst();
    auto dstType = dyn_cast<MemRefType>(dst.getType());
    auto indexType = builder.getIndexType();
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    SmallVector<Value> L2Sizes;
    SmallVector<Value> L2Offsets;
    SmallVector<Value> L3Offsets;
    SmallVector<Value> L3Strides;
    bool dmaLoad;
    if (srcType.getMemorySpaceAsInt() == (int)MemorySpace::L2){
      L2Sizes   = dmaOp.getSrcSizes();
      L2Offsets = dmaOp.getSrcOffsets();
      L3Offsets = dmaOp.getDstOffsets();
      L3Strides = dmaOp.getDstStrides();
      dmaLoad = false;
    }else if(dstType.getMemorySpaceAsInt() == (int)MemorySpace::L2){
      L2Sizes   = dmaOp.getDstSizes();
      L2Offsets = dmaOp.getDstOffsets();
      L3Offsets = dmaOp.getSrcOffsets();
      L3Strides = dmaOp.getSrcStrides();
      dmaLoad = true;
    }else{
      return WalkResult::interrupt();
    }
    // Create for loops for DMA Ops
    builder.setInsertionPoint(dmaOp);
    SmallVector<AffineForOp, 4> newDMALoops;
    auto rank = L2Sizes.size();
    for(unsigned i = 0; i < rank; i++){
      Value size = L2Sizes[i];
      auto constantSize = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
      if(!constantSize)
        return WalkResult::interrupt();
      auto sizeAttr = dyn_cast<IntegerAttr>(constantSize.getValue());
      auto sizeInt = sizeAttr.getInt();
      auto newDMAForOp 
           = builder.create<AffineForOp>(loc, 0, sizeInt, 1);
      newDMALoops.push_back(newDMAForOp);
      builder.setInsertionPointToStart(newDMAForOp.getBody());
    }
    auto newInnerDMALoop = newDMALoops[newDMALoops.size()-1];
    newInnerDMALoop->setAttr("pipeline_ii", oneAttr);
    auto newInnerDMAYiled = newInnerDMALoop.getBody()->getTerminator();
    // Create mem access for L2 buffer
    SmallVector<Value> newApplyopL2DMAs;
    auto d0 = builder.getAffineDimExpr(0);
    auto d1 = builder.getAffineDimExpr(1);
    auto map = AffineMap::get(2, 0, d0 + d1, context);
    for(unsigned i = 0; i < rank; i++){
      SmallVector<Value, 2> applyOperands;
      auto newIOLoop = newDMALoops[i];
      auto var = newIOLoop.getInductionVar();
      auto offset = L2Offsets[i];
      applyOperands.push_back(var);
      applyOperands.push_back(offset);
      builder.setInsertionPoint(newInnerDMAYiled);
      auto newApplyopL2DMA 
           = builder.create<AffineApplyOp>(loc, map, applyOperands);
      newApplyopL2DMAs.push_back(newApplyopL2DMA);
    }
    // Create mem access for L3 buffer
    SmallVector<Value> newApplyopL3DMAs;
    for(unsigned i = 0; i < rank; i++){
      SmallVector<Value, 2> applyOperands;
      auto newIOLoop = newDMALoops[i];
      auto stride = L3Strides[i];
      auto constantStride = dyn_cast<arith::ConstantOp>(stride.getDefiningOp());
      if(!constantStride)
        return WalkResult::interrupt();
      auto strideAttr = dyn_cast<IntegerAttr>(constantStride.getValue());
      auto StrideInt = strideAttr.getInt();
      auto mapNew = AffineMap::get(2, 0, d0 * StrideInt + d1, context);
      auto var = newIOLoop.getInductionVar();
      auto offset = L3Offsets[i];
      applyOperands.push_back(var);
      applyOperands.push_back(offset);
      builder.setInsertionPoint(newInnerDMAYiled);
      auto newApplyopL3DMA 
           = builder.create<AffineApplyOp>(loc, mapNew, applyOperands);
      newApplyopL3DMAs.push_back(newApplyopL3DMA);
    }
    if(dmaLoad){
      auto loadOp = builder.create<AffineLoadOp>(loc, src, newApplyopL3DMAs);
      builder.create<AffineStoreOp>(loc, loadOp, dst, newApplyopL2DMAs);
      // Record the original data type as the attributes in the plFunc
      for(unsigned idx=0; idx < plFunc.getNumArguments(); idx++){
        auto arg = plFunc.getArgument(idx);
        if(arg != src)
          continue;
        auto it = llvm::find(argIdxs, idx);
        if(it != argIdxs.end()){
          unsigned dis = std::distance(argIdxs.begin(),it);
          auto preType = argAttrs[dis];
          if(preType != typeAttr)
            return WalkResult::interrupt();
        }else{
          argIdxs.push_back(idx);
          argAttrs.push_back(typeAttr);
        }
        break;
      }
    }else{
      auto loadOp = builder.create<AffineLoadOp>(loc, src, newApplyopL2DMAs);
      builder.create<AffineStoreOp>(loc, loadOp, dst, newApplyopL3DMAs); 
      // Record the original data type as the attributes in the plFunc
      for(unsigned idx=0; idx < plFunc.getNumArguments(); idx++){
        auto arg = plFunc.getArgument(idx);
        if(arg != dst)
          continue;
        auto it = llvm::find(argIdxs, idx);
        if(it != argIdxs.end()){
          unsigned dis = std::distance(argIdxs.begin(),it);
          auto preType = argAttrs[dis];
          if(preType != typeAttr)
            return WalkResult::interrupt();
        }else{
          argIdxs.push_back(idx);
          argAttrs.push_back(typeAttr);
        }
        break;
      }
    }
    return WalkResult::advance();
  }

  // Tranverse the IOPushOps/IOPopOps and convert them to affine load/store
  bool ConvertIODMAToAffine(OpBuilder builder, FuncOp plFunc, 
                            AffineForOp plForOp){
    SmallVector<unsigned, 4> argIdxs;
    SmallVector<Attribute, 4> argAttrs;
    auto flag = plForOp.walk([&](Operation* op){
      WalkResult result;
      if(dyn_cast<IOPushOp>(op))
        result = ConvertIOToAffine(builder, op, true);
      else if(dyn_cast<IOPopOp>(op))
        result = ConvertIOToAffine(builder, op, false);
      else if(auto dmaOp = dyn_cast<DmaOp>(op))
        result = ConvertDMAToAffine(builder, plFunc, dmaOp, argIdxs, argAttrs);
      else
        return WalkResult::advance();
      op->erase();
      return result;
    });
    if (flag == WalkResult::interrupt()) 
      return false;
    SmallVector<Attribute, 4> idxAttrs;
    for (int idx : argIdxs) 
      idxAttrs.push_back(builder.getI32IntegerAttr(idx));
    auto arrayAttr = builder.getArrayAttr(idxAttrs);
    plFunc->setAttr("mem_idx", arrayAttr);
    auto arrayTypeAttr = builder.getArrayAttr(argAttrs);
    plFunc->setAttr("mem_type", arrayTypeAttr);
    return true;
  }

  // Change direct L2 buffer access to read from/write to a stream
  void L2MemProcess(OpBuilder builder, FuncOp plFunc, AffineStoreOp storeOp,
                       AffineLoadOp loadOp, SmallVector<AffineForOp, 6> band, 
                       bool load){
    auto loc = builder.getUnknownLoc();
    auto outerLoop = band[0];
    auto innerLoop = band[band.size()-1];
    SmallVector<OpFoldResult> sizes;
    sizes.push_back(builder.getIndexAttr(1));
    auto streamAttr = builder.getStringAttr("stream");
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    Value memref, val;
    SmallVector<Value> indices;
    if(load){
      memref = storeOp.getMemRef();
      val = storeOp.getValueToStore();
      indices = storeOp.getIndices();
    }else{
      memref = loadOp.getMemRef();
      val = loadOp.getResult();
      indices = loadOp.getIndices();
    }
    auto type = dyn_cast<MemRefType>(memref.getType());
    auto elementType = type.getElementType();
    if (type.getMemorySpaceAsInt() != (int)MemorySpace::L2)
      return;
    // Alloc single-element memref to represent stream FIFO
    builder.setInsertionPointToStart(&plFunc.getBody().front());
    auto zeroValue = builder.create<arith::ConstantOp>(loc, zeroAttr);
    SmallVector<Value> zeroValues(1, zeroValue);
    auto allocOp 
         = builder.create<AllocOp>(loc, sizes, elementType, streamAttr);
    if(load){
      builder.setInsertionPoint(storeOp);
      builder.create<AffineStoreOp>(loc, val, allocOp, zeroValues);
      builder.setInsertionPointAfter(outerLoop);
    }else{
      builder.setInsertionPoint(loadOp);
      auto newLoadOp = builder.create<AffineLoadOp>(loc, allocOp, zeroValues);
      val.replaceUsesWithIf(newLoadOp,[&](OpOperand &use){
          return innerLoop->isProperAncestor(use.getOwner());
      });
      builder.setInsertionPoint(outerLoop);
    }
    // Create newForOps for reading data from single-element memref 
    // and store to L2 buffer. This is to represent FIFO in PL.
    SmallVector<AffineForOp, 4> newForOps;
    for (auto loop: band){
      auto newForOp 
           = builder.create<AffineForOp>(loc,
                                         loop.getLowerBoundOperands(),
                                         loop.getLowerBoundMap(),
                                         loop.getUpperBoundOperands(),
                                         loop.getUpperBoundMap(),
                                         loop.getStepAsInt());
      newForOps.push_back(newForOp);
      builder.setInsertionPointToStart(newForOp.getBody());
    }
    // Get the affine.apply ops used in affine.store/load op
    auto rank = type.getRank();
    SmallVector<AffineApplyOp, 4> applyops;
    for (unsigned i = 0; i < rank; i++){
      SmallVector<Value, 4> operands;
      auto index = indices[i];
      resolveOffset(index,operands,applyops);
    }
    // Clone and move the used affine apply ops inside newForOps
    auto outerNewLoop = newForOps[0];
    auto innerNewLoop = newForOps[newForOps.size()-1];
    innerNewLoop->setAttr("pipeline_ii", oneAttr);
    auto innerNewYiled = innerNewLoop.getBody()->getTerminator();
    SmallVector<AffineApplyOp, 4> newApplyops;
    std::reverse(applyops.begin(), applyops.end());
    builder.setInsertionPoint(innerNewYiled);
    for(auto applyop : applyops){
      auto *clonedOp = applyop->clone();
      builder.insert(clonedOp);
      auto newApplyOp = dyn_cast<AffineApplyOp>(clonedOp);
      newApplyops.push_back(newApplyOp);
    }
    // Load data from single-element memref and store to L2 buffer
    if(load){
      auto newLoad = builder.create<AffineLoadOp>(loc, allocOp, zeroValues);
      builder.create<AffineStoreOp>(loc, newLoad, memref, indices);
      storeOp.erase();
      auto Attr = outerLoop->getAttr("send");
      outerNewLoop->setAttr("send", Attr);
      outerLoop->removeAttr("send");
    }else{
      auto newLoad = builder.create<AffineLoadOp>(loc, memref, indices);
      builder.create<AffineStoreOp>(loc, newLoad, allocOp, zeroValues);
      // After data store back to L2, initialize local buffer with zero
      Value value;
      if (isa<IntegerType>(elementType)) {
        auto intAttr = builder.getIntegerAttr(elementType, 0);
        value = builder.create<arith::ConstantOp>(loc, elementType, intAttr);
      }else{
        auto floatAttr = builder.getF32FloatAttr(0.0);
        value = builder.create<arith::ConstantOp>(loc, elementType, floatAttr);
      }
      builder.create<AffineStoreOp>(loc, value, memref, indices);
      loadOp.erase();
      auto Attr = outerLoop->getAttr("receive");
      outerNewLoop->setAttr("receive", Attr);
      outerNewLoop->setAttr("hoist", builder.getUnitAttr());
      outerLoop->removeAttr("receive");
    }
    // Update the loop variables
    auto numVi = newForOps.size();
    for (unsigned i = 0; i < numVi; ++i) {
      auto oldvi = band[i].getInductionVar();
      auto newvi = newForOps[i].getInductionVar();
      oldvi.replaceUsesWithIf(newvi,[&](OpOperand &use){
          return innerNewLoop->isProperAncestor(use.getOwner());
      });
    }
    // Update the AffineApplyOp used in the innerNewLoop
    for (unsigned i = 0; i < applyops.size(); i++) {
      auto oldApplyOp = applyops[i].getResult();
      auto newApplyOp = newApplyops[i].getResult();
      oldApplyOp.replaceUsesWithIf(newApplyOp,[&](OpOperand &use){
          return innerNewLoop->isProperAncestor(use.getOwner());
      });
    }
  }

  // Tranverse all the outer point dma loops(involve L3 mem) and change the
  // L2 buffer access with stream access
  void L2MemProcessTop(OpBuilder builder, FuncOp plFunc, AffineForOp plForOp){
    for (AffineForOp forOp : plForOp.getOps<AffineForOp>()) {
      if(!forOp->hasAttr("load") && !forOp->hasAttr("store"))
        continue;
      SmallVector<AffineForOp, 6> band;
      getNestedLoops(band, forOp);
      AffineApplyPerfectize(band);
      auto outerLoop = band[0];
      auto innerLoop = band[band.size()-1];
      AffineStoreOp emptyStoreOp;
      AffineLoadOp emptyLoadOp;
      if(outerLoop->hasAttr("load"))
        for (auto storeOp: 
             llvm::make_early_inc_range(innerLoop.getOps<AffineStoreOp>()))
          L2MemProcess(builder, plFunc, storeOp, emptyLoadOp, band, true);
      else
        for (auto loadOp: 
             llvm::make_early_inc_range(innerLoop.getOps<AffineLoadOp>()))
          L2MemProcess(builder, plFunc, emptyStoreOp, loadOp, band, false);
    }
  }

  // Replace IORead/IOWrite by AffineLoad/AffineStore, update the callee and
  // caller function, create ConnectOp to connect IO with stream
  void ArgUpdate(OpBuilder builder, FuncOp topFunc, 
                 FuncOp adfFunc, FuncOp plFunc, CallOp& caller){
    auto loc = builder.getUnknownLoc();
    SmallVector<OpFoldResult> allocSizes;
    allocSizes.push_back(builder.getIndexAttr(1));
    auto plioAttr = builder.getStringAttr("plio");
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    builder.setInsertionPointToStart(&plFunc.getBody().front());
    auto zeroValue = builder.create<arith::ConstantOp>(loc, zeroAttr);
    SmallVector<Value> zeroValues(1, zeroValue);
    auto inTypes =SmallVector<Type,8>(plFunc.getArgumentTypes().begin(),
                                      plFunc.getArgumentTypes().end());
    auto outTypes = plFunc.getResultTypes();
    unsigned index = 0;
    SmallVector<int64_t, 8> callerIds;
    for (auto argOperand : caller.getArgOperands()) {
      auto defineOp = argOperand.getDefiningOp();
      if(!defineOp || !dyn_cast<CreateGraphIOOp>(defineOp)){
        index++;
        continue;
      }
      callerIds.push_back(index);
      auto graphio = dyn_cast<CreateGraphIOOp>(defineOp);
      auto calleeArg = plFunc.getArgument(index);
      for(auto user : calleeArg.getUsers()){
        builder.setInsertionPointToStart(&adfFunc.getBody().front());
        if(auto ioWrite = dyn_cast<IOWriteOp>(user)){
          auto src = ioWrite.getSrc();
          auto allocOp 
            = builder.create<AllocOp>(loc, allocSizes, src.getType(), plioAttr);
          // Replace the operands in the caller function to the allocOp
          // Change the argument types of callee
          caller.setOperand(index, allocOp);
          inTypes[index] = allocOp.getType();
          calleeArg.setType(allocOp.getType());
          builder.setInsertionPoint(ioWrite);
          builder.create<AffineStoreOp>(loc, src, calleeArg, zeroValues);
          builder.setInsertionPointAfter(graphio);
          auto connect = builder.create<ConnectOp>(loc, allocOp, graphio);
          connect->setAttr("top_config", builder.getUnitAttr());
          ioWrite.erase();
          break;
        }else if(auto ioRead = dyn_cast<IOReadOp>(user)){
          auto dst = ioRead.getResult();
          auto allocOp 
            = builder.create<AllocOp>(loc, allocSizes, dst.getType(), plioAttr);
          caller.setOperand(index, allocOp);
          inTypes[index] = allocOp.getType();
          calleeArg.setType(allocOp.getType());
          builder.setInsertionPoint(ioRead);
          auto load = builder.create<AffineLoadOp>(loc, calleeArg, zeroValues);
          auto result = load.getResult();
          dst.replaceAllUsesWith(result);
          builder.setInsertionPointAfter(graphio);
          auto connect = builder.create<ConnectOp>(loc, graphio, allocOp);
          connect->setAttr("top_config", builder.getUnitAttr());
          ioRead.erase();
          break;
        }
      }
      index++;
    }
    // Update the callee function type.
    plFunc.setType(builder.getFunctionType(inTypes, outTypes));
    // Update the adf.func of the caller with the memref "plio"
    auto adfInTypes =SmallVector<Type,8>(adfFunc.getArgumentTypes().begin(),
                                         adfFunc.getArgumentTypes().end());
    auto topInTypes =SmallVector<Type,8>(topFunc.getArgumentTypes().begin(),
                                         topFunc.getArgumentTypes().end());
    auto adfOutTypes = adfFunc.getResultTypes();
    auto topOutTypes = topFunc.getResultTypes();
    auto& block = adfFunc.getBody().front();
    auto& topBlock = topFunc.getBody().front();
    auto argNum = (unsigned) adfInTypes.size();
    auto topArgNum = (unsigned) topInTypes.size();
    for (auto idx : callerIds) {
      auto operand = caller.getOperand(idx);
      auto newType = operand.getType();
      adfInTypes.push_back(newType);
      block.addArgument(newType, adfFunc.getLoc());
      topInTypes.push_back(newType);
      topBlock.addArgument(newType, topFunc.getLoc());
    }
    // Update the adf.func type.
    adfFunc.setType(builder.getFunctionType(adfInTypes, adfOutTypes));
    topFunc.setType(builder.getFunctionType(topInTypes, topOutTypes));

    // Eliminate the corresponding memref.alloc and replace the use of them
    for (auto idx : callerIds) {
      auto operand = caller.getOperand(idx);
      auto allocOp = operand.getDefiningOp<AllocOp>();
      auto arg = adfFunc.getArgument(argNum++);
      allocOp.replaceAllUsesWith(arg);
      allocOp.erase();
    }

    // update the caller in the topFunc
    auto adfName = adfFunc.getName();
    for (auto call : llvm::make_early_inc_range(topFunc.getOps<CallOp>())) {
      if(call.getCallee() != adfName)
        continue;
      SmallVector<Value, 8> operands;
      for(auto operand: call.getOperands())
        operands.push_back(operand);
      for(auto i=topArgNum; i<topInTypes.size(); i++)
        operands.push_back(topFunc.getArgument(i));
      builder.setInsertionPoint(call);
      builder.create<CallOp>(loc, plFunc, ValueRange{operands});
      call.erase();
    }
    auto topAttr = dyn_cast<StringAttr>(topFunc->getAttr("top_func"));
    if(!topAttr)
      topFunc->setAttr("top_func", plioAttr);
  }

  // This function does the loop permutation for load/store from DDR->L2 mem
  // in order to potential increase the burst length, the loops involved in
  // the access of last dim should be put inside.
  // TODO::This permutation is not safe, since it can not pass 
  //       the interchange verification, need to figure it out why
  bool loopPermutation(AffineForOp plForOp){
    for (AffineForOp forOp : plForOp.getOps<AffineForOp>()) {
      if(!forOp->hasAttr("load") && !forOp->hasAttr("store"))
        continue;
      SmallVector<AffineForOp, 6> originBand;
      getPerfectlyNestedLoops(originBand, forOp);
      auto bandSize = originBand.size();
      auto originInnerLoop = originBand[bandSize-1];
      // Assume there is only memory access from/to L3
      Value memref;
      Operation* defineOp;
      AffineApplyOp applyOp;
      AffineMap map;
      SmallVector<Value> operands;
      for (auto& op: originInnerLoop.getBody()->getOperations()){
        if (auto read = dyn_cast<AffineReadOpInterface>(op)) {
          defineOp = read.getMapOperands().back().getDefiningOp();
          memref = read.getMemRef();
        }else if (auto write = dyn_cast<AffineWriteOpInterface>(op)){
          defineOp = write.getMapOperands().back().getDefiningOp();
          memref = write.getMemRef();
        }else{
          continue;
        }
        if(!defineOp || !dyn_cast<AffineApplyOp>(defineOp))
          return true;
        auto applyOp = dyn_cast<AffineApplyOp>(defineOp);
        auto type = dyn_cast<MemRefType>(memref.getType());
        if(auto memSpace = type.getMemorySpace()){
          auto intSpace = dyn_cast<IntegerAttr>(memSpace);
          if(intSpace && intSpace.getInt()==(int)MemorySpace::L3){
            map = applyOp.getAffineMap();
            operands = applyOp.getOperands();
            break;
          }
        }else{//If no memSpace then default is L3 mem
          map = applyOp.getAffineMap();
          operands = applyOp.getOperands();
          break;
        }
      }
      if(!map)
        return false;
      auto lastExpr = map.getResults().back();
      // flattened form [dims, symbols, locals, constant]
      llvm::SmallVector<int64_t> flattenedExpr;
      if (failed(getFlattenedAffineExpr(lastExpr, map.getNumDims(),
                                        map.getNumSymbols(),
                                        &flattenedExpr)))
        return false;
      auto mapSize = map.getNumDims();
      SmallVector<std::pair<unsigned, int64_t>> outerLoops;
      SmallVector<std::pair<unsigned, int64_t>> innerLoops;
      for (unsigned i = 0; i < mapSize; ++i) {
        auto loop = getForInductionVarOwner(operands[i]);
        if (!loop)
          continue;
        auto it = llvm::find(originBand, loop);
        if(it!=originBand.end()){
          auto coeff = flattenedExpr[i];
          unsigned depth = it - originBand.begin();
          innerLoops.push_back(std::pair(depth, coeff));
        }
      }
      for(unsigned i = 0; i<bandSize; i++){
        auto it 
        = llvm::find_if(innerLoops, [i](const std::pair<unsigned, int64_t> &p) {
          return p.first == i;
        });
        if(it != innerLoops.end())
          continue;
        outerLoops.push_back(std::pair(i, 0));
      }
      // OuterLoops sort depth by ascending order
      // InnerLoops sort coeff by ascending order
      llvm::sort(outerLoops, [](const std::pair<unsigned, int64_t> &a, 
                                const std::pair<unsigned, int64_t> &b){
        return a.first < b.first;
      });
      llvm::sort(innerLoops, [](const std::pair<unsigned, int64_t> &a, 
                                const std::pair<unsigned, int64_t> &b){
        return a.second > b.second;
      });
      // Merge the depth of OuterLoops and InnerLoops
      SmallVector<unsigned, 6> permMap;
      SmallVector<unsigned, 6> orderedDepth;
      for (auto pair : outerLoops)
        orderedDepth.push_back(pair.first);
      for (auto pair : innerLoops)
        orderedDepth.push_back(pair.first);
      for(unsigned i=0; i< bandSize; i++){
        auto newPos = llvm::find(orderedDepth, i) - orderedDepth.begin();
        permMap.push_back(newPos);
      }
      // TODO::This permutation is not safe, since it can not pass 
      //       the interchange verification, need to figure it out why
      //if (isValidLoopInterchangePermutation(originBand, permMap))
      permuteLoops(originBand, permMap);
    }
    return true;
  }

  // Split the loops marked by "load,store,send,receive" and then merge them
  // into the outmost tileBand by identify there attributes
  void PLLoopSplit(OpBuilder builder, FuncOp plFunc, AffineForOp plForOp){
    auto loc = builder.getUnknownLoc();
    SmallVector<AffineForOp, 6> tileBand;
    getNestedLoopBand(plFunc.getRegion(),tileBand);
    auto outerTileBand = tileBand[0];
    // Tranverse the forOps and group then by the attribute 
    llvm::StringMap<SmallVector<unsigned, 4>> groups;
    SmallVector<AffineForOp, 4> forOps;
    unsigned index = 0;
    for (auto forOp: llvm::make_early_inc_range(plForOp.getOps<AffineForOp>())){
      if(auto Attr = forOp->getAttrOfType<IntegerAttr>("load")){
        std::string str = "load" + std::to_string(Attr.getInt());
        StringRef strRef(str);
        groups[strRef].push_back(index++);
        forOps.push_back(forOp);
      }else if(auto Attr = forOp->getAttrOfType<IntegerAttr>("store")){
        std::string str = "store" + std::to_string(Attr.getInt());
        StringRef strRef(str);
        groups[strRef].push_back(index++);
        forOps.push_back(forOp);
      }else if(auto Attr = forOp->getAttrOfType<IntegerAttr>("send")){
        std::string str = "send" + std::to_string(Attr.getInt());
        StringRef strRef(str);
        groups[strRef].push_back(index++);
        forOps.push_back(forOp);
      }else if(auto Attr = forOp->getAttrOfType<IntegerAttr>("receive")){
        std::string str = "receive" + std::to_string(Attr.getInt());
        StringRef strRef(str);
        groups[strRef].push_back(index++);
        forOps.push_back(forOp);
      }
    }
    // Move the forOps with the same attribute to the same tileBand
    for (const auto &group : groups) {
      SmallVector<AffineForOp, 4> newForOps;
      builder.setInsertionPoint(outerTileBand);
      for (auto loop: tileBand){
        auto newForOp 
             = builder.create<AffineForOp>(loc,
                                           loop.getLowerBoundOperands(),
                                           loop.getLowerBoundMap(),
                                           loop.getUpperBoundOperands(),
                                           loop.getUpperBoundMap(),
                                           loop.getStepAsInt());
        newForOps.push_back(newForOp);
        if(loop->hasAttr("Array_Partition"))
          newForOp->setAttr("Array_Partition",builder.getUnitAttr());
        if(loop->hasAttr("reduction"))
          newForOp->setAttr("reduction",builder.getUnitAttr());
        builder.setInsertionPointToStart(newForOp.getBody());
      }
      auto outerNewloop = newForOps[0];
      auto innerNewLoop = newForOps[newForOps.size()-1];
      auto innerNewYiled = innerNewLoop.getBody()->getTerminator();
      unsigned cnt = 0;
      for (unsigned idx : group.second) {
        // Move the forOp to the new loop nests and set new Attrs
        auto forOp = forOps[idx];
        forOp->moveBefore(innerNewYiled);
        auto indexType = builder.getIndexType();
        auto newAttr = builder.getIntegerAttr(indexType, cnt++);
        if(auto Attr = forOp->getAttr("load")){
          outerNewloop->setAttr("load", Attr);
          forOp->removeAttr("load");
          forOp->setAttr("merge", builder.getUnitAttr());
        }else if(auto Attr = forOp->getAttr("store")){
          outerNewloop->setAttr("store", Attr);
          forOp->removeAttr("store");
          forOp->setAttr("merge", builder.getUnitAttr());
          forOp->setAttr("hoist",builder.getUnitAttr());
        }else if(auto Attr = forOp->getAttr("send")){
          outerNewloop->setAttr("send", Attr);
          forOp->removeAttr("send");
          forOp->setAttr("module", newAttr);
        }else if(auto Attr = forOp->getAttr("receive")){
          outerNewloop->setAttr("receive", Attr);
          forOp->removeAttr("receive");
        }
      }
      // Update the loop variables
      auto numVi = newForOps.size();
      for (unsigned i = 0; i < numVi; ++i) {
        auto oldvi = tileBand[i].getInductionVar();
        auto newvi = newForOps[i].getInductionVar();
        oldvi.replaceUsesWithIf(newvi,[&](OpOperand &use){
            return innerNewLoop->isProperAncestor(use.getOwner());
        });
      }
    }
    outerTileBand.erase();
  }

  // Allocate L2 memory & add data movement
  bool PLDataMovement(OpBuilder builder, FuncOp topFunc, FuncOp adfFunc, 
                      FuncOp& plFunc, CallOp& callop){
    AffineForOp plForOp;
    plFunc.walk([&](AffineForOp forOp){
      if(forOp->hasAttr("Array_Partition"))
        plForOp = forOp;
    });
    if(!plForOp){
      llvm::errs() << "Array_Partition loop not found\n";
      return false;
    }
    SmallVector<AffineForOp, 6> band;
    if(!loopNormalize(plForOp, band))
      return false;

    // Simplify the loop structure after loopNormalize.
    // There won't be any nested affine.apply ops
    PassManager pm(plFunc.getContext(), "func.func");
    pm.addPass(createSimplifyAffineStructuresPass());
    (void)pm.run(plFunc);

    if(!AllocL2Buffer(builder, plFunc, plForOp, band)){
      llvm::errs() << "Alloc L2 buffer failed\n";
      return false;
    }
    // Tranverse the IOPushOps/IOPopOps and convert them to affine load/store
    if(!ConvertIODMAToAffine(builder, plFunc, plForOp))
      return false;
    // Replace arguments with PLIOType by memref arguments
    ArgUpdate(builder, topFunc, adfFunc, plFunc, callop);
    // Simplify the loop structure after ConvertToAffine.
    // There won't be any nested affine.apply ops
    pm.addPass(createSimplifyAffineStructuresPass());
    (void)pm.run(plFunc);
    // Permute loops in order to potentially increase the burst length
    if(!loopPermutation(plForOp)){
      llvm::errs() << "Loop permutation failed\n";
      return false;
    }
    // Tranverse all the outer point dma loops(involve L3 mem) and change the
    // L2 buffer access with stream access
    L2MemProcessTop(builder, plFunc, plForOp);

    // Post processes, move each loop marked by "load,store,receive,send" to the
    // outermost temporal tileBand 
    PLLoopSplit(builder, plFunc, plForOp);
    return true;
  }

  bool IOMaterialize (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    FuncOp topFunc;
    if(!topFind(mod, topFunc, "top_func"))
      return true;
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;      
      // Find the LaunchCellOp
      LaunchCellOp launchcell = getFirstOpOfType<LaunchCellOp>(func.getBody());
      if(!launchcell)
        return true;

      // Materialize Push/Pop of PLIO
      auto boolPLIO = func->getAttr("plio");
      FuncOp plFunc;
      CallOp callop;
      if(dyn_cast<BoolAttr>(boolPLIO).getValue()){
        PLFuncCreation(builder, func, plFunc, callop, launchcell);
        if(!PLDataMovement(builder, topFunc, func, plFunc, callop))
          return false;
      }
    }
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPLIOMaterializePass() {
  return std::make_unique<AriesPLIOMaterialize>();
}

std::unique_ptr<Pass> createAriesPLIOMaterializePass(const AriesOptions &opts) {
  return std::make_unique<AriesPLIOMaterialize>(opts);
}


} // namespace aries
} // namespace mlir