#include "aries/Transform/Utils.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/Utils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/Dialect/Affine/Analysis/AffineAnalysis.h"
#include "mlir/Dialect/Affine/Analysis/AffineStructures.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/IntegerSet.h"
#include "llvm/Support/Debug.h"

using namespace mlir;
using namespace affine;
using namespace func;
using namespace presburger;

namespace mlir {
namespace aries {

/// Unrolls this loop completely.
LogicalResult loopUnrollFull(AffineForOp forOp, 
              function_ref<void(unsigned, Operation *, OpBuilder)> annotateFn) {
  std::optional<uint64_t> mayBeConstantTripCount 
                                    = mlir::affine::getConstantTripCount(forOp);
  if (mayBeConstantTripCount.has_value()) {
    uint64_t tripCount = *mayBeConstantTripCount;
    if (tripCount == 0)
      return success();
    if (tripCount == 1)
      return promoteIfSingleIteration(forOp);
    return loopUnrollByFactor(forOp, tripCount, annotateFn);
  }
  return failure();
}

// Traverse all the surrounding 'affine.for' of op
// If fromOuterMost is true: band[0] is the outermost loop
void getSurroundingLoops(Operation &op, SmallVector<AffineForOp, 6>& band,
                         bool fromOuterMost) {
  auto *currOp = op.getParentOp();
  AffineForOp currAffineForOp;
  while (currOp) {
    if (AffineForOp currAffineForOp = dyn_cast<AffineForOp>(currOp))
      band.push_back(currAffineForOp);
    currOp = currOp->getParentOp();
  }
  if(fromOuterMost)
    std::reverse(band.begin(), band.end());
}

/// Get the common loops of op 'a' and 'b'
/// Only return true when all the parent loops are common loops 
bool getCommonSurroundingLoops(Operation &a, Operation &b, 
                               SmallVector<AffineForOp, 6>& commonLoops){
  SmallVector<Value, 4> ivsA;
  SmallVector<Value, 4> ivsB;
  getAffineIVs(a, ivsA);
  getAffineIVs(b, ivsB);
  if(ivsA.size()!=ivsB.size())
    return false;
  for (unsigned i = 0; i < ivsA.size(); ++i) {
    if (ivsA[i] != ivsB[i])
      return false;
    commonLoops.push_back(ivsA[i].getDefiningOp<AffineForOp>());
  }
  return true;
}

unsigned getLoopNum(Operation *op, AffineForOp &loop) {
  unsigned loopNum = 0;
  for (auto &region : op->getRegions())
    for (auto &block : region)
      for (auto &op : block)
        if (auto forOp = dyn_cast<AffineForOp>(op)){
          loop = forOp;
          loopNum++;
        }
  return loopNum;
}

AffineForOp getLoopBandFromOutermost(AffineForOp forOp,
                                     SmallVector<AffineForOp, 6> &band) {
  band.clear();
  auto currentLoop = forOp;
  while (true) {
    band.push_back(currentLoop);
    AffineForOp emptyLoop;
    if (getLoopNum(currentLoop, emptyLoop) == 1)
      currentLoop = *currentLoop.getOps<AffineForOp>().begin();
    else
      break;
  }
  return band.back();
}

/// Get the whole loop band given the innermost loop and return it in "band".
void getLoopBandFromInnermost(AffineForOp forOp, 
                              SmallVector<AffineForOp, 6> &band) {
  band.clear();
  SmallVector<AffineForOp, 6> reverseBand;

  auto currentLoop = forOp;
  while (true) {
    reverseBand.push_back(currentLoop);

    auto parentLoop = currentLoop->getParentOfType<AffineForOp>();
    if (!parentLoop)
      break;
    AffineForOp emptyForOp;
    if (getLoopNum(parentLoop, emptyForOp) == 1)
      currentLoop = parentLoop;
    else
      break;
  }
  band.append(reverseBand.rbegin(), reverseBand.rend());
}

// Extend getPerfectlyNestedLoops func to imperfect nested loops
void getNestedLoops(
    SmallVectorImpl<AffineForOp> &nestedLoops, AffineForOp root) {
  SmallVector<AffineForOp> loops;
  for (unsigned i = 0; i < std::numeric_limits<unsigned>::max(); ++i) {
    nestedLoops.push_back(root);
    AffineForOp loop;
    auto loopNum = getLoopNum(root, loop);
    if(loopNum != 1)
      return;
    root = loop;
  }
}

// Get all the affine.for loops within a region and return them in the band
void getPerfectNestedLoopBand(Region &region, SmallVector<AffineForOp, 6> &band, 
  bool reverse) {
  auto forOp = getFirstOpOfType<AffineForOp>(region);
  getPerfectlyNestedLoops(band, forOp);
  if (reverse)
    std::reverse(band.begin(), band.end());
}

// Get all the affine.for loops within a region and return them in the band
void getNestedLoopBand(Region &region, SmallVector<AffineForOp, 6> &band, 
                       bool reverse) {
  auto forOp = getFirstOpOfType<AffineForOp>(region);
  getNestedLoops(band, forOp);
  if (reverse)
    std::reverse(band.begin(), band.end());
}

/// Built-in Function: Checks whether a loop nest is hyper-rectangular or not.
LogicalResult checkIfHyperRectangular(MutableArrayRef<AffineForOp> input) {
  FlatAffineValueConstraints cst;
  SmallVector<Operation *, 8> ops(input.begin(), input.end());
  // 0-d or 1-d is trivially hyper-rectangular.
  if (input.size() <= 1)
    return success();
  if (failed(getIndexSet(ops, &cst))) {
    llvm::dbgs() << "Index set computation failed!\n";
    return failure();
  }
  if (!cst.isHyperRectangular(0, input.size())) {
    llvm::dbgs()<< "Non-hyperrectangular nests not supported for tiling!\n";
    return failure();
  }
  return success();
}

// Find topFunc and collect the Callee functions
bool topFind(ModuleOp mod, FuncOp& topFunc, StringRef topFuncName){
  bool topFunc_flag = false;
  for (FuncOp func : mod.getOps<FuncOp>()) {
    // Check if the attribute exists in this function.
    if (func->getAttr(topFuncName)){
      topFunc = func;
      topFunc_flag = true;
    }
  }
  return topFunc_flag;
}

// Find the callee function called in the topFunc
bool calleeFind(ModuleOp mod, FuncOp topFunc, FuncOp &calleeFuncOp){
  bool calleeFunc_flag = false;
  SmallVector<FuncOp, 2> CalleeList;
  auto topFuncName = topFunc.getName();
  //Collect the callee function list
  for (FuncOp func : mod.getOps<FuncOp>()) {
    if (func.getName()!= topFuncName)
      CalleeList.push_back(func);
  }

  topFunc.walk([&](CallOp callerFuncOp){
    auto calleeName = callerFuncOp.getCallee();
    for(auto funcOp : CalleeList) {
      if (funcOp.getName() == calleeName) {
        calleeFuncOp = funcOp;
        calleeFunc_flag = true;
        break;
      }
    }
  });
  return calleeFunc_flag;
}

// This function is to include the unused arguments into vector inputs.
// These arguments is to represent the size of the dynamic memory which will
// be used during nd dynamic memory serialization.
// New meta information will be collected
void addMetaData(OpBuilder builder, FuncOp func, SmallVector<Value, 6>& inputs,
                 SmallVector<Attribute, 4>& newMetaArray){
  SmallVector<SmallVector<int64_t, 4>, 4> metaArray;
  // Tranverse the meta_data and put it into the pl_func
  auto metaAttr= func->getAttrOfType<ArrayAttr>("meta_data");
  if (metaAttr) {
    for (auto rowAttr : metaAttr) {
      if (auto rowArrayAttr = dyn_cast<ArrayAttr>(rowAttr)) {
        SmallVector<int64_t, 4> row;
        for (auto element : rowArrayAttr) {
          if (auto intAttr = dyn_cast<IntegerAttr>(element)) {
            row.push_back(intAttr.getInt());
          }
        }
        metaArray.push_back(row);
      }
    }
  }
  // Add the size of the memory into argument list of plFunc
  for(auto argInfo : metaArray){
    auto idx = argInfo[0];
    auto arg = func.getArgument(idx);
    auto it = llvm::find(inputs, arg);
    if(it == inputs.end())
      continue;
    SmallVector<Attribute, 4> tempAttr;
    auto argDis = std::distance(inputs.begin(), it);
    auto argAttr = builder.getI64IntegerAttr(argDis);
    tempAttr.push_back(argAttr);
    for (unsigned i=1; i < argInfo.size(); i++){
      auto sizeArg = func.getArgument(argInfo[i]);
      auto itSize = llvm::find(inputs, sizeArg);
      int64_t dis;
      if(itSize != inputs.end()){
        dis = std::distance(inputs.begin(), itSize);
      }else{
        dis = inputs.size();
        inputs.push_back(sizeArg);
      }
      auto attr = builder.getI64IntegerAttr(dis);
      tempAttr.push_back(attr);
    }
    auto arrayAttr = builder.getArrayAttr(tempAttr);
    newMetaArray.push_back(arrayAttr);
  }
}

}   // namespace aries
}   // namespace mlir