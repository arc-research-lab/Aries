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
    pm.addPass(createAriesTilingPass(opts));

    if(!opts.OptEnableNewTiling){
      // Extract the single kernel design
      pm.addPass(createAriesFuncExtractPass());
      pm.addPass(createAriesLoopSimplifyPass());
      pm.addPass(createAriesMemSubviewPass());
      pm.addPass(createAriesMemHoistPass());
      pm.addPass(createAriesMemCopyPass());
      // Convert to ADF dialect
      pm.addPass(createAriesLowerToADFPass());
      pm.addPass(mlir::createCanonicalizerPass());
    }
    
    // Perform global optimizations
    pm.addPass(createAriesDependencyExtractPass());
    pm.addPass(createAriesFuncUnrollPass());
    pm.addPass(createAriesLocalDataForwardPass());
    pm.addPass(createAriesKernelInterfaceCreatePass(opts));
    if(!opts.OptEnablePL){
      pm.addPass(createAriesBroadcastDetectPass());
      pm.addPass(createAriesL2BufferCreatePass(opts));
    }
    
    // Perform local optimizations
    pm.addPass(createAriesDMAToIOPass(opts));
    pm.addPass(createAriesADFCellCreatePass(opts));
    pm.addPass(createAriesCorePlacementPass(opts));
    pm.addPass(createAriesIOPlacementPass(opts));
    if(opts.OptEnablePL){
      pm.addPass(createAriesGMIOMaterializePass());
      pm.addPass(createAriesPLIOMaterializePass(opts));
      pm.addPass(createAriesAXIPackingPass(opts));
      pm.addPass(createAriesPLDataflowPass());
      pm.addPass(mlir::createCanonicalizerPass());
      pm.addPass(createAriesBurstDetectionPass());
      pm.addPass(createAriesFuncEliminatePass());
      pm.addPass(createAriesPLDoubleBufferPass());
      pm.addPass(mlir::createCanonicalizerPass());
      if(opts.OptEnableSerial){
        pm.addPass(createAriesPLSerializePass());
        pm.addPass(mlir::createCanonicalizerPass());
      }
    }else{
      pm.addPass(mlir::createCanonicalizerPass());
      pm.addPass(mlir::createCSEPass());
      pm.addPass(createADFConvertToAIEPass());
    }
  });
}

void mlir::aries::registerAriesOptPipeline() {
  PassPipelineRegistration<AriesOptions>(
  "aries-opt-pipeline", "Compile to AIE array",
  [](OpPassManager &pm, const AriesOptions &opts) {
    // Perform multi-level tiling
  });
}


void mlir::aries::registerAriesPasses() {
  registerPasses();
  registerAriesPassPipeline();
  registerAriesOptPipeline();
}