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
  
  // Mark reading output arg as initialize (only for NPU)
  void outAnnotate(OpBuilder builder, FuncOp func){
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

  // This is a helper function to add or update attribute to an operation
  void addUpdateAtr(Operation *op, StringRef attrName, int64_t newValue){
    auto *context = op->getContext();
    Builder builder(context);

    auto attr = op->getAttr(attrName);
    if(!attr){
      SmallVector<Attribute, 1> values = {builder.getI64IntegerAttr(newValue)};
      op->setAttr(attrName, builder.getArrayAttr(values));
      return;
    }

    // If it's an IntegerAttr, convert it to an ArrayAttr 
    // with the old value and new value
    if (auto intAttr = dyn_cast<IntegerAttr>(attr)) {
      // Create an array with the existing integer and the new value
      SmallVector<Attribute, 4> values;
      values.push_back(intAttr);
      values.push_back(builder.getI64IntegerAttr(newValue));
      // Create and set the new ArrayAttr
      op->setAttr(attrName, builder.getArrayAttr(values));
    }else if(auto arrayAttr = dyn_cast<ArrayAttr>(attr)) {
      // If it's already an ArrayAttr, append the new value if it's not present
      SmallVector<Attribute, 4> values(arrayAttr.begin(), arrayAttr.end());
      // Check if the value is already present
      for (auto val : values) {
        if (auto intVal = dyn_cast<IntegerAttr>(val)) {
          if (intVal.getInt() == newValue)
            return;
        }
      }
      // Append the new value and set the updated ArrayAttr
      values.push_back(builder.getI64IntegerAttr(newValue));
      op->setAttr(attrName, builder.getArrayAttr(values));
    }
  }

  // Annotate the reduction loops
  // Now only consider hyper-rectangular access
  // For accumulator dmas, mark the loops that are not involved as reduction
  // Record the reduction in dmaOp as well
  void reductionAnnotate(OpBuilder builder, SmallVector<AffineForOp, 6> band){
    auto outerLoop = band[0];
    unsigned redCnt = 0;
    outerLoop.walk([&](DmaOp dmaOp){
      if(!dmaOp->hasAttr("accumulator"))
        return WalkResult::advance();
      // Record the index of ivs that defines the offset
      llvm::DenseSet<unsigned> ivIds;
      auto offsets = dmaOp.getDstOffsets();
      for(auto offset: offsets){
        auto defineOp = offset.getDefiningOp();
        if(!defineOp || !dyn_cast<AffineApplyOp>(defineOp))
          continue;
        auto applyOp = dyn_cast<AffineApplyOp>(defineOp);
        for(auto operand: applyOp.getOperands()){
          auto loop = getForInductionVarOwner(operand);
          if(!loop){
            llvm::errs() << "Find offset not defined by loop ivs\n";
            signalPassFailure();
          }
          auto itLoop = llvm::find(band, loop);
          if(itLoop==band.end()){
            llvm::errs() << "Find reduction loop not in the band\n";
            signalPassFailure();
          }
          auto pos = std::distance(band.begin(), itLoop); 
          if(ivIds.contains(pos))
            continue;
          ivIds.insert(pos);
        }
      }
      // Find the unused loops and mark with reduction
      for(unsigned i=0; i< band.size(); i++){
        if(ivIds.contains(i))
          continue;
        auto loop = band[i];
        if(auto attr = loop->getAttr("reduction")){
          if(auto intAttr = dyn_cast<IntegerAttr>(attr)){
            auto intVal = intAttr.getInt();
            addUpdateAtr(dmaOp, "reduction", intVal);
            continue;
          }
        }
        auto intAttr = builder.getI64IntegerAttr(redCnt);
        loop->setAttr("reduction", intAttr);
        addUpdateAtr(dmaOp, "reduction", redCnt++);
      }
      return WalkResult::advance();
    });
  }

  bool checkRed(SmallVector<AffineForOp, 6> band){
    // Check if the marked reduction loops are innermost and consecutive
    SmallVector<unsigned, 4> redIds;
    // Collect indices of loops marked with 'reduction'
    for (unsigned i = 0; i < band.size(); ++i) {
      auto loop = band[i];
      if (loop->hasAttr("reduction")) {
        redIds.push_back(i);
      }
    }
    if (redIds.empty())
      return true;
    // Check if reductions start from innermost (last in band)
    if (redIds.back() != band.size() - 1) {
      llvm::errs() << "Reduction loops do not start from the innermost loop\n";
      return false;
    }
    // Check if reductions are consecutive (from innermost to outermost)
    for (unsigned i = 1; i < redIds.size(); ++i) {
      if (redIds[i] != redIds[i - 1] + 1) {
        llvm::errs() << "Reduction loops are not consecutive.\n";
        return false;
      }
    }
    return true;
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

  bool applyLoopTiling(ModuleOp mod, unsigned defaultTileSizes){
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    // FuncOp topFunc, func;
    // if(!topFind(mod, topFunc, "top_func"))
    //   return true;
    FuncOp func;
    for(auto tileFunc: mod.getOps<FuncOp>()){
      if(tileFunc.getName() == TileFuncName){
        func = tileFunc;
        break;
      }
    }
    if(!func)
      return true;
    outAnnotate(builder, func);
    // preprocess(mod, builder, topFunc);
    
    // Tile the functions specified in the command line.
    SmallVector<AffineForOp, 6> band;
    getPerfectNestedLoopBand(func.getBody(), band);
    reductionAnnotate(builder, band);
    if(!checkRed(band)){
      llvm::errs() << "Reduction loop check failed\n";
      return false;
    }
    auto bandSize = band.size();
    SmallVector<unsigned ,6> redIndeices;
    SmallVector<Attribute, 6> redAttrs;
    for(unsigned i=0; i < bandSize; i++){
      auto loop = band[i];
      if(loop->hasAttr("reduction")){
        redIndeices.push_back(i);
        redAttrs.push_back(loop->getAttr("reduction"));
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
      for(unsigned id=0; id < redIndeices.size(); id++){
        auto idx = redIndeices[id];
        auto attr = redAttrs[id];
        L2tileBand[idx]->setAttr("reduction", attr);
        L2tileBand[idx+bandSize]->setAttr("reduction", attr);
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
      for(unsigned id=0; id < redIndeices.size(); id++){
        auto idx = redIndeices[id];
        auto attr = redAttrs[id];
        L1tileBand[idx+bandSize]->setAttr("reduction", attr);
      }
    }else{
      //Noralize L1 bands
      for(unsigned i = 0; i < L1tileBand.size(); i++){
        auto forOp = L1tileBand[i];
        if(failed(normalizeAffineFor(forOp)))
          return false;
      }
      // Mark L1 reduction loops
      for(unsigned id=0; id < redIndeices.size(); id++){
        auto idx = redIndeices[id];
        auto attr = redAttrs[id];
        L1tileBand[idx]->setAttr("reduction", attr);
        L1tileBand[idx+bandSize]->setAttr("reduction", attr);
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