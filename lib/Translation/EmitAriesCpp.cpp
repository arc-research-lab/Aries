#include "mlir/InitAllDialects.h"
#include "mlir/Tools/mlir-translate/Translation.h"
#include "mlir/IR/AffineExprVisitor.h"
#include "mlir/Dialect/Affine/IR/AffineValueMap.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/IntegerSet.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/Debug.h"
#include "aries/Translation/Emitter.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"
#include "aries/Dialect/ADF/Visitor.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::func;


// TODO: update naming rule.
SmallString<8> ADFEmitterBase::addName(Value val, bool isPtr,
                                       std::string name) {
  assert(!isDeclared(val) && "has been declared before.");

  SmallString<8> valName;
  // if (isPtr)
  //   valName += "*";

  if (name != "") {
    if (state.nameConflictCnt.count(name) > 0) {
      state.nameConflictCnt[name]++;
      valName += StringRef(name + std::to_string(state.nameConflictCnt[name]));
    } else { // first time
      state.nameConflictCnt[name] = 0;
      valName += name;
    }
  } else {
    valName += StringRef("v" + std::to_string(state.nameTable.size()));
  }
  state.nameTable[val] = valName;

  return valName;
};

// TODO: update naming rule.
SmallString<8> ADFEmitterBase::addCall(CallOp call, std::string name) {
  assert(!isDeclared(call) && "has been declared before.");

  SmallString<8> callName;

  if (name != "") {
    if (state.nameConflictCnt.count(name) > 0) {
      state.nameConflictCnt[name]++;
      callName += StringRef(name + std::to_string(state.nameConflictCnt[name]));
    } else { // first time
      state.nameConflictCnt[name] = 0;
      callName += name;
    }
  } else {
    if(call->hasAttr("adf.kernel"))
      callName += StringRef(call.getCallee().str()  
                            + "_k"  + std::to_string(state.idxCnts[0]++));
    else if(call->hasAttr("adf.cell"))
      callName += StringRef(call.getCallee().str()
                            + "_gr" + std::to_string(state.idxCnts[1]++));
    else if(call->hasAttr("adf.pl"))
      callName = StringRef(call.getCallee().str() 
                           + "_pl" + std::to_string(state.idxCnts[2]++));
    else
      callName += StringRef("var" + std::to_string(state.callTable.size()));
  }
  state.callTable[call] = callName;

  return callName;
};


SmallString<8> ADFEmitterBase::getName(Value val) {
  // For constant scalar operations, the constant number will be returned
  // rather than the value name.
  if (auto defOp = val.getDefiningOp()) {
    if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
      auto constAttr = constOp.getValue();

      if (auto boolAttr = dyn_cast<BoolAttr>(constAttr)) {
        return SmallString<8>(std::to_string(boolAttr.getValue()));

      } else if (auto floatAttr = dyn_cast<FloatAttr>(constAttr)) {
        auto value = floatAttr.getValueAsDouble();
        if (std::isfinite(value))
          return SmallString<8>(std::to_string(value));
        else if (value > 0)
          return SmallString<8>("INFINITY");
        else
          return SmallString<8>("-INFINITY");

      } else if (auto intAttr = dyn_cast<IntegerAttr>(constAttr)) {
        auto value = intAttr.getInt();
        return SmallString<8>(std::to_string(value));
      }
    }
  }
  return state.nameTable.lookup(val);
};

SmallString<8> ADFEmitterBase::getCall(CallOp call) {
  return state.callTable.lookup(call);
};

static Value getCalleeArg(Value val, CallOp& call){
  unsigned index_final;
  for(auto use : val.getUsers()){
    if(auto callop = dyn_cast<CallOp>(use)){
      call = callop;
      unsigned index=0;
      for(auto arg: call.getArgOperands()){
        if(arg == val){
          index_final = index;
          break;
        }
        index++;
      }
      break;
    }else{
      assert("The dst of the IOPush is not used by adf.cell");
    }
  }
  auto mod = call->getParentOfType<ModuleOp>();
  auto calleeFuncOp = mod.lookupSymbol<FuncOp>(call.getCallee());
  auto gmio = calleeFuncOp.getArgument(index_final);
  return gmio;
}
SmallString<16> ADFEmitterBase::getTypeName(Type valType, bool isPtr,
                                            bool BIT_FLAG) {
  bool PLIO_FLAG = false;
  if (auto memType = dyn_cast<MemRefType>(valType)){
    auto attr = memType.getMemorySpace();
    if(attr && dyn_cast<StringAttr>(attr) &&
       dyn_cast<StringAttr>(attr).getValue().str().substr(0, 4) == "plio")
      PLIO_FLAG = true;
  }

  if (auto arrayType = dyn_cast<ShapedType>(valType))
    valType = arrayType.getElementType();

  SmallString<16> typeName;

  // Handle float types.
  if (isa<Float32Type>(valType)){
    if (PLIO_FLAG)
      typeName = SmallString<16>("ap_axiu<32, 0, 0, 0>");
    else
      typeName = SmallString<16>("float");
  }else if (isa<Float64Type>(valType)){
    if (PLIO_FLAG)
      typeName = SmallString<16>("ap_axiu<64, 0, 0, 0>");
    else
      typeName = SmallString<16>("double");
  }
  // Handle integer types.
  else if (isa<IndexType>(valType))
    typeName = SmallString<16>("int");
  else if (auto intType = dyn_cast<IntegerType>(valType)) {
    if (intType.getWidth() == 1) {
      typeName = SmallString<16>("bool");
    } else {
      std::string signedness = "";
      if (intType.getSignedness() == IntegerType::SignednessSemantics::Unsigned)
        signedness = "u";
      if(PLIO_FLAG){
        auto width = intType.getWidth();
        typeName = SmallString<16>("ap_axiu<" + std::to_string(width) 
                                    + ", 0 ,0 ,0>");
      }else if(!BIT_FLAG){
        switch (intType.getWidth()) {
          case 8:
          case 16:
          case 32:
          case 64:
            typeName = SmallString<16>(signedness + "int" +
                                   std::to_string(intType.getWidth()) + "_t");
            break;
          default:
            typeName = SmallString<16>("ap_" + signedness + "int<" +
                                   std::to_string(intType.getWidth()) + ">");
        }
      }else{
        typeName = SmallString<16>("ap_" + signedness + "int<" +
                               std::to_string(intType.getWidth()) + ">");
      }
    }
  }
  else if (auto plioType = dyn_cast<PLIOType>(valType)){
    auto Dir = plioType.getDir();
    if(Dir==PortDir::In)
      typeName = SmallString<16>("adf::input_plio");
    else if(Dir==PortDir::Out)
      typeName = SmallString<16>("adf::output_plio");
    else
      assert("PLIO can't be an inout port.");
  }else if (auto gmioType = dyn_cast<GMIOType>(valType)){
    auto Dir = gmioType.getDir();
    if(Dir==PortDir::In)
      typeName = SmallString<16>("adf::input_gmio");
    else if(Dir==PortDir::Out)
      typeName = SmallString<16>("adf::output_gmio");
    else
      assert("GMIO can't be an inout port.");
  }else if (auto portType = dyn_cast<PortType>(valType)){
    auto Dir = portType.getDir();
    if(Dir==PortDir::In)
      typeName = SmallString<16>("adf::input_port");
    else if(Dir==PortDir::Out)
      typeName = SmallString<16>("adf::output_port");
    else
      typeName = SmallString<16>("adf::inout_port");
  }else{
    assert("Dectect data type not supported.");
  }
  if(isPtr)
    typeName += "*";
  return typeName;
}

SmallString<16> ADFEmitterBase::getTypeName(CallOp call) {
  if(call->hasAttr("adf.kernel")){
    return SmallString<16>("adf::kernel");
  }else if(call->hasAttr("adf.cell")){
    return call.getCallee();
  }else{
    assert("Dectect type not supported.");
  }
  return SmallString<16>();
}

SmallString<16> ADFEmitterBase::getTypeName(Value val, bool isPtr, 
                                            bool BIT_FLAG) {
  auto valType = val.getType();
  return getTypeName(valType, isPtr, BIT_FLAG);
}

void fixUnsignedType(Value &result, bool isUnsigned) {
  if (isUnsigned) { // unsigned type
    if (isa<MemRefType>(result.getType())) {
      auto arrayType = dyn_cast<MemRefType>(result.getType());
      Type elt = IntegerType::get(
          arrayType.getContext(),
          dyn_cast<IntegerType>(arrayType.getElementType()).getWidth(),
          IntegerType::SignednessSemantics::Unsigned);
      result.setType(MemRefType::get(arrayType.getShape(), elt,
                                     arrayType.getLayout(),
                                     arrayType.getMemorySpace()));
    } else if (isa<IntegerType>(result.getType())) {
      Type type =
          IntegerType::get(result.getType().getContext(),
                           dyn_cast<IntegerType>(result.getType()).getWidth(),
                           IntegerType::SignednessSemantics::Unsigned);
      result.setType(type);
    }
  }
}

SmallString<16> ADFEmitterBase::getDMAAccess(adf::DmaOp op, unsigned rank, 
                                             bool isSrc, bool dir){
  
  SmallVector<Value> offsets;
  SmallVector<Value> sizes  ;
  SmallVector<Value> strides;
  MemRefType var;
  if(isSrc){
    offsets=op.getSrcOffsets();
    sizes  =op.getSrcSizes();
    strides=op.getSrcStrides(); 
    var = dyn_cast<MemRefType>(op.getSrc().getType());
  }else{
    offsets=op.getDstOffsets();
    sizes  =op.getDstSizes();
    strides=op.getDstStrides();
    var = dyn_cast<MemRefType>(op.getDst().getType());
  }

  std::string access;
  //if is the src of a input gmio or the dst of a output gmio
  if((isSrc&&dir)||((!isSrc)&&(!dir))){
    for(unsigned i=0; i< rank; i++){
      unsigned offset = 0;
      unsigned stride = 1;
      std::string offsetString = std::to_string(offset);
      std::string strideString = std::to_string(stride);
      if(sizes.size()){
        strideString = getName(strides[i]).str();
        offsetString = getName(offsets[i]).str();
      }
      access += "[" + offsetString + " + iv" + std::to_string(i) 
                 + " * " + strideString + "]"; 
    }
  }else{
    access = "[iv0";
    for(unsigned i=1; i< rank; i++){
      unsigned ub = var.getDimSize(i-1);
      if(sizes.size())
        ub = dyn_cast<IntegerAttr>(
             sizes[i-1].getDefiningOp<arith::ConstantOp>()
             .getValue()).getInt();
      access += " + iv" + std::to_string(i) + " * " + std::to_string(ub); 
    }
    access += "]";
  }

  return SmallString<16>(access);
}

/// Parse other attributes.
SmallVector<int64_t, 8> getIntArrayAttrValue(Operation *op,
                                                  StringRef name) {
  SmallVector<int64_t, 8> array;
  if (auto arrayAttr = op->getAttrOfType<ArrayAttr>(name)) {
    for (auto attr : arrayAttr)
      if (auto intAttr = dyn_cast<IntegerAttr>(attr))
        array.push_back(intAttr.getInt());
      else
        return SmallVector<int64_t, 8>();
    return array;
  } else
    return SmallVector<int64_t, 8>();
}

namespace {
class ModuleEmitter : public ADFEmitterBase {
public:
  explicit ModuleEmitter(ADFEmitterState &state) : ADFEmitterBase(state) {}
  /// SCF statement emitters.
  void emitScfFor(scf::ForOp op);
  void emitScfIf(scf::IfOp op);
  void emitScfYield(scf::YieldOp op);

  /// Affine statement emitters.
  void emitAffineFor(AffineForOp op);
  void emitAffineIf(AffineIfOp op);
  void emitAffineParallel(AffineParallelOp op);
  void emitAffineApply(AffineApplyOp op);
  template <typename OpType>
  void emitAffineMaxMin(OpType op, const char *syntax);
  void emitAffineLoad(AffineLoadOp op);
  void emitAffineStore(AffineStoreOp op);
  void emitAffineYield(AffineYieldOp op);

  /// Memref statement emitters.
  template <typename OpType> void emitAlloc(OpType op);
  void emitLoad(memref::LoadOp op);
  void emitStore(memref::StoreOp op);
  void emitDealloc(memref::DeallocOp op);
  void emitSubView(memref::SubViewOp op);
  void emitCastOp(memref::CastOp op);

  /// Standard expression emitters.
  void emitBinary(Operation *op, const char *syntax);
  void emitUnary(Operation *op, const char *syntax);
  void emitPower(Operation *op);
  void emitMaxMin(Operation *op, const char *syntax);

  /// Special expression emitters.
  void emitCall(func::CallOp op);
  void emitSelect(arith::SelectOp op);
  void emitConstant(arith::ConstantOp op);
  template <typename CastOpType> void emitCast(CastOpType op);
  
