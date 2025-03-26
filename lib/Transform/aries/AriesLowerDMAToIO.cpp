#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#define DEBUG_TYPE "aries-lower-dma-to-io"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;
using namespace mlir::affine;
using namespace mlir::memref;


namespace {

struct AriesLowerDMAToIO : public AriesLowerDMAToIOBase<AriesLowerDMAToIO> {
public:
  AriesLowerDMAToIO() = default;
  AriesLowerDMAToIO(const AriesOptions &opts) {
    PortType=opts.OptPortType;
    PortWidth=opts.OptPortWidth;
    PLIOFreq=opts.OptPLIOFreq;
    PortBurst=opts.OptPortBurst;
    GMIOBW=opts.OptGMIOBW;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (!LowerDMAToIO(mod))
      signalPassFailure();
    PassManager pm(&getContext());
    pm.addPass(createCSEPass());
    pm.addPass(createCanonicalizerPass());
    if (failed(pm.run(mod)))
      signalPassFailure();
  }

private:
  bool ConvertDMA(OpBuilder builder, DmaOp op){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
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
        llvm::errs() << "Defining operation of L2 memory not found\n";
        return false;
      }
      auto port = builder.create<CreateGraphIOOp>(loc, portIn, portName);
      builder.setInsertionPointAfter(port);
      auto conncetOp = builder.create<ConnectOp>(loc, port, dstDMA);
      if(op->hasAttr("initialize"))
        conncetOp->setAttr("initialize", builder.getUnitAttr());
      builder.create<ConfigGMIOOp>(loc, port, portburst, 0);
      SmallVector<Value> src_offsets=op.getSrcOffsets();
      SmallVector<Value> src_sizes=op.getSrcSizes();
      SmallVector<Value> src_strides=op.getSrcStrides();
      builder.setInsertionPoint(op);
      builder.create<IOPushOp>(loc, srcDMA, src_offsets, src_sizes, 
                               src_strides, ValueRange(), ValueRange(), 
                               ValueRange(), ValueRange(), port);
      op.erase();
    }else if(srcSpace == (int)MemorySpace::L2 && !dstSpace){
      auto portOut = GMIOType::get(context, PortDir::Out);
      auto srcDefineOp = srcDMA.getDefiningOp();
      if(srcDefineOp){
        builder.setInsertionPointAfter(srcDefineOp);
      }else{
        llvm::errs() << "Defining operation of L2 memory not found\n";
        return false;
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
                              dst_sizes, dst_strides, ValueRange(), 
                              ValueRange(), ValueRange(), ValueRange());
      op.erase();
    }
    return true;
  }

  void SplitBroadcast(OpBuilder builder, DmaBroadcastOp broadcast){
    auto loc = builder.getUnknownLoc();
    builder.setInsertionPointAfter(broadcast);
    auto dsts = broadcast.getDst();
    for(auto dst: dsts){
      auto newBroadCast = builder.create<DmaBroadcastOp>(loc,
                      broadcast.getSrc(), broadcast.getSrcOffsets(), 
                      broadcast.getSrcSizes(), broadcast.getSrcStrides(),
                      broadcast.getSrcTiles(), broadcast.getSrcDims(),
                      broadcast.getSrcSteps(), broadcast.getSrcWraps(),
                      dst, broadcast.getDstOffsets(), 
                      broadcast.getDstSizes(), broadcast.getDstStrides(),
                      broadcast.getDstTiles(), broadcast.getDstDims(),
                      broadcast.getDstSteps(), broadcast.getDstWraps());
      if(broadcast->hasAttr("initialize"))
        newBroadCast->setAttr("initialize", builder.getUnitAttr());
    }
  }

  LogicalResult AIE2DMAToIO(OpBuilder builder, FuncOp func){
    auto flag = func.walk([&](Operation* op){
      if(auto dmaOp = dyn_cast<DmaOp>(op)){
        ConvertDMA(builder, dmaOp);
      }else if(auto broadcast = dyn_cast<DmaBroadcastOp>(op)){
        SplitBroadcast(builder, broadcast);
        broadcast.erase();
      }
      return WalkResult::advance();
    });
    if (flag == WalkResult::interrupt())
      return failure();
    return success();
  }

  void getDMAInfo(Operation* op, bool& broad_flag, Value& dmaSrc, 
              Value& dmaDst, SmallVector<Value>& dmaDsts,
              SmallVector<Value>& src_offsets, SmallVector<Value>& src_sizes,
              SmallVector<Value>& src_strides, SmallVector<Value>& src_tiles,
              SmallVector<Value>& src_dims,    SmallVector<Value>& src_steps,
              SmallVector<Value>& src_wraps,   SmallVector<Value>& dst_offsets,
              SmallVector<Value>& dst_sizes,   SmallVector<Value>& dst_strides,
              SmallVector<Value>& dst_tiles,   SmallVector<Value>& dst_dims,
              SmallVector<Value>& dst_steps,   SmallVector<Value>& dst_wraps){
    if(auto dmaOp = dyn_cast<DmaOp>(op)){
      dmaSrc = dmaOp.getSrc();
      dmaDst = dmaOp.getDst();
      dmaDsts.push_back(dmaDst);
      src_offsets = dmaOp.getSrcOffsets();
      src_sizes   = dmaOp.getSrcSizes();
      src_strides = dmaOp.getSrcStrides();
      src_tiles   = dmaOp.getSrcTiles();
      src_dims    = dmaOp.getSrcDims();
      src_steps   = dmaOp.getSrcSteps();
      src_wraps   = dmaOp.getSrcWraps();
      dst_offsets = dmaOp.getDstOffsets();
      dst_sizes   = dmaOp.getDstSizes();
      dst_strides = dmaOp.getDstStrides();
      dst_tiles   = dmaOp.getDstTiles();
      dst_dims    = dmaOp.getDstDims();
      dst_steps   = dmaOp.getDstSteps();
      dst_wraps   = dmaOp.getDstWraps();
      broad_flag = false;
    }else if(auto broadcast = dyn_cast<DmaBroadcastOp>(op)){
      dmaSrc = broadcast.getSrc();
      dmaDsts = broadcast.getDst();
      dmaDst = dmaDsts[0];
      src_offsets = broadcast.getSrcOffsets();
      src_sizes   = broadcast.getSrcSizes();
      src_strides = broadcast.getSrcStrides();
      src_tiles   = broadcast.getSrcTiles();
      src_dims    = broadcast.getSrcDims();
      src_steps   = broadcast.getSrcSteps();
      src_wraps   = broadcast.getSrcWraps();
      dst_offsets = broadcast.getDstOffsets();
      dst_sizes   = broadcast.getDstSizes();
      dst_strides = broadcast.getDstStrides();
      dst_tiles   = broadcast.getDstTiles();
      dst_dims    = broadcast.getDstDims();
      dst_steps   = broadcast.getDstSteps();
      dst_wraps   = broadcast.getDstWraps();
      broad_flag = true;
    }
  }

  // Helper function to get the port name, direction and config
  bool getPortInfo(MLIRContext *context, std::string portType,
                   int64_t portWidth, GraphIOName& portName, Type& portIn, 
                   Type& portOut, unsigned& flag_config){
    if (portType=="PLIO" || portType=="plio"){
      portName = GraphIOName::PLIO;
      portIn = PLIOType::get(context, PortDir::In, 32);
      portOut = PLIOType::get(context, PortDir::Out, 32);
      flag_config=1;
    }else if(portType=="GMIO" || portType=="gmio"){
      portName = GraphIOName::GMIO;
      portIn = GMIOType::get(context, PortDir::In);
      portOut = GMIOType::get(context, PortDir::Out);
      flag_config=2;
    }else{
      return false;
    }
    return true;
  }

  void getBurst(int64_t portBurst, enum PortBurst& portburst){
    switch(portBurst){
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
  }

  LogicalResult DMAToIO(OpBuilder builder, ModuleOp mod, FuncOp func, 
    std::string portType, 
    int64_t portWidth, int64_t pliofreq, 
    int64_t portBurst, int64_t gmiobw){
    
    auto context = builder.getContext();
    auto loc = builder.getUnknownLoc();
    auto flag = func.walk([&](Operation* op){
      if(!dyn_cast<DmaOp>(op) && !dyn_cast<DmaBroadcastOp>(op))
        return WalkResult::advance();
      bool broad_flag;
      Value dmaSrc, dmaDst;
      SmallVector<Value> dmaDsts;
      SmallVector<Value> src_offsets, src_sizes, src_strides, src_tiles, 
                         src_dims, src_steps, src_wraps;
      SmallVector<Value> dst_offsets, dst_sizes, dst_strides, dst_tiles, 
                         dst_dims, dst_steps, dst_wraps;
      getDMAInfo(op, broad_flag, dmaSrc, dmaDst, dmaDsts, src_offsets, 
                 src_sizes, src_strides, src_tiles, src_dims, src_steps, 
                 src_wraps, dst_offsets, dst_sizes, dst_strides, dst_tiles, 
                 dst_dims, dst_steps, dst_wraps);
      unsigned int srcSpace, dstSpace;
      srcSpace = dyn_cast<MemRefType>(dmaSrc.getType()).getMemorySpaceAsInt();
      dstSpace = dyn_cast<MemRefType>(dmaDst.getType()).getMemorySpaceAsInt();

      GraphIOName portName;
      Type portIn, portOut;
      unsigned flag_config;
      if(!getPortInfo(context, portType, portWidth, portName, portIn, 
                      portOut, flag_config)){
        llvm::errs() << "Find unsupported IO port configuration\n";
        return WalkResult::interrupt();
      }
      enum PortBurst portburst;
      getBurst(portBurst, portburst);
      //if the DmaOp is copied from L2 to L1 mem
      if(srcSpace !=(int)MemorySpace::L1 && dstSpace == (int)MemorySpace::L1){
        builder.setInsertionPoint(op);
        auto port = builder.create<CreateGraphIOOp>(loc, portIn, portName);
        builder.setInsertionPointAfter(port);
        if(flag_config==1)
          builder.create<ConfigPLIOOp>(loc, port, pliofreq);
        else if(flag_config==2)
          builder.create<ConfigGMIOOp>(loc, port, portburst, gmiobw);
        builder.setInsertionPoint(op);
        auto iopushOp = builder.create<IOPushOp>(loc, dmaSrc, src_offsets,
                                                 src_sizes, src_strides, 
                                                 src_tiles, src_dims, 
                                                 src_steps, src_wraps, port);
        builder.setInsertionPointAfter(iopushOp);
        for (auto dst: dmaDsts){
          builder.create<ConnectOp>(loc, port, dst);
        }
      }
      //if the DmaOp is copied from L1 to L2 mem
      else if(srcSpace == (int)MemorySpace::L1 && 
              dstSpace != (int)MemorySpace::L1){
        builder.setInsertionPoint(op);
        auto port = builder.create<CreateGraphIOOp>(loc, portOut, portName);
        builder.setInsertionPointAfter(port);
        if(flag_config==1)
          builder.create<ConfigPLIOOp>(loc, port, pliofreq);
        else if(flag_config==2)
          builder.create<ConfigGMIOOp>(loc, port, portburst, gmiobw);
        builder.setInsertionPoint(op);
        auto newOp = builder.create<ConnectOp>(loc, dmaSrc, port);
        builder.setInsertionPointAfter(newOp);
        auto IOPop = builder.create<IOPopOp>(loc, port, dmaDst, dst_offsets, 
                                             dst_sizes, dst_strides, dst_tiles, 
                                             dst_dims, dst_steps, dst_wraps);
        if(op->hasAttr("accumulator"))
          IOPop->setAttr("accumulator", builder.getUnitAttr());
        if(auto redAttr = op->getAttr("reduction"))
          IOPop->setAttr("reduction", redAttr);
      }else if(srcSpace == (int)MemorySpace::L1 && 
               dstSpace == (int)MemorySpace::L1){
        builder.setInsertionPoint(op);
        builder.create<ConnectOp>(loc, dmaSrc, dmaDst);
      }else{
        return WalkResult::advance();
      }
      op->erase();
      return WalkResult::advance();
    });
    if (flag == WalkResult::interrupt())
      return failure();
    return success();
  }

  bool LowerDMAToIO (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
      continue;
      auto attrTrue = builder.getBoolAttr(true);
      if(PortType=="GMIO" || PortType=="gmio"){
        func->setAttr("gmio",attrTrue);
        if (failed(DMAToIO(builder, mod, func, PortType, PortWidth, 
                           PLIOFreq, PortBurst, GMIOBW)))
          return false;
      }else if(PortType=="PLIO" || PortType=="plio"){
        func->setAttr("plio",attrTrue);
        if (failed(DMAToIO(builder, mod, func, PortType, PortWidth, 
                           PLIOFreq, PortBurst, GMIOBW)))
          return false;
      }else if(PortType=="AIE2_GMIO" || PortType=="aie2_gmio"){
        if(failed(AIE2DMAToIO(builder, func)))
          return false;
      }
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesLowerDMAToIOPass() {
  return std::make_unique<AriesLowerDMAToIO>();
}

std::unique_ptr<Pass> createAriesLowerDMAToIOPass(const AriesOptions &opts) {
  return std::make_unique<AriesLowerDMAToIO>(opts);
}

} // namespace aries
} // namespace mlir