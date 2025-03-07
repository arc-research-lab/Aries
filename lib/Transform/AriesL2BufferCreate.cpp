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
  AriesL2BufferCreate() = default;
  AriesL2BufferCreate(const AriesOptions &opts) {
    EnablePL = opts.OptEnablePL;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!L2BufferCreate(mod))
      signalPassFailure();
  }

private:
  // This function split one broadcast function to multiple broadcasts.
  // This is to be align with both Vitis and MLIR-AIE backend
  void splitBroadCast(OpBuilder builder, DmaBroadcastOp broadcast){
    auto loc = builder.getUnknownLoc();
    auto src = broadcast.getSrc();
    auto dsts = broadcast.getDst();
    auto srcOffsets = broadcast.getSrcOffsets();
    auto srcSizes   = broadcast.getSrcSizes();
    auto srcStrides = broadcast.getSrcStrides();
    auto dstOffsets = broadcast.getDstOffsets();
    auto dstSizes   = broadcast.getDstSizes();
    auto dstStrides = broadcast.getDstStrides();
    for(auto dst: dsts){
      auto defineOp = dst.getDefiningOp();
      builder.setInsertionPointAfter(defineOp);
      auto newDma = builder.create<DmaBroadcastOp>(loc, 
                                    src, srcOffsets, srcSizes, srcStrides,
                                    dst, dstOffsets, dstSizes, dstStrides);
      if(broadcast->hasAttr("initialize"))
        newDma->setAttr("initialize", builder.getUnitAttr());
    }
    broadcast.erase();
  }

  bool L2BuffExtract(OpBuilder builder, Operation* op, 
          unsigned& loadIdx, unsigned& storeIdx, unsigned& cnt, 
          SmallVector<AffineForOp, 6>& band){
    auto loc = builder.getUnknownLoc();
    Value src, dst;
    MemRefType srcType, dstType;
    SmallVector<Value, 3> dsts;
    SmallVector<Value, 3> srcOffsets;
    SmallVector<Value, 3> srcSizes;
    SmallVector<Value, 3> srcStrides;
    SmallVector<Value, 3> dstOffsets;
    SmallVector<Value, 3> dstSizes;
    SmallVector<Value, 3> dstStrides;
    int opType;
    if(auto broadcast = dyn_cast<DmaBroadcastOp>(op)){
      srcOffsets = broadcast.getSrcOffsets();
      srcSizes   = broadcast.getSrcSizes();
      srcStrides = broadcast.getSrcStrides();
      dstOffsets = broadcast.getDstOffsets();
      dstSizes   = broadcast.getDstSizes();
      dstStrides = broadcast.getDstStrides();
      src = broadcast.getSrc();
      dsts = broadcast.getDst();
      srcType = dyn_cast<MemRefType>(src.getType());
      dstType = dyn_cast<MemRefType>(dsts[0].getType());
      opType = 0;
    }else if(auto dmaOp = dyn_cast<DmaOp>(op)){
      srcOffsets = dmaOp.getSrcOffsets();
      srcSizes   = dmaOp.getSrcSizes();
      srcStrides = dmaOp.getSrcStrides();
      dstOffsets = dmaOp.getDstOffsets();
      dstSizes   = dmaOp.getDstSizes();
      dstStrides = dmaOp.getDstStrides();
      src = dmaOp.getSrc();
      dst = dmaOp.getDst();
      srcType = dyn_cast<MemRefType>(src.getType());
      dstType = dyn_cast<MemRefType>(dst.getType());
      opType = 1;
    }
    SmallVector<Value, 3> offsets;
    SmallVector<Value, 3> sizes;
    SmallVector<Value, 3> strides;
    auto srcSpace = srcType.getMemorySpace();
    unsigned srcSpaInt = 0;
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
      return true;
    if(load_flag){
      offsets = srcOffsets;
      sizes   = srcSizes;
      strides = srcStrides;
    }else{
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
        return false;
      }
      auto intAttr = dyn_cast<IntegerAttr>(constantOp.getValue());
      auto sizeInt = intAttr.getInt();
      sizesInt.push_back(sizeInt);
    }
    // Get the buffer size of each dim
    // The size of the L2 buffer = loop tripcount  * L1 size
    auto outerloop = band[0];
    SmallVector<int64_t, 4> bufSizes; // Record the size of the L2 buffer
    SmallVector<unsigned, 4> loopIndices; // Index of the non-repetitive loops 
    SmallVector<AffineApplyOp, 4> applyOps; // Record the applyOps
    SmallVector<int, 4> tileIdx; // Index of loops in band
    unsigned rank = offsets.size();
    auto totalCount = 1;
    for (unsigned dim=0; dim < rank; dim++){
      auto offset = offsets[dim];
      auto sizeInt = sizesInt[dim];
      if(dim!=rank-1)
        bufSizes.push_back(sizeInt);
      auto defineOp = offset.getDefiningOp();
      if(!defineOp){
        llvm::errs() << "Offset not defined by any operantions!\n";
        return false;
      }
      if(dyn_cast<arith::ConstantOp>(defineOp)){
        continue;
      }else if(auto applyOp = dyn_cast<AffineApplyOp>(defineOp)){
        applyOps.push_back(applyOp);
        auto operands = applyOp.getOperands();
        for (unsigned i = 0; i < operands.size(); i++){
          auto operand = operands[i];
          auto loop = getForInductionVarOwner(operand);
          if(!loop){
            llvm::errs() << "ApplyOp has non-inductionVar operands!\n";
            return false;
          }
          auto it = llvm::find(band, loop);
          if (it != band.end()) {
            unsigned index = std::distance(band.begin(), it);
            auto itId = llvm::find(loopIndices, index);
            if (itId == loopIndices.end())
              loopIndices.push_back(index);
            tileIdx.push_back(index);
            SmallVector<Value, 4> foroperands;
            AffineMap map;
            getTripCountMapAndOperands(loop, &map, &foroperands);
            auto tripCount = map.getSingleConstantResult();
            if (!tripCount){
              llvm::errs() << "Involve loops with non-consant trip count!\n";
              return false;
            }
            totalCount = totalCount * tripCount;
          }
        }
      }else{
        llvm::errs() << "Offset defined by unsupported operations\n";
        return false;
      }
    }
    auto lastSizeInt = sizesInt[rank-1];
    bufSizes.push_back(totalCount*lastSizeInt);
    // Allocate L2 buffer before the outer point loop
    builder.setInsertionPoint(outerloop);
    auto bufName = "L2_buf" + std::to_string(cnt++);
    auto allocOp 
         = builder.create<BufferOp>(loc, MemRefType::get(bufSizes,
                                    srcType.getElementType(), AffineMap(),
                                   (int)MemorySpace::L2), bufName);
    // Create L2 Stride = 1
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    auto zeroValue = builder.create<arith::ConstantOp>(loc,indexType,zeroAttr);
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    auto oneValue = builder.create<arith::ConstantOp>(loc,indexType,oneAttr);
    SmallVector<Value> L2Strides, L2StridesL1;
    for(unsigned i=0; i< rank; i++)
      L2Strides.push_back(oneValue);
    builder.setInsertionPoint(op);
    auto zeroValL1 = builder.create<arith::ConstantOp>(loc,indexType,zeroAttr);
    auto oneValL1 = builder.create<arith::ConstantOp>(loc,indexType,oneAttr);
    for(unsigned i=0; i< rank; i++)
      L2StridesL1.push_back(oneValL1);

    // Load data from external mem to L2 buffer
    // Create loops for DMA Ops
    SmallVector<AffineForOp, 4> newDMALoops;
    if(load_flag)
      builder.setInsertionPoint(outerloop);
    else
      builder.setInsertionPointAfter(outerloop);

    // Create new loops for L3 -> L2 dma
    if(!EnablePL){
      llvm::sort(loopIndices);
    }
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
    auto newOuterDMALoop = newDMALoops[0];
    auto newInnerDMALoop = newDMALoops[newDMALoops.size()-1];
    auto newInnerDMAYiled = newInnerDMALoop.getBody()->getTerminator();
    
    SmallVector<Value, 4> L3Applys;
    SmallVector<Value, 4> oriL2Applys;
    SmallVector<Value, 4> newL2Applys;
    SmallVector<Value, 4> ivs;
    SmallVector<int64_t, 4> tripCnts;
    for (unsigned i = 0; i < applyOps.size(); i++){
      auto applyOp = applyOps[i];
      builder.setInsertionPoint(newInnerDMAYiled);
      auto *clonedOp = applyOp->clone();
      builder.insert(clonedOp);
      // Clone AffineApplyOps for L3 memory
      auto L3ApplyOp = dyn_cast<AffineApplyOp>(clonedOp);
      L3Applys.push_back(L3ApplyOp.getResult());
      
      // Create AffineApplyOps for L2 memory
      // The last dim of offset of L2 mem is defined by the loops that involve 
      // in the original offset. It should be constructed from the innermost(i0) 
      // loop to the outermost(e.g., i3). (i0 + i1 * I0 + ..) * size 
      if(i==rank-1){
        for(int idx=band.size()-1; idx>=0; idx--){
          auto itLoop = llvm::find(tileIdx, idx);
          if(itLoop != tileIdx.end()){
            auto loop = band[idx];
            SmallVector<Value, 4> foroperands;
            AffineMap map;
            getTripCountMapAndOperands(loop, &map, &foroperands); 
            auto tripCount = map.getSingleConstantResult();
            ivs.push_back(loop.getInductionVar());
            tripCnts.push_back(tripCount);
          }
        }
        AffineExpr newExpr = builder.getAffineDimExpr(0);
        for(unsigned j = 1; j < ivs.size(); j++){
          newExpr = newExpr + tripCnts[j-1] * builder.getAffineDimExpr(j);
        }
        auto newMap = AffineMap::get(ivs.size(), 0, newExpr);
        // Create L2ApplyOps in both new loops and original loops
        auto newL2ApplyOp = builder.create<AffineApplyOp>(loc, newMap, ivs);
        newL2Applys.push_back(newL2ApplyOp.getResult());
        builder.setInsertionPoint(applyOp);
        auto oriL2ApplyOp = builder.create<AffineApplyOp>(loc, newMap, ivs);
        oriL2Applys.push_back(oriL2ApplyOp.getResult());
      }else{
        newL2Applys.push_back(zeroValue);
        oriL2Applys.push_back(zeroValL1);
      }
    }
    if(opType == 0){ //DmaBroadcastOp
      builder.setInsertionPoint(newInnerDMAYiled);
      auto oldDma = builder.create<DmaOp>(loc, 
                        src, srcOffsets, srcSizes, srcStrides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        allocOp, newL2Applys, srcSizes, L2Strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      for(auto dst: dsts){
        auto defineOp = dst.getDefiningOp();
        builder.setInsertionPointAfter(defineOp);
        auto newBroadCast = builder.create<DmaBroadcastOp>(loc, 
                                  allocOp, oriL2Applys, srcSizes, L2StridesL1,
                                  dst, dstOffsets, dstSizes, dstStrides);
        if(op->hasAttr("initialize"))
          newBroadCast->setAttr("initialize", builder.getUnitAttr());
      }
      auto loadAttr = builder.getIntegerAttr(indexType, loadIdx++);
      newOuterDMALoop->setAttr("load", loadAttr);
      if(op->hasAttr("initialize")){
        oldDma->setAttr("initialize", builder.getUnitAttr());
        newOuterDMALoop->setAttr("initialize", builder.getUnitAttr());
      }
    }else if(opType == 1){ //DmaOp
      if(load_flag){ // Create L3 -> L2 DmaOp, L2 -> L1 DamOp
        builder.setInsertionPoint(newInnerDMAYiled);
        auto oldDma = builder.create<DmaOp>(loc, 
                        src, srcOffsets, srcSizes, srcStrides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        allocOp, newL2Applys, srcSizes, L2Strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
        builder.setInsertionPoint(op);
        auto newDma = builder.create<DmaOp>(loc, 
                        allocOp, oriL2Applys, srcSizes, L2StridesL1,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        dst, dstOffsets, dstSizes, dstStrides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
        auto loadAttr = builder.getIntegerAttr(indexType, loadIdx++);
        newOuterDMALoop->setAttr("load", loadAttr);
        if(op->hasAttr("initialize")){
          oldDma->setAttr("initialize", builder.getUnitAttr());
          newDma->setAttr("initialize", builder.getUnitAttr());
          newOuterDMALoop->setAttr("initialize", builder.getUnitAttr());
        }
      }else{ // Create L1 -> L2 DmaOp, L2 -> L3 DamOp
        builder.setInsertionPoint(newInnerDMAYiled);
        builder.create<DmaOp>(loc, allocOp, newL2Applys, dstSizes, L2Strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        dst, dstOffsets, dstSizes, dstStrides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
        builder.setInsertionPoint(op);
        builder.create<DmaOp>(loc, src, srcOffsets, srcSizes, srcStrides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        allocOp, oriL2Applys, dstSizes, L2StridesL1,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
        auto storeAttr = builder.getIntegerAttr(indexType, storeIdx++);
        newOuterDMALoop->setAttr("store", storeAttr);
      }
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
    return true;
  }

  // Now L2 buffer will be aligned. This pass will transpose any high 
  // dimensional array block accesses to be aligned in the L2 level. e.g.
  // x _ _ _
  // _ x _ _     ---->    x x x x (Each _ or x is a recutangular block)
  // _ _ x _
  // _ _ _ x
  bool dmaProcess(OpBuilder builder, DmaOp dmaOp,
                  unsigned& loadIdx, unsigned& storeIdx, unsigned& cnt,
                  SmallVector<AffineForOp, 6>& band){
    
    if(!L2BuffExtract(builder, dmaOp, loadIdx, storeIdx, cnt, band))
      return false;
    
    return true;
  }

  // DMABroadCast shares the same logic to extract L2 buffer and create 
  // L2 -> L1 data movement via IOPush/IOPop
  // One additional step is to split the destination of broadcast while keep the
  // Operation still broadcast. 
  bool dmaBroadCastProcess(OpBuilder builder, DmaBroadcastOp broadcast,
                           unsigned& loadIdx, unsigned& storeIdx, unsigned& cnt,
                           SmallVector<AffineForOp, 6>& band){
    if(!L2BuffExtract(builder, broadcast, loadIdx, storeIdx, cnt, band))
      return false;
    return true;
  }

  // This pass infers the L2 buffer from the adf.dma op and the corresponding
  // array partitioning loops
  bool L2BufferCreate (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
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
      unsigned loadIdx = 0;
      unsigned storeIdx = 0;
      unsigned cnt = 0;
      auto flag = arrayForOp.walk([&](Operation* op){
        if(auto dmaOp = dyn_cast<DmaOp>(op)){
          if(!dmaProcess(builder, dmaOp, loadIdx, storeIdx, cnt, band))
            return WalkResult::interrupt();
          dmaOp.erase();
        }else if(auto broadcast = dyn_cast<DmaBroadcastOp>(op)){
          if(!dmaBroadCastProcess(builder, broadcast, loadIdx, storeIdx, 
                                  cnt, band))
            return WalkResult::interrupt();
          broadcast.erase();
        }
        return WalkResult::advance();
      });
      if (flag == WalkResult::interrupt()) 
        return false;

      // Create LaunchCellOp to the outerloop and move all the operations
      // outside the cellOp
      // Find the CellOp
      CellOp cellOp = getFirstOpOfType<CellOp>(func.getBody());
      if(!cellOp)
        return true;
      auto& cellBlock = cellOp.getRegion().front();
      for (auto &op: llvm::make_early_inc_range(cellBlock)){
        if(!dyn_cast<EndCellOp>(op))
          op.moveBefore(cellOp);
      }
      auto outerLoop = band[0];
      builder.setInsertionPoint(outerLoop);
      auto cellLaunch = builder.create<LaunchCellOp>(loc, cellOp.getCellName());
      Block *cellLaunchBlock = builder.createBlock(&cellLaunch.getRegion());
      builder.setInsertionPointToEnd(cellLaunchBlock);
      auto endLaunchCell = builder.create<EndLaunchCellOp>(loc);
      outerLoop->moveBefore(endLaunchCell);
      auto attr = cellOp->getAttr("tripCount");
      cellLaunch->setAttr("tripCount", attr);
      cellOp.erase();
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

std::unique_ptr<Pass> createAriesL2BufferCreatePass(const AriesOptions &opts) {
  return std::make_unique<AriesL2BufferCreate>(opts);
}

} // namespace aries
} // namespace mlir