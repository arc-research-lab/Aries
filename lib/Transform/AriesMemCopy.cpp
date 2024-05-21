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
using namespace mlir::memref;
using namespace aries;
using namespace func;


namespace {

struct AriesMemCopy : public AriesMemCopyBase<AriesMemCopy> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    StringRef topFuncName = "top_func";
  
    if (!MemCopy(mod,topFuncName))
      signalPassFailure();
  }

private:
  bool MemCopy (ModuleOp mod,StringRef topFuncName) {
    FuncOp topFunc;
    if(!topFind(mod, topFunc, topFuncName)){
      topFunc->emitOpError("Top function not found\n");
      return false;
    }

    subviewHoist(mod, topFunc);

    return true;
  }

  //Check if the argument has been touched or not
  bool copyBack(FuncOp calleeFuncOp, unsigned index){
    auto arg = calleeFuncOp.getArgument(index);
    for (auto user : arg.getUsers()){
      if (dyn_cast<AffineStoreOp>(user))
        return true;
    }
    return false;
  }

  void subviewHoist(ModuleOp mod, FuncOp topFunc){
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    topFunc.walk([&](CallOp caller){
      auto calleeFuncOp = mod.lookupSymbol<FuncOp>(caller.getCallee());
      auto inTypes =SmallVector<Type,8>(calleeFuncOp.getArgumentTypes().begin(),
                                        calleeFuncOp.getArgumentTypes().end());
      auto outTypes = calleeFuncOp.getResultTypes();

      //Traverse the subview arg operands of the caller function
      //Allocate new memref, copy the subview to it, & deallocate it
      unsigned index = 0;
      for (auto argOperand : caller.getArgOperands()) {
        if(!dyn_cast<SubViewOp>(argOperand.getDefiningOp()))
          continue;
        auto type = dyn_cast<MemRefType>(argOperand.getType());

        //Allocate, copy & deallocate new memref before & after the function call
        builder.setInsertionPoint(caller);
        auto allocOp = builder.create<AllocOp>(loc,MemRefType::get(type.getShape(),type.getElementType()));
        builder.create<CopyOp>(loc, argOperand, allocOp);
        builder.setInsertionPointAfter(caller);
        //Copy the allocation back if it is touched in the callee
        if (copyBack(calleeFuncOp,index))
          builder.create<CopyOp>(loc, allocOp, argOperand);
        builder.create<DeallocOp>(loc, allocOp);

        //Replace the subview in the caller function to the allocOp
        caller.setOperand(index, allocOp);

        //Change the argument types of callee
        inTypes[index] = allocOp.getType();
        auto arg = calleeFuncOp.getArgument(index++);
        arg.setType(allocOp.getType());
      }

      // Update the callee function type.
      calleeFuncOp.setType(builder.getFunctionType(inTypes, outTypes));

    });
  }


};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesMemCopyPass() {
  return std::make_unique<AriesMemCopy>();
}

} // namespace aries
} // namespace mlir