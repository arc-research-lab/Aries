#include "aries/Transform/Passes.h"
#include "aries/Conversion/Passes.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"

using namespace mlir;
using namespace aries;
using namespace adf;

namespace {
#define GEN_PASS_REGISTRATION
#include "aries/Transform/Passes.h.inc"
} // namespace

void mlir::aries::registerAriesPassPipeline() {
  PassPipelineRegistration<AriesOptions>(
  "aries-pipeline", "Compile to AIE array",
  [](OpPassManager &pm, const AriesOptions &opts) {
    pm.addPass(createAriesTilingPass(opts));
    pm.addPass(createAriesFuncExtractPass());
    pm.addPass(createAriesLoopSimplifyPass());
    pm.addPass(createAriesMemSubviewPass());
    pm.addPass(createAriesMemHoistPass());
    pm.addPass(createAriesMemCopyPass());
    pm.addPass(createAriesDependencyExtractPass());
    pm.addPass(createAriesLowerToADFPass());
    pm.addPass(createAriesFuncUnrollPass());
    pm.addPass(createAriesCorePlacementPass());
    pm.addPass(createAriesLocalDataForwardPass());
    pm.addPass(createAriesKernelInterfaceCreatePass());
    pm.addPass(createAriesDMAToIOPass());
    pm.addPass(createAriesDMAToIOPass(opts));
    pm.addPass(createAriesADFCellCreatePass());
    pm.addPass(createAriesKernelSplitPass());
    pm.addPass(createAriesGMIOMaterializePass());
    pm.addPass(createAriesPLIOMaterializePass());
    pm.addPass(createAriesAXIPackingPass());
    pm.addPass(createAriesPLDataflowPass());
    pm.addPass(createAriesPLDoubleBufferPass());
    pm.addPass(createAriesBurstDetectionPass());
    pm.addPass(createAriesADFTestPass());
    pm.addPass(createAriesFileSplitPass(opts));
  });
}


void mlir::aries::registerAriesPasses() {
  registerPasses();
  registerAriesPassPipeline();
}