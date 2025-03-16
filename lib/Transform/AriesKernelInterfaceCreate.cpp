#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Dialect/Affine/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;

namespace {

struct AriesKernelInterfaceCreate 
      : public AriesKernelInterfaceCreateBase<AriesKernelInterfaceCreate> {
public:
  AriesKernelInterfaceCreate() = default;
  AriesKernelInterfaceCreate(const AriesOptions &opts) {
    EnableLink = opts.OptEnableLink;
    EnablePL = opts.OptEnablePL;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if(EnablePL)
      if (!KernelInterfaceCreate(mod))
        signalPassFailure();
    // Need to change function call to private for NPU, since its already 
    // generated
    if(!EnablePL && !EnableLink)
      linkKernel(mod);
  }

private:
  void classifyArgs(OpBuilder builder, FuncOp calleeFunc,
                    SmallVector<unsigned, 4>& inArgs,
                    SmallVector<unsigned, 4>& outArgs,
                    SmallVector<unsigned, 4>& moveArgs,
                    SmallVector<unsigned, 4>& edgeInArgs,
                    SmallVector<unsigned, 4>& wrBuffers,
                    SmallVector<MemRefType, 4>& newOutTypes){
    auto &entryBlock = calleeFunc.getBody().front();
    unsigned index = 0;
    unsigned bufIndex = 0;
    for (auto arg : calleeFunc.getArguments()) {
      if(!dyn_cast<MemRefType>(arg.getType()))
        continue;
      auto type = dyn_cast<MemRefType>(arg.getType());
      bool isWrite = false;
      bool isRead = false;
      for (auto user : arg.getUsers()){
        if (dyn_cast<AffineStoreOp>(user))
          isWrite=true;
        if (dyn_cast<AffineLoadOp>(user))
          isRead=true;
      }
      //If the mem has been read and written
      //then alloc and copy to a new buffer and return it
      builder.setInsertionPointToStart(&entryBlock);
      if(isWrite && isRead){
        inArgs.push_back(index);
        outArgs.push_back(index);
        // Record the newly created buffer that has been both W & R
        wrBuffers.push_back(bufIndex++);
        newOutTypes.push_back(type);
      }else if(isWrite){
        //If it has only been written 
        //then move it from Argument list to return value
        outArgs.push_back(index);
        moveArgs.push_back(index);
        newOutTypes.push_back(type);
        bufIndex++;
      }else{
        inArgs.push_back(index);
        edgeInArgs.push_back(index);
      }
      index++;
    }
  }

  void updateCallee(OpBuilder builder, FuncOp& newFunc,
                    SmallVector<unsigned, 4>& inArgs,
                    SmallVector<unsigned, 4>& outArgs,
                    SmallVector<unsigned, 4>& moveArgs,
                    SmallVector<unsigned, 4>& wrBuffers,
                    SmallVector<MemRefType, 4>& newOutTypes,
                    bool edgeKernel){
    auto loc = builder.getUnknownLoc();
    // Create new kernel
    SmallVector<Type,8> newInTypes;
    auto &newBlock = newFunc.getBody().front();
    auto newReturn = dyn_cast<ReturnOp>(newBlock.getTerminator());
    auto inTypes =SmallVector<Type,8>(newFunc.getArgumentTypes().begin(),
                                      newFunc.getArgumentTypes().end());
    auto outTypes =SmallVector<Type, 8>(newFunc.getResultTypes().begin(),
                                        newFunc.getResultTypes().end());
    SmallVector<Value, 4> returnOperands(newReturn.getOperands().begin(), 
                                         newReturn.getOperands().end());
    auto returnNum = newReturn.getNumOperands();
    for(auto type : newOutTypes){
      builder.setInsertionPointToStart(&newBlock);
      auto buffer = builder.create<AllocOp>(loc,MemRefType::get(
                                            type.getShape(),
                                            type.getElementType(),
                                            AffineMap(),
                                            type.getMemorySpaceAsInt()));
      outTypes.push_back(type);
      returnOperands.push_back(buffer.getResult());
    }

    SmallVector<Value, 4> initBuffers;
    SmallVector<Value, 4> loadBuffers;
    // The buffers that has been both W & R should be initialized
    for(auto idx : wrBuffers){
      initBuffers.push_back(returnOperands[returnNum + idx]);
      auto idxArg = outArgs[idx];
      loadBuffers.push_back(newFunc.getArgument(idxArg));
    }

    // Update the argument types
    for(auto i : inArgs)
      newInTypes.push_back(inTypes[i]);
    auto newFuncType = builder.getFunctionType(newInTypes, outTypes);
    newFunc.setType(newFuncType);
    // Replace all the output arguments by the newly created buffers
    unsigned index = 0;
    for (auto i : outArgs){
      auto arg = newFunc.getArgument(i);
      auto newArg = returnOperands[returnNum + index];
      arg.replaceUsesWithIf(newArg, [&](OpOperand &use){
          return newFunc->isProperAncestor(use.getOwner());
      });
      index++;
    }
    // Delete the block arguments
    // For edge kernels move all the output arguments
    // For other kernels move the write only arguments
    BitVector bv(newFunc.getArguments().size());
    for (auto i : moveArgs)
      bv.set(i);
    newBlock.eraseArguments(bv);
    // Init the W&R buffers
    // For edge kernels, initialize with zero
    // For other kernels, initialize with its corresponding input buffer
    for (unsigned i =0; i < initBuffers.size(); i++){
      auto memref = initBuffers[i];
      auto src = loadBuffers[i];
      auto type = dyn_cast<MemRefType>(memref.getType());
      //Create nested for loops
      builder.setInsertionPointAfter(memref.getDefiningOp());
      SmallVector<Value, 4> ivs;
      for (int i = 0, e = type.getRank(); i < e; ++i) {
        auto ub = type.getDimSize(i);
        auto loop = builder.create<AffineForOp>(loc, 0, ub);
        ivs.push_back(loop.getInductionVar());
        builder.setInsertionPointToStart(loop.getBody());
      }
      // Load from source and store to destination
      Value value;
      if(edgeKernel){
        auto eleType = type.getElementType();
        if (isa<IntegerType>(eleType)) {
          auto zeroAttr = builder.getIntegerAttr(eleType, 0);
          value = builder.create<arith::ConstantOp>(loc, eleType, zeroAttr);
        }else{
          auto floatType = builder.getF32Type();
          auto floatAttr = builder.getF32FloatAttr(0.0);
          value = builder.create<arith::ConstantOp>(loc, floatType, floatAttr);
        }
      }else{
        value = builder.create<AffineLoadOp>(loc, src, ivs);
      }
      builder.setInsertionPointAfter(value.getDefiningOp());
      builder.create<AffineStoreOp>(loc, value, memref, ivs);
    }
    // Create returned value
    builder.setInsertionPoint(newReturn);
    builder.create<ReturnOp>(loc, returnOperands);
    newReturn.erase();
  }

  void updateCaller(OpBuilder builder, FuncOp func, CallOp caller, 
                    SmallVector<unsigned, 4>& inArgs,
                    SmallVector<unsigned, 4>& outArgs){
    auto loc = builder.getUnknownLoc();
    auto outTypes =SmallVector<Type, 8>(func.getResultTypes().begin(),
                                        func.getResultTypes().end());
    SmallVector<Value,8> callerOps; 
    for(auto i : inArgs)
      callerOps.push_back(caller.getOperand(i));
    builder.setInsertionPoint(caller);
    auto newCallOp 
         = builder.create<func::CallOp>(loc, SymbolRefAttr::get(func), outTypes, 
                                        callerOps);
    // Update the uses of the old call results to use the new call results
    unsigned index = 0;
    for (auto argIndex : outArgs) {
      auto arg = caller.getArgOperands()[argIndex];
      // Replace the touched memref by the return value if it appears after 
      // the new caller function
      arg.replaceUsesWithIf(newCallOp.getResult(index++), [&](OpOperand &use){
        if(newCallOp->isBeforeInBlock(use.getOwner()))
          return true;
        else
          return false;
      });
    }
    // Erase the old call operation
    newCallOp->setAttr("adf.kernel", builder.getUnitAttr());
    if(auto attr = caller->getAttr("ivs"))
      if(auto arrayAttr = dyn_cast<ArrayAttr>(attr))
        newCallOp->setAttr("ivs", arrayAttr);
    if(auto attr = caller->getAttr("kernel"))
      if(auto intAttr = dyn_cast<IntegerAttr>(attr))
        if(intAttr.getInt() == 0)
          newCallOp->setAttr("kernel", intAttr);
    auto calleeName = caller.getCallee();
    auto intAttr = dyn_cast<IntegerAttr>(caller->getAttr(calleeName));
    auto newCalleeName = newCallOp.getCallee();
    newCallOp->setAttr(newCalleeName, intAttr);
    caller.erase();
  };

  // This is an experimental pass to create the output buffer
  // TODO: Tensor may be a proper representation for the arguments in adf.kernel
  bool KernelInterfaceCreate (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    PassManager pm(&getContext());
    pm.addPass(createLoopFusionPass());
    
    // First walk, tranverse the non-repeated callees and update them
    
    for(auto calleeFunc : mod.getOps<FuncOp>()){
      if (!calleeFunc->hasAttr("adf.kernel"))
        continue;
      // Get the info of original callee
      // auto &entryBlock = calleeFunc.getBody().front();
      

      // check if the callee memref type arguments have been touched or not 
      SmallVector<unsigned, 4> inArgs;
      SmallVector<unsigned, 4> outArgs;
      SmallVector<unsigned, 4> moveArgs;
      SmallVector<unsigned, 4> edgeInArgs;
      SmallVector<unsigned, 4> wrBuffers;
      SmallVector<MemRefType, 4> newOutTypes;
      classifyArgs(builder, calleeFunc, inArgs, outArgs, moveArgs, edgeInArgs, 
                   wrBuffers, newOutTypes);

      // Update edge callee
      auto op = calleeFunc->clone();
      auto oldName = calleeFunc.getName();
      auto newName = oldName.str() + "0";
      auto newFunc =  dyn_cast<FuncOp>(op);
      newFunc.setName(newName);
      newFunc->setAttr("edge_kernel", builder.getUnitAttr());
      builder.setInsertionPoint(calleeFunc);
      builder.insert(newFunc);
      updateCallee(builder, newFunc, edgeInArgs, outArgs, outArgs, 
                   wrBuffers, newOutTypes, true);

      // Update normal callee
      updateCallee(builder, calleeFunc, inArgs, outArgs, moveArgs, 
                   wrBuffers, newOutTypes, false);
      if(failed(pm.run(calleeFunc)))
        return false;
      
        // Tranverse all the adf.func
      for (auto func : mod.getOps<FuncOp>()) {
        if(!func->hasAttr("adf.func"))
          continue;
        // Tranverse all the old callers and replace with the new callers
        func.walk([&](CallOp caller){
          auto calleeName = caller.getCallee();
          if(calleeName != oldName)
            return WalkResult::advance();
          bool flag = false;
          // Change the first 
          if(auto attr = caller->getAttr("kernel")){
            if(auto intAttr = dyn_cast<IntegerAttr>(attr))
              if(intAttr.getInt() == 0)
                flag = true;
          }else{
            flag = true;
          }
          if(flag)
            updateCaller(builder, newFunc, caller, edgeInArgs, outArgs);
          else
            updateCaller(builder, calleeFunc, caller, inArgs, outArgs);

          return WalkResult::advance();
        });
      }
    }
    return true;
  }

  // When kernel linking is specified, convert the adf.kernel to private func
  void linkKernel(ModuleOp mod){
    for(auto func : mod.getOps<FuncOp>()){
      if (!func->hasAttr("adf.kernel"))
        continue;
      while (!func.getBody().empty()) {
        func.getBody().front().erase();
      }
      func.setPrivate();
    }
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesKernelInterfaceCreatePass() {
  return std::make_unique<AriesKernelInterfaceCreate>();
}

std::unique_ptr<Pass> createAriesKernelInterfaceCreatePass(
                      const AriesOptions &opts) {
  return std::make_unique<AriesKernelInterfaceCreate>(opts);
}

} // namespace aries
} // namespace mlir