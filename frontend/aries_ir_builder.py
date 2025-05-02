import ast
import astor
import inspect
import sympy as sp
import numpy as np
import subprocess, os, glob
import types
from pathlib import Path
from .gen_template import *
from .analytical_model import *

# =========== Code Transformation and IR Builder ===========

# =========== Base Emitter Class ===========
class MLIRGenerator(ast.NodeVisitor):
    def __init__(self, mapInfo, map_cnt=0, func_attr=None):
        self.mlir_func_code = [] # Store the code within func
        self.mlir_pl_code = [] # Store the pl libaray code
        self.mlir_map_code = [] # Store the AffineMap code
        self.indent = 2
        self.var_count = 0
        self.map_cnt = map_cnt
        
        self.valName = {} # valName["A"] = "%A"
        self.valType = {} # E.g., valType["A"] = (T, [32, 32])
        self.valNameCnt = {} # valNameCnt["%A"] = cnt, to avoid name conflict
        self.map = {} # map["ti"] = # map, dims  now only record the offset map
        self.castMap = {} # This records the original mem before cast: castMap["cast"] = real_mem
        self.mapInfo = mapInfo # dic["ti"] = (32*i), stores key and expression
        self.in_assign  = False # Track whether inside an Assign node
        self.func_attr = func_attr

    ## -- Variable & Type Management -- ##
    def add_var_name(self, val, name="", en_prefix=True):
        if(name != ""):
            if en_prefix:
              name = "%" + name
            if(self.valNameCnt.get(name, 0) > 0):
                valNameStr = name + "_" + str(self.valNameCnt[name])
                self.valNameCnt[name] += 1
            else:
                self.valNameCnt[name] = 1
                valNameStr = name
        else:
            valNameStr = "%v" + str(self.var_count)
            self.var_count += 1
        self.valName[val] = valNameStr
        return valNameStr
    
    def get_var_name(self, val):
        if val not in self.valName:
            assert False, f"KeyError: The val '{val}' was not defined."
        valNameStr = self.valName[val]
        return valNameStr
    
    def add_type_name(self, val, type, shape=[], memSpace = ""):
        self.valType[val] = (type, shape, memSpace)
        typeName = self.get_type_name(val)
        return typeName
    
    def normalize_type(self, dtype):
        if dtype == 'float':
            return 'float32'
        if dtype == 'int':
            return 'int32'
        return dtype
        
    def get_eletype_name(self, arg):
        type_map = {
            "float32": "f32",
            "float": "f32",
            "double": "f64",
            "int32": "i32",
            "int": "i32",
            "int16": "i16",
            "int8": "i8",
            "index": "index",
            "f32": "f32",
            "f64": "f64",
            "i32": "i32",
            "i16": "i16",
            "i8": "i8",
        }
        ty = self.valType[arg][0]
        if ty in type_map:
            return type_map[ty]
        else:
            raise TypeError(f"Unsupported type: {ty}")
    
    def addMemSpace(self, type_name, memSpace):
        if memSpace == "L1":
            type_name += ", " + str(2)
        elif memSpace == "L2":
            type_name += ", " + str(1)
        elif memSpace == "L3":
            type_name += ", " + str(0)
        return type_name
    
    def get_shape_from_memref_type(self, memrefType_name):
      # Regular expression to match "memref<shape>", including element type
      match = re.match(r"memref<([^x]+(?:x[^>]+)*)x(\w+)>", memrefType_name)
      if match:
          shape_str = match.group(1)
          # Split shape by 'x' and convert to list of integers, replacing '?' with -1
          shape = [int(dim) if dim != '?' else -1 for dim in shape_str.split('x')]
          return shape
      else:
          raise ValueError(f"Invalid memref type string: {memrefType_name}")
    
    def get_MemRefType_name(self, arg):
      _, shape, memSpace = self.valType[arg]
      shape_name = "x".join(["?" if s == -1 else str(s) for s in shape])
      type_name = self.get_eletype_name(arg)
      type_name = self.addMemSpace(type_name, memSpace)
      memrefType_name = f"memref<{shape_name}x{type_name}>"
      return memrefType_name
    
    def get_type_name(self, arg):
        if arg not in self.valType:
            assert False, f"KeyError: The type of '{arg}' was not found."
        if not self.is_array(arg):
            typeName = self.get_eletype_name(arg)
        else:
            typeName = self.get_MemRefType_name(arg)
        return typeName
    
    def is_declared(self, arg):
        if arg in self.valName:
            return True
        else:
            return False
    
    def is_array(self, arg):
        if arg not in self.valType:
            assert False, f"KeyError: The type of '{arg}' was not found." 
        _, shape, _ = self.valType[arg] 
        if len(shape) == 0:
            return False
        else:
            return True       
    
    # Handle uniary op
    def extract_constant(self, expr):
      if isinstance(expr, ast.Constant):
          return expr.value
      elif isinstance(expr, ast.UnaryOp) and isinstance(expr.op, ast.USub):
          return -self.extract_constant(expr.operand)
      elif isinstance(expr, ast.UnaryOp) and isinstance(expr.op, ast.UAdd):
          return +self.extract_constant(expr.operand)
      else:
          raise ValueError(f"Unsupported expression in shape: {ast.dump(expr)}")
    
    def addArgType(self, node, memSpace = ""):
        # Record the type of arguments in the function
        for arg in node.args.args:
            self.add_var_name(arg.arg, arg.arg)
            if arg.annotation:
                ty = arg.annotation
                if isinstance(ty, ast.Subscript):
                    # Extract shape
                    if isinstance(ty.slice, ast.Tuple):
                        shape = tuple(self.extract_constant(e) for e in ty.slice.elts)
                    else:
                        shape = [self.extract_constant(ty.slice)]
                    self.add_type_name(arg.arg, ty.value.id, shape, memSpace)
                else:
                    self.add_type_name(arg.arg, ty.id)
            else: # If not anntation then the default type is index
                self.add_type_name(arg.arg, "index")
                    
        return
    
    ## -- Core AST Processing -- ##
    def visit_FunctionDef(self, node):
        # Add types for each arg
        self.addArgType(node)
        
        # Process the function definition and arguments
        func_name = node.name
        args = [arg.arg for arg in node.args.args]
        # Get annotation types
        memrefs = []
        for arg in args:
            if arg in self.valType:
                typeName = self.get_type_name(arg)
                memrefs.append(f"%{arg}: {typeName}")
            else:
                raise ValueError(f"Argument {arg} not found in valType.")
        if self.func_attr is None:
            self.emit(f"func.func @{func_name}({', '.join(memrefs)}) {{")
        else:
            self.emit(f"func.func @{func_name}({', '.join(memrefs)}) attributes {{{self.func_attr}}} {{")

        self.indent += 2
        self.generic_visit(node)
        self.emit("return")
        self.indent -= 2
        self.emit("} ")
    
    def visit_For(self, node):
        # Process affine.for loop
        loop_var = node.target.id  # e.g., i0, j0, k0
        loop_Name = self.add_var_name(loop_var, loop_var)
        loop_call = node.iter.func
        if len(node.iter.args) == 1:
          loop_lb = 0
          if isinstance(node.iter.args[0], ast.Constant):
              loop_ub = node.iter.args[0].value
          elif isinstance(node.iter.args[0], ast.Name):
              loop_ub = self.get_var_name(node.iter.args[0].id)  # get variable name
          else:
              raise TypeError("Unsupported upper loop bound")
        else:
          if isinstance(node.iter.args[0], ast.Constant):
              loop_lb = node.iter.args[0].value
          elif isinstance(node.iter.args[0], ast.Name):
              loop_lb = self.get_var_name(node.iter.args[0].id)
          else:
              raise TypeError("Unsupported lower loop  bound")

          if isinstance(node.iter.args[1], ast.Constant):
              loop_ub = node.iter.args[1].value
          elif isinstance(node.iter.args[1], ast.Name):
              loop_ub = self.get_var_name(node.iter.args[0].id) 
          else:
              raise TypeError("Unsupported upper loop bound")
        self.emit(f"affine.for {loop_Name} = {loop_lb} to {loop_ub} {{")

        self.indent += 2
        self.generic_visit(node)
        self.indent -= 2
        
        if isinstance(loop_call, ast.Attribute) and loop_call.attr == "reduce_range":
            self.emit("}{reduction}")
        elif isinstance(loop_call, ast.Name) and loop_call.id == "reduce_range":
            self.emit("}{reduction}")
        else:
            self.emit("}")
    
    ## -- Emit Functions -- ##
    def emit(self, code, same_line=False):
        if same_line:
            self.mlir_func_code[-1] = self.mlir_func_code[-1] + code
        else:
            self.mlir_func_code.append(" " * self.indent + code)
    
    def emit_cons(self, value, type = "index"):
        varName = "c" + str(int(float(value)))
        result = self.add_var_name("temp", varName)
        self.emit(f"{result} = arith.constant {value} : {type}")
        return result
    
    def emitMap(self, code):
        self.mlir_map_code.append(code)
    
    def find_dim(self, expr):
        """
        Extract dimension variables from a SymPy expression.

        Args:
            expr: SymPy expression (e.g., i * 32 + j)

        Returns:
            List of dimension variable names (sorted for consistency)
        """
        return sorted([str(symbol) for symbol in expr.free_symbols])  # Extract symbols as strings


    def emit_affine_map(self, expr, dims, syms):
        """
        Convert a SymPy expression to an MLIR affine map.

        Args:
            expr: SymPy expression (e.g., i * 32 + j)
            dims: List of dimension variables (e.g., ['i', 'j'])
            syms: List of symbolic variables (e.g., [])

        Returns:
            MLIR affine map string (e.g., affine_map<(d0, d1) -> (d0*32 + d1)>)
        """
        dim_map = {dim: f"d{i}" for i, dim in enumerate(dims)}
        sym_map = {sym: f"s{i}" for i, sym in enumerate(syms)}

        affine_expr = expr.subs(dim_map).subs(sym_map)

        dim_str = ", ".join(dim_map.values()) if dim_map else ""
        sym_str = ", ".join(sym_map.values()) if sym_map else ""

        map_str = f"affine_map<({dim_str})"
        if sym_str:
            map_str += f"[{sym_str}]"
        map_str += f" -> ({affine_expr})>"

        return map_str
    
    # Generate map for offset
    def gen_map(self):
        if self.mapInfo is None:
            return
        for key, value in self.mapInfo.items():
            offestExpr = value[0]
            dims = self.find_dim(offestExpr)
            affineMap = self.emit_affine_map(offestExpr, dims, [])
            mapName = "#map" + str(self.map_cnt)
            self.map_cnt +=1
            self.map[key] = (mapName, dims)
            self.emitMap(f"{mapName} = {affineMap}")
        return
    
    def generate(self, tree):
        # Generate the code for AffineMap
        self.gen_map()
        
        # Parse the input Python code and visit nodes
        self.visit(tree)
        func_code = "\n".join(self.mlir_func_code)
        func_lib_code = "\n".join(self.mlir_pl_code)
        combined_code = func_lib_code + "\n" + func_code
        map_code = "\n".join(self.mlir_map_code)
        return combined_code, map_code, self.map_cnt


