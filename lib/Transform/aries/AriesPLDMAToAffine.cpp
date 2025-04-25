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
#define DEBUG_TYPE "aries-pl-dma-to-affine"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::memref;
using namespace mlir::arith;

namespace {

struct AriesPLDMAToAffine 
      : public AriesPLDMAToAffineBase<AriesPLDMAToAffine> {
public:
  AriesPLDMAToAffine() = default;

  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    auto context = mod->getContext();
    PassManager pm(context);
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
    if (!PLDMAToAffine(mod))
      signalPassFailure();
    if (failed(pm.run(mod)))
      signalPassFailure();
  }

private:
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

  // Convert adf.io.push/pop that moves data between memrefs and ios to 
  // affine load&store
  WalkResult ConvertIOToAffine(OpBuilder builder, Operation* op,  bool iopush){
    auto loc = builder.getUnknownLoc();
    IOPushOp iopushOp;
    IOPopOp iopopOp;
    Value src, dst;
    SmallVector<Value> offsets, sizes, strides, tiles, dims, steps, wraps;
    MemRefType type;
    getIOInfo(op, iopushOp, iopopOp, src, dst, offsets, sizes, strides, tiles,
              dims, steps, wraps, type, iopush);
    auto elementType = type.getElementType();
    auto width = type.getElementTypeBitWidth();
    auto rank = type.getRank();
    auto idxType = builder.getIndexType();
    builder.setInsertionPoint(op);
    // Create for loops for IOPush/Pop Ops
    SmallVector<AffineForOp, 4> newIOLoops;
    for(unsigned i = 0; i < rank; i++){
      auto size = sizes[i];
      auto consSize = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
      if(!consSize)
        return WalkResult::interrupt();
      auto sizeAttr = dyn_cast<IntegerAttr>(consSize.getValue());
      auto sizeInt = sizeAttr.getInt();
      auto newIOForOp 
           = builder.create<AffineForOp>(loc, 0, sizeInt, 1);
      newIOLoops.push_back(newIOForOp);
      builder.setInsertionPointToStart(newIOForOp.getBody());
    }
    // Get the access operands of affine load/store
    auto newInnerIOLoop = newIOLoops[newIOLoops.size()-1];
    auto oneAttr = builder.getIntegerAttr(idxType, 1);
    newInnerIOLoop->setAttr("pipeline_ii", oneAttr);
    auto newInnerIOYiled = newInnerIOLoop.getBody()->getTerminator();
    // The access should be iv * stride + offset
    builder.setInsertionPoint(newInnerIOYiled);
    auto d0 = builder.getAffineDimExpr(0);
    auto d1 = builder.getAffineDimExpr(1);
    SmallVector<Value> newApplyopIOs;
    for(unsigned i = 0; i < rank; i++){
      auto stride = strides[i];
      auto consStride = dyn_cast<arith::ConstantOp>(stride.getDefiningOp());
      if(!consStride)
        return WalkResult::interrupt();
      auto strideAttr = dyn_cast<IntegerAttr>(consStride.getValue());
      auto strideInt = strideAttr.getInt();
      auto map = AffineMap::get(2, 0, d0*strideInt + d1, builder.getContext());
      SmallVector<Value, 2> applyOperands;
      auto newIOLoop = newIOLoops[i];
      auto var = newIOLoop.getInductionVar();
      auto offset = offsets[i];
      applyOperands.push_back(var);
      applyOperands.push_back(offset);
      auto newApplyopIO=builder.create<AffineApplyOp>(loc, map, applyOperands);
      newApplyopIOs.push_back(newApplyopIO);
    }

    // Replace IOPush/Pop Ops with affine.load and affine.store
    if(iopush){
      auto loadOp = builder.create<AffineLoadOp>(loc, src, newApplyopIOs);
      auto loadType = loadOp.getType();
      Value tempVal;
      if (auto floatType = dyn_cast<FloatType>(loadType)){
        auto intType = builder.getIntegerType(width);
        auto castOp = builder.create<BitcastOp>(loc, intType, loadOp);
        tempVal = castOp.getResult();
      }else{
        tempVal = loadOp;
      }
      builder.create<IOWriteOp>(loc, tempVal, dst);
    }else{
      auto intType = builder.getIntegerType(width);
      auto result = builder.create<IOReadOp>(loc, intType, src);
      // Need to do reduction meaning load data from IO sum and store back to L2
      if(op->hasAttr("accumulator")){
        // Check the original type and handle reduction properly
        auto loadOp = builder.create<AffineLoadOp>(loc, dst, newApplyopIOs);
        auto typeAttr = dyn_cast<TypeAttr>(iopopOp->getAttr("type"));
        auto originType = typeAttr.getValue();
        auto originWidth = originType.getIntOrFloatBitWidth();
        auto newType = builder.getIntegerType(originWidth);
        auto splitNum = (unsigned)(width/originWidth);
        if(splitNum==1){
          Value addOp;
          if (auto floatType = dyn_cast<FloatType>(elementType)){
            auto castFloat = builder.create<BitcastOp>(loc, floatType, result);
            addOp = builder.create<arith::AddFOp>(loc, loadOp, castFloat);
          }else{
            addOp = builder.create<arith::AddIOp>(loc, loadOp, result);
          }
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
      }else{
        Value tempVal;
        if (auto floatType = dyn_cast<FloatType>(elementType)){
          auto castFloat = builder.create<BitcastOp>(loc, floatType, result);
          tempVal = castFloat.getResult();
        }else{
          tempVal = result;
        }
        builder.create<AffineStoreOp>(loc, tempVal, dst, newApplyopIOs);
      }
    }
    return WalkResult::advance();
  }

  void getDMAInfo(DmaOp dmaOp, Value& src, Value& dst, 
                  MemRefType& srcType, MemRefType& dstType, bool& dmaLoad,
                  SmallVector<Value>& L2Sizes, SmallVector<Value>& L2Offsets,
                  SmallVector<Value>& L2Strides, SmallVector<Value>& L3Offsets, 
                  SmallVector<Value>& L3Strides){
    src = dmaOp.getSrc();
    dst = dmaOp.getDst();
    srcType = dyn_cast<MemRefType>(src.getType());
    dstType = dyn_cast<MemRefType>(dst.getType());
    if(srcType.getMemorySpaceAsInt() == (int)MemorySpace::L2){
      L2Sizes   = dmaOp.getSrcSizes();
      L2Offsets = dmaOp.getSrcOffsets();
      L2Strides = dmaOp.getSrcStrides();
      L3Offsets = dmaOp.getDstOffsets();
      L3Strides = dmaOp.getDstStrides();
      dmaLoad = false;
    }else if(dstType.getMemorySpaceAsInt() == (int)MemorySpace::L2){
      L2Sizes   = dmaOp.getDstSizes();
      L2Offsets = dmaOp.getDstOffsets();
      L2Strides = dmaOp.getDstStrides();
      L3Offsets = dmaOp.getSrcOffsets();
      L3Strides = dmaOp.getSrcStrides();
      dmaLoad = true;
    }else{
      llvm::errs() << "No L2 buffer found in src or dst\n";
      signalPassFailure();
    }
  }

  // Convert adf.dma that moves data between two memrefs to affine load&store
  WalkResult ConvertDMAToAffine(OpBuilder builder, FuncOp plFunc, DmaOp dmaOp){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
    auto indexType = builder.getIndexType();
    Value src, dst;
    // For the size of L3 is the same as L2
    SmallVector<Value> L2Sizes, L2Offsets, L2Strides, L3Offsets, L3Strides;
    MemRefType srcType, dstType;
    bool dmaLoad;
    getDMAInfo(dmaOp, src, dst, srcType, dstType, dmaLoad, L2Sizes, L2Offsets,
               L2Strides, L3Offsets, L3Strides);
    auto rank = srcType.getRank();

    // Create for loops for DMA Ops
    builder.setInsertionPoint(dmaOp);
    SmallVector<AffineForOp, 4> newDMALoops;
    for(unsigned i = 0; i < rank; i++){
      Value size = L2Sizes[i];
      auto consSize = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
      if(!consSize)
        return WalkResult::interrupt();
      auto sizeAttr = dyn_cast<IntegerAttr>(consSize.getValue());
      auto sizeInt = sizeAttr.getInt();
      auto newDMAForOp 
           = builder.create<AffineForOp>(loc, 0, sizeInt, 1);
      newDMALoops.push_back(newDMAForOp);
      builder.setInsertionPointToStart(newDMAForOp.getBody());
    }
    auto newInnerDMALoop = newDMALoops[newDMALoops.size()-1];
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    newInnerDMALoop->setAttr("pipeline_ii", oneAttr);
    auto newInnerDMAYiled = newInnerDMALoop.getBody()->getTerminator();

    // Create mem access for L2 buffer
    SmallVector<Value> newApplyopL2DMAs;
    auto d0 = builder.getAffineDimExpr(0);
    auto d1 = builder.getAffineDimExpr(1);
    for(unsigned i = 0; i < rank; i++){
      SmallVector<Value, 2> applyOperands;
      auto stride = L2Strides[i];
      auto consStride = dyn_cast<arith::ConstantOp>(stride.getDefiningOp());
      if(!consStride)
        return WalkResult::interrupt();
      auto strideAttr = dyn_cast<IntegerAttr>(consStride.getValue());
      auto StrideInt = strideAttr.getInt();
      auto map = AffineMap::get(2, 0, d0 * StrideInt + d1, context);
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
      auto map = AffineMap::get(2, 0, d0 * StrideInt + d1, context);
      auto var = newIOLoop.getInductionVar();
      auto offset = L3Offsets[i];
      applyOperands.push_back(var);
      applyOperands.push_back(offset);
      builder.setInsertionPoint(newInnerDMAYiled);
      auto newApplyopL3DMA 
           = builder.create<AffineApplyOp>(loc, map, applyOperands);
      newApplyopL3DMAs.push_back(newApplyopL3DMA);
    }
    if(dmaLoad){
      auto loadOp = builder.create<AffineLoadOp>(loc, src, newApplyopL3DMAs);
      builder.create<AffineStoreOp>(loc, loadOp, dst, newApplyopL2DMAs);
    }else{
      auto loadOp = builder.create<AffineLoadOp>(loc, src, newApplyopL2DMAs);
      builder.create<AffineStoreOp>(loc, loadOp, dst, newApplyopL3DMAs);
    }    
    return WalkResult::advance();
  }

  // Tranverse the IOPushOps/IOPopOps and convert them to affine load/store
  bool ConvertIODMAToAffine(OpBuilder builder, FuncOp plFunc, 
                            AffineForOp plForOp){
    auto flag = plForOp.walk([&](Operation* op){
      WalkResult result;
      if(dyn_cast<IOPushOp>(op))
        result = ConvertIOToAffine(builder, op, true);
      else if(dyn_cast<IOPopOp>(op))
        result = ConvertIOToAffine(builder, op, false);
      else if(auto dmaOp = dyn_cast<DmaOp>(op))
        result = ConvertDMAToAffine(builder, plFunc, dmaOp);
      else
        return WalkResult::advance();
      op->erase();
      return result;
    });
    if (flag == WalkResult::interrupt()) 
      return false;
    return true;
  }

  // This is a helper function to get the func.call of the current adf.pl func
  // the adf.func that contains the func.call, the top_func that calls adf.func
  // The adf.pl is assumed to be called in adf.func where the later one is
  // assumed to be called in top_func
  void getFuncs(ModuleOp mod, FuncOp plFunc, FuncOp& topFunc, FuncOp& adfFunc,
                CallOp& adfCaller, SmallVector<CallOp>& topCallers){
    for (auto func : mod.getOps<FuncOp>()) {
      if(func->hasAttr("top_func")){
        topFunc = func;
        continue;
      }
      if(!func->hasAttr("adf.func"))
        continue;
      unsigned foundCall = 0;
      // Find if caller is inside the current adf.func op
      func.walk([&](CallOp call){
        if(call.getCallee() != plFunc.getName())
          return WalkResult::advance();
        adfFunc = func;
        adfCaller = call;
        foundCall++;
        return WalkResult::interrupt();
      });
      if(foundCall>1){
        llvm::errs() << "Found multiple adf.func that calls the adf.pl func\n";
        signalPassFailure();
      }
    }
    // Get the caller of adfFunc in topFunc
    for (auto call : topFunc.getOps<CallOp>()) {
      if(call.getCallee() != adfFunc.getName())
        continue;
      topCallers.push_back(call);
    }
  }

  // This function does the loop permutation for load/store from L3->L2 mem
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

  // Tranverse IORead/IOWrite and convert them to AffineLoad/AffineStore
  // PLIO type will be replaced by memref<1xtype, "plio">
  // Then update its func type, caller type, adfFunc and the parent topFunc
  // In the corrsponding adf.func create ConnectOp to connect stream with PLIO
  void ConvertIOToMem(ModuleOp mod, OpBuilder builder, FuncOp plFunc){
    auto loc = builder.getUnknownLoc();
    auto plioAttr = builder.getStringAttr("plio");
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    SmallVector<int64_t> oneVec;
    oneVec.push_back(1);
    builder.setInsertionPointToStart(&plFunc.getBody().front());
    auto zeroValue = builder.create<arith::ConstantOp>(loc, zeroAttr);
    SmallVector<Value> zeroValues(1, zeroValue);
    auto inTypes =SmallVector<Type,8>(plFunc.getArgumentTypes().begin(),
                                      plFunc.getArgumentTypes().end());
    auto outTypes = plFunc.getResultTypes();

    // Get the caller, adfFunc, topFunc of the plFunc
    FuncOp topFunc, adfFunc;
    CallOp caller;
    SmallVector<CallOp> topCallers;
    getFuncs(mod, plFunc, topFunc, adfFunc, caller, topCallers);
    auto topAttr = dyn_cast<StringAttr>(topFunc->getAttr("top_func"));
    if(!topAttr)
      topFunc->setAttr("top_func", plioAttr);

    // Tranverse the arguments of plFunc collect the newType based on 
    // corresponding IOWriteOp & IOReadOp
    SmallVector<unsigned> argIds;
    SmallVector<bool> writeFlags;
    SmallVector<Type> newTypes;
    for (unsigned i = 0; i < plFunc.getNumArguments(); i++){
      auto arg = plFunc.getArgument(i);
      auto type = arg.getType();
      if(!dyn_cast<PLIOType>(type))
        continue;
      Type elementType;
      // One IO will have and only have one direction
      bool write_flag = false;
      for(auto user: arg.getUsers()){
        if(auto ioWrite = dyn_cast<IOWriteOp>(user)){
          write_flag = true;
          auto src = ioWrite.getSrc();
          auto eleType = src.getType();
          if(!elementType)
            elementType = eleType;
          else if(elementType != eleType){
            llvm::errs() << "Find src with different types write to io\n";
            signalPassFailure();
          }  
        }else if(auto ioRead = dyn_cast<IOReadOp>(user)){
          auto dst = ioRead.getResult();
          auto eleType = dst.getType();
          if(!elementType)
            elementType = eleType;
          else if(elementType != eleType){
            llvm::errs() << "Find dst with different types read from io\n";
            signalPassFailure();
          }
        }
      }
      writeFlags.push_back(write_flag);
      argIds.push_back(i);
      auto newType=MemRefType::get(oneVec, elementType, AffineMap(), plioAttr);
      newTypes.push_back(newType);
    }

    // Tranverse the arguments of plFunc, change the PLIO types to 
    // memref<1xtype, "plio">
    // Replace the IOWriteOp/IOReadOp by AffineStore/AffineLoad
    for (unsigned i = 0; i < plFunc.getNumArguments(); i++){
      auto arg = plFunc.getArgument(i);
      auto type = arg.getType();
      if(!dyn_cast<PLIOType>(type))
        continue;
      auto it = llvm::find(argIds, i);
      if(it==argIds.end()){
        llvm::errs() << "Arg of PLIO type didn't collect correctly\n";
        signalPassFailure();
      }
      auto pos = std::distance(argIds.begin(), it); 
      auto newType=newTypes[pos];
      inTypes[i] = newType;
      arg.setType(newType);
      for(auto user: llvm::make_early_inc_range(arg.getUsers())){
        if(auto ioWrite = dyn_cast<IOWriteOp>(user)){
          auto src = ioWrite.getSrc();
          builder.setInsertionPoint(ioWrite);
          builder.create<AffineStoreOp>(loc, src, arg, zeroValues);
          ioWrite.erase();
        }else if(auto ioRead = dyn_cast<IOReadOp>(user)){
          auto dst = ioRead.getResult();
          builder.setInsertionPoint(ioRead);
          auto load = builder.create<AffineLoadOp>(loc, arg, zeroValues);
          auto result = load.getResult();
          dst.replaceAllUsesWith(result);
          ioRead.erase();
        }
      }
    }
    // Update the plfunc function type.
    plFunc.setType(builder.getFunctionType(inTypes, outTypes));

    // In adfFunc and topFunc, add memref<1xtype, "plio"> to argument list
    // Connect the GraphIO with the new argument
    auto adfInTypes =SmallVector<Type,8>(adfFunc.getArgumentTypes().begin(),
                                         adfFunc.getArgumentTypes().end());
    
    auto topInTypes =SmallVector<Type,8>(topFunc.getArgumentTypes().begin(),
                                         topFunc.getArgumentTypes().end());
    auto adfOutTypes = adfFunc.getResultTypes();
    auto topOutTypes = topFunc.getResultTypes();
    auto& adfBlock = adfFunc.getBody().front();
    auto& topBlock = topFunc.getBody().front();
    auto topArgNum = (unsigned) topInTypes.size();

    for (unsigned i =0; i < argIds.size(); i++){
      auto argId = argIds[i];
      auto operand = caller.getOperand(argId);
      auto defineOp = operand.getDefiningOp();
      if(!defineOp || !dyn_cast<CreateGraphIOOp>(defineOp)){
        llvm::errs() << "Find PLIO Type Operands not defined by GraphIOOp\n";
        signalPassFailure();
      }
      // Add argument to adfFunc and topFunc
      auto newType = newTypes[i];
      adfInTypes.push_back(newType);
      adfBlock.addArgument(newType, adfFunc.getLoc());
      topInTypes.push_back(newType);
      topBlock.addArgument(newType, topFunc.getLoc());
      // Create connectOp to connect memref<1xtype, "plio"> with graphIO
      auto arg = adfBlock.getArgument(adfBlock.getNumArguments()-1);
      caller.setOperand(argId, arg);
      auto graphio = dyn_cast<CreateGraphIOOp>(defineOp);
      auto write_flag = writeFlags[i];
      builder.setInsertionPointAfter(graphio);
      if(write_flag){
        auto connect = builder.create<ConnectOp>(loc, arg, graphio);
        connect->setAttr("top_config", builder.getUnitAttr());
      }else{
        auto connect = builder.create<ConnectOp>(loc, graphio, arg);
        connect->setAttr("top_config", builder.getUnitAttr());
      }
    }
    // Update the adf.func type.
    adfFunc.setType(builder.getFunctionType(adfInTypes, adfOutTypes));
    topFunc.setType(builder.getFunctionType(topInTypes, topOutTypes));

    // Update topCallers
    for (auto call : llvm::make_early_inc_range(topCallers)) {
      SmallVector<Value, 8> operands;
      for(auto operand: call.getOperands())
        operands.push_back(operand);
      for(auto i=topArgNum; i<topInTypes.size(); i++)
        operands.push_back(topFunc.getArgument(i));
      builder.setInsertionPoint(call);
      builder.create<CallOp>(loc, plFunc, ValueRange{operands});
      call.erase();
    }
  }

  // Tranverse the "load" and "store" module and change the L2 buffer access 
  // with stream access
  void L2MemProcess(OpBuilder builder, FuncOp plFunc, AffineForOp plForOp){
    auto loc = builder.getUnknownLoc();
    auto streamAttr = builder.getStringAttr("stream");
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    SmallVector<OpFoldResult> sizes;
    sizes.push_back(builder.getIndexAttr(1));
    for (AffineForOp forOp : plForOp.getOps<AffineForOp>()) {
      if(!forOp->hasAttr("load") && !forOp->hasAttr("store"))
        continue;
      SmallVector<AffineForOp, 6> band;
      getNestedLoops(band, forOp);
      auto outerLoop = band[0];
      auto innerLoop = band[band.size()-1];
      bool load_flag;
      AffineStoreOp storeOp;
      AffineLoadOp loadOp;
      Value memref, val;
      SmallVector<Value> indices;
      if(outerLoop->hasAttr("load")){
        storeOp = getFirstOpOfType<AffineStoreOp>(innerLoop.getRegion());
        memref = storeOp.getMemRef();
        val = storeOp.getValueToStore();
        indices = storeOp.getIndices();
        load_flag = true;
      }else{
        loadOp = getFirstOpOfType<AffineLoadOp>(innerLoop.getRegion());
        memref = loadOp.getMemRef();
        val = loadOp.getResult();
        indices = loadOp.getIndices();
        load_flag = false;
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
      // Clone the outerloop, for load module, change affine.store to L2 mem to 
      // affine.store to allocOp stream mem in the original loop.
      // In the cloned loop, change the val of store loaded from L3 to 
      // affine.load from stream.
      auto clonedLoop = dyn_cast<AffineForOp>(outerLoop->clone());
      SmallVector<AffineForOp, 6> newBand;
      getNestedLoops(newBand, clonedLoop);
      auto newInnerLoop = newBand[newBand.size()-1];
      if(load_flag){
        builder.setInsertionPointAfter(outerLoop);
        builder.insert(clonedLoop);
        // In the original loop, create affine.store to stream
        builder.setInsertionPoint(storeOp);
        builder.create<AffineStoreOp>(loc, val, allocOp, zeroValues);
        storeOp.erase();
        outerLoop->removeAttr("send");
        // In the cloned loop, load data from stream
        auto newStore 
            = getFirstOpOfType<AffineStoreOp>(newInnerLoop.getRegion());
        auto newVal = newStore.getValueToStore();
        auto defineOp = newVal.getDefiningOp();
        builder.setInsertionPoint(newStore);
        auto newLoad = builder.create<AffineLoadOp>(loc, allocOp, zeroValues);
        newVal.replaceUsesWithIf(newLoad,[&](OpOperand &use){
          return newInnerLoop->isProperAncestor(use.getOwner());
        });
        clonedLoop->removeAttr("load");
        defineOp->erase();
      }else{
        builder.setInsertionPoint(outerLoop);
        builder.insert(clonedLoop);
        // In the cloned loop, store data to allocOp stream
        auto newStore 
            = getFirstOpOfType<AffineStoreOp>(newInnerLoop.getRegion());
        auto newVal = newStore.getValueToStore();
        builder.setInsertionPoint(newStore);
        builder.create<AffineStoreOp>(loc, newVal, allocOp, zeroValues);
        auto defineOp = newVal.getDefiningOp();
        if(!defineOp || !dyn_cast<AffineLoadOp>(defineOp)){
          llvm::errs() << "newVal defined by AffineLoadOp\n";
          signalPassFailure();
        }
        auto clonedLoad = dyn_cast<AffineLoadOp>(defineOp);
        auto clonedMem = clonedLoad.getMemRef();
        auto clonedIndices = clonedLoad.getIndices();
        // Check if the L2 mem is marked by init, if it is then initialize it
        // by zero
        auto l2mem = dyn_cast<AllocOp>(clonedMem.getDefiningOp());
        if(l2mem && l2mem->hasAttr("init")){
          Value zeroVal;
          if (isa<IntegerType>(elementType)) {
            auto intAttr = builder.getIntegerAttr(elementType, 0);
            zeroVal 
              = builder.create<arith::ConstantOp>(loc, elementType, intAttr);
          }else{
            auto floatAttr = builder.getF32FloatAttr(0.0);
            zeroVal 
              = builder.create<arith::ConstantOp>(loc, elementType, floatAttr);
          }
          builder.create<AffineStoreOp>(loc, zeroVal, clonedMem, clonedIndices);
        }
        clonedLoop->removeAttr("store");
        newStore.erase();
        // In the original loop, load from stream
        builder.setInsertionPoint(loadOp);
        auto newLoad = builder.create<AffineLoadOp>(loc, allocOp, zeroValues);
        val.replaceUsesWithIf(newLoad,[&](OpOperand &use){
          return innerLoop->isProperAncestor(use.getOwner());
        });
        outerLoop->removeAttr("receive");
        loadOp->erase();
      }
    }
  }

  // Split the loops marked by "load,store,send,receive" and then merge them
  // into the outmost tileBand by identify there attributes
  void PLLoopSplit(OpBuilder builder, FuncOp plFunc, AffineForOp plForOp){
    auto loc = builder.getUnknownLoc();
    SmallVector<AffineForOp, 6> tileBand;
    getLoopBandFromInnermost(plForOp, tileBand);
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
        if(auto redAttr = loop->getAttr("reduction"))
          newForOp->setAttr("reduction", redAttr);
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
          forOp->setAttr("merge", builder.getUnitAttr()); // Used for burst
        }else if(auto Attr = forOp->getAttr("store")){
          outerNewloop->setAttr("store", Attr);
          forOp->removeAttr("store");
          forOp->setAttr("merge", builder.getUnitAttr());
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

  // Hoist the loops beyond loops marked by reduction, 
  // this is to implement the output stationary dataflow
  // This function assumes the modules inside plFunc have already been moved
  // inside the temporal loops
  bool hoistStore(FuncOp plFunc){
    // Tranverse each store forOp inside plFunc
    for(auto forOp: plFunc.getOps<AffineForOp>()){
      if(!forOp->hasAttr("store") && !forOp->hasAttr("receive"))
        continue;
      // Get the Array_Partition forOp
      AffineForOp partforOp;
      forOp.walk([&](AffineForOp op){
        if(op->hasAttr("Array_Partition")){
          partforOp = op;
          return WalkResult::interrupt();
        }
        return WalkResult::advance();
      });
      if(!partforOp)
        return true;
      // Get the temporal loops from outermost
      SmallVector<AffineForOp, 6> tileBand;
      getLoopBandFromInnermost(partforOp, tileBand);

      // Collect the reduction temporal loops and its loop id
      SmallVector<int64_t> loopids;
      SmallVector<int64_t> redIds;
      for(unsigned i=0; i< tileBand.size(); i++){
        auto loop = tileBand[i];
        if(loop->hasAttr("reduction")){
          auto redAttr =  dyn_cast<IntegerAttr>(loop->getAttr("reduction"));
          loopids.push_back(i);
          redIds.push_back(redAttr.getInt());
        }
      }
      // Tranverse the forOp marked by hoist
      for(auto hoistLoop : llvm::make_early_inc_range(partforOp.getOps<AffineForOp>())){
        if(!hoistLoop->hasAttr("hoist"))
          continue;
        // Collect the hoist ids marked inside the array_part loop
        auto arrayAttr = dyn_cast<ArrayAttr>(hoistLoop->getAttr("hoist"));
        SmallVector<int64_t> hoistIds;
        for(auto attr: arrayAttr){
          if(auto intAttr = dyn_cast<IntegerAttr>(attr)){
            auto intVal = intAttr.getInt();
            hoistIds.push_back(intVal);
          }
        }
        // Find the loop idx or the loops marked by hoist ids
        SmallVector<int64_t> markedLoops;
        for(auto hoistId: hoistIds){
          auto it = llvm::find(redIds, hoistId);
          if(it == redIds.end()){
            llvm::errs() << "Marked reduction loop not found\n";
            return false;
          }
          auto pos = std::distance(redIds.begin(), it);
          markedLoops.push_back(loopids[pos]);
        }
        llvm::sort(markedLoops);
        // Check for consecutiveness
        for (unsigned i = 0; i < markedLoops.size() - 1; i++) {
          if (markedLoops[i] + 1 != markedLoops[i + 1]) {
            llvm::errs() << "Marked reduction loop are not consecutive\n";
            return false;
          }
        }
        // Check if from innermost
        if(markedLoops.back()+1 != (int)tileBand.size()){
          llvm::errs() << "Reduction loops do not start from innermost\n";
          return false;
        }
        // Move redLoop outside of the outermost reduction loop
        auto targetLoop = tileBand[markedLoops[0]];
        hoistLoop->moveAfter(targetLoop);
        hoistLoop->removeAttr("hoist");
      }
    }
    return true;
  }
  
  // This pass infers the L2 buffer from the adf.dma op and the corresponding
  // array partitioning loops
  bool PLDMAToAffine (ModuleOp mod) {
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
      // Tranverse the IOPushOps/IOPopOps and convert them to affine load/store
      if(!ConvertIODMAToAffine(builder, func, plForOp))
        return false;

      // Simplify the loop structure after ConvertToAffine.
      // There won't be any nested affine.apply ops
      PassManager pm(func.getContext(), "func.func");
      pm.addPass(createSimplifyAffineStructuresPass());
      (void)pm.run(func);
      
      // Permute loops in order to potentially increase the burst length
      if(!loopPermutation(plForOp)){
        llvm::errs() << "Loop permutation failed\n";
        return false;
      }

      // Tranverse the IOWrite/IOReadOp and convert them to affine load/store
      // Then update the function type and function calls
      ConvertIOToMem(mod, builder, func);

      // For access between L3 <-> L2, use stream to connect
      L2MemProcess(builder, func, plForOp);
      
      // Move each loop marked by "load,store,receive,send" to the
      // outermost temporal tileBand 
      PLLoopSplit(builder, func, plForOp);

      // Initialize L2 Mem and hoist the store to outside of the marked 
      // reduction loops
      if(!hoistStore(func))
        return false;
    }
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPLDMAToAffinePass() {
  return std::make_unique<AriesPLDMAToAffine>();
}

} // namespace aries
} // namespace mlir