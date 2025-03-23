#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"

using namespace mlir;
using namespace aries;
using namespace adf;

template<typename OpType>
struct DeadElim : public OpRewritePattern<OpType> {
  using OpRewritePattern<OpType>::OpRewritePattern;
  LogicalResult matchAndRewrite(OpType op, PatternRewriter &rewriter) const override {
    if (op.use_empty()) {
      rewriter.eraseOp(op);
      return success();
    }
    return failure();
  }
};

template<typename OpType>
struct DuplicateElim : public OpRewritePattern<OpType> {
  using OpRewritePattern<OpType>::OpRewritePattern;
  LogicalResult matchAndRewrite(OpType op, PatternRewriter &rewriter) const override {
    for (auto &newOp : *op->getBlock()) {
      if (&newOp == op) continue;
      if (auto newop = dyn_cast<OpType>(&newOp)) {
        auto newoperands = newop->getOperands();
        auto operands = op->getOperands();
        if(newoperands == operands){
          rewriter.eraseOp(op);
          return success();
        }
      }
    }
    return failure();
  }
};

void CreateGraphIOOp::getCanonicalizationPatterns(RewritePatternSet &results,
                                           MLIRContext *context) {
  results.add<DeadElim<CreateGraphIOOp>>(context);
}

void BufferOp::getCanonicalizationPatterns(RewritePatternSet &results,
                                           MLIRContext *context) {
  results.add<DeadElim<BufferOp>>(context);
}

void IOPushOp::getCanonicalizationPatterns(RewritePatternSet &results,
                                           MLIRContext *context) {
  results.add<DuplicateElim<IOPushOp>>(context);
}

void ConfigPLIOOp::getCanonicalizationPatterns(RewritePatternSet &results,
                                           MLIRContext *context) {
  results.add<DuplicateElim<ConfigPLIOOp>>(context);
}

void ConfigGMIOOp::getCanonicalizationPatterns(RewritePatternSet &results,
                                           MLIRContext *context) {
  results.add<DuplicateElim<ConfigGMIOOp>>(context);
}

LogicalResult DmaOp::verify(){
  auto src = dyn_cast<MemRefType>(getSrc().getType());
  auto dst = dyn_cast<MemRefType>(getDst().getType());
  auto src_rank = src.getRank();
  auto dst_rank = dst.getRank();

  if(src_rank!=dst_rank)
    return emitOpError()<<"the ranks of src and dst in DmaOp are not the same";
  if(src_rank<1)
    return emitOpError()<<"the rank of src in DmaOp is less than 1";
  if(dst_rank<1)
    return emitOpError()<<"the rank of dst in DmaOp is less than 1";
  return success();
}

void CreateGraphIOOp::setGraphIOType(Type newType) {
  auto currentType = getResult().getType();
  if (currentType == newType) {
    return;
  }
  OpBuilder builder(getContext());
  builder.setInsertionPointAfter(*this);
  CreateGraphIOOp newOp;
  if(auto plio = dyn_cast<PLIOType>(newType)){
    newOp = builder.create<CreateGraphIOOp>(getLoc(), plio, GraphIOName::PLIO);
  }else if(auto gmio = dyn_cast<GMIOType>(newType)){
    newOp = builder.create<CreateGraphIOOp>(getLoc(), gmio, GraphIOName::GMIO);
  }else if(auto port = dyn_cast<PortType>(newType)){
    newOp = builder.create<CreateGraphIOOp>(getLoc(), port, GraphIOName::PORT);
  }else{
    llvm::errs() << "Set to invalid graphio type\n";
  }
  getResult().replaceAllUsesWith(newOp.getResult());
  this->erase();
}