# =========== Emitter for task tile ===========
class TileMLIRGenerator(MLIRGenerator):
    # dmaInfo: dic["ti"] = (32*i, 32, 1) (offset, size, step)
    # This is a slightly different than this parent class where the mapInfo 
    # only contains the expression
    def __init__(self, dmaInfo, map_cnt=0):
        super().__init__(dmaInfo, map_cnt, "adf.func")
    
    def DmaInfo(self, arg, offsets, sizes, strides):
        eltName = arg.id
        # For each dim, create the affine.apply op for each offset
        mapName, dims = self.map[eltName] #mapName, dims
        dimNames = [self.get_var_name(dim) for dim in dims]
        offsetVar = arg.id + "_offset"
        offsetVarName = self.add_var_name(offsetVar)
        offsets.append(offsetVarName)
        self.emit(f"{offsetVarName} = affine.apply {mapName}({', '.join(dimNames)})")
        # For each dim, create constant for size and stride
        _, size, step = self.mapInfo[eltName]
        sizeVar = arg.id + "_size"
        sizeVarName = self.add_var_name(sizeVar, "c" + sizeVar)
        sizes.append(sizeVarName)
        self.emit(f"{sizeVarName} = arith.constant {size} : index")
        strideVar = arg.id + "_stride"
        strideVarName = self.add_var_name(strideVar, "c" + strideVar)
        strides.append(strideVarName)
        self.emit(f"{strideVarName} = arith.constant {step} : index")
        return offsets, sizes, strides
    
    def getDmaInfo(self, call, is_load = False):
        # Stores the VarName of offsets, sizes and strides
        # that can be printed out directly
        offsets = []
        sizes = []
        strides = []
        srcMemName = None
        dstMemName = None
        srcMemName = call.args[0].id
        if is_load:
            idx = 1
        else:
            dstMemName = call.args[1].id
            idx = 2
        if isinstance(call.args[idx], ast.Name):
            offsets, sizes, strides = self.DmaInfo(call.args[idx], offsets, sizes, strides)
        else:
            for elt in call.args[idx].elts:
                offsets, sizes, strides = self.DmaInfo(elt, offsets, sizes, strides)
        return offsets, sizes, strides, srcMemName, dstMemName
    
    def TransInfo(self, arg0, arg1, tiles, dims, steps, wraps):
        for elt in arg0.elts:
            result = self.emit_cons(elt.value)
            tiles.append(result)
        # In case the transpose info is not in a 2d list
        if isinstance(arg1.elts[0], ast.Constant): 
            result = self.emit_cons(arg1.elts[0].value)
            dims.append(result)
            result = self.emit_cons(arg1.elts[1].value)
            steps.append(result)
            result = self.emit_cons(arg1.elts[2].value)
            wraps.append(result)
        else:
          for eltList in arg1.elts:
              result = self.emit_cons(eltList.elts[0].value)
              dims.append(result)
              result = self.emit_cons(eltList.elts[1].value)
              steps.append(result)
              result = self.emit_cons(eltList.elts[2].value)
              wraps.append(result)
        return tiles, dims, steps, wraps
    
    def getTransInfo(self, call, is_load = False):
        tiles = []
        dims = []
        steps = []
        wraps = []
        argLen = len(call.args)
        if is_load and argLen==4:
            tiles, dims, steps, wraps = self.TransInfo(call.args[2], call.args[3], tiles, dims, steps, wraps) 
        elif not is_load and argLen == 5:
            tiles, dims, steps, wraps = self.TransInfo(call.args[3], call.args[4], tiles, dims, steps, wraps)    
        return tiles, dims, steps, wraps
    
    def visit_Assign(self, node):
        assert len(node.targets) == 1
        target = node.targets[0]
        
        if isinstance(node.value, ast.Call):
            assert isinstance(node.value.func, ast.Attribute)
            assert isinstance(node.value.func.value, ast.Name)
            assert node.value.func.value.id == 'aries'
            
            if node.value.func.attr == 'load':
                call = node.value
                dstMemName = target.id
                offsets, sizes, strides, srcMemName, _ = self.getDmaInfo(call, True)
                srcMem = self.get_var_name(srcMemName)
                srcType = self.get_type_name(srcMemName)
                dstMem = self.get_var_name(dstMemName)
                dstType = self.get_type_name(dstMemName)
                tiles, dims, steps, wraps = self.getTransInfo(call, True)
                self.emit(f"adf.dma({srcMem}[{' ,'.join(offsets)}] [{' ,'.join(sizes)}] [{' ,'.join(strides)}] [{' ,'.join(tiles)}] [{' ,'.join(dims)}] [{' ,'.join(steps)}] [{' ,'.join(wraps)}], {dstMem}[] [] [] [] [] [] []) : ({srcType} , {dstType})")  
                return
            
            elif node.value.func.attr == 'buffer':
                buffer = target.id
                bufferName = self.add_var_name(buffer, buffer)
                shape_node = node.value.args[0]
                type_node = node.value.args[1]
                shape = tuple(constant.value for constant in shape_node.elts)
                type = type_node.value
                typeName = self.add_type_name(buffer, type, shape, "L1")
                self.emit(f"{bufferName} = adf.buffer.create @L1_{buffer}() : {typeName}")
                return
            
            elif node.value.func.attr == "accbuffer":
                buffer = target.id
                bufferName = self.add_var_name(buffer, buffer)
                shape_node = node.value.args[0]
                type_node = node.value.args[1]
                shape = tuple(constant.value for constant in shape_node.elts)
                type = type_node.value
                typeName = self.add_type_name(buffer, type, shape, "L1")
                self.emit(f"{bufferName} = adf.buffer.create @L1_{buffer}() {{accumulator}} : {typeName} ")
                return
            elif node.value.func.attr == "arange":
                return
            else:
                raise TypeError(f"Unsupported API call in @task_tile(): {node.value.func.attr}.")
    
    def visit_Expr(self, node):
        if isinstance(node.value, ast.Call):
            if isinstance(node.value.func, ast.Name):
                calleeName = node.value.func.id
                args = node.value.args
                argNames = []
                argTypes = []
                for arg in args:
                    argNames.append(self.get_var_name(arg.id))
                    argTypes.append(self.get_type_name(arg.id))
                self.emit(f"func.call @{calleeName}({', '.join(argNames)}) : (")
                self.emit(f"{', '.join(argTypes)}) -> ()", True)
            elif isinstance(node.value.func, ast.Attribute):
                assert node.value.func.value.id == 'aries'
                if node.value.func.attr == 'store':
                    call = node.value
                    offsets, sizes, strides, srcMemName, dstMemName = self.getDmaInfo(call)
                    srcMem = self.get_var_name(srcMemName)
                    srcType = self.get_type_name(srcMemName)
                    dstMem = self.get_var_name(dstMemName)
                    dstType = self.get_type_name(dstMemName)
                    tiles, dims, steps, wraps = self.getTransInfo(call)
                    self.emit(f"adf.dma({srcMem}[] [] [] [] [] [] [], {dstMem}[{' ,'.join(offsets)}] [{' ,'.join(sizes)}] [{' ,'.join(strides)}] [{' ,'.join(tiles)}] [{' ,'.join(dims)}] [{' ,'.join(steps)}] [{' ,'.join(wraps)}]) : ({srcType} , {dstType})")  
                    return
                elif node.value.func.attr == 'accstore':
                    call = node.value
                    offsets, sizes, strides, srcMemName, dstMemName = self.getDmaInfo(call)
                    srcMem = self.get_var_name(srcMemName)
                    srcType = self.get_type_name(srcMemName)
                    dstMem = self.get_var_name(dstMemName)
                    dstType = self.get_type_name(dstMemName)
                    tiles, dims, steps, wraps = self.getTransInfo(call)
                    self.emit(f"adf.dma({srcMem}[] [] [] [] [] [] [], {dstMem}[{' ,'.join(offsets)}] [{' ,'.join(sizes)}] [{' ,'.join(strides)}] [{' ,'.join(tiles)}] [{' ,'.join(dims)}] [{' ,'.join(steps)}] [{' ,'.join(wraps)}]) {{accumulator}} : ({srcType} , {dstType})")  
                    return
                
