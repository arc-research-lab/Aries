#ifndef ARIES_DIALECT_ADF_VISITOR_H
#define ARIES_DIALECT_ADF_VISITOR_H

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "llvm/ADT/TypeSwitch.h"

#include "aries/Dialect/ADF/ADFDialect.h"

namespace mlir {
namespace aries {

using namespace adf;

/// This class is a visitor for SSACFG operation nodes.
template <typename ConcreteType, typename ResultType, typename... ExtraArgs>
class ADFVisitorBase {
public:
  ResultType dispatchVisitor(Operation *op, ExtraArgs... args) {
    auto *thisCast = static_cast<ConcreteType *>(this);
    return TypeSwitch<Operation *, ResultType>(op)
        .template Case<
            // ADF dialect operations.
            GraphOp, GraphReturnOp, CellOp, EndCellOp, LaunchCellOp, 
            EndLaunchCellOp, WaitLaunchCellOp, KernelOp, CreateGraphIOOp, 
            ConfigPLIOOp, ConfigGMIOOp, BufferOp, StreamOp, CascadeOp, 
            CreateKernelIOOp, DmaOp, ConnectOp, IOPushOp, IOPopOp, IOWaitOp,
            IOWriteOp, IOReadOp, BuffLocOp, IntToAPInt, APIntToInt, GetIntBitOp, 
            SetIntBitOp, GetIntSliceOp, SetIntSliceOp, BitReverseOp,

            // Function operations.
            func::CallOp, func::ReturnOp,

            // SCF statements.
            scf::ForOp, scf::IfOp, scf::ParallelOp, scf::ReduceOp,
            scf::ReduceReturnOp, scf::YieldOp,

            // Affine statements.
            AffineForOp, AffineIfOp, AffineParallelOp, AffineApplyOp,
            AffineMaxOp, AffineMinOp, AffineLoadOp, AffineStoreOp,
            AffineVectorLoadOp, AffineVectorStoreOp, AffineYieldOp,

            // Vector statements.
            vector::InsertOp, vector::ExtractOp, vector::ExtractElementOp,
            vector::TransferReadOp, vector::TransferWriteOp,
            vector::BroadcastOp,

            // Memref statements.
            memref::AllocOp, memref::AllocaOp, memref::LoadOp, memref::StoreOp,
            memref::DeallocOp, memref::CopyOp, memref::SubViewOp, 
            memref::CastOp,

            // Unary expressions.
            math::AbsIOp, math::AbsFOp, math::CeilOp, math::CosOp, math::SinOp,
            math::TanhOp, math::SqrtOp, math::RsqrtOp, math::ExpOp,
            math::Exp2Op, math::LogOp, math::Log2Op, math::Log10Op,
            arith::NegFOp, arith::MaximumFOp,

            // Float binary expressions.
            arith::CmpFOp, arith::AddFOp, arith::SubFOp, arith::MulFOp,
            arith::DivFOp, arith::RemFOp, math::PowFOp,

            // Integer binary expressions.
            arith::CmpIOp, arith::AddIOp, arith::SubIOp, arith::MulIOp,
            arith::DivSIOp, arith::RemSIOp, arith::DivUIOp, arith::RemUIOp,
            arith::XOrIOp, arith::AndIOp, arith::OrIOp, arith::ShLIOp,
            arith::ShRSIOp, arith::ShRUIOp, arith::MaxSIOp, arith::MinSIOp,
            arith::MaxUIOp, arith::MinUIOp,

            // Special expressions.
            arith::SelectOp, arith::ConstantOp, arith::TruncIOp,
            arith::TruncFOp, arith::ExtUIOp, arith::ExtSIOp, arith::IndexCastOp,
            arith::UIToFPOp, arith::SIToFPOp, arith::FPToSIOp, arith::FPToUIOp,
            arith::BitcastOp>(
            [&](auto opNode) -> ResultType {
              return thisCast->visitOp(opNode, args...);
            })
        .Default([&](auto opNode) -> ResultType {
          return thisCast->visitInvalidOp(op, args...);
        });
  }

  /// This callback is invoked on any invalid operations.
  ResultType visitInvalidOp(Operation *op, ExtraArgs... args) {
    op->emitOpError("is unsupported operation.");
    abort();
  }

  /// This callback is invoked on any operations that are not handled by the
  /// concrete visitor.
  ResultType visitUnhandledOp(Operation *op, ExtraArgs... args) {
    return ResultType();
  }

#define HANDLE(OPTYPE)                                                         \
  ResultType visitOp(OPTYPE op, ExtraArgs... args) {                           \
    return static_cast<ConcreteType *>(this)->visitUnhandledOp(op, args...);   \
  }

