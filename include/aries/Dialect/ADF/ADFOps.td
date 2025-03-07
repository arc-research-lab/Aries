#ifndef ARIES_DIALECT_ARIES_ADF_OPS_TD
#define ARIES_DIALECT_ARIES_ADF_OPS_TD

include "ADFDialect.td"
include "ADFTypes.td"

// Base class for ADF operations 
class ADF_Op<string mnemonic, list<Trait> traits = []> :
    Op<ADF_Dialect, mnemonic, traits>;

def GraphOp : ADF_Op<"graph", [Pure]> {
  let summary = "An operation presenting an ADF graph";
  let description = [{
    This is an operation to represent an ADF graph.  This operation includes
    the other defined operations in ADF dialect including the GraphOp as well. 

    ```mlir
    %plio_in = adf.plio.create() : !adf.plio<In, 128>
    %gmio_in = adf.gmio.create() : !adf.gmio<In, 128>
    adf.graph(%plio_in,%gmio_in){
    
    } : (!adf.plio<In, 128>, !adf.gmio<In, 128>)
    ```
  }];

  let arguments = (ins Variadic<GraphIOType>:$input_ports);
  let regions = (region AnyRegion:$region);
  let assemblyFormat = [{
    `(` $input_ports `)` regions attr-dict `:` `(` type($input_ports) `)`
    }];
}

def GraphReturnOp : ADF_Op<"return", [HasParent<"GraphOp">, Pure, Terminator]>{
  let summary = "Terminator for adf graph regions.";
  let description = [{
    This is a terminator op for the adf.graph region which returns the GraphIOType.
  }];
  
  let arguments = (ins Variadic<GraphIOType>:$output_ports);

  let builders = [OpBuilder<(ins), [{
    build($_builder, $_state, std::nullopt);
  }]>];

  let assemblyFormat = "attr-dict ($output_ports^ `:` type($output_ports))?";
}

def CellOp : ADF_Op<"cell", [SingleBlock]> {
  let summary = "An operation identify the adf cell region";
  let arguments = (ins FlatSymbolRefAttr:$cell_name);
  let regions = (region SizedRegion<1>:$body);
  let assemblyFormat = [{
      $cell_name regions attr-dict
    }];
}

def EndCellOp : ADF_Op<"cell.end", [HasParent<"CellOp">, Pure, Terminator]>{
  let summary = "Terminator for adf cell region.";
  let assemblyFormat = "attr-dict";
}

def LaunchCellOp : ADF_Op<"cell.launch", [SingleBlock]> {
  let summary = "An operation to identify the accelerator part";
  let description = [{
    This op is currently used to identify the part run on the adf.cell. It
    could be useful for to generate the buffer.sync barriers in the host code.
  }];
  let regions = (region SizedRegion<1>:$body);
  let arguments = (
    ins FlatSymbolRefAttr:$callee
  );
  let assemblyFormat = [{
      $callee regions attr-dict
    }];
}

def WaitLaunchCellOp : ADF_Op<"cell.launch.wait", []>{
  let summary = "An operation that wait for the adf.cell";
  let assemblyFormat = [{
    attr-dict
  }];
}

def EndLaunchCellOp : ADF_Op<"cell.launch.end", [HasParent<"LaunchCellOp">, 
                            Pure, Terminator]>{
  let summary = "Terminator for adf.cell.launch region.";
  let assemblyFormat = "attr-dict";
}

def LaunchPLOp : ADF_Op<"pl.launch", [SingleBlock]> {
  let summary = "An operation to identify the PL part";
  let description = [{
    This op is currently used to identify the part run on the adf.pl. It
    could be useful for to generate the buffer.sync barriers in the host code.
  }];
  let regions = (region SizedRegion<1>:$body);
  let arguments = (
    ins FlatSymbolRefAttr:$callee
  );
  let assemblyFormat = [{
      $callee regions attr-dict
    }];
}

def WaitLaunchPLOp : ADF_Op<"pl.launch.wait", [HasParent<"LaunchPLOp">, 
                            Pure, Terminator]>{
  let summary = "An operation that wait for the adf.pl";
  let assemblyFormat = [{
    attr-dict
  }];
}

