#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Analysis/Liveness.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::affine;

namespace {

struct AriesPLDataflow 
       : public AriesPLDataflowBase<AriesPLDataflow> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
  
    if (!PLDataflow(mod))
      signalPassFailure();
  }

private:
  // This function simplifies the upperbound affine map in the form of 
  // affine_map<()[s0] -> (s0 ceildiv 64)> to affine_map<(d0) -> (d0)>
  void simplifyUb(OpBuilder builder, FuncOp func){
    auto loc = builder.getUnknownLoc();
    std::vector<SmallVector<AffineForOp, 6>> bands;
    getTileableBands(func, &bands);
    for (auto tileBand : bands){
      auto context = builder.getContext();
      auto outerLoop = tileBand[0];
      builder.setInsertionPoint(outerLoop);
      for(auto loop : tileBand){
        if(loop.hasConstantUpperBound())
          continue;
        auto ubMap = loop.getUpperBoundMap();
        unsigned numDim = ubMap.getNumDims();
        unsigned numSym = ubMap.getNumSymbols();
        if (ubMap.getNumResults() != 1){
          llvm::errs() << "Doesn't support affineMap with multi results\n";
          return;
        }
        auto expr = dyn_cast<AffineBinaryOpExpr>(ubMap.getResult(0));
        if (!expr || expr.getKind() != AffineExprKind::CeilDiv){
          llvm::errs() << "Besides constant upperbound, only support ceildiv\n";
          return;
        }
        // Extract the divisor and symbol
        auto divisorExpr = dyn_cast<AffineConstantExpr>(expr.getRHS());
        if (!divisorExpr)
          return;
        auto symbolExpr = dyn_cast<AffineSymbolExpr>(expr.getLHS());
        if (!symbolExpr)
          return;
        unsigned symbolPos = symbolExpr.getPosition();
        auto s0 = loop.getUpperBoundOperands()[numDim+symbolPos];
        // Replace the AffineExprKind::CeilDiv using arith dialect
        /* Code snippet for ceilDiv
        auto divInt = divisorExpr.getValue();
        auto divAttr = builder.getIndexAttr(divInt);
        auto divVal = builder.create<arith::ConstantOp>(loc, divAttr);
        auto ceilAttr = builder.getIndexAttr(divInt-1);
        auto ceilVal = builder.create<arith::ConstantOp>(loc, ceilAttr);
        auto temp = builder.create<arith::AddIOp>(loc, s0, ceilVal);
        auto ubVal = builder.create<arith::DivUIOp>(loc, temp, divVal);
        */
        // Currently use floor div directly
        auto divInt = divisorExpr.getValue();
        auto divAttr = builder.getIndexAttr(divInt);
        auto divVal = builder.create<arith::ConstantOp>(loc, divAttr);
        auto ubVal = builder.create<arith::DivUIOp>(loc, s0, divVal);
        // Replace the loop upper bound with the computed value
        SmallVector<Value, 4> newOperands{(loop.getUpperBoundOperands())};
        newOperands.push_back(ubVal);
        AffineExpr ubExpr = {builder.getAffineSymbolExpr(numSym)};
        auto newMap = AffineMap::get(numDim, numSym+1, ubExpr, context);
        loop.setUpperBound(newOperands, newMap);
      }
    }
  }

  // Tranverse all the forOps marked by "load,store,send,receive" and split
  // them into new functions marked by adf.pl
  void PLFuncSplit(OpBuilder builder, FuncOp plFunc){
    auto loc = builder.getUnknownLoc();
    for (auto forOp: llvm::make_early_inc_range(plFunc.getOps<AffineForOp>())){
      SmallVector<Operation*, 4> Ops;
      SmallVector<Value> liveins(forOp.getOperands());
      auto liveness = Liveness(forOp);
      for (auto livein: liveness.getLiveIn(forOp.getBody())){
        if (!forOp->isProperAncestor(livein.getParentBlock()->getParentOp())){
          auto definedOp = livein.getDefiningOp();
          if(definedOp){
            if(auto allocOp = dyn_cast<AllocOp>(definedOp)){
              auto type = dyn_cast<MemRefType>(livein.getType());
              if(auto memorySpace = type.getMemorySpace()){
                auto intAttr = dyn_cast<IntegerAttr>(memorySpace);
                if(intAttr && intAttr.getInt() == (int)MemorySpace::L2){
                  Ops.push_back(definedOp);
                  continue;
                }
              }
            }else if(auto constOp = dyn_cast<arith::ConstantOp>(definedOp)){
              Ops.push_back(definedOp);
              continue;
            }
          }
          liveins.push_back(livein);
        }
      }
      // Reorder the input arguments to be aligned with the previous function
      SmallVector<Value, 6> inputs;
      for(auto arg : plFunc.getArguments()){
        auto it = llvm::find(liveins,arg);
        if(it != liveins.end())
          inputs.push_back(arg);
      }
      SmallVector<Attribute, 4> newMetaArray;
      addMetaData(builder, plFunc, inputs, newMetaArray);
      for(auto livein : liveins){
        auto it = llvm::find(inputs, livein);
        if(it == inputs.end())
          inputs.push_back(livein);
      }
      
      builder.setInsertionPoint(plFunc);
      std::string funcName;
      std::string funcAttr;
      if(auto Attr = forOp->getAttrOfType<IntegerAttr>("load")){
        if(auto cntAttr = forOp->getAttrOfType<IntegerAttr>("func")){
          funcName = "load" + std::to_string(Attr.getInt()) + "_" 
                             + std::to_string(cntAttr.getInt());
          forOp->removeAttr("func");
        }else{
          funcName = "load" + std::to_string(Attr.getInt());
        }
        forOp->removeAttr("load");
        funcAttr = "load";
      }else if(auto Attr = forOp->getAttrOfType<IntegerAttr>("store")){
        if(auto cntAttr = forOp->getAttrOfType<IntegerAttr>("func")){
          funcName = "store" + std::to_string(Attr.getInt()) + "_" 
                             + std::to_string(cntAttr.getInt());
          forOp->removeAttr("func");
        }else{
          funcName = "store" + std::to_string(Attr.getInt());
        }
        forOp->removeAttr("store");
        funcAttr = "store";
      }else if(auto Attr = forOp->getAttrOfType<IntegerAttr>("send")){
        funcName = "send" + std::to_string(Attr.getInt());
        funcAttr = "send";
        forOp->removeAttr("send");
      }else if(auto Attr = forOp->getAttrOfType<IntegerAttr>("receive")){
        funcName = "receive" + std::to_string(Attr.getInt());
        forOp->removeAttr("receive");
        funcAttr = "receive";
      }else{
       continue; 
      }
      auto funcType = builder.getFunctionType(ValueRange(inputs),TypeRange({}));
      auto newfunc = builder.create<FuncOp>(
                                  builder.getUnknownLoc(), funcName, funcType);
      newfunc->setAttr("adf.pl",builder.getUnitAttr());
      newfunc->setAttr("inline",builder.getBoolAttr(false));
      newfunc->setAttr(funcAttr, builder.getUnitAttr());
      if(!newMetaArray.empty()){
        auto arrayAttr = builder.getArrayAttr(newMetaArray);
        newfunc->setAttr("meta_data", arrayAttr);
      }
      auto destBlock = newfunc.addEntryBlock();
      builder.setInsertionPointToEnd(destBlock);
      auto returnOp = builder.create<ReturnOp>(builder.getUnknownLoc());

      // Move L2 buffer/Constant definition inside each function
      builder.setInsertionPointToStart(destBlock);
      SmallVector<Operation*, 4> newOps;
      for(auto *op : Ops){
        auto newOp = op->clone();
        builder.insert(newOp);
        newOps.push_back(newOp);
      }

      // Move the entire block of outerPointLoop before the returnOp
      builder.setInsertionPointToEnd(destBlock);
      forOp->moveBefore(returnOp);

      // Create the function CallOp in plFunc
      auto topReturnOp = plFunc.getBody().front().getTerminator();
      builder.setInsertionPoint(topReturnOp);
      builder.create<CallOp>(loc, newfunc, inputs);

      // Update the references in the newfunc after move
      auto numArg = destBlock->getNumArguments();
      for (unsigned i = 0; i < numArg; ++i) {
        auto sourceArg = inputs[i];
        auto destArg = destBlock->getArgument(i);
        sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
            return newfunc->isProperAncestor(use.getOwner());
        });
      }
      auto opSize = newOps.size();
      for (unsigned i = 0; i < opSize; ++i) {
        auto oldVal = Ops[i]->getResult(0);
        auto newVal = newOps[i]->getResult(0);
        oldVal.replaceUsesWithIf(newVal,[&](OpOperand &use){
            return newfunc->isProperAncestor(use.getOwner());
        });
      }
      // Replace upperbound of the for loops in each pl function
      simplifyUb(builder, newfunc);
    }
  }

  // This function annotate the original types of the memref arguments to each
  // extracted function
  void annotateType(ModuleOp mod, OpBuilder builder, FuncOp func){
    auto funcArgs = func.getArguments();
    auto idxAttrs = func->getAttrOfType<ArrayAttr>("mem_idx");
    auto typeAttrs = func->getAttrOfType<ArrayAttr>("mem_type");
    if(!idxAttrs)
      return;
    SmallVector<int64_t, 4> idxs;
    for (auto attr : idxAttrs) {
      if (auto intAttr = dyn_cast<IntegerAttr>(attr)){
        idxs.push_back(intAttr.getInt());
      }
    }
    for(auto call : func.getOps<CallOp>()){
      auto callee = mod.lookupSymbol<FuncOp>(call.getCallee());
      // Continue when already assigned the types
      if(callee->hasAttr("mem_idx"))
        continue;
      SmallVector<unsigned, 4> argIdxs;
      SmallVector<Attribute, 4> argAttrs;
      for(unsigned i=0; i < call.getNumOperands(); i++){
        auto operand = call.getOperand(i);
        // Find if operand is the arguments of the func
        auto it = llvm::find(funcArgs, operand);
        if(it == funcArgs.end())
          continue;
        int64_t dis = std::distance(funcArgs.begin(),it);
        // Find if the argument is marked with an arttibute
        auto it1 = llvm::find(idxs, dis);
        if(it1 == idxs.end())
          continue;
        int64_t dis1 = std::distance(funcArgs.begin(),it);
        auto attr = typeAttrs[dis1];
        argIdxs.push_back(i);
        argAttrs.push_back(attr);
      }
      if(argIdxs.empty())
        continue;
      SmallVector<Attribute, 4> newIdxAttrs;
      for (int idx : argIdxs) 
        newIdxAttrs.push_back(builder.getI32IntegerAttr(idx));
      auto arrayAttr = builder.getArrayAttr(newIdxAttrs);
      callee->setAttr("mem_idx", arrayAttr);
      auto arrayTypeAttr = builder.getArrayAttr(argAttrs);
      callee->setAttr("mem_type", arrayTypeAttr);
    }
  }

  // Hoist the loops beyond loops marked by reduction, 
  // this is to implement the output stationary dataflow
  // If has reduction, then need to initialize L2 buffer marked by init
  void hoistBufferStore(OpBuilder builder, FuncOp plFunc){
    auto loc = builder.getUnknownLoc();
    auto indexType = builder.getIndexType();
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    
    AffineForOp plforOp;
    plFunc.walk([&](AffineForOp op){
      if(op->hasAttr("Array_Partition")){
        plforOp = op;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    if(!plforOp)
      return;
    SmallVector<AffineForOp, 6> tileBand;
    getLoopBandFromInnermost(plforOp, tileBand);
    auto innerloop = tileBand[tileBand.size()-1];
    auto reverseBand = tileBand;
    std::reverse(reverseBand.begin(), reverseBand.end());
    // Check forOps marked by hoist
    SmallVector<AffineForOp, 2> forOps;
    for(auto forOp : innerloop.getOps<AffineForOp>())
      if(forOp->hasAttr("hoist")){
        forOp->removeAttr("hoist");
        forOps.push_back(forOp);
      }
    if(!forOps.size())
      return;
    // Check and find the outmost reduction loop
    AffineForOp finalLoop;
    unsigned index = 0;
    unsigned indexRed = 0;
    for(auto loop : reverseBand){
      if(loop->hasAttr("reduction")){
        finalLoop = loop;
        if(index>indexRed)
          assert("Detected loop doesn't support output stationary");
        indexRed++;
      }
      index++;
    }
    if(!finalLoop)
      return;
    for(auto forOp : forOps)
      forOp->moveAfter(finalLoop);
    // Initialize output buffer as zero
    for(auto alloc : plFunc.getOps<AllocOp>()){
      if(alloc->hasAttr("init")){
        alloc->removeAttr("init");
        auto memref = alloc.getResult();
        auto type = dyn_cast<MemRefType>(memref.getType());
        auto eleType = type.getElementType();
        auto rank = type.getRank();
        SmallVector<Value> sizes;
        SmallVector<AffineForOp, 4> newLoops;
        builder.setInsertionPointAfter(alloc);
        SmallVector<Value, 4> ivs;
        for(unsigned i = 0; i < rank; i++){
          auto size = type.getDimSize(i);
          auto newForOp = builder.create<AffineForOp>(loc, 0, size, 1);
          newLoops.push_back(newForOp);
          ivs.push_back(newForOp.getInductionVar());
          builder.setInsertionPointToStart(newForOp.getBody());
        }
        auto newInnerLoop = newLoops[newLoops.size()-1];
        newInnerLoop->setAttr("pipeline_ii", oneAttr);
        auto newInnerYiled = newInnerLoop.getBody()->getTerminator();
        builder.setInsertionPoint(newInnerYiled);
        Value value;
        if (isa<IntegerType>(eleType)) {
          auto zeroAttr = builder.getIntegerAttr(eleType, 0);
          value = builder.create<arith::ConstantOp>(loc, eleType, zeroAttr);
        }else{
          auto floatType = builder.getF32Type();
          auto floatAttr = builder.getF32FloatAttr(0.0);
          value = builder.create<arith::ConstantOp>(loc, floatType, floatAttr);
        }
        builder.create<AffineStoreOp>(loc, value, memref, ivs);
      }
    }
  }

  bool PLDataflow (ModuleOp mod) {
    auto builder = OpBuilder(mod);

    mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.pl"))
        return WalkResult::advance();
      auto attr = func->getAttr("adf.pl");
      if(!dyn_cast<BoolAttr>(attr))
        return WalkResult::advance();
      func->setAttr("dataflow",builder.getUnitAttr());
      func->setAttr("inline",builder.getBoolAttr(false));
      // For each loop in adf.pl, create a new func marked by adf.pl
      PLFuncSplit(builder, func);
      annotateType(mod, builder, func);
      return WalkResult::advance();
    });

    mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.pl"))
        return WalkResult::advance();
      hoistBufferStore(builder, func);
      return WalkResult::advance();
    });
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPLDataflowPass() {
  return std::make_unique<AriesPLDataflow>();
}

} // namespace aries
} // namespace mlir