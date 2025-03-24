#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
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
#define DEBUG_TYPE "aries-pl-buffer-extract"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::memref;

namespace {

struct AriesPLBufferExtract 
      : public AriesPLBufferExtractBase<AriesPLBufferExtract> {
public:
  AriesPLBufferExtract() = default;
  AriesPLBufferExtract(const AriesOptions &opts) {
    BuffSels=opts.OptBuffSels;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    auto context = mod->getContext();
    PassManager pm(context);
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
    if (!PLBufferExtract(mod))
      signalPassFailure();
  }

private:
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

  // Perform loop normalization and SimplifyAffineStructures
  bool loopNormalize(AffineForOp plForOp, SmallVector<AffineForOp, 6>& band){
    // Normalize point loops
    for (auto forOp : band){
      if(failed(normalizeAffineFor(forOp)))
        return false;
    }
    AffineApplyPerfectize(band);
    return true;
  }

  void getIOInfo(Operation* op, IOPushOp& iopushOp, IOPopOp& iopopOp, 
                 Value& src, Value& dst, 
                 SmallVector<Value>& offsets, SmallVector<Value>& sizes,
                 SmallVector<Value>& strides, SmallVector<Value>& tiles,
                 SmallVector<Value>& dims, SmallVector<Value>& steps,
                 SmallVector<Value>& wraps, MemRefType& type, bool iopush){
    if(iopush){
      iopushOp = dyn_cast<IOPushOp>(op);
      src = iopushOp.getSrc();
      dst = iopushOp.getDst();
      type = dyn_cast<MemRefType>(src.getType());
      offsets = iopushOp.getSrcOffsets();
      sizes = iopushOp.getSrcSizes();
      strides = iopushOp.getSrcStrides();
      tiles   = iopushOp.getSrcTiles();
      dims    = iopushOp.getSrcDims();
      steps   = iopushOp.getSrcSteps();
      wraps   = iopushOp.getSrcWraps();
    }else{
      iopopOp = dyn_cast<IOPopOp>(op);
      src = iopopOp.getSrc();
      dst = iopopOp.getDst();
      type = dyn_cast<MemRefType>(dst.getType());
      offsets = iopopOp.getDstOffsets();
      sizes = iopopOp.getDstSizes();
      strides = iopopOp.getDstStrides();
      tiles   = iopopOp.getDstTiles();
      dims    = iopopOp.getDstDims();
      steps   = iopopOp.getDstSteps();
      wraps   = iopopOp.getDstWraps();
    }
  }


  // Get the buffer implementation selection: 0:BRAM 1:URAM
  void bufAssign(FuncOp plFunc, SmallVector<
                                  std::pair<Value, unsigned>, 4>& argIndeices){
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
    for (unsigned i = 0; i < std::min(argIndeices.size(), BuffSels.size()); ++i)
      argIndeices[i].second = BuffSels[i];
  }

  // Assign the type of L2 buffer
  void setBufferType(OpBuilder builder, Value src, Value dst, 
                     AllocOp allocOp, bool iopush,
                     SmallVector<std::pair<Value, unsigned>, 4> argIndeices){
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
  }

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
    SmallVector<Value> offsets, sizes, strides, tiles, dims, steps, wraps;
    MemRefType type;
    // Get the push and pop slice and traversal info
    getIOInfo(op, iopushOp, iopopOp, src, dst, offsets, sizes, strides, tiles,
              dims, steps, wraps, type, iopush);
    // Collect the buffer assignment selections
    SmallVector<std::pair<Value, unsigned>, 4> argIndeices; //Arg, sel
    bufAssign(plFunc, argIndeices);

    // Create local buffer. Now only support DMA that has static size and stride
    SmallVector<int64_t, 4> sizesInt; 
    for(auto size : sizes){
      auto constantOp = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
      if(!constantOp){
        llvm::errs() << "Involve non-consant size!\n";
        return WalkResult::interrupt();
      }
      auto intAttr = dyn_cast<IntegerAttr>(constantOp.getValue());
      auto sizeInt = intAttr.getInt();
      sizesInt.push_back(sizeInt);
    }

    // Get the buffer size of each dim
    // The size of the L2 buffer = loop tripcount  * L1 size
    auto outerloop = band[0];
    SmallVector<int64_t, 4> bufSizes; // Record the size of the L2 buffer
    // TODO:: Currently DMA only support hyper-recutangular data slicing
    // Now assume each affineApply Op is only constructed by one loop
    SmallVector<unsigned, 4> loopIndices;
    // Record the original applyOps of offset
    SmallVector<AffineApplyOp, 4> applyOps;
    unsigned rank = type.getRank();
    for (unsigned dim=0; dim < rank; dim++){
      auto offset = offsets[dim];
      auto sizeInt = sizesInt[dim];
      auto defineOp = offset.getDefiningOp();
      if(!defineOp){
        llvm::errs() << "Offset not defined by any operantions!\n";
        return WalkResult::interrupt();
      }
      // TODO:: May need to handle ConstantOp
      if(auto applyOp = dyn_cast<AffineApplyOp>(defineOp)){
        applyOps.push_back(applyOp);
        auto operands = applyOp.getOperands();
        // Flag to see if one offset is constructed by multiple loops in band
        bool flag_loop = false;
        for (unsigned i = 0; i < operands.size(); i++){
          auto operand = operands[i];
          auto loop = getForInductionVarOwner(operand);
          if(!loop){
            llvm::errs() << "ApplyOp has non-inductionVar operands!\n";
            return WalkResult::interrupt();
          }
          auto it = llvm::find(band, loop);
          if (it != band.end()) {
            if(flag_loop)
              llvm::errs() << "Found one ApplyOp constructed by > 1 loops\n";
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
            bufSizes.push_back(tripCount*sizeInt);
            flag_loop = true;
          }
        }
      }else{
        llvm::errs() << "Offset defined by unsupported operations\n";
        return WalkResult::interrupt();
      }
    }

    // Allocate L2 buffer before the outer point loop
    builder.setInsertionPoint(outerloop);
    auto allocOp = builder.create<AllocOp>(loc, MemRefType::get(bufSizes,
                                           type.getElementType(), AffineMap(),
                                           (int)MemorySpace::L2));
    // Set the type of L2 buffer to uram or bram
    setBufferType(builder, src, dst, allocOp, iopush, argIndeices);
    
    // Create L2 Stride = 1
    auto indexType = builder.getIndexType();
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    auto oneValue = builder.create<arith::ConstantOp>(loc,indexType,oneAttr);
    SmallVector<Value> L2Strides;
    for(unsigned i=0; i< rank; i++)
      L2Strides.push_back(oneValue);

    // Load data from external mem to L2 buffer
    // Create loops for DMA Ops
    SmallVector<AffineForOp, 4> newDMALoops;
    if(iopush)
      builder.setInsertionPoint(outerloop);
    else
      builder.setInsertionPointAfter(outerloop);

    // DMA Loops are for L3 <-> L2 (PL SRAMs)
    for (auto loopIndex : loopIndices){
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
    auto newOuterDMALoop = newDMALoops[0];
    auto newInnerDMALoop = newDMALoops[newDMALoops.size()-1];
    auto newInnerDMAYiled = newInnerDMALoop.getBody()->getTerminator();
    
    // Send data from L2 memory to PLIO port
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
    auto newOuterIOLoop = newIOLoops[0];
    auto newInnerIOLoop = newIOLoops[newIOLoops.size()-1];
    auto newInnerIOYiled = newInnerIOLoop.getBody()->getTerminator();

    // Annotate the outerloops
    // load: L3->L2, send: L2->PLIO, store: L2->L3, receive: PLIO -> L2
    if(iopush){
      // Check if the external memory has been read, if so then find the loadIdx
      // If not use the current loadIdx and increase it.
      // This is to ensure, that in the later stage L3 buffer is accessed only
      // from one loop nests
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
      auto sendAttr = builder.getIntegerAttr(indexType, sendIdx++);
      newOuterDMALoop->setAttr("load", loadAttr);
      newOuterIOLoop->setAttr("send", sendAttr);
    }else{
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
      auto receiveAttr = builder.getIntegerAttr(indexType, receiveIdx++);
      newOuterDMALoop->setAttr("store", storeAttr);
      newOuterIOLoop->setAttr("receive", receiveAttr);
    }
    // Clone and create AffineApplyOps for L3 and L2 memory respectively
    // L3Applys: L3 offsets, when L3->L2
    // L3L2Applys: L2 offset when L3->L2
    // L2L1Applys: L2 offset when L2->L1
    // For L3L2Applys, it should be the same as the offset of IOPush/IOPop
    // TODO:: For L2Applys, it is now set as the d0 * size. 
    // This may need to be generalized
    SmallVector<Value, 4> L3Applys, L3L2Applys, L2L1Applys;
    for (unsigned i = 0; i < rank; i++){
      auto applyOp = applyOps[i];
      builder.setInsertionPoint(newInnerDMAYiled);
      auto *clonedOp = applyOp->clone();
      builder.insert(clonedOp);
      // Clone AffineApplyOps for L3 memory
      auto L3ApplyOp = dyn_cast<AffineApplyOp>(clonedOp);
      L3Applys.push_back(L3ApplyOp.getResult());

      // Create L2 offset/ApplyOp
      auto sizeInt = sizesInt[i];
      auto d0 = builder.getAffineDimExpr(0);
      auto map = AffineMap::get(1, 0, d0 * sizeInt, builder.getContext());
      auto dmaLoop = newDMALoops[i];
      auto dmaIv = dmaLoop.getInductionVar();
      builder.setInsertionPoint(newInnerDMAYiled);
      auto L3L2Apply = builder.create<AffineApplyOp>(loc, map, dmaIv);
      L3L2Applys.push_back(L3L2Apply);

      auto ioLoop = newIOLoops[i];
      auto ioIv = ioLoop.getInductionVar();
      builder.setInsertionPoint(newInnerIOYiled);
      auto L2L1Apply = builder.create<AffineApplyOp>(loc, map, ioIv);
      L2L1Applys.push_back(L2L1Apply);
    }
    // Replace the loop variant in newInnerDMALoop
    for (unsigned i = 0; i < loopIndices.size(); i++) {
      auto loopIndex = loopIndices[i];
      auto oldVi = band[loopIndex].getInductionVar();
      auto newVi = newDMALoops[i].getInductionVar();
      oldVi.replaceUsesWithIf(newVi,[&](OpOperand &use){
          return newInnerDMALoop->isProperAncestor(use.getOwner());
      });
    }
    if (iopush){
      // Create dma op to load data from external mem to L2 buffer
      // Replace IOPush: Send data from L2 buffer to PLIO port
      builder.setInsertionPoint(newInnerDMAYiled);
      builder.create<DmaOp>(loc, src, L3Applys, sizes, strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        allocOp, L3L2Applys, sizes, L2Strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      builder.setInsertionPoint(newInnerIOYiled);
      builder.create<IOPushOp>(loc, allocOp, L2L1Applys, sizes, L2Strides, 
                               tiles, dims, steps, wraps, dst);
    }else{
      // Create dma op to store data from L2 buffer to external mem
      // Replace IOPop: Receive data from PLIO to L2 buffer
      builder.setInsertionPoint(newInnerDMAYiled);
      builder.create<DmaOp>(loc, allocOp, L3L2Applys, sizes, L2Strides, 
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(), 
                        dst, L3Applys, sizes, strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      builder.setInsertionPoint(newInnerIOYiled);
      auto popOp = builder.create<IOPopOp>(loc, src, allocOp, L2L1Applys, sizes, 
                                          L2Strides, tiles, dims, steps, wraps);
      if(op->hasAttr("accumulator"))
        popOp->setAttr("accumulator", builder.getUnitAttr());
    }
    return WalkResult::advance();
  }

  bool plBuffAlloc(OpBuilder builder, FuncOp plFunc, AffineForOp plForOp, 
                   SmallVector<AffineForOp, 6>& band){
    unsigned loadIdx = 0;
    unsigned storeIdx = 0;
    unsigned sendIdx = 0;
    unsigned receiveIdx = 0;
    // Record the load and store argument and index
    SmallVector<std::pair<Value, unsigned>, 4> loadSrcs, storeDsts;
    auto flag = plForOp.walk([&](Operation* op){
      WalkResult result;
      if(dyn_cast<IOPushOp>(op))
        result = IOProcesses(builder, plFunc, op, band, loadIdx, storeIdx,
                             sendIdx, receiveIdx, loadSrcs, storeDsts, true);
      else if(dyn_cast<IOPopOp>(op))
        result = IOProcesses(builder, plFunc, op, band, loadIdx, storeIdx,
                             sendIdx, receiveIdx, loadSrcs, storeDsts, false);
      return WalkResult::advance();
    });
    if (flag == WalkResult::interrupt()) 
      return false;
    // After Processes IOPush/IOPop in the outerloop, safe to erase outerLoop
    auto outerLoop = band[0];
    outerLoop.erase();
    return true;
  }

  // This pass infers the L2 buffer from the adf.dma op and the corresponding
  // array partitioning loops
  bool PLBufferExtract (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.pl"))
        continue;
      auto plBool = dyn_cast<BoolAttr>(func->getAttr("adf.pl"));
      if(!plBool || !plBool.getValue())
        continue;
      AffineForOp plForOp;
      func.walk([&](AffineForOp forOp){
        if(forOp->hasAttr("Array_Partition"))
          plForOp = forOp;
      });
      if(!plForOp){
        llvm::errs() << "Array_Partition loop not found\n";
        return false;
      }
      // Get point loops in band
      SmallVector<AffineForOp, 6> band;
      getNestedLoopBand(plForOp.getRegion(), band);
      if(!loopNormalize(plForOp, band))
        return false;

      // Simplify the loop structure after loopNormalize.
      // There won't be any nested affine.apply ops
      PassManager pm(func.getContext(), "func.func");
      pm.addPass(createSimplifyAffineStructuresPass());
      (void)pm.run(func);
      
      // Allocate PL buffer
      if(!plBuffAlloc(builder, func, plForOp, band))
        return false;
    }
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPLBufferExtractPass() {
  return std::make_unique<AriesPLBufferExtract>();
}

std::unique_ptr<Pass> createAriesPLBufferExtractPass(const AriesOptions &opts) {
  return std::make_unique<AriesPLBufferExtract>(opts);
}

} // namespace aries
} // namespace mlir