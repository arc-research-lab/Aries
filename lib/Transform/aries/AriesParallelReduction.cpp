#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-parallel-reduction"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;

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

struct AriesParallelReduction 
      : public AriesParallelReductionBase<AriesParallelReduction> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!parallelReduce(mod))
      signalPassFailure();
  }

private:

  bool parallelReduce (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    // Tranverse all the adf.func
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
      SmallVector<DmaOp, 6> dmaOps;
      func.walk([&](DmaOp op){
        if(op->hasAttr("accumulator"))
          dmaOps.push_back(op);
      });
      // Use customized hash map here, the key involves many values this could
      // be optimized in the future
      DenseMap<SmallVector<Value, 6>, SmallVector<DmaOp, 4>> dmaGroups;
      for (auto dmaOp : dmaOps){
        Value dest = dmaOp.getDst();
        SmallVector<Value, 6> vars;
        vars.push_back(dest);
        vars.append(dmaOp.getDstOffsets().begin(), dmaOp.getDstOffsets().end());
        vars.append(dmaOp.getDstSizes().begin(), dmaOp.getDstSizes().end());
        vars.append(dmaOp.getDstStrides().begin(), dmaOp.getDstStrides().end());
        vars.append(dmaOp.getDstTiles().begin(), dmaOp.getDstTiles().end());
        vars.append(dmaOp.getDstDims().begin(), dmaOp.getDstDims().end());
        vars.append(dmaOp.getDstSteps().begin(), dmaOp.getDstSteps().end());
        vars.append(dmaOp.getDstWraps().begin(), dmaOp.getDstWraps().end());
        dmaGroups[vars].push_back(dmaOp);
      }
      SmallVector<DmaOp, 6> eraseOps;
      // Process each group of DMA operations to reduce the same destination
      for (auto &group : dmaGroups) {
        auto &dmaOps = group.second;
        auto numDma = dmaOps.size();
        if(numDma<=1)
          continue;
        auto itFirst = llvm::find_if(dmaOps, [&](const DmaOp &op) {
          auto attr = dyn_cast<IntegerAttr>(op->getAttr("accumulator"));
          auto intVal = attr.getInt();
          return intVal == 0;
        });
        if (itFirst == dmaOps.end())
          llvm::errs() << "First reduction in the chain hasn't been found\n";
        auto firstDmaOp = *itFirst;
        for(unsigned i=1; i<numDma; i++){
          auto it = llvm::find_if(dmaOps, [&](const DmaOp &op) {
            auto attr = dyn_cast<IntegerAttr>(op->getAttr("accumulator"));
            auto intVal = attr.getInt();
            return intVal == i;
          });
          if(it == dmaOps.end())
            llvm::errs() << "Reduction in the chain hasn't been found\n";
          auto curDmaOp = firstDmaOp;
          auto nxtDmaOp = *it;
          builder.setInsertionPoint(curDmaOp);
          auto src = curDmaOp.getSrc();
          auto dst = nxtDmaOp.getSrc();
          SmallVector<Value> srcOffsets = curDmaOp.getSrcOffsets();
          SmallVector<Value> srcSizes   = curDmaOp.getSrcSizes();
          SmallVector<Value> srcStrides = curDmaOp.getSrcStrides();
          SmallVector<Value> srcTiles   = curDmaOp.getSrcTiles();
          SmallVector<Value> srcDims    = curDmaOp.getSrcDims();
          SmallVector<Value> srcSteps   = curDmaOp.getSrcSteps();
          SmallVector<Value> srcWraps   = curDmaOp.getSrcWraps();
          SmallVector<Value> dstOffsets = nxtDmaOp.getSrcOffsets();
          SmallVector<Value> dstSizes   = nxtDmaOp.getSrcSizes();
          SmallVector<Value> dstStrides = nxtDmaOp.getSrcStrides();
          SmallVector<Value> dstTiles   = nxtDmaOp.getSrcTiles();
          SmallVector<Value> dstDims    = nxtDmaOp.getSrcDims();
          SmallVector<Value> dstSteps   = nxtDmaOp.getSrcSteps();
          SmallVector<Value> dstWraps   = nxtDmaOp.getSrcWraps();
          builder.create<DmaOp>(loc, src, srcOffsets, srcSizes, srcStrides, 
                                srcTiles, srcDims, srcSteps, srcWraps, 
                                dst, dstOffsets, dstSizes, dstStrides, dstTiles,
                                dstDims, dstSteps, dstWraps);
          eraseOps.push_back(curDmaOp);
          firstDmaOp = nxtDmaOp;
        }
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

std::unique_ptr<Pass> createAriesParallelReductionPass() {
  return std::make_unique<AriesParallelReduction>();
}

} // namespace aries
} // namespace mlir