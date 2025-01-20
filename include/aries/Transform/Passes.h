#ifndef ARIES_TRANSFORM_PASSES_H
#define ARIES_TRANSFORM_PASSES_H

#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/Pass/Pass.h"
#include "aries/Dialect/ADF/ADFDialect.h"

#include <memory>
#include <vector>

namespace mlir {
class Pass;
} // namespace mlir

namespace mlir {
namespace aries {

struct AriesOptions : public PassPipelineOptions<AriesOptions> {
  /// Configure the tiling pass.
  Option<std::string> OptTileFuncName{
      *this, "tile-func-name", llvm::cl::init("main"),
      llvm::cl::desc("Specify the function to be tiled")};

  ListOption<unsigned> OptL1TileSize{
      *this, "l1-tile-sizes", llvm::cl::ZeroOrMore,
      llvm::cl::desc("Specify a list of L1 loop tile sizes")};

  ListOption<unsigned> OptL2TileSize{
      *this, "l2-tile-sizes", llvm::cl::ZeroOrMore,
      llvm::cl::desc("Specify a list of L2 loop tile sizes")};
  
  ListOption<unsigned> OptL3TileSize{
      *this, "l3-tile-sizes", llvm::cl::ZeroOrMore,
      llvm::cl::desc("Specify a list of L3 loop tile sizes")};
  
  /// Configure the L2bufferCreate/CorePlacement pass.
  Option<bool> OptEnablePL{
      *this, "en-pl", llvm::cl::init(true), llvm::cl::desc(
      "Enable programmable logic(PL) or not")};

  /// Configure the DMAToIO pass.
  Option<std::string> OptPortType{
      *this, "port-type", llvm::cl::init("PLIO"),
      llvm::cl::desc("Specify the type of the ports(PORT,GMIO,PLIO)")};
  Option<int64_t> OptPortWidth{
      *this, "plio-width", llvm::cl::init(32),
      llvm::cl::desc("Specify the plio width of a port in bits (32,64,128)")};
  Option<int64_t> OptPLIOFreq{
      *this, "plio-freq", llvm::cl::init(250),
      llvm::cl::desc("Specify the plio frequency in MHz")};
  Option<int64_t> OptPortBurst{
      *this, "gmio-burst", llvm::cl::init(64),
      llvm::cl::desc("Specify the gmio burst in bytes (64,128,256)")};
  Option<int64_t> OptGMIOBW{
      *this, "gmio-bw", llvm::cl::init(1000),
      llvm::cl::desc("Specify the required gmio bandwidth in MB/s")};

  /// Configure the CorePlacement pass.
  Option<int64_t> OptColNum{
      *this, "col-num", llvm::cl::init(0), 
      llvm::cl::desc("Specify the number of columns of the AIE array")};
  Option<int64_t> OptRowNum{
      *this, "row-num", llvm::cl::init(0), 
      llvm::cl::desc("Specify the number of rows of the AIE array")};
  Option<int64_t> OptColOffset{
      *this, "col-offset", llvm::cl::init(0), llvm::cl::desc(
      "Specify the offset for core placement in the col direction")};
  Option<int64_t> OptRowOffset{
      *this, "row-offset", llvm::cl::init(0), llvm::cl::desc(
      "Specify the offset for core placement in the row direction")};
  Option<int64_t> OptColGap{
      *this, "core-gap", llvm::cl::init(0), llvm::cl::desc(
      "Specify the gap between columns to improve corner cases")};
  Option<int64_t> OptCoreAlgo{
      *this, "core-algo", llvm::cl::init(0), llvm::cl::desc(
      "Specify the algorithm for core placement 0:vertical,1:horizontally")};
  Option<bool> OptEnableAIE2{
      *this, "en-aie2", llvm::cl::init(false), llvm::cl::desc(
      "Enable AIE2 architecture or not")};
  
