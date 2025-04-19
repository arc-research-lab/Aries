#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-pl-serialize"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::affine;

namespace {

struct AriesPLSerialize 
       : public AriesPLSerializeBase<AriesPLSerialize> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
  
    if (!PLSerialize(mod))
      signalPassFailure();
  }

private:
  bool getPacksize(ArrayAttr typeAttrs, unsigned width, unsigned dis,
                   unsigned& packNum, SmallVector<int64_t, 4> idxs){
    if(!typeAttrs){
      packNum = 1;
      return true;
    }
    auto it1 = llvm::find(idxs, dis);
    if(it1 == idxs.end())
      return false;
    int64_t dis1 = std::distance(idxs.begin(),it1);
    auto typeAttr = dyn_cast<TypeAttr>(typeAttrs[dis1]);
    auto originType = typeAttr.getValue();
    auto originWidth = originType.getIntOrFloatBitWidth();
    packNum = (unsigned)(width/originWidth);
    return true;
  }

  bool memUpdate(OpBuilder builder, Block& entryBlock, AffineLoadOp load, 
                 AffineStoreOp store, unsigned packNum, 
                 SmallVector<int64_t, 4> memSizes,
                 SmallVector<BlockArgument, 8> args,
                 SmallVector<SmallVector<int64_t, 4>, 4> metaData){
    auto loc = builder.getUnknownLoc();
    Operation* newOp;
    Value mem;
    SmallVector<Value, 4> operands;
    AffineMap map;
    if(load){
      mem = load.getMemRef();
      operands = load.getMapOperands();
      map = load.getAffineMap();
      newOp = load;
    }else if(store){
      mem = store.getMemRef();
      operands = store.getMapOperands();
      map = store.getAffineMap();
      newOp = store;
    }else{
      return false;
    }
    int numRes = map.getNumResults();
    auto numDim = map.getNumDims();
    auto numSym = map.getNumSymbols();
    if(numSym>0)      
      return false;
    if(numRes<=1){
      return true;
    }else{
      // Serialize the memory access by calculating the new mem access
      // using arith dialect
      arith::ConstantOp consOp;
      if(packNum!=1){
        auto pAttr = builder.getIndexAttr(packNum);
        builder.setInsertionPointToStart(&entryBlock);
        consOp = builder.create<arith::ConstantOp>(loc, pAttr);
      }
      Value addL1; //Left op to add different memory dims
      SmallVector<Value, 4> memVals;
      for(int dimIdx = numRes-1; dimIdx >= 0; dimIdx--){
        auto res = map.getResult(dimIdx);
        // flattened form [dims, symbols, locals, constant]
        llvm::SmallVector<int64_t> flatExpr;
        if (failed(getFlattenedAffineExpr(res, numDim, numSym,&flatExpr)))
          return false;
        auto memInt = memSizes[dimIdx];
        // Save the constant mem size
        if(memInt>0){
          auto sizeAttr = builder.getIndexAttr(memInt);
          builder.setInsertionPointToStart(&entryBlock);
          auto sizeVal = builder.create<arith::ConstantOp>(loc, sizeAttr);
          memVals.push_back(sizeVal);
        }else if(dimIdx!=0){
          if(metaData.empty())
            return false;
          auto it = llvm::find(args, mem);
          if(it == args.end())
            return false;
          int64_t dis = std::distance(args.begin(), it);
          bool flag =false;
          for (auto innerVec : metaData) {
            if (!innerVec.empty() && innerVec[0] == dis) {
              int64_t sizeIdx = innerVec[dimIdx];
              auto sizeVal = args[sizeIdx];
              Value sizeNew;
              if(dimIdx == numRes-1 && consOp){
                auto pVal = consOp.getResult();
                builder.setInsertionPointAfter(consOp);
                auto divOp 
                     = builder.create<arith::DivUIOp>(loc, sizeVal, pVal);
                sizeNew = divOp.getResult();
              }else{
                sizeNew = sizeVal;
              }
              memVals.push_back(sizeNew);  
              flag = true;
              break;
            }
          }
          // If the memref argument with dynamic size is not annotated
          if(!flag){
            llvm::errs() << "Find dynamic memref arguments not annotated\n";
            return false;
          }
        }
        builder.setInsertionPoint(newOp);
        // Handle constant in map
        auto consInt = flatExpr.back();
        Value addL0; //Left op to add one memory dim
        if(consInt != 0){
          auto consAttr = builder.getIndexAttr(consInt);
          addL0 = builder.create<arith::ConstantOp>(loc, consAttr);
        }
        for(unsigned dim = 0; dim < numDim; dim++){
          auto stride = flatExpr[dim];
          auto operand = operands[dim];
          if(stride==0)
            continue;
          Value mulRes;
          if(stride==1){
            mulRes = operand;
          }else{
            auto mulL = operand;
            auto mulRAttr = builder.getIndexAttr(stride);
            auto mulR = builder.create<arith::ConstantOp>(loc, mulRAttr);
            auto mul = builder.create<arith::MulIOp>(loc, mulL, mulR);
            mulRes = mul.getResult();
          }
          Value addRes;
          if(!addL0){
            addRes = mulRes;
          }else{
            auto addR = mulRes;
            auto add = builder.create<arith::AddIOp>(loc, addL0, addR);
            addRes = add.getResult();
          }
          addL0 = addRes;
        }
        Value addRes1;
        if(!addL1){
          addRes1 = addL0;
        }else{
          auto mulL1 = addL0;
          for(int idx=0; idx < (numRes-1-dimIdx); idx++){
            auto mulR1 = memVals[idx];
            auto mul1 = builder.create<arith::MulIOp>(loc, mulL1, mulR1);
            mulL1 = mul1.getResult();
          }
          auto add1 = builder.create<arith::AddIOp>(loc, addL1, mulL1);
          addRes1 = add1.getResult();
        }
        addL1 = addRes1;
      }
      if(load){
        auto loadNew = builder.create<LoadOp>(loc, mem, ValueRange{addL1});
        load.getResult().replaceAllUsesWith(loadNew.getResult());
        load.erase();
      }else{
        auto val = store.getValue();
        builder.create<StoreOp>(loc, val, mem, ValueRange{addL1});
        store.erase();
      }
    }
    return true;
  }

  void castUpdate(OpBuilder builder, MemRefType newType, Value arg, bool flag){
    auto loc = builder.getUnknownLoc();
    for(auto use : arg.getUsers()){
      if (auto castOp = dyn_cast<CastOp>(use)) {
        auto res = castOp.getResult();
        auto resType = dyn_cast<MemRefType>(res.getType());
        if(flag){
          if(resType && !resType.hasStaticShape()){
            res.replaceAllUsesWith(arg);
            castOp.erase();
            break;
          }
        }else{
          if(resType && !resType.hasStaticShape()){
            builder.setInsertionPoint(castOp);
            auto newCast = builder.create<CastOp>(loc, newType, arg);
            res.replaceAllUsesWith(newCast);
            castOp.erase();
            break;
          }
        }
      }
    }
  }

  // This function will update the arguments with dynamic shape in adf.pl 
  // top_func, origin_func and top_host funcs
  // Then update the uses of these arguments, now handle the affine.load/store
  // ops and CastOps
  // TODO:: May need to deal with other ops that uses the updated arg
  // May need to handle the definingOp of caller, since the callee has been
  // updated, now assumes the updated operands are all in block argument or 
  // defined by CastOp
  bool typeUpdate(OpBuilder builder, FuncOp func){
    // Traverse the arguments and replace the ones with dynamic shape
    auto inTypes =SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                      func.getArgumentTypes().end());
    auto outTypes = func.getResultTypes();
    auto args =SmallVector<BlockArgument, 8>(func.getArguments().begin(),
                                             func.getArguments().end());
    auto idxAttrs = func->getAttrOfType<ArrayAttr>("mem_idx");
    auto typeAttrs = func->getAttrOfType<ArrayAttr>("mem_type");
    auto& entryBlock = func.getBody().front();
    SmallVector<int64_t, 4> idxs;
    if(idxAttrs){
      for (auto attr : idxAttrs) {
        if (auto intAttr = dyn_cast<IntegerAttr>(attr)){
          idxs.push_back(intAttr.getInt());
        }
      }
    }
    SmallVector<SmallVector<int64_t, 4>, 4> metaData;
    // Tranverse the meta_data and put it into the pl_func
    auto metaAttr= func->getAttrOfType<ArrayAttr>("meta_data");
    if (metaAttr) {
      for (auto rowAttr : metaAttr) {
        if (auto rowArrayAttr = dyn_cast<ArrayAttr>(rowAttr)) {
          SmallVector<int64_t, 4> row;
          for (auto element : rowArrayAttr) {
            if (auto intAttr = dyn_cast<IntegerAttr>(element)) {
              row.push_back(intAttr.getInt());
            }
          }
          metaData.push_back(row);
        }
      }
    }
    // Update the callee function type.
    SmallVector<int64_t, 4> argIds;
    for(unsigned i=0; i < inTypes.size(); i++){
      auto inType = inTypes[i];
      auto memType = dyn_cast<MemRefType>(inType); 
      if(!memType)
        continue;
      auto memAttr = memType.getMemorySpace();
      if(memAttr){
        auto IntAttr = dyn_cast<IntegerAttr>(memAttr);
        if(!IntAttr || IntAttr.getInt()!=(int)MemorySpace::L3)
          continue;
      }
      auto eleType = memType.getElementType();
      auto newType = MemRefType::get({ShapedType::kDynamic},eleType);
      // The top_host and top_func has static memory size
      // In top_host, it needs to keep the shape 
      // In top_func, it needs to change to dynamic size
      if(memType.hasStaticShape()){
        auto numElem = memType.getNumElements();
        if(func->hasAttr("origin_func"))
          inTypes[i] = MemRefType::get({numElem},eleType);
        else
          inTypes[i] = newType;
      }else{
        inTypes[i] = newType;
      }
      argIds.push_back(i);
    }
    func.setType(builder.getFunctionType(inTypes, outTypes));
    // For private functions return directly
    if(func.getVisibility() == SymbolTable::Visibility::Private)
      return true;
    
    // Update the block argument type and update the affine.load/store op that
    // uses the argument
    for (auto argId : argIds){
      auto arg = func.getArgument(argId);
      auto memType = dyn_cast<MemRefType>(arg.getType());
      SmallVector<int64_t, 4> memSizes(memType.getShape());
      auto eleType = memType.getElementType();
      auto width = eleType.getIntOrFloatBitWidth();
      // Update argument type
      auto newType = inTypes[argId];
      arg.setType(newType);
      // Get the pack number
      unsigned packNum;
      if(!getPacksize(typeAttrs, width, argId, packNum, idxs)){
        llvm::errs() << "Find dynamic memref not in the arguments\n";
        return false;
      }
      // Update the affine.load/affine.store that uses the arg
      // TODO: Handle other operations
      for (auto use: llvm::make_early_inc_range(arg.getUsers())){
        if(dyn_cast<CallOp>(use)){
          continue;
        }else if(auto load = dyn_cast<AffineLoadOp>(use)){
          AffineStoreOp store;
          if(!memUpdate(builder, entryBlock, load, store, packNum, memSizes, 
             args, metaData)){
            return false;
          }
        }else if(auto store = dyn_cast<AffineStoreOp>(use)){
          AffineLoadOp load;
          if(!memUpdate(builder, entryBlock, load, store, packNum, memSizes, 
             args, metaData)){
            return false;
          }
        }else if(auto castOp = dyn_cast<CastOp>(use)){
          // For castOp in top_func, need to replace it with the updated arg
          // For castOp in top_host need to create new cast using new arg
          auto res = castOp.getResult();
          if(func->hasAttr("top_func")){ 
            res.replaceAllUsesWith(arg);
            use->erase();
          }else{
            builder.setInsertionPoint(castOp);
            auto loc = builder.getUnknownLoc();
            auto newType = MemRefType::get({ShapedType::kDynamic}, eleType);
            auto newCast = builder.create<CastOp>(loc, newType, arg);
            res.replaceAllUsesWith(newCast);
            use->erase();
          }
        }else{
          llvm::errs() << "Argument with dynamic size is used by other ops\n";
          return false;
        }
      }
    }
    return true;
  }

  // This pass will serialize all the memref arguments of the top function
  // that has dynamic size. This pass will serialize the affine.load and
  // affine.store that uses the argument. And will update the memref in all the
  // arguments of the parent functions.
  bool PLSerialize (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    for (auto func: mod.getOps<FuncOp>()){
      if(!func->hasAttr("adf.pl")   && !func->hasAttr("adf.func") &&
         !func->hasAttr("top_func") && !func->hasAttr("origin_func"))
        continue;
      if(!typeUpdate(builder, func))
        return false;
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPLSerializePass() {
  return std::make_unique<AriesPLSerialize>();
}

} // namespace aries
} // namespace mlir