# =========== Emitter for task kernel ===========
class KernelMLIRGenerator(MLIRGenerator):
    def __init__(self, dmaInfo, map_cnt=0, device="vck190", linkFile="true"):
        super().__init__(dmaInfo, map_cnt, "adf.kernel")
        self.is_assign = False
        self.device = device
        self.linkFile = linkFile
        
    def get_type(self, node):
        """Retrieve the type of a variable or constant."""
        if isinstance(node, ast.Constant):
            if isinstance(node.value, int):
                return "int32"
            elif isinstance(node.value, float):
                return "float32"
            else:
                raise TypeError(f"Unsupported constant type: {type(node.value)}")
        elif isinstance(node, ast.Call): # Defined constant type
            return node.func.id
        elif isinstance(node, ast.Subscript): # Memref
            if node.value.id in self.valType:
                return self.valType[node.value.id][0]
            else:
                raise KeyError(f"Variable '{node.value.id}' is not declared.")
        elif isinstance(node, ast.Name):
            if node.id in self.valType:
                return self.valType[node.id][0]  # Extract stored type
            else:
                raise KeyError(f"Variable '{node.id}' is not declared.")
        elif isinstance(node, ast.BinOp):
            # If it's a BinOp, recursively check the types of the left and right operands
            left_type = self.normalize_type(self.get_type(node.left))
            right_type = self.normalize_type(self.get_type(node.right))
            # Check that the types of the left and right operands are compatible
            if left_type != right_type:
                raise TypeError(f"Type mismatch: {left_type} and {right_type} are not compatible.")
            # Return the type of the BinOp (same as the operand types)
            return left_type
        else:
            raise TypeError(f"Unsupported type retrieval for node: {ast.dump(node)}")
    
    def addArgType(self, node, memSpace="L1"):
        """Overrides parent method, specifying memorySpace = 'L1'."""
        super().addArgType(node, memSpace=memSpace)  # Calls parent with L1
    
    def get_op_type(self, op, operand_type):
        """Maps Python operators to MLIR integer or floating-point operations."""
        float_ops = {
            ast.Add: "arith.addf",
            ast.Sub: "arith.subf",
            ast.Mult: "arith.mulf",
            ast.Div: "arith.divf",
        }
        int_ops = {
            ast.Add: "arith.addi",
            ast.Sub: "arith.subi",
            ast.Mult: "arith.muli",
            ast.Div: "arith.divsi",  # Signed integer division
        }

        if operand_type.startswith("f"):
            return float_ops.get(type(op), None)
        elif operand_type.startswith("i"):
            return int_ops.get(type(op), None)
        else:
            raise NotImplementedError(f"Unsupported operand type: {operand_type}")
    
    def visit_FunctionDef(self, node):
        # Add types for each arg
        self.addArgType(node)
        
        # Process the function definition and arguments
        func_name = node.name
        args = [arg.arg for arg in node.args.args]
        # Get annotation types
        memrefs = []
        for arg in args:
            if arg in self.valType:
                typeName = self.get_type_name(arg)
                memrefs.append(f"%{arg}: {typeName}")
            else:
                raise ValueError(f"Argument {arg} not found in valType.")
        if self.func_attr is None:
            self.emit(f"func.func @{func_name}({', '.join(memrefs)}) {{")
        else:
            if self.device == "npu" and self.linkFile == "true":
                self.emit(f"func.func private @{func_name}({', '.join(memrefs)}) attributes {{{self.func_attr}}}")
                return
            else:
                self.emit(f"func.func @{func_name}({', '.join(memrefs)}) attributes {{{self.func_attr}}} {{")

        self.indent += 2
        self.generic_visit(node)
        self.emit("return")
        self.indent -= 2
        self.emit("} ")
    
    def visit_Call(self, node):
        if self.is_assign == False:
            return
        assert isinstance(node.func, ast.Name)
        assert len(node.args) == 1
        value = node.args[0].value
        
        if node.func.id.startswith("f"):
            formatted_value = f"{value:.6f}"
        elif node.func.id.startswith("i"):
            formatted_value = value
        else:
            raise NotImplementedError(f"Unsupported operand type: {node.func.id}")
        type = self.add_type_name("temp", node.func.id)
        result = self.emit_cons(formatted_value, type)
        return result
    
    def visit_BinOp(self, node):
        """Processes binary operations."""
        lhs = self.visit(node.left)
        rhs = self.visit(node.right)
        
        # Retrieve types from stored values
        lhs_type = self.normalize_type(self.get_type(node.left))
        rhs_type = self.normalize_type(self.get_type(node.right))
        assert lhs_type == rhs_type, f"Type mismatch: {lhs_type} vs {rhs_type}"
        
        result = self.add_var_name("temp")
        type = self.add_type_name("temp", lhs_type)
        
        op_type = self.get_op_type(node.op, type)
        self.emit(f"{result} = {op_type} {lhs}, {rhs} : {type}")

        return result

    def get_binop_symbol(self, op):
        """Maps AST binary operator nodes to string symbols."""
        if isinstance(op, ast.Add): return "+"
        if isinstance(op, ast.Sub): return "-"
        if isinstance(op, ast.Mult): return "*"
        raise NotImplementedError(f"Unsupported binary operator: {type(op).__name__}")
    
    def index_expr(self, node):
        """Recursively reconstruct the index expression with renamed variables."""
        if isinstance(node, ast.Name):
            return self.get_var_name(node.id)
        elif isinstance(node, ast.Constant):
            return str(node.value)
        elif isinstance(node, ast.BinOp):
          left = self.index_expr(node.left)
          right = self.index_expr(node.right)
          op = self.get_binop_symbol(node.op)
          return f"{left} {op} {right}"
        else:
          raise NotImplementedError(f"Unsupported index expression: {ast.dump(node)}")
        
    def visit_Subscript(self, node):
        if self.is_assign == False:
            return
        """Handles memory accesses like chunk[i, j]."""
        memref = node.value.id
        memType = self.get_type_name(memref)
        memName = self.get_var_name(memref)
        if isinstance(node.slice, ast.Tuple):
            indices = [self.index_expr(expr) for expr in node.slice.elts]
        else:
            indices = [self.index_expr(node.slice)]
        
        if isinstance(node.ctx, ast.Store):
            return memref, indices
        elif isinstance(node.ctx, ast.Load):
            result = self.add_var_name("load")
            self.emit(f"{result} = affine.load {memName}[{', '.join(indices)}] : {memType}")
            return result 
        else:
            raise NotImplementedError(f"Unsupported context {type(node.ctx)} in Subscript.")

    def visit_Assign(self, node):
        assert len(node.targets) == 1
        target_node = node.targets[0]
        self.is_assign = True
        value = self.visit(node.value)
        if isinstance(target_node, ast.Subscript):
            # Handle memory store case
            memref, indices = self.visit(target_node)
            memType = self.get_type_name(memref)
            memName = self.get_var_name(memref)
            self.emit(f"affine.store {value}, {memName}[{', '.join(indices)}] : {memType}")
        self.is_assign = False
    
    def visit_AugAssign(self, node):
        target_node = node.target
        self.is_assign = True
        value = self.visit(node.value)
        if isinstance(target_node, ast.Subscript):
            # Handle memory store case
            memref, indices = self.visit(target_node)
            memType = self.get_type_name(memref)
            memName = self.get_var_name(memref)
            lhs = self.add_var_name("load")
            self.emit(f"{lhs} = affine.load {memName}[{', '.join(indices)}] : {memType}")
            type = self.get_eletype_name(memref)
            op_type = self.get_op_type(node.op, type)
            result = self.add_var_name("temp")
            self.emit(f"{result} = {op_type} {lhs}, {value} : {type}")
            self.emit(f"affine.store {result}, {memName}[{', '.join(indices)}] : {memType}")
        self.is_assign = False
        return