  /// ADFGrpah emitters
  void emitADFLaunchCell(adf::LaunchCellOp op);
  void emitADFEndLaunchCell(adf::EndLaunchCellOp op);
  void emitADFWaitLaunchCell(adf::WaitLaunchCellOp op);
  void emitADFPLIOConf(adf::ConfigPLIOOp op);
  void emitADFGMIOConf(adf::ConfigGMIOOp op);
  void emitADFBuffer(adf::BufferOp op);
  void emitADFDma(adf::DmaOp op);
  void emitADFConnect(adf::ConnectOp op);
  void emitADFIOPush(adf::IOPushOp op);
  void emitADFIOPop(adf::IOPopOp op);
  void emitADFIOWait(adf::IOWaitOp op);
  void emitADFIOWrite(adf::IOWriteOp op);
  void emitADFIORead(adf::IOReadOp op);
  void emitADFBuffLoc(adf::BuffLocOp op);
  void emitIntToAP(adf::IntToAPInt op);
  void emitAPToInt(adf::APIntToInt op);
  void emitGetBit(adf::GetIntBitOp op);
  void emitSetBit(adf::SetIntBitOp op);
  void emitGetSlice(adf::GetIntSliceOp op);
  void emitSetSlice(adf::SetIntSliceOp op);
  void emitBitReverse(adf::BitReverseOp op);
  void emitBitcast(arith::BitcastOp op);


  /// Top-level MLIR module emitter.
  void emitModule(ModuleOp module);
private:
  /// C++ component emitters.
  void emitValue(Value val, unsigned rank = 0, bool isPtr = false,
                 bool BIT_FLAG = false, std::string name = "");
  void emitArrayDecl(Value array, bool isFunc = false, std::string name = "");
  unsigned emitNestedLoopHead(Value val);
  void emitNestedLoopTail(unsigned rank);
  void emitInfoAndNewLine(Operation *op);

  /// MLIR component and ADF emitters.
  void emitBlock(Block &block);
  void emitArrayDirectives(Value memref);
  void emitLoopDirectives(Operation *op);
  void emitFunctionDirectives(func::FuncOp func, ArrayRef<Value> portList);
  void emitKernelHeader(FuncOp func);      // AIE kernel header definition
  void emitKernelFunc(FuncOp func);        // AIE kernel function
  void emitADFGraphFunction(FuncOp func);  // ADF graph for AIE array
  void emitADFMain(FuncOp func);           // AIE host if use GMIO
  void emitHLSFunction(func::FuncOp func); // Vitis HLS for PL
  void emitHostFunction(ModuleOp module, func::FuncOp func); // System host
  void emitConfig(ModuleOp module, func::FuncOp topFunc, func::FuncOp func);      
       // System config
};
}

//===----------------------------------------------------------------------===//
// AffineEmitter Class
//===----------------------------------------------------------------------===//

namespace {
class AffineExprEmitter : public ADFEmitterBase,
                          public AffineExprVisitor<AffineExprEmitter> {
public:
  using operand_range = Operation::operand_range;
  explicit AffineExprEmitter(ADFEmitterState &state, unsigned numDim,
                             operand_range operands)
      : ADFEmitterBase(state), numDim(numDim), operands(operands) {}

  void visitAddExpr(AffineBinaryOpExpr expr) { emitAffineBinary(expr, "+"); }
  void visitMulExpr(AffineBinaryOpExpr expr) { emitAffineBinary(expr, "*"); }
  void visitModExpr(AffineBinaryOpExpr expr) { emitAffineBinary(expr, "%"); }
  void visitFloorDivExpr(AffineBinaryOpExpr expr) {
    emitAffineBinary(expr, "/");
  }
  void visitCeilDivExpr(AffineBinaryOpExpr expr) {
    // This is super inefficient.
    os << "((";
    visit(expr.getLHS());
    os << " + ";
    visit(expr.getRHS());
    os << " - 1) / ";
    visit(expr.getRHS());
    os << ")";
  }

  void visitConstantExpr(AffineConstantExpr expr) { os << expr.getValue(); }

  void visitDimExpr(AffineDimExpr expr) {
    os << getName(operands[expr.getPosition()]);
  }
  void visitSymbolExpr(AffineSymbolExpr expr) {
    os << getName(operands[numDim + expr.getPosition()]);
  }

  /// Affine expression emitters.
  void emitAffineBinary(AffineBinaryOpExpr expr, const char *syntax) {
    os << "(";
    if (auto constRHS = dyn_cast<AffineConstantExpr>(expr.getRHS())) {
      if ((unsigned)*syntax == (unsigned)*"*" && constRHS.getValue() == -1) {
        os << "-";
        visit(expr.getLHS());
        os << ")";
        return;
      }
      if ((unsigned)*syntax == (unsigned)*"+" && constRHS.getValue() < 0) {
        visit(expr.getLHS());
        os << " - ";
        os << -constRHS.getValue();
        os << ")";
        return;
      }
    }
    if (auto binaryRHS = dyn_cast<AffineBinaryOpExpr>(expr.getRHS())) {
      if (auto constRHS = dyn_cast<AffineConstantExpr>(binaryRHS.getRHS())) {
        if ((unsigned)*syntax == (unsigned)*"+" && constRHS.getValue() == -1 &&
            binaryRHS.getKind() == AffineExprKind::Mul) {
          visit(expr.getLHS());
          os << " - ";
          visit(binaryRHS.getLHS());
          os << ")";
          return;
        }
      }
    }
    visit(expr.getLHS());
    os << " " << syntax << " ";
    visit(expr.getRHS());
    os << ")";
  }

  void emitAffineExpr(AffineExpr expr) { visit(expr); }

private:
  unsigned numDim;
  operand_range operands;
};
} // namespace

namespace {
class StmtVisitor : public ADFVisitorBase<StmtVisitor, bool> {
public:
  StmtVisitor(ModuleEmitter &emitter) : emitter(emitter) {}
  using ADFVisitorBase::visitOp;
  
  /// ADF statements
  bool visitOp(adf::GraphOp op) { return true; };
  bool visitOp(adf::GraphReturnOp op) { return true; };
  bool visitOp(adf::CellOp op) { return true; };
  bool visitOp(adf::EndCellOp op) { return true; };
  bool visitOp(adf::LaunchCellOp op) { 
    return emitter.emitADFLaunchCell(op), true;
  };
  bool visitOp(adf::EndLaunchCellOp op) { 
    return emitter.emitADFEndLaunchCell(op), true;
  };
  bool visitOp(adf::WaitLaunchCellOp op) { 
    return emitter.emitADFWaitLaunchCell(op),true;
  };
  bool visitOp(adf::KernelOp op) { return true; };
  bool visitOp(adf::CreateGraphIOOp op) { return true; };
  bool visitOp(adf::ConfigPLIOOp op) { 
    return emitter.emitADFPLIOConf(op), true;
  };
  bool visitOp(adf::ConfigGMIOOp op) { 
    return emitter.emitADFGMIOConf(op), true; 
  };
  bool visitOp(adf::BufferOp op) { return emitter.emitADFBuffer(op), true; };
  bool visitOp(adf::StreamOp op) { return true; };
  bool visitOp(adf::CascadeOp op) { return true; };
  bool visitOp(adf::CreateKernelIOOp op) { return true; };
  bool visitOp(adf::DmaOp op) { return emitter.emitADFDma(op), true; };
  bool visitOp(adf::ConnectOp op) { return emitter.emitADFConnect(op), true; };
  bool visitOp(adf::IOPushOp op) { return emitter.emitADFIOPush(op), true; };
  bool visitOp(adf::IOPopOp op) { return emitter.emitADFIOPop(op), true; };
  bool visitOp(adf::IOWaitOp op) { return emitter.emitADFIOWait(op), true; };
  bool visitOp(adf::IOWriteOp op) { return emitter.emitADFIOWrite(op), true;};
  bool visitOp(adf::IOReadOp op) { return emitter.emitADFIORead(op), true; };
  bool visitOp(adf::BuffLocOp op) { return emitter.emitADFBuffLoc(op), true; };
  bool visitOp(adf::IntToAPInt op) { return emitter.emitIntToAP(op), true; };
  bool visitOp(adf::APIntToInt op) { return emitter.emitAPToInt(op), true; };
  bool visitOp(arith::BitcastOp op) { return emitter.emitBitcast(op), true; };

  /// Function operations.
  bool visitOp(func::CallOp op) { return emitter.emitCall(op), true; }
  bool visitOp(func::ReturnOp op) { return true; }

  /// SCF statements.
  bool visitOp(scf::ForOp op) { return emitter.emitScfFor(op), true; };
  bool visitOp(scf::IfOp op) { return emitter.emitScfIf(op), true; };
  bool visitOp(scf::ParallelOp op) { return true; };
  bool visitOp(scf::ReduceOp op) { return true; };
  bool visitOp(scf::ReduceReturnOp op) { return true; };
  bool visitOp(scf::YieldOp op) { return emitter.emitScfYield(op), true; };

  /// Affine statements.
  bool visitOp(AffineForOp op) { return emitter.emitAffineFor(op), true; }
  bool visitOp(AffineIfOp op) { return emitter.emitAffineIf(op), true; }
  bool visitOp(AffineParallelOp op) {
    return emitter.emitAffineParallel(op), true;
  }
  bool visitOp(AffineApplyOp op) { return emitter.emitAffineApply(op), true; }
  bool visitOp(AffineMaxOp op) {
    return emitter.emitAffineMaxMin<AffineMaxOp>(op, "max"), true;
  }
  bool visitOp(AffineMinOp op) {
    return emitter.emitAffineMaxMin<AffineMinOp>(op, "min"), true;
  }
  bool visitOp(AffineLoadOp op) { return emitter.emitAffineLoad(op), true; }
  bool visitOp(AffineStoreOp op) { return emitter.emitAffineStore(op), true; }
  bool visitOp(AffineYieldOp op) { return emitter.emitAffineYield(op), true; }

  /// Memref statements.
  bool visitOp(memref::AllocOp op) { return emitter.emitAlloc(op), true; }
  bool visitOp(memref::AllocaOp op) { return emitter.emitAlloc(op), true; }
  bool visitOp(memref::LoadOp op) { return emitter.emitLoad(op), true; }
  bool visitOp(memref::StoreOp op) { return emitter.emitStore(op), true; }
  bool visitOp(memref::DeallocOp op) { return emitter.emitDealloc(op), true; }
  bool visitOp(memref::SubViewOp op) { return emitter.emitSubView(op), true; }
  bool visitOp(memref::CastOp op) { return true; }

private:
  ModuleEmitter &emitter;
};
}

namespace {
class ExprVisitor : public ADFVisitorBase<ExprVisitor, bool> {
public:
  ExprVisitor(ModuleEmitter &emitter) : emitter(emitter) {}

  using ADFVisitorBase::visitOp;
  /// Float binary expressions.
  bool visitOp(arith::CmpFOp op);
  bool visitOp(arith::AddFOp op) { return emitter.emitBinary(op, "+"), true; }
  bool visitOp(arith::SubFOp op) { return emitter.emitBinary(op, "-"), true; }
  bool visitOp(arith::MulFOp op) { return emitter.emitBinary(op, "*"), true; }
  bool visitOp(arith::DivFOp op) { return emitter.emitBinary(op, "/"), true; }
  bool visitOp(arith::RemFOp op) { return emitter.emitBinary(op, "%"), true; }

  /// Integer binary expressions.
  bool visitOp(arith::CmpIOp op);
  bool visitOp(arith::AddIOp op) { return emitter.emitBinary(op, "+"), true; }
  bool visitOp(arith::SubIOp op) { return emitter.emitBinary(op, "-"), true; }
  bool visitOp(arith::MulIOp op) { return emitter.emitBinary(op, "*"), true; }
  bool visitOp(arith::DivSIOp op) { return emitter.emitBinary(op, "/"), true; }
  bool visitOp(arith::RemSIOp op) { return emitter.emitBinary(op, "%"), true; }
  bool visitOp(arith::DivUIOp op) { return emitter.emitBinary(op, "/"), true; }
  bool visitOp(arith::RemUIOp op) { return emitter.emitBinary(op, "%"), true; }
  bool visitOp(arith::MaxSIOp op) {
    return emitter.emitMaxMin(op, "max"), true;
  }
  bool visitOp(arith::MinSIOp op) {
    return emitter.emitMaxMin(op, "min"), true;
  }
  bool visitOp(arith::MaxUIOp op) {
    return emitter.emitMaxMin(op, "max"), true;
  }
  bool visitOp(arith::MinUIOp op) {
    return emitter.emitMaxMin(op, "min"), true;
  }

  /// Logical expressions.
  bool visitOp(arith::XOrIOp op) { return emitter.emitBinary(op, "^"), true; }
  bool visitOp(arith::AndIOp op) { return emitter.emitBinary(op, "&"), true; }
  bool visitOp(arith::OrIOp op) { return emitter.emitBinary(op, "|"), true; }
  bool visitOp(arith::ShLIOp op) { return emitter.emitBinary(op, "<<"), true; }
  bool visitOp(arith::ShRSIOp op) { return emitter.emitBinary(op, ">>"), true; }
  bool visitOp(arith::ShRUIOp op) { return emitter.emitBinary(op, ">>"), true; }
  bool visitOp(adf::GetIntBitOp op) { return emitter.emitGetBit(op), true; }
  bool visitOp(adf::SetIntBitOp op) { return emitter.emitSetBit(op), true; }
  bool visitOp(adf::GetIntSliceOp op) { return emitter.emitGetSlice(op), true; }
  bool visitOp(adf::SetIntSliceOp op) { return emitter.emitSetSlice(op), true; }
  bool visitOp(adf::BitReverseOp op) {
    return emitter.emitBitReverse(op), true;
  }

