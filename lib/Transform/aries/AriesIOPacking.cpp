#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-io-packing"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::affine;
using namespace mlir::memref;


namespace {

struct AriesIOPacking : public AriesIOPackingBase<AriesIOPacking> {
public:
  AriesIOPacking() = default;
  AriesIOPacking(const AriesOptions &opts) {
    PortWidth=opts.OptPortWidth;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!IOPacking(mod))
      signalPassFailure();
  }

private:
  // Check if all the port can do data packing or not
  bool checkPacking(FuncOp func){
    auto flag = func.walk([&](CreateGraphIOOp graphio){
      if(!dyn_cast<PLIOType>(graphio.getType())){
        llvm::outs() << "Found non-plio graphio\n";
        return WalkResult::interrupt();
      }
      auto ioType = dyn_cast<PLIOType>(graphio.getType());
      auto width = ioType.getWidth();
      if(PortWidth%width!=0){
        llvm::outs() << "IO packing skipped due to undividable factor\n";
        return WalkResult::interrupt();
      }
      auto packNum = (int)(PortWidth / width);
      auto plio = graphio.getResult();
      for(auto user: plio.getUsers()){
        if(!dyn_cast<IOPushOp>(user) && !dyn_cast<IOPopOp>(user))
          continue;
        Value size, offset;
        if(auto iopushOp = dyn_cast<IOPushOp>(user)){
          auto sizes = iopushOp.getSrcSizes();
          auto offsets = iopushOp.getSrcSizes();
          size = sizes[sizes.size()-1];
          offset = offsets[offsets.size()-1];
        }else{
          auto iopopOp = dyn_cast<IOPopOp>(user);
          auto sizes = iopopOp.getDstSizes();
          auto offsets = iopopOp.getDstOffsets();
          size = sizes[sizes.size()-1];
          offset = offsets[offsets.size()-1];
        }

        // Check if the size is dividable by packNum
        auto constantOp = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
        if(!constantOp){
          llvm::outs() << "Involve non-constant inner size!\n";
          return WalkResult::interrupt();
        }
        auto intSizeAttr = dyn_cast<IntegerAttr>(constantOp.getValue());
        auto intSize = intSizeAttr.getInt();
        if (intSize%packNum!=0){
          llvm::outs() << "IO packing skipped due to slicing size\n";
          return WalkResult::interrupt();
        }

        // Check if the coefficients of offset is dividable or not
        auto offsetDefineOp = offset.getDefiningOp();
        if(auto constOp = dyn_cast<arith::ConstantOp>(offsetDefineOp)){
          auto intOffAttr = dyn_cast<IntegerAttr>(constOp.getValue());
          auto intOffset = intOffAttr.getInt();
          if (intOffset%packNum!=0){
            llvm::outs() << "IO packing skipped due to slicing offset\n";
            return WalkResult::interrupt();
          }
        }else if(auto applyOp = dyn_cast<AffineApplyOp>(offsetDefineOp)){
          auto map = applyOp.getAffineMap();
          for (auto expr : map.getResults()) {
            if (!expr.isMultipleOf(packNum)) {
              llvm::outs() << "IO packing skipped due to slicing expression\n";
              return WalkResult::interrupt();
            }
          }
        }else{
          llvm::outs() << "IO packing skipped due to unrecognized offset\n";
          return WalkResult::interrupt();
        }
      }
      return WalkResult::advance();
    });
    if(flag==WalkResult::interrupt())
      return false;
    return true;
  }

