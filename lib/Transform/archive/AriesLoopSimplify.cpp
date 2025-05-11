#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"

using namespace mlir;
using namespace aries;
using namespace mlir::affine;
using namespace mlir::arith;
using namespace func;


namespace {

struct AriesLoopSimplify : public AriesLoopSimplifyBase<AriesLoopSimplify> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
  
    if (failed(LoopSimplify(mod)))
      signalPassFailure();
    
    PassManager pm(&getContext());
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
  }

private:
  LogicalResult  LoopSimplify(ModuleOp mod){    
    auto builder = OpBuilder(mod);
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      auto flag = func.walk([&](CallOp caller){
        auto calleeFuncOp = mod.lookupSymbol<FuncOp>(caller.getCallee());

        SmallVector<AffineForOp, 6> band;
        getNestedLoopBand(calleeFuncOp.getBody(), band);

        if (failed(checkIfHyperRectangular(band))){
          llvm::errs() << "Not recutangular nested loops!\n";
          return WalkResult::interrupt();
        }

        auto innerLoop = band[band.size()-1];
        for (auto forOp: band){
          //Check if the loops has constant trip count
          //TODO: This should work for recutangular loop nests, 
          //      but may need to extend
          SmallVector<Value, 4> operands;
          AffineMap map;
          getTripCountMapAndOperands(forOp, &map, &operands);
          if (!map.isSingleConstant()){
            llvm::errs() << "Involve loops with non-consant trip count!\n";
            return WalkResult::interrupt();
          }

          auto step = forOp.getStepAsInt();
          auto lowerBound = forOp.getLowerBound();
          auto lowerBoundMp = lowerBound.getMap();
          auto lowerBoundOperands = lowerBound.getOperands();

          // Current only support For loops with single arguments
          auto blockArgs = forOp.getBody()->getArguments();
          if (blockArgs.size()!=1){
            llvm::errs() << "The number of block arguments of the forOp" 
                         << " doesn't euqal to 1!\n" ;
            return WalkResult::interrupt();
          }
          auto blockArg = blockArgs[0];

          //Construct newAffineMaps using affine.apply and replace the old block 
          //arguments to gurantee correct memref accesses
          auto context = mod.getContext();
          builder.setInsertionPointToStart(innerLoop.getBody());
          AffineExpr newDim = getAffineDimExpr(lowerBoundMp.getNumDims(), context);
          //TODO May need to deal with lowerBoundMp with multi-results
          AffineExpr newExpr = lowerBoundMp.getResult(0) + newDim * step;
          unsigned int dimCount = lowerBoundMp.getNumDims() + 1;

          AffineMap newMap = AffineMap::get(dimCount, 0, newExpr, context);
          SmallVector<Value, 2> ApplyOperands;
          for (auto lbOperand : lowerBoundOperands)
            ApplyOperands.push_back(lbOperand);
          ApplyOperands.push_back(blockArg);
          auto applyOp = builder.create<AffineApplyOp>(builder.getUnknownLoc(),
                                                       newMap,ApplyOperands);

          blockArg.replaceAllUsesExcept(applyOp,applyOp);

          //Replace the loop bound with constant value
          auto tripCount = map.getSingleConstantResult();
          forOp.setConstantLowerBound(0);
          forOp.setStep(1);
          forOp.setConstantUpperBound(tripCount);

        }
        return WalkResult::advance();
      });

      if (flag == WalkResult::interrupt())
        return failure();
    }
    return success();
  }

};
} // namespace


namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesLoopSimplifyPass() {
  return std::make_unique<AriesLoopSimplify>();
}

} // namespace aries
} // namespace mlir