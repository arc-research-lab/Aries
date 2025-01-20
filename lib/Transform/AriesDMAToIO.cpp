#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::affine;
using namespace mlir::memref;


namespace {

struct AriesDMAToIO : public AriesDMAToIOBase<AriesDMAToIO> {
public:
  AriesDMAToIO() = default;
  AriesDMAToIO(const AriesOptions &opts) {
    PortType=opts.OptPortType;
    PortWidth=opts.OptPortWidth;
    PLIOFreq=opts.OptPLIOFreq;
    PortBurst=opts.OptPortBurst;
    GMIOBW=opts.OptGMIOBW;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!DMAToIO(mod))
      signalPassFailure();
  }

private:
  // Eliminate the dma ops that haven't been called by func.call
  // or haven't use the return value of func.call
  bool elimDMA(DmaOp op, Value val){
    // Check if it is the result of CallOp
    auto defineOp = val.getDefiningOp();
    if(defineOp && dyn_cast<CallOp>(defineOp))
      return false;
    // Check if it is used by CallOp
    for (auto user : val.getUsers())
      if(dyn_cast<CallOp>(user))
        return false;
    return true;
  }
  // Here need to deal with the data packing, and we assume the AIE local
  // mem is always row major
  bool dataPacking(OpBuilder builder, FuncOp func, MemRefType type, 
                   int64_t portWidth, Value val, SmallVector<Value>& sizes, 
                   SmallVector<Value>& offsets,
                   SmallVector<std::pair<AllocOp, AllocOp>, 4>& allocPairs,
                   SmallVector<std::pair<MemRefType, unsigned>, 4>& typePairs){
    auto loc = builder.getUnknownLoc();
    auto &entryBlock = func.getBody().front();
    auto indexType = builder.getIndexType();
    auto shape = type.getShape();
    auto rank = type.getRank();
    auto typeWidth = type.getElementTypeBitWidth();
    auto packNum = (int)(portWidth / typeWidth);
    auto newTypeWidth = typeWidth * packNum;
    auto newType = builder.getIntegerType(newTypeWidth);
    if (packNum!=1){
      builder.setInsertionPointToStart(&entryBlock);
      // Change the size of the DMA src/dst
      auto sizeNum = sizes.size();
      auto size = sizes[sizeNum-1];
      auto sizeDefineOp = size.getDefiningOp();
      auto constOp = dyn_cast<arith::ConstantOp>(sizeDefineOp);
      if(!constOp)
        return false;
      auto attr = constOp.getValue();
      int64_t lastSize;
      if (auto intAttr = dyn_cast<IntegerAttr>(attr)){
        auto intSize = intAttr.getInt();
        if(intSize%packNum!=0){
          llvm::errs() << "Invalid PLIO packing due to memory size\n";
          return false;
        }
        lastSize = intSize/packNum;
      }else{
        return false;
      }
      auto sizeAttr = builder.getIntegerAttr(indexType, lastSize);
      auto sizeValue 
           = builder.create<arith::ConstantOp>(loc, indexType, sizeAttr);
      sizes[sizeNum-1] = sizeValue;
      // Change the offset of the DMA src/dst
      auto offset = offsets[sizeNum-1];
      auto offsetDefineOp = offset.getDefiningOp();
      auto applyOp = dyn_cast<AffineApplyOp>(offsetDefineOp);
      if(!applyOp)
        return false;
      auto originalMap = applyOp.getAffineMap();
      SmallVector<AffineExpr, 4> modifiedExprs;
      for (auto expr : originalMap.getResults()) {
          auto dividedExpr = expr.floorDiv(packNum);
          modifiedExprs.push_back(dividedExpr);
      }
      auto newMap = AffineMap::get(originalMap.getNumDims(), 
                                   originalMap.getNumSymbols(), modifiedExprs, 
                                   applyOp.getContext());
      auto operands = applyOp.getOperands();
      builder.setInsertionPoint(applyOp);
      auto newApplyOp = builder.create<AffineApplyOp>(loc, newMap, operands);
      offsets[sizeNum-1] = newApplyOp.getResult();
      // Change the memref type of the val defined by AllocOp or in the Argus
      auto defineOp = val.getDefiningOp();
      if(defineOp){ // If the memref is defined by AllocOp
        if(auto allocOp = dyn_cast<AllocOp>(defineOp)){
          SmallVector<int64_t> sizesInt(shape.begin(),shape.end());
          // Deal with dynmic shape
          if (sizesInt[rank-1]>0)
            sizesInt[rank-1] = sizesInt[rank-1] / packNum;
          builder.setInsertionPoint(allocOp);
          auto newMemRefType = MemRefType::get(sizesInt, newType);
          auto newAllocOp = builder.create<AllocOp>(loc, newMemRefType);
          auto it = std::find_if(allocPairs.begin(), allocPairs.end(),
              [&](const std::pair<AllocOp, AllocOp> &pair) {
                  return pair.second == allocOp;
              });
          if(it == allocPairs.end())
            allocPairs.push_back(std::pair(newAllocOp, allocOp));
        }
        else{
          llvm::errs() << "Memref not defined by AllocOp\n";
          return false;
        }
      }else{ // Find the memref in the argument list
        unsigned idx = 0;
        for(auto arg : func.getArguments()){
          if(arg == val){
            SmallVector<int64_t> sizesInt(shape.begin(),shape.end());
            // Deal with dynmic shape
            if (sizesInt[rank-1]>0)
              sizesInt[rank-1] = sizesInt[rank-1] / packNum;
            auto newMemRefType = MemRefType::get(sizesInt, newType);
            auto it = std::find_if(typePairs.begin(), typePairs.end(),
                [&](const std::pair<MemRefType, unsigned> &pair) {
                    return pair.second == idx;
                });
            if(it == typePairs.end())
              typePairs.push_back(std::pair(newMemRefType, idx));
            break;
          }
          idx++;
        }
      }
    }
    return true;
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

  LogicalResult LowerDMAToIO(OpBuilder builder, ModuleOp mod, FuncOp func, 
                             std::string portType, 
                             int64_t portWidth, int64_t pliofreq, 
                             int64_t portBurst, int64_t gmiobw){
    auto context = builder.getContext();
    auto loc = builder.getUnknownLoc();
    auto inTypes =SmallVector<Type,8>(func.getArgumentTypes().begin(),
                                      func.getArgumentTypes().end());
    auto outTypes = func.getResultTypes();
    SmallVector<std::pair<AllocOp, AllocOp>, 4> allocPairs; //(new,old)
    SmallVector<std::pair<MemRefType, unsigned>, 4> typePairs;
    auto flag = func.walk([&](DmaOp op){
      auto DmaSrc = op.getSrc();
      auto DmaDst = op.getDst();
      auto SrcSpace 
           = dyn_cast<MemRefType>(DmaSrc.getType()).getMemorySpaceAsInt();
      auto DstSpace 
           = dyn_cast<MemRefType>(DmaDst.getType()).getMemorySpaceAsInt();
      auto srcType = dyn_cast<MemRefType>(DmaSrc.getType());
      auto dstType = dyn_cast<MemRefType>(DmaDst.getType());
      auto writeAttr = op->getAttr("write");
      auto readAttr = op->getAttr("read");

      GraphIOName portName;
      Type portIn, portOut;
      enum PortBurst portburst;
      unsigned flag_config=0;
      if (portType=="PLIO" || portType=="plio"){
        portName = GraphIOName::PLIO;
        portIn = PLIOType::get(context, PortDir::In, portWidth);
        portOut = PLIOType::get(context, PortDir::Out, portWidth);
        flag_config=1;
      }else if(portType=="GMIO" || portType=="gmio"){
        portName = GraphIOName::GMIO;
        portIn = GMIOType::get(context, PortDir::In);
        portOut = GMIOType::get(context, PortDir::Out);
        flag_config=2;
      }else if(portType=="PORT" || portType=="port"){
        portName = GraphIOName::PORT;
        portIn = PortType::get(context, PortDir::In);
        portOut = PortType::get(context, PortDir::Out);
      }else{
        return WalkResult::interrupt();
      }

      switch(portBurst) {
        case 0:
          portburst = PortBurst::BurstNULL;
          break;
        case 64:
          portburst = PortBurst::Burst64;
          break;
        case 128:
          portburst = PortBurst::Burst128;
          break;
        case 256:
          portburst = PortBurst::Burst256;
          break;
        default:
          portburst = PortBurst::Burst64;
      }

      //if the DmaOp is copied to L1 mem
      if(SrcSpace !=(int)MemorySpace::L1 && DstSpace == (int)MemorySpace::L1){
        // Elim dead DMAs
        if(elimDMA(op, DmaDst)){
          op.erase();
          return WalkResult::advance();
        }
        builder.setInsertionPoint(op);
        auto port = builder.create<CreateGraphIOOp>(loc, portIn, portName);
        builder.setInsertionPointAfter(port);
        if(flag_config==1)
          builder.create<ConfigPLIOOp>(loc, port, pliofreq);
        else if(flag_config==2)
          builder.create<ConfigGMIOOp>(loc, port, portburst, gmiobw);
        SmallVector<Value> src_offsets=op.getSrcOffsets();
        SmallVector<Value> src_sizes=op.getSrcSizes();
        SmallVector<Value> src_strides=op.getSrcStrides();
        builder.setInsertionPoint(op);
        auto newOp = builder.create<ConnectOp>(loc, port, DmaDst);
        op.erase();
        if(readAttr){
          auto intRAttr = dyn_cast<IntegerAttr>(readAttr);
          newOp->setAttr("read", intRAttr);
        }
        if(!dataPacking(builder, func, srcType, portWidth, 
                        DmaSrc, src_sizes, src_offsets, allocPairs, typePairs))
          return WalkResult::interrupt();
        builder.setInsertionPoint(newOp);
        auto iopushOp = builder.create<IOPushOp>(loc, DmaSrc, src_offsets,
                                                 src_sizes, src_strides, port);
        auto elementType = srcType.getElementType();
        auto elementTypeAttr = TypeAttr::get(elementType);
        iopushOp->setAttr("type", elementTypeAttr);
        return WalkResult::advance();
      }else if(SrcSpace == (int)MemorySpace::L1 && 
               DstSpace != (int)MemorySpace::L1){
        // Elim dead DMAs
        if(elimDMA(op, DmaSrc)){
          op.erase();
          return WalkResult::advance();
        }
        builder.setInsertionPoint(op);
        auto port = builder.create<CreateGraphIOOp>(loc, portOut, portName);
        builder.setInsertionPointAfter(port);
        if(flag_config==1)
          builder.create<ConfigPLIOOp>(loc, port, pliofreq);
        else if(flag_config==2)
          builder.create<ConfigGMIOOp>(loc, port, portburst, gmiobw);
        SmallVector<Value> dst_offsets=op.getDstOffsets();
        SmallVector<Value> dst_sizes=op.getDstSizes();
        SmallVector<Value> dst_strides=op.getDstStrides();
        builder.setInsertionPoint(op);
        auto newOp = builder.create<ConnectOp>(loc, DmaSrc, port);
        op.erase();
        if(writeAttr){
          auto intWAttr = dyn_cast<IntegerAttr>(writeAttr);
          newOp->setAttr("write", intWAttr);
        }
        if(!dataPacking(builder, func, dstType, portWidth, 
                        DmaDst, dst_sizes, dst_offsets, allocPairs, typePairs))
          return WalkResult::interrupt();
        builder.setInsertionPointAfter(newOp);
        auto iopopOp = builder.create<IOPopOp>(loc, port, DmaDst, dst_offsets, 
                                               dst_sizes, dst_strides);
        auto elementType = dstType.getElementType();
        auto elementTypeAttr = TypeAttr::get(elementType);
        iopopOp->setAttr("type", elementTypeAttr);
        return WalkResult::advance();
      }else if(SrcSpace == (int)MemorySpace::L1 && 
               DstSpace == (int)MemorySpace::L1){
        builder.setInsertionPoint(op);
        builder.create<ConnectOp>(loc, DmaSrc, DmaDst);
        op.erase();
        return WalkResult::advance();
      }
      return WalkResult::advance();
    });
    // Replace old AllocOp with new AllocOp
    for(auto pair : allocPairs){
      auto newAllocOp = pair.first;
      auto oldAllocOp = pair.second;
      newAllocOp.getResult().replaceAllUsesWith(oldAllocOp.getResult());
      oldAllocOp.erase();
    }
    // Update func InputTypes
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
    for (auto topFunc : mod.getOps<FuncOp>()) {
      if(!topFunc->hasAttr("top_func"))
        continue;
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

    if (flag == WalkResult::interrupt())
      return failure();
    return success();
  }

  LogicalResult BroadcastDetect(FuncOp func){
    SmallVector<IOPushOp, 6> iopushs;
    func.walk([&](IOPushOp op){
      iopushs.push_back(op);
    });

    // Record the index of IOpush that has the same source
    // And replace the dst with the dst of the first IOPush
    SmallVector<unsigned, 6> indeices;
    for (auto iopush0 : iopushs) {
      unsigned index = 0;
      for (auto iopush1 : iopushs) {
        if(iopush0==iopush1){
          index++;
          continue;
        }
        if (iopush0.getSrc() == iopush1.getSrc() &&
            iopush0.getSrcOffsets() == iopush1.getSrcOffsets() &&
            iopush0.getSrcSizes() == iopush1.getSrcSizes() &&
            iopush0.getSrcStrides() == iopush1.getSrcStrides()){
          auto dst1 = iopush1.getDst();
          auto dst0 = iopush0.getDst();
          if(dst0!=dst1){
            dst1.replaceAllUsesWith(dst0);
            indeices.push_back(index);
          }
        }
        index++;
      }
    }

    for (auto index : indeices) {
      auto op = iopushs[index];
      op.erase();
    }
    return success();
  }

  LogicalResult AIE2DMAToIO(OpBuilder builder, FuncOp func){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
    auto flag = func.walk([&](DmaOp op){
      auto srcDMA = op.getSrc();
      auto srcType = dyn_cast<MemRefType>(srcDMA.getType());
      auto srcSpace = srcType.getMemorySpaceAsInt();
      auto dstDMA = op.getDst();
      auto dstType = dyn_cast<MemRefType>(dstDMA.getType());
      auto dstSpace = dstType.getMemorySpaceAsInt();
      auto portName = GraphIOName::GMIO;
      auto portburst = PortBurst::BurstNULL;
      if(!srcSpace && dstSpace == (int)MemorySpace::L2){
        auto portIn = GMIOType::get(context, PortDir::In);
        auto dstDefineOp = dstDMA.getDefiningOp();
        if(dstDefineOp){
          builder.setInsertionPointAfter(dstDefineOp);
        }else{
          llvm::errs() << "Find L2 memory not created by other Op\n";
          return WalkResult::interrupt();
        }
        auto port = builder.create<CreateGraphIOOp>(loc, portIn, portName);
        builder.setInsertionPointAfter(port);
        builder.create<ConnectOp>(loc, port, dstDMA);
        builder.create<ConfigGMIOOp>(loc, port, portburst, 0);
        SmallVector<Value> src_offsets=op.getSrcOffsets();
        SmallVector<Value> src_sizes=op.getSrcSizes();
        SmallVector<Value> src_strides=op.getSrcStrides();
        builder.setInsertionPoint(op);
        builder.create<IOPushOp>(loc, srcDMA, src_offsets, src_sizes, 
                                 src_strides, port);
        op.erase();
        return WalkResult::advance();
      }else if(srcSpace == (int)MemorySpace::L2 && !dstSpace){
        auto portOut = GMIOType::get(context, PortDir::Out);
        auto srcDefineOp = srcDMA.getDefiningOp();
        if(srcDefineOp){
          builder.setInsertionPointAfter(srcDefineOp);
        }else{
          llvm::errs() << "Find L2 memory not created by other Op\n";
          return WalkResult::interrupt();
        }
        auto port = builder.create<CreateGraphIOOp>(loc, portOut, portName);
        builder.setInsertionPointAfter(port);
        builder.create<ConnectOp>(loc, srcDMA, port);
        builder.create<ConfigGMIOOp>(loc, port, portburst, 0);
        SmallVector<Value> dst_offsets=op.getDstOffsets();
        SmallVector<Value> dst_sizes=op.getDstSizes();
        SmallVector<Value> dst_strides=op.getDstStrides();
        builder.setInsertionPoint(op);
        builder.create<IOPopOp>(loc, port, dstDMA, dst_offsets, 
                                dst_sizes, dst_strides);
        op.erase();
      }
      return WalkResult::advance();
    });
    if (flag == WalkResult::interrupt())
      return failure();
    return success();
  }

  bool DMAToIO (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      auto attrGMIO = builder.getBoolAttr(false);
      auto attrPLIO = builder.getBoolAttr(false);
      if(PortType=="GMIO" || PortType=="gmio"){
        attrGMIO = builder.getBoolAttr(true);
        func->setAttr("gmio",attrGMIO);
        if (failed(LowerDMAToIO(builder, mod, func, PortType, PortWidth, 
                                PLIOFreq, PortBurst, GMIOBW)))
          return false;
      }else if(PortType=="PLIO" || PortType=="plio"){
        attrPLIO = builder.getBoolAttr(true);
        func->setAttr("plio",attrPLIO);
        if (failed(LowerDMAToIO(builder, mod, func, PortType, PortWidth, 
                                PLIOFreq, PortBurst, GMIOBW)))
          return false;
      }else if(PortType=="PORT" || PortType=="port"){
        if (failed(LowerDMAToIO(builder, mod, func, PortType, PortWidth, 
                                PLIOFreq, PortBurst, GMIOBW)))
          return false;
      }else if(PortType=="AIE2_GMIO" || PortType=="aie2_gmio"){
        if(failed(AIE2DMAToIO(builder, func)))
          return false;
      }

      MLIRContext &context = getContext();
      RewritePatternSet patterns(&context);
      PassManager pm(&getContext());
      pm.addPass(createCSEPass());
      pm.addPass(createCanonicalizerPass());

      if (failed(pm.run(func)))
        return false;

      if (failed(BroadcastDetect(func)))
        return false;
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesDMAToIOPass() {
  return std::make_unique<AriesDMAToIO>();
}

std::unique_ptr<Pass> createAriesDMAToIOPass(const AriesOptions &opts) {
  return std::make_unique<AriesDMAToIO>(opts);
}

} // namespace aries
} // namespace mlir