  // Perform GraphIO data packing
  void packing(OpBuilder builder, FuncOp func, 
               SmallVector<std::pair<MemRefType, unsigned>, 4>& typePairs){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
    auto &entryBlock = func.getBody().front();
    auto indexType = builder.getIndexType();
    builder.setInsertionPointToStart(&entryBlock);
    func.walk([&](CreateGraphIOOp graphio){
      auto ioType = dyn_cast<PLIOType>(graphio.getType());
      auto width = ioType.getWidth();
      auto packNum = (int)(PortWidth / width);
      auto newTypeWidth = width * packNum;
      auto newType = builder.getIntegerType(newTypeWidth);
      if (packNum==1)
        return WalkResult::advance();
      // Update the size and offset of IOPush/IOPop
      auto plio = graphio.getResult();
      for(auto user: plio.getUsers()){
        if(!dyn_cast<IOPushOp>(user) && !dyn_cast<IOPopOp>(user))
          continue;
        SmallVector<Value> sizes, offsets;
        Value size, offset, val;
        if(auto iopushOp = dyn_cast<IOPushOp>(user)){
          val = iopushOp.getSrc();
          sizes = iopushOp.getSrcSizes();
          offsets = iopushOp.getSrcSizes();
          size = sizes[sizes.size()-1];
          offset = offsets[offsets.size()-1];
          // Update the graphio type
          auto portIn = PLIOType::get(context, PortDir::In, PortWidth);
          graphio.setGraphIOType(portIn);
        }else{
          auto iopopOp = dyn_cast<IOPopOp>(user);
          val = iopopOp.getDst();
          sizes = iopopOp.getDstSizes();
          offsets = iopopOp.getDstOffsets();
          size = sizes[sizes.size()-1];
          offset = offsets[offsets.size()-1];
          auto portOut = PLIOType::get(context, PortDir::Out, PortWidth);
          graphio.setGraphIOType(portOut);
        }
        // Mark the original type
        auto memrefType = dyn_cast<MemRefType>(val.getType());
        auto shape = memrefType.getShape();
        auto rank = memrefType.getRank();
        auto eleType = memrefType.getElementType();
        auto eleTypeAttr = TypeAttr::get(eleType);
        user->setAttr("type", eleTypeAttr); 
        SmallVector<int64_t> shapeInt(shape.begin(),shape.end());

        // Create new size and update the IO ops
        auto constantOp = dyn_cast<arith::ConstantOp>(size.getDefiningOp());
        auto intSizeAttr = dyn_cast<IntegerAttr>(constantOp.getValue());
        auto intSize = intSizeAttr.getInt();
        auto packedSize = intSize/packNum;
        auto sizeAttr = builder.getIntegerAttr(indexType, packedSize);
        auto sizeValue 
             = builder.create<arith::ConstantOp>(loc, indexType, sizeAttr);
        sizes[sizes.size()-1] = sizeValue;

        // Change the offset of the IO ops
        auto offsetDefineOp = offset.getDefiningOp();
        if(auto constOp = dyn_cast<arith::ConstantOp>(offsetDefineOp)){
          auto intOffAttr = dyn_cast<IntegerAttr>(constOp.getValue());
          auto intOffset = intOffAttr.getInt();
          auto packedOffset = intOffset/packNum;
          auto offsetAttr = builder.getIntegerAttr(indexType, packedOffset);
          auto offsetValue 
               = builder.create<arith::ConstantOp>(loc, indexType, offsetAttr);
          offsets[offsets.size()-1] = offsetValue;
        }else if(auto applyOp = dyn_cast<AffineApplyOp>(offsetDefineOp)){
          auto map = applyOp.getAffineMap();
          SmallVector<AffineExpr, 4> modifiedExprs;
          for (auto expr : map.getResults()) {
            auto dividedExpr = expr.floorDiv(packNum);
            modifiedExprs.push_back(dividedExpr);
          }
          auto newMap = AffineMap::get(map.getNumDims(), map.getNumSymbols(), 
                                       modifiedExprs, applyOp.getContext());
          auto operands = applyOp.getOperands();
          builder.setInsertionPoint(applyOp);
          auto newApplyOp = builder.create<AffineApplyOp>(loc, newMap, operands);
          offsets[offsets.size()-1] = newApplyOp.getResult();
        }

        // Record the arguments that need to be changed and the corresponding
        // memrefType
        for(unsigned idx = 0; idx < func.getNumArguments(); idx++){
          auto arg = func.getArgument(idx);
          if(arg != val)
            continue;
          // Deal with dynmic shape
          if (shapeInt[rank-1]>0)
            shapeInt[rank-1] = shapeInt[rank-1] / packNum;
          auto newMemRefType = MemRefType::get(shapeInt, newType);
          auto it = std::find_if(typePairs.begin(), typePairs.end(),
              [&](const std::pair<MemRefType, unsigned> &pair) {
                  return pair.second == idx;
              });
          if(it == typePairs.end())
            typePairs.push_back(std::pair(newMemRefType, idx));
          break;
        }
      }
      return WalkResult::advance();
    });
  }

  // Mark the original data type
  void markMemType(OpBuilder builder, FuncOp func){
    SmallVector<Attribute> idxAttrs;
    SmallVector<Attribute> argAttrs;
    for(unsigned idx=0; idx < func.getNumArguments(); idx++){
      auto arg = func.getArgument(idx);
      auto type = arg.getType();
      if(!dyn_cast<MemRefType>(type))
        continue;
      idxAttrs.push_back(builder.getI32IntegerAttr(idx));
      auto memType = dyn_cast<MemRefType>(type);
      auto eleType = memType.getElementType();
      auto eleTypeAttr = TypeAttr::get(eleType);
      argAttrs.push_back(eleTypeAttr);
    }
    auto arrayAttr = builder.getArrayAttr(idxAttrs);
    func->setAttr("mem_idx", arrayAttr);
    auto arrayTypeAttr = builder.getArrayAttr(argAttrs);
    func->setAttr("mem_type", arrayTypeAttr);
  }