  /// Unary expressions.
  bool visitOp(math::AbsFOp op) { return emitter.emitUnary(op, "abs"), true; }
  bool visitOp(math::AbsIOp op) { return emitter.emitUnary(op, "abs"), true; }
  bool visitOp(math::CeilOp op) { return emitter.emitUnary(op, "ceil"), true; }
  bool visitOp(math::CosOp op) { return emitter.emitUnary(op, "cos"), true; }
  bool visitOp(math::SinOp op) { return emitter.emitUnary(op, "sin"), true; }
  bool visitOp(math::TanhOp op) { return emitter.emitUnary(op, "tanh"), true; }
  bool visitOp(math::SqrtOp op) { return emitter.emitUnary(op, "sqrt"), true; }
  bool visitOp(math::RsqrtOp op) {
    return emitter.emitUnary(op, "1.0 / sqrt"), true;
  }
  bool visitOp(math::ExpOp op) { return emitter.emitUnary(op, "exp"), true; }
  bool visitOp(math::Exp2Op op) { return emitter.emitUnary(op, "exp2"), true; }
  bool visitOp(math::PowFOp op) { return emitter.emitPower(op), true; }
  bool visitOp(math::LogOp op) { return emitter.emitUnary(op, "log"), true; }
  bool visitOp(math::Log2Op op) { return emitter.emitUnary(op, "log2"), true; }
  bool visitOp(math::Log10Op op) {
    return emitter.emitUnary(op, "log10"), true;
  }
  bool visitOp(arith::NegFOp op) { return emitter.emitUnary(op, "-"), true; }

  /// Special operations.
  bool visitOp(arith::SelectOp op) { return emitter.emitSelect(op), true; }
  bool visitOp(arith::ConstantOp op) { return emitter.emitConstant(op), true; }
  bool visitOp(arith::IndexCastOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::UIToFPOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::SIToFPOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::FPToUIOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::FPToSIOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::TruncIOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::TruncFOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::ExtUIOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::ExtSIOp op) { return emitter.emitCast(op), true; }
  bool visitOp(arith::ExtFOp op) { return emitter.emitCast(op), true; }

private:
  ModuleEmitter &emitter;
};
} // namespace

bool ExprVisitor::visitOp(arith::CmpFOp op) {
  switch (op.getPredicate()) {
  case arith::CmpFPredicate::OEQ:
  case arith::CmpFPredicate::UEQ:
    return emitter.emitBinary(op, "=="), true;
  case arith::CmpFPredicate::ONE:
  case arith::CmpFPredicate::UNE:
    return emitter.emitBinary(op, "!="), true;
  case arith::CmpFPredicate::OLT:
  case arith::CmpFPredicate::ULT:
    return emitter.emitBinary(op, "<"), true;
  case arith::CmpFPredicate::OLE:
  case arith::CmpFPredicate::ULE:
    return emitter.emitBinary(op, "<="), true;
  case arith::CmpFPredicate::OGT:
  case arith::CmpFPredicate::UGT:
    return emitter.emitBinary(op, ">"), true;
  case arith::CmpFPredicate::OGE:
  case arith::CmpFPredicate::UGE:
    return emitter.emitBinary(op, ">="), true;
  default:
    op.emitError("has unsupported compare type.");
    return false;
  }
}

bool ExprVisitor::visitOp(arith::CmpIOp op) {
  switch (op.getPredicate()) {
  case arith::CmpIPredicate::eq:
    return emitter.emitBinary(op, "=="), true;
  case arith::CmpIPredicate::ne:
    return emitter.emitBinary(op, "!="), true;
  case arith::CmpIPredicate::slt:
  case arith::CmpIPredicate::ult:
    return emitter.emitBinary(op, "<"), true;
  case arith::CmpIPredicate::sle:
  case arith::CmpIPredicate::ule:
    return emitter.emitBinary(op, "<="), true;
  case arith::CmpIPredicate::sgt:
  case arith::CmpIPredicate::ugt:
    return emitter.emitBinary(op, ">"), true;
  case arith::CmpIPredicate::sge:
  case arith::CmpIPredicate::uge:
    return emitter.emitBinary(op, ">="), true;
  }
  assert(false && "unsupported compare type");
  return false;
}

//===----------------------------------------------------------------------===//
// ModuleEmitter Class Definition
//===----------------------------------------------------------------------===//

void ModuleEmitter::emitADFLaunchCell(adf::LaunchCellOp op){
  indent();
  op.walk([&](CallOp call){
    if(call->hasAttr("adf.cell")){
      os << getCall(call) << ".init();\n";
    }
  });
  emitBlock(op.getBody().front());
}

void ModuleEmitter::emitADFEndLaunchCell(adf::EndLaunchCellOp op){
  indent();
  auto launchop = op.getParentOp<LaunchCellOp>();
  launchop.walk([&](CallOp call){
    if(call->hasAttr("adf.cell")){
      os << getCall(call) << ".end();\n";
    }
  });
}

void ModuleEmitter::emitADFWaitLaunchCell(adf::WaitLaunchCellOp op){
  indent();
  auto launchop = op->getParentOfType<LaunchCellOp>();
  auto calleeName = launchop.getCallee();
  auto *parentBlock = op->getBlock();
  for(auto callop : parentBlock->getOps<CallOp>()){
    auto callee = callop.getCallee();
    if(callee == calleeName){
      os << getCall(callop) << ".wait();\n";
      return;
    }
  }
  op->emitError("Could not find corresponding CallOp");
}

void ModuleEmitter::emitADFPLIOConf(adf::ConfigPLIOOp op){
  auto plio = op.getPlio();
  auto IOType = getTypeName(plio);
  auto width = (int)plio.getType().getWidth();
  auto freq = op.getFrequency();
  auto VName = getName(plio);
  std::string portName ="";
  portName = plio.getType().getMnemonic().str();
  indent();
  std::string portSetting = portName + "_" + std::to_string(width) + "_bits";
  os << VName << " = " << IOType << "::create(\"" << VName << "\", " << 
  portSetting << ", \"data/" << VName << ".txt\", " << freq <<");\n" ;
  if(op->hasAttr("col, chl")){
    auto IOPlaceAttr = dyn_cast<ArrayAttr>(op->getAttr("col, chl"));
    auto colAttr = IOPlaceAttr[0];
    auto chlAttr = IOPlaceAttr[1];
    auto intColAttr = dyn_cast<IntegerAttr>(colAttr);
    auto intChlAttr = dyn_cast<IntegerAttr>(chlAttr);
    int ioCol = intColAttr.getInt();
    int ioChl = intChlAttr.getInt();
    indent();
    os << "adf::location<PLIO>(" << VName << ") = shim(" << ioCol << ", " 
       << ioChl  << ");\n";
  }
}

void ModuleEmitter::emitADFGMIOConf(adf::ConfigGMIOOp op){
  auto gmio = op.getGmio();
  auto IOType = getTypeName(gmio);
  auto burst = (int)op.getBurst();
  auto bandwith = op.getBandwidth();
  auto VName = getName(gmio);
  std::string portName ="";
  indent();
  os << VName << " = " << IOType << "::create(\"" << VName << "\", " 
  << burst << ", " << bandwith <<");\n" ;
}

void ModuleEmitter::emitADFBuffer(adf::BufferOp op) {
  auto buffer = op.getResult();
  if(!isDeclared(buffer)){
    for (auto user: buffer.getUsers()){
      if(auto call = dyn_cast<func::CallOp>(user)){
        if(call->hasAttr("adf.kernel")){
          auto KName = getCall(call).str().str();
          for(unsigned i=0; i<call.getNumOperands(); i++){
            if(buffer == call.getOperand(i)){
              auto VName = KName + std::string(".in[") 
                                 + std::to_string(i) + std::string("]");
              addName(buffer, false, VName);
              return;
            }
          }
        }
      }
    }
  }
}

void ModuleEmitter::emitADFDma(adf::DmaOp op) {
  auto src = dyn_cast<MemRefType>(op.getSrc().getType());
  auto dst = dyn_cast<MemRefType>(op.getDst().getType());
  auto dst_rank = dst.getRank();

  for (unsigned i=0; i<dst_rank; i++){
    indent();
    addIndent();
    auto iterVar = "iv" + std::to_string(i);
    auto ubSrc = src.getDimSize(i);
    auto ubDst = dst.getDimSize(i);
    auto ub = std::min(ubSrc,ubDst);
    os << "for (unsigned " << iterVar << "=0; " << iterVar << "<" << ub 
       << "; "  << iterVar << "++){\n";
    
  }

  SmallString<16> src_access;
  SmallString<16> dst_access;

  if(op->hasAttr("in")){
    src_access = getDMAAccess(op, dst_rank, true, true);
    dst_access = getDMAAccess(op, dst_rank, false, true);
  }else if(op->hasAttr("out")){
    src_access = getDMAAccess(op, dst_rank, true, false);
    dst_access = getDMAAccess(op, dst_rank, false, false);
  }else{
    op->emitError("Unsupport to emit: DMA op without direction.");
  }
  indent();
  os << getName(op.getDst()) << dst_access << " = "
     << getName(op.getSrc()) << src_access << ";\n";

  for (unsigned i=0; i<dst_rank; i++){
    reduceIndent();
    indent();
    os << "}\n";
  }
}

void ModuleEmitter::emitADFConnect(adf::ConnectOp op) {
  indent();
  auto src = op.getSrc();
  auto dst = op.getDst();
  auto srcName = getName(src);
  auto dstName = getName(dst);
  auto srcType = src.getType();
  auto dstType = dst.getType();
  if (dyn_cast<PLIOType>(srcType) || dyn_cast<GMIOType>(srcType) ||
      dyn_cast<PortType>(srcType))
      srcName += ".out[0]";
  if (dyn_cast<PLIOType>(dstType) || dyn_cast<GMIOType>(dstType) ||
      dyn_cast<PortType>(dstType))
      dstName += ".in[0]";
  os << "adf::connect<>(" << srcName << ", " << dstName << ");\n";
}

void ModuleEmitter::emitADFIOPush(adf::IOPushOp op) {
  indent();
  auto src = op.getSrc();
  auto dst = op.getDst();
  CallOp call;
  auto memref = dyn_cast<MemRefType>(src.getType());
  auto gmio = getCalleeArg(dst, call);
  os << getCall(call) << "." << getName(gmio) << ".gm2aie_nb(" 
  << getName(src) << ", " << memref.getNumElements() << "*sizeof(" 
  << getTypeName(memref) << "));\n";
}

void ModuleEmitter::emitADFIOPop(adf::IOPopOp op) {
  indent();
  auto src = op.getSrc();
  auto dst = op.getDst();
  CallOp call;
  auto gmio = getCalleeArg(src, call);
  auto memref = dyn_cast<MemRefType>(dst.getType());
  os << getCall(call) << "." << getName(gmio) << ".aie2gm_nb(" 
  << getName(dst) << ", " << memref.getNumElements() << "*sizeof(" 
  << getTypeName(memref) << "));\n";
}

void ModuleEmitter::emitADFIOWait(adf::IOWaitOp op){
  indent();
  auto io = op.getGraphio();
  CallOp call;
  auto gmio = getCalleeArg(io, call);
  os << getCall(call) << "." << getName(gmio) << ".wait();\n";
}

void ModuleEmitter::emitADFIOWrite(adf::IOWriteOp op){
  indent();
  auto val = op.getSrc();
  auto stream = op.getDst();
  emitValue(stream);
  os << ".write(";
  emitValue(val);
  os << ");\n";
}

void ModuleEmitter::emitADFIORead(adf::IOReadOp op){
  indent();
  Value result = op.getResult();
  auto val = op.getSrc();
  emitValue(result);
  os << " = ";
  emitValue(val);
  os << ".read();\n";
}

void ModuleEmitter::emitADFBuffLoc(adf::BuffLocOp op){
  auto memref = op.getBuffer();
  auto col = op.getCol();
  auto row = op.getRow();
  auto offset0 = op.getOffset0();
  auto offset1 = op.getOffset1();
  int colInt=-1, rowInt=-1, offsetInt0=-1, offsetInt1=-1;
  if(auto constOp = col.getDefiningOp<arith::ConstantOp>()){
    auto attr = dyn_cast<IntegerAttr>(constOp.getValue());
    if(attr)
      colInt = attr.getInt();
  }
  if(auto constOp = row.getDefiningOp<arith::ConstantOp>()){
    auto attr = dyn_cast<IntegerAttr>(constOp.getValue());
    if(attr)
      rowInt = attr.getInt();
  }
  if(auto constOp = offset0.getDefiningOp<arith::ConstantOp>()){
    auto attr = dyn_cast<IntegerAttr>(constOp.getValue());
    if(attr)
      offsetInt0 = attr.getInt();
  }
  if(auto constOp = offset1.getDefiningOp<arith::ConstantOp>()){
    auto attr = dyn_cast<IntegerAttr>(constOp.getValue());
    if(attr)
      offsetInt1 = attr.getInt();
  }
  if(colInt < 0 || rowInt < 0 || offsetInt0 < 0 || offsetInt1 < 0)
    op.emitError("has negative operands.");
  indent();
  os << "location<buffer>(" << getName(memref) << ") =\n";
  indent();
  os << "{ address(" << colInt << ", " << rowInt << ", "
     << llvm::format_hex(offsetInt0, 6)  << "),\n";
  indent();
  os << "  address(" << colInt << ", " << rowInt << ", " 
     << llvm::format_hex(offsetInt1, 6)  << ")};";
  os << "\n";
}

