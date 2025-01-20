#include "aries/Conversion/Passes.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "aries/Transform/Utils.h"
#include "aie/Dialect/AIE/IR/AIEDialect.h"
#include "aie/Dialect/AIEX/IR/AIEXDialect.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::arith;
using namespace mlir::affine;


namespace {

struct ADFConvertToAIE : public ADFConvertToAIEBase<ADFConvertToAIE> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());  
    if (!ConvertToAIE(mod))
      signalPassFailure();
  }

private:
  bool ConvertToAIE(ModuleOp mod) {

    return true;
  }

};

} // namespace


namespace mlir {
namespace aries {
namespace adf {

std::unique_ptr<Pass> createADFConvertToAIEPass() {
  return std::make_unique<ADFConvertToAIE>();
}

} // namespace adf
} // namespace aries
} // namespace mlir