def KernelOp : ADF_Op<"kernel", [Pure]> {
  let summary = "ADF Dialcet CallOp";
  let description = [{
    This operation is the Callop function in ADF dialect which creates and calls
    the single kernel runs on an AIE. It takes the arguments with KernelIOType
    as inputs and will also return the KernelIOType outputs. Thus the direction
    information (in or out or inout) can be attached.

    ```mlir
      %out = adf.kernel @kernel(%0, %1) :
              (memref<32x32xf32>, !cascade) -> !cascade
    ```
  }];

  let arguments = (ins FlatSymbolRefAttr:$callee, 
                  Variadic<KernelIOType>:$kernel_inputs);
  let results = (outs Variadic<KernelIOType>:$kernel_outputs);

  let assemblyFormat = [{
    $callee `(` $kernel_inputs `)` attr-dict 
    `:` functional-type($kernel_inputs, results)
  }];
}


// -------------
// Operations to create GraphIOType
// -------------

//This may replace the seperated operations above PORTOp, PLIOOp, GMIOOp
def CreateGraphIOOp : ADF_Op<"graph.io", []> {
  let summary = "graph input/output creation";
  let description = [{
    This operation creates either PLIO, GMIO or Port.

    ```mlir
      %plio0 = adf.graph.io(PLIO) : !adf.plio<In,128> 
      %gmio0 = adf.graph.io(GMIO) : !adf.gmio<In>
      %port0 = adf.graph.io(PORT) : !adf.port<In>
    ```
  }];

  let arguments = (ins GraphIOName: $name);
  let results = (outs GraphIOType:$graphio);
  let assemblyFormat = " `(` $name `)` attr-dict `:` type(results)";

  let hasCanonicalizer = 1;
}

def ConfigPLIOOp : ADF_Op<"config.plio", []> {
  let summary = "Set PLIO width and frequency";
  let description = [{
    This operation sets port width and the frequency(MHz) of PLIO 
    in the ADF Graph.

    ```mlir
      %plio0 = adf.graph.io(PLIO) : !adf.plio<In>
      adf.config.plio(%plio0, 250)
    ```
  }];

  let arguments = (ins PLIOType:$plio, I32Attr:$frequency);
  let assemblyFormat = [{ 
    `(` $plio `,` $frequency `)` attr-dict `:` type($plio)
  }];
  let hasCanonicalizer = 1;
}

def ConfigGMIOOp : ADF_Op<"config.gmio", []> {
  let summary = "GMIO burst size and bandwidth";
  let description = [{
    This operation set the burst size(64,128,256) in bytes and required 
    bandwidth(MB/s) of GMIO in the ADF Graph.

    ```mlir
      %gmio0 = adf.graph.io(GMIO) : !adf.gmio<In>
      adf.config.gmio(%gmio0,256,1000)
    ```
  }];

  let arguments = (ins GMIOType:$gmio, PortBurst:$burst, I32Attr:$bandwidth);
  let assemblyFormat = [{
    `(` $gmio `,` $burst `,` $bandwidth `)` attr-dict `:` type($gmio)
  }];
  let hasCanonicalizer = 1;
}

// -------------
// Operations to create KernelIOType
// -------------

def BufferOp : ADF_Op<"buffer.create", []> {
  let summary = "buffer creation";
  let description = [{
    This operation creates a buffer.

    ```mlir
      %buffer0 = adf.buffer.create() : memref<32x32xi32>
    ```
  }];
  let arguments = (ins FlatSymbolRefAttr:$symbol);
  let results = (outs AnyMemRef:$buffer);
  let assemblyFormat = " $symbol `(``)` attr-dict `:` type(results)";
  let hasCanonicalizer = 1;
}

def StreamOp : ADF_Op<"stream.create", []> {
  let summary = "stream creation";
  let description = [{
    This operation creates a stream.

    ```mlir
      %stream0 = adf.stream.create() : !adf.stream
    ```
  }];

  let results = (outs StreamType:$stream);
  let assemblyFormat = " `(``)` attr-dict `:` type(results)";

}

