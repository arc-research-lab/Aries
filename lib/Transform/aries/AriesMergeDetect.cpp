#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "mlir/Dialect/Affine/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-merge-detect"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;


namespace llvm {
template <>
struct DenseMapInfo<SmallVector<Value, 6>> {
    // Return an empty key (used internally by DenseMap)
    static inline SmallVector<Value, 6> getEmptyKey() {
      return SmallVector<Value, 6>{Value()};
    }

    // Return a tombstone key (used internally by DenseMap)
    static inline SmallVector<Value, 6> getTombstoneKey() {
      return SmallVector<Value, 6>{Value(nullptr)};
    }

    // Hash function for SmallVector<Value, 6>
    static unsigned getHashValue(const SmallVector<Value, 6> &vec) {
      return llvm::hash_combine_range(vec.begin(), vec.end());
    }

    // Equality comparator for SmallVector<Value, 6>
    static bool isEqual(const SmallVector<Value, 6> &lhs, 
                        const SmallVector<Value, 6> &rhs) {
      return lhs == rhs;
    }
};
}

namespace {

struct AriesMergeDetect 
      : public AriesMergeDetectBase<AriesMergeDetect> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    PassManager pm(&getContext());
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
    if (!MergeDetect(mod))
      signalPassFailure();
  }

