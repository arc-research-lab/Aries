#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "mlir/Dialect/Affine/LoopUtils.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;

namespace {

struct AriesADFCellCreate : public AriesADFCellCreateBase<AriesADFCellCreate> {
public:
  AriesADFCellCreate() = default;
  AriesADFCellCreate(const AriesOptions &opts) {
    EnablePL = opts.OptEnablePL;
    EnableAIE2 = opts.OptEnableAIE2;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());

    if(!EnablePL && EnableAIE2){
      if (!NPUCellCreate(mod))
        signalPassFailure();
    }else{
      if (!ADFCellCreate(mod))
        signalPassFailure();
    }
  }

private:
  void OpCollect(AffineForOp arrayForOp, 
                 SmallVector<Operation*> &TopOps, 
                 SmallVector<Operation*> &topGraphOps, 
                 SmallVector<IOPopOp> &IOPopOps, 
                 SmallVector<Value> &ArgIns){
    arrayForOp.walk([&](Operation *op){
      if(dyn_cast<ConfigPLIOOp>(op) ||dyn_cast<ConfigGMIOOp>(op) || 
         dyn_cast<BufferOp>(op) || dyn_cast<ConnectOp>(op))
        topGraphOps.push_back(op);
      else if(auto graphio = dyn_cast<CreateGraphIOOp>(op)){
        TopOps.push_back(op);
        ArgIns.push_back(graphio.getResult());
      }else if(auto iopopOp = dyn_cast<IOPopOp>(op))
        IOPopOps.push_back(iopopOp);
    });
  }

  // This function moves the launchCellOp to the innermost new loop
  // Then unroll the loops inside launchCell region
  // Create new launchCellOp and move outerLoop inside launchCellOp
  bool processCell(OpBuilder builder, LaunchCellOp& LaunchCell, 
                   LaunchCellOp& newLaunch, AffineForOp outerLoop, 
                   Operation* terminator){
    //auto loc = builder.getUnknownLoc();
    LaunchCell->moveBefore(terminator);
    auto forOp = getFirstOpOfType<AffineForOp>(LaunchCell.getBody());
    SmallVector<AffineForOp, 6> band;
    getNestedLoops(band, forOp);
    for(auto loop : band)
      if(failed(loopUnrollFull(loop)))
        return false;
    auto& entryBlock = LaunchCell.getBody().front();
    for(auto& op: llvm::make_early_inc_range(entryBlock)){
      if(!dyn_cast<EndLaunchCellOp>(op))
        op.moveBefore(LaunchCell);
    }
    newLaunch = dyn_cast<LaunchCellOp>(LaunchCell->clone());
    auto& newBlock = newLaunch.getBody().front();
    auto endOp = newBlock.getTerminator();
    builder.setInsertionPoint(outerLoop);
    builder.insert(newLaunch);
    outerLoop->moveBefore(endOp);
    LaunchCell.erase();
    return true;
  }