  // ADF dialect operations.
  HANDLE(GraphOp);
  HANDLE(GraphReturnOp);
  HANDLE(CellOp);
  HANDLE(EndCellOp);
  HANDLE(LaunchCellOp);
  HANDLE(EndLaunchCellOp);
  HANDLE(WaitLaunchCellOp);
  HANDLE(KernelOp);
  HANDLE(CreateGraphIOOp);
  HANDLE(ConfigPLIOOp);
  HANDLE(ConfigGMIOOp);
  HANDLE(BufferOp);
  HANDLE(StreamOp);
  HANDLE(CascadeOp);
  HANDLE(CreateKernelIOOp);
  HANDLE(DmaOp);
  HANDLE(ConnectOp);
  HANDLE(IOPushOp);
  HANDLE(IOPopOp);
  HANDLE(IOWaitOp);
  HANDLE(IOWriteOp);
  HANDLE(IOReadOp);
  HANDLE(BuffLocOp);
  HANDLE(IntToAPInt);
  HANDLE(APIntToInt);
  HANDLE(GetIntBitOp);
  HANDLE(SetIntBitOp);
  HANDLE(GetIntSliceOp);
  HANDLE(SetIntSliceOp);
  HANDLE(BitReverseOp);

  // Control flow operations.
  HANDLE(func::CallOp);
  HANDLE(func::ReturnOp);

  // SCF statements.
  HANDLE(scf::ForOp);
  HANDLE(scf::IfOp);
  HANDLE(scf::ParallelOp);
  HANDLE(scf::ReduceOp);
  HANDLE(scf::ReduceReturnOp);
  HANDLE(scf::YieldOp);

  // Affine statements.
  HANDLE(AffineForOp);
  HANDLE(AffineIfOp);
  HANDLE(AffineParallelOp);
  HANDLE(AffineApplyOp);
  HANDLE(AffineMaxOp);
  HANDLE(AffineMinOp);
  HANDLE(AffineLoadOp);
  HANDLE(AffineStoreOp);
  HANDLE(AffineVectorLoadOp);
  HANDLE(AffineVectorStoreOp);
  HANDLE(AffineYieldOp);

  // Vector statements.
  HANDLE(vector::InsertOp);
  HANDLE(vector::ExtractOp);
  HANDLE(vector::ExtractElementOp);
  HANDLE(vector::TransferReadOp);
  HANDLE(vector::TransferWriteOp);
  HANDLE(vector::BroadcastOp);

  // Memref statements.
  HANDLE(memref::AllocOp);
  HANDLE(memref::AllocaOp);
  HANDLE(memref::LoadOp);
  HANDLE(memref::StoreOp);
  HANDLE(memref::DeallocOp);
  HANDLE(memref::CopyOp);
  HANDLE(memref::SubViewOp);
  HANDLE(memref::CastOp);

  // Unary expressions.
  HANDLE(math::AbsIOp);
  HANDLE(math::AbsFOp);
  HANDLE(math::CeilOp);
  HANDLE(math::CosOp);
  HANDLE(math::SinOp);
  HANDLE(math::TanhOp);
  HANDLE(math::SqrtOp);
  HANDLE(math::RsqrtOp);
  HANDLE(math::ExpOp);
  HANDLE(math::Exp2Op);
  HANDLE(math::LogOp);
  HANDLE(math::Log2Op);
  HANDLE(math::Log10Op);
  HANDLE(arith::NegFOp);
  HANDLE(arith::MaximumFOp);

  // Float binary expressions.
  HANDLE(arith::CmpFOp);
  HANDLE(arith::AddFOp);
  HANDLE(arith::SubFOp);
  HANDLE(arith::MulFOp);
  HANDLE(arith::DivFOp);
  HANDLE(arith::RemFOp);
  HANDLE(math::PowFOp);

  // Integer binary expressions.
  HANDLE(arith::CmpIOp);
  HANDLE(arith::AddIOp);
  HANDLE(arith::SubIOp);
  HANDLE(arith::MulIOp);
  HANDLE(arith::DivSIOp);
  HANDLE(arith::RemSIOp);
  HANDLE(arith::DivUIOp);
  HANDLE(arith::RemUIOp);
  HANDLE(arith::XOrIOp);
  HANDLE(arith::AndIOp);
  HANDLE(arith::OrIOp);
  HANDLE(arith::ShLIOp);
  HANDLE(arith::ShRSIOp);
  HANDLE(arith::ShRUIOp);
  HANDLE(arith::MaxSIOp);
  HANDLE(arith::MinSIOp);
  HANDLE(arith::MaxUIOp);
  HANDLE(arith::MinUIOp);

  // Special expressions.
  HANDLE(arith::SelectOp);
  HANDLE(arith::ConstantOp);
  HANDLE(arith::TruncIOp);
  HANDLE(arith::TruncFOp);
  HANDLE(arith::ExtUIOp);
  HANDLE(arith::ExtSIOp);
  HANDLE(arith::ExtFOp);
  HANDLE(arith::IndexCastOp);
  HANDLE(arith::UIToFPOp);
  HANDLE(arith::SIToFPOp);
  HANDLE(arith::FPToUIOp);
  HANDLE(arith::FPToSIOp);
  HANDLE(arith::BitcastOp);
#undef HANDLE
};
} // namespace aries
} // namespace mlir

#endif // ARIES_DIALECT_ADF_VISITOR_H