void ModuleEmitter::emitIntToAP(adf::IntToAPInt op){
  indent();
  auto val = op.getInput();
  auto result = op.getResult();
  emitValue(result, /*rank=*/0, /*isPtr=*/false, /*BIT_FLAG=*/true);
  os << " = ";
  emitValue(val);
  os << ";\n";
}

void ModuleEmitter::emitAPToInt(adf::APIntToInt op){
  indent();
  auto val = op.getInput();
  auto result = op.getResult();
  emitValue(result);
  os << " = ";
  emitValue(val);
  os << ";\n";
}

void ModuleEmitter::emitBitcast(arith::BitcastOp op) {
  indent();
  emitValue(op.getResult());
  os << ";\n";
  indent();
  os << "union { ";
  os << getTypeName(op.getOperand());
  os << " from; ";
  os << getTypeName(op.getResult());
  os << " to;} ";
  auto name = SmallString<32>("_converter_") + getName(op.getOperand()) +
              SmallString<32>("_to_") + getName(op.getResult());
  os << name << ";\n";
  indent();
  os << name << ".from";
  os << " = ";
  emitValue(op.getOperand());
  os << ";\n";
  indent();
  emitValue(op.getResult());
  os << " = ";
  os << name << ".to;";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitCall(func::CallOp op) {
  if(op->hasAttr("adf.kernel")){
    return;
  }else if(op->hasAttr("adf.cell")){
    indent();
    os << getCall(op) << ".run(1);\n" ;
    return;
  }
  // Handle returned value by the callee.
  for (auto result : op.getResults()) {
    if (!isDeclared(result)) {
      indent();
      if (isa<ShapedType>(result.getType()))
        emitArrayDecl(result);
      else
        emitValue(result);
      os << ";\n";
    }
  }

  // Emit the function call.
  indent();
  os << op.getCallee(); 
  
  if(auto attr = op->getAttr("template"))
    if(auto intAttr = dyn_cast<IntegerAttr>(attr))
      os << "<" << intAttr.getInt() << ">";

  os << "(";

  // Handle input arguments.
  unsigned argIdx = 0;
  for (auto arg : op.getOperands()) {
    emitValue(arg);

    if (argIdx++ != op.getNumOperands() - 1)
      os << ", ";
  }

  // Handle output arguments.
  for (auto result : op.getResults()) {
    // The address should be passed in for scalar result arguments.
    if (isa<ShapedType>(result.getType()))
      os << ", ";
    else
      os << ", &";

    emitValue(result);
  }

  os << ");";
  emitInfoAndNewLine(op);
}

/// SCF statement emitters.
void ModuleEmitter::emitScfFor(scf::ForOp op) {
  indent();
  os << "for (";
  auto iterVar = op.getInductionVar();

  // Emit lower bound.
  emitValue(iterVar);
  os << " = ";
  emitValue(op.getLowerBound());
  os << "; ";

  // Emit upper bound.
  emitValue(iterVar);
  os << " < ";
  emitValue(op.getUpperBound());
  os << "; ";

  // Emit increase step.
  emitValue(iterVar);
  os << " += ";
  emitValue(op.getStep());
  os << ") {";
  emitInfoAndNewLine(op);

  addIndent();

  emitLoopDirectives(op);
  emitBlock(*op.getBody());
  reduceIndent();

  indent();
  os << "}\n";
}

void ModuleEmitter::emitScfIf(scf::IfOp op) {
  // Declare all values returned by scf::YieldOp. They will be further handled
  // by the scf::YieldOp emitter.
  for (auto result : op.getResults()) {
    if (!isDeclared(result)) {
      indent();
      if (isa<ShapedType>(result.getType()))
        emitArrayDecl(result);
      else
        emitValue(result);
      os << ";\n";
    }
  }

  indent();
  os << "if (";
  emitValue(op.getCondition());
  os << ") {";
  emitInfoAndNewLine(op);

  addIndent();
  emitBlock(op.getThenRegion().front());
  reduceIndent();

  if (!op.getElseRegion().empty()) {
    indent();
    os << "} else {\n";
    addIndent();
    emitBlock(op.getElseRegion().front());
    reduceIndent();
  }

  indent();
  os << "}\n";
}

void ModuleEmitter::emitScfYield(scf::YieldOp op) {
  if (op.getNumOperands() == 0)
    return;

  // For now, only and scf::If operations will use scf::Yield to return
  // generated values.
  if (auto parentOp = dyn_cast<scf::IfOp>(op->getParentOp())) {
    unsigned resultIdx = 0;
    for (auto result : parentOp.getResults()) {
      unsigned rank = emitNestedLoopHead(result);
      indent();
      emitValue(result, rank);
      os << " = ";
      emitValue(op.getOperand(resultIdx++), rank);
      os << ";";
      emitInfoAndNewLine(op);
      emitNestedLoopTail(rank);
    }
  }
}

/// Affine statement emitters.
void ModuleEmitter::emitAffineFor(AffineForOp op) {
  indent();
  auto iterVar = op.getInductionVar();
  std::string loop_name = "";
  if (op->hasAttr("loop_name")) { // loop label
    loop_name = dyn_cast<StringAttr>(op->getAttr("loop_name")).getValue().str();
    std::replace(loop_name.begin(), loop_name.end(), '.', '_');
    os << "l_";
    if (op->hasAttr("op_name")) {
      std::string op_name =
          dyn_cast<StringAttr>(op->getAttr("op_name")).getValue().str();
      std::replace(op_name.begin(), op_name.end(), '.', '_');
      os << op_name << "_";
    }
    os << addName(iterVar, false, loop_name);
    os << ": ";
  }
  os << "for (";

  // Emit lower bound.
  if (op->hasAttr("loop_name")) {
    os << getTypeName(iterVar) << " ";
  }
  emitValue(iterVar, 0, false, false, loop_name);
  os << " = ";
  auto lowerMap = op.getLowerBoundMap();
  AffineExprEmitter lowerEmitter(state, lowerMap.getNumDims(),
                                 op.getLowerBoundOperands());
  if (lowerMap.getNumResults() == 1)
    lowerEmitter.emitAffineExpr(lowerMap.getResult(0));
  else {
    for (unsigned i = 0, e = lowerMap.getNumResults() - 1; i < e; ++i)
      os << "max(";
    lowerEmitter.emitAffineExpr(lowerMap.getResult(0));
    for (auto &expr : llvm::drop_begin(lowerMap.getResults(), 1)) {
      os << ", ";
      lowerEmitter.emitAffineExpr(expr);
      os << ")";
    }
  }
  os << "; ";

  // Emit upper bound.
  emitValue(iterVar, 0, false, false, loop_name);
  os << " < ";
  auto upperMap = op.getUpperBoundMap();
  AffineExprEmitter upperEmitter(state, upperMap.getNumDims(),
                                 op.getUpperBoundOperands());
  if (upperMap.getNumResults() == 1)
    upperEmitter.emitAffineExpr(upperMap.getResult(0));
  else {
    for (unsigned i = 0, e = upperMap.getNumResults() - 1; i < e; ++i)
      os << "min(";
    upperEmitter.emitAffineExpr(upperMap.getResult(0));
    for (auto &expr : llvm::drop_begin(upperMap.getResults(), 1)) {
      os << ", ";
      upperEmitter.emitAffineExpr(expr);
      os << ")";
    }
  }
  os << "; ";

  // Emit increase step.
  emitValue(iterVar, 0, false, false, loop_name);
  if (op.getStep() == 1)
    os << "++) {";
  else
    os << " += " << op.getStep() << ") {";
  emitInfoAndNewLine(op);

  addIndent();

  emitLoopDirectives(op);
  emitBlock(*op.getBody());
  reduceIndent();

  indent();
  os << "}\n";
}

void ModuleEmitter::emitAffineIf(AffineIfOp op) {
  // Declare all values returned by AffineYieldOp. They will be further
  // handled by the AffineYieldOp emitter.
  for (auto result : op.getResults()) {
    if (!isDeclared(result)) {
      indent();
      if (isa<ShapedType>(result.getType()))
        emitArrayDecl(result);
      else
        emitValue(result);
      os << ";\n";
    }
  }

  indent();
  os << "if (";
  auto constrSet = op.getIntegerSet();
  AffineExprEmitter constrEmitter(state, constrSet.getNumDims(),
                                  op.getOperands());

  // Emit all constraints.
  unsigned constrIdx = 0;
  for (auto &expr : constrSet.getConstraints()) {
    constrEmitter.emitAffineExpr(expr);
    if (constrSet.isEq(constrIdx))
      os << " == 0";
    else
      os << " >= 0";

    if (constrIdx++ != constrSet.getNumConstraints() - 1)
      os << " && ";
  }
  os << ") {";
  emitInfoAndNewLine(op);

  addIndent();
  emitBlock(*op.getThenBlock());
  reduceIndent();

  if (op.hasElse()) {
    indent();
    os << "} else {\n";
    addIndent();
    emitBlock(*op.getElseBlock());
    reduceIndent();
  }

  indent();
  os << "}\n";
}

void ModuleEmitter::emitAffineParallel(AffineParallelOp op) {
  // Declare all values returned by AffineParallelOp. They will be further
  // handled by the AffineYieldOp emitter.
  for (auto result : op.getResults()) {
    if (!isDeclared(result)) {
      indent();
      if (isa<ShapedType>(result.getType()))
        emitArrayDecl(result);
      else
        emitValue(result);
      os << ";\n";
    }
  }

  auto steps = getIntArrayAttrValue(op, op.getStepsAttrName());
  for (unsigned i = 0, e = op.getNumDims(); i < e; ++i) {
    indent();
    os << "for (";
    auto iterVar = op.getBody()->getArgument(i);

    // Emit lower bound.
    emitValue(iterVar);
    os << " = ";
    auto lowerMap = op.getLowerBoundsValueMap().getAffineMap();
    AffineExprEmitter lowerEmitter(state, lowerMap.getNumDims(),
                                   op.getLowerBoundsOperands());
    lowerEmitter.emitAffineExpr(lowerMap.getResult(i));
    os << "; ";

    // Emit upper bound.
    emitValue(iterVar);
    os << " < ";
    auto upperMap = op.getUpperBoundsValueMap().getAffineMap();
    AffineExprEmitter upperEmitter(state, upperMap.getNumDims(),
                                   op.getUpperBoundsOperands());
    upperEmitter.emitAffineExpr(upperMap.getResult(i));
    os << "; ";

    // Emit increase step.
    emitValue(iterVar);
    os << " += " << steps[i] << ") {";
    emitInfoAndNewLine(op);

    addIndent();
  }

  emitBlock(*op.getBody());

  for (unsigned i = 0, e = op.getNumDims(); i < e; ++i) {
    reduceIndent();

    indent();
    os << "}\n";
  }
}

void ModuleEmitter::emitAffineApply(AffineApplyOp op) {
  indent();
  emitValue(op.getResult());
  os << " = ";
  auto affineMap = op.getAffineMap();
  AffineExprEmitter(state, affineMap.getNumDims(), op.getOperands())
      .emitAffineExpr(affineMap.getResult(0));
  os << ";";
  emitInfoAndNewLine(op);
}

template <typename OpType>
void ModuleEmitter::emitAffineMaxMin(OpType op, const char *syntax) {
  indent();
  emitValue(op.getResult());
  os << " = ";
  auto affineMap = op.getAffineMap();
  AffineExprEmitter affineEmitter(state, affineMap.getNumDims(),
                                  op.getOperands());
  for (unsigned i = 0, e = affineMap.getNumResults() - 1; i < e; ++i)
    os << syntax << "(";
  affineEmitter.emitAffineExpr(affineMap.getResult(0));
  for (auto &expr : llvm::drop_begin(affineMap.getResults(), 1)) {
    os << ", ";
    affineEmitter.emitAffineExpr(expr);
    os << ")";
  }
  os << ";";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitAffineLoad(AffineLoadOp op) {
  Value result = op.getResult();
  fixUnsignedType(result, op->hasAttr("unsigned"));
  auto memref = op.getMemRef();
  auto affineMap = op.getAffineMap();
  AffineExprEmitter affineEmitter(state, affineMap.getNumDims(),
                                  op.getMapOperands());
  auto attr = dyn_cast<MemRefType>(memref.getType()).getMemorySpace();
  if (attr && dyn_cast<StringAttr>(attr)){
    auto stringAttr =  dyn_cast<StringAttr>(attr).getValue().str();
    if(stringAttr.substr(0, 6) == "stream"){
      indent();
      emitValue(result);
      os << " = ";
      emitValue(memref);
      os << ".read(); //";
      emitValue(memref, 0, false); // comment
    }else if(stringAttr.substr(0, 4) == "plio"){
      // TODO: Currently, print meta data. Maybe need to add operation.
      auto axiuName = getName(memref).str().str() + "_axiu";
      indent();
      os << getTypeName(memref) << " " << axiuName << " = " ;
      emitValue(memref);
      os << ".read();\n";
      indent();
      emitValue(result);
      os << " = " << axiuName << ".data; //";
      emitValue(memref, 0, false); // comment
    }
  }
  indent();
  emitValue(result);
  os << " = ";
  emitValue(memref);
  auto arrayType = dyn_cast<ShapedType>(memref.getType());
  if (arrayType.getShape().size() == 1 && arrayType.getShape()[0] == 1) {
    // do nothing;
  } else {
    for (auto index : affineMap.getResults()) {
      os << "[";
      affineEmitter.emitAffineExpr(index);
      os << "]";
    }
  }
  os << ";";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitAffineStore(AffineStoreOp op) {
  
  auto memref = op.getMemRef();
  auto affineMap = op.getAffineMap();
  AffineExprEmitter affineEmitter(state, affineMap.getNumDims(),
                                  op.getMapOperands());
  auto attr = dyn_cast<MemRefType>(memref.getType()).getMemorySpace();
  if (attr && dyn_cast<StringAttr>(attr)){
    auto stringAttr =  dyn_cast<StringAttr>(attr).getValue().str();
    if(stringAttr.substr(0, 6) == "stream"){
      indent();
      emitValue(memref);
      os << ".write(";
      emitValue(op.getValueToStore());
      os << "); //";
      emitValue(memref, 0, false); // comment
    }else if(stringAttr.substr(0, 4) == "plio"){
      // TODO: Currently, print meta data. Maybe need to add operation.
      auto axiuName = getName(memref).str().str() + "_axiu";
      indent();
      os << getTypeName(memref) << " " << axiuName <<";\n";
      indent();
      os << axiuName << ".data = ";
      emitValue(op.getValueToStore());
      os << ";\n";
      indent();
      os << axiuName << ".keep = -1;\n";
      indent();
      emitValue(memref);
      os << ".write(" << axiuName << "); //";
      emitValue(memref, 0, false); // comment
    }
  }
  indent();
  emitValue(memref);
  auto arrayType = dyn_cast<ShapedType>(memref.getType());
  if (arrayType.getShape().size() == 1 && arrayType.getShape()[0] == 1) {
    // do nothing;
  } else {
    for (auto index : affineMap.getResults()) {
      os << "[";
      affineEmitter.emitAffineExpr(index);
      os << "]";
    }
  }
  os << " = ";
  emitValue(op.getValueToStore());
  os << ";";
  emitInfoAndNewLine(op);
}

// TODO: For now, all values created in the AffineIf region will be declared
// in the generated C++. However, values which will be returned by affine
// yield operation should not be declared again. How to "bind" the pair of
// values inside/outside of AffineIf region needs to be considered.
void ModuleEmitter::emitAffineYield(AffineYieldOp op) {
  if (op.getNumOperands() == 0)
    return;

  // For now, only AffineParallel and AffineIf operations will use
  // AffineYield to return generated values.
  if (auto parentOp = dyn_cast<AffineIfOp>(op->getParentOp())) {
    unsigned resultIdx = 0;
    for (auto result : parentOp.getResults()) {
      unsigned rank = emitNestedLoopHead(result);
      indent();
      emitValue(result, rank);
      os << " = ";
      emitValue(op.getOperand(resultIdx++), rank);
      os << ";";
      emitInfoAndNewLine(op);
      emitNestedLoopTail(rank);
    }
  } else if (auto parentOp = dyn_cast<AffineParallelOp>(op->getParentOp())) {
    indent();
    os << "if (";
    unsigned ivIdx = 0;
    for (auto iv : parentOp.getBody()->getArguments()) {
      emitValue(iv);
      os << " == 0";
      if (ivIdx++ != parentOp.getBody()->getNumArguments() - 1)
        os << " && ";
    }
    os << ") {\n";

    // When all induction values are 0, generated values will be directly
    // assigned to the current results, correspondingly.
    addIndent();
    unsigned resultIdx = 0;
    for (auto result : parentOp.getResults()) {
      unsigned rank = emitNestedLoopHead(result);
      indent();
      emitValue(result, rank);
      os << " = ";
      emitValue(op.getOperand(resultIdx++), rank);
      os << ";";
      emitInfoAndNewLine(op);
      emitNestedLoopTail(rank);
    }
    reduceIndent();

    indent();
    os << "} else {\n";

    // Otherwise, generated values will be accumulated/reduced to the
    // current results with corresponding arith::AtomicRMWKind operations.
    addIndent();
    auto RMWAttrs =
        getIntArrayAttrValue(parentOp, parentOp.getReductionsAttrName());
    resultIdx = 0;
    for (auto result : parentOp.getResults()) {
      unsigned rank = emitNestedLoopHead(result);
      indent();
      emitValue(result, rank);
      switch ((arith::AtomicRMWKind)RMWAttrs[resultIdx]) {
      case (arith::AtomicRMWKind::addf):
      case (arith::AtomicRMWKind::addi):
        os << " += ";
        emitValue(op.getOperand(resultIdx++), rank);
        break;
      case (arith::AtomicRMWKind::assign):
        os << " = ";
        emitValue(op.getOperand(resultIdx++), rank);
        break;
      case (arith::AtomicRMWKind::maximumf):
      case (arith::AtomicRMWKind::maxs):
      case (arith::AtomicRMWKind::maxu):
      case (arith::AtomicRMWKind::maxnumf):
        os << " = max(";
        emitValue(result, rank);
        os << ", ";
        emitValue(op.getOperand(resultIdx++), rank);
        os << ")";
        break;
      case (arith::AtomicRMWKind::minimumf):
      case (arith::AtomicRMWKind::mins):
      case (arith::AtomicRMWKind::minu):
      case (arith::AtomicRMWKind::minnumf):
        os << " = min(";
        emitValue(result, rank);
        os << ", ";
        emitValue(op.getOperand(resultIdx++), rank);
        os << ")";
        break;
      case (arith::AtomicRMWKind::mulf):
      case (arith::AtomicRMWKind::muli):
        os << " *= ";
        emitValue(op.getOperand(resultIdx++), rank);
        break;
      case (arith::AtomicRMWKind::ori):
        os << " |= ";
        emitValue(op.getOperand(resultIdx++), rank);
        break;
      case (arith::AtomicRMWKind::andi):
        os << " &= ";
        emitValue(op.getOperand(resultIdx++), rank);
        break;
      }
      os << ";";
      emitInfoAndNewLine(op);
      emitNestedLoopTail(rank);
    }
    reduceIndent();

    indent();
    os << "}\n";
  }
}

/// Memref-related statement emitters.
template <typename OpType> void ModuleEmitter::emitAlloc(OpType op) {
  // A declared result indicates that the memref is output of the function, and
  // has been declared in the function signature.
  if (isDeclared(op.getResult()))
    return;

  // Vivado HLS only supports static shape on-chip memory.
  if (!op.getType().hasStaticShape())
    op->emitError("is unranked or has dynamic shape.");

  //If this a memory in the GMIO space
  if (op->hasAttr("gmio")) {
    indent();
    auto result = op.getResult(); // memref
    os << getTypeName(result) << "* ";
    os << addName(result) << "=(" << getTypeName(result) << "*) GMIO::malloc(";
    auto memref = dyn_cast<MemRefType>(result.getType());
    auto sizeBytes = memref.getElementType().getIntOrFloatBitWidth() / 8;
    os << memref.getNumElements()*sizeBytes << ");\n";
    return;
  }

  std::string name;
  if (op->hasAttr("name")) {
    auto attr = dyn_cast<StringAttr>(op->getAttr("name"));
    name = attr.getValue().str();
  }

  indent();
  Value result = op.getResult(); // memref
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitArrayDecl(result, false, name);
  os << ";";
  emitInfoAndNewLine(op);
  emitArrayDirectives(result);
}

void ModuleEmitter::emitLoad(memref::LoadOp op) {
  indent();
  Value result = op.getResult(); 
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result);
  os << " = ";
  emitValue(op.getMemRef());
  for (auto index : op.getIndices()) {
    os << "[";
    emitValue(index);
    os << "]";
  }
  os << ";";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitStore(memref::StoreOp op) {
  indent();
  emitValue(op.getMemRef());
  for (auto index : op.getIndices()) {
    os << "[";
    emitValue(index);
    os << "]";
  }
  os << " = ";
  emitValue(op.getValueToStore());
  os << ";";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitDealloc(memref::DeallocOp op){
  if(op->hasAttr("gmio")){
    indent();
    auto memref = op.getMemref();
    os << "GMIO::free(" << getName(memref) << ");\n";
  }
}

void ModuleEmitter::emitSubView(memref::SubViewOp op) {
  indent();
  emitArrayDecl(op.getResult(), true);
  os << " = ";
  emitValue(op.getSource());
  for (auto index : op.getOffsets()) {
    os << "[";
    emitValue(index);
    os << "]";
  }
  os << ";";
  emitInfoAndNewLine(op);
}

/// Standard expression emitters.
void ModuleEmitter::emitBinary(Operation *op, const char *syntax) {
  auto rank = emitNestedLoopHead(op->getResult(0));
  indent();
  Value result = op->getResult(0);
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result, rank);
  os << " = ";
  emitValue(op->getOperand(0), rank);
  os << " " << syntax << " ";
  emitValue(op->getOperand(1), rank);
  os << ";";
  emitInfoAndNewLine(op);
  emitNestedLoopTail(rank);
}

void ModuleEmitter::emitUnary(Operation *op, const char *syntax) {
  auto rank = emitNestedLoopHead(op->getResult(0));
  indent();
  Value result = op->getResult(0);
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result, rank);
  os << " = " << syntax << "(";
  emitValue(op->getOperand(0), rank);
  os << ");";
  emitInfoAndNewLine(op);
  emitNestedLoopTail(rank);
}

void ModuleEmitter::emitPower(Operation *op) {
  auto rank = emitNestedLoopHead(op->getResult(0));
  indent();
  emitValue(op->getResult(0), rank);
  os << " = pow(";
  emitValue(op->getOperand(0), rank);
  os << ", ";
  emitValue(op->getOperand(1), rank);
  os << ");";
  emitInfoAndNewLine(op);
  emitNestedLoopTail(rank);
}

/// Special operation emitters.
void ModuleEmitter::emitMaxMin(Operation *op, const char *syntax) {
  auto rank = emitNestedLoopHead(op->getResult(0));
  indent();
  Value result = op->getResult(0);
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result, rank);
  os << " = " << syntax << "(";
  emitValue(op->getOperand(0), rank);
  os << ", ";
  emitValue(op->getOperand(1), rank);
  os << ");";
  emitInfoAndNewLine(op);
  emitNestedLoopTail(rank);
}

void ModuleEmitter::emitGetBit(adf::GetIntBitOp op) {
  indent();
  Value result = op.getResult();
  fixUnsignedType(result, op->hasAttr("unsigned"));
  // generate ap_int types
  os << "ap_int<" << op.getNum().getType().getIntOrFloatBitWidth() << "> ";
  emitValue(op.getNum());
  os << "_tmp = ";
  emitValue(op.getNum());
  os << ";\n";
  // generate bit indexing
  indent();
  emitValue(result);
  os << " = ";
  emitValue(op.getNum());
  os << "_tmp[";
  emitValue(op.getIndex());
  os << "];";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitSetBit(adf::SetIntBitOp op) {
  indent();
  // generate ap_int types
  os << "ap_int<" << op.getNum().getType().getIntOrFloatBitWidth() << "> ";
  emitValue(op.getNum());
  os << "_tmp = ";
  emitValue(op.getNum());
  os << ";\n";
  // generate bit indexing
  indent();
  emitValue(op.getNum());
  os << "_tmp[";
  emitValue(op.getIndex());
  os << "] = ";
  emitValue(op.getVal());
  os << ";";
  // write back
  indent();
  emitValue(op.getResult());
  os << " = ";
  emitValue(op.getNum());
  os << "_tmp;";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitGetSlice(adf::GetIntSliceOp op) {
  indent();
  Value result = op.getResult();
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result);
  os << " = ";
  emitValue(op.getNum());
  os << "(";
  emitValue(op.getHi());
  os << ", ";
  emitValue(op.getLo());
  os << ");";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitSetSlice(adf::SetIntSliceOp op) {
  indent();
  emitValue(op.getNum());
  os << "(";
  emitValue(op.getHi());
  os << ", ";
  emitValue(op.getLo());
  os << ") = ";
  emitValue(op.getVal());
  os << ";";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitBitReverse(adf::BitReverseOp op) {
  indent();
  Value result = op.getResult();
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result);
  os << " = ";
  emitValue(op.getNum());
  os << ".reverse();";
  emitInfoAndNewLine(op);
}

void ModuleEmitter::emitSelect(arith::SelectOp op) {
  unsigned rank = emitNestedLoopHead(op.getResult());
  unsigned conditionRank = rank;
  if (!isa<ShapedType>(op.getCondition().getType()))
    conditionRank = 0;
  indent();
  Value result = op.getResult();
  fixUnsignedType(result, op->hasAttr("unsigned"));
  emitValue(result, rank);
  os << " = ";
  emitValue(op.getCondition(), conditionRank);
  os << " ? ";
  Value true_val = op.getTrueValue();
  fixUnsignedType(true_val, op->hasAttr("unsigned"));
  os << "(" << getTypeName(true_val) << ")";
  emitValue(true_val, rank);
  os << " : ";
  Value false_val = op.getFalseValue();
  fixUnsignedType(false_val, op->hasAttr("unsigned"));
  os << "(" << getTypeName(false_val) << ")";
  emitValue(false_val, rank);
  os << ";";
  emitInfoAndNewLine(op);
  emitNestedLoopTail(rank);
}

void ModuleEmitter::emitConstant(arith::ConstantOp op) {
  // This indicates the constant type is scalar (float, integer, or bool).
  if (isDeclared(op.getResult()))
    return;

  if (auto denseAttr = dyn_cast<DenseElementsAttr>(op.getValue())) {
    indent();
    Value result = op.getResult(); // memref
    fixUnsignedType(result, op->hasAttr("unsigned"));
    emitArrayDecl(result);
    os << " = {";
    auto type = dyn_cast<ShapedType>(op.getResult().getType()).getElementType();

    unsigned elementIdx = 0;
    for (auto element : denseAttr.getValues<Attribute>()) {
      if (type.isF32()) {
        auto value = dyn_cast<FloatAttr>(element).getValue().convertToFloat();
        if (std::isfinite(value))
          os << value;
        else if (value > 0)
          os << "INFINITY";
        else
          os << "-INFINITY";

      } else if (type.isF64()) {
        auto value = dyn_cast<FloatAttr>(element).getValue().convertToDouble();
        if (std::isfinite(value))
          os << value;
        else if (value > 0)
          os << "INFINITY";
        else
          os << "-INFINITY";

      } else if (type.isInteger(1))
        os << dyn_cast<BoolAttr>(element).getValue();
      else if (type.isIntOrIndex())
        os << dyn_cast<IntegerAttr>(element).getValue();
      else
        op->emitError("array has unsupported element type.");

      if (elementIdx++ != denseAttr.getNumElements() - 1)
        os << ", ";
    }
    os << "};";
    emitInfoAndNewLine(op);
  } else
    op->emitError("has unsupported constant type.");
}

template <typename CastOpType> void ModuleEmitter::emitCast(CastOpType op) {
  indent();
  emitValue(op.getResult());
  os << " = ";
  emitValue(op.getOperand());
  os << ";";
  emitInfoAndNewLine(op);
}

/// C++ component emitters.
void ModuleEmitter::emitValue(Value val, unsigned rank, bool isPtr, 
                              bool BIT_FLAG, std::string name) {
  assert(!(rank && isPtr) && "should be either an array or a pointer.");

  // Value has been declared before or is a constant number.
  if (isDeclared(val)) {
    os << getName(val);
    for (unsigned i = 0; i < rank; ++i)
      os << "[iv" << i << "]";
    return;
  }

  os << getTypeName(val, isPtr, BIT_FLAG) << " ";

  if (name == "") {
    // Add the new value to nameTable and emit its name.
    os << addName(val, isPtr);
    for (unsigned i = 0; i < rank; ++i)
      os << "[iv" << i << "]";
  } else {
    os << addName(val, isPtr, name);
  }
}

void ModuleEmitter::emitArrayDecl(Value array, bool isFunc, std::string name) {
  assert(!isDeclared(array) && "has been declared before.");

  auto arrayType = dyn_cast<ShapedType>(array.getType());
  if (arrayType && arrayType.hasStaticShape()) {
    auto memref = dyn_cast<MemRefType>(array.getType());
    if (memref) {
      auto attr = memref.getMemorySpace();
      if (attr && dyn_cast<StringAttr>(attr) &&
          (dyn_cast<StringAttr>(attr).getValue().str().substr(0, 6) == "stream"||
           dyn_cast<StringAttr>(attr).getValue().str().substr(0, 4) == "plio")){
        // Value has been declared before or is a constant number.
        if (isDeclared(array)) {
          os << getName(array);
          return;
        }

        // print stream type
        os << "hls::stream< " << getTypeName(array) << " > ";
        if (isFunc)
          os << "&"; // pass by reference, only non-array needs reference

        // Add the new value to nameTable and emit its name.
        os << addName(array, /*isPtr=*/false, name);
        
        // Add original array declaration as comment
        os << " /* ";
        emitValue(array, 0, false, false, name);
        for (auto &shape : arrayType.getShape())
          os << "[" << shape << "]";
        os << " */";
      } else {
        emitValue(array, 0, false, false, name);
        if (arrayType.getShape().size() == 1 && arrayType.getShape()[0] == 1) {
          // do nothing;
        } else {
          for (auto &shape : arrayType.getShape())
            os << "[" << shape << "]";
        }
      }
    } else { // tensor
      emitValue(array, 0, false, false, name);
    }
  } else
    emitValue(array, /*rank=*/0, /*isPtr=*/true, false, name);
}

unsigned ModuleEmitter::emitNestedLoopHead(Value val) {
  unsigned rank = 0;

  if (auto type = dyn_cast<ShapedType>(val.getType())) {
    if (!type.hasStaticShape()) {
      val.getDefiningOp()->emitError("is unranked or has dynamic shape.");
      return 0;
    }

    // Declare a new array.
    if (!isDeclared(val)) {
      indent();
      emitArrayDecl(val);
      os << ";\n";
    }

    // Create nested loop.
    unsigned dimIdx = 0;
    for (auto &shape : type.getShape()) {
      indent();
      os << "for (int iv" << dimIdx << " = 0; ";
      os << "iv" << dimIdx << " < " << shape << "; ";
      os << "++iv" << dimIdx++ << ") {\n";

      addIndent();
    }
    rank = type.getRank();
  }

  return rank;
}

void ModuleEmitter::emitNestedLoopTail(unsigned rank) {
  for (unsigned i = 0; i < rank; ++i) {
    reduceIndent();

    indent();
    os << "}\n";
  }
}

void ModuleEmitter::emitInfoAndNewLine(Operation *op) {
  os << "\t//";
  // Print line number.
  if (auto loc = dyn_cast<FileLineColLoc>(op->getLoc()))
    os << " L" << loc.getLine();

  os << "\n";
}

/// MLIR component and HLS C++ pragma emitters.
void ModuleEmitter::emitBlock(Block &block) {
  for (auto &op : block) {
    if (ExprVisitor(*this).dispatchVisitor(&op))
      continue;

    if (StmtVisitor(*this).dispatchVisitor(&op))
      continue;

    op.emitError("can't be correctly emitted.");
  }
}

void ModuleEmitter::emitADFMain(FuncOp func){
    std::string adf_cpp_header = R"XXX(
//_aries_split_//adf_graph.cpp//_aries_split_//
//===----------------------------------------------------------------------===//
//
// Automatically generated file for adf_graph.cpp
//
//===----------------------------------------------------------------------===//
#include <adf.h>
#include <stdio.h>
#include <iostream>
#include "adf_graph.h"
)XXX";

  std::string adf_gmio_header = R"XXX(
#if !defined(__AIESIM__) && !defined(__X86SIM__) && !defined(__ADF_FRONTEND__)
    #include "adf/adf_api/XRTConfig.h"
    #include "experimental/xrt_kernel.h"
#endif
)XXX";

  std::string adf_main_plio_head = R"XXX(
#ifdef __AIESIM__
int main(int argc, char ** argv) {
)XXX";

  std::string adf_main_plio_tail = R"XXX(
  return 0;
}
#endif
)XXX";

  std::string adf_main_gmio_head = R"XXX(