private:
  // Collect the affine.applys of the first offest
  void collectApply(SmallVectorImpl<DmaOp>& dmaOps,
                    SmallVectorImpl<AffineApplyOp>& applyOps){
    for(auto dmaOp : dmaOps){
      SmallVector<Value> offsets = dmaOp.getDstOffsets();
      auto offset = offsets.front();
      auto defineOp = offset.getDefiningOp();
      if(!defineOp && !dyn_cast<AffineApplyOp>(defineOp)){
        llvm::errs() << "Find offest not defined by AffineApplyOp\n";
        signalPassFailure();
      }
      auto applyOp = dyn_cast<AffineApplyOp>(defineOp);
      applyOps.push_back(applyOp);
    }
  }

  /// Analyze a list of affine.apply operations and find the longest chain of
  /// operations where each subsequent op differs from the previous one by a 
  /// constant offset in their affine expressions. The function only considers
  /// affine.apply ops with a single result.
  ///
  /// The function proceeds in three major steps:
  /// 1. For each pair of affine.apply ops, canonicalize their affine maps and
  ///    operands, and attempt to compute the difference between their results.
  ///    If the difference simplifies to a constant, store the (opA, opB, diff).
  /// 2. Using the collected constant-difference pairs, try to form the longest
  ///    possible chain such that each link in the chain advances by the same 
  ///    constant value.
  /// 3. Report the longest such chain and its constant difference.
  void analyzeAffineApplyChains(SmallVectorImpl<AffineApplyOp>& affineOps,
                                SmallVectorImpl<unsigned>& orderedIndices,
                                int64_t& commonDiff){
    std::vector<std::tuple<AffineApplyOp, AffineApplyOp, int64_t>> diffs;
    // Compare every pair and compute constant diffs
    for (unsigned i = 0; i < affineOps.size(); ++i) {
      for (unsigned j = 0; j < affineOps.size(); ++j) {
        if (i == j) continue;
        auto a = affineOps[i];
        auto b = affineOps[j];
        AffineMap mapA = a.getAffineMap();
        AffineMap mapB = b.getAffineMap();
        SmallVector<Value> operandsA = a.getOperands();
        SmallVector<Value> operandsB = b.getOperands();
        fullyComposeAffineMapAndOperands(&mapA, &operandsA);
        fullyComposeAffineMapAndOperands(&mapB, &operandsB);
        canonicalizeMapAndOperands(&mapA, &operandsA);
        canonicalizeMapAndOperands(&mapB, &operandsB);
        // Only handle single-result affine maps
        if (mapA.getNumResults() != 1 || mapB.getNumResults() != 1)
          continue;
        AffineExpr diffExpr = mapB.getResult(0) - mapA.getResult(0);
        AffineExpr simplified = simplifyAffineExpr(
            diffExpr,
            std::max(mapA.getNumDims(), mapB.getNumDims()),
            std::max(mapA.getNumSymbols(), mapB.getNumSymbols()));
  
        if (auto cst = dyn_cast<AffineConstantExpr>(simplified)) {
          diffs.emplace_back(a, b, cst.getValue());
        }
      }
    }
    // Build the longest chain with the same constant difference
    SmallVector<AffineApplyOp> bestChain;
    for (auto &[start, next, diff] : diffs) {
      SmallVector<AffineApplyOp> tempChain = {start, next};
      int64_t currentDiff = diff;
      bool extended = true;
      while (extended) {
        extended = false;
        for (auto &[a, b, d] : diffs) {
          if (a == tempChain.back() && d == currentDiff) {
            tempChain.push_back(b);
            extended = true;
          }
        }
      }
      if (tempChain.size() > bestChain.size()) {
        bestChain = tempChain;
        commonDiff = currentDiff;
      }
    }

    if (bestChain.empty() || commonDiff == 0) {
      llvm::errs() << "Find output dmas can't form a chain\n";
      signalPassFailure();
    }
    // Reverse to make ascending
    if (commonDiff < 0) {
      std::reverse(bestChain.begin(), bestChain.end());
      commonDiff = -commonDiff;
    }

    // Map bestChain back to indices in affineOps
    for (AffineApplyOp op : bestChain) {
      auto it = llvm::find(affineOps, op);
      if (it != affineOps.end()) {
        orderedIndices.push_back(it - affineOps.begin());
      }
    }
    // llvm::outs() << "Found chain of size " << bestChain.size()
    //              << " with constant difference = " << commonDiff << "\n";
    // llvm::outs() << "Chain indices in affineOps: ";
    // for (unsigned idx : orderedIndices) {
    //   llvm::outs() << idx << " ";
    // }
    // llvm::outs() << "\n";
  }

  // Check if the constant diff equal the size, if so create new size
  void createSize(OpBuilder builder, SmallVectorImpl<DmaOp>& dmaOps, 
                  unsigned commonDiff, arith::ConstantOp& newVal){
    auto loc = builder.getUnknownLoc();
    auto dmaOp = dmaOps[0];
    auto size = dmaOp.getDstSizes().front();
    auto defineOp = size.getDefiningOp();
    if(!defineOp && !dyn_cast<arith::ConstantOp>(defineOp)){
      llvm::errs() << "Find size not defined by ConstantOp\n";
      signalPassFailure();
    }
    int64_t sizeInt;
    auto constOp = dyn_cast<arith::ConstantOp>(defineOp);
    auto attr = constOp.getValue(); // This returns a mlir::Attribute
  
    if (auto intAttr = dyn_cast<IntegerAttr>(attr)){
      sizeInt = intAttr.getInt();
      if(sizeInt != commonDiff){
        llvm::errs() << "Find commonDiff != size\n";
        signalPassFailure();
      }
    }else{
      llvm::errs() << "Find non-integer size in DmaOp\n";
      signalPassFailure();
    }

    builder.setInsertionPoint(constOp);
    auto newSize = commonDiff * dmaOps.size();
    auto indexAttr = builder.getIndexAttr(newSize);
    newVal = builder.create<arith::ConstantOp>(loc, indexAttr);
  }

  // This function applies a 1d merge of the output dmas
  // The output dmas only differs the first offset and with the same rest of the
  // slice and traversal information could be merged together
  // e.g. adf.dma(%2, %arg2[%6, %8] [%c64, %c64])
  // e.g. adf.dma(%5, %arg2[%9, %8] [%c64, %c64])
  // e.g. adf.dma.merge({%2, %5}, %arg2[%6, %8] [%c128, %c64])
  bool MergeDetect (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      // Collect all the dmaOps from L1->L3 (store)
      SmallVector<DmaOp, 6> dmaOps;
      func.walk([&](DmaOp op){
        auto dstDMA = op.getDst();
        auto dstType = dyn_cast<MemRefType>(dstDMA.getType());
        auto dstSpace = dstType.getMemorySpaceAsInt();
        if(!dstSpace && dstSpace == (int)MemorySpace::L3)
          dmaOps.push_back(op);
      });
      // Record the index of dmaOps that has the same source
      SmallVector<DmaOp, 6> eraseOps;
      // Group the dmaOps that only differ in the first offset
      DenseMap<SmallVector<Value, 6>, SmallVector<DmaOp, 4>> dmaGroups;
      for (auto dmaOp : dmaOps){
        Value dest = dmaOp.getDst();
        SmallVector<Value, 6> vars;
        vars.push_back(dest);
        SmallVector<Value> offsets = dmaOp.getDstOffsets();
        if (offsets.size()>1){
          auto allButFirst = SmallVector<Value>(
            std::next(offsets.begin()), offsets.end());
          vars.append(allButFirst.begin(), allButFirst.end());
        }
        vars.append(dmaOp.getDstSizes().begin(), dmaOp.getDstSizes().end());
        vars.append(dmaOp.getDstStrides().begin(), dmaOp.getDstStrides().end());
        vars.append(dmaOp.getDstTiles().begin(), dmaOp.getDstTiles().end());
        vars.append(dmaOp.getDstDims().begin(), dmaOp.getDstDims().end());
        vars.append(dmaOp.getDstSteps().begin(), dmaOp.getDstSteps().end());
        vars.append(dmaOp.getDstWraps().begin(), dmaOp.getDstWraps().end());
        dmaGroups[vars].push_back(dmaOp);
      }
      for (auto &group : dmaGroups) {
        auto &dmaOps = group.second;
        auto numDma = dmaOps.size();
        if(numDma<=1)
          continue;
        // Check if the dmaOps can be merged or not
        SmallVector<AffineApplyOp, 4> applyOps;
        SmallVector<unsigned, 4> orderedIndices;
        int64_t commonDiff = 0;
        arith::ConstantOp newVal;
        collectApply(dmaOps, applyOps);
        analyzeAffineApplyChains(applyOps, orderedIndices, commonDiff);
        createSize(builder, dmaOps, commonDiff, newVal);
        SmallVector<Value, 4> srcs;
        for (unsigned idx : orderedIndices) {
          srcs.push_back(dmaOps[idx].getSrc());
        }
        auto firstDma = dmaOps[orderedIndices[0]];
        auto lastDma = dmaOps[orderedIndices[orderedIndices.size()-1]];
        builder.setInsertionPoint(lastDma);
        auto dst = firstDma.getDst();
        SmallVector<Value> srcOffsets = firstDma.getSrcOffsets();
        SmallVector<Value> srcSizes   = firstDma.getSrcSizes();
        SmallVector<Value> srcStrides = firstDma.getSrcStrides();
        SmallVector<Value> srcTiles   = firstDma.getSrcTiles();
        SmallVector<Value> srcDims    = firstDma.getSrcDims();
        SmallVector<Value> srcSteps   = firstDma.getSrcSteps();
        SmallVector<Value> srcWraps   = firstDma.getSrcWraps();
        SmallVector<Value> dstOffsets = firstDma.getDstOffsets();
        SmallVector<Value> dstSizes   = firstDma.getDstSizes();
        dstSizes[0] = newVal;
        SmallVector<Value> dstStrides = firstDma.getDstStrides();
        SmallVector<Value> dstTiles   = firstDma.getDstTiles();
        SmallVector<Value> dstDims    = firstDma.getDstDims();
        SmallVector<Value> dstSteps   = firstDma.getDstSteps();
        SmallVector<Value> dstWraps   = firstDma.getDstWraps();
        auto merge = builder.create<DmaMergeOp>(loc, srcs, srcOffsets, srcSizes, 
                              srcStrides, srcTiles, srcDims, srcSteps, srcWraps, 
                              dst, dstOffsets, dstSizes, dstStrides, dstTiles,
                              dstDims, dstSteps, dstWraps);
        if(firstDma->hasAttr("accumulator"))
          merge->setAttr("accumulator", builder.getUnitAttr());
        if(auto attr = firstDma->getAttr("reduction"))
          merge->setAttr("reduction", attr);
        eraseOps.append(dmaOps.begin(), dmaOps.end());
      }
      // Erase the DmaOps
      for(auto op: llvm::make_early_inc_range(eraseOps))
        op.erase();
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesMergeDetectPass() {
  return std::make_unique<AriesMergeDetect>();
}

} // namespace aries
} // namespace mlir