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
      if(!func->hasAttr("adf.func") && !func->hasAttr("adf.pl"))
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
      func.walk([&](AffineStoreOp op){
        auto dst = op.getMemRef();
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
      // This is only for NPU
      for (auto id : ids){
        auto arg = func.getArgument(id);
        for (auto use : arg.getUsers()){
          if(auto dmaOp = dyn_cast<DmaOp>(use)){
            auto src = dmaOp.getSrc();
            if(src == arg)
              dmaOp->setAttr("initialize", builder.getUnitAttr());
          }
        }
      }
    }

    SmallVector<Attribute, 4> attrs;
    // Record the output arguments at the top
    for (auto call: topFunc.getOps<CallOp>()){
      auto func = mod.lookupSymbol<FuncOp>(call.getCallee());
      if(call.getCallee() != func.getName())
        continue;
      if(!func->hasAttr("adf.func") && !func->hasAttr("adf.pl")){
        llvm::errs() << "None adf.func or adf.pl is called in topFunc\n";
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
      auto funcType = builder.getFunctionType(inTypes, outTypes);
      auto newFunc = builder.create<FuncOp>(loc, newName, funcType);
      newFunc.setVisibility(SymbolTable::Visibility::Private);
      newFunc->setAttr("origin_func", newAttr);
      if(auto attr = func->getAttr("meta_data"))
        newFunc->setAttr("meta_data", attr);
      caller.setCallee(newName);
      caller->setAttr("origin_func", newAttr);
      caller->removeAttr("adf.func");
    }
  }
  
  // Add the shape of the dynamic memref arguments to the argument list 
  // of adf.func and mark the index by using meta_data
  /* For example:
  func.func @gemm0(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>, 
                   %arg2: memref<?x?xf32>, %arg3: index, %arg4: index, 
                   %arg5: index, %arg6: index, %arg7: index, %arg8: index) 
                   attributes {adf.func, meta_data = [[0, 6], [1, 7], [2, 8]]}
  The meta_data [0, 6] means the inner shape of %arg0 is determined by %arg6
  If meta_data [0, 6, 7] it means %arg0: memref<?x(%arg6)x(%arg7)xf32>
  */
  void addDynamicShape(ModuleOp mod, OpBuilder builder, FuncOp topFunc){
    auto loc = builder.getUnknownLoc();
    auto indexType = builder.getIndexType();
    // Add arguments and meta_data attributes to adf.func
    for (auto func: mod.getOps<FuncOp>()){
      if(!func->hasAttr("adf.func") && !func->hasAttr("adf.pl"))
        continue;
      auto &entryBlock = func.getBody().front();
      auto inTypes =SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                        func.getArgumentTypes().end());
      auto outTypes =SmallVector<Type, 8>(func.getResultTypes().begin(),
                                          func.getResultTypes().end());
      auto numInArg = inTypes.size();
      auto numNewArg = numInArg;
      SmallVector<Attribute, 4> metaData;
      for (unsigned i = 0; i < numInArg; i++){
        auto inType = inTypes[i];
        if(!dyn_cast<MemRefType>(inType))
          continue;
        auto memType = dyn_cast<MemRefType>(inType);
        if(memType.hasStaticShape())
          continue;
        auto rank = memType.getRank();
        if(rank<=1)
          continue;
        SmallVector<Attribute, 4> indices;
        indices.push_back(builder.getI64IntegerAttr(i));
        for (int64_t j = 0; j < rank - 1; ++j) {
          indices.push_back(builder.getI64IntegerAttr(numNewArg + j));
        }
        numNewArg += rank-1;
        metaData.push_back(builder.getArrayAttr(indices));
        SmallVector<IndexType, 4> indexTypes(rank-1, indexType);
        inTypes.append(indexTypes.begin(), indexTypes.end());
        for (auto t : indexTypes)
          entryBlock.addArguments(t, loc);
      }
      if(numInArg == numNewArg)
        continue;
      auto funcType  = builder.getFunctionType(inTypes, outTypes);
      func.setType(funcType);
      auto metaAttr = builder.getArrayAttr(metaData);
      func->setAttr("meta_data", metaAttr);
    }
    // Collect the funcs and inputs for creating new calls
    SmallVector<FuncOp> funcs;
    SmallVector<CallOp> calls;
    SmallVector<SmallVector<Value, 4>> inputs;
    for (auto call: topFunc.getOps<CallOp>()){
      auto func = mod.lookupSymbol<FuncOp>(call.getCallee());
      if(call.getCallee() != func.getName())
        continue;
      if(!func->hasAttr("adf.func") && !func->hasAttr("adf.pl")){
        llvm::errs() << "None adf.func or adf.pl is called in topFunc\n";
        signalPassFailure();
      }
      // Find the original memref and create constantOp as the new arguments
      // of the caller
      builder.setInsertionPoint(call);
      SmallVector<Value, 4> operands = call.getArgOperands();
      bool create_call = false;
      for(auto operand: call.getArgOperands()){
        auto type = operand.getType();
        if(!dyn_cast<MemRefType>(type))
          continue;
        auto memType = dyn_cast<MemRefType>(type);
        if(memType.hasStaticShape())
          continue;
        auto defineOp = operand.getDefiningOp();
        if(!defineOp || !dyn_cast<CastOp>(defineOp))
          continue;
        auto castOp = dyn_cast<CastOp>(defineOp);
        auto oriMem = castOp.getSource();
        auto oriMemType = dyn_cast<MemRefType>(oriMem.getType());
        if(!oriMemType.hasStaticShape()){
          llvm::errs() << "Original memref has dynamic size\n";
          signalPassFailure();
        }
        auto shape = oriMemType.getShape();
        auto rank = oriMemType.getRank();
        // Create the constantOp for the inner shapes
        for (auto i=1; i < rank; i++){
          auto shapeAttr = builder.getIndexAttr(shape[i]);
          auto shapeVal = builder.create<arith::ConstantOp>(loc, shapeAttr);
          operands.push_back(shapeVal);
          create_call = true;
        }
      }
      if(create_call){
        funcs.push_back(func);
        calls.push_back(call);
        inputs.push_back(operands);
      }
    }
    // Update the callers with the shape arguments
    for(unsigned i=0; i < funcs.size(); i++){
      auto func = funcs[i];
      auto call = calls[i];
      auto input = inputs[i];
      builder.setInsertionPoint(call);
      builder.create<CallOp>(loc, func, input);
      call.erase();
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
    addDynamicShape(mod, builder, topFunc);
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