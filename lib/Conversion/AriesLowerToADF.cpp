#include "aries/Conversion/Passes.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "aries/Transform/Utils.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::arith;
using namespace mlir::affine;

struct AllocConvert : public OpConversionPattern<AllocOp> {
  using OpConversionPattern<AllocOp>::OpConversionPattern;
  unsigned& cnt;
  AllocConvert(MLIRContext *context, unsigned& cnt)
        : OpConversionPattern<AllocOp>(context), cnt(cnt){}
  LogicalResult matchAndRewrite(
      AllocOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
      
    auto memrefType = dyn_cast<MemRefType>(op.getMemref().getType());
    auto memSpace = memrefType.getMemorySpace();
    if (!memSpace || !dyn_cast<IntegerAttr>(memSpace))
      return failure();
    if (memrefType.getMemorySpaceAsInt() == (int)MemorySpace::L1){
      auto bufName = "L1_buf" + std::to_string(cnt++);
      rewriter.replaceOpWithNewOp<BufferOp>(op, op.getType(), bufName);
      return success();
    }else
      return failure();
    return success();
  }
};

struct DeallocConvert : public OpConversionPattern<DeallocOp> {
  using OpConversionPattern<DeallocOp>::OpConversionPattern;
  LogicalResult matchAndRewrite(
      DeallocOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
      
    rewriter.eraseOp(op);
    return success();
  }
};

struct SubViewConvert : public OpConversionPattern<SubViewOp> {
  using OpConversionPattern<SubViewOp>::OpConversionPattern;
  LogicalResult matchAndRewrite(
      SubViewOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
      
    rewriter.eraseOp(op);
    return success();
  }
};

//Create port and replace copy to/from L1 memory with the io.push
struct CopyConvert : public OpConversionPattern<CopyOp> {
  using OpConversionPattern<CopyOp>::OpConversionPattern;
  LogicalResult matchAndRewrite(
      CopyOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
    auto CopySrc = op.getSource();
    auto CopyDst = op.getTarget();

    Value src;
    SmallVector<Value> src_offsets;
    SmallVector<Value> src_sizes;
    SmallVector<Value> src_strides;
    Value dst;
    SmallVector<Value> dst_offsets;
    SmallVector<Value> dst_sizes;
    SmallVector<Value> dst_strides;

    //Check if the src memref is defined by subviewOp
    if(auto defineOp = CopySrc.getDefiningOp()){
      if (auto subViewOp = dyn_cast<SubViewOp>(defineOp)){
        src = subViewOp.getSource();
        auto indexType = rewriter.getIndexType();
        auto mixedOffsets = subViewOp.getMixedOffsets();
        for (auto offset : mixedOffsets) {
          if (auto attr = dyn_cast<Attribute>(offset)) {//static offset
            if (auto integerAttr = dyn_cast<IntegerAttr>(attr)) {
              auto offsetAttr 
                   = rewriter.getIntegerAttr(indexType, integerAttr.getInt());
              auto offsetValue 
                   = rewriter.create<arith::ConstantOp>(op->getLoc(), 
                                                        indexType, offsetAttr);
              src_offsets.push_back(offsetValue);
            }
          }else if (auto value = dyn_cast<Value>(offset)) {//dynamic offset
            src_offsets.push_back(value);
          }
        }
        for(auto size : subViewOp.getStaticSizes()){
          auto sizeAttr = rewriter.getIntegerAttr(indexType, size);
          auto sizeValue = rewriter.create<arith::ConstantOp>(op->getLoc(), 
                                                           indexType, sizeAttr);
          src_sizes.push_back(sizeValue);
        }
        for(auto stride : subViewOp.getStaticStrides()){
          auto strideAttr = rewriter.getIntegerAttr(indexType, stride);
          auto strideValue = rewriter.create<arith::ConstantOp>(op->getLoc(), 
                                                        indexType, strideAttr);
          src_strides.push_back(strideValue);
        }
      }
      else{
        src = CopySrc;
      }
    }

    if(auto defineOp = CopyDst.getDefiningOp()){
      if (auto subViewOp = dyn_cast<SubViewOp>(defineOp)){
        dst = subViewOp.getSource();
        auto indexType = rewriter.getIndexType();

        auto mixedOffsets = subViewOp.getMixedOffsets();
        for (auto offset : mixedOffsets) {
          if (auto attr = dyn_cast<Attribute>(offset)) {//static offset
            if (auto integerAttr = dyn_cast<IntegerAttr>(attr)) {
              auto offsetAttr 
                  = rewriter.getIntegerAttr(indexType, integerAttr.getInt());
              auto offsetValue 
                  = rewriter.create<arith::ConstantOp>(op->getLoc(), 
                                                       indexType, offsetAttr);
              dst_offsets.push_back(offsetValue);
            }
          }else if (auto value = dyn_cast<Value>(offset)) {//dynamic offset
            dst_offsets.push_back(value);
          }
        }

        for(auto size : subViewOp.getStaticSizes()){
          auto sizeAttr = rewriter.getIntegerAttr(indexType, size);
          auto sizeValue = rewriter.create<arith::ConstantOp>(op->getLoc(), 
                                                          indexType, sizeAttr);
          dst_sizes.push_back(sizeValue);
        }

        for(auto stride : subViewOp.getStaticStrides()){
          auto strideAttr = rewriter.getIntegerAttr(indexType, stride);
          auto strideValue = rewriter.create<arith::ConstantOp>(op->getLoc(), 
                                                        indexType, strideAttr);
          dst_strides.push_back(strideValue);
        }
      }
      else{
        dst = CopyDst;
      }
    }

    auto dmaOp = rewriter.replaceOpWithNewOp<DmaOp>(op, 
                        src, src_offsets, src_sizes, src_strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        dst, dst_offsets, dst_sizes, dst_strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
    if(op->hasAttr("initialize"))
      dmaOp->setAttr("initialize", rewriter.getUnitAttr());

    return success();
  }
};

struct AffineParallelConvert : public OpConversionPattern<AffineParallelOp> {
  using OpConversionPattern<AffineParallelOp>::OpConversionPattern;
  unsigned& index;
  AffineParallelConvert(MLIRContext *context, unsigned& index)
        : OpConversionPattern<AffineParallelOp>(context), index(index){}
  LogicalResult matchAndRewrite(
      AffineParallelOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
      
    auto lbMap = op.getLowerBoundsMap();
    auto ubMap = op.getUpperBoundsMap();
    auto steps = op.getSteps();
    rewriter.setInsertionPoint(op);
    SmallVector<AffineForOp, 4> band;
    for (unsigned i = 0; i < op.getNumDims(); ++i) {
      if(!dyn_cast<AffineConstantExpr>(lbMap.getResult(i))){
        assert("The lower bound has non-constant map\n");
        return failure();
      }
      if(!dyn_cast<AffineConstantExpr>(ubMap.getResult(i))){
        assert("The upper bound has non-constant map\n");
        return failure();
      }
      auto lowerBound 
            = dyn_cast<AffineConstantExpr>(lbMap.getResult(i)).getValue();
      auto upperBound 
            = dyn_cast<AffineConstantExpr>(ubMap.getResult(i)).getValue();
      auto step = steps[i];

      auto affineForOp = rewriter.create<AffineForOp>(
        op->getLoc(), lowerBound, upperBound, step);
      band.push_back(affineForOp);

      // Set the insertion point inside the newly created loop.
      rewriter.setInsertionPointToStart(affineForOp.getBody());
    }
    // Mark the reduction loops back
    if(op->hasAttr("redDim")){
      auto arrayAttr = dyn_cast<ArrayAttr>(op->getAttr("redDim"));
      for (auto attr : arrayAttr){
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        auto intVal = intAttr.getInt();
        band[intVal]->setAttr("reduction", rewriter.getUnitAttr());
      }
    }

    //Erase the terminator of the AffineParallelOp
    rewriter.eraseOp(&op.getBody()->back());

    //Move the body of AffineParallelOp to the innermost loop
    auto innermostLoop = band[op.getNumDims()-1];
    innermostLoop.getBody()->getOperations().splice(
        innermostLoop.getBody()->begin(), op.getBody()->getOperations());
    
    for (unsigned i = 0; i < op.getNumDims(); ++i) {
      op.getIVs()[i].replaceAllUsesWith(band[i].getInductionVar());
    }
    rewriter.eraseOp(op);
    
    //Create adf CellOp and move operations into Cell
    auto outermostLoop = band[0];
    rewriter.setInsertionPoint(outermostLoop);
    auto cellName = "cell" + std::to_string(index++);
    auto cellOp = rewriter.create<CellOp>(outermostLoop->getLoc(),cellName);
    Block *destBlock = rewriter.createBlock(&cellOp.getRegion());
    rewriter.setInsertionPointToEnd(destBlock);
    auto endCellOp = rewriter.create<EndCellOp>(cellOp->getLoc());
    
    // Move the entire block of outerPointLoop before the returnOp
    rewriter.setInsertionPointToEnd(destBlock);
    outermostLoop->moveBefore(endCellOp);

    return success();
  }
};

namespace {

struct AriesLowerToADF : public AriesLowerToADFBase<AriesLowerToADF> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());  
    if (!LowerToADF(mod))
      signalPassFailure();
  }

