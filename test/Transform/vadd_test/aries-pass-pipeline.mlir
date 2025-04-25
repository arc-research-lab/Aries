// RUN: aries-opt -aries-pipeline-versal="tile-func-name=vadd l1-tile-sizes=1 l2-tile-sizes=1 en-newtiling="true" port-type=PLIO plio-width=32 en-pl="true" en-aie2="false" en-link="false" col-num=50 row-num=8 col-offset=0  row-offset=0 core-gap=0 core-algo=1 first-col=6 num-shim=39 mid-line=24 chal-in=3 chal-out=3 iocons="false" buf-sels=0,0,0 axi-width=32 en-serial="true"" -cse --canonicalize %s | FileCheck %s

// CHECK: module {
// CHECK:   func.func @kernel_add0(%arg0: memref<32xf32, 2>, %arg1: memref<32xf32, 2>) -> memref<32xf32, 2> attributes {adf.kernel, edge_kernel} {
// CHECK:     %alloc = memref.alloc() : memref<32xf32, 2>
// CHECK:     affine.for %arg2 = 0 to 32 {
// CHECK:       %0 = affine.load %arg0[%arg2] : memref<32xf32, 2>
// CHECK:       %1 = affine.load %arg1[%arg2] : memref<32xf32, 2>
// CHECK:       %2 = arith.addf %0, %1 : f32
// CHECK:       affine.store %2, %alloc[%arg2] : memref<32xf32, 2>
// CHECK:     }
// CHECK:     return %alloc : memref<32xf32, 2>
// CHECK:   }
// CHECK:   func.func @adf_cell0(%arg0: !adf.plio<In, 32>, %arg1: !adf.plio<In, 32>, %arg2: !adf.plio<Out, 32>) attributes {adf.cell, tripCount = [1 : index, 1 : index, 1 : index]} {
// CHECK:     %c23 = arith.constant 23 : index
// CHECK:     %c8192 = arith.constant 8192 : index
// CHECK:     %c0 = arith.constant 0 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c24 = arith.constant 24 : index
// CHECK:     adf.config.plio(%arg0, 250) {"col, chl" = [24 : index, 4 : index]} : <In, 32>
// CHECK:     adf.config.plio(%arg1, 250) {"col, chl" = [24 : index, 2 : index]} : <In, 32>
// CHECK:     adf.config.plio(%arg2, 250) {"col, chl" = [24 : index, 4 : index]} : <Out, 32>
// CHECK:     %0 = adf.buffer.create @L1_L1_A() : memref<32xf32, 2>
// CHECK:     %1 = adf.buffer.create @L1_L1_B() : memref<32xf32, 2>
// CHECK:     adf.connect(%arg0, %0) : (!adf.plio<In, 32>, memref<32xf32, 2>)
// CHECK:     adf.connect(%arg1, %1) : (!adf.plio<In, 32>, memref<32xf32, 2>)
// CHECK:     %2 = call @kernel_add0(%0, %1) {adf.kernel, "col, row" = [24 : index, 0 : index], ivs = [0 : index, 0 : index, 0 : index], kernel_add0 = 0 : index} : (memref<32xf32, 2>, memref<32xf32, 2>) -> memref<32xf32, 2>
// CHECK:     adf.buffer.location(%2, %c24, %c0, %c0, %c8192) : (memref<32xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%1, %c23, %c0, %c0, %c8192) : (memref<32xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%0, %c24, %c1, %c0, %c8192) : (memref<32xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%2, %arg2) : (memref<32xf32, 2>, !adf.plio<Out, 32>)
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send0(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, send, template} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 32 {
// CHECK:         %0 = affine.load %arg1[0] : memref<1xf32, "stream">
// CHECK:         %1 = arith.bitcast %0 : f32 to i32
// CHECK:         affine.store %1, %arg0[0] : memref<1xi32, "plio">
// CHECK:       } {pipeline_ii = 1 : index}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send0_top(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">, %arg2: memref<1xi32, "plio">, %arg3: memref<1xf32, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @send0(%arg0, %arg1) {template = 0 : index} : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     call @send0(%arg2, %arg3) {template = 1 : index} : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0(%arg0: memref<?xf32>, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 1 {
// CHECK:         affine.for %arg4 = 0 to 32 {
// CHECK:           %0 = affine.load %arg1[0] : memref<1xf32, "stream">
// CHECK:           affine.store %0, %arg0[%arg4 + %arg2 * 32 + %arg3 * 32] : memref<?xf32>
// CHECK:         } {pipeline_ii = 1 : index}
// CHECK:       } {merge}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0_top(%arg0: memref<?xf32>, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @store0(%arg0, %arg1) {template = 0 : index} : (memref<?xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0(%arg0: memref<?xf32>, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 1 {
// CHECK:         affine.for %arg4 = 0 to 32 {
// CHECK:           %0 = affine.load %arg0[%arg4 + %arg2 * 32 + %arg3 * 32] : memref<?xf32>
// CHECK:           affine.store %0, %arg1[0] : memref<1xf32, "stream">
// CHECK:         } {pipeline_ii = 1 : index}
// CHECK:       } {merge}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0_top(%arg0: memref<?xf32>, %arg1: memref<1xf32, "stream">, %arg2: memref<?xf32>, %arg3: memref<1xf32, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @load0(%arg0, %arg1) {template = 0 : index} : (memref<?xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     call @load0(%arg2, %arg3) {template = 1 : index} : (memref<?xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @receive0(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, receive, template} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 32 {
// CHECK:         %0 = affine.load %arg0[0] : memref<1xi32, "plio">
// CHECK:         %1 = arith.bitcast %0 : i32 to f32
// CHECK:         affine.store %1, %arg1[0] : memref<1xf32, "stream">
// CHECK:       } {pipeline_ii = 1 : index}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @receive0_top(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @receive0(%arg0, %arg1) {template = 0 : index} : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @vadd_pl(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<1xi32, "plio">, %arg4: memref<1xi32, "plio">, %arg5: memref<1xi32, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32]} {
// CHECK:     %alloc = memref.alloc() : memref<1xf32, "stream">
// CHECK:     %alloc_0 = memref.alloc() : memref<1xf32, "stream">
// CHECK:     %alloc_1 = memref.alloc() : memref<1xf32, "stream">
// CHECK:     call @send0_top(%arg5, %alloc_1, %arg4, %alloc_0) : (memref<1xi32, "plio">, memref<1xf32, "stream">, memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     call @store0_top(%arg2, %alloc) : (memref<?xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     call @load0_top(%arg0, %alloc_1, %arg1, %alloc_0) : (memref<?xf32>, memref<1xf32, "stream">, memref<?xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     call @receive0_top(%arg3, %alloc) : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @vadd(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<1xi32, "plio">, %arg4: memref<1xi32, "plio">, %arg5: memref<1xi32, "plio">) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32], plio = true} {
// CHECK:     %0 = adf.graph.io(PLIO) : !adf.plio<Out, 32>
// CHECK:     adf.connect(%0, %arg3) {top_config} : (!adf.plio<Out, 32>, memref<1xi32, "plio">)
// CHECK:     %1 = adf.graph.io(PLIO) : !adf.plio<In, 32>
// CHECK:     adf.connect(%arg4, %1) {top_config} : (memref<1xi32, "plio">, !adf.plio<In, 32>)
// CHECK:     %2 = adf.graph.io(PLIO) : !adf.plio<In, 32>
// CHECK:     adf.connect(%arg5, %2) {top_config} : (memref<1xi32, "plio">, !adf.plio<In, 32>)
// CHECK:     adf.cell.launch @adf_cell0 {
// CHECK:       func.call @adf_cell0(%2, %1, %0) {adf.cell} : (!adf.plio<In, 32>, !adf.plio<In, 32>, !adf.plio<Out, 32>) -> ()
// CHECK:       adf.cell.launch.end
// CHECK:     }
// CHECK:     adf.pl.launch @vadd_pl {
// CHECK:       func.call @vadd_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5) {adf.pl} : (memref<?xf32>, memref<?xf32>, memref<?xf32>, memref<1xi32, "plio">, memref<1xi32, "plio">, memref<1xi32, "plio">) -> ()
// CHECK:       adf.pl.launch.wait
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @top(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<1xi32, "plio">, %arg4: memref<1xi32, "plio">, %arg5: memref<1xi32, "plio">) attributes {outArgs = [2 : i32], top_func = "plio"} {
// CHECK:     call @vadd_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5) : (memref<?xf32>, memref<?xf32>, memref<?xf32>, memref<1xi32, "plio">, memref<1xi32, "plio">, memref<1xi32, "plio">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func private @vadd_host(memref<256xf32>, memref<256xf32>, memref<256xf32>) attributes {origin_func = "vadd"}
// CHECK:   func.func @top_host(%arg0: memref<256xf32>, %arg1: memref<256xf32>, %arg2: memref<256xf32>) attributes {origin_func = "top", outArgs = [2 : i32], top_host} {
// CHECK:     call @vadd_host(%arg0, %arg1, %arg2) {origin_func = "vadd"} : (memref<256xf32>, memref<256xf32>, memref<256xf32>) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0) -> (d0 * 32)>
module {
  func.func @kernel_add(%arg0: memref<32xf32, 2>, %arg1: memref<32xf32, 2>, %arg2: memref<32xf32, 2>) attributes {adf.kernel} {
    affine.for %arg3 = 0 to 32 {
      %0 = affine.load %arg0[%arg3] : memref<32xf32, 2>
      %1 = affine.load %arg1[%arg3] : memref<32xf32, 2>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg2[%arg3] : memref<32xf32, 2>
    }
    return
  }
  func.func @vadd(%arg0: memref<256xf32>, %arg1: memref<256xf32>, %arg2: memref<256xf32>) attributes {adf.func} {
    %c1 = arith.constant 1 : index
    %c32 = arith.constant 32 : index
    affine.for %arg3 = 0 to 8 {
      %0 = adf.buffer.create @L1_L1_A() : memref<32xf32, 2>
      %1 = adf.buffer.create @L1_L1_B() : memref<32xf32, 2>
      %2 = adf.buffer.create @L1_L1_C() : memref<32xf32, 2>
      %3 = affine.apply #map(%arg3)
      adf.dma(%arg0[%3] [%c32] [%c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<256xf32>, memref<32xf32, 2>)
      adf.dma(%arg1[%3] [%c32] [%c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<256xf32>, memref<32xf32, 2>)
      func.call @kernel_add(%0, %1, %2) : (memref<32xf32, 2>, memref<32xf32, 2>, memref<32xf32, 2>) -> ()
      adf.dma(%2[] [] [] [] [] [] [], %arg2[%3] [%c32] [%c1] [] [] [] []) : (memref<32xf32, 2>, memref<256xf32>)
    }
    return
  }
  func.func @top(%arg0: memref<256xf32>, %arg1: memref<256xf32>, %arg2: memref<256xf32>) attributes {top_func} {
    call @vadd(%arg0, %arg1, %arg2) : (memref<256xf32>, memref<256xf32>, memref<256xf32>) -> ()
    return
  }
}