int main(int argc, char ** argv) {
#if !defined(__AIESIM__) && !defined(__X86SIM__) && !defined(__ADF_FRONTEND__)
  // Create XRT device handle for ADF API
  char* xclbinFilename = argv[1];
  auto dhdl = xrtDeviceOpen(0);//device index=0
  xrtDeviceLoadXclbinFile(dhdl,xclbinFilename);
  xuid_t uuid;
  xrtDeviceGetXclbinUUID(dhdl, uuid);
  adf::registerXRT(dhdl, uuid);
#endif
)XXX";

  std::string adf_main_gmio_tail = R"XXX(
#if !defined(__AIESIM__) && !defined(__X86SIM__) && !defined(__ADF_FRONTEND__)
  xrtDeviceClose(dhdl);
#endif
  return 0;
}
)XXX";

  os << adf_cpp_header;

  // Define graph
  SmallVector<CallOp, 4> calls;
  func.walk([&](CallOp call){
    if(call->hasAttr("adf.cell")){
      os << getTypeName(call) << " ";
      os << getCall(call) << ";\n";
      calls.push_back(call);
    }
  });
  os << "\n";
  
  auto boolAttrGMIO = func->getAttrOfType<BoolAttr>("gmio");
  auto boolAttrPLIO = func->getAttrOfType<BoolAttr>("plio");
  if(boolAttrGMIO && boolAttrGMIO.getValue()==true){
    // Emit cell arguments
    addIndent();
    for(auto arg: func.getArguments()){
      indent();
      if (isa<ShapedType>(arg.getType()))
        emitArrayDecl(arg);
      else
        emitValue(arg);
      os << ";\n";
    }
    os << "\n";
    os << adf_main_gmio_head << "\n";
    emitBlock(func.getBody().front());
    os << adf_main_gmio_tail;
  }else if(boolAttrPLIO && boolAttrPLIO.getValue()==true){
    os << adf_main_plio_head << "\n";
    addIndent();
    for(auto call: calls){
      indent();
      os << getCall(call) << ".init();\n";
    }
    for(auto call: calls){
      indent();
      os << getCall(call) << ".run(1);\n";
    }
    for(auto call: calls){
      indent();
      os << getCall(call) << ".end();\n";
    }
    os << adf_main_plio_tail;
  }
}