class TopMLIRGenerator(MLIRGenerator):
    def __init__(self, dmaInfo, temp_dir= ".", map_cnt=0):
        super().__init__(dmaInfo, map_cnt, "top_func")
        self.pl_dir = Path(temp_dir) / "pl_mlir"
    
    def emit_call(self, node):
        if isinstance(node.func, ast.Name):
            calleeName = node.func.id
        elif isinstance(node.func, ast.Subscript):
            calleeName = node.func.value.id
        args = node.args
        argNames = []
        argTypes = []
        for arg in args:
            if isinstance(arg, ast.Name):
                argNames.append(self.get_var_name(arg.id))
                argTypes.append(self.get_type_name(arg.id))
            elif isinstance(arg, ast.Constant):
                result = self.emit_cons(arg.value, "index")
                argNames.append(result)
                argTypes.append("index")
        self.emit(f"func.call @{calleeName}({', '.join(argNames)}) : (")
        self.emit(f"{', '.join(argTypes)}) -> ()", True)
        
        if(calleeName == "softmax"):
            input = args[0].id
            inTypeNew = self.get_type_name(input)
            if input in self.castMap:
                input = self.castMap[input]
            inType = self.get_type_name(input)
            inShape = self.get_shape_from_memref_type(inType)
            output = args[1].id
            if output in self.castMap:
                output = self.castMap[output]
            outType = self.get_type_name(output)
            outShape = self.get_shape_from_memref_type(outType)
            if inShape != outShape:
                assert False, f"Error: inShape {inShape} does not match outShape {outShape} in Softmax"
            code_temp = gen_softmax(self.pl_dir, inShape, inTypeNew)
            self.mlir_pl_code = code_temp.splitlines()
            
    
    def visit_Expr(self, node):
        if isinstance(node.value, ast.Call):
            self.emit_call(node.value)
    
    def visit_Assign(self, node):
        assert len(node.targets) == 1
        target = node.targets[0]
        if isinstance(node.value, ast.Call):
            if isinstance(node.value.func, ast.Attribute):
                assert node.value.func.value.id == 'aries'
                if node.value.func.attr == 'cast':
                    targetName = target.id
                    varName = self.add_var_name(targetName, targetName)
                    args = node.value.args
                    srcMem = args[0].id
                    srcName = self.get_var_name(srcMem)
                    srcType = self.get_type_name(srcMem)
                    eleType = self.get_eletype_name(srcMem)
                    shapeTuple = args[1]
                    if isinstance(shapeTuple, ast.Tuple):
                        shape = tuple(self.extract_constant(e) for e in shapeTuple.elts)
                    else:
                        shape = [self.extract_constant(shapeTuple)]
                    dstType = self.add_type_name(targetName, eleType, shape)
                    self.emit(f"{varName} = memref.cast {srcName} : {srcType} to {dstType}")
                    # Record the cast map
                    self.castMap[targetName] = srcMem
                else:
                    raise TypeError(f"Unsupported API call in @task_top(): {node.value.func.attr}.")
            else:      
              self.emit_call(node.value)

class HostArgCollect(ast.NodeVisitor):
    def __init__(self):
        self.args = []
        self.dtypes = [] # (type, shape)
        self.outIdxs = []
    
    def convertType(self, type):
        if type == "float32":
            return "float"
        elif type == "float64":
            return "double"
        elif type == "int32":
            return "int"
        elif type == "int16":
            return "int16_t"
        elif type == "int8":
            return "int8_t"
        else:
            return type
    
    def visit_FunctionDef(self, node):
        # Get the type and shape of all the arguments
        for arg in node.args.args:
            self.args.append(arg.arg)
            if arg.annotation:
                ty = arg.annotation
                type = self.convertType(ty.value.id)
                if isinstance(ty, ast.Subscript):
                    # Extract shape
                    if isinstance(ty.slice, ast.Tuple):
                        shape = [constant.value for constant in ty.slice.elts]
                        self.dtypes.append((type, shape))
                    else:
                        shape = [ty.slice.value]
                        self.dtypes.append((type, shape))
                else:
                    assert False, "Unspported argument type found in host!"
        
        # Detect the output arguments
        for subnode in node.body:
            if isinstance(subnode, ast.Return):
                if isinstance(subnode.value, ast.Tuple):
                    for outArg in subnode.value.elts:
                        if outArg.id in self.args:
                          index = self.args.index(outArg.id)
                          self.outIdxs.append(index)

npu_host_header = """
//===----------------------------------------------------------------------===//
//
// Automatically generated file for NPU test.cpp
//
//===----------------------------------------------------------------------===//
#include <boost/program_options.hpp>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "xrt/xrt_bo.h"
#include "xrt/xrt_device.h"
#include "xrt/xrt_kernel.h"

#include "test_utils.h"

namespace po = boost::program_options;

int main(int argc, const char *argv[]) {

  // Program arguments parser
  po::options_description desc("Allowed options");
  po::variables_map vm;
  test_utils::add_default_options(desc);

  test_utils::parse_options(argc, argv, desc, vm);
  int verbosity = vm["verbosity"].as<int>();
  int do_verify = vm["verify"].as<bool>();
  int n_iterations = vm["iters"].as<int>();
  int n_warmup_iterations = vm["warmup"].as<int>();
  int trace_size = vm["trace_sz"].as<int>();

  // Load instruction
  std::vector<uint32_t> instr_v =
      test_utils::load_instr_sequence(vm["instr"].as<std::string>());
  if (verbosity >= 1)
    std::cout << "Sequence instr count: " << instr_v.size() << "\\n";

  // Get a device handle
  unsigned int device_index = 0;
  auto device = xrt::device(device_index);

  // Load the xclbin
  if (verbosity >= 1)
    std::cout << "Loading xclbin: " << vm["xclbin"].as<std::string>() << "\\n";
  auto xclbin = xrt::xclbin(vm["xclbin"].as<std::string>());

  if (verbosity >= 1)
    std::cout << "Kernel opcode: " << vm["kernel"].as<std::string>() << "\\n";
  std::string Node = vm["kernel"].as<std::string>();

  // Get the kernel from the xclbin
  auto xkernels = xclbin.get_kernels();
  auto xkernel = *std::find_if(xkernels.begin(), xkernels.end(),
                               [Node, verbosity](xrt::xclbin::kernel &k) {
                                 auto name = k.get_name();
                                 if (verbosity >= 1) {
                                   std::cout << "Name: " << name << std::endl;
                                 }
                                 return name.rfind(Node, 0) == 0;
                               });
  auto kernelName = xkernel.get_name();

  // Register the xclbin
  if (verbosity >= 1)
    std::cout << "Registering xclbin: " << vm["xclbin"].as<std::string>()
              << "\\n";
  device.register_xclbin(xclbin);

  // Get a hardware context
  if (verbosity >= 1)
    std::cout << "Getting hardware context.\\n";
  xrt::hw_context context(device, xclbin.get_uuid());

  // Get a kernel handle
  if (verbosity >= 1)
    std::cout << "Getting handle to kernel:" << kernelName << "\\n";
  auto kernel = xrt::kernel(context, kernelName);

  // Initialize input/ output buffer
  auto bo_instr = xrt::bo(device, instr_v.size() * sizeof(int),
                          XCL_BO_FLAGS_CACHEABLE, kernel.group_id(1));
  void *bufInstr = bo_instr.map<void *>();
  memcpy(bufInstr, instr_v.data(), instr_v.size() * sizeof(int));
"""


