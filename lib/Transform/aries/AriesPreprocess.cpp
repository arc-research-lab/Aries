#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#define DEBUG_TYPE "aries-preprocess"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::affine;

namespace {

struct AriesPreprocess 
       : public AriesPreprocessBase<AriesPreprocess> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!preprocess(mod))
      signalPassFailure();
    PassManager pm(&getContext());
    pm.addPass(createCanonicalizerPass());
    pm.addPass(createCSEPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
  }

private:
  // Annotate the output arguments
  void outAnnotate(ModuleOp mod, OpBuilder builder, FuncOp topFunc){
    // Traverse the adf.func op and collect the output arg
    DenseMap<FuncOp, SmallVector<int64_t, 4>> funcIds;
    for (auto func: mod.getOps<FuncOp>()){
      if(!func->hasAttr("adf.func"))
        continue;
      SmallVector<int64_t, 4> ids;
      func.walk([&](DmaOp op){
        auto dst = op.getDst();
        unsigned index = 0;
        for(auto arg : func.getArguments()){
          if(arg == dst){
            auto it = llvm::find(ids, index);
            if(it == ids.end()){
              ids.push_back(index);
              break;
            }
          }
          index++;
        }
      });
      funcIds[func] = ids;
    }

    SmallVector<Attribute, 4> attrs;
    // Record the output arguments at the top
    for (auto call: topFunc.getOps<CallOp>()){
      auto func = mod.lookupSymbol<FuncOp>(call.getCallee());
      if(call.getCallee() != func.getName())
        continue;
      if(!func->hasAttr("adf.func")){
        llvm::errs() << "None adf.func is called in topFunc\n";
        signalPassFailure();
      }
      auto ids = funcIds[func];
      for(auto id: ids){
        unsigned idx = 0;
        auto dst = call.getOperand(id);
        auto defineOp = dst.getDefiningOp();
        Value operand;
        //TODO::Handle more defining operations
        if(!defineOp){
          operand= dst;
        }else if(auto castOp = dyn_cast<memref::CastOp>(defineOp)){
          operand = castOp.getSource();
        }
        for(auto arg : topFunc.getArguments()){
          if(arg == operand){
            auto intAttr = builder.getI32IntegerAttr(idx);
            if(!llvm::is_contained(attrs, intAttr)){
              attrs.push_back(intAttr);
              break;
            }
          }
          idx++;
        }
      }
    }
    auto outAttrs = builder.getArrayAttr(attrs);
    topFunc->setAttr("outArgs",outAttrs);
  }

  // Clone the original functions for host emission
  void preprocess(ModuleOp mod, OpBuilder builder, FuncOp topFunc){
    auto loc = builder.getUnknownLoc();
    auto topName = topFunc.getName();
    auto hostFunc = dyn_cast<FuncOp>(topFunc->clone());
    auto hostName = topName.str() + "_host";
    hostFunc->setAttr("top_host", builder.getUnitAttr());
    auto nameAttr = builder.getStringAttr(topName.str());
    hostFunc->setAttr("origin_func", nameAttr);
    hostFunc->removeAttr("top_func");
    hostFunc.setName(hostName);
    builder.setInsertionPointAfter(topFunc);
    builder.insert(hostFunc);
    builder.setInsertionPoint(hostFunc);
    SmallVector<std::string, 4> strList;
    for(auto caller: hostFunc.getOps<CallOp>()){
      auto func = mod.lookupSymbol<FuncOp>(caller.getCallee());
      auto funcName = func.getName();
      auto newAttr = builder.getStringAttr(funcName.str());
      auto newName = funcName.str() + "_host";
      auto it = llvm::find(strList, newName);
      if(it != strList.end()){
        caller.setCallee(newName);
        caller->setAttr("origin_func", newAttr);
        caller->removeAttr("adf.func");
        continue;
      }
      strList.push_back(newName);
      auto inTypes =SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                        func.getArgumentTypes().end());
      auto outTypes =SmallVector<Type, 8>(func.getResultTypes().begin(),
                                          func.getResultTypes().end());
      auto funcType 
        = builder.getFunctionType(inTypes, outTypes);
      auto newFunc = builder.create<FuncOp>(loc, newName, funcType);
      newFunc.setVisibility(SymbolTable::Visibility::Private);
      newFunc->setAttr("origin_func", newAttr);
      caller.setCallee(newName);
      caller->setAttr("origin_func", newAttr);
      caller->removeAttr("adf.func");
    }
  }
  
  // This pass mainly 
  // 1) Preserves the original func info; 
  // 2) Anotate the output arguments; 
  // 3) Add the info for memref with dynamic size.
  bool preprocess (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    FuncOp topFunc;
    if(!topFind(mod, topFunc, "top_func"))
      return true;
    outAnnotate(mod, builder, topFunc);
    preprocess(mod, builder, topFunc);
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPreprocessPass() {
  return std::make_unique<AriesPreprocess>();
}

} // namespace aries
} // namespace mlir