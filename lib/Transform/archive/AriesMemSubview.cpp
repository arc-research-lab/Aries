#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "llvm/Support/Debug.h"

#include "mlir/IR/Builders.h"

using namespace mlir;
using namespace aries;
using namespace mlir::affine;
using namespace mlir::arith;
using namespace mlir::memref;
using namespace func;


namespace {

struct AriesMemSubview : public AriesMemSubviewBase<AriesMemSubview> {
public:
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    if (failed(MemSubview(mod)))
      signalPassFailure();
  }

private:
  // This pass analyzes the memref arguments used by affine.load and store ops.
  // And then it creates a subview of the mem access to represent the local mem.
  // 1) Flatten the experssion of the map to [dims, symbols, locals, constant]
  // 2) Dims and Constant determine the size of the subview
  // 3) Symbols determine the offset of the subview 
  // 4) TODO: Handle Locals
  LogicalResult MemSubview(ModuleOp mod){
    auto builder = OpBuilder(mod);
    auto context = mod.getContext();
    auto loc = builder.getUnknownLoc();
    // Tranverse all the adf.func
    for (auto func : mod.getOps<FuncOp>()) {
      if(!func->hasAttr("adf.func"))
        continue;
      auto flag = func.walk([&](CallOp caller){
        auto calleeFuncOp = mod.lookupSymbol<FuncOp>(caller.getCallee());

        for (auto arg : calleeFuncOp.getArguments()) {
          // Traverse the memref arguments in the callee function
          auto argType = dyn_cast<MemRefType>(arg.getType());
          if (!argType)
            continue;

          //Here assume there is only one access pattern for each memref argument
          auto affineOp = *arg.user_begin();
          SmallVector<Value, 4> operands;
          AffineMap map;
          SmallVector<AffineForOp, 6> band;
          if (auto loadOp = dyn_cast<AffineLoadOp>(affineOp)) {
            operands = SmallVector<Value, 4>(loadOp.getMapOperands());
            map = loadOp.getAffineMap();
          } else if (auto storeOp = dyn_cast<AffineStoreOp>(affineOp)) {
            operands = SmallVector<Value, 4>(storeOp.getMapOperands());
            map = storeOp.getAffineMap();
          } else{
            continue;
          }
          getSurroundingLoops(*affineOp, band);
          auto mapSize = map.getNumResults();
          auto dimSize = map.getNumDims();
          auto symSize = map.getNumSymbols();
          //Used to build memref.subview
          SmallVector<OpFoldResult, 4> memOffsets;
          SmallVector<OpFoldResult, 4> memSizes;
          SmallVector<OpFoldResult, 4> memStrides;
          SmallVector<Value, 4> newOperands;
          SmallVector<AffineExpr, 4> newExprs;
          for (unsigned i = 0; i < dimSize; i++)
            newOperands.push_back(operands[i]);
          builder.setInsertionPointToStart(&calleeFuncOp.front());
          // Tranverse the maps of the load/store ops
          for(unsigned i = 0; i < mapSize; i++){
            auto mapExpr = map.getResult(i);
            // flattened form [dims, symbols, locals, constant]
            llvm::SmallVector<int64_t> flattenedExpr;
            llvm::SmallVector<int64_t> newFlattenedExpr;
            if (failed(getFlattenedAffineExpr(mapExpr, dimSize, symSize,
                                              &flattenedExpr)))
              return WalkResult::interrupt();
            int64_t cons = flattenedExpr[flattenedExpr.size()-1];
            // Deal with Dims to get the size of the subview and create new access
            int64_t size = cons + 1;
            for (unsigned i = 0; i < dimSize; i++) {
              auto coeff = flattenedExpr[i];
              newFlattenedExpr.push_back(coeff);
              auto loop = getForInductionVarOwner(operands[i]);
              auto it = llvm::find(band, loop);
              if(it==band.end())
                return WalkResult::interrupt();
              auto ub = loop.getConstantUpperBound();
              if(ub < 1)
                continue;
              size += (ub-1) * coeff;
            }
            newFlattenedExpr.push_back(cons);
            auto newMemExpr = getAffineExprFromFlatForm(newFlattenedExpr, 
                                                        dimSize, 0, {}, context);
            newExprs.push_back(newMemExpr);
            memSizes.push_back(builder.getIndexAttr(size));
            // TODO : Strides need to be more general 
            memStrides.push_back(builder.getIndexAttr(1));
            AffineExpr expr;
            SmallVector<Value> symbolOperands;
            unsigned dimCnt = 0;
            // Deal with Symbols to get the offsets of the subview
            for (unsigned i = dimSize; i < (dimSize + symSize); i++) {
              auto coeff = flattenedExpr[i];
              if (coeff==0)
                continue;
              symbolOperands.push_back(operands[i]);
              auto dim = builder.getAffineDimExpr(dimCnt);
              if(dimCnt==0)
                expr = dim * coeff;
              else
                expr = expr + dim * coeff;
              dimCnt++;
            }
            auto newDimSize = symbolOperands.size();
            auto newMap = AffineMap::get(newDimSize, 0, expr, context);
            auto applyOp 
                 = builder.create<AffineApplyOp>(loc, newMap, symbolOperands);
            memOffsets.push_back(applyOp.getResult());
            builder.setInsertionPointAfter(applyOp);
          }
          // Create the SubViewOp with dynmic entries and inferred result type
          auto subviewOutputType = dyn_cast<MemRefType>(
          SubViewOp::inferResultType(dyn_cast<MemRefType>(arg.getType()),
                                     memOffsets, memSizes, memStrides));
          auto subview =
              builder.create<SubViewOp>(loc, 
                                        subviewOutputType, arg, memOffsets, 
                                        memSizes, memStrides);

          arg.replaceAllUsesExcept(subview.getResult(), subview);

          // Create new affineMap and update the memory access
          auto newMap = AffineMap::get(dimSize, 0, newExprs, context);
          for(auto use : subview->getUsers()){
            if (auto loadOp = dyn_cast<AffineLoadOp>(use)) {
              auto mem = loadOp.getMemRef();
              builder.setInsertionPoint(loadOp);
              auto newLoadOp = builder.create<AffineLoadOp>(
                               loc, mem, newMap, newOperands);
              loadOp.getResult().replaceAllUsesWith(newLoadOp);
              loadOp.erase();
            } else if (auto storeOp = dyn_cast<AffineStoreOp>(use)) {
              auto mem = storeOp.getMemRef();
              auto val = storeOp.getValue();
              builder.setInsertionPoint(storeOp);
              builder.create<AffineStoreOp>(loc, val, mem, newMap, newOperands);
              storeOp.erase();
            } else{
              continue;
            }
          }
        }
        return WalkResult::advance();
      });
      if (flag == WalkResult::interrupt())
        return failure();
    }
    return success();
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesMemSubviewPass() {
  return std::make_unique<AriesMemSubview>();
}

} // namespace aries
} // namespace mlir