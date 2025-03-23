#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-io-packing"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::affine;
using namespace mlir::memref;


namespace {

struct AriesIOPacking : public AriesIOPackingBase<AriesIOPacking> {
public:
  AriesIOPacking() = default;
  AriesIOPacking(const AriesOptions &opts) {
    PortWidth=opts.OptPortWidth;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!IOPacking(mod))
      signalPassFailure();
  }

private:
  bool IOPacking (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      // // Perform data packing for PLIO
      // auto boolPLIO = func->getAttr("plio");
      // if(!boolPLIO || !dyn_cast<BoolAttr>(boolPLIO).getValue())
      //   return;
      // func.walk([&](CreateGraphIOOp graphio){
        
      // });
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesIOPackingPass() {
  return std::make_unique<AriesIOPacking>();
}

std::unique_ptr<Pass> createAriesIOPackingPass(const AriesOptions &opts) {
  return std::make_unique<AriesIOPacking>(opts);
}

} // namespace aries
} // namespace mlir