class HostCPPGenerator:
    def __init__(self, device, args, dtypes, outIdxs):
        self.device = device
        self.args = args
        self.dtypes = dtypes
        self.outIdxs = outIdxs # (type, shape)
        self.code = []
        self.group = 0 # group_id 3-7 works for host buffer
        self.indent = 2
        
    def emit(self, code, same_line=False):
        if same_line:
            self.code[-1] = self.code[-1] + code
        else:
            self.code.append(" " * self.indent + code)

    
    def emitNPUHost(self):
        self.emit(npu_host_header)
        num_arg = len(self.args)
        for i in range(num_arg):
            arg = self.args[i]
            dtype, shape = self.dtypes[i]
            size = np.prod(shape)
            self.emit(f"// Read data from files")
            self.emit(f'std::ifstream ifile{i}("data{i}.sim");')
            self.emit(f"if (!ifile{i}.is_open()) {{")
            self.indent +=2
            self.emit('std::cerr << "Error: Could not open input file.\\n";')
            self.emit('return 1;')
            self.indent -=2
            self.emit('}')
            self.emit(f"std::vector<{dtype}> srcVec{i};")
            self.emit(f"for (int i = 0; i < {size}; i++) {{")
            self.indent +=2
            self.emit(f"{dtype} num;")
            self.emit(f"ifile{i} >> num;")
            self.emit(f"srcVec{i}.push_back(num);")
            self.indent -=2
            self.emit("}")
            self.group = (self.group + 1) % 5
            group_id =  self.group + 3
            self.emit(f"auto bo_{arg} = xrt::bo(device, {size} * sizeof({dtype}),")
            self.indent +=20
            self.emit(f"XRT_BO_FLAGS_HOST_ONLY, kernel.group_id({group_id}));")
            self.indent -=20
            if i not in self.outIdxs:
                self.emit(f"// Initialized buffer")
                self.emit(f"{dtype} *buf{arg} = bo_{arg}.map<{dtype} *>();")
                self.emit(f"memcpy(buf{arg}, srcVec{i}.data(), (srcVec{i}.size() * sizeof({dtype})));\n")
        self.emit(f"// Sync input from host to device")
        self.emit(f"bo_instr.sync(XCL_BO_SYNC_BO_TO_DEVICE);")
        for i in range(num_arg):
            if i in self.outIdxs:
                continue
            arg = self.args[i]
            self.emit(f"bo_{arg}.sync(XCL_BO_SYNC_BO_TO_DEVICE);")
        self.emit('std::cout << "Warmup Kernel.\\n";')
        self.emit(f"for (int i = 0; i < n_warmup_iterations; i++) {{")
        self.indent +=2
        self.emit("unsigned int opcode = 3;")
        xrt_bos = ", ".join([f"bo_{self.args[i]}" for i in range(num_arg)])
        self.emit(f"auto run = kernel(opcode, bo_instr, instr_v.size(), {xrt_bos});")
        self.emit("run.wait();")
        self.indent -=2
        self.emit("}\n")
        self.emit("if (verbosity >= 1){")
        self.indent +=2
        self.emit('std::cout << "Running Kernel.\\n";')
        self.indent -=2
        self.emit("}\n")
        self.emit("double kernel_time_in_sec = 0;")
        self.emit( "std::chrono::duration<double> kernel_time(0);")
        self.emit("auto kernel_start = std::chrono::high_resolution_clock::now();")
        self.emit(f"for (int i = 0; i < n_iterations; i++) {{")
        self.indent +=2
        self.emit("unsigned int opcode = 3;")
        xrt_bos = ", ".join([f"bo_{self.args[i]}" for i in range(num_arg)])
        self.emit(f"auto run = kernel(opcode, bo_instr, instr_v.size(), {xrt_bos});")
        self.emit("run.wait();")
        self.indent -=2
        self.emit("}\n")
        self.emit("auto kernel_end = std::chrono::high_resolution_clock::now();")
        self.emit("kernel_time = std::chrono::duration<double>(kernel_end - kernel_start);")
        self.emit("kernel_time_in_sec = kernel_time.count()/n_iterations;")
        self.emit('std::cout << "NPU execution time: " << kernel_time_in_sec << "s\\n";\n')
        self.emit(f"// Sync output from device to host")
        for i in range(num_arg):
            if i not in self.outIdxs:
                continue
            arg = self.args[i]
            dtype, shape = self.dtypes[i]
            size = np.prod(shape)
            self.emit(f"bo_{arg}.sync(XCL_BO_SYNC_BO_FROM_DEVICE);")
            self.emit(f"{dtype} *buf{arg} = bo_{arg}.map<{dtype} *>();")
        
        fmt = '%d' if dtype.startswith("int") else '%f'
        self.emit(f"int errorCount = 0;")
        for i in range(num_arg):
            if i not in self.outIdxs:
                continue
            arg = self.args[i]
            dtype, shape = self.dtypes[i]
            self.emit(f"if(do_verify){{")
            self.indent +=2
            self.emit(f"for (int i = 0; i < {size}; i++) {{")
            self.indent +=2
            self.emit(f"if(abs((float)(srcVec{i}[i])-buf{arg}[i])>=1e-4){{")
            self.indent +=2
            self.emit(f'printf("Error found srcVec{i}[%d]!=buf{arg}[%d], {fmt}!={fmt} \\n", i, i, srcVec{i}[i], buf{arg}[i]);')
            self.emit("errorCount++;")
            self.indent -=2
            self.emit("}")
            self.indent -=2
            self.emit("}")
            self.indent -=2
            self.emit("}\n")
        
        self.emit("if (errorCount)")
        self.indent +=2
        self.emit("printf(\"Test failed with %d errors\\n\", errorCount);")
        self.indent -=2
        self.emit("else");
        self.indent +=2
        self.emit("printf(\"TEST PASSED\\n\");");
        self.indent -=2
        
        for i in range(num_arg):
            self.emit(f"ifile{i}.close();")
        self.indent -=2
        self.emit("}\n")
        
    def build(self):
        if self.device == "npu":
            self.emitNPUHost()
        return self.code

class FuncCollect(ast.NodeTransformer):
    def __init__(self):
        self.funcs = []
        self.topFunc = None
    
    def visit_FunctionDef(self, node):
        # Assume there's only one decorator for each func
        if node.decorator_list:
            decorator_id = node.decorator_list[0].func.id
            if decorator_id in ('task_kernel', 'task_top', 'task_tile'):
                self.funcs.append(node)
                if decorator_id == 'task_top':
                    self.topFunc = node

class ConstantPropagation(ast.NodeTransformer):
    def __init__(self):
        # Store constant values for propagation
        self.constant_mapping = {}
        # Worklist to process modified nodes iteratively
        self.worklist = []
        self.funcs = []
        self.topFunc = None
    
    def _clear_targets(self, targets):
      """Clear constants for modified targets."""
      for target in targets:
          if isinstance(target, ast.Name):
              self.constant_mapping.pop(target.id, None)
    
    def visit_Assign(self, node):
      """Process assignment and propagate constants."""
      self.generic_visit(node)  # Visit child nodes
      assert len(node.targets) == 1, f"Chained assignments are not supported, got {len(node.targets)}: {ast.dump(node)}"
      # Handle multiple assignments: I, J, K = 64, 64, 64
      if isinstance(node.value, (ast.Tuple, ast.List)):
          target = node.targets[0]

          # Check if target is a tuple or list of names
          if isinstance(target, (ast.Tuple, ast.List)) and len(target.elts) == len(node.value.elts):
              for idx, elt in enumerate(target.elts):
                  if isinstance(elt, ast.Name) and isinstance(node.value.elts[idx], ast.Constant):
                      # Propagate constants for tuple unpacking
                      var_name = elt.id
                      self.constant_mapping[var_name] = node.value.elts[idx]
          else:
              # Handle case where unpacking doesn't match or is invalid
              self._clear_targets(node.targets)
          return node

      # Handle simple assignment: a = 5
      if isinstance(node.value, ast.Constant) and isinstance(node.targets[0], ast.Name):
          var_name = node.targets[0].id
          self.constant_mapping[var_name] = node.value
      else:
          # Clear constants if assigned to non-constant or unknown type
        self._clear_targets(node.targets)
      return node

    def visit_Name(self, node):
        """Replace variable with its constant value if available."""
        if isinstance(node, ast.Name) and node.id in self.constant_mapping:
            # Replace with constant if propagated value exists
            return self.constant_mapping[node.id]
        return node

    def visit_BinOp(self, node):
        """Fold constant binary operations."""
        self.generic_visit(node)  # Visit child nodes

        # Check if both sides are constants
        if isinstance(node.left, ast.Constant) and isinstance(node.right, ast.Constant):
            folded_node = self._fold_constants(node)
            if folded_node is not None:
                return folded_node
        return node

    def _fold_constants(self, node):
        """Perform constant folding of binary operations."""
        try:
            left_val = node.left.value
            right_val = node.right.value
            op_type = type(node.op)

            # Evaluate the binary operation
            if op_type == ast.Add:
                result = left_val + right_val
            elif op_type == ast.Sub:
                result = left_val - right_val
            elif op_type == ast.Mult:
                result = left_val * right_val
            elif op_type == ast.Div:
                result = left_val / right_val
            elif op_type == ast.Mod:
                result = left_val % right_val
            elif op_type == ast.Pow:
                result = left_val ** right_val
            elif op_type == ast.FloorDiv:
                result = left_val // right_val
            else:
                return None

            # Return a new Constant node with the result
            return ast.Constant(value=result)
        except Exception:
            return None

