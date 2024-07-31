#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "llvm/Support/Debug.h"

#include "mlir/IR/Builders.h"

using namespace mlir;
using namespace aries;
using namespace mlir::affine;
using namespace mlir::arith;
using namespace mlir::memref;
using namespace func;


namespace {

struct AriesMemSubview : public AriesMemSubviewBase<AriesMemSubview> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    StringRef topFuncName = "top_func";
  
    if (!MemSubview(mod,topFuncName))
      signalPassFailure();
  }

private:
  bool MemSubview (ModuleOp mod,StringRef topFuncName) {
    FuncOp topFunc;
    if(!topFind(mod, topFunc, topFuncName)){
      topFunc->emitOpError("Top function not found\n");
      return false;
    }

    createMemsubview(mod, topFunc);

    return true;
  }

  void createMemsubview(ModuleOp mod, FuncOp topFunc){
    auto builder = OpBuilder(mod);
    auto context = mod.getContext();
    auto loc = builder.getUnknownLoc();

    topFunc.walk([&](CallOp caller){
      auto calleeFuncOp = mod.lookupSymbol<FuncOp>(caller.getCallee());

      for (auto arg : calleeFuncOp.getArguments()) {
        // Traverse the memref arguments in the callee function
        auto argType = arg.getType().dyn_cast<MemRefType>();
        if (!argType)
          continue;

        //Here assume there is only one access pattern for each memref argument
        auto affineOp = *arg.user_begin();
        SmallVector<Value, 4> operands;
        AffineMap map;

        if (auto loadOp = dyn_cast<AffineLoadOp>(affineOp)) {
          operands = SmallVector<Value, 4>(loadOp.getMapOperands());
          map = loadOp.getAffineMap();
        } else if (auto storeOp = dyn_cast<AffineStoreOp>(affineOp)) {
          operands = SmallVector<Value, 4>(storeOp.getMapOperands());
          map = storeOp.getAffineMap();
        }

        //Used to build memref.subview
        SmallVector<OpFoldResult, 4> memOffsets;
        SmallVector<OpFoldResult, 4> memSizes;
        SmallVector<OpFoldResult, 4> memStrides;
        //Traverse the operands of affine.load and affine.store
        builder.setInsertionPointToStart(&calleeFuncOp.front());
        for (auto operand: operands){
          // Get the applyOp that defines the memory access operands
          auto applyOp = dyn_cast<AffineApplyOp>(operand.getDefiningOp());
          auto applyOperands = applyOp.getOperands();
          auto applyOperandsMap = applyOp.getAffineMap();
          auto mapResult = applyOperandsMap.getResult(0);
          auto binaryExpr = dyn_cast<AffineBinaryOpExpr>(mapResult);
          SmallVector<Value, 4> newoperands;

          // TODO:: Need to handle more complexed expressions
          // Now assume the map is in form <(d0, d1) -> (d0 + d1*step)>
          // where d0 could be another experssion
          // Collect the step info which is in the left most of the AffineExpr
          auto RHS = binaryExpr.getRHS();
          if (auto binaryExpr1 = dyn_cast<AffineBinaryOpExpr>(RHS)){
            if (auto RHS1 = dyn_cast<AffineConstantExpr>(binaryExpr1.getRHS())){
              auto step = RHS1.getValue();
              memStrides.push_back(builder.getIndexAttr(step));
            }else{
              memStrides.push_back(builder.getIndexAttr(1));
            }
          }else{
            memStrides.push_back(builder.getIndexAttr(1));
          }

          //Collect the offset and size info
          for (auto applyOperand: applyOperands){
            auto definedOp = applyOperand.getParentBlock()->getParentOp();
            if (auto funcOp = dyn_cast<FuncOp>(definedOp))
              newoperands.push_back(applyOperand);
            else if (auto forOp = dyn_cast<AffineForOp>(definedOp)){
              auto size = forOp.getConstantUpperBound();
              memSizes.push_back(builder.getIndexAttr(size));
            }
          }

          //Collect the offset info
          auto LHS = binaryExpr.getLHS();
          AffineMap newMap = AffineMap::get(newoperands.size(),0, LHS, context);
          auto newApplyOp = 
               builder.create<AffineApplyOp>(loc, newMap, newoperands);
          memOffsets.push_back(newApplyOp.getResult());
          builder.setInsertionPointAfter(newApplyOp);
        }

        // Create the SubViewOp with dynmic and entries and inferred result type
        auto subviewOutputType =
        SubViewOp::inferResultType(arg.getType().dyn_cast<MemRefType>(),
                                   memOffsets, memSizes, memStrides)
                                  .dyn_cast<MemRefType>();
        auto subview =
            builder.create<SubViewOp>(loc, 
                                      subviewOutputType, arg, memOffsets, 
                                      memSizes, memStrides);

        arg.replaceAllUsesExcept(subview.getResult(), subview);
      }

      //Replace the memory access and erase the affine.apply op 
      calleeFuncOp.walk([&](AffineApplyOp applyOp){
        auto applyOperands = applyOp.getOperands();
        for (auto applyOperand: applyOperands){
          auto definedOp = applyOperand.getParentBlock()->getParentOp();
          if (dyn_cast<AffineForOp>(definedOp)){
            applyOp.replaceAllUsesWith(applyOperand);
            applyOp.erase();
            break;
          }
        }
      });
    });
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesMemSubviewPass() {
  return std::make_unique<AriesMemSubview>();
}

} // namespace aries
} // namespace mlir