void ModuleEmitter::emitArrayDirectives(Value memref) {
  auto type = dyn_cast<MemRefType>(memref.getType());

  // streaming
  auto attr = type.getMemorySpace();
  if (attr && dyn_cast<StringAttr>(attr)) {
    std::string attr_str = dyn_cast<StringAttr>(attr).getValue().str();
    if (attr_str.substr(0, 6) == "stream" && attr_str.length() > 6) {
      indent();
      os << "#pragma HLS stream variable=";
      emitValue(memref);
      os << " depth=";
      int depth = std::stoi(attr_str.substr(6,7));
      os << depth;
      os << "\n";
      // if the array is a FIFO, then it cannot be further partitioned
      // so directly return
      return;
    }
  }
  if (auto defineOp = memref.getDefiningOp()){
    if (auto defineAttr = defineOp->getAttr("buffer_type")){
      std::string attrStr = dyn_cast<StringAttr>(defineAttr).getValue().str();
      auto ramType = attrStr.substr(1, 8);
      auto ramImp = attrStr.substr(0, 4);
      indent();
      os << "#pragma HLS bind_storage variable=";
      emitValue(memref);
      os << " type=" << ramType;
      os << " impl=" << ramImp << "\n";
    }
  }
}


void ModuleEmitter::emitLoopDirectives(Operation *op) {
  if (auto ii = op->getAttr("pipeline_ii")) {
    reduceIndent();
    indent();
    os << "#pragma HLS pipeline II=" << dyn_cast<IntegerAttr>(ii).getValue();
    // https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/Rewinding-Pipelined-Loops-for-Performance
    if (op->hasAttr("rewind"))
      os << " rewind";
    os << "\n";
    addIndent();
  }

  if (auto factor = op->getAttr("unroll")) {
    reduceIndent();
    indent();
    auto val = dyn_cast<IntegerAttr>(factor).getValue();
    if (val == 0)
      os << "#pragma HLS unroll"
         << "\n";
    else
      os << "#pragma HLS unroll factor=" << val << "\n";
    addIndent();
  }

  if (auto dataflow = op->getAttr("dataflow")) {
    reduceIndent();
    indent();
    os << "#pragma HLS dataflow\n";
    addIndent();
  }
}