  // For NPU, the AIE array can not be viewed as a graph triggered automatically
  // like the ADF Graph in Vitis flow.
  // A differtent cell creating function is needed to include all the control
  // logics in the cell as well.
  bool NPUCellCreate (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      AffineForOp arrayForOp;   
      func.walk([&](AffineForOp forOp){
        if(forOp->hasAttr("Array_Partition"))
          arrayForOp = forOp;
      });
      if(!arrayForOp)
        continue;
      SmallVector<AffineForOp, 6> band;
      getLoopBandFromInnermost(arrayForOp, band);
      // Create new point loops that need to move the LaunchCell op to
      SmallVector<AffineForOp, 4> newLoops;
      auto outerLoop = band[0];
      builder.setInsertionPointAfter(outerLoop);
      for (auto loop : band){
        auto newDMAForOp
             = builder.create<AffineForOp>(loc,
                                           loop.getLowerBoundOperands(),
                                           loop.getLowerBoundMap(),
                                           loop.getUpperBoundOperands(),
                                           loop.getUpperBoundMap());
        if(auto attr = loop->hasAttr("reduction"))
          newDMAForOp->setAttr("reduction", builder.getUnitAttr());
        newLoops.push_back(newDMAForOp);
        builder.setInsertionPointToStart(newDMAForOp.getBody());
      }
      auto newOuterLoop = newLoops[0];
      auto newInnerLoop = newLoops[newLoops.size()-1];
      auto newInnerYiled = newInnerLoop.getBody()->getTerminator();

      // Find the LaunchCellOp
      LaunchCellOp LaunchCell = getFirstOpOfType<LaunchCellOp>(func.getBody());
      if(!LaunchCell)
        return true;
      SmallVector<Operation*> TopOps; // GraphIO Op need to define in top
      SmallVector<Operation*> topGraphOps; // Ops defined in adf.cell
      SmallVector<IOPopOp> IOPopOps; // unused now
      SmallVector<Value> ArgIns;
      OpCollect(arrayForOp, TopOps, topGraphOps, IOPopOps, ArgIns); 

      // Move GraphIOs to the start of the adf.func Op
      auto& entryBlock = func.getRegion().front();
      for (Operation *op : TopOps) {
        op->moveBefore(&entryBlock, entryBlock.begin());
      }
      builder.setInsertionPoint(func);
      auto funcName = "adf_" + LaunchCell.getCallee().str();
      auto funcType 
           = builder.getFunctionType(ValueRange(ArgIns), ValueRange());
      auto newfunc = builder.create<FuncOp>(loc, funcName, funcType);
      newfunc->setAttr("adf.cell",builder.getUnitAttr());
      if(auto attr = LaunchCell->getAttr("tripCount"))
        if(auto arrayAttr = dyn_cast<ArrayAttr>(attr))
          newfunc->setAttr("tripCount", arrayAttr);
      auto destBlock = newfunc.addEntryBlock();
      builder.setInsertionPointToEnd(destBlock);
      auto returnOp = builder.create<ReturnOp>(loc);

      // Create call op of the adf.cell func
      builder.setInsertionPoint(LaunchCell);
      auto callop = builder.create<CallOp>(loc, newfunc, ValueRange(ArgIns));
      callop->setAttr("adf.cell", builder.getUnitAttr());

      // Move graph ops that need to appear upfront to adf.cell
      for (Operation *op : topGraphOps) {
        op->moveBefore(returnOp);
      }
      // Process LaunchCellOp
      LaunchCellOp newLaunch;
      if(!processCell(builder, LaunchCell, newLaunch, newOuterLoop, 
                      newInnerYiled))
        return false;

      // Replace the loop variant in newInnerDMALoop
      for (unsigned i = 0; i < band.size(); i++) {
        auto oldVi = band[i].getInductionVar();
        auto newVi = newLoops[i].getInductionVar();
        oldVi.replaceUsesWithIf(newVi,[&](OpOperand &use){
            return newInnerLoop->isProperAncestor(use.getOwner());
        });
      }

      // Clone Const op into for loop
      // TODO:: May need to change launchcell to an isolated region later
      SmallVector<Value, 4> oldConsts;
      SmallVector<Value, 4> newConsts;
      auto& newBlock = newLaunch.getBody().front();
      for (auto constOp : func.getOps<arith::ConstantOp>()){
        auto newConst = constOp.clone();
        builder.setInsertionPointToStart(&newBlock);
        builder.insert(newConst);
        oldConsts.push_back(constOp.getResult());
        newConsts.push_back(newConst.getResult());
      }

      // Replace the constOp newInnerDMALoop
      for (unsigned i = 0; i < newConsts.size(); i++) {
        auto oldCons = oldConsts[i];
        auto newCons = newConsts[i];
        oldCons.replaceUsesWithIf(newCons,[&](OpOperand &use){
            return newLaunch->isProperAncestor(use.getOwner());
        });
      }
      // // Move the new loop nest into adf.cell func
      newLaunch->moveBefore(returnOp);

      // Update the references in the newfunc after move
      auto num_arg = destBlock->getNumArguments();
      for (unsigned i = 0; i < num_arg; ++i) {
        auto sourceArg = ArgIns[i];
        auto destArg = destBlock->getArgument(i);
        sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
            return newfunc->isProperAncestor(use.getOwner());
        });
      }     
    }
    return true;
  }


  void OpCollect(CellOp cellop, 
                 SmallVector<Operation*> &TopOps, 
                 SmallVector<Operation*> &topGraphOps, 
                 SmallVector<Operation*> &GraphOps, 
                 SmallVector<IOPopOp> &IOPopOps, 
                 SmallVector<Value> &ArgIns){
    cellop.walk([&](Operation *op){
      if(dyn_cast<ConfigPLIOOp>(op) ||dyn_cast<ConfigGMIOOp>(op))
        topGraphOps.push_back(op);
      else if(dyn_cast<BufferOp>(op) || dyn_cast<ConnectOp>(op) || 
              dyn_cast<CallOp>(op))
        GraphOps.push_back(op);
      else if(auto graphio = dyn_cast<CreateGraphIOOp>(op)){
        TopOps.push_back(op);
        ArgIns.push_back(graphio.getResult());
      }else if(auto iopopOp = dyn_cast<IOPopOp>(op))
        IOPopOps.push_back(iopopOp);
      else
        TopOps.push_back(op);
    });
  }

  bool ADFCellCreate (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    auto loc = builder.getUnknownLoc();
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      // Find the CellOp
      CellOp cellOp = getFirstOpOfType<CellOp>(func.getBody());
      if(!cellOp)
        return true;
      // Eliminate the cell.end Op
      cellOp.getBody().front().back().erase();

      SmallVector<Operation*> TopOps;
      SmallVector<Operation*> topGraphOps; 
      SmallVector<Operation*> GraphOps;
      SmallVector<IOPopOp> IOPopOps;
      SmallVector<Value> ArgIns;
      OpCollect(cellOp, TopOps, topGraphOps, GraphOps, IOPopOps, ArgIns);

      //Create an empty func adf_graph before the outmost band loop
      builder.setInsertionPoint(func);
      auto funcName = "adf_" + cellOp.getCellName().str();
      auto funcType 
           = builder.getFunctionType(ValueRange(ArgIns), ValueRange());
      auto newfunc = builder.create<FuncOp>(loc, funcName, funcType);
      newfunc->setAttr("adf.cell",builder.getUnitAttr());
      if(auto attr = cellOp->getAttr("tripCount"))
        if(auto arrayAttr = dyn_cast<ArrayAttr>(attr))
          newfunc->setAttr("tripCount", arrayAttr);
      auto destBlock = newfunc.addEntryBlock();
      builder.setInsertionPointToEnd(destBlock);
      auto returnOp = builder.create<ReturnOp>(loc);

      //Move GraphOps into adf_cell
      builder.setInsertionPoint(returnOp);
      // Move ConfigOps first, as these will translate to create ios in adf graph
      for (Operation *op : topGraphOps) {
        op->moveBefore(returnOp);
      }
      for (Operation *op : GraphOps) {
        op->moveBefore(returnOp);
      }

      // Create the function CallOp
      builder.setInsertionPoint(cellOp);
      for (auto op : TopOps) {
        op->moveBefore(cellOp);
      }

      builder.setInsertionPoint(cellOp);
      auto callop = builder.create<CallOp>(loc, newfunc, ValueRange(ArgIns));
      callop->setAttr("adf.cell",builder.getUnitAttr());

      builder.setInsertionPoint(cellOp);
      for (auto op : IOPopOps) {
        op->moveBefore(cellOp);
      }

      builder.setInsertionPoint(cellOp);
      for (auto op : IOPopOps) {
        builder.create<IOWaitOp>(loc, op.getSrc());
      }

      // Update the references in the newfunc after move
      auto num_arg = destBlock->getNumArguments();
      for (unsigned i = 0; i < num_arg; ++i) {
        auto sourceArg = ArgIns[i];
        auto destArg = destBlock->getArgument(i);
        sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
            return newfunc->isProperAncestor(use.getOwner());
        });
      }

      //Create WaitLaunchCellOp after all the IOwait
      builder.create<WaitLaunchCellOp>(loc);

      //Erase cellop after func with adf.cell attributes has been created 
      cellOp.erase();

      // Create LaunchCellOp and move all the operations inside LaunchCellOp
      // TODO:: This is because current LaunchCellOp will be converted to
      // graph.init() which should be declared only once. Thus, now all the ops
      // are moved inside it. 
      //----------This part May need to change------------.
      Block &entryBlock = func.getBody().front();
      builder.setInsertionPoint(entryBlock.getTerminator());
      auto cellLaunchop = builder.create<LaunchCellOp>(loc, callop.getCallee());
      Block *cellLaunchBlock = builder.createBlock(&cellLaunchop.getRegion());
      builder.setInsertionPointToEnd(cellLaunchBlock);
      auto endLaunchCell = builder.create<EndLaunchCellOp>(loc);

      for (auto &op: llvm::make_early_inc_range(entryBlock)){
        if(!dyn_cast<LaunchCellOp>(op)&&!dyn_cast<ReturnOp>(op)
         &&!dyn_cast<memref::AllocOp>(op))
          op.moveBefore(endLaunchCell);
      }

      // Move CreateGraphIOOp before adf.cell.launch
      func.walk([&](CreateGraphIOOp op){
        op->moveBefore(&entryBlock, entryBlock.begin());
      });
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesADFCellCreatePass() {
  return std::make_unique<AriesADFCellCreate>();
}

std::unique_ptr<Pass> createAriesADFCellCreatePass(const AriesOptions &opts) {
  return std::make_unique<AriesADFCellCreate>(opts);
}

} // namespace aries
} // namespace mlir