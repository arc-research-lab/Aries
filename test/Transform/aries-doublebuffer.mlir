// RUN: aries-opt -aries-pl-double-buffer -cse -canonicalize %s | FileCheck %s

// CHECK: #map = affine_map<(d0) -> (d0 * 128 + 127)>
// CHECK: #map1 = affine_map<(d0) -> (d0 * 128)>
// CHECK: module {
// CHECK:   func.func private @adf_cell0(!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]}
// CHECK:   func.func @send3_0(%arg0: memref<1xi128, "stream">, %arg1: memref<4x16x8xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
// CHECK:     scf.if %arg2 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 8 {
// CHECK:               affine.for %arg7 = 0 to 2 {
// CHECK:                 affine.for %arg8 = 0 to 4 {
// CHECK:                   %0 = affine.load %arg0[0] : memref<1xi128, "stream">
// CHECK:                   affine.store %0, %arg1[%arg5 + %arg3 * 2, %arg6 + %arg4 * 8, %arg8 + %arg7 * 4] : memref<4x16x8xi128, 1>
// CHECK:                 } {pipeline_ii = 1 : index}
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send3_1(%arg0: memref<4x16x8xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
// CHECK:     scf.if %arg2 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 2 {
// CHECK:                 affine.for %arg8 = 0 to 8 {
// CHECK:                   affine.for %arg9 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg0[%arg7 + %arg3 * 2, %arg8 + %arg5 * 8, %arg9 + %arg6 * 4] : memref<4x16x8xi128, 1>
// CHECK:                     affine.store %0, %arg1[0] : memref<1xi128, "plio">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send3(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %true = arith.constant true
// CHECK:     %c0 = arith.constant 0 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_0 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             %0 = arith.muli %arg4, %c2 : index
// CHECK:             %1 = arith.addi %arg5, %0 : index
// CHECK:             %2 = arith.muli %arg3, %c4 : index
// CHECK:             %3 = arith.addi %1, %2 : index
// CHECK:             %4 = arith.muli %arg2, %c8 : index
// CHECK:             %5 = arith.addi %3, %4 : index
// CHECK:             %6 = arith.remsi %5, %c2 : index
// CHECK:             %7 = arith.cmpi eq, %6, %c0 : index
// CHECK:             %8 = arith.cmpi ne, %5, %c0 : index
// CHECK:             scf.if %7 {
// CHECK:               func.call @send3_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<4x16x8xi128, 1>, i1) -> ()
// CHECK:               func.call @send3_1(%alloc_0, %arg0, %8) : (memref<4x16x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:             } else {
// CHECK:               func.call @send3_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<4x16x8xi128, 1>, i1) -> ()
// CHECK:               func.call @send3_1(%alloc, %arg0, %8) : (memref<4x16x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     call @send3_1(%alloc_0, %arg0, %true) : (memref<4x16x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send3_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @send3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load2(%arg0: memref<128x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg5 = 0 to 1 {
// CHECK:       affine.for %arg6 = 0 to 2 {
// CHECK:         affine.for %arg7 = 0 to 2 {
// CHECK:           affine.for %arg8 = 0 to 2 {
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 16 {
// CHECK:                 affine.for %arg11 = 0 to 2 {
// CHECK:                   affine.for %arg12 = 0 to 2 {
// CHECK:                     %0 = affine.load %arg0[%arg10 + %arg9 * 32 + %arg8 * 64, %arg12 + %arg11 * 2 + %arg6 * 4] : memref<128x8xi512>
// CHECK:                     %1 = arith.cmpi slt, %arg12, %c1 : index
// CHECK:                     scf.if %1 {
// CHECK:                       affine.store %0, %arg4[0] : memref<1xi512, "stream1">
// CHECK:                     } else {
// CHECK:                       affine.store %0, %arg2[0] : memref<1xi512, "stream1">
// CHECK:                     }
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 16 {
// CHECK:                 affine.for %arg11 = 0 to 2 {
// CHECK:                   affine.for %arg12 = 0 to 2 {
// CHECK:                     %0 = affine.load %arg0[%arg10 + %arg9 * 32 + %arg8 * 64 + 16, %arg12 + %arg11 * 2 + %arg6 * 4] : memref<128x8xi512>
// CHECK:                     %1 = arith.cmpi slt, %arg12, %c1 : index
// CHECK:                     scf.if %1 {
// CHECK:                       affine.store %0, %arg3[0] : memref<1xi512, "stream1">
// CHECK:                     } else {
// CHECK:                       affine.store %0, %arg1[0] : memref<1xi512, "stream1">
// CHECK:                     }
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load2_top(%arg0: memref<128x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load2(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<128x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load2_3(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, template} {
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 16 {
// CHECK:                 affine.for %arg8 = 0 to 2 {
// CHECK:                   affine.for %arg9 = 0 to 1 {
// CHECK:                     %0 = affine.load %arg1[0] : memref<1xi512, "stream1">
// CHECK:                     affine.for %arg10 = 0 to 4 {
// CHECK:                       %1 = affine.apply #map(%arg10)
// CHECK:                       %2 = affine.apply #map1(%arg10)
// CHECK:                       %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
// CHECK:                       affine.store %3, %arg0[0] : memref<1xi128, "stream">
// CHECK:                     } {pipeline_ii = 1 : index}
// CHECK:                   } {pipeline_ii = 4 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load2_3_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream1">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load2_3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load2_3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load2_3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load2_3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send5_0(%arg0: memref<1xi128, "stream">, %arg1: memref<16x8xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
// CHECK:     scf.if %arg2 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 8 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 4 {
// CHECK:               %0 = affine.load %arg0[0] : memref<1xi128, "stream">
// CHECK:               affine.store %0, %arg1[%arg4 + %arg3 * 8, %arg6 + %arg5 * 4] : memref<16x8xi128, 1>
// CHECK:             } {pipeline_ii = 1 : index}
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send5_1(%arg0: memref<16x8xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
// CHECK:     scf.if %arg2 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 8 {
// CHECK:                 affine.for %arg8 = 0 to 4 {
// CHECK:                   %0 = affine.load %arg0[%arg7 + %arg5 * 8, %arg8 + %arg4 * 4] : memref<16x8xi128, 1>
// CHECK:                   affine.store %0, %arg1[0] : memref<1xi128, "plio">
// CHECK:                 } {pipeline_ii = 1 : index}
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send5(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %true = arith.constant true
// CHECK:     %c0 = arith.constant 0 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
// CHECK:     %alloc_0 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             %0 = arith.muli %arg4, %c2 : index
// CHECK:             %1 = arith.addi %arg5, %0 : index
// CHECK:             %2 = arith.muli %arg3, %c4 : index
// CHECK:             %3 = arith.addi %1, %2 : index
// CHECK:             %4 = arith.muli %arg2, %c8 : index
// CHECK:             %5 = arith.addi %3, %4 : index
// CHECK:             %6 = arith.remsi %5, %c2 : index
// CHECK:             %7 = arith.cmpi eq, %6, %c0 : index
// CHECK:             %8 = arith.cmpi ne, %5, %c0 : index
// CHECK:             scf.if %7 {
// CHECK:               func.call @send5_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<16x8xi128, 1>, i1) -> ()
// CHECK:               func.call @send5_1(%alloc_0, %arg0, %8) : (memref<16x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:             } else {
// CHECK:               func.call @send5_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<16x8xi128, 1>, i1) -> ()
// CHECK:               func.call @send5_1(%alloc, %arg0, %8) : (memref<16x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     call @send5_1(%alloc_0, %arg0, %true) : (memref<16x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send5_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @send5(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send5(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @receive2(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, receive, template} {
// CHECK:     %c96 = arith.constant 96 : index
// CHECK:     %c127 = arith.constant 127 : index
// CHECK:     %c64 = arith.constant 64 : index
// CHECK:     %c95 = arith.constant 95 : index
// CHECK:     %c32 = arith.constant 32 : index
// CHECK:     %c63 = arith.constant 63 : index
// CHECK:     %c31 = arith.constant 31 : index
// CHECK:     %c0_i128 = arith.constant 0 : i128
// CHECK:     %c0 = arith.constant 0 : index
// CHECK:     %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<4x8xi128, 1>
// CHECK:     affine.for %arg2 = 0 to 4 {
// CHECK:       affine.for %arg3 = 0 to 8 {
// CHECK:         affine.store %c0_i128, %alloc[%arg2, %arg3] : memref<4x8xi128, 1>
// CHECK:       } {pipeline_ii = 1 : index}
// CHECK:     }
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 2 {
// CHECK:                 affine.for %arg8 = 0 to 2 {
// CHECK:                   affine.for %arg9 = 0 to 2 {
// CHECK:                     affine.for %arg10 = 0 to 2 {
// CHECK:                       affine.for %arg11 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg0[0] : memref<1xi128, "plio">
// CHECK:                         %1 = affine.load %alloc[%arg10 + %arg6 * 2, %arg11 + %arg7 * 4] : memref<4x8xi128, 1>
// CHECK:                         %2 = adf.int_to_apint(%0) : (i128) -> i128
// CHECK:                         %3 = adf.int_to_apint(%1) : (i128) -> i128
// CHECK:                         %4 = adf.int_to_apint(%c0_i128) : (i128) -> i128
// CHECK:                         %5 = adf.get_slice(%2 : i128, %c31, %c0) -> i32
// CHECK:                         %6 = adf.get_slice(%3 : i128, %c31, %c0) -> i32
// CHECK:                         %7 = arith.bitcast %5 : i32 to f32
// CHECK:                         %8 = arith.bitcast %6 : i32 to f32
// CHECK:                         %9 = arith.addf %7, %8 : f32
// CHECK:                         %10 = arith.bitcast %9 : f32 to i32
// CHECK:                         adf.set_slice(%4 : i128, %c31, %c0, %10 : i32)
// CHECK:                         %11 = adf.get_slice(%2 : i128, %c63, %c32) -> i32
// CHECK:                         %12 = adf.get_slice(%3 : i128, %c63, %c32) -> i32
// CHECK:                         %13 = arith.bitcast %11 : i32 to f32
// CHECK:                         %14 = arith.bitcast %12 : i32 to f32
// CHECK:                         %15 = arith.addf %13, %14 : f32
// CHECK:                         %16 = arith.bitcast %15 : f32 to i32
// CHECK:                         adf.set_slice(%4 : i128, %c63, %c32, %16 : i32)
// CHECK:                         %17 = adf.get_slice(%2 : i128, %c95, %c64) -> i32
// CHECK:                         %18 = adf.get_slice(%3 : i128, %c95, %c64) -> i32
// CHECK:                         %19 = arith.bitcast %17 : i32 to f32
// CHECK:                         %20 = arith.bitcast %18 : i32 to f32
// CHECK:                         %21 = arith.addf %19, %20 : f32
// CHECK:                         %22 = arith.bitcast %21 : f32 to i32
// CHECK:                         adf.set_slice(%4 : i128, %c95, %c64, %22 : i32)
// CHECK:                         %23 = adf.get_slice(%2 : i128, %c127, %c96) -> i32
// CHECK:                         %24 = adf.get_slice(%3 : i128, %c127, %c96) -> i32
// CHECK:                         %25 = arith.bitcast %23 : i32 to f32
// CHECK:                         %26 = arith.bitcast %24 : i32 to f32
// CHECK:                         %27 = arith.addf %25, %26 : f32
// CHECK:                         %28 = arith.bitcast %27 : f32 to i32
// CHECK:                         adf.set_slice(%4 : i128, %c127, %c96, %28 : i32)
// CHECK:                         %29 = adf.apint_to_int(%4) : (i128) -> i128
// CHECK:                         affine.store %29, %alloc[%arg10 + %arg6 * 2, %arg11 + %arg7 * 4] : memref<4x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc[%arg5 + %arg4 * 2, %arg7 + %arg6 * 4] : memref<4x8xi128, 1>
// CHECK:                 affine.store %0, %arg1[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %c0_i128, %alloc[%arg5 + %arg4 * 2, %arg7 + %arg6 * 4] : memref<4x8xi128, 1>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @receive2_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @receive2(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @receive2(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @receive2(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @receive2(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send6_0(%arg0: memref<1xi128, "stream">, %arg1: memref<32x8xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
// CHECK:     scf.if %arg2 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 16 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 4 {
// CHECK:               %0 = affine.load %arg0[0] : memref<1xi128, "stream">
// CHECK:               affine.store %0, %arg1[%arg4 + %arg3 * 16, %arg6 + %arg5 * 4] : memref<32x8xi128, 1>
// CHECK:             } {pipeline_ii = 1 : index}
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send6_1(%arg0: memref<32x8xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
// CHECK:     scf.if %arg2 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 16 {
// CHECK:                 affine.for %arg8 = 0 to 4 {
// CHECK:                   %0 = affine.load %arg0[%arg7 + %arg6 * 16, %arg8 + %arg4 * 4] : memref<32x8xi128, 1>
// CHECK:                   affine.store %0, %arg1[0] : memref<1xi128, "plio">
// CHECK:                 } {pipeline_ii = 1 : index}
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send6(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %true = arith.constant true
// CHECK:     %c0 = arith.constant 0 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_0 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             %0 = arith.muli %arg4, %c2 : index
// CHECK:             %1 = arith.addi %arg5, %0 : index
// CHECK:             %2 = arith.muli %arg3, %c4 : index
// CHECK:             %3 = arith.addi %1, %2 : index
// CHECK:             %4 = arith.muli %arg2, %c8 : index
// CHECK:             %5 = arith.addi %3, %4 : index
// CHECK:             %6 = arith.remsi %5, %c2 : index
// CHECK:             %7 = arith.cmpi eq, %6, %c0 : index
// CHECK:             %8 = arith.cmpi ne, %5, %c0 : index
// CHECK:             scf.if %7 {
// CHECK:               func.call @send6_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<32x8xi128, 1>, i1) -> ()
// CHECK:               func.call @send6_1(%alloc_0, %arg0, %8) : (memref<32x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:             } else {
// CHECK:               func.call @send6_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<32x8xi128, 1>, i1) -> ()
// CHECK:               func.call @send6_1(%alloc, %arg0, %8) : (memref<32x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     call @send6_1(%alloc_0, %arg0, %true) : (memref<32x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @send6_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
// CHECK:     call @send6(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send6(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send6(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send6(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0_0(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, store, template} {
// CHECK:     %c0_i512 = arith.constant 0 : i512
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 1 {
// CHECK:                 %0 = adf.int_to_apint(%c0_i512) : (i512) -> i512
// CHECK:                 affine.for %arg8 = 0 to 4 {
// CHECK:                   %1 = affine.load %arg0[0] : memref<1xi128, "stream">
// CHECK:                   %2 = affine.apply #map(%arg8)
// CHECK:                   %3 = affine.apply #map1(%arg8)
// CHECK:                   adf.set_slice(%0 : i512, %2, %3, %1 : i128)
// CHECK:                 } {pipeline_ii = 1 : index}
// CHECK:                 affine.store %0, %arg1[0] : memref<1xi512, "stream1">
// CHECK:               } {pipeline_ii = 4 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0_0_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream1">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @store0_0(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @store0_0(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @store0_0(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @store0_0(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0(%arg0: memref<8x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg5 = 0 to 1 {
// CHECK:       affine.for %arg6 = 0 to 2 {
// CHECK:         affine.for %arg7 = 0 to 2 {
// CHECK:           affine.for %arg8 = 0 to 2 {
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 2 {
// CHECK:                 %0 = arith.cmpi slt, %arg10, %c1 : index
// CHECK:                 %1 = scf.if %0 -> (i512) {
// CHECK:                   %2 = affine.load %arg4[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %2 : i512
// CHECK:                 } else {
// CHECK:                   %2 = affine.load %arg3[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %2 : i512
// CHECK:                 }
// CHECK:                 affine.store %1, %arg0[%arg8 + %arg7 * 4 + %arg5 * 8, %arg10 + %arg9 * 2 + %arg6 * 4] : memref<8x8xi512>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:         affine.for %arg7 = 0 to 2 {
// CHECK:           affine.for %arg8 = 0 to 2 {
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 2 {
// CHECK:                 %0 = arith.cmpi slt, %arg10, %c1 : index
// CHECK:                 %1 = scf.if %0 -> (i512) {
// CHECK:                   %2 = affine.load %arg2[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %2 : i512
// CHECK:                 } else {
// CHECK:                   %2 = affine.load %arg1[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %2 : i512
// CHECK:                 }
// CHECK:                 affine.store %1, %arg0[%arg8 + %arg7 * 4 + %arg5 * 8 + 2, %arg10 + %arg9 * 2 + %arg6 * 4] : memref<8x8xi512>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0_top(%arg0: memref<8x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @store0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<8x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0(%arg0: memref<8x32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg5 = 0 to 1 {
// CHECK:       affine.for %arg6 = 0 to 2 {
// CHECK:         affine.for %arg7 = 0 to 2 {
// CHECK:           affine.for %arg8 = 0 to 2 {
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 2 {
// CHECK:                 affine.for %arg11 = 0 to 2 {
// CHECK:                   affine.for %arg12 = 0 to 8 {
// CHECK:                     affine.for %arg13 = 0 to 2 {
// CHECK:                       affine.for %arg14 = 0 to 2 {
// CHECK:                         %0 = affine.load %arg0[%arg11 + %arg9 * 4 + %arg5 * 8, %arg12 + %arg10 * 8 + %arg7 * 16, %arg14 + %arg13 * 2 + %arg8 * 4] : memref<8x32x8xi512>
// CHECK:                         %1 = arith.cmpi slt, %arg14, %c1 : index
// CHECK:                         scf.if %1 {
// CHECK:                           affine.store %0, %arg4[0] : memref<1xi512, "stream1">
// CHECK:                         } else {
// CHECK:                           affine.store %0, %arg3[0] : memref<1xi512, "stream1">
// CHECK:                         }
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 2 {
// CHECK:                 affine.for %arg11 = 0 to 2 {
// CHECK:                   affine.for %arg12 = 0 to 8 {
// CHECK:                     affine.for %arg13 = 0 to 2 {
// CHECK:                       affine.for %arg14 = 0 to 2 {
// CHECK:                         %0 = affine.load %arg0[%arg11 + %arg9 * 4 + %arg5 * 8 + 2, %arg12 + %arg10 * 8 + %arg7 * 16, %arg14 + %arg13 * 2 + %arg8 * 4] : memref<8x32x8xi512>
// CHECK:                         %1 = arith.cmpi slt, %arg14, %c1 : index
// CHECK:                         scf.if %1 {
// CHECK:                           affine.store %0, %arg2[0] : memref<1xi512, "stream1">
// CHECK:                         } else {
// CHECK:                           affine.store %0, %arg1[0] : memref<1xi512, "stream1">
// CHECK:                         }
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0_top(%arg0: memref<8x32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<8x32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0_3(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, template} {
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 2 {
// CHECK:                 affine.for %arg8 = 0 to 2 {
// CHECK:                   affine.for %arg9 = 0 to 8 {
// CHECK:                     affine.for %arg10 = 0 to 2 {
// CHECK:                       affine.for %arg11 = 0 to 1 {
// CHECK:                         %0 = affine.load %arg1[0] : memref<1xi512, "stream1">
// CHECK:                         affine.for %arg12 = 0 to 4 {
// CHECK:                           %1 = affine.apply #map(%arg12)
// CHECK:                           %2 = affine.apply #map1(%arg12)
// CHECK:                           %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
// CHECK:                           affine.store %3, %arg0[0] : memref<1xi128, "stream">
// CHECK:                         } {pipeline_ii = 1 : index}
// CHECK:                       } {pipeline_ii = 4 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0_3_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream1">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load0_3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load1(%arg0: memref<32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg3 = 0 to 1 {
// CHECK:       affine.for %arg4 = 0 to 2 {
// CHECK:         affine.for %arg5 = 0 to 2 {
// CHECK:           affine.for %arg6 = 0 to 2 {
// CHECK:             affine.for %arg7 = 0 to 2 {
// CHECK:               affine.for %arg8 = 0 to 8 {
// CHECK:                 affine.for %arg9 = 0 to 2 {
// CHECK:                   affine.for %arg10 = 0 to 2 {
// CHECK:                     %0 = affine.load %arg0[%arg8 + %arg7 * 8 + %arg5 * 16, %arg10 + %arg9 * 2 + %arg4 * 4] : memref<32x8xi512>
// CHECK:                     %1 = arith.cmpi slt, %arg10, %c1 : index
// CHECK:                     scf.if %1 {
// CHECK:                       affine.store %0, %arg2[0] : memref<1xi512, "stream1">
// CHECK:                     } else {
// CHECK:                       affine.store %0, %arg1[0] : memref<1xi512, "stream1">
// CHECK:                     }
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load1_top(%arg0: memref<32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load1(%arg0, %arg1, %arg2) {template = 0 : index} : (memref<32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load1_1(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, template} {
// CHECK:     affine.for %arg2 = 0 to 1 {
// CHECK:       affine.for %arg3 = 0 to 2 {
// CHECK:         affine.for %arg4 = 0 to 2 {
// CHECK:           affine.for %arg5 = 0 to 2 {
// CHECK:             affine.for %arg6 = 0 to 2 {
// CHECK:               affine.for %arg7 = 0 to 8 {
// CHECK:                 affine.for %arg8 = 0 to 2 {
// CHECK:                   affine.for %arg9 = 0 to 1 {
// CHECK:                     %0 = affine.load %arg1[0] : memref<1xi512, "stream1">
// CHECK:                     affine.for %arg10 = 0 to 4 {
// CHECK:                       %1 = affine.apply #map(%arg10)
// CHECK:                       %2 = affine.apply #map1(%arg10)
// CHECK:                       %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
// CHECK:                       affine.store %3, %arg0[0] : memref<1xi128, "stream">
// CHECK:                     } {pipeline_ii = 1 : index}
// CHECK:                   } {pipeline_ii = 4 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load1_1_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load1_1(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load1_1(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @mttkrp_pl(%arg0: memref<8x32x8xi512>, %arg1: memref<32x8xi512>, %arg2: memref<128x8xi512>, %arg3: memref<8x8xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
// CHECK:     %alloc = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_0 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_1 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_2 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_3 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_4 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_5 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_6 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_7 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_8 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_9 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_10 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_11 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_12 = memref.alloc() : memref<1xi128, "stream">
// CHECK:     %alloc_13 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_14 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_15 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_16 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_17 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_18 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_19 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_20 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_21 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_22 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_23 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_24 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_25 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     %alloc_26 = memref.alloc() : memref<1xi512, "stream1">
// CHECK:     call @send3_top(%arg14, %alloc_9, %arg7, %alloc_4, %arg6, %alloc_3, %arg17, %alloc_12) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @load2_top(%arg2, %alloc_13, %alloc_14, %alloc_15, %alloc_16) : (memref<128x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load2_3_top(%alloc_10, %alloc_16, %alloc_8, %alloc_15, %alloc_6, %alloc_14, %alloc_5, %alloc_13) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @send5_top(%arg11, %alloc_7, %arg16, %alloc_11) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @receive2_top(%arg5, %alloc_1, %arg12, %alloc, %arg4, %alloc_2, %arg8, %alloc_0) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send6_top(%arg10, %alloc_6, %arg13, %alloc_8, %arg9, %alloc_5, %arg15, %alloc_10) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @store0_0_top(%alloc_2, %alloc_17, %alloc_1, %alloc_18, %alloc_0, %alloc_19, %alloc, %alloc_20) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @store0_top(%arg3, %alloc_17, %alloc_18, %alloc_19, %alloc_20) : (memref<8x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_top(%arg0, %alloc_21, %alloc_22, %alloc_23, %alloc_24) : (memref<8x32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_3_top(%alloc_12, %alloc_24, %alloc_9, %alloc_23, %alloc_4, %alloc_22, %alloc_3, %alloc_21) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load1_top(%arg1, %alloc_25, %alloc_26) : (memref<32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load1_1_top(%alloc_11, %alloc_26, %alloc_7, %alloc_25) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @mttkrp(%arg0: memref<8x32x8xi512>, %arg1: memref<32x8xi512>, %arg2: memref<128x8xi512>, %arg3: memref<8x8xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
// CHECK:     %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     adf.connect(%0, %arg4) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
// CHECK:     %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     adf.connect(%1, %arg5) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
// CHECK:     %2 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg6, %2) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %3 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg7, %3) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     adf.connect(%4, %arg8) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
// CHECK:     %5 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg9, %5) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %6 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg10, %6) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %7 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg11, %7) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %8 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     adf.connect(%8, %arg12) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
// CHECK:     %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg13, %9) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg14, %10) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg15, %11) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %12 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg16, %12) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     %13 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.connect(%arg17, %13) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
// CHECK:     adf.cell.launch @adf_cell0 {
// CHECK:       func.call @adf_cell0(%13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
// CHECK:       adf.cell.launch.end
// CHECK:     }
// CHECK:     adf.pl.launch @mttkrp_pl {
// CHECK:       func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) {adf.pl} : (memref<8x32x8xi512>, memref<32x8xi512>, memref<128x8xi512>, memref<8x8xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
// CHECK:       adf.pl.launch.wait
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @top(%arg0: memref<8x32x8xi512>, %arg1: memref<32x8xi512>, %arg2: memref<128x8xi512>, %arg3: memref<8x8xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {outArgs = [3 : i32], top_func = "plio"} {
// CHECK:     call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) : (memref<8x32x8xi512>, memref<32x8xi512>, memref<128x8xi512>, memref<8x8xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0) -> (d0 * 128 + 127)>
#map1 = affine_map<(d0) -> (d0 * 128)>
module {
  func.func private @adf_cell0(!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]}
  func.func @send3(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 8 {
                    affine.for %arg10 = 0 to 2 {
                      affine.for %arg11 = 0 to 4 {
                        %0 = affine.load %arg1[0] : memref<1xi128, "stream">
                        affine.store %0, %alloc[%arg8 + %arg6 * 2, %arg9 + %arg7 * 8, %arg11 + %arg10 * 4] : memref<4x16x8xi128, 1>
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {module = 0 : index}
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 2 {
                    affine.for %arg10 = 0 to 2 {
                      affine.for %arg11 = 0 to 8 {
                        affine.for %arg12 = 0 to 4 {
                          %0 = affine.load %alloc[%arg10 + %arg6 * 2, %arg11 + %arg8 * 8, %arg12 + %arg9 * 4] : memref<4x16x8xi128, 1>
                          affine.store %0, %arg0[0] : memref<1xi128, "plio">
                        } {pipeline_ii = 1 : index}
                      }
                    }
                  }
                }
              }
            } {module = 1 : index}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @send3_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @load2(%arg0: memref<128x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c1 = arith.constant 1 : index
    affine.for %arg5 = 0 to 1 {
      affine.for %arg6 = 0 to 2 {
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 16 {
                affine.for %arg11 = 0 to 2 {
                  affine.for %arg12 = 0 to 2 {
                    %0 = affine.load %arg0[%arg10 + %arg9 * 32 + %arg8 * 64, %arg12 + %arg11 * 2 + %arg6 * 4] : memref<128x8xi512>
                    %1 = arith.cmpi slt, %arg12, %c1 : index
                    scf.if %1 {
                      affine.store %0, %arg4[0] : memref<1xi512, "stream1">
                    } else {
                      affine.store %0, %arg2[0] : memref<1xi512, "stream1">
                    }
                  } {pipeline_ii = 1 : index}
                }
              }
            } {merge}
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 16 {
                affine.for %arg11 = 0 to 2 {
                  affine.for %arg12 = 0 to 2 {
                    %0 = affine.load %arg0[%arg10 + %arg9 * 32 + %arg8 * 64 + 16, %arg12 + %arg11 * 2 + %arg6 * 4] : memref<128x8xi512>
                    %1 = arith.cmpi slt, %arg12, %c1 : index
                    scf.if %1 {
                      affine.store %0, %arg3[0] : memref<1xi512, "stream1">
                    } else {
                      affine.store %0, %arg1[0] : memref<1xi512, "stream1">
                    }
                  } {pipeline_ii = 1 : index}
                }
              }
            } {merge}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @load2_top(%arg0: memref<128x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @load2(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<128x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @load2_3(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 16 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 1 {
                    %0 = affine.load %arg1[0] : memref<1xi512, "stream1">
                    affine.for %arg10 = 0 to 4 {
                      %1 = affine.apply #map(%arg10)
                      %2 = affine.apply #map1(%arg10)
                      %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
                      affine.store %3, %arg0[0] : memref<1xi128, "stream">
                    } {pipeline_ii = 1 : index}
                  } {pipeline_ii = 4 : index}
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @load2_3_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream1">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @load2_3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load2_3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load2_3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load2_3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @send5(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 8 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 4 {
                    %0 = affine.load %arg1[0] : memref<1xi128, "stream">
                    affine.store %0, %alloc[%arg7 + %arg6 * 8, %arg9 + %arg8 * 4] : memref<16x8xi128, 1>
                  } {pipeline_ii = 1 : index}
                }
              }
            } {module = 0 : index}
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 2 {
                    affine.for %arg10 = 0 to 8 {
                      affine.for %arg11 = 0 to 4 {
                        %0 = affine.load %alloc[%arg10 + %arg8 * 8, %arg11 + %arg7 * 4] : memref<16x8xi128, 1>
                        affine.store %0, %arg0[0] : memref<1xi128, "plio">
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {module = 1 : index}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @send5_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send5(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send5(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @receive2(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, receive, template} {
    %c96 = arith.constant 96 : index
    %c127 = arith.constant 127 : index
    %c64 = arith.constant 64 : index
    %c95 = arith.constant 95 : index
    %c32 = arith.constant 32 : index
    %c63 = arith.constant 63 : index
    %c31 = arith.constant 31 : index
    %c0_i128 = arith.constant 0 : i128
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<4x8xi128, 1>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 8 {
        affine.store %c0_i128, %alloc[%arg2, %arg3] : memref<4x8xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 2 {
                    affine.for %arg10 = 0 to 2 {
                      affine.for %arg11 = 0 to 4 {
                        %0 = affine.load %arg0[0] : memref<1xi128, "plio">
                        %1 = affine.load %alloc[%arg10 + %arg6 * 2, %arg11 + %arg7 * 4] : memref<4x8xi128, 1>
                        %2 = adf.int_to_apint(%0) : (i128) -> i128
                        %3 = adf.int_to_apint(%1) : (i128) -> i128
                        %4 = adf.int_to_apint(%c0_i128) : (i128) -> i128
                        %5 = adf.get_slice(%2 : i128, %c31, %c0) -> i32
                        %6 = adf.get_slice(%3 : i128, %c31, %c0) -> i32
                        %7 = arith.bitcast %5 : i32 to f32
                        %8 = arith.bitcast %6 : i32 to f32
                        %9 = arith.addf %7, %8 : f32
                        %10 = arith.bitcast %9 : f32 to i32
                        adf.set_slice(%4 : i128, %c31, %c0, %10 : i32)
                        %11 = adf.get_slice(%2 : i128, %c63, %c32) -> i32
                        %12 = adf.get_slice(%3 : i128, %c63, %c32) -> i32
                        %13 = arith.bitcast %11 : i32 to f32
                        %14 = arith.bitcast %12 : i32 to f32
                        %15 = arith.addf %13, %14 : f32
                        %16 = arith.bitcast %15 : f32 to i32
                        adf.set_slice(%4 : i128, %c63, %c32, %16 : i32)
                        %17 = adf.get_slice(%2 : i128, %c95, %c64) -> i32
                        %18 = adf.get_slice(%3 : i128, %c95, %c64) -> i32
                        %19 = arith.bitcast %17 : i32 to f32
                        %20 = arith.bitcast %18 : i32 to f32
                        %21 = arith.addf %19, %20 : f32
                        %22 = arith.bitcast %21 : f32 to i32
                        adf.set_slice(%4 : i128, %c95, %c64, %22 : i32)
                        %23 = adf.get_slice(%2 : i128, %c127, %c96) -> i32
                        %24 = adf.get_slice(%3 : i128, %c127, %c96) -> i32
                        %25 = arith.bitcast %23 : i32 to f32
                        %26 = arith.bitcast %24 : i32 to f32
                        %27 = arith.addf %25, %26 : f32
                        %28 = arith.bitcast %27 : f32 to i32
                        adf.set_slice(%4 : i128, %c127, %c96, %28 : i32)
                        %29 = adf.apint_to_int(%4) : (i128) -> i128
                        affine.store %29, %alloc[%arg10 + %arg6 * 2, %arg11 + %arg7 * 4] : memref<4x8xi128, 1>
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            }
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 4 {
                %0 = affine.load %alloc[%arg5 + %arg4 * 2, %arg7 + %arg6 * 4] : memref<4x8xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "stream">
                affine.store %c0_i128, %alloc[%arg5 + %arg4 * 2, %arg7 + %arg6 * 4] : memref<4x8xi128, 1>
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @receive2_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @receive2(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @send6(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 16 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 4 {
                    %0 = affine.load %arg1[0] : memref<1xi128, "stream">
                    affine.store %0, %alloc[%arg7 + %arg6 * 16, %arg9 + %arg8 * 4] : memref<32x8xi128, 1>
                  } {pipeline_ii = 1 : index}
                }
              }
            } {module = 0 : index}
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 2 {
                    affine.for %arg10 = 0 to 16 {
                      affine.for %arg11 = 0 to 4 {
                        %0 = affine.load %alloc[%arg10 + %arg9 * 16, %arg11 + %arg7 * 4] : memref<32x8xi128, 1>
                        affine.store %0, %arg0[0] : memref<1xi128, "plio">
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {module = 1 : index}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @send6_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send6(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @store0_0(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, store, template} {
    %c0_i512 = arith.constant 0 : i512
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 1 {
                %0 = adf.int_to_apint(%c0_i512) : (i512) -> i512
                affine.for %arg8 = 0 to 4 {
                  %1 = affine.load %arg0[0] : memref<1xi128, "stream">
                  %2 = affine.apply #map(%arg8)
                  %3 = affine.apply #map1(%arg8)
                  adf.set_slice(%0 : i512, %2, %3, %1 : i128)
                } {pipeline_ii = 1 : index}
                affine.store %0, %arg1[0] : memref<1xi512, "stream1">
              } {pipeline_ii = 4 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @store0_0_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream1">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @store0_0(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @store0_0(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @store0_0(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @store0_0(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @store0(%arg0: memref<8x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
    %c1 = arith.constant 1 : index
    affine.for %arg5 = 0 to 1 {
      affine.for %arg6 = 0 to 2 {
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 2 {
                %0 = arith.cmpi slt, %arg10, %c1 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg4[0] : memref<1xi512, "stream1">
                  scf.yield %2 : i512
                } else {
                  %2 = affine.load %arg3[0] : memref<1xi512, "stream1">
                  scf.yield %2 : i512
                }
                affine.store %1, %arg0[%arg8 + %arg7 * 4 + %arg5 * 8, %arg10 + %arg9 * 2 + %arg6 * 4] : memref<8x8xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 2 {
                %0 = arith.cmpi slt, %arg10, %c1 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg2[0] : memref<1xi512, "stream1">
                  scf.yield %2 : i512
                } else {
                  %2 = affine.load %arg1[0] : memref<1xi512, "stream1">
                  scf.yield %2 : i512
                }
                affine.store %1, %arg0[%arg8 + %arg7 * 4 + %arg5 * 8 + 2, %arg10 + %arg9 * 2 + %arg6 * 4] : memref<8x8xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
      }
    }
    return
  }
  func.func @store0_top(%arg0: memref<8x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @store0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<8x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @load0(%arg0: memref<8x32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c1 = arith.constant 1 : index
    affine.for %arg5 = 0 to 1 {
      affine.for %arg6 = 0 to 2 {
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 2 {
                affine.for %arg11 = 0 to 2 {
                  affine.for %arg12 = 0 to 8 {
                    affine.for %arg13 = 0 to 2 {
                      affine.for %arg14 = 0 to 2 {
                        %0 = affine.load %arg0[%arg11 + %arg9 * 4 + %arg5 * 8, %arg12 + %arg10 * 8 + %arg7 * 16, %arg14 + %arg13 * 2 + %arg8 * 4] : memref<8x32x8xi512>
                        %1 = arith.cmpi slt, %arg14, %c1 : index
                        scf.if %1 {
                          affine.store %0, %arg4[0] : memref<1xi512, "stream1">
                        } else {
                          affine.store %0, %arg3[0] : memref<1xi512, "stream1">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 2 {
                affine.for %arg11 = 0 to 2 {
                  affine.for %arg12 = 0 to 8 {
                    affine.for %arg13 = 0 to 2 {
                      affine.for %arg14 = 0 to 2 {
                        %0 = affine.load %arg0[%arg11 + %arg9 * 4 + %arg5 * 8 + 2, %arg12 + %arg10 * 8 + %arg7 * 16, %arg14 + %arg13 * 2 + %arg8 * 4] : memref<8x32x8xi512>
                        %1 = arith.cmpi slt, %arg14, %c1 : index
                        scf.if %1 {
                          affine.store %0, %arg2[0] : memref<1xi512, "stream1">
                        } else {
                          affine.store %0, %arg1[0] : memref<1xi512, "stream1">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @load0_top(%arg0: memref<8x32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @load0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<8x32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @load0_3(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 8 {
                    affine.for %arg10 = 0 to 2 {
                      affine.for %arg11 = 0 to 1 {
                        %0 = affine.load %arg1[0] : memref<1xi512, "stream1">
                        affine.for %arg12 = 0 to 4 {
                          %1 = affine.apply #map(%arg12)
                          %2 = affine.apply #map1(%arg12)
                          %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
                          affine.store %3, %arg0[0] : memref<1xi128, "stream">
                        } {pipeline_ii = 1 : index}
                      } {pipeline_ii = 4 : index}
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @load0_3_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream1">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @load0_3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load0_3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load0_3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load0_3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @load1(%arg0: memref<32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c1 = arith.constant 1 : index
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 2 {
        affine.for %arg5 = 0 to 2 {
          affine.for %arg6 = 0 to 2 {
            affine.for %arg7 = 0 to 2 {
              affine.for %arg8 = 0 to 8 {
                affine.for %arg9 = 0 to 2 {
                  affine.for %arg10 = 0 to 2 {
                    %0 = affine.load %arg0[%arg8 + %arg7 * 8 + %arg5 * 16, %arg10 + %arg9 * 2 + %arg4 * 4] : memref<32x8xi512>
                    %1 = arith.cmpi slt, %arg10, %c1 : index
                    scf.if %1 {
                      affine.store %0, %arg2[0] : memref<1xi512, "stream1">
                    } else {
                      affine.store %0, %arg1[0] : memref<1xi512, "stream1">
                    }
                  } {pipeline_ii = 1 : index}
                }
              }
            } {merge}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @load1_top(%arg0: memref<32x8xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @load1(%arg0, %arg1, %arg2) {template = 0 : index} : (memref<32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @load1_1(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 1 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 8 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 1 {
                    %0 = affine.load %arg1[0] : memref<1xi512, "stream1">
                    affine.for %arg10 = 0 to 4 {
                      %1 = affine.apply #map(%arg10)
                      %2 = affine.apply #map1(%arg10)
                      %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
                      affine.store %3, %arg0[0] : memref<1xi128, "stream">
                    } {pipeline_ii = 1 : index}
                  } {pipeline_ii = 4 : index}
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @load1_1_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
    call @load1_1(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load1_1(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @mttkrp_pl(%arg0: memref<8x32x8xi512>, %arg1: memref<32x8xi512>, %arg2: memref<128x8xi512>, %arg3: memref<8x8xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
    %alloc = memref.alloc() : memref<1xi128, "stream">
    %alloc_0 = memref.alloc() : memref<1xi128, "stream">
    %alloc_1 = memref.alloc() : memref<1xi128, "stream">
    %alloc_2 = memref.alloc() : memref<1xi128, "stream">
    %alloc_3 = memref.alloc() : memref<1xi128, "stream">
    %alloc_4 = memref.alloc() : memref<1xi128, "stream">
    %alloc_5 = memref.alloc() : memref<1xi128, "stream">
    %alloc_6 = memref.alloc() : memref<1xi128, "stream">
    %alloc_7 = memref.alloc() : memref<1xi128, "stream">
    %alloc_8 = memref.alloc() : memref<1xi128, "stream">
    %alloc_9 = memref.alloc() : memref<1xi128, "stream">
    %alloc_10 = memref.alloc() : memref<1xi128, "stream">
    %alloc_11 = memref.alloc() : memref<1xi128, "stream">
    %alloc_12 = memref.alloc() : memref<1xi128, "stream">
    %alloc_13 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_14 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_15 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_16 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_17 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_18 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_19 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_20 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_21 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_22 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_23 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_24 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_25 = memref.alloc() : memref<1xi512, "stream1">
    %alloc_26 = memref.alloc() : memref<1xi512, "stream1">
    call @send3_top(%arg14, %alloc_9, %arg7, %alloc_4, %arg6, %alloc_3, %arg17, %alloc_12) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @load2_top(%arg2, %alloc_13, %alloc_14, %alloc_15, %alloc_16) : (memref<128x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    call @load2_3_top(%alloc_10, %alloc_16, %alloc_8, %alloc_15, %alloc_6, %alloc_14, %alloc_5, %alloc_13) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @send5_top(%arg11, %alloc_7, %arg16, %alloc_11) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2_top(%arg5, %alloc_1, %arg12, %alloc, %arg4, %alloc_2, %arg8, %alloc_0) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6_top(%arg10, %alloc_6, %arg13, %alloc_8, %arg9, %alloc_5, %arg15, %alloc_10) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @store0_0_top(%alloc_2, %alloc_17, %alloc_1, %alloc_18, %alloc_0, %alloc_19, %alloc, %alloc_20) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @store0_top(%arg3, %alloc_17, %alloc_18, %alloc_19, %alloc_20) : (memref<8x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    call @load0_top(%arg0, %alloc_21, %alloc_22, %alloc_23, %alloc_24) : (memref<8x32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    call @load0_3_top(%alloc_12, %alloc_24, %alloc_9, %alloc_23, %alloc_4, %alloc_22, %alloc_3, %alloc_21) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    call @load1_top(%arg1, %alloc_25, %alloc_26) : (memref<32x8xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
    call @load1_1_top(%alloc_11, %alloc_26, %alloc_7, %alloc_25) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
    return
  }
  func.func @mttkrp(%arg0: memref<8x32x8xi512>, %arg1: memref<32x8xi512>, %arg2: memref<128x8xi512>, %arg3: memref<8x8xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
    %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%0, %arg4) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%1, %arg5) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %2 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg6, %2) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %3 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg7, %3) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%4, %arg8) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %5 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg9, %5) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %6 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg10, %6) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %7 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg11, %7) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %8 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%8, %arg12) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg13, %9) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg14, %10) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg15, %11) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %12 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg16, %12) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %13 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg17, %13) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    adf.cell.launch @adf_cell0 {
      func.call @adf_cell0(%13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
      adf.cell.launch.end
    }
    adf.pl.launch @mttkrp_pl {
      func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) {adf.pl} : (memref<8x32x8xi512>, memref<32x8xi512>, memref<128x8xi512>, memref<8x8xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
      adf.pl.launch.wait
    }
    return
  }
  func.func @top(%arg0: memref<8x32x8xi512>, %arg1: memref<32x8xi512>, %arg2: memref<128x8xi512>, %arg3: memref<8x8xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {outArgs = [3 : i32], top_func = "plio"} {
    call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) : (memref<8x32x8xi512>, memref<32x8xi512>, memref<128x8xi512>, memref<8x8xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
    return
  }
}