class TileToLoop(ast.NodeTransformer):
    """Transform tile ranks to loops"""
    def __init__(self, grid_dims=None, ids=None):
        # tile sizes and grid ranks
        self.grid_dims = grid_dims
        self.loopIds = ids # Record the idx of reduction loops
    
    def visit_FunctionDef(self, node):
        # Extract assignment to i, j
        new_body = []
        loop_vars = {}

        for stmt in node.body:
            if (isinstance(stmt, ast.Assign) and 
                stmt.value.func.value.id == "aries" and 
                stmt.value.func.attr == "tile_ranks"):
                if isinstance(stmt.targets[0], ast.Tuple):
                    loop_var_names = [elt.id for elt in stmt.targets[0].elts]
                else:
                    loop_var_names = [stmt.targets[0].id]
                for idx, var in enumerate(loop_var_names):
                    loop_vars[var] = self.grid_dims[idx]
                continue
            
            new_body.append(stmt)

        for idx, (var, max_range) in enumerate(reversed(loop_vars.items())):
            loopId = len(loop_vars) -1 - idx
            if self.loopIds and loopId in self.loopIds:
              idName = "reduce_range"
            else:
              idName = "range"
            new_body = [ast.For(
                target=ast.Name(id=var, ctx=ast.Store()),
                iter=ast.Call(
                    func=ast.Name(id=idName, ctx=ast.Load()),
                    args=[ast.Constant(value=0), ast.Constant(value=max_range)],
                    keywords=[]
                ),
                body=new_body,
                orelse=[]
            )]
        node.body = new_body  # Replace function body with transformed version
        return node

# Traverse the tree for constant propagation and record arange info
class TilePreprocess(ast.NodeTransformer):
    def __init__(self, grid_dims=None, tile_sizes=None):

        # tile sizes and grid ranks
        self.grid_dims = grid_dims
        self.tile_sizes = tile_sizes

        # Record the constant value
        self.constant_mapping = {}
        
        # Record the offset, size, step information from aries.arange
        self.dmaInfo = {} # dic["ti"] = (32*i, 32, 1) (offset, size, step)
        self.startExpr = None
        self.stopExpr = None
        self.stepExpr = sp.Integer(1) # Default step is 1 if not assigned

    def visit_FunctionDef(self, node):
        # Traverse function body and update
        node.body = [self.visit(statement) for statement in node.body]
        return node
    
    def generic_visit(self, node):
        return super().generic_visit(node)
    
    # Recursively converts a nested BinOp AST node into a SymPy expression
    def arange_to_sympy(self, node):
        if isinstance(node, ast.BinOp):
            left = self.arange_to_sympy(node.left)  # Recursively process left operand
            right = self.arange_to_sympy(node.right)  # Recursively process right operand

            if isinstance(node.op, ast.Add):
                return left + right
            elif isinstance(node.op, ast.Sub):
                return left - right
            elif isinstance(node.op, ast.Mult):
                return left * right
            elif isinstance(node.op, ast.Div):
                return left / right
            elif isinstance(node.op, ast.Mod):
                return left % right
            elif isinstance(node.op, ast.Pow):
                return left**right
            else:
                raise ValueError(f"Unsupported operation: {node.op}")

        elif isinstance(node, ast.Name):
            return sp.Symbol(node.id)  # Convert variable names to SymPy symbols
        elif isinstance(node, ast.Constant):
            return sp.Integer(node.value)  # Convert constants to SymPy Integers

        raise ValueError(f"Unsupported node type: {type(node)}")
    
    def visit_Assign(self, node):
        assert len(node.targets) == 1
        target = node.targets[0]
        
        if isinstance(node.value, ast.Call):
            assert isinstance(node.value.func, ast.Attribute)
            assert isinstance(node.value.func.value, ast.Name)
            assert node.value.func.value.id == 'aries'
            
            # TI, TJ, TK = tile_sizes()
            # Record the tile size which are constant values
            if node.value.func.attr == "tile_sizes":
                if isinstance(target, ast.Tuple):
                    assert len(target.elts) == len(self.tile_sizes)
                    for i, tsize in enumerate(self.tile_sizes):
                        self.constant_mapping[target.elts[i].id] = int(tsize)
                    return None
                else:
                    tsize = self.tile_sizes
                    self.constant_mapping[target.id] = int(tsize)
                    return None
            
            # Need to visit the nested nodes to propagate constants and 
            # record the arange Info
            elif node.value.func.attr == "arange":
                call = node.value
                # Recursively visit and propagate constants
                call.args = [self.visit(arg) for arg in call.args]
                self.startExpr = None
                self.stopExpr = None
                self.stepExpr = sp.Integer(1)
                # Record the arange information
                for idx, arg in enumerate(call.args):
                    if idx == 0: # Processes start
                        self.startExpr = self.arange_to_sympy(arg)
                    elif idx == 1: # Processes stop
                        self.stopExpr = self.arange_to_sympy(arg)
                    elif idx == 1: # Processes step
                        self.stepExpr = self.arange_to_sympy(arg)
                # offset = start, size = (stop-start)/step
                sizeExpr = (self.stopExpr-self.startExpr) / self.stepExpr
                coeffs = sizeExpr.as_coefficients_dict()
                for coeff in coeffs.values():
                    assert coeff.is_integer, f"Non-integer coefficient found: {coeff}"
                sp.simplify(self.startExpr)
                sp.simplify(sizeExpr)
                sp.simplify(self.stepExpr)
                self.dmaInfo[target.id] = (self.startExpr, sizeExpr, self.stepExpr)
                return node
            
            elif node.value.func.attr == "buffer" or node.value.func.attr == "accbuffer":
                call = node.value
                # Recursively visit and propagate constants
                call.args = [self.visit(arg) for arg in call.args]
                return node
            
            elif node.value.func.attr in ["load", "store", "accstore"]:
                return node
            
            else:
                raise ValueError(
                    f"Unsupported function call: {node.value.func.attr}")
        return node
    
    def visit_Name(self, node):
        # Replace variable names in constant_mapping with their corresponding values
        if node.id in self.constant_mapping:
            return ast.Constant(value=self.constant_mapping[node.id], kind=None)
        return node

    def visit_BinOp(self, node):
        # Recursively replace variable names inside binary operations
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        return node

# =======  Preprocess for task_kernel ===========
# This is a hurestic function that count the number of input and output args
# of the sinlge kernel, and will be used to determine the placement algo
class preKernel(ast.NodeVisitor):
    def __init__(self):
      self.cntIn = 0
      self.cntOut = 0
      self.memref = []
      self.outmem = []
      self.externPath = None
      self.paraList = []
      self.funcName = ""
      
    def visit_FunctionDef(self, node):
        self.funcName = node.name
        for arg in node.args.args:
            if arg.annotation:
                ty = arg.annotation
                if isinstance(ty, ast.Subscript):
                    if arg.arg not in self.memref:
                        self.memref.append(arg.arg)
                        self.cntIn += 1
        # Get the external_path of the kernel
        if len(node.decorator_list) != 0:
            decorator = node.decorator_list[0]
            for i in range(len(decorator.keywords)):
                keyword = decorator.keywords[i]
                if keyword.arg == 'external_path':
                    self.externPath = keyword.value.value
                elif keyword.arg == 'para':
                    self.paraList = [elt.value for elt in keyword.value.elts]
        self.generic_visit(node)
    
    def visit_Assign(self, node):
        assert len(node.targets) == 1
        target_node = node.targets[0]
        if isinstance(target_node, ast.Subscript):
            memref = target_node.value.id
            if memref not in self.outmem:
                self.outmem.append(memref)
                self.cntIn -= 1
                self.cntOut += 1
    
    def visit_AugAssign(self, node):
        target_node = node.target
        if isinstance(target_node, ast.Subscript):
            memref = target_node.value.id
            if memref not in self.outmem:
                self.outmem.append(memref)
                self.cntIn -= 1
                self.cntOut += 1

