#include "aries/Conversion/Passes.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "aries/Transform/Utils.h"
#include "aie/Dialect/AIE/IR/AIEDialect.h"
#include "aie/Dialect/AIEX/IR/AIEXDialect.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::arith;
using namespace mlir::affine;
using namespace xilinx::AIE;
using namespace xilinx::AIEX;


struct ConnectConvert : public OpConversionPattern<adf::ConnectOp> {
  using OpConversionPattern<adf::ConnectOp>::OpConversionPattern;
  DenseMap<Value, std::pair<Value, std::string>>& memMap;
  ConnectConvert(MLIRContext *context, 
                 DenseMap<Value, std::pair<Value, std::string>>& memMap)
        : OpConversionPattern<adf::ConnectOp>(context), memMap(memMap){}
  LogicalResult matchAndRewrite(
      adf::ConnectOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
    
    auto context = op.getContext();
    auto int32Type = rewriter.getIntegerType(32);
    auto depthAttr = rewriter.getIntegerAttr(int32Type, 2);
    auto src = op.getSrc();
    auto srcType = src.getType();
    auto dst = op.getDst();
    auto dstType = dst.getType();
    auto srcMemType = dyn_cast<MemRefType>(srcType);
    auto dstMemType = dyn_cast<MemRefType>(dstType);
    auto srcTile = memMap[src].first;
    auto dstTile = memMap[dst].first;
    MemRefType memrefType;
    std::string objFIFOName;
    if(!srcMemType){
      memrefType = dstMemType;
      objFIFOName = memMap[dst].second;
    }else if(!dstMemType){
      memrefType = srcMemType;
      objFIFOName = memMap[src].second;
    }else{
      ;
      // TODO: Currently do nothing, but need to deal with connect between mems
    }
    if(op->hasAttr("initialize")){
      rewriter.eraseOp(op);
      return success();
    }
    auto stringAttr = StringAttr::get(context, objFIFOName);
    auto objectType = AIEObjectFifoType::get(memrefType);
    rewriter.replaceOpWithNewOp<ObjectFifoCreateOp>(op, stringAttr, srcTile, 
                                                    ValueRange{dstTile}, 
                                                    depthAttr, objectType);
    return success();
  }
};

struct CellLaunchConvert : public OpConversionPattern<LaunchCellOp> {
  using OpConversionPattern<LaunchCellOp>::OpConversionPattern;
  DenseMap<CallOp, Value>& coreMap;
  CellLaunchConvert(MLIRContext *context, DenseMap<CallOp, Value>& coreMap)
                : OpConversionPattern<LaunchCellOp>(context), coreMap(coreMap){}
  LogicalResult matchAndRewrite(
      LaunchCellOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
      
    auto attr = op->getAttr("callName");
    if(!attr)
      return failure();
    auto strAttr = dyn_cast<StringAttr>(attr);
    CallOp tileCall;
    op.walk([&](CallOp call){
      if(call.getCallee() != strAttr.getValue())
        return WalkResult::advance();
      tileCall = call;
      return WalkResult::interrupt();
    });
    auto tile = coreMap[tileCall];
    auto coreOp = rewriter.create<xilinx::AIE::CoreOp>(op->getLoc(), tile);
    Region &r = coreOp.getBody();
    Block *endBlock = rewriter.createBlock(&r);
    rewriter.setInsertionPointToStart(endBlock);
    auto endOp = rewriter.create<EndOp>(op->getLoc());
    for(auto& newop : llvm::make_early_inc_range(op.getOps())){
      if(!dyn_cast<EndLaunchCellOp>(newop))
        newop.moveBefore(endOp);
    }
    rewriter.eraseOp(op);
    return success();
  }
};