def CascadeOp : ADF_Op<"cascade.create", []> {
  let summary = "cascade creation";
  let description = [{
    This operation creates a cascade.

    ```mlir
      %cascade0 = adf.cascade.create() : !adf.cascade
    ```
  }];

  let results = (outs CascadeType:$cascade);
  let assemblyFormat = " `(``)` attr-dict `:` type(results)";

}

//This may replace the seperated operations above BufferOp, StreamOp, CascadeOp
def CreateKernelIOOp : ADF_Op<"kernel.io", []> {
  let summary = "kernel input/output creation";
  let description = [{
    This operation creates either buffer, stream or cascade.

    ```mlir
      %buffer0  = adf.kernel.io() : memref<32x32xi32>
      %stream0  = adf.kernel.io() : !adf.stream
      %cascade0 = adf.kernel.io() : !adf.cascade
    ```
  }];

  let arguments = (ins KernelIOName: $name);
  let results = (outs KernelIOType:$kernelarg);
  let assemblyFormat = " `(` $name `)` attr-dict `:` type(results)";
}

// -------------
// Operations for connecting the ADF Graph
// -------------

def DmaOp: ADF_Op<"dma", [AttrSizedOperandSegments]> {
  let summary = "This is a dma operator that copy data between memrefs";
  let description = [{
    This is a dma operator that copy data between memrefs
  }];
  let arguments = (
    ins AnyMemRef:$src,
        Variadic<Index>:$src_offsets,
        Variadic<Index>:$src_sizes,
        Variadic<Index>:$src_strides,
        Variadic<Index>:$src_tiles,
        Variadic<Index>:$src_dims,
        Variadic<Index>:$src_steps,
        Variadic<Index>:$src_wraps,
        AnyMemRef:$dst,
        Variadic<Index>:$dst_offsets,
        Variadic<Index>:$dst_sizes,
        Variadic<Index>:$dst_strides,
        Variadic<Index>:$dst_tiles,
        Variadic<Index>:$dst_dims,
        Variadic<Index>:$dst_steps,
        Variadic<Index>:$dst_wraps
  );
  let assemblyFormat = [{
    `(` $src `[` ($src_offsets^)? `]``[` ($src_sizes^)? `]``[` ($src_strides^)? `]` 
             `[` ($src_tiles^)? `]``[` ($src_dims^)? `]``[` ($src_steps^)? `]` `[` ($src_wraps^)? `]` `,`
        $dst `[` ($dst_offsets^)? `]``[` ($dst_sizes^)? `]``[` ($dst_strides^)? `]` 
             `[` ($dst_tiles^)? `]``[` ($dst_dims^)? `]``[` ($dst_steps^)? `]` `[` ($dst_wraps^)? `]`
      `)`  attr-dict `:`
    `(` type($src) `,` type($dst) `)`
  }];
  let hasVerifier = 1;
}

def DmaBroadcastOp: ADF_Op<"dma.broadcast", [AttrSizedOperandSegments]> {
  let summary = "This is a dma broadcast operator that copy data between memrefs";
  let description = [{
    This is a dma broadcast operator that allows one source memory to be 
    broadcast to different dsts
  }];
  let arguments = (
    ins AnyMemRef:$src,
        Variadic<Index>:$src_offsets,
        Variadic<Index>:$src_sizes,
        Variadic<Index>:$src_strides,
        Variadic<AnyMemRef>:$dst,
        Variadic<Index>:$dst_offsets,
        Variadic<Index>:$dst_sizes,
        Variadic<Index>:$dst_strides
  );
  let assemblyFormat = [{
    `(` $src `[` ($src_offsets^)? `]``[` ($src_sizes^)? `]``[` ($src_strides^)? `]` `,`
        `{` $dst `}` `[` ($dst_offsets^)? `]``[` ($dst_sizes^)? `]``[` ($dst_strides^)? `]` `)`  attr-dict `:`
    `(` type($src) `,` type($dst) `)`
  }];
}

