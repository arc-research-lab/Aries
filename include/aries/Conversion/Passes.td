#ifndef ARIES_CONVERSION_PASSES_TD
#define ARIES_CONVERSION_PASSES_TD

include "mlir/Pass/PassBase.td"

def AriesLowerToADF : Pass<"aries-lower-to-adf"> {
  let summary = "Lower to adf dialect";

  let description = [{
    This pass lowers the front-end IRs to adf dialect.
  }];
  let dependentDialects = [
    "mlir::aries::adf::ADFDialect",
    "mlir::affine::AffineDialect"
  ];
  let constructor = "mlir::aries::adf::createAriesLowerToADFPass()";
}

def ADFConvertToAIE : Pass<"adf-convert-to-aie"> {
  let summary = "Convert ADF dialect to AIE and AIEx dialects";
  let description = [{
    This pass convert the ADF dialect to AIE and AIEx dialects.
  }];
  let dependentDialects = [
    "xilinx::AIE::AIEDialect",
    "xilinx::AIEX::AIEXDialect"
  ];
  let constructor = "mlir::aries::adf::createADFConvertToAIEPass()";
}

#endif  // ARIES_CONVERSION_PASSES_TD