void ModuleEmitter::emitFunctionDirectives(func::FuncOp func,
                                           ArrayRef<Value> portList) {
  
  // Only top function should emit interface pragmas.
  bool TOP_FLAG = false;
  if(auto Attr = func->getAttr("top_func")){
    if(auto strAttr = dyn_cast<StringAttr>(Attr)){
      if(strAttr.getValue().str() == "plio")
        TOP_FLAG = true;
    }
  }
  if (TOP_FLAG) {
    indent();
    os << "#pragma HLS interface s_axilite port=return bundle=control\n";
    unsigned index = 0;
    for (auto &port : portList) {
      // Array ports and scalar ports are handled separately. Here, we only
      // handle MemRef types since we assume the IR has be fully bufferized.
      if (auto memrefType = dyn_cast<MemRefType>(port.getType())) {
        indent();
        os << "#pragma HLS interface";
        auto attr = memrefType.getMemorySpace();
        if(attr && dyn_cast<StringAttr>(attr) &&
           dyn_cast<StringAttr>(attr).getValue().str().substr(0,4)=="plio"){
           os << " axis";
           os << " port=";
           emitValue(port);
           os << "\n";
        }else{
          // For now, we set the offset of all m_axi interfaces as slave.
          os << " m_axi offset=slave";
          os << " bundle=gmem" << std::to_string(index++);
          os << " port=";
          emitValue(port);
          os << "\n";
          indent();
          os << "#pragma HLS interface s_axilite bundle=control";
          os << " port=";
          emitValue(port);
          os << "\n";
        }
      } else {
        indent();
        os << "#pragma HLS interface s_axilite";
        os << " port=";
        // TODO: This is a temporary solution.
        auto name = getName(port);
        if (name.front() == "*"[0])
          name.erase(name.begin());
        os << name;
        os << " bundle=control\n";
      }
    }

    // An empty line.
    os << "\n";
  }
  
  if (func->hasAttr("dataflow")) {
    indent();
    os << "#pragma HLS dataflow\n";
  }

  if (auto attr = func->getAttr("inline")) {
    auto boolAttr = dyn_cast<BoolAttr>(attr);
    indent();
    os << "#pragma HLS inline";
    if(!boolAttr.getValue())
      os << " OFF";
    os << "\n";
  }

  // // Emit other pragmas for function ports.
  // for (auto &port : portList)
  //   if (isa<MemRefType>(port.getType()))
  //     emitArrayDirectives(port);
}

void ModuleEmitter::emitKernelHeader(FuncOp func){
  auto KName = func.getName();
  os << "void " << KName << "(";
  unsigned index = 0;
  for(auto arg: func.getArguments()){
    auto argType = arg.getType();
    if(auto memType = dyn_cast<MemRefType>(argType)){
      auto size = memType.getNumElements();
      os << "input_buffer<" << getTypeName(arg) << ", extents<" << size
      <<">>& __restrict in" << std::to_string(index++) << ", "; 
    }else{
      os << getTypeName(arg) << "in" << std::to_string(index++) << ", ";
    }
  }
  index = 0;
  auto outNum = func.getNumResults();
  if(outNum == 0)
    assert("The kernel declration without any outputs is wrong");
  for(auto outType: func.getResultTypes()){
    if(auto memType = dyn_cast<MemRefType>(outType)){
      auto size = memType.getNumElements();
      os << "output_buffer<" << getTypeName(outType) <<", extents<" <<size
      << ">>& __restrict out" << std::to_string(index++);
      if(index != outNum)
        os << ", ";
      else
        os << ");\n\n"; 
      
    }else{
      os << getTypeName(outType) << "out" << std::to_string(index++) << ", ";
      if(index != outNum)
        os << ", ";
      else
        os << ");\n\n"; 
    }
  }
}

void ModuleEmitter::emitKernelFunc(FuncOp func){
  auto funcName = func.getName();
  std::string split_header = "//_aries_split_//" + funcName.str()
                             + ".cc//_aries_split_//";
  std::string kernel_header = R"XXX(
//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated file for AIE kernel with pointers.
//
//===----------------------------------------------------------------------===//

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <type_traits>
#include <aie_api/aie.hpp>

static inline void
)XXX";
  os << split_header;
  os << kernel_header;
  
  os << funcName << "(\n";
  addIndent();

  auto argNum = func.getNumArguments();
  for(unsigned i = 0; i < argNum; i++){
    indent();
    auto arg = func.getArgument(i);
    if (isa<ShapedType>(arg.getType()))
      emitArrayDecl(arg, true);
    else
      emitValue(arg);
    if (i != (argNum-1))
      os << ",\n";
  }
  reduceIndent();
  os << "\n){\n";
  addIndent();
  
  emitBlock(func.getBody().front());

  reduceIndent();
  os << "}\n\n";
}

void ModuleEmitter::emitADFGraphFunction(FuncOp func) {
  if (func.getBlocks().size() != 1)
    func->emitError("has zero or more than one basic blocks.");

  auto GraphName = func.getName();
  os << "class " << GraphName << ": public adf::graph{\n";
  os << "private:\n";
  
  // Define kernel in adf graph
  addIndent();
  func.walk([&](CallOp call){
    indent();
    os << getTypeName(call) << " ";
    os << getCall(call) << ";\n";
  });
  os << "\n";

  reduceIndent();
  os << "public:\n";

  // Define IO in adf graph
  addIndent();
  for (auto arg: func.getArguments()){
    indent();
    os << getTypeName(arg) << " ";
    os << addName(arg) << ";\n";
  }
  auto &entryBlock = func.getBody().front();
  auto returnOp = dyn_cast<ReturnOp>(entryBlock.getTerminator());
  for (auto operand: returnOp.getOperands()){
    indent();
    os << getTypeName(operand) << " ";
    os << addName(operand) << ";\n";
  }
  os << "\n";

  indent();
  os << GraphName << "() {\n";
  addIndent();

  // Create kernel and specify source files in adf graph
  func.walk([&](CallOp op){
    if(op->hasAttr("adf.kernel")){
      unsigned i=0;
      auto KName = getCall(op).str().str();
      // Define the returned value by the callee
      for( auto result: op.getResults()){
        if (!isDeclared(result)) {
          auto VName = KName + std::string(".out[") 
                             + std::to_string(i) + std::string("]");
          addName(result, false, VName);
        }
        i++;
      }
      auto calleeName = op.getCallee();
      indent();
      os <<  KName << " = " << "adf::kernel::create(" 
         << calleeName.str() << ");\n";
      indent();
      os <<  "adf::source(" << KName << ") = \"" 
         << calleeName.str() << ".cc\";\n";
      indent();
      os <<  "adf::runtime<ratio>(" << KName << ") = 1;\n" ;
      if(!op->hasAttr("col, row"))
        return;
      auto arrayAttr = dyn_cast<ArrayAttr>(op->getAttr("col, row"));
      auto col = dyn_cast<IntegerAttr>(arrayAttr[0]).getInt();
      auto row = dyn_cast<IntegerAttr>(arrayAttr[1]).getInt();
      indent();
      os <<  "adf::location<kernel>(" << KName << ") = " << "adf::tile(" 
         << std::to_string(col) << ", " << std::to_string(row) << ");\n";
      indent();
      os <<  "adf::location<stack>(" << KName << ") = " << "adf::bank(" 
        << std::to_string(col) << ", " << std::to_string(row) << ", 3);\n";
      return;
    }
  });

  emitBlock(func.getBody().front());

  reduceIndent();
  indent();
  reduceIndent();
  os << "}\n";

  os << "};\n\n";
}

void ModuleEmitter::emitHLSFunction(func::FuncOp func){
  if (func.getBlocks().size() != 1)
    func->emitError("has zero or more than one basic blocks.");
  if(func->hasAttr("template"))
    os << "template<int NC>\n";

  os << "void " << func.getName() << "(\n";
  addIndent();

  // This vector is to record all ports of the function.
  SmallVector<Value, 8> portList;

  auto argNum = func.getNumArguments();
  for(unsigned i = 0; i < argNum; i++){
    indent();
    auto arg = func.getArgument(i);
    if (isa<ShapedType>(arg.getType()))
      emitArrayDecl(arg, true);
    else
      emitValue(arg);
    
    portList.push_back(arg);
    if (i != (argNum-1))
      os << ",\n";
  }
  reduceIndent();
  os << "\n){\n";
  addIndent();
  
  emitFunctionDirectives(func, portList);
  
  emitBlock(func.getBody().front());

  reduceIndent();
  os << "}\n\n";
}

