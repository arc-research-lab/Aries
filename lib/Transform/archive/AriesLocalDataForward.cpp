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

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;

struct DMAForward: public OpRewritePattern<DmaOp>{
DMAForward(MLIRContext *context)
      : OpRewritePattern<DmaOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(
    DmaOp op, PatternRewriter &rewriter) const override {

    auto ConSrc = op.getSrc();
    SmallVector<Value> src_offsets=op.getSrcOffsets();
    SmallVector<Value> src_sizes  =op.getSrcSizes();
    SmallVector<Value> src_strides=op.getSrcStrides();
    SmallVector<Value> src_tiles = op.getSrcTiles();
    SmallVector<Value> src_dims  = op.getSrcDims();
    SmallVector<Value> src_steps = op.getSrcSteps();
    SmallVector<Value> src_wraps = op.getSrcWraps();

    auto ConDst = op.getDst();
    SmallVector<Value> dst_offsets=op.getDstOffsets();
    SmallVector<Value> dst_sizes  =op.getDstSizes();
    SmallVector<Value> dst_strides=op.getDstStrides();
    SmallVector<Value> dst_tiles = op.getDstTiles();
    SmallVector<Value> dst_dims  = op.getDstDims();
    SmallVector<Value> dst_steps = op.getDstSteps();
    SmallVector<Value> dst_wraps = op.getDstWraps();
    
    if(op->getAttr("finish")){
      rewriter.eraseOp(op);
      return success();
    }

    if(auto readAttr = op->getAttr("read")){
      auto intRAttr = dyn_cast<IntegerAttr>(readAttr);
      if(!intRAttr)
        return success();
      auto RIndex = intRAttr.getInt();
      if(RIndex<=0)
        return success();
      for(auto use: ConSrc.getUsers()){
        if(auto dmaop = dyn_cast<DmaOp>(use)){
          auto writeAttr = dmaop->getAttr("write");
          SmallVector<Value> Wdst_offsets=dmaop.getDstOffsets();
          SmallVector<Value> Wdst_sizes  =dmaop.getDstSizes();
          SmallVector<Value> Wdst_strides=dmaop.getDstStrides();
          SmallVector<Value> Wdst_tiles = dmaop.getDstTiles();
          SmallVector<Value> Wdst_dims  = dmaop.getDstDims();
          SmallVector<Value> Wdst_steps = dmaop.getDstSteps();
          SmallVector<Value> Wdst_wraps = dmaop.getDstWraps();
          if(writeAttr
             && src_offsets == Wdst_offsets
             && src_sizes   == Wdst_sizes
             && src_strides == Wdst_strides
             && src_tiles   == Wdst_tiles
             && src_dims    == Wdst_dims 
             && src_steps   == Wdst_steps
             && src_wraps   == Wdst_wraps){
            auto intWAttr = dyn_cast<IntegerAttr>(writeAttr);
            auto WIndex = intWAttr.getInt();
            if(WIndex == RIndex -1){
              auto src = dmaop.getSrc();
              SmallVector<Value> Rsrc_offsets=dmaop.getSrcOffsets();
              SmallVector<Value> Rsrc_sizes  =dmaop.getSrcSizes();
              SmallVector<Value> Rsrc_strides=dmaop.getSrcStrides();
              SmallVector<Value> Rsrc_tiles = dmaop.getSrcTiles();
              SmallVector<Value> Rsrc_dims  = dmaop.getSrcDims();
              SmallVector<Value> Rsrc_steps = dmaop.getSrcSteps();
              SmallVector<Value> Rsrc_wraps = dmaop.getSrcWraps();
              rewriter.setInsertionPointAfter(op);
              rewriter.replaceOpWithNewOp<DmaOp>
              (op, src,  Rsrc_offsets, Rsrc_sizes, Rsrc_strides,
               Rsrc_tiles, Rsrc_dims, Rsrc_steps, Rsrc_wraps,
               ConDst, dst_offsets,  dst_sizes,  dst_strides,
               dst_tiles, dst_dims, dst_steps, dst_wraps);
              dmaop->removeAttr("write");
              dmaop->setAttr("finish",rewriter.getUnitAttr());
              return success();
            }
          }
        }
      }
    }else if(auto writeAttr = op->getAttr("write")){
      auto intWAttr = dyn_cast<IntegerAttr>(writeAttr);
      if(!intWAttr)
        return success();
      auto WIndex = intWAttr.getInt();
      for(auto use: ConDst.getUsers()){
        if(auto dmaop = dyn_cast<DmaOp>(use)){
          auto readAttr = dmaop->getAttr("read");
          SmallVector<Value> Rsrc_offsets=dmaop.getSrcOffsets();
          SmallVector<Value> Rsrc_sizes  =dmaop.getSrcSizes();
          SmallVector<Value> Rsrc_strides=dmaop.getSrcStrides();
          SmallVector<Value> Rsrc_tiles = dmaop.getSrcTiles();
          SmallVector<Value> Rsrc_dims  = dmaop.getSrcDims();
          SmallVector<Value> Rsrc_steps = dmaop.getSrcSteps();
          SmallVector<Value> Rsrc_wraps = dmaop.getSrcWraps();
          if(readAttr
             && dst_offsets == Rsrc_offsets
             && dst_sizes   == Rsrc_sizes  
             && dst_strides == Rsrc_strides
             && dst_tiles   == Rsrc_tiles
             && dst_dims    == Rsrc_dims 
             && dst_steps   == Rsrc_steps
             && dst_wraps   == Rsrc_wraps){
            auto intRAttr = dyn_cast<IntegerAttr>(readAttr);
            auto RIndex = intRAttr.getInt();
            if(WIndex == RIndex - 1){
              auto dst = dmaop.getDst();
              SmallVector<Value> Rdst_offsets=dmaop.getDstOffsets();
              SmallVector<Value> Rdst_sizes  =dmaop.getDstSizes();
              SmallVector<Value> Rdst_strides=dmaop.getDstStrides();
              SmallVector<Value> Rdst_tiles = dmaop.getDstTiles();
              SmallVector<Value> Rdst_dims  = dmaop.getDstDims();
              SmallVector<Value> Rdst_steps = dmaop.getDstSteps();
              SmallVector<Value> Rdst_wraps = dmaop.getDstWraps();
              rewriter.setInsertionPointAfter(dmaop);
              rewriter.replaceOpWithNewOp<DmaOp>
              (op, ConSrc,src_offsets, src_sizes,  src_strides,
                   src_tiles, src_dims, src_steps, src_wraps,
                   dst,   Rdst_offsets,Rdst_sizes, Rdst_strides,
                   Rdst_tiles, Rdst_dims, Rdst_steps, Rdst_wraps);
              dmaop->removeAttr("read");
              dmaop->setAttr("finish",rewriter.getUnitAttr());
              return success();
            }
          }
        }
      }
    }
    return success();
  }
};

namespace {

struct AriesLocalDataForward 
      : public AriesLocalDataForwardBase<AriesLocalDataForward> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!LocalDataForward(mod))
      signalPassFailure();
  }

private:

  bool LocalDataForward (ModuleOp mod) {
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
      RewritePatternSet patterns(context);
      patterns.add<DMAForward>(patterns.getContext());
      (void)applyPatternsGreedily(mod, std::move(patterns));

      func.walk([&](DmaOp dmaOp){
        if(dmaOp->hasAttr("initialize"))
          dmaOp.erase();
      });
    }

    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesLocalDataForwardPass() {
  return std::make_unique<AriesLocalDataForward>();
}

} // namespace aries
} // namespace mlir