#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "aries/Transform/Passes.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace func;


namespace {

struct AriesKernelSplit : public AriesKernelSplitBase<AriesKernelSplit> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    for (auto func : llvm::make_early_inc_range(mod.getOps<FuncOp>())) {
      if(!func->getAttr("adf.kernel"))
        func.erase();
    }
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesKernelSplitPass() {
  return std::make_unique<AriesKernelSplit>();
}

} // namespace aries
} // namespace mlir