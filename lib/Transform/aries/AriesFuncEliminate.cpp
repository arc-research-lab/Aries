#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/OperationSupport.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-func-eliminate"

using namespace mlir;
using namespace aries;
using namespace mlir::aries::adf;

namespace {

struct AriesFuncEliminate : public AriesFuncEliminateBase<AriesFuncEliminate> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
  
    if (!FuncEliminate(mod))
      signalPassFailure();
  }

private:
  bool compareFunctions(FuncOp funcA, FuncOp funcB) {
    return OperationEquivalence::isRegionEquivalentTo(
        &funcA.getRegion(), &funcB.getRegion(),
        OperationEquivalence::Flags::IgnoreLocations);
  }
  void funcGroup(SmallVector<FuncOp, 4> funcs,
        SmallVector<SmallVector<FuncOp, 4>>& groups){
    // Group the funcs
    for(auto func : funcs){
      // Check if the loop can be grouped to any exisiting groups
      bool grouped = false;
      for(auto& group : groups){
        for(auto newFunc : group){
          if(func == newFunc)
            continue;
          if(compareFunctions(func, newFunc)){
            group.push_back(func);
            grouped = true;
            break;
          }
        }
        if(grouped)
          break;
      }
      // If the loop haven't been added to any group, create a new group
      if(!grouped){
        SmallVector<FuncOp, 4> newGroup;
        newGroup.push_back(func);
        groups.push_back(newGroup);
      }
    }
  }

  // For each func group only keep the first func
  // Need to replace the caller with template mark and erase the old callee
  void funcMerge(OpBuilder builder, FuncOp topPLFunc, 
                 SmallVector<SmallVector<FuncOp, 4>>& groups){
    auto loc = builder.getUnknownLoc();
    auto indexType = builder.getIndexType();
    for(auto group : groups){
      auto firstFunc = group[0];
      firstFunc->setAttr("template", builder.getUnitAttr());
      auto firstName = firstFunc.getName();
      auto inTypes = SmallVector<Type,8>(firstFunc.getArgumentTypes().begin(),
                                         firstFunc.getArgumentTypes().end());
      auto outTypes =SmallVector<Type, 8>(firstFunc.getResultTypes().begin(),
                                        firstFunc.getResultTypes().end());
      SmallVector<Value, 16> operands;
      CallOp firstCall;
      SmallVector<CallOp, 16> calls; 
      // Set the first func as the first instance
      unsigned index = 0;
      topPLFunc.walk([&](CallOp call){
        auto callName = call.getCallee();
        if(callName != firstName)
          return WalkResult::advance();
        auto attr = builder.getIntegerAttr(indexType, index++);
        call->setAttr("template", attr);
        operands.append(call.getOperands().begin(), call.getOperands().end());
        firstCall = call;
        calls.push_back(call);
        return WalkResult::interrupt();
      });
      for(auto func : group){
        if(func == firstFunc)
          continue;
        inTypes.append(func.getArgumentTypes().begin(),
                       func.getArgumentTypes().end());
        outTypes.append(func.getResultTypes().begin(),
                        func.getResultTypes().end());
        auto funcName = func.getName();
        topPLFunc.walk([&](CallOp call){
          auto callName = call.getCallee();
          if(callName != funcName)
            return WalkResult::advance();
          auto attr = builder.getIntegerAttr(indexType, index++);
          call->setAttr("template", attr);
          call.setCallee(firstName);
          operands.append(call.getOperands().begin(), call.getOperands().end());
          calls.push_back(call);
          return WalkResult::interrupt();
        });
      }
      // Create new callOp
      auto newfuncName = firstName.str() + "_top";
      builder.setInsertionPoint(firstCall);
      builder.create<CallOp>(loc, newfuncName, outTypes, operands);

      // Create new function that include all the calls
      auto newFuncType = builder.getFunctionType(inTypes, outTypes);
      builder.setInsertionPointAfter(firstFunc);
      auto newFunc = builder.create<FuncOp>(loc, newfuncName, newFuncType);
      newFunc->setAttr("adf.pl",builder.getUnitAttr());
      newFunc->setAttr("inline",builder.getBoolAttr(false));
      auto destBlock = newFunc.addEntryBlock();
      builder.setInsertionPointToEnd(destBlock);
      auto returnOp = builder.create<ReturnOp>(loc);

      // Move calls into new func
      for(auto call : calls)
        call->moveBefore(returnOp);

      // Update the references in the newFunc after move
      auto num_arg = destBlock->getNumArguments();
      for (unsigned i = 0; i < num_arg; ++i) {
        auto sourceArg = operands[i];
        auto destArg = destBlock->getArgument(i);
        sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
            return newFunc->isProperAncestor(use.getOwner());
        });
      }
    }
  }

  bool hasCaller(ModuleOp& mod, FuncOp func) {
    auto funcName = func.getName();
    auto flag = false;
    mod.walk([&](CallOp call){
      if(call.getCallee() == funcName){
        flag = true;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    return flag;
  }
  // Eliminate unused funcs
  void funcClean(ModuleOp mod){
    for (auto func : llvm::make_early_inc_range(mod.getOps<FuncOp>())) {
      if(func->getAttr("top_func") || func->getAttr("top_host") ||
         func->getAttr("origin_func") || func->getAttr("adf.func"))
        continue;
      if (!hasCaller(mod, func)) {
        func.erase();
      }
    }
  }

  // This is a work around pass to eliminate functions that share the same
  // functionality. Need to generalize it using formal verification.
  // This pass only carefully checks the affine.load and affine.store ops. 
  // For other ops, only do general check e.g. the name and type.
  bool FuncEliminate (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    // Collect send and receive funcs
    SmallVector<FuncOp, 4> sendFuncs;
    SmallVector<FuncOp, 4> receiveFuncs;
    SmallVector<FuncOp, 4> loadFuncs;
    SmallVector<FuncOp, 4> storeFuncs;
    FuncOp topPLFunc;
    mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.pl"))
        return WalkResult::advance();
      auto plAttr = func->getAttr("adf.pl");
      if(auto boolAttr = dyn_cast<BoolAttr>(plAttr))
        if(boolAttr.getValue())
          topPLFunc = func;
      if(func->hasAttr("send"))
        sendFuncs.push_back(func);
      else if(func->hasAttr("receive"))
        receiveFuncs.push_back(func);
      else if(func->hasAttr("load"))
        loadFuncs.push_back(func);
      else if(func->hasAttr("store"))
        storeFuncs.push_back(func);
      else
        return WalkResult::advance();
      return WalkResult::advance();
    });
    if(!topPLFunc)
      return true;
    SmallVector<SmallVector<FuncOp, 4>> sendGroups;
    SmallVector<SmallVector<FuncOp, 4>> receiveGroups;
    SmallVector<SmallVector<FuncOp, 4>> loadGroups;
    SmallVector<SmallVector<FuncOp, 4>> storeGroups;
    funcGroup(sendFuncs, sendGroups);
    funcGroup(receiveFuncs, receiveGroups);
    funcGroup(loadFuncs, loadGroups);
    funcGroup(storeFuncs, storeGroups);
    funcMerge(builder, topPLFunc, sendGroups);
    funcMerge(builder, topPLFunc, receiveGroups);
    funcMerge(builder, topPLFunc, loadGroups);
    funcMerge(builder, topPLFunc, storeGroups);
    funcClean(mod);
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesFuncEliminatePass() {
  return std::make_unique<AriesFuncEliminate>();
}

} // namespace aries
} // namespace mlir