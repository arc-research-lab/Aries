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

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;

namespace {

struct AriesBroadcastDetect 
      : public AriesBroadcastDetectBase<AriesBroadcastDetect> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    PassManager pm(&getContext());
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
    if (!BroadcastDetect(mod))
      signalPassFailure();
  }

private:
  bool BroadcastDetect (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      SmallVector<DmaOp, 6> dmaOps;
      func.walk([&](DmaOp op){
        dmaOps.push_back(op);
      });
      // Record the index of dmaOps that has the same source
      SmallVector<DmaOp, 6> eraseOps;
      auto dmaNum = dmaOps.size(); 
      for(unsigned i = 0; i < dmaNum; i++){
        auto dma0 = dmaOps[i];
        auto it = llvm::find(eraseOps, dma0);
        if(it != eraseOps.end())
          continue;
        // auto lastDmaOp = dma0;
        auto firstDmaOp = dma0;
        SmallVector<Value, 6> dsts;
        dsts.push_back(dma0.getDst());
        for (unsigned j = i+1; j < dmaNum; j++) {
          auto dma1 = dmaOps[j];
          if (dma0.getSrc() == dma1.getSrc() &&
              dma0.getSrcOffsets() == dma1.getSrcOffsets() &&
              dma0.getSrcSizes() == dma1.getSrcSizes() &&
              dma0.getSrcStrides() == dma1.getSrcStrides()){
            // lastDmaOp = dma1;
            eraseOps.push_back(dma1);
            dsts.push_back(dma1.getDst());
          }
        }
        auto dstSize = dsts.size();
        if(dstSize <= 1)
          continue;
        eraseOps.push_back(dma0);
        // Create DmaBroadcastOp
        builder.setInsertionPoint(dmaOps[0]);
        builder.create<DmaBroadcastOp>(loc, firstDmaOp.getSrc(),
                                       firstDmaOp.getSrcOffsets(), 
                                       firstDmaOp.getSrcSizes(),
                                       firstDmaOp.getSrcStrides(),
                                       firstDmaOp.getSrcTiles(),
                                       firstDmaOp.getSrcDims(),
                                       firstDmaOp.getSrcSteps(),
                                       firstDmaOp.getSrcWraps(),
                                       dsts, firstDmaOp.getDstOffsets(),
                                       firstDmaOp.getDstSizes(),
                                       firstDmaOp.getDstStrides(),
                                       firstDmaOp.getDstTiles(),
                                       firstDmaOp.getDstDims(),
                                       firstDmaOp.getDstSteps(),
                                       firstDmaOp.getDstWraps());
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

std::unique_ptr<Pass> createAriesBroadcastDetectPass() {
  return std::make_unique<AriesBroadcastDetect>();
}

} // namespace aries
} // namespace mlir