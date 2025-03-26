#ifndef ARIES_TRANSFORM_UTILS_H
#define ARIES_TRANSFORM_UTILS_H


#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace affine;
using namespace func;

namespace mlir {
namespace aries {

// Modified UnrollFull: Use function_ref to anotote operations during unroll.
LogicalResult loopUnrollFull(AffineForOp forOp, 
              function_ref<void(unsigned, Operation *, OpBuilder)> annotateFn);

template <typename OpType>
OpType getFirstOpOfType(Region &region) {
  for (Operation &op : region.getOps()){
    if (auto specificOp = dyn_cast<OpType>(&op))
      return specificOp;
    for (Region &nestedRegion : op.getRegions())
      if (auto nestedSpecificOp = getFirstOpOfType<OpType>(nestedRegion))
        return nestedSpecificOp;
  }
  return nullptr;
}

void getSurroundingLoops(Operation &a,  SmallVector<AffineForOp, 6>& band, 
                         bool fromOuterMost = true);

bool getCommonSurroundingLoops(Operation &a, Operation &b, 
                               SmallVector<AffineForOp, 6>& commonLoops);

unsigned getLoopNum(Operation *op, AffineForOp &loop);

AffineForOp getLoopBandFromOutermost(AffineForOp forOp,
                                     SmallVector<AffineForOp, 6> &band);

void getLoopBandFromInnermost(AffineForOp forOp, 
                              SmallVector<AffineForOp, 6> &band);

// Extend getPerfectlyNestedLoops func to imperfect nested loops
void getNestedLoops(SmallVectorImpl<AffineForOp> &nestedLoops, 
                    AffineForOp root);

// Get the perfect nested for loops within a region and return them in the band
void getPerfectNestedLoopBand(Region &region, SmallVector<AffineForOp, 6> &band, 
  bool reverse = false);

// Get all the affine.for loops within a region and return them in the band
void getNestedLoopBand(Region &region, SmallVector<AffineForOp, 6> &band, 
                       bool reverse = false);

/// Built-in Function: Checks whether a loop nest is hyper-rectangular or not.
LogicalResult checkIfHyperRectangular(MutableArrayRef<AffineForOp> input);

// Find topFunc and collect the Callee functions
bool topFind(ModuleOp mod, FuncOp& topFunc, StringRef topFuncName);

// Find the callee function called in the topFunc
bool calleeFind(ModuleOp mod, FuncOp topFunc, FuncOp &calleeFuncOp);

void addMetaData(OpBuilder builder, FuncOp func, SmallVector<Value, 6>& inputs,
                 SmallVector<Attribute, 4>& newMetaArray);

}   // namespace aries
}   // namespace mlir


#endif // ARIES_TRANSFORM_UTILS_H