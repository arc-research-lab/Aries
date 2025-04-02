#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/Utils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::affine;

namespace {

struct AriesBurstDetection : public AriesBurstDetectionBase<AriesBurstDetection> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    
    if (!BurstDetection(mod))
      signalPassFailure();
  }

private:
  // Get the accessOp, memref, AffineMap, operands, and other ops inside 
  // the innermost loop
  void getMergeOp(AffineForOp innerLoop, Value& val,  bool& direction, 
                  AffineWriteOpInterface& writeOp,
                  SmallVector<Operation*>& otherOps){
    for (auto& op: innerLoop.getBody()->getOperations()){
      if (auto read = dyn_cast<AffineReadOpInterface>(op)) {
        auto memref = read.getMemRef();
        auto result = read.getValue();
        auto type = dyn_cast<MemRefType>(memref.getType());
        if(auto memSpace = type.getMemorySpace()){
          auto intSpace = dyn_cast<IntegerAttr>(memSpace);
          if(intSpace && intSpace.getInt()==(int)MemorySpace::L3){
            val = result;
            direction = false;
          }
          else
            otherOps.push_back(&op);
        }else{//If no memSpace then default is L3 mem
          val = result;
          direction = false;
        }
      }else if (auto write = dyn_cast<AffineWriteOpInterface>(op)) {
        auto memref = write.getMemRef();
        auto valToStore = write.getValueToStore();
        auto type = dyn_cast<MemRefType>(memref.getType());
        if(auto memSpace = type.getMemorySpace()){
          auto intSpace = dyn_cast<IntegerAttr>(memSpace);
          if(intSpace && intSpace.getInt()==(int)MemorySpace::L3){
            val = valToStore;
            direction = true;
            writeOp = write;
          }
          else
            otherOps.push_back(&op);
        }else{//If no memSpace then default is L3 mem
          val = valToStore;
          direction = true;
          writeOp = write;
        }
      }else if(!dyn_cast<AffineYieldOp>(op) && !dyn_cast<scf::YieldOp>(op)){
        otherOps.push_back(&op);
      }
    }
  }
  // Get the accessOp, memref, AffineMap, operand sinside the innermost loop
  void getMemInfo(AffineForOp innerLoop, AffineMap& map,
                  SmallVector<Operation*>& accessOps, 
                  SmallVector<Value>& operands){
    for (auto& op: innerLoop.getBody()->getOperations()){
      if (auto read = dyn_cast<AffineReadOpInterface>(op)) {
        auto memref = read.getMemRef();
        auto type = dyn_cast<MemRefType>(memref.getType());
        if(auto memSpace = type.getMemorySpace()){
          auto intSpace = dyn_cast<IntegerAttr>(memSpace);
          if(intSpace && intSpace.getInt()==(int)MemorySpace::L3){
            map = read.getAffineMap();
            operands = read.getMapOperands();
            accessOps.push_back(&op);
          }
        }else{//If no memSpace then default is L3 mem
          map = read.getAffineMap();
          operands = read.getMapOperands();
          accessOps.push_back(&op);
        }
      }else if (auto write = dyn_cast<AffineWriteOpInterface>(op)) {
        auto memref = write.getMemRef();
        auto type = dyn_cast<MemRefType>(memref.getType());
        if(auto memSpace = type.getMemorySpace()){
          auto intSpace = dyn_cast<IntegerAttr>(memSpace);
          if(intSpace && intSpace.getInt()==(int)MemorySpace::L3){
            map = write.getAffineMap();
            operands = write.getMapOperands();
            accessOps.push_back(&op);
          }
        }else{//If no memSpace then default is L3 mem
          map = write.getAffineMap();
          operands = write.getMapOperands();
          accessOps.push_back(&op);
        }
      }else{
        continue;
      }
    }
  }

  // Get the coefficents and corresponding ivs of the AffineMap of the AccessOp 
  void getCoeff(AffineMap map, AffineExpr expr, int64_t& constCoEff,
                SmallVector<Value> operands,
                SmallVector<AffineForOp, 6>& band,
                SmallVector<AffineForOp, 6>& commonLoops,
                SmallVector<std::pair<int64_t, int64_t>>& loopCoEff,
                SmallVector<std::pair<int64_t, int64_t>>& commonCoEff){

    // flattened form [dims, symbols, locals, constant]
    llvm::SmallVector<int64_t> flattenedExpr;
    if (failed(getFlattenedAffineExpr(expr, map.getNumDims(),
                                      map.getNumSymbols(),
                                      &flattenedExpr)))
      return;
    auto mapSize = map.getNumDims();
    auto exprSize = flattenedExpr.size();
    constCoEff = flattenedExpr[exprSize-1];
    for (unsigned i = 0; i < mapSize; ++i) {
      auto loop = getForInductionVarOwner(operands[i]);
      if (flattenedExpr[i] == 0 || !loop)
        continue;
      int64_t srcDepth=-1, commonDepth=-1;
      auto it = llvm::find(band, loop);
      auto it1 = llvm::find(commonLoops, loop);
      if(it!=band.end()){
        srcDepth = it - band.begin();
        loopCoEff.push_back(std::pair(srcDepth, flattenedExpr[i]));
      }else if(it1!=commonLoops.end()){
        commonDepth = it1 - commonLoops.begin();
        commonCoEff.push_back(std::pair(commonDepth, flattenedExpr[i]));
      }
    }
  }

  bool coEffCompare(SmallVector<std::pair<int64_t, int64_t>> srcCoEff, 
                    SmallVector<std::pair<int64_t, int64_t>> dstCoEff){
    // Check if the number of the coefficents in src and dst is the same
    auto srcLoopEffNum = srcCoEff.size();
    auto dstLoopEffNum = dstCoEff.size();
    if(srcLoopEffNum!=dstLoopEffNum)
      return false;
    // sort the (depth, coeff) pair by the depth or to match the ivs
    llvm::sort(srcCoEff, [](const std::pair<int64_t, int64_t> &a, 
                                const std::pair<int64_t, int64_t> &b){
      return a.first < b.first;
    });
    llvm::sort(dstCoEff, [](const std::pair<int64_t, int64_t> &a, 
                                const std::pair<int64_t, int64_t> &b){
      return a.first < b.first;
    });
    // Check if the coeff are exactly the same for each iv
    for(unsigned idx = 0; idx <srcLoopEffNum; idx++)
      if(srcCoEff[idx].second != dstCoEff[idx].second)
        return false;
    return true;
  }

  // This is a very specific optimization only for the assumed situations
  // This function merge loops together to increse burst length following 
  // these criteria
  // 1) Both are perfect nested loops and have the same number of loops
  // 2) The step of the innermost loop should be 1
  // 3) All the loops share the same lb, ub and step,
  // 4) Src and Dst share the same memory access in all dims except inner
  // 5) The inner loop should be used in the last map result with coeff=1
  // 6) The last dim of map has src_cons + src_inner_ub = dst_ub + dst_inner_lb
  //    or dst_cons + dst_inner_ub = src_ub + src_inner_lb
  bool canMerge(AffineForOp& srcLoop, AffineForOp& dstLoop, 
                int64_t& lastDimSrcCons, int64_t& lastDimDstCons){
    // Step 1-2: Get the nested for loops and check the loop number and step
    SmallVector<AffineForOp, 6> srcBand;
    SmallVector<AffineForOp, 6> dstBand;
    getPerfectlyNestedLoops(srcBand, srcLoop);
    getPerfectlyNestedLoops(dstBand, dstLoop);
    SmallVector<AffineForOp, 6> commonLoops;
    if(!getCommonSurroundingLoops(*srcLoop, *dstLoop, commonLoops))
      return false;
    auto srcSize = srcBand.size();
    auto dstSize = dstBand.size();
    auto srcInner = srcBand[srcSize-1];
    auto srcInnerUb = srcInner.getConstantUpperBound();
    auto srcInnerLb = srcInner.getConstantLowerBound();
    auto dstInner = dstBand[dstSize-1];
    auto dstInnerUb = dstInner.getConstantUpperBound();
    auto dstInnerLb = dstInner.getConstantLowerBound();
    //Check if number of loops is same & the step innerLoop == 1 
    AffineForOp op; //This is a placeholder
    if(srcInner.getStepAsInt() != 1 || dstInner.getStepAsInt() != 1 ||
       srcSize != dstSize )
      return false;
    // Step 3: Check if all the loops share the same lbs, ubs and steps
    for(unsigned i = 0; i < srcSize; i++){
      auto srcForOp = srcBand[i];
      auto dstForOp = dstBand[i];
      if(srcForOp.getConstantLowerBound()!=dstForOp.getConstantLowerBound() ||
         srcForOp.getConstantUpperBound()!=dstForOp.getConstantUpperBound() ||
         srcForOp.getStepAsInt()!=dstForOp.getStepAsInt())
         return false;
    }
    // Step 4: Get the memory accessOp inside the innermost loop,
    // compare the flattened affineMap experssions to check if the affine
    // experssion is exactly the same (this need to make sure the order of the 
    // ivs of the src and dst is the same). 
    // Step 5: Check if the innermost iv is used by the last map result and 
    // has coefficent and is 1
    // Step 6: Check if the last dim of map has:
    //         src_cons + src_inner_ub = dst_cons + dst_inner_lb or
    //         or dst_cons + dst_inner_ub = src_cons + src_inner_lb

    // check if all the ivs have the same co-efficients
    // Get the access of L3 mem first
    AffineMap srcMap, dstMap;
    SmallVector<Operation*> srcAccessOps;
    SmallVector<Operation*> dstAccessOps;
    SmallVector<Value> srcOperands, dstOperands;
    srcAccessOps.clear();
    dstAccessOps.clear();
    getMemInfo(srcInner, srcMap, srcAccessOps, srcOperands);
    getMemInfo(dstInner, dstMap, dstAccessOps, dstOperands);
    // Check if there exits and only exits one L3 access in src and dst
    if(srcAccessOps.size()!=1 || dstAccessOps.size()!=1)
      return false;
    // Check if the num of result of the AffineMap is the same
    unsigned srcNumRes = srcMap.getNumResults();
    unsigned dstNumRes = dstMap.getNumResults();
    if(srcNumRes !=dstNumRes  || srcMap.getNumSymbols()!=0 || 
       dstMap.getNumSymbols()!=0)
      return false;
    // Compare if all the dim of src and dst access are the same
    // This is to gurantee the correct burst length merge
    for (unsigned i = 0; i< srcNumRes; i++) {
      auto srcExpr = srcMap.getResult(i);
      auto dstExpr = dstMap.getResult(i);
      int64_t constSrcCoEff=0, constDstCoEff=0;
      SmallVector<std::pair<int64_t, int64_t>> srcLoopCoEff, dstLoopCoEff;
      SmallVector<std::pair<int64_t, int64_t>> srcCommonCoEff, dstCommonCoEff;
      getCoeff(srcMap, srcExpr, constSrcCoEff, srcOperands, srcBand,
               commonLoops, srcLoopCoEff, srcCommonCoEff);
      getCoeff(dstMap, dstExpr, constDstCoEff, dstOperands, dstBand,
               commonLoops, dstLoopCoEff, dstCommonCoEff);
      if(!coEffCompare(srcLoopCoEff, dstLoopCoEff))
        return false;
      if(!coEffCompare(srcCommonCoEff, dstCommonCoEff))
        return false;
      if(i!=srcNumRes-1){
        if(constSrcCoEff!=constDstCoEff)
          return false;
      }else{
        auto itSrc = llvm::find_if(srcLoopCoEff, 
        [srcSize](const std::pair<int64_t, int64_t>& p) {
           return p.first == (int64_t)(srcSize-1);
        });
        auto itDst = llvm::find_if(dstLoopCoEff, 
        [dstSize](const std::pair<int64_t, int64_t>& p) {
           return p.first == (int64_t)(dstSize-1);
        });
        if(itSrc == srcLoopCoEff.end() || itDst == dstLoopCoEff.end())
          return false;
        if(itSrc->second!=1 || itDst->second!=1)
          return false;
        lastDimSrcCons = constSrcCoEff;
        lastDimDstCons = constDstCoEff;
        if((constSrcCoEff + srcInnerUb == constDstCoEff + dstInnerLb) ||
           (constDstCoEff + dstInnerUb == constSrcCoEff + srcInnerLb))
          return true;
      }
    }
    return false;
  }

  // This function separate the merge loops into different groups
  // Each group contains the loops that can be merged together
  void loopGroup(FuncOp func, 
          SmallVector<SmallVector<std::pair<int64_t, AffineForOp>, 4>>& groups){
    SmallVector<AffineForOp> mergeLoops;
    func.walk([&](AffineForOp op){
      if(op->hasAttr("merge")){
        mergeLoops.push_back(op);
      }
    });
    for(auto loop : mergeLoops){
      // Check if the loop can be grouped to any exisiting groups
      bool grouped = false;
      for(auto& group : groups){
        for(auto pair : group){
          int64_t lastDimSrcCons, lastDimDstCons;
          auto srcLoop = pair.second;
          if(canMerge(srcLoop, loop, lastDimSrcCons, lastDimDstCons)){
            group.push_back(std::pair(lastDimDstCons, loop));
            grouped = true;
            break;
          }
        }
        if(grouped)
          break;
      }
      // If the loop haven't been added to any group, create a new group
      if(!grouped){
        int64_t lastDimSrcCons, lastDimDstCons;
        SmallVector<std::pair<int64_t, AffineForOp>, 4> newGroup;
        if(!canMerge(loop, loop, lastDimSrcCons, lastDimDstCons)){
          newGroup.push_back(std::pair(lastDimDstCons, loop));
          groups.push_back(newGroup);
        }
      }
    }
  }

  // This function merges the loops in each group together
  void loopMerge(OpBuilder builder,
          SmallVector<SmallVector<std::pair<int64_t, AffineForOp>, 4>>& groups){
    auto loc = builder.getUnknownLoc();
    SmallVector<AffineForOp, 6> eliminateLoops;
    for(auto group : groups){
      llvm::sort(group, [](const std::pair<int64_t, AffineForOp>& a, 
                           const std::pair<int64_t, AffineForOp>& b) {
        return a.first < b.first;
      });
      auto sizeG = group.size();
      if(sizeG<=1)
        continue;
      auto lastCons = group[sizeG-1].first;
      // Create scf.if and move the otherOps inside each merge op in to it
      // And replace the ivs to the dst ivs, replace the memref with dst
      AffineForOp innerDstLoop;
      AffineYieldOp innerDstYiled;
      Value dstIv, dstVal;
      Block* preElseBlock = nullptr;
      scf::IfOp lastIFOp, firstIFOp;
      AffineWriteOpInterface dstWriteOp;
      SmallVector<AffineForOp, 6> dstBand;
      for( unsigned index = 0; index < sizeG; index++){
        auto pair = group[index];
        auto loop = pair.second;
        SmallVector<AffineForOp, 6> band;
        getPerfectlyNestedLoops(band, loop);
        auto innerLoop = band[band.size()-1];
        Value val;
        bool direction;
        AffineWriteOpInterface writeOp;
        SmallVector<Operation*> otherOps;
        getMergeOp(innerLoop, val, direction, writeOp, otherOps);
        if(index == 0){
          dstVal = val;
          getPerfectlyNestedLoops(dstBand, loop);
          innerDstLoop = innerLoop;
          dstIv = innerDstLoop.getInductionVar();
          auto dstUb = lastCons + innerDstLoop.getConstantUpperBound();
          innerDstLoop.setConstantUpperBound(dstUb);
          auto innerDstYiled = innerDstLoop.getBody()->getTerminator();
          dstWriteOp = writeOp;
          if(direction)
            builder.setInsertionPoint(dstWriteOp);
          else
            builder.setInsertionPoint(innerDstYiled);
        }else{
          eliminateLoops.push_back(loop);
        }
        // Create IFOp with then region, move the otherOps in it and replace
        // the ivs and val. read:direction==false, write:direction==true
        if(!direction){
          if(index != sizeG-1){
            auto Const = group[index+1].first;
            auto indexAttr = builder.getIndexAttr(Const);
            auto indexValue = builder.create<arith::ConstantOp>(loc, indexAttr);
            auto cond 
                 = builder.create<arith::CmpIOp>(loc, arith::CmpIPredicate::slt, 
                                                 dstIv, indexValue);
            auto ifOp  = builder.create<scf::IfOp>(loc, cond, true);
            auto destIfblock = &ifOp.getThenRegion().front();
            auto ifYiledOp = destIfblock->getTerminator();
            for(auto op : otherOps){
              op->moveBefore(ifYiledOp);
            }
            for (unsigned i = 0; i < band.size(); i++) {
              auto oldIV = band[i].getInductionVar();
              auto newIV = dstBand[i].getInductionVar();
              oldIV.replaceUsesWithIf(newIV,[&](OpOperand &use){
                  return ifOp->isProperAncestor(use.getOwner());
              });
            }
            val.replaceUsesWithIf(dstVal,[&](OpOperand &use){
              return ifOp->isProperAncestor(use.getOwner());
            });
            auto destElseblock = &ifOp.getElseRegion().front();
            auto elseYiledOp = destElseblock->getTerminator();
            builder.setInsertionPoint(elseYiledOp);
            lastIFOp = ifOp;
          }else{
            auto lastElseblock = &lastIFOp.getElseRegion().front();
            auto lastYiledOp = lastElseblock->getTerminator();
            for(auto op : otherOps){
              op->moveBefore(lastYiledOp);
            }
            for (unsigned i = 0; i < band.size(); i++) {
              auto oldIV = band[i].getInductionVar();
              auto newIV = dstBand[i].getInductionVar();
              oldIV.replaceUsesWithIf(newIV,[&](OpOperand &use){
                  return lastIFOp->isProperAncestor(use.getOwner());
              });
            }
            val.replaceUsesWithIf(dstVal,[&](OpOperand &use){
              return lastIFOp->isProperAncestor(use.getOwner());
            });
          }
        }else{
          if(index != sizeG-1){
            auto Const = group[index+1].first;
            auto indexAttr = builder.getIndexAttr(Const);
            auto indexValue = builder.create<arith::ConstantOp>(loc, indexAttr);
            auto cond 
                 = builder.create<arith::CmpIOp>(loc, arith::CmpIPredicate::slt, 
                                                 dstIv, indexValue);
            TypeRange types = {val.getType()};
            auto ifOp = builder.create<scf::IfOp>(loc, types, cond, true, true);
            auto destIfblock = &ifOp.getThenRegion().front();
            builder.setInsertionPointToStart(destIfblock);
            SmallVector<Value> results0({val});
            auto ifYiledOp = builder.create<scf::YieldOp>(loc, results0);
            if(index == 0)
              firstIFOp = ifOp;
            if(preElseBlock){
              builder.setInsertionPointAfter(ifOp);
              SmallVector<Value> results0(ifOp.getResults());
              builder.create<scf::YieldOp>(loc, results0);
            }
            for(auto op : otherOps){
              op->moveBefore(ifYiledOp);
            }
            for (unsigned i = 0; i < band.size(); i++) {
              auto oldIV = band[i].getInductionVar();
              auto newIV = dstBand[i].getInductionVar();
              oldIV.replaceUsesWithIf(newIV,[&](OpOperand &use){
                  return ifOp->isProperAncestor(use.getOwner());
              });
            }
            preElseBlock = &ifOp.getElseRegion().front();
            builder.setInsertionPointToStart(preElseBlock);
            lastIFOp = ifOp;
          }else{
            SmallVector<Value> results0({val});
            auto lastYiledOp = builder.create<scf::YieldOp>(loc, results0);
            for(auto op : otherOps){
              op->moveBefore(lastYiledOp);
            }
            for (unsigned i = 0; i < band.size(); i++) {
              auto oldIV = band[i].getInductionVar();
              auto newIV = dstBand[i].getInductionVar();
              oldIV.replaceUsesWithIf(newIV,[&](OpOperand &use){
                  return lastIFOp->isProperAncestor(use.getOwner());
              });
            }
            dstVal.replaceUsesWithIf(firstIFOp.getResult(0),[&](OpOperand &use){
              if(use.getOwner() == dstWriteOp)
                return true;
              else
                return false;
            });
          }
        }
      }
    }
    //Eliminate loops already been merged
    for(auto loop : eliminateLoops)
      loop.erase();
  }

  // This pass assumes that function marked by "L3" only plays
  // the role of accessing the L3 memory and push/pop the data to the stream.
  // TODO: This pass is a work around, and need to be rigourously implemented
  // by using polyhedral analysis
  bool BurstDetection (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    // Detect if it is the pl function that interacts with L3 memory
    // This pass tries to merge the memory access together, in order to
    // increase the burst length.
    mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.pl") || 
         ! (func->hasAttr("load") || func->hasAttr("store")))
        return WalkResult::advance();
      SmallVector<SmallVector<std::pair<int64_t, AffineForOp>, 4>> groups;
      // Separate loops that can be merged into groups
      loopGroup(func, groups);
      // Merge the loops in each group together
      loopMerge(builder, groups);
      return WalkResult::advance();
    });
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesBurstDetectionPass() {
  return std::make_unique<AriesBurstDetection>();
}

} // namespace aries
} // namespace mlir