def ConnectOp : ADF_Op<"connect", []> {
  let summary = "Connect graph input/output and kernel arguments";
  let description = [{
    This operation builds up a connection between graph input/output and kernel
    arguments. This should be translate to the connect api in adf C/C++.

    ```mlir
      %plio = adf.plio.create() : !adf.plio<In>
      %buffer0 = adf.buffer.create() : memref<32x32xi32>
      adf.connect(%plio, %buffer0) : (!adf.plio<In>, memref<32x32xi32>)
    ```
  }];
  let arguments = (ins ConnectType:$src, ConnectType:$dst);
  let assemblyFormat = " `(` $src `,` $dst `)` attr-dict `:` `(` type($src) `,` type($dst) `)`" ;

}

def IOPushOp: ADF_Op<"io.push", [AttrSizedOperandSegments]> {
  let summary = "Push the externel memory to a graph io";
  let description = [{
    It creates an operation to connect the externel memory 
    (out of aie) with the graph io.

    It pushes an N-dimension of data in one memref to an ADF IO.

    ```mlir
      %mem0 = memref.alloc() : memref<64x64xf32>
      %plio0 = adf.graph.io(PLIO) : !adf.plio<In>
      adf.io.push(%mem0[0, 0][32, 32][1, 1], %plio0) 
      : (memref<64x64xf32>, !adf.plio<In>)
    ```
  }];
  let arguments = (
    ins AnyMemRef:$src,
        Variadic<Index>:$src_offsets,
        Variadic<Index>:$src_sizes,
        Variadic<Index>:$src_strides,
        GraphIOType:$dst
  );
  let assemblyFormat = [{
    `(` $src `[` ($src_offsets^)? `]``[` ($src_sizes^)? `]``[` ($src_strides^)? `]` `,`
        $dst `)`  attr-dict `:` `(` type($src) `,` type($dst) `)`
  }];
  let hasCanonicalizer = 1;
}

def IOPopOp: ADF_Op<"io.pop", [AttrSizedOperandSegments]> {
  let summary = "Pop the data from graph io to the externel memory";
  let description = [{
    It creates an operation to pop the data from graph io to the externel memory 
    (out of aie).

    It pops an N-dimension of data in a memref to an ADF graph IO.

    ```mlir
      %mem0 = memref.alloc() : memref<64x64xf32>
      %plio0 = adf.graph.io(PLIO) : !adf.plio<In> 
      adf.io.pop(%plio0,%mem0[0, 0][32, 32][1, 1]) 
      : (!adf.plio<In> , memref<64x64xf32>)
    ```
  }];
  let arguments = (
    ins GraphIOType:$src,
        AnyMemRef:$dst,
        Variadic<Index>:$dst_offsets,
        Variadic<Index>:$dst_sizes,
        Variadic<Index>:$dst_strides
  );
  let assemblyFormat = [{
    `(` $src `,` 
    $dst `[` ($dst_offsets^)? `]``[` ($dst_sizes^)? `]``[` ($dst_strides^)? `]`
     `)`  attr-dict `:` `(` type($src) `,` type($dst) `)`
  }];
}

def IOWaitOp: ADF_Op<"io.wait", []> {
  let summary = "Barrier operation for IOPop op";
  let arguments = (ins GraphIOType:$graphio);
  let assemblyFormat = [{
    `(` $graphio `)`  attr-dict `:` type($graphio)
  }];
}

def IOWriteOp: ADF_Op<"io.write", []> {
  let summary = "Write one date into GraphIO";
  let description = [{
    This operation is used in the PL to write data to a GraphIO which is similar 
    to fifo.write 

    ```mlir
      %data = affine.load %alloc[%1] : memref<32xf32>
      %plio0 = adf.graph.io(PLIO) : !adf.plio<In>
      adf.io.write(%data, %plio0) 
      : (f32, , !adf.plio<In>)
    ```
  }];
  let arguments = (ins AnyType:$src, GraphIOType:$dst);
  let assemblyFormat = [{
    `(` $src  `,` $dst `)`  attr-dict `:` `(` type($src) `,` type($dst) `)`
  }];
}