# =========== Schedule ===========
class Schedule:
    def __init__(self, *tasks):
        self.tasks = tasks
        self.constants = {}
        self.subName = "project"
        self.mlir_func_code = []
        self.mlir_pl_code = []
        self.mlir_map_code = [] # AffineMap should be defined outside of Module
        self.map_cnt = 0
        self.paraSize = {} # paraSize[task] = factor[]
        self.l2Size = {} # l2Size[task] = factor[]
        self.bufSel = {} # bufsel[task] = factor[] # 1:BRAM, 0: URAM
        self.placement = [] # ColNum, RowNum, ColOffset, RowOffset, ColGap, FirstCol, NumShim, MidLine, ChalIn, ChalOut
        self.placeAlgo = [2, "true"] # CoreAlgo, EnableIOCons
        self.linkFile = "false"
        self.AIEVectorize = {} # AIEVectorize[task] = factor,  Default 8
        self.AIEUnroll = {} # AIEUnroll[task] = factor,  Default 1
        self.AIEUnrollOption = {}  # 0:unroll-factor; 1:unroll-full-threshold
        self.IOWidth = {} # IOWidth[task]= width, Default 128
        self.AXIWidth = {} # AXIWidth[task]= width, Default 512
        self.en_pl = "true"
        self.en_aie2 = "false"
        self.linkPath = ""
        self.freqPL = 250  #Set the PL frequency
        self.paraList = []
        self.funcs= []
        self.krlName = "" 
        self.topFunc = []
        self.funName = ""
        self.device = ""
        self.temp_dir = "./"
    
    def link_kernel_info(self, parsed_ast):
        instance = preKernel()
        instance.visit(parsed_ast)
        if instance.cntIn <= 2:
            self.placeAlgo = [1, "false"] # CoreAlgo, EnableIOCons
        else:
            self.placeAlgo = [2, "true"]
        if instance.externPath != None:
            self.linkFile = "true"
            self.linkPath = instance.externPath
        if len(instance.paraList) != 0:
            self.paraList = instance.paraList
        self.funName = instance.funcName
    
    def preprocess(self, module):
        """Propagate the global constant to the function_wappers and get the
        function wappers"""
        # Perform constant folding
        if isinstance(module, types.ModuleType):
            source_code = inspect.getsource(module)
        elif isinstance(module, str):
            source_code = module
        else:
            raise TypeError("Expected a module or source code string")
        parsed_ast = ast.parse(source_code)
        ins_propagate = ConstantPropagation()
        tree = ins_propagate.visit(parsed_ast)
        ast.fix_missing_locations(tree)
        # print("Parsed AST after constant folding", ast.dump(tree, indent=4))
        # print(astor.to_source(tree))
        
        # Collect the function wrappers
        ins_func = FuncCollect()
        ins_func.visit(tree)
        self.funcs = ins_func.funcs
        self.topFunc = ins_func.topFunc
        
    
    def task_tile_emit(self, func_name, parsed_ast):
        # print("Parsed New AST 0", ast.dump(parsed_ast, indent=4))
        task = None
        # TODOs: Now assumes tasks has unique funcs 
        for task_temp in self.tasks:
            if task_temp.func.__name__ == func_name:
                task = task_temp
                break
        # Transform the tile ranks to index
        if task.grid_dims:
          tileTrans = TileToLoop(task.grid_dims)
          tree = tileTrans.visit(parsed_ast)
        else:
          tree = parsed_ast
        ast.fix_missing_locations(tree)
        # print("Parsed New AST 0", ast.dump(tree, indent=4))
        # print("\n\n\n=== Python AST 0 code ===")
        # print(astor.to_source(tree))
        
        # Collect dmaInfo and conduct constant propagation
        preInstance = TilePreprocess(task.grid_dims, task.tile_sizes)
        tree = preInstance.visit(tree)
        ast.fix_missing_locations(tree)
        dmaInfo = preInstance.dmaInfo
        # print("Parsed New AST 1", ast.dump(tree, indent=4))
        
        # Add func and map code
        func_code, map_code, self.map_cnt = TileMLIRGenerator(dmaInfo, self.map_cnt).generate(tree)
        self.mlir_func_code.append(func_code)
        self.mlir_map_code.append(map_code)
        # print(func_code)
    
    def task_kernel_emit(self, parsed_ast):
        # print("Parsed AIE Kernel AST", ast.dump(parsed_ast, indent=4))
        self.link_kernel_info(parsed_ast)
        func_code, map_code, self.map_cnt = KernelMLIRGenerator(None, self.map_cnt, self.device, self.linkFile).generate(parsed_ast)
        self.mlir_func_code.append(func_code)
        self.mlir_map_code.append(map_code)
        # print(func_code)
    
    def task_top_emit(self, parsed_ast):
        # print("Parsed Top AST", ast.dump(parsed_ast, indent=4))
        func_code, map_code, self.map_cnt = TopMLIRGenerator(None, self.temp_dir, self.map_cnt).generate(parsed_ast)
        self.mlir_func_code.append(func_code)
        self.mlir_map_code.append(map_code)
        # print(func_code)
    
    def host_emit(self, sub_dir):
        # Get the arguements
        # print("Parsed Host AST", ast.dump(self.topFunc, indent=4))
        instance = HostArgCollect()
        instance.visit(self.topFunc)
        temp_code = HostCPPGenerator(self.device, instance.args,instance.dtypes,instance.outIdxs).build()
        host_code = "\n".join(filter(None, temp_code))
        sim_files = glob.glob("*.sim")
        if sim_files:
            cmd = ["mv"] + sim_files + [sub_dir]
            subprocess.run(cmd)
        host_file = sub_dir / "host/host.cpp" 
        with open(host_file, "w") as file:
            print(host_code, file=file)
    
    def code_gen(self):
        for parsed_ast in self.funcs:
            decorator_id = None
            func_name = None
            # Identify the decorators
            for node in ast.walk(parsed_ast):
                if isinstance(node, ast.FunctionDef):
                    # Assume there's only one decorator for each func
                    decorator_id = node.decorator_list[0].func.id
                    func_name = node.name
                    break
            if decorator_id is None:
                continue
            if decorator_id == 'task_kernel':
                self.krlName = func_name
                self.task_kernel_emit(parsed_ast)
                continue
            elif decorator_id == 'task_tile':
                self.task_tile_emit(func_name, parsed_ast)
                continue
            elif decorator_id == 'task_top':
                self.task_top_emit(parsed_ast)
                continue
            else:
                raise ValueError(f"Unsupported decorator: {decorator_id}")
        final_map_code = "\n".join(filter(None, self.mlir_map_code))
        final_lib_code = "\n".join(filter(None, self.mlir_pl_code))
        final_func_code = "\n".join(filter(None, self.mlir_func_code))
        return final_map_code, final_lib_code, final_func_code
        
    def code_emit(self, prj_dir):
        final_map_code, final_lib_code, final_func_code = self.code_gen()
        mlir_file = prj_dir / "aries.mlir" 
        with open(mlir_file, "w") as file:
            print(final_map_code, file=file)
        with open(mlir_file, "a") as file:
            print("module {", file=file)
            print(final_lib_code, file=file)
            print(final_func_code, file=file)
            print("}", file=file)
    
    def genAriesMake(self, prj_dir, temp_dir):
        if len(self.tasks)==0:
            func = None
            paraSize, l2Size, bufSel = [1], [1], [0]
            AIEVectorize = 8
            AIEUnroll = 1
            AIEUnrollOption = 0
            AXIWidth = 512
            IOWidth = 128
        else:
            task = self.tasks[0]
            func = task.func.__name__
            length = len(task.grid_dims) if task.grid_dims else len(task.call_args)
            paraSize = self.paraSize.get(task, [1] * length)
            l2Size = self.l2Size.get(task, [1] * length)
            bufSel = self.bufSel.get(task, [0] * len(task.call_args))
            AIEVectorize = self.AIEVectorize.get(task, 8)
            AIEUnroll = self.AIEUnroll.get(task, 1)
            AIEUnrollOption = self.AIEUnrollOption.get(task, 0)
            AXIWidth = self.AXIWidth.get(task, 512)
            IOWidth = self.IOWidth.get(task, 128)
        pipeline_op = "aries-pipeline-versal"
        if self.device == "npu":
          pipeline_op = "aries-pipeline"
          IOWidth = 32
        gen_make_aries(prj_dir, temp_dir, self.subName, func, paraSize, l2Size, 
                       self.placement, self.placeAlgo, self.linkFile,
                       AIEVectorize, AIEUnroll, AIEUnrollOption, 
                       bufSel, IOWidth, AXIWidth, self.en_pl, 
                       self.en_aie2, pipeline_op)
    
    def genNPUMake(self, sub_dir, temp_dir):
        task = self.tasks[0]
        func = task.func.__name__
        temp_dir = Path(temp_dir)
        krlName = self.krlName
        gen_make_npu(sub_dir, temp_dir, func, krlName)
    
    def genVersalMake(self, sub_dir, temp_dir):
        temp_dir = Path(temp_dir)
        gen_make_versal(sub_dir, temp_dir, self.freqPL)
    
    def genKernel(self, sub_dir, temp_dir):
        if self.linkFile!="false":
            gen_kernel(sub_dir, temp_dir, self.linkPath, self.paraList, self.funName)
    
    def ioWidth(self, task, width = 128):
        self.IOWidth[task] = width
        
    def axiWidth(self, task, width = 512):
        self.AXIWidth[task] = width
    
    def aieVector(self, task, factor = 8):
        self.AIEVectorize[task] = factor
    
    def aieUnroll(self, task, factor = 8, option = 0):
        self.AIEUnroll[task] = factor
        self.AIEUnrollOption[task] = option
    
    def parallel(self, task, factor=[]):
        self.paraSize[task] = factor
    
    def l2buffer(self, task, factor=[]):
        self.l2Size[task] = factor
    
    def bufsel(self, task, factor=[]):
        self.bufSel[task] = factor
        
    def freqpl(self, freq):
        self.freqPL = freq
    
    def to(self, device):
        if device == "VCK190" or device == "vck190":
            self.device = "vck190"
            # ColNum, RowNum, ColOffset, RowOffset, ColGap, FirstCol, NumShim, MidLine, ChalIn, ChalOut
            self.placement= [50, 8, 0, 0, 0, 6, 39, 24, 3, 3]
        elif device == "NPU" or device == "npu":
            self.device = "npu"
            self.placement= [4, 6, 0, 2, 0, 0, 4, 1, 6, 6]
            self.en_pl = "false"
            self.en_aie2 = "true"
    
    def gemm_model(self, task, data_type):
        if data_type in ["float32", "float", "fp32", "int", "int32"]:
            BPE = 4
        elif data_type in ["int16"]:
            BPE = 2
        elif data_type in ["int8"]:
            BPE = 1
        else:
            raise ValueError(f"Unsupported data type: {data_type}")
        
        if not hasattr(task, 'grid_dims'):
            raise AttributeError(f"Expected 'task' to have attribute 'grid_dims': {type(task)}")
        if not hasattr(task, 'tile_sizes'):
            raise AttributeError(f"Expected 'task' to have attribute 'tile_sizes': {type(task)}")
        grids = task.grid_dims
        tile_sizes = task.tile_sizes
        array_sizes = np.array(grids) * np.array(tile_sizes)
        length = len(task.grid_dims)
        paraSize = self.paraSize.get(task, [1] * length)
        l2Size = self.l2Size.get(task, [1] * length)
        bufSel = self.bufSel.get(task, [0] * len(task.call_args))
        AXIWidth = self.AXIWidth.get(task, 512)
        IOWidth = self.IOWidth.get(task, 128)
        gemm_result(array_sizes, tile_sizes, paraSize, l2Size, BPE, AXIWidth, IOWidth, bufSel)
    
    def folder_create(self, sub_dir):
        if Path(sub_dir).exists():
            print(f"Directory '{sub_dir}' already exists, skipping creation.")
        else:
            Path(sub_dir).mkdir(parents=True)
            print(f"Created directory: {sub_dir}")
        for subdir in ["aie", "kernel", "host"]:
            subdir_path = Path(sub_dir, subdir)
            if subdir_path.exists():
                print(f"Directory '{subdir_path}' already exists, skipping creation.")
            else:
                subdir_path.mkdir(parents=True)
                print(f"Created directory: {subdir_path}")
    
    def genPrjMake(self, sub_dir, temp_dir):
        makeDst = os.path.join(sub_dir, "Makefile")
        if self.device == "vck190":
            # Copy Makefile for Vitis Flow
            if os.path.exists(makeDst):
                print(f"Warning: {makeDst} already exists!")
            else:
                self.genVersalMake(sub_dir, temp_dir)
                #command = f"cp -r {temp_dir}/Makefile_VCK190 {makeDst}"
                #subprocess.run(command, shell=True, check=True)
        elif self.device == "npu":
            # Generate the NPU Makefile and Host Code here
            command = f"cp -r {temp_dir}/CMake/CMakeLists.txt {sub_dir}"
            subprocess.run(command, shell=True, check=True)
            if os.path.exists(makeDst):
                print(f"Warning: {makeDst} already exists!")
            else:
                self.genNPUMake(sub_dir, temp_dir)
    
    def print_mlir(self, module):
        self.preprocess(module)
        final_map_code, final_lib_code, final_func_code = self.code_gen()
        print(final_map_code)
        print("module {")
        print(final_lib_code)
        print(final_func_code)
        print("}")
        return final_map_code, final_lib_code, final_func_code
    
    def check_vitis_env(self, version="2023.2"):
      cmd = f"source /tools/Xilinx/Vitis/{version}/settings64.sh && source /opt/xilinx/xrt/setup.sh && echo 'Vitis environment loaded successfully'"
      try:
          result = subprocess.run(
              ["bash", "-c", cmd],
              check=True,
              stdout=subprocess.PIPE,
              stderr=subprocess.PIPE,
              text=True
          )
          print("✅ Vitis environment loaded.")
          print("Output:", result.stdout.strip())
          return True
      except subprocess.CalledProcessError as e:
          print("❌ Failed to source Vitis environment.")
          print("Error:", e.stderr.strip())
          return False
    
    def run_make(self, aries_dir, prj_dir, edge_image_dir, target):
        # Add aries-opt to the PATH
        aries_opt_dir = os.path.join(aries_dir, "build/bin")
        env = os.environ.copy()
        env["PATH"] = aries_opt_dir + ":" + env["PATH"]
        prj_dir = os.path.abspath(prj_dir)
        
        # Step 1: Run make all in prj_dir
        try:
            subprocess.run(
                ["bash", "-c", "make clean || true && make all"],
                cwd=prj_dir,
                env=env,
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.PIPE,
                text=True
            )
            print(f"✅ make all in {prj_dir} succeeded")
        except subprocess.CalledProcessError as e:
            print(f"❌ make all in {prj_dir} failed")
            print(e.stderr)
            return
        
        
        
        # Step 2: If target is specified, run Vitis backend
        if target:
            if target == "report":
                project_dir = os.path.join(prj_dir, "project")
                version = "2023.2"
                if not self.check_vitis_env(version):
                    raise EnvironmentError("❌ Vitis environment is not properly set up.")
                try:
                    # Run `make kernels`
                    cmd_kernels = f"source /tools/Xilinx/Vitis/{version}/settings64.sh && make kernels"
                    subprocess.run(cmd_kernels, shell=True, check=True, cwd=project_dir, executable="/bin/bash")
                    # Run `make aie`
                    cmd_aie = f"source /tools/Xilinx/Vitis/{version}/settings64.sh && make aie"
                    subprocess.run(cmd_aie, shell=True, check=True, cwd=project_dir, executable="/bin/bash")
                    print("✅ Report generation (make kernels & make aie) succeeded.")
                except subprocess.CalledProcessError as e:
                    raise RuntimeError(f"❌ Report generation failed: {e}")
                return  # Exit early after report generation
            
            if target not in ["sw_emu", "hw_emu", "hw"]:
                raise ValueError(f"❌ Invalid target '{target}'. Must be one of: sw_emu, hw_emu, hw.")
            
            if not edge_image_dir:
                raise EnvironmentError("❌ Versal image not properly set up.")
            version="2023.2"
            if not self.check_vitis_env(version):
                raise EnvironmentError("❌ Vitis environment is not properly set up.")
            assert target in {"sw_emu", "hw_emu", "hw"}, f"Invalid target: {target}"
            project_dir = os.path.join(prj_dir, "project")
            cmd = f"source /tools/Xilinx/Vitis/{version}/settings64.sh && source /opt/xilinx/xrt/setup.sh && make all TARGET={target} EDGE_COMMON_SW_PATH={edge_image_dir}"
            try:
                process = subprocess.Popen(
                    cmd,
                    shell=True,
                    executable="/bin/bash",
                    cwd=project_dir,
                    env=env,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    bufsize=1,
                    universal_newlines=True,
                )
                for line in process.stdout:
                    print(line, end="")
                process.wait()
                if process.returncode == 0:
                    print(f"✅ make all TARGET={target} in {project_dir} succeeded")
                else:
                    print(f"❌ make all TARGET={target} in {project_dir} failed with code {process.returncode}")
            except Exception as e:
                print(f"❌ make all TARGET={target} in {project_dir} failed with exception")
                print(e)
    
    def build(self, module, prj_dir="./my_project", temp_dir="./templates"):
        self.mlir_func_code = []
        self.mlir_pl_code = []
        self.mlir_map_code = []
        prj_dir = Path(prj_dir)
        sub_dir = Path(prj_dir) / self.subName
        self.temp_dir = temp_dir
        self.folder_create(sub_dir)
        self.preprocess(module)
        self.code_emit(prj_dir)
        self.host_emit(sub_dir)
        self.genAriesMake(prj_dir, temp_dir)
        self.genPrjMake(sub_dir, temp_dir)
        self.genKernel(sub_dir, temp_dir)
    
    def compile(self, aries_dir, prj_dir, edge_image_dir=None, target=None):
        self.run_make(aries_dir, prj_dir, edge_image_dir, target)