#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Analysis/Liveness.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/Dialect/Affine/Passes.h"
#include "llvm/Support/Debug.h"
#include "llvm/ADT/StringMap.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-pl-func-extract"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::memref;

namespace {

struct AriesPLFuncExtract 
      : public AriesPLFuncExtractBase<AriesPLFuncExtract> {
public:
  AriesPLFuncExtract() = default;
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!PLFuncExtract(mod))
      signalPassFailure();
  }

private:
  // Collect and remove the adf.cells and erase adf.io.wait
  void Preprocess(OpBuilder builder, LaunchCellOp launchcell, 
                  SmallVectorImpl<CallOp>& calls){
    launchcell.walk([&](Operation *op){
      if(auto call = dyn_cast<CallOp>(op)){
        if(call->hasAttr("adf.cell"))
          calls.push_back(call);
        call->remove();
      }else if(dyn_cast<IOWaitOp>(op) || dyn_cast<WaitLaunchCellOp>(op)){
        op->erase();
      }
    });
  }

  // Move the collected adf.cell to adf.cell.launch
  void Postprocess(OpBuilder builder, LaunchCellOp launchcell, 
                   SmallVectorImpl<CallOp>& calls){
    auto &entryBlock = launchcell.getBody().front();
    builder.setInsertionPointToStart(&entryBlock);
    for(auto call: calls)
      builder.insert(call);
  }

  // Create PL func.func and pl.launch. Create Callop inside pl.launch
  void PLFuncCreation(OpBuilder builder, FuncOp adfFunc,
                      LaunchCellOp launchcell){
    SmallVector<CallOp> calls;
    Preprocess(builder, launchcell, calls);
    auto loc = builder.getUnknownLoc();
    SmallVector<Value> liveins;
    auto liveness = Liveness(launchcell);
    for (auto livein: liveness.getLiveIn(&launchcell.getBody().front()))
      if (!launchcell->isProperAncestor(livein.getParentBlock()->getParentOp()))
        liveins.push_back(livein);
    
    //reorder inputs to be correspond with the adfFunc arguments
    SmallVector<Value, 6> inputs;
    for(auto arg : adfFunc.getArguments()){
      auto it = llvm::find(liveins,arg);
      if(it != liveins.end())
        inputs.push_back(arg);
    }
    SmallVector<Attribute, 4> newMetaArray;
    addMetaData(builder, adfFunc, inputs, newMetaArray);
    for(auto livein : liveins){
      auto it = llvm::find(inputs, livein);
      if(it == inputs.end())
        inputs.push_back(livein);
    }

    // Define the dma function with the detected inputs as arguments
    builder.setInsertionPoint(adfFunc);
    auto funcName = adfFunc.getName().str() + "_pl";
    auto funcType = builder.getFunctionType(ValueRange(inputs), TypeRange({}));
    auto plFunc = builder.create<FuncOp>(
                  builder.getUnknownLoc(), funcName, funcType);
    plFunc->setAttr("adf.pl",builder.getBoolAttr(true));
    if(!newMetaArray.empty()){
      auto arrayAttr = builder.getArrayAttr(newMetaArray);
      plFunc->setAttr("meta_data", arrayAttr);
    }
    auto destBlock = plFunc.addEntryBlock();
    builder.setInsertionPointToEnd(destBlock);
    auto returnOp = builder.create<ReturnOp>(builder.getUnknownLoc());
    
    // Move the operations in the adf.cell.launch before the returnOp
    builder.setInsertionPointToEnd(destBlock);
    auto &entryBlock = launchcell.getBody().front();
    for(auto &op: llvm::make_early_inc_range(entryBlock)){
      if(!dyn_cast<EndLaunchCellOp>(op))
        op.moveBefore(returnOp);
    }

    // Create LaunchPLOp and insert the CallOp
    builder.setInsertionPointAfter(launchcell);
    auto launchPLOp = builder.create<LaunchPLOp>(loc,funcName);
    auto *cellLaunchPLBlock = builder.createBlock(&launchPLOp.getBody());
    builder.setInsertionPointToEnd(cellLaunchPLBlock);
    auto endLaunchPL = builder.create<WaitLaunchPLOp>(loc);
    builder.setInsertionPoint(endLaunchPL);
    auto callop = builder.create<CallOp>(loc, plFunc, inputs);
    callop->setAttr("adf.pl",builder.getUnitAttr());

    // Update the references in the plFunc after move
    for (unsigned i = 0, num_arg = destBlock->getNumArguments(); 
         i < num_arg; ++i) {
      auto sourceArg = inputs[i];
      auto destArg = destBlock->getArgument(i);
      sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
          return plFunc->isProperAncestor(use.getOwner());
      });
    }
    Postprocess(builder, launchcell, calls);
  }

  // This pass extract the DMA logics in the PL side
  bool PLFuncExtract (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func") || !func->hasAttr("plio"))
        continue;      
      // Find the LaunchCellOp
      LaunchCellOp launchcell = getFirstOpOfType<LaunchCellOp>(func.getBody());
      if(!launchcell)
        return true;
      auto boolPLIO = dyn_cast<BoolAttr>(func->getAttr("plio"));
      if(!boolPLIO && !boolPLIO.getValue())
        continue;
      PLFuncCreation(builder, func, launchcell);
    }
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesPLFuncExtractPass() {
  return std::make_unique<AriesPLFuncExtract>();
}

} // namespace aries
} // namespace mlir