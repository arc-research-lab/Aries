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
    if (!MemCopy(mod))
      signalPassFailure();
  }

private:
  //Check if the argument has been write or not
  bool isWrite(FuncOp calleeFuncOp, unsigned index){
    auto arg = calleeFuncOp.getArgument(index);
    for (auto user : arg.getUsers()){
      if (dyn_cast<AffineStoreOp>(user))
        return true;
    }
    return false;
  }

  //Check if the argument has been write or not
  bool isRead(FuncOp calleeFuncOp, unsigned index){
    auto arg = calleeFuncOp.getArgument(index);
    for (auto user : arg.getUsers()){
      if (dyn_cast<AffineLoadOp>(user))
        return true;
    }
    return false;
  }

  bool MemCopy(ModuleOp mod){
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      func.walk([&](CallOp caller){
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

          //Allocate, copy & deallocate new memref before & after the caller
          builder.setInsertionPoint(caller);
          auto allocOp 
               = builder.create<AllocOp>(loc, MemRefType::get(type.getShape(),
                                         type.getElementType(), AffineMap(),
                                         (int)mlir::aries::adf::MemorySpace::L1));
          if (isRead(calleeFuncOp,index)){
            auto copyOp = builder.create<CopyOp>(loc, argOperand, allocOp);
            if(isWrite(calleeFuncOp,index))
              copyOp->setAttr("initialize", builder.getUnitAttr());
          }
          builder.setInsertionPointAfter(caller);
          //Copy the allocation back if it is touched in the callee
          if (isWrite(calleeFuncOp,index))
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
    return true;
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