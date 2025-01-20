#include "aries/Conversion/Passes.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"

using namespace mlir;
using namespace aries;
using namespace adf;

namespace {
#define GEN_PASS_REGISTRATION
#include "aries/Conversion/Passes.h.inc"
} // namespace


void mlir::aries::adf::registerConversionPasses() {
  registerPasses();
}