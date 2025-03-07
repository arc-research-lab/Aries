#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
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

struct AriesGMIOMaterialize : public AriesGMIOMaterializeBase<AriesGMIOMaterialize> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!IOMaterialize(mod))
      signalPassFailure();
  }

private:
  // Serialize the IOPushOp for GMIO
  void GMIOPushOpProcess(OpBuilder builder, FuncOp topFunc, 
                       EndLaunchCellOp endlaunchCell){
    // Need to consider the insertion point of dma of PopOp and deallocOp
    // Now set before EndLaunchCellOp
    auto loc = builder.getUnknownLoc();
    auto &entryBlock = topFunc.getBody().front();
    topFunc.walk([&](IOPushOp op){
      auto src         = op.getSrc();
      auto dst         = op.getDst();
      auto src_offsets = op.getSrcOffsets();
      auto src_sizes   = op.getSrcSizes();
      auto src_strides = op.getSrcStrides();
      // Skip if the src of the IOPush is serialized
      if((!src_offsets.size())&&(!src_sizes.size())&&(!src_strides.size()))
        return WalkResult::advance();
      SmallVector<int64_t, 4> sizes;
      for (auto size : src_sizes){
        auto sizeAttr = dyn_cast<IntegerAttr>(
                        size.getDefiningOp<arith::ConstantOp>().getValue());
        auto sizeInt = sizeAttr.getInt();
        sizes.push_back(sizeInt);
      }
      auto memRefType 
          = MemRefType::get(sizes, 
                        dyn_cast<MemRefType>(src.getType()).getElementType());
      builder.setInsertionPointToStart(&entryBlock);
      auto newMem = builder.create<AllocOp>(loc,memRefType);
      newMem->setAttr("gmio",builder.getUnitAttr());
      builder.setInsertionPoint(endlaunchCell);
      auto dealloc = builder.create<DeallocOp>(loc,newMem);
      dealloc->setAttr("gmio",builder.getUnitAttr());
      builder.setInsertionPoint(op);
      auto dmaOp = builder.create<DmaOp>(
                        loc, src, src_offsets, src_sizes, src_strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        newMem, ValueRange(), ValueRange(), ValueRange(),
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      dmaOp->setAttr("in",builder.getUnitAttr());
      builder.setInsertionPoint(op);
      builder.create<IOPushOp>(loc, newMem, 
                               ValueRange(), ValueRange(), ValueRange(), dst);
      op.erase();
      return WalkResult::advance();
    });
  }

  // Serialize the IOPopOp for GMIO
  void GMIOPopOpProcess(OpBuilder builder, FuncOp topFunc, 
                       EndLaunchCellOp endlaunchCell){
    auto loc = builder.getUnknownLoc();
    auto &entryBlock = topFunc.getBody().front();
    topFunc.walk([&](IOPopOp op){
      auto src = op.getSrc();
      auto dst   = op.getDst();
      auto dst_offsets = op.getDstOffsets();
      auto dst_sizes   = op.getDstSizes();
      auto dst_strides = op.getDstStrides();

      IOWaitOp iowaitOp;
      // Get the corresponding wait operation
      for (auto user: src.getUsers()){
        if(auto iowait = dyn_cast<IOWaitOp>(user))
          iowaitOp = iowait;
      }
      // Skip if the dst of the IOPop is serialized
      if((!dst_offsets.size())&&(!dst_sizes.size())&&(!dst_strides.size()))
        return WalkResult::advance();
      SmallVector<int64_t, 4> sizes;
      for (auto size : dst_sizes){
        auto sizeAttr = dyn_cast<IntegerAttr>(
                        size.getDefiningOp<arith::ConstantOp>().getValue());
        auto sizeInt = sizeAttr.getInt();
        sizes.push_back(sizeInt);
      }
      auto memRefType 
          = MemRefType::get(sizes, 
                        dyn_cast<MemRefType>(dst.getType()).getElementType());
      builder.setInsertionPointToStart(&entryBlock);               
      auto newMem = builder.create<AllocOp>(loc,memRefType);
      newMem->setAttr("gmio",builder.getUnitAttr());
      builder.setInsertionPointAfter(iowaitOp);
      auto dmaOp = builder.create<DmaOp>(
                        loc, newMem, ValueRange(), ValueRange(), ValueRange(),
                        ValueRange(), ValueRange(), ValueRange(), ValueRange(),
                        dst, dst_offsets, dst_sizes, dst_strides,
                        ValueRange(), ValueRange(), ValueRange(), ValueRange());
      dmaOp->setAttr("out",builder.getUnitAttr());
      builder.setInsertionPoint(endlaunchCell);
      auto dealloc = builder.create<DeallocOp>(loc,newMem);
      dealloc->setAttr("gmio",builder.getUnitAttr()); 
      builder.setInsertionPoint(op);
      builder.create<IOPopOp>(loc, src, newMem, 
                              ValueRange(), ValueRange(), ValueRange());             
      op.erase();
      return WalkResult::advance();
    });
  }

  bool IOMaterialize (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      // Find the LaunchCellOp
      LaunchCellOp launchcell = getFirstOpOfType<LaunchCellOp>(func.getBody());
      if(!launchcell)
        return true;

      auto &entryBlock = launchcell.getBody().front();
      auto endlaunchCell = dyn_cast<EndLaunchCellOp>(entryBlock.getTerminator());

      // Materialize Push/Pop of GMIO
      auto boolGMIO = func->getAttr("gmio");
      if(boolGMIO && dyn_cast<BoolAttr>(boolGMIO).getValue()){
        GMIOPushOpProcess(builder, func, endlaunchCell);
        GMIOPopOpProcess(builder, func, endlaunchCell);
      }
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesGMIOMaterializePass() {
  return std::make_unique<AriesGMIOMaterialize>();
}

} // namespace aries
} // namespace mlir