private:
  bool LowerToADF(ModuleOp mod) {
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      MLIRContext *context = func->getContext();
      RewritePatternSet patterns(context);
      unsigned index = 0;
      unsigned cnt = 0;
      ConversionTarget target(*context);
      target.addIllegalOp<AffineParallelOp>();
      target.addIllegalOp<DeallocOp>();
      target.addIllegalOp<CopyOp>();
      target.addIllegalOp<SubViewOp>();
      patterns.add<AffineParallelConvert>(patterns.getContext(),index);
      patterns.add<AllocConvert>(patterns.getContext(), cnt);
      patterns.add<DeallocConvert>(patterns.getContext());
      patterns.add<CopyConvert>(patterns.getContext());
      patterns.add<SubViewConvert>(patterns.getContext());
      target.addLegalOp<arith::ConstantOp>();
      target.addLegalOp<BufferOp>();
      target.addLegalOp<DmaOp>();
      target.addLegalOp<AffineApplyOp>();
      target.addLegalOp<AffineForOp>();
      target.addLegalOp<CellOp>();
      target.addLegalOp<EndCellOp>();
      target.addLegalDialect<ADFDialect>();
      target.addLegalDialect<AffineDialect>();
      if(!func->hasAttr("adf.func"))
        continue;
      if (failed(applyPartialConversion(func, target, std::move(patterns)))) {
        return false;
      }
    }

    return true;
  }

};

} // namespace


namespace mlir {
namespace aries {
namespace adf {

std::unique_ptr<Pass> createAriesLowerToADFPass() {
  return std::make_unique<AriesLowerToADF>();
}

} // namespace adf
} // namespace aries
} // namespace mlir