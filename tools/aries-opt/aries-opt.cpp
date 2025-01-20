#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Pass/PassRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "aries/Transform/Passes.h"
#include "aries/Conversion/Passes.h"
#include "aries/Dialect/ADF/ADFDialect.h"

#include "aie/Dialect/AIE/IR/AIEDialect.h"
#include "aie/Dialect/AIEVec/IR/AIEVecDialect.h"
#include "aie/Dialect/AIEVec/AIE1/IR/AIEVecAIE1Ops.h"
#include "aie/Dialect/AIEX/IR/AIEXDialect.h"
#include "aie/Dialect/AIE/Transforms/AIEPasses.h"
#include "aie/Dialect/AIEVec/Transforms/Passes.h"

int main(int argc, char **argv) {
    mlir::DialectRegistry registry;
    mlir::registerAllDialects(registry);
    registry.insert<mlir::aries::adf::ADFDialect>();
    registry.insert<xilinx::aievec::AIEVecDialect>();
    registry.insert<xilinx::aievec::aie1::AIEVecAIE1Dialect>();
    registry.insert<xilinx::AIE::AIEDialect>();
    registry.insert<xilinx::AIEX::AIEXDialect>();

    mlir::registerAllPasses();
    mlir::aries::registerAriesPasses();
    mlir::aries::adf::registerConversionPasses();

    xilinx::AIE::registerAIEPasses();
    xilinx::aievec::registerAIEVecPasses();

    return mlir::asMainReturnCode(
        mlir::MlirOptMain(argc, argv, "ARIES modular optimizer Driver", registry));
}