def IOReadOp: ADF_Op<"io.read", []> {
  let summary = "Read one date from GraphIO";
  let description = [{
    This operation is used in the PL to read data from a GraphIO which is 
    similar to fifo.read 

    ```mlir
      %plio0 = adf.graph.io(PLIO) : !adf.plio<In>
      %data = adf.io.read(%plio0) 
      : (!adf.plio<In>, f32)
    ```
  }];
  let arguments = (ins GraphIOType:$src);
  let results = (outs AnyType:$result);
  let assemblyFormat = [{
    `(` $src  `)`  attr-dict `:` functional-type($src, results)
  }];
}

def BuffLocOp : ADF_Op<"buffer.location", []> {
  let summary = "Specify buffer location";
  let description = [{
    This operation specify the location of an AIE local buffer.

    ```mlir
      %buffer0 = adf.buffer.create() : memref<32x32xi32>
      adf.buffer.location(%buffer0, %col, %row, %offset)
    ```
  }];
  let arguments = (ins AnyMemRef:$buffer, Index:$col, Index:$row, Index:$offset0, Index:$offset1);
  let assemblyFormat = [{ 
  `(` $buffer `,` $col `,` $row `,` $offset0 `,` $offset1 `)` attr-dict `:` `(` type($buffer) `,` type($col) `,` type($row) `,` type($offset0) `,` type($offset1) `)`
  }];
}

//===----------------------------------------------------------------------===//
// Bitwise operations proposed in hcl-dialect. TODO need to consider how to 
// leverage the existing dialects to construct the PL logic
//===----------------------------------------------------------------------===//

def IntToAPInt : ADF_Op<"int_to_apint"> {
  let summary = "int to ap_int cast operation";
  let arguments = (ins SignlessIntegerLike:$input);
  let results = (outs SignlessIntegerLike:$result);
  let assemblyFormat = [{
      `(` $input `)` attr-dict `:` functional-type($input, results)
  }];
}

def APIntToInt : ADF_Op<"apint_to_int"> {
  let summary = "ap_int to int cast operation";
  let arguments = (ins SignlessIntegerLike:$input);
  let results = (outs SignlessIntegerLike:$result);
  let assemblyFormat = [{
      `(` $input `)` attr-dict `:` functional-type($input, results)
  }];
}

def GetIntBitOp : ADF_Op<"get_bit"> {
    let summary = "get bit of an integer";
    let arguments = (ins SignlessIntegerLike:$num, Builtin_Index:$index);
    let results = (outs BoolLike:$result);
    let assemblyFormat = [{
        `(` $num `:` type($num) `,` $index `)` attr-dict `->` type($result)
    }];
}

def SetIntBitOp : ADF_Op<"set_bit"> {
    let summary = "set bit of an integer";
    let arguments = (ins SignlessIntegerLike:$num, Builtin_Index:$index, BoolLike:$val);
    let results = (outs SignlessIntegerLike:$result);
    let assemblyFormat = [{
        `(` $num `:` type($num) `,` $index `,` $val `:` type($val) `)` attr-dict `->` type($result)
    }];
}

def GetIntSliceOp : ADF_Op<"get_slice"> {
    let summary = "get slice of an integer";
    let arguments = (ins SignlessIntegerLike:$num, Builtin_Index:$hi, Builtin_Index:$lo);
    let results = (outs SignlessIntegerLike:$result);
    let assemblyFormat = [{
        `(` $num `:` type($num) `,` $hi `,` $lo `)` attr-dict `->` type($result)
    }];
}

def SetIntSliceOp : ADF_Op<"set_slice"> {
    let summary = "set slice of an integer";
    let arguments = (ins SignlessIntegerLike:$num, Builtin_Index:$hi, Builtin_Index:$lo, SignlessIntegerLike:$val);
    let assemblyFormat = [{
        `(` $num `:` type($num) `,` $hi `,` $lo `,` $val `:` type($val) `)` attr-dict
    }];
}

def BitReverseOp : ADF_Op<"bit_reverse", [SameOperandsAndResultType]> {
    let summary = "reverse bits of an integer";
    let arguments = (ins SignlessIntegerLike:$num);
    let results = (outs SignlessIntegerLike:$result);
    let assemblyFormat = [{
        `(` $num `:` type($num) `)` attr-dict
    }];
}

#endif  // ARIES_DIALECT_ARIES_ADF_OPS_TD