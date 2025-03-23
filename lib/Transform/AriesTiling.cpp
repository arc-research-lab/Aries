#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-tiling"

using namespace mlir;
using namespace mlir::affine;
using namespace aries;
using namespace adf;
using namespace func;

namespace {

struct AriesTiling : public AriesTilingBase<AriesTiling> {
public:
  AriesTiling() = default;
  AriesTiling(const AriesOptions &opts) {
    TileFuncName = opts.OptTileFuncName;
    L1TileSizes=opts.OptL1TileSize;
    L2TileSizes=opts.OptL2TileSize;
    L3TileSizes=opts.OptL3TileSize;
  }
  
  void runOnOperation() override {
      auto mod = dyn_cast<ModuleOp>(getOperation());
      unsigned defaultTileSizes = 32;
      if(!applyLoopTiling(mod, defaultTileSizes))
        return signalPassFailure();
  }

private:
  // For memory with dynamic size, only reserve the celldiv at the outermost
  // band. Eliminate all the min function if one of the operand is an argument.
  // TODO: Handle cases that need padding
  bool postprocess(FuncOp func, SmallVector<AffineForOp,6> pointBand){
    for (auto loop : pointBand){
      auto ubMap = loop.getUpperBoundMap();
      // Check if the upperbound of the loop is determined by min
      auto numRes = ubMap.getNumResults();
      if(numRes != 2)
        continue;
      auto uboperands = loop.getUpperBoundOperands();
      auto numDims = ubMap.getNumDims();
      auto numSyms = ubMap.getNumSymbols();
      // Check if one of the result of the upperbound map is only determined
      // by the index argument of the function
      auto res0 = ubMap.getResult(0);
      auto res1 = ubMap.getResult(1);
      Value operand;
      AffineExpr res;
      if(isa<AffineSymbolExpr>(res0)&&!isa<AffineSymbolExpr>(res1)){
        res = res1;
        auto pos = dyn_cast<AffineSymbolExpr>(res0).getPosition();
        operand = uboperands[numDims+pos];
      }else if(!isa<AffineSymbolExpr>(res0)&&isa<AffineSymbolExpr>(res1)){
        res = res0;
        auto pos = dyn_cast<AffineSymbolExpr>(res1).getPosition();
        operand = uboperands[numDims+pos];
      }else{
        return false;
      }
      // Check if the operand is one of the argument of the function
      bool flag=false;
      for (auto arg:func.getArguments()){
        if(operand==arg){
          flag = true;
          break;
        }
      }
      // Modify the upperbound 
      if(!flag)
        return false;
      auto newMap = mlir::AffineMap::get(numDims, numSyms, res);
      loop.setUpperBoundMap(newMap);
    }
    return true;
  }
  