struct DmaConvert : public OpConversionPattern<DmaOp> {
  using OpConversionPattern<DmaOp>::OpConversionPattern;
  DenseMap<Value, std::pair<Value, std::string>>& memMap;
  DmaConvert(MLIRContext *context, 
             DenseMap<Value, std::pair<Value, std::string>>& memMap)
        : OpConversionPattern<adf::DmaOp>(context), memMap(memMap){}
  LogicalResult matchAndRewrite(
      DmaOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
    
    auto loc = rewriter.getUnknownLoc();
    auto context = op.getContext();
    auto int32Type = rewriter.getIntegerType(32);
    auto zeroAttr = rewriter.getIntegerAttr(int32Type, 0);
    auto depthAttr = rewriter.getIntegerAttr(int32Type, 2);
    auto src = op.getSrc();
    auto srcType = src.getType();
    auto dst = op.getDst();
    auto dstType = dst.getType();
    auto srcMemType = dyn_cast<MemRefType>(srcType);
    auto dstMemType = dyn_cast<MemRefType>(dstType);
    auto srcTile = memMap[src].first;
    auto dstTile = memMap[dst].first;
    auto srcDefOp = dyn_cast<adf::BufferOp>(src.getDefiningOp());
    auto dstDefOp = dyn_cast<adf::BufferOp>(dst.getDefiningOp());
    MemRefType memrefType;
    std::string objFIFOName;
    auto srcSpace = dyn_cast<IntegerAttr>(srcMemType.getMemorySpace());
    bool store_flag; // Identify if stored to outer mem hierarchy
    if(srcSpace.getInt() == (int)MemorySpace::L1){
      memrefType = srcMemType;
      objFIFOName = memMap[src].second;
      store_flag = true;
    }else{
      memrefType = dstMemType;
      objFIFOName = memMap[dst].second;
      store_flag = false;
    }
    auto coreOp = op->getParentOfType<xilinx::AIE::CoreOp>();
    SmallVector<AffineForOp, 6> band;
    getNestedLoopBand(coreOp.getRegion(), band);
    AffineForOp redLoop;
    // Get the outermost reduction loop
    for (auto loop : band){
      if(loop->hasAttr("reduction")){
        redLoop = loop;
        break;
      }
    }
    auto device = op->getParentOfType<xilinx::AIE::DeviceOp>();
    auto& entryBlock = device.getRegion().front();
    if(op->hasAttr("initialize")){
      // Create zero init callee at the beginning of deviceOp
      rewriter.setInsertionPointToStart(&entryBlock);
      auto eleType = dstMemType.getElementType();
      auto eleAttr = TypeAttr::get(eleType);
      std::string eleStr;
      llvm::raw_string_ostream os(eleStr);
      eleAttr.print(os);
      std::string funcName = "zero_" + eleStr;
      auto callee = device.lookupSymbol<FuncOp>(funcName);
      FuncOp funcOp = callee;
      if(!callee){
        auto funcType 
             = rewriter.getFunctionType(TypeRange({dstMemType}), TypeRange({}));
        auto newfunc = rewriter.create<FuncOp>(loc, funcName, funcType);
        funcOp = newfunc;
        newfunc.setVisibility(SymbolTable::Visibility::Private);
      }
      // Create zero init caller outside of reduction loop
      // The buffer should be changed from dst to the objectfifo
      rewriter.setInsertionPoint(redLoop);
      auto objectName = dstDefOp.getSymbol();
      auto acqType = AIEObjectFifoSubviewType::get(dstMemType);
      auto objACQ = rewriter.create<ObjectFifoAcquireOp>(
                    loc, acqType, ObjectFifoPort::Produce, objectName, 1);
      auto objSubview = rewriter.create<ObjectFifoSubviewAccessOp>(
                        loc, dstMemType, objACQ.getSubview(), zeroAttr);
      rewriter.create<CallOp>(loc, funcOp, ValueRange{objSubview});
      // Replace the use of the buffer
      adf::BufferOp buffer;
      device.walk([&](adf::BufferOp bufferOp) {
        // Check if the symbol name matches.
        if (bufferOp.getSymbol() == objectName) {
          buffer = bufferOp;
          return WalkResult::interrupt();
        }
        return WalkResult::advance();
      });
      auto buf = buffer.getResult();
      buf.replaceUsesWithIf(objSubview.getResult(), [&](OpOperand &use){
        bool flag = !(dyn_cast<DmaOp>(use.getOwner()));
        return flag;
      });
      rewriter.eraseOp(op);
    }else{
      auto stringAttr = StringAttr::get(context, objFIFOName);
      auto objectType = AIEObjectFifoType::get(memrefType);
      rewriter.setInsertionPoint(coreOp);
      rewriter.create<ObjectFifoCreateOp>(loc, stringAttr, srcTile, 
                                          ValueRange{dstTile}, 
                                          depthAttr, objectType);
      auto srcName = srcDefOp.getSymbol();
      auto dstName = dstDefOp.getSymbol();
      auto srcAttr = SymbolRefAttr::get(context, srcName);
      auto dstAttr = SymbolRefAttr::get(context, dstName);
      auto srcArray = ArrayAttr::get(context, {srcAttr});
      auto dstArray = ArrayAttr::get(context, {dstAttr});
      auto empty = ArrayAttr::get(context, {});
      rewriter.create<ObjectFifoLinkOp>(loc, srcArray, dstArray, empty, empty);
      if(store_flag){
        rewriter.setInsertionPointAfter(redLoop);
        rewriter.create<ObjectFifoReleaseOp>(loc, ObjectFifoPort::Produce, 
                                             objFIFOName, 1);
        rewriter.eraseOp(op);
      }else{
        rewriter.setInsertionPoint(op);
        auto acqType = AIEObjectFifoSubviewType::get(memrefType);
        auto objACQ = rewriter.create<ObjectFifoAcquireOp>(
                      loc, acqType, ObjectFifoPort::Consume, objFIFOName, 1);
        auto objSubview = rewriter.create<ObjectFifoSubviewAccessOp>(
                          loc, memrefType, objACQ.getSubview(), zeroAttr);
        auto forOp = op->getParentOfType<AffineForOp>();
        auto& block = forOp.getRegion().front();
        auto terminator = block.getTerminator();
        rewriter.setInsertionPoint(terminator);
        rewriter.create<ObjectFifoReleaseOp>(loc, ObjectFifoPort::Consume, 
                                             objFIFOName, 1);
        // Replace the use of the buffer
        adf::BufferOp buffer;
        device.walk([&](adf::BufferOp bufferOp) {
          // Check if the symbol name matches.
          if (bufferOp.getSymbol().str() == objFIFOName) {
            buffer = bufferOp;
            return WalkResult::interrupt();
          }
          return WalkResult::advance();
        });
        buffer.getResult().replaceAllUsesWith(objSubview.getResult());
        rewriter.eraseOp(op);
      }
    }
    return success();
  }
};

