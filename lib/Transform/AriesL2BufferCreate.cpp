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

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::memref;

namespace {

struct AriesL2BufferCreate 
      : public AriesL2BufferCreateBase<AriesL2BufferCreate> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!L2BufferCreate(mod))
      signalPassFailure();
  }

private:
  WalkResult dmaProcess(OpBuilder builder, FuncOp func, DmaOp dmaOp, 
                        SmallVector<AffineForOp, 6>& band){
    auto loc = builder.getUnknownLoc();
    auto src = dmaOp.getSrc();
    auto dst = dmaOp.getDst();
    MemRefType type = dyn_cast<MemRefType>(src.getType());
    SmallVector<Value> offsets = dmaOp.getSrcOffsets();
    SmallVector<Value> sizes   = dmaOp.getSrcSizes();
    SmallVector<Value> strides = dmaOp.getSrcStrides();
    SmallVector<Value> srcOffsets = dmaOp.getSrcOffsets();
    SmallVector<Value> srcSizes   = dmaOp.getSrcSizes();
    SmallVector<Value> srcStrides = dmaOp.getSrcStrides();
    SmallVector<Value> dstOffsets = dmaOp.getDstOffsets();
    SmallVector<Value> dstSizes   = dmaOp.getDstSizes();
    SmallVector<Value> dstStrides = dmaOp.getDstStrides();
    auto srcType = dyn_cast<MemRefType>(src.getType());
    auto srcSpace = srcType.getMemorySpace();
    unsigned srcSpaInt = 0;
    auto dstType = dyn_cast<MemRefType>(dst.getType());
    auto dstSpace = dstType.getMemorySpace();
    unsigned dstSpaInt = 0;
    bool load_flag;
    if(srcSpace){
      if(auto memIntAttr = dyn_cast<IntegerAttr>(srcSpace)){
        srcSpaInt = memIntAttr.getInt();
      }
    }
    if(dstSpace){
      if(auto memIntAttr = dyn_cast<IntegerAttr>(dstSpace)){
        dstSpaInt = memIntAttr.getInt();
      }
    }
    if(srcSpaInt == (int)MemorySpace::L3 && dstSpaInt == (int)MemorySpace::L1)
      load_flag = true;
    else if(dstSpaInt == (int)MemorySpace::L3 
         && srcSpaInt == (int)MemorySpace::L1)
      load_flag = false;
    else
      return WalkResult::advance();
    if(!load_flag){
      offsets = dstOffsets;
      sizes   = dstSizes;
      strides = dstStrides;
    }
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
    SmallVector<unsigned, 4> loopIndices; // Record the loop depth
    SmallVector<AffineApplyOp, 4> applyOps; // Record the applyOps
    SmallVector<SmallVector<int, 4>, 4> tileIdxs; // Index of loops not in band
    unsigned rank = offsets.size();
    for (unsigned dim=0; dim < rank; dim++){
      auto offset = offsets[dim];
      auto sizeInt = sizesInt[dim];
      auto defineOp = offset.getDefiningOp();
      if(!defineOp){
        llvm::errs() << "Offset not defined by any operantions!\n";
        return WalkResult::interrupt();
      }
      if(dyn_cast<arith::ConstantOp>(defineOp)){
        auto sizeInt = sizesInt[dim];
        bufSizes.push_back(sizeInt);
      }else if(auto applyOp = dyn_cast<AffineApplyOp>(defineOp)){
        applyOps.push_back(applyOp);
        auto operands = applyOp.getOperands();
        SmallVector<int, 4> tileIdx;
        auto totalCount = 1;
        for (unsigned i = 0; i < operands.size(); i++){
          auto operand = operands[i];
          auto loop = getForInductionVarOwner(operand);
          if(!loop){
            llvm::errs() << "ApplyOp has non-inductionVar operands!\n";
            return WalkResult::interrupt();
          }
          auto it = llvm::find(band, loop);
          if (it != band.end()) {
            unsigned index = std::distance(band.begin(), it);
            auto itId = llvm::find(loopIndices, index);
            if (itId == loopIndices.end())
              loopIndices.push_back(index);
            SmallVector<Value, 4> foroperands;
            AffineMap map;
            getTripCountMapAndOperands(loop, &map, &foroperands);
            auto tripCount = map.getSingleConstantResult();
            if (!tripCount){
              llvm::errs() << "Involve loops with non-consant trip count!\n";
              return WalkResult::interrupt();
            }
            totalCount = totalCount * tripCount;
          }else{ // Record the index of operands not in point-loops
            tileIdx.push_back(i);
          }
        }
        bufSizes.push_back(totalCount*sizeInt);
        tileIdxs.push_back(tileIdx);
      }else{
        llvm::errs() << "Offset defined by unsupported operations\n";
        return WalkResult::interrupt();
      }
    }
    // Allocate L2 buffer before the outer point loop
    builder.setInsertionPoint(outerloop);
    auto allocOp 
         = builder.create<BufferOp>(loc, MemRefType::get(bufSizes,
                                   type.getElementType(), AffineMap(),
                                   (int)MemorySpace::L2));
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
    if(load_flag)
      builder.setInsertionPoint(outerloop);
    else
      builder.setInsertionPointAfter(outerloop);

    // Create new loops for L3 -> L2 dma
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
    
    // Clone and create AffineApplyOps for L3 and L2 memory respectively
    auto newInnerDMALoop = newDMALoops[newDMALoops.size()-1];
    auto newInnerDMAYiled = newInnerDMALoop.getBody()->getTerminator();
    
    SmallVector<Value, 4> L3Applys;
    SmallVector<Value, 4> oriL2Applys;
    SmallVector<Value, 4> newL2Applys;
    for (unsigned i = 0; i < applyOps.size(); i++){
      auto applyOp = applyOps[i];
      builder.setInsertionPoint(newInnerDMAYiled);
      auto *clonedOp = applyOp->clone();
      builder.insert(clonedOp);
      // Clone AffineApplyOps for L3 memory
      auto L3ApplyOp = dyn_cast<AffineApplyOp>(clonedOp);
      L3Applys.push_back(L3ApplyOp.getResult());
      // Create AffineApplyOps for L2 memory
      // Set the co-efficients of non-point loops to zero
      auto map = applyOp.getAffineMap();
      auto operands = applyOp.getOperands();
      auto expr = map.getResult(0);
      auto dimSize = map.getNumDims();
      auto symSize = map.getNumSymbols();
      // flattened form [dims, symbols, locals, constant]
      llvm::SmallVector<int64_t> flattenedExpr;
      if (failed(getFlattenedAffineExpr(expr, dimSize,
                                        symSize, &flattenedExpr))){
        return WalkResult::interrupt();
      }
      auto tileIdx = tileIdxs[i];
      for(auto id : tileIdx){
        flattenedExpr[id]=0;
      }
      // Build the new AffineExpr and map for L2 memory
      auto constantTerm = flattenedExpr[flattenedExpr.size()-1];
      auto newExpr = builder.getAffineConstantExpr(constantTerm);
      for (unsigned j = 0; j < dimSize; ++j) {
        newExpr = newExpr + flattenedExpr[j] * builder.getAffineDimExpr(j);
      }
      for (unsigned j = 0; j < symSize; ++j) {
        auto pos = j + dimSize;
        newExpr = newExpr + flattenedExpr[pos] * builder.getAffineSymbolExpr(j);
      }
      auto newMap = AffineMap::get(dimSize, symSize, newExpr);
      // Create L2ApplyOps in both new loops and original loops
      auto newL2ApplyOp = builder.create<AffineApplyOp>(loc, newMap, operands);
      newL2Applys.push_back(newL2ApplyOp.getResult());
      builder.setInsertionPoint(applyOp);
      auto oriL2ApplyOp = builder.create<AffineApplyOp>(loc, newMap, operands);
      oriL2Applys.push_back(oriL2ApplyOp.getResult());
    }
    if(load_flag){ // Create L3 -> L2 DmaOp, L2 -> L1 DamOp
      builder.setInsertionPoint(newInnerDMAYiled);
      builder.create<DmaOp>(loc, src, srcOffsets, srcSizes, srcStrides,
                                 allocOp, newL2Applys, srcSizes, L2Strides);
      builder.setInsertionPoint(dmaOp);
      builder.create<DmaOp>(loc, allocOp, oriL2Applys, srcSizes, L2Strides,
                                 dst, dstOffsets, dstSizes, dstStrides);
    }else{ // Create L1 -> L2 DmaOp, L2 -> L3 DamOp
      builder.setInsertionPoint(newInnerDMAYiled);
      builder.create<DmaOp>(loc, allocOp, newL2Applys, dstSizes, L2Strides,
                                 dst, dstOffsets, dstSizes, dstStrides);
      builder.setInsertionPoint(dmaOp);
      builder.create<DmaOp>(loc, src, srcOffsets, srcSizes, srcStrides,
                                 allocOp, oriL2Applys, dstSizes, L2Strides);
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
    // Replace the offset in the DmaOp by L3ApplyOp in newInnerDMALoop
    for (unsigned i = 0; i < L3Applys.size(); i++) {
      auto oldRes = applyOps[i].getResult();
      auto newRes = L3Applys[i];
      oldRes.replaceUsesWithIf(newRes,[&](OpOperand &use){
          return newInnerDMALoop->isProperAncestor(use.getOwner());
      });
    }
    return WalkResult::advance();
  }


  // This pass infers the L2 buffer from the adf.dma op and the corresponding
  // array partitioning loops
  bool L2BufferCreate (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      auto context = func->getContext();
      PassManager pm(context);
      pm.addPass(createCSEPass());
      pm.addPass(createCanonicalizerPass());
      if (failed(pm.run(func))) {
        return false;
      }
      AffineForOp arrayForOp;   
      func.walk([&](AffineForOp forOp){
        if(forOp->hasAttr("Array_Partition"))
          arrayForOp = forOp;
      });
      if(!arrayForOp)
        continue;
      SmallVector<AffineForOp, 6> band;
      getNestedLoopBand(arrayForOp.getRegion(), band);
      // Perform loop normalization
      for(auto loop : band){
        if(failed(normalizeAffineFor(loop))){
          llvm::errs() << "Find loop that can't be normalized!\n";
          return false;
        }
      }
      auto flag = arrayForOp.walk([&](DmaOp dmaOp){
        auto result = dmaProcess(builder, func, dmaOp, band);
        dmaOp.erase();
        return result;
      });
      if (flag == WalkResult::interrupt()) 
        return false;
      if (failed(pm.run(func))) {
        return false;
      }
    }
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesL2BufferCreatePass() {
  return std::make_unique<AriesL2BufferCreate>();
}

} // namespace aries
} // namespace mlir