  /// Configure the IOPlacement pass.
  Option<int64_t> OptFirstCol{
      *this, "first-col", llvm::cl::init(6),
      llvm::cl::desc("Specify the first col to place PLIOs")};
  Option<int64_t> OptNumShim{
      *this, "num-shim", llvm::cl::init(39),
      llvm::cl::desc("Specify the number of shim tiles to place PLIOs")};
  Option<int64_t> OptMidLine{
      *this, "mid-line", llvm::cl::init(24), llvm::cl::desc(
      "Specify the middle position for calculate the cost function")};
  Option<int64_t> OptChalIn{
      *this, "chal-in", llvm::cl::init(3),
      llvm::cl::desc("Specify the input PLIO channel in each shim")};
  Option<int64_t> OptChalOut{
      *this, "chal-out", llvm::cl::init(3),
      llvm::cl::desc("Specify the output PLIO channel in each shim")};
  Option<bool> OptEnableIOCons{
      *this, "iocons", llvm::cl::init(false), llvm::cl::desc(
      "Enable limiting the IO used in a shim for certain PLIOs")};
  
  /// Configure the PLIOMaterialize pass.
  ListOption<unsigned> OptBuffSels{
      *this, "buf-sels", llvm::cl::ZeroOrMore,
      llvm::cl::desc("Specify a list of buffer selection 1:BRAM, 0:URAM")};

  /// Configure the AXIPacking pass.
  Option<int64_t> OptAXIWidth{
      *this, "axi-width", llvm::cl::init(32), llvm::cl::desc(
      "Specify the axi width of the DDR ports in bits (32, 64, 128, ...)")};

  /// Configure the split file pass.
  Option<std::string> OptFileName{
      *this, "inputfile-name", llvm::cl::init("adf_graph_temp.cpp"),
      llvm::cl::desc("Specify the temp file name")};
  
  /// Configure the split file pass.
  Option<std::string> OptPathName{
      *this, "path-name", llvm::cl::init("adf_graph_add"),
      llvm::cl::desc("Specify the path name")};
};

std::unique_ptr<Pass> createAriesTilingPass();
std::unique_ptr<Pass> createAriesTilingPass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesFuncExtractPass();
std::unique_ptr<Pass> createAriesLoopSimplifyPass();
std::unique_ptr<Pass> createAriesMemSubviewPass();
std::unique_ptr<Pass> createAriesMemHoistPass();
std::unique_ptr<Pass> createAriesMemCopyPass();
std::unique_ptr<Pass> createAriesDependencyExtractPass();
std::unique_ptr<Pass> createAriesFuncUnrollPass();
std::unique_ptr<Pass> createAriesLocalDataForwardPass();
std::unique_ptr<Pass> createAriesL2BufferCreatePass();
std::unique_ptr<Pass> createAriesL2BufferCreatePass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesKernelInterfaceCreatePass();
std::unique_ptr<Pass> createAriesBroadcastToForwardingPass();
std::unique_ptr<Pass> createAriesDMAToIOPass();
std::unique_ptr<Pass> createAriesDMAToIOPass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesADFCellCreatePass();
std::unique_ptr<Pass> createAriesADFCellCreatePass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesCorePlacementPass();
std::unique_ptr<Pass> createAriesCorePlacementPass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesIOPlacementPass();
std::unique_ptr<Pass> createAriesIOPlacementPass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesGMIOMaterializePass();
std::unique_ptr<Pass> createAriesPLIOMaterializePass();
std::unique_ptr<Pass> createAriesPLIOMaterializePass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesAXIPackingPass();
std::unique_ptr<Pass> createAriesAXIPackingPass(const AriesOptions &opts);
std::unique_ptr<Pass> createAriesPLDataflowPass();
std::unique_ptr<Pass> createAriesBurstDetectionPass();
std::unique_ptr<Pass> createAriesFuncEliminatePass();
std::unique_ptr<Pass> createAriesPLDoubleBufferPass();
std::unique_ptr<Pass> createAriesPLSerializePass();
std::unique_ptr<Pass> createAriesKernelSplitPass();
std::unique_ptr<Pass> createAriesFileSplitPass();
std::unique_ptr<Pass> createAriesFileSplitPass(const AriesOptions &opts);

void registerAriesPasses();
void registerAriesPassPipeline();

#define GEN_PASS_CLASSES
#include "aries/Transform/Passes.h.inc"

}   // namespace aries
}   // namespace mlir


#endif // ARIES_TRANSFORM_PASSES_H