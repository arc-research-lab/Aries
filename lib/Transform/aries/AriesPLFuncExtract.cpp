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

  // Mark the original data type of the MemRefType for plfunc
  void markMemType(OpBuilder builder, FuncOp adfFunc, CallOp call,
                   FuncOp plFunc){
    if(!adfFunc->getAttrOfType<ArrayAttr>("mem_idx"))
      return;
    auto memIdxAttr = adfFunc->getAttrOfType<ArrayAttr>("mem_idx");
    auto memTypeAttr = adfFunc->getAttrOfType<ArrayAttr>("mem_type");
    SmallVector<unsigned> memIdxs;
    SmallVector<Attribute> idxAttrs;
    SmallVector<Attribute> argAttrs;
    for (auto attr : memIdxAttr) {
      auto intAttr = dyn_cast<IntegerAttr>(attr);
      memIdxs.push_back(intAttr.getInt());
    }
    for (unsigned i = 0; i < call.getNumOperands(); ++i) {
      auto operand = call.getOperand(i);
      auto type = operand.getType();
      if(!dyn_cast<MemRefType>(type))
        continue;
      // Check if the operand is an argument of the parent function
      if (auto arg = dyn_cast<BlockArgument>(operand)) {
        unsigned argIdx = arg.getArgNumber();
        auto it = llvm::find(memIdxs, argIdx);
        if(it==memIdxs.end()){
          llvm::errs() << "PLfunc has argument not marked in the adfFunc\n";
          signalPassFailure();
        }
        auto pos = std::distance(memIdxs.begin(), it);
        auto typeAttr = memTypeAttr[pos];
        idxAttrs.push_back(builder.getI32IntegerAttr(i));
        argAttrs.push_back(typeAttr);
      }else{
        llvm::errs() << "Found pl call operands not in the adfFunc args\n";
        signalPassFailure();
      }
    }
    auto arrayAttr = builder.getArrayAttr(idxAttrs);
    plFunc->setAttr("mem_idx", arrayAttr);
    auto arrayTypeAttr = builder.getArrayAttr(argAttrs);
    plFunc->setAttr("mem_type", arrayTypeAttr);
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
    SmallVector<Operation*, 4> Ops;
    auto liveness = Liveness(launchcell);
    for (auto livein: liveness.getLiveIn(&launchcell.getBody().front())){
      if(launchcell->isProperAncestor(livein.getParentBlock()->getParentOp()))
        continue;
      auto definedOp = livein.getDefiningOp();
      if (!definedOp){
        liveins.push_back(livein);
        continue;
      }
      if(auto constOp = dyn_cast<arith::ConstantOp>(definedOp)){
        Ops.push_back(definedOp);
      }else{
        liveins.push_back(livein);
      }
    }

    // Sort the order or liveins to make the order fixed
    llvm::sort(liveins, [](Value a, Value b) {
      // Case 1: Both are block arguments: Sort by function argument index
      if (isa<BlockArgument>(a) && isa<BlockArgument>(b)) {
        return dyn_cast<BlockArgument>(a).getArgNumber() < 
               dyn_cast<BlockArgument>(b).getArgNumber();
      }
      // Case 2: One is a block argument, the other is a defining operation
      if (isa<BlockArgument>(a)) return true;  // Block arguments come first
      if (isa<BlockArgument>(b)) return false;
      // Case 3: Both have defining operations: Sort by op order in block
      Operation *opA = a.getDefiningOp();
      Operation *opB = b.getDefiningOp();
      if (opA && opB)
        return opA->isBeforeInBlock(opB);
      // Fallback: Compare raw pointers for deterministic tie-breaking
      return a.getAsOpaquePointer() < b.getAsOpaquePointer();
    });
    
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

    // SmallVector<Value> definedLiveins;
    // for(auto livein : liveins){
    //   auto it = llvm::find(inputs, livein);
    //   if(it == inputs.end())
    //     definedLiveins.push_back(livein);
    // }
    
    // llvm::sort(definedLiveins, [](Value a, Value b) {
    //   Operation *opA = a.getDefiningOp();
    //   Operation *opB = b.getDefiningOp();
    //   if (!opA || !opB) return opA != nullptr;
    //   return opA->isBeforeInBlock(opB);
    // });

    // for(auto livein : definedLiveins){
    //   inputs.push_back(livein);
    // }

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

    // Move the collected Constant Op defined outside of adf.cell.launch 
    // before the returnOp
    llvm::sort(Ops, [](Operation* a, Operation* b) {
      return a->isBeforeInBlock(b);
    });
    builder.setInsertionPointToStart(destBlock);
    SmallVector<Operation*, 4> newOps;
    for(auto *op : Ops){
      auto newOp = op->clone();
      builder.insert(newOp);
      newOps.push_back(newOp);
    }
    
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

    // Mark the original type of the memref arguments of plFunc
    markMemType(builder, adfFunc, callop, plFunc);

    // Update the references in the plFunc after move
    for (unsigned i = 0, num_arg = destBlock->getNumArguments(); 
         i < num_arg; ++i) {
      auto sourceArg = inputs[i];
      auto destArg = destBlock->getArgument(i);
      sourceArg.replaceUsesWithIf(destArg,[&](OpOperand &use){
          return plFunc->isProperAncestor(use.getOwner());
      });
    }
    // Replace the oldOp with the newOp
    auto opSize = newOps.size();
    for (unsigned i = 0; i < opSize; ++i) {
      auto oldVal = Ops[i]->getResult(0);
      auto newVal = newOps[i]->getResult(0);
      oldVal.replaceUsesWithIf(newVal,[&](OpOperand &use){
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