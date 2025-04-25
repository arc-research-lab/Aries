// RUN: aries-opt -aries-pl-dataflow -cse -canonicalize %s | FileCheck %s

// CHECK: module {
// CHECK:   func.func @send0(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, send} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 32 {
// CHECK:         %0 = affine.load %arg1[0] : memref<1xf32, "stream">
// CHECK:         %1 = arith.bitcast %0 : f32 to i32
// CHECK:         affine.store %1, %arg0[0] : memref<1xi32, "plio">
// CHECK:       } {pipeline_ii = 1 : index}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0(%arg0: memref<256xf32>, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 1 {
// CHECK:         affine.for %arg4 = 0 to 32 {
// CHECK:           %0 = affine.load %arg1[0] : memref<1xf32, "stream">
// CHECK:           affine.store %0, %arg0[%arg4 + %arg2 * 32 + %arg3 * 32] : memref<256xf32>
// CHECK:         } {pipeline_ii = 1 : index}
// CHECK:       } {merge}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0(%arg0: memref<256xf32>, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32]} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 1 {
// CHECK:         affine.for %arg4 = 0 to 32 {
// CHECK:           %0 = affine.load %arg0[%arg4 + %arg2 * 32 + %arg3 * 32] : memref<256xf32>
// CHECK:           affine.store %0, %arg1[0] : memref<1xf32, "stream">
// CHECK:         } {pipeline_ii = 1 : index}
// CHECK:       } {merge}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send1(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, send} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 32 {
// CHECK:         %0 = affine.load %arg1[0] : memref<1xf32, "stream">
// CHECK:         %1 = arith.bitcast %0 : f32 to i32
// CHECK:         affine.store %1, %arg0[0] : memref<1xi32, "plio">
// CHECK:       } {pipeline_ii = 1 : index}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load1(%arg0: memref<256xf32>, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32]} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 1 {
// CHECK:         affine.for %arg4 = 0 to 32 {
// CHECK:           %0 = affine.load %arg0[%arg4 + %arg2 * 32 + %arg3 * 32] : memref<256xf32>
// CHECK:           affine.store %0, %arg1[0] : memref<1xf32, "stream">
// CHECK:         } {pipeline_ii = 1 : index}
// CHECK:       } {merge}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @receive0(%arg0: memref<1xi32, "plio">, %arg1: memref<1xf32, "stream">) attributes {adf.pl, inline = false, receive} {
// CHECK:     affine.for %arg2 = 0 to 8 {
// CHECK:       affine.for %arg3 = 0 to 32 {
// CHECK:         %0 = affine.load %arg0[0] : memref<1xi32, "plio">
// CHECK:         %1 = arith.bitcast %0 : i32 to f32
// CHECK:         affine.store %1, %arg1[0] : memref<1xf32, "stream">
// CHECK:       } {pipeline_ii = 1 : index}
// CHECK:     } {Array_Partition}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @vadd_pl(%arg0: memref<256xf32>, %arg1: memref<256xf32>, %arg2: memref<256xf32>, %arg3: memref<1xi32, "plio">, %arg4: memref<1xi32, "plio">, %arg5: memref<1xi32, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32]} {
// CHECK:     %alloc = memref.alloc() : memref<1xf32, "stream">
// CHECK:     %alloc_0 = memref.alloc() : memref<1xf32, "stream">
// CHECK:     %alloc_1 = memref.alloc() : memref<1xf32, "stream">
// CHECK:     call @send0(%arg5, %alloc_1) : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     call @store0(%arg2, %alloc) : (memref<256xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     call @load0(%arg0, %alloc_1) : (memref<256xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     call @send1(%arg4, %alloc_0) : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     call @load1(%arg1, %alloc_0) : (memref<256xf32>, memref<1xf32, "stream">) -> ()
// CHECK:     call @receive0(%arg3, %alloc) : (memref<1xi32, "plio">, memref<1xf32, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

module {
  func.func @vadd_pl(%arg0: memref<256xf32>, %arg1: memref<256xf32>, %arg2: memref<256xf32>, %arg3: memref<1xi32, "plio">, %arg4: memref<1xi32, "plio">, %arg5: memref<1xi32, "plio">) attributes {adf.pl = true, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32]} {
    %alloc = memref.alloc() : memref<1xf32, "stream">
    %alloc_0 = memref.alloc() : memref<1xf32, "stream">
    %alloc_1 = memref.alloc() : memref<1xf32, "stream">
    %alloc_2 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32xf32, 1>
    %alloc_3 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32xf32, 1>
    %alloc_4 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32xf32, 1>
    affine.for %arg6 = 0 to 8 {
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %alloc_1[0] : memref<1xf32, "stream">
          affine.store %0, %alloc_4[%arg8 + %arg7 * 32] : memref<32xf32, 1>
        } {pipeline_ii = 1 : index}
      } {module = 0 : index}
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %alloc_4[%arg8 + %arg7 * 32] : memref<32xf32, 1>
          %1 = arith.bitcast %0 : f32 to i32
          affine.store %1, %arg5[0] : memref<1xi32, "plio">
        } {pipeline_ii = 1 : index}
      } {module = 1 : index}
    } {Array_Partition, send = 0 : index}
    affine.for %arg6 = 0 to 8 {
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %alloc[0] : memref<1xf32, "stream">
          affine.store %0, %arg2[%arg8 + %arg6 * 32 + %arg7 * 32] : memref<256xf32>
        } {pipeline_ii = 1 : index}
      } {merge}
    } {Array_Partition, store = 0 : index}
    affine.for %arg6 = 0 to 8 {
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %arg0[%arg8 + %arg6 * 32 + %arg7 * 32] : memref<256xf32>
          affine.store %0, %alloc_1[0] : memref<1xf32, "stream">
        } {pipeline_ii = 1 : index}
      } {merge}
    } {Array_Partition, load = 0 : index}
    affine.for %arg6 = 0 to 8 {
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %alloc_0[0] : memref<1xf32, "stream">
          affine.store %0, %alloc_3[%arg8 + %arg7 * 32] : memref<32xf32, 1>
        } {pipeline_ii = 1 : index}
      } {module = 0 : index}
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %alloc_3[%arg8 + %arg7 * 32] : memref<32xf32, 1>
          %1 = arith.bitcast %0 : f32 to i32
          affine.store %1, %arg4[0] : memref<1xi32, "plio">
        } {pipeline_ii = 1 : index}
      } {module = 1 : index}
    } {Array_Partition, send = 1 : index}
    affine.for %arg6 = 0 to 8 {
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %arg1[%arg8 + %arg6 * 32 + %arg7 * 32] : memref<256xf32>
          affine.store %0, %alloc_0[0] : memref<1xf32, "stream">
        } {pipeline_ii = 1 : index}
      } {merge}
    } {Array_Partition, load = 1 : index}
    affine.for %arg6 = 0 to 8 {
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %arg3[0] : memref<1xi32, "plio">
          %1 = arith.bitcast %0 : i32 to f32
          affine.store %1, %alloc_2[%arg8 + %arg7 * 32] : memref<32xf32, 1>
        } {pipeline_ii = 1 : index}
      }
      affine.for %arg7 = 0 to 1 {
        affine.for %arg8 = 0 to 32 {
          %0 = affine.load %alloc_2[%arg8 + %arg7 * 32] : memref<32xf32, 1>
          affine.store %0, %alloc[0] : memref<1xf32, "stream">
        } {pipeline_ii = 1 : index}
      }
    } {Array_Partition, receive = 0 : index}
    return
  }
}