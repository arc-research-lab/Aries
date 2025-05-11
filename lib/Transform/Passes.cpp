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

    // Perform multi-level tiling
    pm.addPass(createAriesPreprocessPass());
    pm.addPass(createAriesTilingPass(opts));
    
    // Perform global optimizations
    pm.addPass(createAriesDependencyExtractPass());
    pm.addPass(createAriesFuncUnrollPass());
    pm.addPass(createAriesParallelReductionPass());
    pm.addPass(createAriesBroadcastDetectPass());
    pm.addPass(createAriesL2BufferCreatePass(opts));
    
    // Perform local optimizations
    pm.addPass(createAriesDMAToIOPass(opts));
    pm.addPass(createAriesADFCellCreatePass(opts));
    pm.addPass(createAriesCorePlacementPass(opts));
    pm.addPass(createAriesIOPlacementPass(opts));
    pm.addPass(mlir::createCanonicalizerPass());
    pm.addPass(mlir::createCSEPass());
    pm.addPass(createADFConvertToAIEPass());
  });
}

void mlir::aries::registerAriesOptPipeline() {
  PassPipelineRegistration<AriesOptions>(
  "aries-pipeline-versal", "Compile to Versal Devices",
  [](OpPassManager &pm, const AriesOptions &opts) {
    pm.addPass(createAriesPreprocessPass());
    pm.addPass(createAriesTilingPass(opts));
    pm.addPass(createAriesAffineUnrollPass());
    pm.addPass(createAriesParallelReductionPass());
    pm.addPass(createAriesBroadcastDetectPass());
    pm.addPass(createAriesKernelInterfaceCreatePass(opts));
    pm.addPass(createAriesLowerDMAToIOPass(opts));
    pm.addPass(createAriesIOPackingPass(opts));
    pm.addPass(createAriesADFCellCreatePass(opts));
    pm.addPass(createAriesCorePlacementPass(opts));
    pm.addPass(createAriesIOPlacementPass(opts));
    pm.addPass(createAriesPLFuncExtractPass());
    pm.addPass(createAriesPLBufferExtractPass(opts));
    pm.addPass(createAriesPLDMAToAffinePass());
    pm.addPass(createAriesAXIPackingPass(opts));
    pm.addPass(createAriesPLDataflowPass());
    pm.addPass(mlir::createCanonicalizerPass());
    pm.addPass(mlir::createCSEPass());
    pm.addPass(createAriesBurstDetectionPass());
    pm.addPass(createAriesFuncEliminatePass());
    pm.addPass(createAriesPLDoubleBufferPass());
    pm.addPass(mlir::createCanonicalizerPass());
    pm.addPass(mlir::createCSEPass());
    if(opts.OptEnableSerial){
      pm.addPass(createAriesPLSerializePass());
      pm.addPass(mlir::createCanonicalizerPass());
      pm.addPass(mlir::createCSEPass());
    }
  });
}


void mlir::aries::registerAriesPasses() {
  registerPasses();
  registerAriesPassPipeline();
  registerAriesOptPipeline();
}