  void updateTop(Value val, Value& arg, FuncOp topFunc, 
                 MemRefType newMemRefType,
                 SmallVector<Type,8>& inTopTypes,
                 SmallVector<Value, 4> arg_list,
                 SmallVector<Value, 4>& igArgs){
    auto igIt = std::find(igArgs.begin(), igArgs.end(), val);
    if(igIt!=igArgs.end())
      return;
    igArgs.push_back(val);
    auto it = std::find(arg_list.begin(), arg_list.end(), val);
    auto idx_arg = std::distance(arg_list.begin(), it);
    arg = topFunc.getArgument(idx_arg);
    inTopTypes[idx_arg] = newMemRefType;
    arg.setType(newMemRefType);
  }

  // After IO packing need to update the caller and callee
  void topFuncUpdate(OpBuilder builder, FuncOp topFunc, FuncOp func,
                    SmallVector<std::pair<MemRefType, unsigned>, 4>& typePairs){
    auto loc = builder.getUnknownLoc();
    // Update func InputTypes
    auto inTypes =SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                      func.getArgumentTypes().end());
    auto outTypes = func.getResultTypes();
    for(auto pair : typePairs){
      auto newMemRefType = pair.first;
      auto idx = pair.second;
      auto arg = func.getArgument(idx);
      inTypes[idx] = newMemRefType;
      arg.setType(newMemRefType);
    }
    func.setType(builder.getFunctionType(inTypes, outTypes));

    // Update the caller functions
    // TODO:: Now assumes that the operands of the caller functions are defined
    // by the argument list in the parent func of the callers or are defined by
    // memref.cast operations
    auto inTopTypes =SmallVector<Type,8>(topFunc.getArgumentTypes().begin(),
                                           topFunc.getArgumentTypes().end());
    auto outTopTypes = topFunc.getResultTypes();
    SmallVector<Value, 4> arg_list(topFunc.getArguments().begin(),
                                   topFunc.getArguments().end());
    SmallVector<Value, 4> igArgs;
    for (auto caller : topFunc.getOps<CallOp>()) {
      if(caller.getCallee() != func.getName())
        continue;
      for(auto pair : typePairs){
        auto newMemRefType = pair.first;
        auto idx_op = pair.second;
        auto operand = caller.getOperand(idx_op);
        auto definingOp = operand.getDefiningOp();
        if(!definingOp){
          Value arg;
          updateTop(operand, arg, topFunc, newMemRefType, 
                    inTopTypes, arg_list, igArgs);
        }else if(auto castOp = dyn_cast<CastOp>(definingOp)){
          auto src = castOp.getSource();
          auto memType = dyn_cast<MemRefType>(src.getType());
          auto shape = memType.getShape();
          auto rank = memType.getRank();
          auto width = memType.getElementTypeBitWidth();
          auto widthNew = newMemRefType.getElementTypeBitWidth();
          auto newType = newMemRefType.getElementType();
          SmallVector<int64_t> sizesInt(shape.begin(),shape.end());
          // Deal with dynmic shape
          if (sizesInt[rank-1]>0)
            sizesInt[rank-1] = sizesInt[rank-1] / (widthNew/width);
          auto newMemType = MemRefType::get(sizesInt, newType);
          Value arg;
          updateTop(src, arg, topFunc, newMemType, 
                    inTopTypes, arg_list, igArgs);
          if(!arg)
            continue;
          builder.setInsertionPoint(castOp);
          auto newCast = builder.create<CastOp>(loc, newMemRefType, src);
          castOp.getResult().replaceAllUsesWith(newCast);
          castOp.erase();
        }
      }
    }
    topFunc.setType(builder.getFunctionType(inTopTypes, outTopTypes));
  }
  
  void performPacking(OpBuilder builder, FuncOp topFunc, FuncOp func){
    SmallVector<std::pair<MemRefType, unsigned>, 4> typePairs;
    packing(builder, func, typePairs);
    markMemType(builder, func);
    topFuncUpdate(builder, topFunc, func, typePairs);
  }

  bool IOPacking (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    FuncOp topFunc;
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("top_func"))
        continue;
      topFunc = func;
    }
    if(!topFunc)
      return false;
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      // Perform data packing for PLIO
      auto boolPLIO = func->getAttr("plio");
      if(!boolPLIO || !dyn_cast<BoolAttr>(boolPLIO).getValue())
        continue;
      if(!checkPacking(func))
        continue;
      performPacking(builder, topFunc, func);
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesIOPackingPass() {
  return std::make_unique<AriesIOPacking>();
}

std::unique_ptr<Pass> createAriesIOPackingPass(const AriesOptions &opts) {
  return std::make_unique<AriesIOPacking>(opts);
}

} // namespace aries
} // namespace mlir