void ModuleEmitter::emitHostFunction(ModuleOp module, func::FuncOp func){
  if (func.getBlocks().size() != 1)
    func->emitError("has zero or more than one basic blocks.");
  std::string host_string0 = R"XXX(
int main(int argc, char **argv) {
  if(argc < 4) {
    std::cout << "Need to provide xclbin(file name), device id (int) and verify(0 or 1)\n";
    return 1;
  }
  char* xclbinFilename = argv[1];
  int deviceId, verify;
  if (sscanf (argv[2], "%i", &deviceId) != 1) {
    fprintf(stderr, "error - not an integer");
  }
  if (sscanf (argv[3], "%i", &verify) != 1) {
    fprintf(stderr, "error - not an integer");
  }
  
  // Open xclbin
  auto device = xrt::device(deviceId); //device index=0
	auto uuid = device.load_xclbin(xclbinFilename);
	auto dhdl = xrtDeviceOpenFromXcl(device);

)XXX";
  
  // Define function for verification
  /* Currently unused, will verify it in frontend
  SmallVector<FuncOp, 4> funcList;
  for (auto caller: func.getOps<CallOp>()){
    auto hostFunc = module.lookupSymbol<FuncOp>(caller.getCallee());
    auto it = llvm::find(funcList, hostFunc);
    if(it != funcList.end())
      continue;
    funcList.push_back(hostFunc);
    os << "void " << hostFunc.getName() << "(\n";
    addIndent();
    auto argNum = hostFunc.getNumArguments();
    for(unsigned i = 0; i < argNum; i++){
      indent();
      auto arg = hostFunc.getArgument(i);
      if (isa<ShapedType>(arg.getType()))
        emitArrayDecl(arg, true);
      else
        emitValue(arg);
      if (i != (argNum-1))
        os << ",\n";
    }
    reduceIndent();
    os << "\n){\n";
    addIndent();
    emitBlock(hostFunc.getBody().front());
    reduceIndent();
    os << "}\n\n";
  }
  */

  os << "\n";
  os << host_string0;

  SmallVector<CallOp, 4> cellCalls;
  module.walk([&](CallOp call){
    if(call->hasAttr("adf.cell"))
      cellCalls.push_back(call);
  });
  addIndent();
  indent();
  os << "// PL control\n";
  indent();
  auto strAttr = dyn_cast<StringAttr>(func->getAttr("origin_func"));
  auto callName = strAttr.getValue().str();
  auto krlName = callName + "_0";
  os << "auto " << krlName << "= xrt::kernel(device, uuid, \"" 
       << callName << ":{" << krlName << "}\");\n\n";

  // Get the attibutes that mark for the output arguments
  SmallVector<unsigned, 4> outIndices;
  if(func->hasAttr("outArgs")){
    auto arrayAttr = dyn_cast<ArrayAttr>(func->getAttr("outArgs"));
    for (auto attr : arrayAttr) {
      if (auto intAttr = dyn_cast<IntegerAttr>(attr)) {
          outIndices.push_back(intAttr.getInt());
      }
    }
  }

  // Define func arguments
  indent();
  os << "// Define arguments\n";
  unsigned indexIn = 0;
  unsigned indexOut = 0;
  SmallVector<Value, 4> outMems;
  for (unsigned idx=0; idx < func.getNumArguments(); idx++){
    auto arg = func.getArgument(idx);
    auto srcVecName = "srcVec" + std::to_string(idx);
    indent();
    os << "std::vector<" << getTypeName(arg) << "> " << srcVecName << ";\n";
    indent();
    auto fileVarName = "ifile" + std::to_string(idx);
    auto fileName = "\"data" + std::to_string(idx) + ".sim\"";
    os << "std::ifstream " << fileVarName << ";\n";
    indent();
    os << "if(verify){\n";
    addIndent();
    indent();
    os << fileVarName << ".open(" << fileName << ");\n";
    indent();
    os << "if (!" << fileVarName << ".is_open()){\n";
    addIndent();
    indent();
    os << "std::cerr << \"Error: Could not open input file.\\n\";\n";
    indent();
    os << "return 1;\n";
    reduceIndent();
    indent();
    os << "}\n";
    reduceIndent();
    indent();
    os << "}\n";
    if(llvm::is_contained(outIndices, idx)){
      auto memrefType = dyn_cast<MemRefType>(arg.getType());
      if (!memrefType)
        assert("Has non-mem output arguments.");
      std::string outHandleName = "out_bohdl" + std::to_string(indexOut);
      addName(arg, false, outHandleName);
      outMems.push_back(arg);
      std::string outMapName = "out_bomapped" + std::to_string(indexOut++);
      auto size = memrefType.getNumElements();
      indent();
      os << "auto " << getName(arg) << " = xrt::bo(device, " << size 
         << " * sizeof(" << getTypeName(arg) << "), "    
         << krlName      << ".group_id(0));\n";
      indent();
      os << "auto " << outMapName    << " = "  << getName(arg)
         << ".map<" << getTypeName(arg)    << "*>();\n\n";
    }else if(auto memrefType = dyn_cast<MemRefType>(arg.getType())){
      auto size = memrefType.getNumElements();
      std::string inHandleName = "in_bohdl" + std::to_string(indexIn);
      addName(arg, false, inHandleName);
      std::string inMapName = "in_bomapped" + std::to_string(indexIn++);
      indent();
      os << "auto " << getName(arg) << " = xrt::bo(device, " << size
         << " * sizeof(" << getTypeName(arg) << "), "   
         << krlName      << ".group_id(0));\n";
      indent();
      os << "auto " << inMapName    << " = "  << getName(arg)
         << ".map<" << getTypeName(arg)   << "*>();\n";
      // Initialize input arguments
      indent();
      os << "if(verify){\n";
      addIndent();
      indent();
      os << "for (unsigned i=0; i < " << size << "; i++){\n";
      addIndent();
      indent();
      os << getTypeName(arg) << " num;\n";
      indent();
      os << fileVarName << ">> num;\n";
      indent();
      os << srcVecName << ".push_back(num);\n";
      reduceIndent();
      indent();
      os << "}\n";
      reduceIndent();
      indent();
      os << "}\n";
      indent();
      os << "else{\n";
      addIndent();
      indent();
      os << "for (unsigned i=0; i < " << size << "; i++){\n";
      addIndent();
      indent();
      os << getTypeName(arg) << " num = (" << getTypeName(arg) 
         << ")(rand()%5);\n";
      indent();
      os << srcVecName << ".push_back(num);\n";
      reduceIndent();
      indent();
      os << "}\n";
      reduceIndent();
      indent();
      os << "}\n";
      indent();
      os << "memcpy(" << inMapName << ", " << srcVecName << ".data(), "
         << srcVecName << ".size() * sizeof(" << getTypeName(arg) << "));";
      // Sync input from host to device
      indent();
      os << getName(arg) << ".sync(XCL_BO_SYNC_BO_TO_DEVICE, " << size
         << " * sizeof(" << getTypeName(arg) << "), " << "0);\n\n";
    }else{
      emitValue(arg);
    }
  }

  // Define aie run handler
  indent();
  os << "// AI Engine Graph Control\n";
  indent();
  os << "std::cout << \"Graph run\\n\";\n"; 
  // Emit ADF Graph APIs
  for (auto call : cellCalls){
    auto cellName = getCall(call);
    indent();
    os << "auto " << cellName << "= xrt::graph(device, uuid, \"" 
       << cellName << "\");\n";
    indent();
    os << cellName << ".run(-1);\n\n";
  }

  // Define pl run handler
  auto krlRunName = krlName + "_run";
  indent();
  os << "// Set arguments of the PL function\n";
  indent();
  os << "xrt::run " << krlRunName << "= xrt::run(" << krlName << ");\n";
  auto opNum = func.getNumArguments();
  for (unsigned i = 0; i < opNum; i++){
    auto arg = func.getArgument(i);
    indent();
    os << krlRunName << ".set_arg(" << i << ", " << getName(arg) << ");\n";
  }
  indent();
  os << "std::cout << \"Kernel run\\n\";\n";
  indent();
  os << "double kernel_time_in_sec = 0;\n";
  indent();
  os << "std::chrono::duration<double> kernel_time(0);\n";
  indent();
  os << "auto kernel_start = std::chrono::high_resolution_clock::now();\n";
  indent();
  os << krlRunName << ".start();\n";
  indent();
  os << krlRunName << ".wait();\n";
  indent();
  os << "auto kernel_end = std::chrono::high_resolution_clock::now();\n";
  indent();
  os << "kernel_time = std::chrono::duration<double>"
     << "(kernel_end - kernel_start);\n";
  indent();
  os << "kernel_time_in_sec = kernel_time.count();\n";
  indent();
  os << "std::cout << \"Kernel run finished!\\n\";\n";
  indent();
  os << "std::cout << \"Total time is: \"<< kernel_time_in_sec" 
     << "<< \"s\" << std::endl;\n";
  indent();
  os << "// Sync output buffer back to host\n";
  for (auto outMem : outMems){
    auto memrefType = dyn_cast<MemRefType>(outMem.getType());
    auto size = memrefType.getNumElements();
    indent();
    os << getName(outMem) << ".sync(XCL_BO_SYNC_BO_FROM_DEVICE , " << size
       << " * sizeof(" << getTypeName(outMem) << "), " << "0);\n";
  }
  indent();
  os << "std::cout << \"Output buffer sync back finished\\n\";\n\n";
  indent();
  os << "int errorCount = 0;\n";
  indent();
  os << "if(verify){\n";
  addIndent();
  indent();
  os << "std::cout << \"Start results verification\\n\";\n";
  for (unsigned idx=0; idx < outMems.size(); idx++){
    auto outMem = outMems[0];
    auto index = outIndices[idx];
    auto memrefType = dyn_cast<MemRefType>(outMem.getType());
    auto size = memrefType.getNumElements();
    auto srcVecName = "srcVec" + std::to_string(index);
    std::string outMapName = "out_bomapped" + std::to_string(idx);
    indent();
    os << "for (unsigned i=0; i < " << size << "; i++){\n";
    addIndent();
    indent();
    os << "if(abs((float)(" << srcVecName << "[i]-" << outMapName << "[i]"
       << ")>=1e-4)){\n";
    addIndent();
    indent();
    os << "printf(\"Error found " << srcVecName << "[%d]!=" 
       << outMapName << "[%d], %f!=%f \", i, i, " << srcVecName << "[i], "
       << outMapName << "[i]);\n";
    indent();
    os << "errorCount++;\n"; 
    reduceIndent();
    indent();
    os << "}\n";
    reduceIndent();
    indent();
    os << "}\n";
  }
  indent();
  os << "if (errorCount)\n";
  addIndent();
  indent();
  os << "printf(\"Test failed with %d errors\\n\", errorCount);\n";
  reduceIndent();
  indent();
  os << "else\n";
  addIndent();
  indent();
  os << "printf(\"TEST PASSED\\n\");\n";
  reduceIndent();
  reduceIndent();
  indent();
  os << "}\n";
  
  indent();
  os << "if(verify){\n";
  addIndent();
  for (unsigned idx=0; idx < func.getNumArguments(); idx++){
    auto fileVarName = "ifile" + std::to_string(idx);
    indent();
    os << fileVarName << ".close();\n";
  }
  reduceIndent();
  indent();
  os << "}\n";

  indent();
  os << "std::cout << \"Host Run Finished!\\n\";\n"; 
  os << "  return 0;\n";
  os << "}\n";
  // An empty line.
  os << "\n";
}

static Value calleeArg(CallOp topCaller, CallOp caller, FuncOp callee, 
                    Value val, bool topSel){
  Value finalVal;
  auto callArgs = caller.getOperands();
  auto it = llvm::find(callArgs,val);
  if(it == callArgs.end())
   return finalVal;
  auto index = std::distance(callArgs.begin(), it);
  if(topSel)
    finalVal = topCaller.getOperand(index);
  else
    finalVal = callee.getArgument(index);
  return finalVal;
}

void ModuleEmitter::emitConfig(ModuleOp mod, func::FuncOp topFunc,
                               func::FuncOp func){  
  auto funcName = topFunc.getName();
  auto plName = funcName + "_0";
  os << "nk = " << funcName << ":1:" << plName << "\n";
  CallOp plCall;
  CallOp cellCall;
  func.walk([&](CallOp call){
    if(call->hasAttr("adf.pl")){
      plCall = call;
    }else if(call->hasAttr("adf.cell")){
      cellCall = call;
    }
  });
  CallOp topCaller;
  for (auto call: topFunc.getOps<CallOp>()){
    if(call.getCallee()!=plCall.getCallee())
      continue;
    topCaller = call;
    break;
  }
  FuncOp cellCallee;
  for (auto funcOp: mod.getOps<FuncOp>()){
    if(cellCall.getCallee()!=funcOp.getName())
      continue;
    cellCallee = funcOp;
    break;
  }
  func.walk([&](adf::ConnectOp op){
    auto src = op.getSrc();
    auto srcType = src.getType();
    auto dst = op.getDst();
    if(dyn_cast<MemRefType>(srcType)){
      auto srcVal = calleeArg(topCaller, plCall, cellCallee, src, true);
      auto dstVal = calleeArg(topCaller, cellCall, cellCallee, dst, false);
      os << "stream_connect = " << plName << "." << getName(srcVal)
         << ":ai_engine_0." << getName(dstVal) << "\n";
    }else{
      auto srcVal = calleeArg(topCaller, cellCall, cellCallee, src, false);
      auto dstVal = calleeArg(topCaller, plCall, cellCallee, dst, true);
      os << "stream_connect = " << "ai_engine_0." << getName(srcVal) << ":"
         << plName << "." << getName(dstVal) << "\n"; 
    }
  });
}

void ModuleEmitter::emitModule(ModuleOp module) {
  std::string kernel_header = R"XXX(
//_aries_split_//adf_kernel.h//_aries_split_//
//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated AIE kernel file supported by Vitis Flow.
//
//===----------------------------------------------------------------------===//
#ifndef __KERNEL_H__
#define __KERNEL_H__
using namespace adf;

)XXX";

  std::string kernel_tail = R"XXX(
#endif //__KERNEL_H__/
)XXX";
  
  std::string adfh_header = R"XXX(
//_aries_split_//adf_graph.h//_aries_split_//
//===----------------------------------------------------------------------===//
//
// Automatically generated file for adf_graph.h
//
//===----------------------------------------------------------------------===//
#ifndef __GRAPH_H__
#define __GRAPH_H__

#include <adf.h>
#include <stdio.h>
#include <iostream>
#include "adf_kernel.h"
using namespace adf;


)XXX";

  std::string hls_header = R"XXX(
//_aries_split_//hls.cpp//_aries_split_//
//===----------------------------------------------------------------------===//
//
// Automatically generated file for hlc.cpp
//
//===----------------------------------------------------------------------===//
#include <math.h>
#include <stdint.h>
#include <ap_int.h>
#include <ap_fixed.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include <hls_math.h>
)XXX";

  std::string host_header = R"XXX(
//_aries_split_//host.cpp//_aries_split_//
//===----------------------------------------------------------------------===//
//
// Automatically generated file for host.cpp
//
//===----------------------------------------------------------------------===//
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <fstream>
#include <cstring>
#include <time.h>
#include <vector>
#include <math.h>
#include <string>

// This is used for the PL Kernels
#include "experimental/xrt_bo.h"
#include "experimental/xrt_device.h"
#include "experimental/xrt_kernel.h"


// Using the ADF API that call XRT API
#include "adf/adf_api/XRTConfig.h"
//#include "../aie/adf_graph.h"

using namespace std;
)XXX";

//Emit Connection between PL and AIE
  std::string config_header = R"XXX(
//_aries_split_//system.cfg//_aries_split_//
#===----------------------------------------------------------------------===
#
# Automatically generated file for system.cfg
#
#===----------------------------------------------------------------------===
[vivado]
prop=run.impl_1.STEPS.PLACE_DESIGN.ARGS.DIRECTIVE=EarlyBlockPlacement
[connectivity]
)XXX";
  // Tranverse and record the specified callOp
  module.walk([&](CallOp call){
    if(call->hasAttr("adf.kernel") || call->hasAttr("adf.cell")
    || call->hasAttr("adf.pl")){
      addCall(call);
    }
  });

  FuncOp topFunc;
  bool PL_FLAG = true;
  bool en_gen = false;
  for (auto op : module.getOps<FuncOp>()) {
    if(op->hasAttr("adf.kernel")){
      // Currently do nothing
      // emitKernelFunc(op);
    }else if (op->hasAttr("adf.cell")){
      os << adfh_header;
      emitADFGraphFunction(op);
      os << "#endif //__GRAPH_H__\n";
    }else if(op->getAttr("adf.pl")){
      if(PL_FLAG){
        os << hls_header;
        PL_FLAG = false;
      }
      emitHLSFunction(op);
    }else if(op->hasAttr("top_func")){
      en_gen = true;
      topFunc = op;
      emitHLSFunction(op);
    }else if(op->hasAttr("top_host")){
      os << host_header;
      emitHostFunction(module,op);
    }
  }

  if(en_gen){
    // Generate the kernel header separately
    os << kernel_header;
    for (auto op : module.getOps<FuncOp>()) {
      if(op->hasAttr("adf.kernel")){
        emitKernelHeader(op);
      }
    }
    os << kernel_tail;
  }

  bool CONF_FLAG = true;
  for (auto op : module.getOps<FuncOp>()) {
    if(!op->hasAttr("adf.func"))
      continue;
    emitADFMain(op);
    auto boolAttrPLIO = op->getAttrOfType<BoolAttr>("plio");
    if(boolAttrPLIO && boolAttrPLIO.getValue()){
      if(CONF_FLAG){
        os << config_header;
        CONF_FLAG = false;
      }
      emitConfig(module, topFunc, op);
    }
  }
}

LogicalResult aries::emitAriesCpp(ModuleOp module, llvm::raw_ostream &os) {
  ADFEmitterState state(os);
  ModuleEmitter(state).emitModule(module);
  return failure(state.encounteredError);
}