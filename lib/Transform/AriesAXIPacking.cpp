#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Analysis/Liveness.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
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

struct AriesAXIPacking 
       : public AriesAXIPackingBase<AriesAXIPacking> {
public:
  AriesAXIPacking() = default;
  AriesAXIPacking(const AriesOptions &opts) {
    AXIWidth=opts.OptAXIWidth;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!AXIPacking(mod))
      signalPassFailure();
  }

private:
  // This function checks if innermost loop is used by the last dim of affineMap
  // of an AffineLoadOp/AffineSoreOp, and the coeff of the innermost loop = 1
  // Then update the last dim of affineMap and the upperbound of innermost
  bool getPackList(Value arg, unsigned packNum, size_t& numUser,
                   SmallVector<std::pair<AffineForOp, int64_t>, 4>& loopList,
                   SmallVector<std::pair<Operation*, AffineMap>, 4>& packList){
    auto &context = getContext();
    for(auto user : arg.getUsers()){
      numUser++;
      AffineMap map;
      SmallVector<Value> operands;
      Operation* affineOp;
      SmallVector<AffineForOp, 6> band;
      if (auto read = dyn_cast<AffineLoadOp>(user)) {
        map = read.getAffineMap();
        operands = read.getMapOperands();
        affineOp = read;
      }else if(auto write = dyn_cast<AffineStoreOp>(user)){
        map = write.getAffineMap();
        operands = write.getMapOperands();
        affineOp = write;
      }else{
        continue;
      }
      getSurroundingLoops(*affineOp, band);
      auto mapSize = map.getNumResults();
      auto dimSize = map.getNumDims();
      auto symSize = map.getNumSymbols();
      auto lastDimExpr = map.getResult(mapSize-1);
      // flattened form [dims, symbols, locals, constant]
      llvm::SmallVector<int64_t> flattenedExpr;
      llvm::SmallVector<int64_t> newFlattenedExpr;
      if (failed(getFlattenedAffineExpr(lastDimExpr, dimSize, symSize,
                                        &flattenedExpr)))
        return false;
      // Check if innerLoop has coeff == 1 && Update AffineMap
      for (unsigned i = 0; i < dimSize; ++i) {
        auto loop = getForInductionVarOwner(operands[i]);
        auto it = llvm::find(band, loop);
        if(it==band.end())
          return false;
        auto coeff = flattenedExpr[i];
        unsigned depth = it - band.begin();
        if(depth != (unsigned)(band.size()-1)){ // If not, update the expr
          if(coeff%packNum!=0){
            llvm::errs() << "Invalid AXI packing, size not dividable\n";
            return false;
          }
          auto newCoeff = (int64_t)(coeff / packNum);
          newFlattenedExpr.push_back(newCoeff);
        }else{ // If used by the innermost loop, update the upperbound && record
          auto upbound = loop.getConstantUpperBound();
          if(upbound%packNum!=0){
            llvm::errs() << "Invalid AXI packing, loop bound not dividable\n";
            return false;
          }
          auto newBound = (int64_t)(upbound/packNum);
          loopList.push_back(std::pair(loop, newBound));
          if(coeff!=1)
            return false;
          newFlattenedExpr.push_back(coeff);
        }
      }
      auto exprSize = flattenedExpr.size();
      for(unsigned i = dimSize; i < exprSize; ++i){
        auto coeff = flattenedExpr[i];
        if(coeff%packNum!=0)
          return false;
        auto newCoeff = (int64_t)(coeff / packNum);
        newFlattenedExpr.push_back(newCoeff);
      }
      // Get new experssion for the last dim
      auto newLastExpr = getAffineExprFromFlatForm(newFlattenedExpr, dimSize,
                                                   symSize, {}, &context);
      // Update affineMap
      SmallVector<AffineExpr, 4> newExprs(map.getResults().begin(), 
                                          map.getResults().end());
      newExprs.back() = newLastExpr;
      auto newMap = AffineMap::get(dimSize, symSize, newExprs, &context);
      packList.push_back(std::pair(affineOp, newMap));
    }
    return true;
  }

  void loadMerge(OpBuilder builder, AffineLoadOp read, MemRefType type, 
                 MemRefType newType, unsigned packNum, unsigned& cnt){
    auto loc = builder.getUnknownLoc();
    auto elemType = type.getElementType();
    auto typeWidth = type.getElementTypeBitWidth();
    auto result = read.getResult();
    auto newElemType = newType.getElementType();
    SmallVector<OpFoldResult> sizes;
    sizes.push_back(builder.getIndexAttr(1));
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    auto packAttr = builder.getIntegerAttr(indexType, packNum);
    SmallVector<AffineForOp, 6> band;
    getSurroundingLoops(*read, band);
    auto outerLoop = band[0];
    auto innerLoop = band[band.size()-1];
    auto innerUb = innerLoop.getConstantUpperBound();
    std::string streamStr = "stream" + std::to_string(innerUb);
    auto streamAttr = builder.getStringAttr(streamStr);
    builder.setInsertionPoint(outerLoop);
    auto allocOp 
         = builder.create<AllocOp>(loc, sizes, newElemType, streamAttr);
    auto zeroValue = builder.create<arith::ConstantOp>(loc, zeroAttr);
    SmallVector<Value> zeroValues(1, zeroValue);
    // Create newForOps for reading data from wider stream and write to
    // narrower stream
    builder.setInsertionPointAfter(outerLoop);
    SmallVector<AffineForOp, 4> newForOps;
    for (auto loop: band){
      auto newForOp 
           = builder.create<AffineForOp>(loc,
                                         loop.getLowerBoundOperands(),
                                         loop.getLowerBoundMap(),
                                         loop.getUpperBoundOperands(),
                                         loop.getUpperBoundMap(),
                                         loop.getStepAsInt());
      newForOps.push_back(newForOp);
      builder.setInsertionPointToStart(newForOp.getBody());
    }
    auto newOuterForOp = newForOps[0];
    auto newInnerForOp = newForOps[newForOps.size()-1];
    auto attr = outerLoop->getAttr("load");
    auto cntAttr = builder.getIntegerAttr(indexType, cnt++); 
    newOuterForOp->setAttr("load", attr);
    newOuterForOp->setAttr("func", cntAttr);
    newInnerForOp->setAttr("pipeline_ii", packAttr);
    // Create new AffineLoad to load data from wider stream/new alloc
    auto newLoad = builder.create<AffineLoadOp>(loc, allocOp, zeroValues);
    auto newResult = newLoad.getResult();
    builder.setInsertionPointAfter(newLoad);
    auto forOp = builder.create<AffineForOp>(loc, 0, packNum);
    forOp->setAttr("pipeline_ii", oneAttr);
    auto entryBlock = forOp.getBody();
    auto forYiledOp = dyn_cast<AffineYieldOp>(entryBlock->getTerminator());
    builder.setInsertionPoint(forYiledOp);
    // Insert GetIntSliceOp to transfer data from newType to oldType 
    // Create the ub for slicing
    auto hiExpr = builder.getAffineDimExpr(0) * typeWidth + typeWidth-1;
    auto hiMap = AffineMap::get(1, 0, hiExpr);
    SmallVector<Value, 1> hiOperands = {forOp.getInductionVar()};
    auto hiVal = builder.create<AffineApplyOp>(loc, hiMap, hiOperands);
    // Create the lb for slicing
    auto loExpr = builder.getAffineDimExpr(0) * typeWidth;
    auto loMap = AffineMap::get(1, 0, loExpr);
    SmallVector<Value, 1> loOperands = {forOp.getInductionVar()};
    auto loVal = builder.create<AffineApplyOp>(loc, loMap, loOperands);
    GetIntSliceOp slice;
    Value valToGet;
    if(auto floatType = dyn_cast<FloatType>(elemType)){
      auto intType = IntegerType::get(builder.getContext(), typeWidth);
      slice = builder.create<GetIntSliceOp>(loc, intType, newResult, 
                                            hiVal, loVal);
      valToGet = builder.create<arith::BitcastOp>(loc, elemType, slice);
    }else{
      slice = builder.create<GetIntSliceOp>(loc, elemType, newResult,
                                               hiVal, loVal);
      valToGet = slice.getResult();
    }
    // Move the use into the AffineForOp
    SmallVector<Operation*, 4> users;
    for(auto use: result.getUsers()){
      use->moveBefore(forYiledOp);
    }
    result.replaceAllUsesWith(valToGet);
    // Create StoreOp to new Alloc after original read
    builder.setInsertionPointAfter(read);
    builder.create<AffineStoreOp>(loc, result, allocOp, zeroValues);
  }

  void storeSplit(OpBuilder builder, AffineStoreOp write, MemRefType type, 
                 MemRefType newType, unsigned packNum, unsigned& cnt){
    auto loc = builder.getUnknownLoc();
    auto typeWidth = type.getElementTypeBitWidth();
    auto newElemType = newType.getElementType();
    SmallVector<OpFoldResult> sizes;
    sizes.push_back(builder.getIndexAttr(1));
    auto indexType = builder.getIndexType();
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    auto oneAttr = builder.getIntegerAttr(indexType, 1);
    auto packAttr = builder.getIntegerAttr(indexType, packNum);
    SmallVector<AffineForOp, 6> band;
    getSurroundingLoops(*write, band);
    auto outerLoop = band[0];
    auto innerLoop = band[band.size()-1];
    auto innerUb = innerLoop.getConstantUpperBound();
    std::string streamStr = "stream" + std::to_string(innerUb);
    auto streamAttr = builder.getStringAttr(streamStr);
    builder.setInsertionPoint(outerLoop);
    auto allocOp 
         = builder.create<AllocOp>(loc, sizes, newElemType, streamAttr);
    auto zeroValue = builder.create<arith::ConstantOp>(loc, zeroAttr);
    SmallVector<Value> zeroValues(1, zeroValue);
    // Create new AffineloadOp from wider stream
    builder.setInsertionPoint(write);
    auto newLoad = builder.create<AffineLoadOp>(loc, allocOp, zeroValues);
    auto newResult = newLoad.getResult();
    // Create newForOps for reading data from wider stream and write to
    // narrower stream
    builder.setInsertionPoint(outerLoop);
    SmallVector<AffineForOp, 4> newForOps;
    for (auto loop: band){
      auto newForOp 
           = builder.create<AffineForOp>(loc,
                                         loop.getLowerBoundOperands(),
                                         loop.getLowerBoundMap(),
                                         loop.getUpperBoundOperands(),
                                         loop.getUpperBoundMap(),
                                         loop.getStepAsInt());
      newForOps.push_back(newForOp);
      if(loop->hasAttr("hoist"))
        newForOp->setAttr("hoist", builder.getUnitAttr());
      if(loop->hasAttr("Array_Partition"))
        newForOp->setAttr("Array_Partition", builder.getUnitAttr());
      if(loop->hasAttr("reduction"))
        newForOp->setAttr("reduction", builder.getUnitAttr());
      builder.setInsertionPointToStart(newForOp.getBody());
    }
    auto newOuterForOp = newForOps[0];
    auto newInnerForOp = newForOps[newForOps.size()-1];
    auto attr = outerLoop->getAttr("store");
    auto cntAttr = builder.getIntegerAttr(indexType, cnt++); 
    newOuterForOp->setAttr("store", attr);
    newOuterForOp->setAttr("func", cntAttr);
    newInnerForOp->setAttr("pipeline_ii", packAttr);
    auto forOp = builder.create<AffineForOp>(loc, 0, packNum);
    forOp->setAttr("pipeline_ii", oneAttr);
    auto entryBlock = forOp.getBody();
    auto forYiledOp = dyn_cast<AffineYieldOp>(entryBlock->getTerminator());
    // Create temp reg to store newType
    builder.setInsertionPoint(forOp);
    auto intAttr = builder.getIntegerAttr(newElemType, 0);
    auto zeroVal = builder.create<arith::ConstantOp>(loc, newElemType, intAttr);
    auto temp = builder.create<IntToAPInt>(loc, newElemType, zeroVal);
    builder.setInsertionPoint(forYiledOp);
    // Move definingOp of val inside forOp
    auto val = write.getValueToStore();
    auto valType = val.getType();
    auto defineOp = val.getDefiningOp();
    if(defineOp)
      defineOp->moveBefore(forYiledOp);
    // Create the ub for slicing
    auto hiExpr = builder.getAffineDimExpr(0) * typeWidth + typeWidth-1;
    auto hiMap = AffineMap::get(1, 0, hiExpr);
    SmallVector<Value, 1> hiOperands = {forOp.getInductionVar()};
    auto hiVal = builder.create<AffineApplyOp>(loc, hiMap, hiOperands);
    // Create the lb for slicing
    auto loExpr = builder.getAffineDimExpr(0) * typeWidth;
    auto loMap = AffineMap::get(1, 0, loExpr);
    SmallVector<Value, 1> loOperands = {forOp.getInductionVar()};
    auto loVal = builder.create<AffineApplyOp>(loc, loMap, loOperands);
    Value valToSet;
    if(auto floatType = dyn_cast<FloatType>(valType)){ 
      auto width = floatType.getWidth();
      auto intType = IntegerType::get(builder.getContext(), width);                                      
      valToSet = builder.create<arith::BitcastOp>(loc, intType, val);
    }else{
      valToSet = val;
    }
    builder.create<SetIntSliceOp>(loc, temp, hiVal, loVal, valToSet);
    // Create AffineStoeOp to store temp to wider stream/allocOp
    builder.setInsertionPointAfter(forOp);
    builder.create<AffineStoreOp>(loc, temp, allocOp, zeroValues);
    // Update value to store in original AffineStoreOp
    write.setOperand(0, newResult);
  }

  void applyPacking(OpBuilder builder, BlockArgument arg, unsigned index,
                     MemRefType type, unsigned packNum,
                     SmallVector<Type,8>& inTypes,
                     SmallVector<std::pair<AffineForOp, int64_t>, 4>& loopList,
                     SmallVector<std::pair<Operation*, AffineMap>, 4>& packlist,
                     SmallVector<AffineLoadOp, 4>& eliminateOps){
    auto loc = builder.getUnknownLoc();
    auto shape = type.getShape();
    auto rank = type.getRank();
    auto typeWidth = type.getElementTypeBitWidth();
    auto newTypeWidth = typeWidth * packNum;
    auto newType = builder.getIntegerType(newTypeWidth);
    // Update innerLoop Upperbound
    for(auto loopPair : loopList){
      auto loop = loopPair.first;
      auto ub = loopPair.second;
      loop.setConstantUpperBound(ub);
    }

    // Update arguments in func
    SmallVector<int64_t> sizesInt(shape.begin(),shape.end());
    // Deal with dynmic shape
    if (sizesInt[rank-1]>0)
      sizesInt[rank-1] = sizesInt[rank-1] / packNum;
    auto newMemRefType = MemRefType::get(sizesInt, newType);
    inTypes[index] = newMemRefType;
    arg.setType(newMemRefType);

    // Update access map && add logic to send new data to stream
    unsigned cnt = 0;
    for(auto packPair : packlist){
      auto op = packPair.first;
      auto map = packPair.second;
      if(auto read = dyn_cast<AffineLoadOp>(op)){
        // Update the access map
        read.setMap(map);
        auto result = read.getResult();
        auto operands = read.getOperands();
        SmallVector<Value, 4> indices(operands.begin() + 1, operands.end()); 
        builder.setInsertionPoint(read);
        auto newRead 
             = builder.create<AffineLoadOp>(loc, newType, arg, indices, map);
        auto newResult = newRead.getResult();
        result.replaceAllUsesWith(newResult);
        eliminateOps.push_back(read);
        loadMerge(builder, newRead, type, newMemRefType, packNum, cnt);
      }else if(auto write = dyn_cast<AffineStoreOp>(op)){
        // Update the access map
        write.setMap(map);
        storeSplit(builder, write, type, newMemRefType, packNum, cnt);
      }
    }             
  }
  
  // This function pack the L3 memory to specified port width in order to
  // increase the L3 access bandwidth.
  // Arguments of plFunc with MemRefType will be packed and the index will be
  // returned in argList
  void mergeAXIPort (OpBuilder builder,FuncOp& plFunc, unsigned axiWidth,
                     SmallVector<int64_t, 4>& argList){
    auto inTypes = SmallVector<Type,8>(plFunc.getArgumentTypes().begin(),
                                       plFunc.getArgumentTypes().end());
    auto outTypes = plFunc.getResultTypes();
    SmallVector<AffineLoadOp, 4> eliminateOps;
    auto argNum= plFunc.getNumArguments();
    for(unsigned i = 0; i < argNum; i++){
      auto arg = plFunc.getArgument(i);
      if(!dyn_cast<MemRefType>(arg.getType()))
        continue;
      auto type = dyn_cast<MemRefType>(arg.getType());
      if(auto memSpace = type.getMemorySpace()){
        auto intSpace = dyn_cast<IntegerAttr>(memSpace);
        if(!intSpace || intSpace.getInt()!=(int)MemorySpace::L3)
          continue;
      }
      auto typeWidth = type.getElementTypeBitWidth();
      auto packNum = (unsigned)(axiWidth / typeWidth); 
      if(packNum<=1)
        continue;
      SmallVector<std::pair<AffineForOp, int64_t>, 4> loopList;
      SmallVector<std::pair<Operation*, AffineMap>, 4> packlist;
      size_t numUser = 0;
      if(!getPackList(arg, packNum, numUser, loopList, packlist))
        continue;
      
      if(loopList.size()!=packlist.size() || loopList.size()!= numUser)
        continue;
      applyPacking(builder, arg, i, type, packNum, inTypes, loopList, packlist, 
                   eliminateOps);
      argList.push_back(i);

    }
    for(auto read: llvm::make_early_inc_range(eliminateOps))
      read.erase();
    plFunc.setType(builder.getFunctionType(inTypes, outTypes));
  }

  // Update the function and the corresponding argument list and newType
  bool updatePair(CallOp call, SmallVector<int64_t, 4> argIdxs, FuncOp topFunc,
  FuncOp func, SmallVector<std::tuple<int64_t, Operation*, Type>, 4>& pairVec){
    auto inTypes = SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                       func.getArgumentTypes().end());
    // Tranverse the args need to be updated in the callee function
    for(auto idx : argIdxs){
      auto operand = call.getOperand(idx);
      auto typeNew = inTypes[idx];
      // Get the argument index in the topFunc
      auto args = topFunc.getArguments();
      auto itArg = std::find(args.begin(), args.end(), operand);
      int64_t dis;
      if (itArg != args.end()){
        dis = std::distance(args.begin(), itArg);
        auto itTuple = std::find_if(pairVec.begin(), pairVec.end(),
                            [&](std::tuple<int64_t, Operation*, Type> &tuple){
                            return std::get<0>(tuple) == dis;});
        // Check if the arguments has already been recorded
        if(itTuple != pairVec.end()){
          // If already recorded, make sure the saved type is the same
          if(std::get<2>(*itTuple)!=typeNew)
            return false;
        }else{ // Add the tuple into the Smallvector
           std::tuple<int64_t, Operation*, Type> newTuple 
                                                  = {dis, nullptr, typeNew};
           pairVec.push_back(newTuple);
        }
      }else{
        auto defineOp = operand.getDefiningOp();
        if(!defineOp)
          return false;
        else{
          auto itTuple = std::find_if(pairVec.begin(), pairVec.end(),
                            [&](std::tuple<int64_t, Operation*, Type> &tuple){
                            return std::get<1>(tuple) == defineOp;});
          if(itTuple != pairVec.end()){
            if(std::get<2>(*itTuple)!=typeNew)
              return false;
          }else{//TODO: Handle more defining operations
             if(auto castOp = dyn_cast<CastOp>(defineOp)){
                auto src = castOp.getSource();
                auto it = std::find(args.begin(), args.end(), src);
                std::tuple<int64_t, Operation*, Type> newTuple;
                if(it == args.end()){
                  newTuple = {-1, defineOp, typeNew};
                }else{
                  int64_t idx = std::distance(args.begin(), it);
                  newTuple = {idx, defineOp, typeNew};
                }
                pairVec.push_back(newTuple);
             }else{
                llvm::errs() << "Operand of callOp is not defined by CastOp\n";
                return false;
             }
          }
        }
      }
      
    }
    return true;             
  }

  // After the arguments of func.func has been updated. This function will
  // record the arguments or defining operation of the parent function of the 
  // caller function.
  bool getTopFuncList(ModuleOp mod, FuncOp func, SmallVector<int64_t,4>argIdxs,
       SmallVector<std::pair<FuncOp, 
       SmallVector<std::tuple<int64_t, Operation*, Type>, 4>>, 4>& topArgList){
    auto calleeName = func.getName();
    auto result = mod.walk([&](CallOp call){
      auto symbolName = call.getCallee();
      if(calleeName!=symbolName)
        return WalkResult::advance();
      auto topFunc = call->getParentOfType<FuncOp>();
      auto it = std::find_if(topArgList.begin(), topArgList.end(), [&](
      std::pair<FuncOp, SmallVector<std::tuple<int64_t, Operation*, Type>, 4>> 
      &pair) {return pair.first == topFunc;});
      // If the FuncOp has already been added in the List
      // then check and update the arguments that need to be updated
      if(it != topArgList.end()){
        auto& pairVec = it->second;
        if(!updatePair(call, argIdxs, topFunc, func, pairVec))
          return WalkResult::interrupt();
      }else{ // FuncOp hasn't been put into the recording list
        SmallVector<std::tuple<int64_t, Operation*, Type>, 4> pairVec;
        if(!updatePair(call, argIdxs, topFunc, func, pairVec))
          return WalkResult::interrupt();
        topArgList.push_back(std::pair(topFunc, pairVec));
      }
      return WalkResult::advance();       
    });
    if (result == WalkResult::interrupt())
      return false;
    return true;
  }
  
  void funcUpdate(OpBuilder builder,std::pair<FuncOp, SmallVector<std::tuple
                                    <int64_t, Operation*, Type>, 4>> & pair){
    auto loc = builder.getUnknownLoc();
    auto& func = pair.first;
    auto inTypes = SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                       func.getArgumentTypes().end());
    auto outTypes = func.getResultTypes();
    auto& argTuples = pair.second;
    for(auto& argTuple : argTuples){
      auto idx = std::get<0>(argTuple);
      Operation* op = std::get<1>(argTuple);
      auto newType = std::get<2>(argTuple);
      if(!op && idx>=0){
        auto arg = func.getArgument(idx);
        inTypes[idx] = newType;
        arg.setType(newType);
      }else{//TODO::Deal with other defining operation here
        if(auto castOp = dyn_cast<CastOp>(op)){
          if(idx<0){
            llvm::errs() << "Source of castOp is not in the arg list\n";
            return;
          }
          auto arg = func.getArgument(idx); 
          auto oldType = dyn_cast<MemRefType>(arg.getType());
          auto newMemRefType = dyn_cast<MemRefType>(newType);
          auto shape = oldType.getShape();
          auto rank = oldType.getRank();
          auto width = oldType.getElementTypeBitWidth();
          auto widthNew = newMemRefType.getElementTypeBitWidth();
          auto eleType = newMemRefType.getElementType();
          SmallVector<int64_t> sizesInt(shape.begin(),shape.end());
          // Deal with dynmic shape
          if (sizesInt[rank-1]>0)
            sizesInt[rank-1] = sizesInt[rank-1] / (widthNew/width);
          auto newMemType = MemRefType::get(sizesInt, eleType);
          inTypes[idx] = newMemType;
          arg.setType(newMemType);
          builder.setInsertionPoint(castOp);
          auto src = castOp.getSource();
          auto newCast = builder.create<CastOp>(loc, newMemRefType, src);
          castOp.getResult().replaceAllUsesWith(newCast);
          castOp.erase();
        }
      }
    }
    func.setType(builder.getFunctionType(inTypes, outTypes));
  }

  // According to the topArgList, update the function and argument type 
  bool topFuncUpdate(ModuleOp mod, OpBuilder builder, 
                    SmallVector<std::pair<FuncOp, SmallVector<std::tuple<
                    int64_t, Operation*, Type>, 4>>, 4>& topArgList){
    SmallVector<std::pair<FuncOp, 
    SmallVector<std::tuple<int64_t, Operation*, Type>, 4>>, 4> ArgList;
    for (auto& pair: topArgList){
      funcUpdate(builder, pair);
    }
    return true;
  }

  bool AXIPacking (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    unsigned axiWidth = AXIWidth;
    // Stores function, the corresponding arguments need to be updated
    // and the newMemRefType
    SmallVector<std::pair<FuncOp, 
    SmallVector<std::tuple<int64_t, Operation*, Type>, 4>>, 4> topArgList;
    auto result = mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.pl"))
        return WalkResult::advance();
      SmallVector<int64_t, 4> argList;
      mergeAXIPort(builder, func, axiWidth, argList);
      if(!getTopFuncList(mod, func, argList, topArgList))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if(result == WalkResult::interrupt())
      return false;
    if(!topFuncUpdate(mod, builder, topArgList))
      return false;
    return true;
  }
};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesAXIPackingPass() {
  return std::make_unique<AriesAXIPacking>();
}

std::unique_ptr<Pass> createAriesAXIPackingPass(const AriesOptions &opts) {
  return std::make_unique<AriesAXIPacking>(opts);
}

} // namespace aries
} // namespace mlir