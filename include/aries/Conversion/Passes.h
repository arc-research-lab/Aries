#ifndef ARIES_CONVERSION_PASSES_H
#define ARIES_CONVERSION_PASSES_H

#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "aries/Transform/Passes.h"
#include "aie/Dialect/AIE/IR/AIEDialect.h"
#include "aie/Dialect/AIEX/IR/AIEXDialect.h"

namespace mlir {
class Pass;
} // namespace mlir

namespace mlir {
namespace aries {
namespace adf {

std::unique_ptr<Pass> createAriesLowerToADFPass();
std::unique_ptr<Pass> createADFConvertToAIEPass();
void registerConversionPasses();

#define GEN_PASS_CLASSES
#include "aries/Conversion/Passes.h.inc"

}  // namespace adf
}  // namespace aries
}  // namespace mlir

#endif // ARIES_CONVERSION_PASSES_H