  // Annotate the output arguments
  void outAnnotate(OpBuilder builder, FuncOp topFunc, FuncOp func){
    SmallVector<Attribute, 4> attrs;
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
    // Mark reading output arg as initialize
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
    // Record the output arguments at the top
    for (auto call: topFunc.getOps<CallOp>()){
      if(call.getCallee() != func.getName())
        continue;
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
      if(it != strList.end())
        continue;
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

  bool applyLoopTiling(ModuleOp mod, unsigned defaultTileSizes){
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    FuncOp topFunc, func;
    if(!topFind(mod, topFunc, "top_func"))
      return true;
    for(auto tileFunc: mod.getOps<FuncOp>()){
      if(tileFunc.getName() == TileFuncName){
        func = tileFunc;
        break;
      }
    }
    if(!func)
      return true;
    outAnnotate(builder, topFunc, func);
    preprocess(mod, builder, topFunc);

    // Tile the functions specified in the command line.
    SmallVector<AffineForOp, 6> band;
    getPerfectNestedLoopBand(func.getBody(), band);
    auto bandSize = band.size();
    SmallVector<unsigned ,6> redIndeices;
    for(unsigned i=0; i < bandSize; i++){
      auto loop = band[i];
      if(loop->hasAttr("reduction")){
        redIndeices.push_back(i);
      }
    }
    // Set the default tiling fatctor
    SmallVector<unsigned,6> L1tileSizes(bandSize,defaultTileSizes);
    SmallVector<unsigned,6> L2tileSizes(bandSize,defaultTileSizes);
    // Assign received tiling factors to the tilable loop bands
    for (unsigned i = 0; i < std::min(bandSize,L1TileSizes.size()); ++i)
      L1tileSizes[i] = L1TileSizes[i];
    // Call Affine tiling functions for perfectly nested loops
    SmallVector<AffineForOp,6> L1tileBand;
    SmallVector<AffineForOp,6> L2tileBand;
    if (failed(tilePerfectlyNested(band, L1tileSizes, &L1tileBand)))
      return false;
    if(!postprocess(func, L1tileBand))
      return false;
    // L2 tiling if specified
    if(L2TileSizes.size()){
      for (unsigned i = 0; i <std::min(bandSize,L2TileSizes.size());++i)
        L2tileSizes[i] = L2TileSizes[i];
      
      SmallVector<AffineForOp, 6> blockL1tileBand(
        L1tileBand.begin(), L1tileBand.begin() + bandSize);
      
      if (failed(tilePerfectlyNested(
                            blockL1tileBand, L2tileSizes, &L2tileBand)))
        return false;
      if(!postprocess(func, L2tileBand))
        return false;
      L2tileBand[bandSize-1]->setAttr("Array_Partition", builder.getUnitAttr());
      // Mark L2 reduction loops
      for(auto idx : redIndeices){
        L2tileBand[idx]->setAttr("reduction", builder.getUnitAttr());
        L2tileBand[idx+bandSize]->setAttr("reduction", builder.getUnitAttr());
      }
      //Noralize L2 loops
      for(unsigned i =0; i < L2tileBand.size(); i++){
        auto forOp = L2tileBand[i];
        if(failed(normalizeAffineFor(forOp)))
          return false;
      }
      //Noralize L1 inner bands
      for(unsigned i = 0; i < bandSize; i++){
        auto forOp = L1tileBand[bandSize+i];
        if(failed(normalizeAffineFor(forOp)))
          return false;
      }
      // Mark L1 inner bands
      for(auto idx : redIndeices)
        L1tileBand[idx+bandSize]->setAttr("reduction", builder.getUnitAttr());
    }else{
      //Noralize L1 bands
      for(unsigned i = 0; i < L1tileBand.size(); i++){
        auto forOp = L1tileBand[i];
        if(failed(normalizeAffineFor(forOp)))
          return false;
      }
      // Mark L1 reduction loops
      for(auto idx : redIndeices){
        L1tileBand[idx]->setAttr("reduction", builder.getUnitAttr());
        L1tileBand[idx+bandSize]->setAttr("reduction", builder.getUnitAttr());
      }
    }
    PassManager pm(&getContext());
    pm.addPass(createCanonicalizerPass());
    pm.addPass(createCSEPass());
    if (failed(pm.run(func)))
      return false;

    // Create adf.cell and move inner bands to it
    auto parallelLoop = L1tileBand[bandSize];
    builder.setInsertionPoint(parallelLoop);
    auto cellName = "cell" + std::to_string(0);
    auto cellOp = builder.create<CellOp>(loc,cellName);
    Block *destBlock = builder.createBlock(&cellOp.getRegion());
    builder.setInsertionPointToEnd(destBlock);
    auto endCellOp = builder.create<EndCellOp>(cellOp->getLoc());
    // Move the entire block of outerPointLoop before the returnOp
    builder.setInsertionPointToEnd(destBlock);
    parallelLoop->moveBefore(endCellOp);
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesTilingPass() {
  return std::make_unique<AriesTiling>();
}

std::unique_ptr<Pass> createAriesTilingPass(const AriesOptions &opts) {
  return std::make_unique<AriesTiling>(opts);
}


} // namespace aries
} // namespace mlir