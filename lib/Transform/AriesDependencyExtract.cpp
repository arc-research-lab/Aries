#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "mlir/Dialect/Affine/Passes.h"
#include "mlir/Pass/PassManager.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;

namespace {

struct AriesDependencyExtract 
                  : public AriesDependencyExtractBase<AriesDependencyExtract> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!DependencyExtract(mod))
      signalPassFailure();
  }

private:
  // Collect dmaOp that access the external mem
  void DMACollect(AffineForOp forop, SmallVector<DmaOp, 4>& dmaOps){
    forop.walk([&](DmaOp dma){
      auto dmaSrc = dma.getSrc();
      auto dmaDst = dma.getDst();
      auto SrcSpace 
          = dyn_cast<MemRefType>(dmaSrc.getType()).getMemorySpaceAsInt();
      auto DstSpace 
          = dyn_cast<MemRefType>(dmaDst.getType()).getMemorySpaceAsInt();

      if(SrcSpace && SrcSpace == (int)mlir::aries::adf::MemorySpace::L1){
        if (!DstSpace || DstSpace!=(int)mlir::aries::adf::MemorySpace::L1) {
          dmaOps.push_back(dma);
        }
      }else if(DstSpace && DstSpace == (int)mlir::aries::adf::MemorySpace::L1){
        if (!SrcSpace || SrcSpace!=(int)mlir::aries::adf::MemorySpace::L1) {
          dmaOps.push_back(dma);
        }
      }
    });
  }

  //Check if the collected dmaOp write to the external mem
  bool IsWrite(DmaOp dma){
    auto dmaDst = dma.getDst();
    auto DstSpace 
        = dyn_cast<MemRefType>(dmaDst.getType()).getMemorySpaceAsInt();
    if(!DstSpace || DstSpace!=(int)mlir::aries::adf::MemorySpace::L1)
      return true;
    else
      return false;
  }

  // This function extracts the loop-carried flow dependencies 
  // There is a dependency if: 1) two accesses are to the same memory
  //                           2) one of the accesses is a write
  //                           3) precedence constraints
  // This is an experimental pass which should be replaced by mathmatical
  // formulation e.g. polyhedral model                      
  bool DependencyExtract (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      PassManager pm(func->getContext());
      pm.addPass(createCSEPass());
      pm.addPass(createCanonicalizerPass());
      if (failed(pm.run(func)))
        return false;

      SmallVector<AffineForOp, 6> band;

      // Find the CellOp
      CellOp cellOp = getFirstOpOfType<CellOp>(func.getBody());

      if(cellOp)
        getNestedLoopBand(cellOp.getBody(), band);
      else
        getNestedLoopBand(func.getBody(), band);

      auto innerloop = band[band.size()-1];
      SmallVector<DmaOp, 4> dmaOps;
      DMACollect(innerloop, dmaOps);

      // Simplify the loop structure before analyze the dependency.
      // There won't be any nested affine.apply ops
      PassManager pm1(func.getContext(), "func.func");
      pm1.addPass(createSimplifyAffineStructuresPass());
      (void)pm1.run(func);

      auto indexType = builder.getIndexType();
      auto zeroAttr = builder.getIntegerAttr(indexType, 0);
      // Find DmaWrite -> DmaRead pair that access the same mem
      for (auto dmaWrite : dmaOps){
        unsigned opIndex=0;
        if (!IsWrite(dmaWrite))
          continue;
        auto dst = dmaWrite.getDst();
        auto dstOffsets = dmaWrite.getDstOffsets();
        auto dstSizes   = dmaWrite.getDstSizes(); 
        auto dstStrides = dmaWrite.getDstStrides();
        auto dstTiles = dmaWrite.getDstTiles();
        auto dstDims = dmaWrite.getDstDims();
        auto dstSteps = dmaWrite.getDstSteps();
        auto dstWraps = dmaWrite.getDstWraps();
        for (auto dmaRead : dmaOps){
          if (IsWrite(dmaRead))
            continue;
          auto src = dmaRead.getSrc();
          auto srcOffsets = dmaRead.getSrcOffsets();
          auto srcSizes = dmaRead.getSrcSizes(); 
          auto srcStrides = dmaRead.getSrcStrides();
          auto srcTiles = dmaWrite.getSrcTiles();
          auto srcDims  = dmaWrite.getSrcDims();
          auto srcSteps = dmaWrite.getSrcSteps();
          auto srcWraps = dmaWrite.getSrcWraps();
          if(src != dst || srcOffsets != dstOffsets || srcSizes != dstSizes
                        || srcStrides != dstStrides || srcTiles != dstTiles
                        || srcDims  != dstDims || srcSteps != dstSteps
                        || srcWraps != dstWraps)
            continue;
          if(opIndex>0){
            llvm::errs() 
                << "More than one flow dependencies found\n";
            return false;
          }
          opIndex++;
          // If the loop variable is not included inside the access then
          // it will cause loop-carried flow dependency
          unsigned bandIndex=0;
          bool initial_flag = true;
          for(auto loop: band){
            auto vi = loop.getInductionVar();
            bool flag =false;
            Value temp;
            for(auto user: vi.getUsers()){
              if(auto dmaOp = dyn_cast<DmaOp>(user) ){
                temp = vi;
                flag =true;
              }else if(auto applyop = dyn_cast<AffineApplyOp>(user)){
                temp = applyop.getResult();
                flag =true;
              }
              if(!flag)
                continue;
              if(std::find(srcOffsets.begin(), srcOffsets.end(), temp) 
                 !=  srcOffsets.end())
                continue;
              if(bandIndex>1){
                llvm::errs() 
                  << "More than two non-single parallel loops lead"
                  << "to a flow dependency\n";
                return false;
              }else if(initial_flag){
              //Only set one loop, but can monitor more non-single loops
                if(getConstantTripCount(loop)>1){
                  initial_flag = false;
                  loop->setAttr("flow", builder.getUnitAttr());
                  dmaWrite->setAttr("write", zeroAttr);
                  dmaRead->setAttr("read", zeroAttr);
                  bandIndex++; 
                }
              }else {
                if(getConstantTripCount(loop)>1)
                  bandIndex++; 
              }
            }
          }
        }
      }
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesDependencyExtractPass() {
  return std::make_unique<AriesDependencyExtract>();
}

} // namespace aries
} // namespace mlir