struct BufferConvert : public OpConversionPattern<adf::BufferOp> {
  using OpConversionPattern<adf::BufferOp>::OpConversionPattern;
  LogicalResult matchAndRewrite(
      adf::BufferOp op, OpAdaptor adaptor,
      ConversionPatternRewriter &rewriter) const override {
    
    rewriter.eraseOp(op);
    return success();
  }
};

namespace {

struct ADFConvertToAIE : public ADFConvertToAIEBase<ADFConvertToAIE> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());  
    if (!ConvertToAIE(mod))
      signalPassFailure();
  }

private:
  // Create a new device Op and specify it to npu1_4col
  // Move all the funcs makred by adf.kernel, adf.cell, adf.func to device
  void createDevice(ModuleOp mod, OpBuilder builder, DeviceOp& device, 
                    EndOp& endOp){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
    auto& destBlock = mod.getRegion().front();
    builder.setInsertionPointToStart(&destBlock);
    auto deviceAttr = AIEDeviceAttr::get(context, AIEDevice::npu1_4col);
    device = builder.create<DeviceOp>(loc, deviceAttr);
    auto& entryBlock = device.getRegion().emplaceBlock();
    DeviceOp::ensureTerminator(device.getBodyRegion(), builder, loc);
    endOp = dyn_cast<EndOp>(entryBlock.getTerminator());
    mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.kernel") && !func->hasAttr("adf.cell") && 
         !func->hasAttr("adf.func") )
        func.erase();
      else
        func->moveBefore(endOp);
    });
  }

  // Keep a specific callOp and delete the unused callOp, DmaOp, connectOp
  void removeOps(LaunchCellOp cellLaunch, IntegerAttr attr){
    // First traverse find the specific CallOp
    CallOp call;
    cellLaunch.walk([&](CallOp op){
      auto callName = op.getCallee();
      auto intAttr = dyn_cast<IntegerAttr>(op->getAttr(callName));
      if(intAttr.getInt() == attr.getInt()){
        call = op;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    auto oprands = call.getOperands();
    auto results = call.getResults();
    cellLaunch.walk([&](Operation* op){
      if(dyn_cast<DmaOp>(op) || dyn_cast<adf::ConnectOp>(op)){
        Value src, dst;
        if(auto dmaOp = dyn_cast<DmaOp>(op)){
          src = dmaOp.getSrc();
          dst = dmaOp.getDst();
        }else{
          auto connect = dyn_cast<adf::ConnectOp>(op);
          src = connect.getSrc();
          dst = connect.getDst();
        }
        auto it0 = llvm::find(oprands, src);
        auto it1 = llvm::find(oprands, dst);
        auto it2 = llvm::find(results, src);
        auto it3 = llvm::find(results, dst);
        // If op not used in operands and results then erase it
        if(it0 == oprands.end() && it1 == oprands.end() &&
           it2 == results.end() && it3 == results.end())
          op->erase();
      }else if(auto newCall = dyn_cast<CallOp>(op)){
        if(newCall != call)
          op->erase();
      }
    });
  }

  // 1) Remove tripCount attr of cellLauchOp
  // 2) Split callOp in cellLauchOp to difference cellLauchOps
  void splitCores(OpBuilder builder, DeviceOp device){
    auto loc = builder.getUnknownLoc();
    auto context = builder.getContext();
    for (auto cellLaunch: 
              llvm::make_early_inc_range(device.getOps<LaunchCellOp>())){
      cellLaunch->removeAttr("tripCount");
      cellLaunch.walk([&](CallOp call){
        builder.setInsertionPoint(cellLaunch);
        auto callName = call.getCallee();
        if(!call->hasAttr("adf.kernel"))
          return WalkResult::advance();
        auto intAttr = dyn_cast<IntegerAttr>(call->getAttr(callName));
        auto newLaunch = dyn_cast<LaunchCellOp>(cellLaunch->clone());
        auto strAttr = StringAttr::get(context, callName);
        newLaunch->setAttr("callName", strAttr);
        builder.insert(newLaunch);
        removeOps(newLaunch, intAttr);
        auto& entryBlock = newLaunch.getRegion().front();
        builder.setInsertionPointToStart(&entryBlock);
        auto infinteLoop = builder.create<AffineForOp>(loc, 0, UINT_MAX, 1);
        auto forblock = infinteLoop.getBody();
        auto forYiledOp = dyn_cast<AffineYieldOp>(forblock->getTerminator()); 
        for(auto& op : llvm::make_early_inc_range(newLaunch.getOps())){
          if(auto loop = dyn_cast<AffineForOp>(op)){
            if( loop!= infinteLoop)
              op.moveBefore(forYiledOp);
          }else if(!dyn_cast<EndLaunchCellOp>(op)){
            op.moveBefore(forYiledOp);
          }
        }
        return WalkResult::advance();
      });
      cellLaunch.erase();
    }
  }

  // Create and record tileOp for shim, mem-tile and cores
  void recordMap(OpBuilder builder, DeviceOp device,
                 DenseMap<Value, std::pair<Value, std::string>>& memMap,
                 DenseMap<CallOp, Value>& coreMap){
    auto loc = builder.getUnknownLoc();
    auto& entryBlock = device.getRegion().front();
    builder.setInsertionPointToStart(&entryBlock);
    SmallVector<std::tuple<Value, int32_t, int32_t>, 4> tileLocs;
    device.walk([&](BuffLocOp bufLoc){
      Value buf = bufLoc.getBuffer();
      auto buffOp = dyn_cast<adf::BufferOp>(buf.getDefiningOp());
      auto col = bufLoc.getCol();
      auto constCol = dyn_cast<arith::ConstantOp>(col.getDefiningOp());
      int32_t colInt = dyn_cast<IntegerAttr>(constCol.getValue()).getInt();
      auto row = bufLoc.getRow();
      auto constRow = dyn_cast<arith::ConstantOp>(row.getDefiningOp());
      int32_t rowInt = dyn_cast<IntegerAttr>(constRow.getValue()).getInt();
      auto it = llvm::find_if(tileLocs, [&colInt, &rowInt](
                            const std::tuple<Value, int32_t, int32_t>& tileLoc){
        return std::get<1>(tileLoc) == colInt && std::get<2>(tileLoc) == rowInt;
      });
      if(it != tileLocs.end()){
        memMap[buf].first = std::get<0>(*it);
        memMap[buf].second = buffOp.getSymbol();
      }else{
        auto tile = builder.create<TileOp>(loc, colInt, rowInt);
        memMap[buf].first = tile.getResult();
        memMap[buf].second = buffOp.getSymbol();
        tileLocs.push_back(std::tuple(tile, colInt, rowInt));
      }
      bufLoc.erase();
    });
    device.walk([&](ConfigGMIOOp configOp){
      auto gmio = configOp.getGmio();
      auto attr = dyn_cast<ArrayAttr>(configOp->getAttr("col, chl"));
      auto colAttr = attr[0];
      int32_t colInt = dyn_cast<IntegerAttr>(colAttr).getInt();
      int32_t rowInt = 0;
      auto it = llvm::find_if(tileLocs, [&colInt, &rowInt](
                            const std::tuple<Value, int32_t, int32_t>& tileLoc){
        return std::get<1>(tileLoc) == colInt && std::get<2>(tileLoc) == rowInt;
      });
      if(it != tileLocs.end())
        memMap[gmio].first = std::get<0>(*it);
      else{
        auto tile = builder.create<TileOp>(loc, colInt, rowInt);
        memMap[gmio].first = tile.getResult();
        tileLocs.push_back(std::tuple(tile, colInt, rowInt));
      }
      configOp.erase();
    });
    device.walk([&](CallOp call){
      auto attr = dyn_cast<ArrayAttr>(call->getAttr("col, row"));
      auto colAttr = attr[0];
      auto rowAttr = attr[1];
      int32_t colInt = dyn_cast<IntegerAttr>(colAttr).getInt();
      int32_t rowInt = dyn_cast<IntegerAttr>(rowAttr).getInt();
      auto it = llvm::find_if(tileLocs, [&colInt, &rowInt](
                            const std::tuple<Value, int32_t, int32_t>& tileLoc){
        return std::get<1>(tileLoc) == colInt && std::get<2>(tileLoc) == rowInt;
      });
      if(it != tileLocs.end())
        coreMap[call] = std::get<0>(*it);
      else{
        auto tile = builder.create<TileOp>(loc, colInt, rowInt);
        coreMap[call] = tile.getResult();
        tileLocs.push_back(std::tuple(tile, colInt, rowInt));
      }
    });
  }

  // Tranverse each operands of adf.cell calls and create a newIO before endOp
  void createNewIO(OpBuilder builder, CallOp call, EndOp endOp,
                   unsigned &inCnt, unsigned &outCnt,
                   SmallVector<Value, 6>& graphIOs){
    auto indexType = builder.getIndexType();
    for(auto operand : call.getOperands()){
      auto defineOp = operand.getDefiningOp();
      if(!defineOp || !dyn_cast<CreateGraphIOOp>(defineOp)){
        llvm::errs() << "Adf cell has non-graphio arguments\n";
        return;
      }
      auto graphio = dyn_cast<CreateGraphIOOp>(defineOp);
      auto tempType = graphio.getType();
      auto ioType = dyn_cast<GMIOType>(tempType);
      if(!ioType){
        llvm::errs() << "Adf cell has non-gmio arguments\n";
        return;
      }
      auto dir = ioType.getDir();
      if(dir == PortDir::In){
        auto intAttr = builder.getIntegerAttr(indexType, inCnt++);
        graphio->setAttr("input_io", intAttr);
      }else{
        auto intAttr = builder.getIntegerAttr(indexType, outCnt++);
        graphio->setAttr("output_io", intAttr);
      }
      auto newio = graphio.clone();
      builder.setInsertionPoint(endOp);
      builder.insert(newio);
      graphIOs.push_back(newio.getResult());
    }
  }

  // This function create a callee, move all the operations of callee before
  // the endOp and replace the arguments by graphios
  void moveToDevice(OpBuilder builder, CallOp call, DeviceOp device, 
                    EndOp endOp, SmallVector<Value, 6>& graphIOs){
    auto calleeName = call.getCallee();
    auto callee = device.lookupSymbol<FuncOp>(calleeName);
    auto newCallee = dyn_cast<FuncOp>(callee->clone());
    builder.setInsertionPoint(callee);
    builder.insert(newCallee);
    auto numIO = graphIOs.size();
    for (unsigned i = 0; i < numIO; ++i) {
      auto oldio = newCallee.getArgument(i);
      auto newio = graphIOs[i];
      oldio.replaceUsesWithIf(newio,[&](OpOperand &use){
          return newCallee->isProperAncestor(use.getOwner());
      });
    }
    for(auto& op: llvm::make_early_inc_range(newCallee.getOps())){
      if(!dyn_cast<ReturnOp>(op))
        op.moveBefore(endOp);
    }
    newCallee.erase();
  }

  // This function creates the graphios and lift the operations
  // inside the func marked by adf.cell to deviceOp
  void liftCell(OpBuilder builder, DeviceOp device, EndOp endOp){
    unsigned inCnt=0, outCnt=0;
    // First tranverse create newIOs and move ops from callee to device
    for(auto func: device.getOps<FuncOp>()){
      if(!func->hasAttr("adf.func"))
        continue;
      func.walk([&](CallOp call){
        if(!call->hasAttr("adf.cell"))
          return WalkResult::advance();
        SmallVector<Value, 6> graphIOs;
        createNewIO(builder, call, endOp, inCnt, outCnt, graphIOs);
        moveToDevice(builder, call, device, endOp, graphIOs);
        call.erase();
        return WalkResult::advance();
      });
    }
    // Second tranverse, remove adf.cells
    for(auto func: llvm::make_early_inc_range(device.getOps<FuncOp>())){
      if(!func->hasAttr("adf.cell"))
        continue;
      func.erase();
    }
  }

  bool ADFtoAIE(OpBuilder builder, DeviceOp& device,
                DenseMap<Value, std::pair<Value, std::string>>& memMap,
                DenseMap<CallOp, Value>& coreMap){
    MLIRContext *context = device->getContext();
    RewritePatternSet patterns(context);
    ConversionTarget target(*context);
    target.addIllegalOp<adf::ConnectOp>();
    patterns.add<ConnectConvert>(patterns.getContext(), memMap);
    patterns.add<CellLaunchConvert>(patterns.getContext(), coreMap);
    patterns.add<DmaConvert>(patterns.getContext(), memMap);
    patterns.add<BufferConvert>(patterns.getContext());
    target.addLegalOp<ObjectFifoAcquireOp>();
    target.addLegalOp<ObjectFifoSubviewAccessOp>();
    target.addLegalDialect<FuncDialect>();
    target.addLegalDialect<AffineDialect>();
    target.addLegalDialect<AIEDialect>();
    target.addLegalDialect<AIEXDialect>();
    if (failed(applyPartialConversion(device, target, std::move(patterns))))
      return false;
    return true;
  }

  bool ConvertToAIE(ModuleOp mod) {
    auto builder = OpBuilder(mod);
    DeviceOp device;
    EndOp endOp;
    createDevice(mod, builder, device, endOp);
    liftCell(builder, device, endOp);
    splitCores(builder, device);
    // Record tiles of shim, L1 and L2 mem, tile = memMap[buf/shim].first
    DenseMap<Value, std::pair<Value, std::string>> memMap;
    DenseMap<CallOp, Value> coreMap;
    recordMap(builder, device, memMap, coreMap);
    if(!ADFtoAIE(builder, device, memMap, coreMap))
      return false;
    return true;
  }

};

} // namespace


namespace mlir {
namespace aries {
namespace adf {

std::unique_ptr<Pass> createADFConvertToAIEPass() {
  return std::make_unique<ADFConvertToAIE>();
}

} // namespace adf
} // namespace aries
} // namespace mlir