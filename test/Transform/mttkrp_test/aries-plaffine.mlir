// RUN: aries-opt -aries-pl-dma-to-affine -cse -canonicalize %s | FileCheck %s

// CHECK: module {
// CHECK:   func.func private @adf_cell0(!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]}
// CHECK:   func.func @mttkrp_pl(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.pl = true, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
// CHECK:     %c96 = arith.constant 96 : index
// CHECK:     %c127 = arith.constant 127 : index
// CHECK:     %c64 = arith.constant 64 : index
// CHECK:     %c95 = arith.constant 95 : index
// CHECK:     %c32 = arith.constant 32 : index
// CHECK:     %c63 = arith.constant 63 : index
// CHECK:     %c31 = arith.constant 31 : index
// CHECK:     %c0_i128 = arith.constant 0 : i128
// CHECK:     %c0 = arith.constant 0 : index
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
// CHECK:     %alloc_13 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_14 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_15 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_16 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_17 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_18 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_19 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_20 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_21 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
// CHECK:     %alloc_22 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_23 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_24 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_25 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
// CHECK:     %alloc_26 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_9[0] : memref<1xi128, "stream">
// CHECK:                         affine.store %0, %alloc_23[%arg24 + %arg22 * 2, %arg25 + %arg23 * 8, %arg27 + %arg26 * 4] : memref<4x16x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 8 {
// CHECK:                         affine.for %arg28 = 0 to 4 {
// CHECK:                           %0 = affine.load %alloc_23[%arg26 + %arg22 * 2, %arg27 + %arg24 * 8, %arg28 + %arg25 * 4] : memref<4x16x8xi128, 1>
// CHECK:                           affine.store %0, %arg14[0] : memref<1xi128, "plio">
// CHECK:                         } {pipeline_ii = 1 : index}
// CHECK:                       }
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 3 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg2[%arg23 + %arg22 * 32 + %arg21 * 64, %arg25 + %arg24 * 8 + %arg19 * 16] : memref<128x32xi128>
// CHECK:                     affine.store %0, %alloc_10[0] : memref<1xi128, "stream">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg2[%arg23 + %arg22 * 32 + %arg21 * 64 + 16, %arg25 + %arg24 * 8 + %arg19 * 16] : memref<128x32xi128>
// CHECK:                     affine.store %0, %alloc_8[0] : memref<1xi128, "stream">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg2[%arg23 + %arg22 * 32 + %arg21 * 64, %arg25 + %arg24 * 8 + %arg19 * 16 + 4] : memref<128x32xi128>
// CHECK:                     affine.store %0, %alloc_6[0] : memref<1xi128, "stream">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg2[%arg23 + %arg22 * 32 + %arg21 * 64 + 16, %arg25 + %arg24 * 8 + %arg19 * 16 + 4] : memref<128x32xi128>
// CHECK:                     affine.store %0, %alloc_5[0] : memref<1xi128, "stream">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {load = 2 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 8 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %alloc_7[0] : memref<1xi128, "stream">
// CHECK:                     affine.store %0, %alloc_21[%arg23 + %arg22 * 8, %arg25 + %arg24 * 4] : memref<16x8xi128, 1>
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 8 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_21[%arg26 + %arg24 * 8, %arg27 + %arg23 * 4] : memref<16x8xi128, 1>
// CHECK:                         affine.store %0, %arg11[0] : memref<1xi128, "plio">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 5 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 8 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %alloc_11[0] : memref<1xi128, "stream">
// CHECK:                     affine.store %0, %alloc_25[%arg23 + %arg22 * 8, %arg25 + %arg24 * 4] : memref<16x8xi128, 1>
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 8 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_25[%arg26 + %arg24 * 8, %arg27 + %arg23 * 4] : memref<16x8xi128, 1>
// CHECK:                         affine.store %0, %arg16[0] : memref<1xi128, "plio">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 1 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_4[0] : memref<1xi128, "stream">
// CHECK:                         affine.store %0, %alloc_18[%arg24 + %arg22 * 2, %arg25 + %arg23 * 8, %arg27 + %arg26 * 4] : memref<4x16x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 8 {
// CHECK:                         affine.for %arg28 = 0 to 4 {
// CHECK:                           %0 = affine.load %alloc_18[%arg26 + %arg22 * 2, %arg27 + %arg24 * 8, %arg28 + %arg25 * 4] : memref<4x16x8xi128, 1>
// CHECK:                           affine.store %0, %arg7[0] : memref<1xi128, "plio">
// CHECK:                         } {pipeline_ii = 1 : index}
// CHECK:                       }
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 8 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg5[0] : memref<1xi128, "plio">
// CHECK:                         %1 = affine.load %alloc_14[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
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
// CHECK:                         affine.store %29, %alloc_14[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_14[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:                 affine.store %0, %alloc_1[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %c0_i128, %alloc_14[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     } {receive = 2 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg12[0] : memref<1xi128, "plio">
// CHECK:                         %1 = affine.load %alloc_16[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
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
// CHECK:                         affine.store %29, %alloc_16[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_16[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:                 affine.store %0, %alloc[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %c0_i128, %alloc_16[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     } {receive = 0 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg4[0] : memref<1xi128, "plio">
// CHECK:                         %1 = affine.load %alloc_13[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
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
// CHECK:                         affine.store %29, %alloc_13[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_13[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:                 affine.store %0, %alloc_2[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %c0_i128, %alloc_13[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     } {receive = 3 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_3[0] : memref<1xi128, "stream">
// CHECK:                         affine.store %0, %alloc_17[%arg24 + %arg22 * 2, %arg25 + %arg23 * 8, %arg27 + %arg26 * 4] : memref<4x16x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 8 {
// CHECK:                         affine.for %arg28 = 0 to 4 {
// CHECK:                           %0 = affine.load %alloc_17[%arg26 + %arg22 * 2, %arg27 + %arg24 * 8, %arg28 + %arg25 * 4] : memref<4x16x8xi128, 1>
// CHECK:                           affine.store %0, %arg6[0] : memref<1xi128, "plio">
// CHECK:                         } {pipeline_ii = 1 : index}
// CHECK:                       }
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 9 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %alloc_6[0] : memref<1xi128, "stream">
// CHECK:                     affine.store %0, %alloc_20[%arg23 + %arg22 * 16, %arg25 + %arg24 * 4] : memref<32x8xi128, 1>
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 16 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_20[%arg26 + %arg25 * 16, %arg27 + %arg23 * 4] : memref<32x8xi128, 1>
// CHECK:                         affine.store %0, %arg10[0] : memref<1xi128, "plio">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 6 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_12[0] : memref<1xi128, "stream">
// CHECK:                         affine.store %0, %alloc_26[%arg24 + %arg22 * 2, %arg25 + %arg23 * 8, %arg27 + %arg26 * 4] : memref<4x16x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 8 {
// CHECK:                         affine.for %arg28 = 0 to 4 {
// CHECK:                           %0 = affine.load %alloc_26[%arg26 + %arg22 * 2, %arg27 + %arg24 * 8, %arg28 + %arg25 * 4] : memref<4x16x8xi128, 1>
// CHECK:                           affine.store %0, %arg17[0] : memref<1xi128, "plio">
// CHECK:                         } {pipeline_ii = 1 : index}
// CHECK:                       }
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 0 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %alloc_8[0] : memref<1xi128, "stream">
// CHECK:                     affine.store %0, %alloc_22[%arg23 + %arg22 * 16, %arg25 + %arg24 * 4] : memref<32x8xi128, 1>
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 16 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_22[%arg26 + %arg25 * 16, %arg27 + %arg23 * 4] : memref<32x8xi128, 1>
// CHECK:                         affine.store %0, %arg13[0] : memref<1xi128, "plio">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 4 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %0, %arg3[%arg21 + %arg20 * 4 + %arg18 * 8, %arg23 + %arg22 * 8 + %arg19 * 16] : memref<8x32xi128>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_0[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %0, %arg3[%arg21 + %arg20 * 4 + %arg18 * 8, %arg23 + %arg22 * 8 + %arg19 * 16 + 4] : memref<8x32xi128>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_1[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %0, %arg3[%arg21 + %arg20 * 4 + %arg18 * 8 + 2, %arg23 + %arg22 * 8 + %arg19 * 16] : memref<8x32xi128>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_2[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %0, %arg3[%arg21 + %arg20 * 4 + %arg18 * 8 + 2, %arg23 + %arg22 * 8 + %arg19 * 16 + 4] : memref<8x32xi128>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:       }
// CHECK:     } {store = 0 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg8[0] : memref<1xi128, "plio">
// CHECK:                         %1 = affine.load %alloc_15[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
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
// CHECK:                         affine.store %29, %alloc_15[%arg26 + %arg22 * 2, %arg27 + %arg23 * 4] : memref<4x8xi128, 1>
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             }
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 4 {
// CHECK:                 %0 = affine.load %alloc_15[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:                 affine.store %0, %alloc_0[0] : memref<1xi128, "stream">
// CHECK:                 affine.store %c0_i128, %alloc_15[%arg21 + %arg20 * 2, %arg23 + %arg22 * 4] : memref<4x8xi128, 1>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     } {receive = 1 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg0[%arg24 + %arg22 * 4 + %arg18 * 8, %arg25 + %arg23 * 8 + %arg20 * 16, %arg27 + %arg26 * 8 + %arg21 * 16] : memref<8x32x32xi128>
// CHECK:                         affine.store %0, %alloc_12[0] : memref<1xi128, "stream">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg0[%arg24 + %arg22 * 4 + %arg18 * 8, %arg25 + %arg23 * 8 + %arg20 * 16, %arg27 + %arg26 * 8 + %arg21 * 16 + 4] : memref<8x32x32xi128>
// CHECK:                         affine.store %0, %alloc_9[0] : memref<1xi128, "stream">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg0[%arg24 + %arg22 * 4 + %arg18 * 8 + 2, %arg25 + %arg23 * 8 + %arg20 * 16, %arg27 + %arg26 * 8 + %arg21 * 16] : memref<8x32x32xi128>
// CHECK:                         affine.store %0, %alloc_4[0] : memref<1xi128, "stream">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 8 {
// CHECK:                     affine.for %arg26 = 0 to 2 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %arg0[%arg24 + %arg22 * 4 + %arg18 * 8 + 2, %arg25 + %arg23 * 8 + %arg20 * 16, %arg27 + %arg26 * 8 + %arg21 * 16 + 4] : memref<8x32x32xi128>
// CHECK:                         affine.store %0, %alloc_3[0] : memref<1xi128, "stream">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {load = 0 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 8 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg1[%arg23 + %arg22 * 8 + %arg20 * 16, %arg25 + %arg24 * 8 + %arg19 * 16] : memref<32x32xi128>
// CHECK:                     affine.store %0, %alloc_11[0] : memref<1xi128, "stream">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 8 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %arg1[%arg23 + %arg22 * 8 + %arg20 * 16, %arg25 + %arg24 * 8 + %arg19 * 16 + 4] : memref<32x32xi128>
// CHECK:                     affine.store %0, %alloc_7[0] : memref<1xi128, "stream">
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {load = 1 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %alloc_5[0] : memref<1xi128, "stream">
// CHECK:                     affine.store %0, %alloc_19[%arg23 + %arg22 * 16, %arg25 + %arg24 * 4] : memref<32x8xi128, 1>
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 16 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_19[%arg26 + %arg25 * 16, %arg27 + %arg23 * 4] : memref<32x8xi128, 1>
// CHECK:                         affine.store %0, %arg9[0] : memref<1xi128, "plio">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 7 : index}
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 16 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 4 {
// CHECK:                     %0 = affine.load %alloc_10[0] : memref<1xi128, "stream">
// CHECK:                     affine.store %0, %alloc_24[%arg23 + %arg22 * 16, %arg25 + %arg24 * 4] : memref<32x8xi128, 1>
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     affine.for %arg26 = 0 to 16 {
// CHECK:                       affine.for %arg27 = 0 to 4 {
// CHECK:                         %0 = affine.load %alloc_24[%arg26 + %arg25 * 16, %arg27 + %arg23 * 4] : memref<32x8xi128, 1>
// CHECK:                         affine.store %0, %arg15[0] : memref<1xi128, "plio">
// CHECK:                       } {pipeline_ii = 1 : index}
// CHECK:                     }
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {module = 1 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     } {send = 2 : index}
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @mttkrp(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
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
// CHECK:       func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) {adf.pl} : (memref<8x32x32xi128>, memref<32x32xi128>, memref<128x32xi128>, memref<8x32xi128>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
// CHECK:       adf.pl.launch.wait
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @top(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {outArgs = [3 : i32], top_func = "plio"} {
// CHECK:     call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) : (memref<8x32x32xi128>, memref<32x32xi128>, memref<128x32xi128>, memref<8x32xi128>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
#map1 = affine_map<(d0) -> (d0 * 2)>
#map2 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
#map3 = affine_map<(d0) -> (d0 * 8)>
#map4 = affine_map<(d0) -> (d0 * 4)>
#map5 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
#map6 = affine_map<(d0) -> (d0 * 16)>
#map7 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16 + 4)>
#map8 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
#map9 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
module {
  func.func private @adf_cell0(!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]}
  func.func @mttkrp_pl(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: !adf.plio<Out, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<Out, 128>, %arg9: !adf.plio<In, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<Out, 128>, %arg13: !adf.plio<In, 128>, %arg14: !adf.plio<In, 128>, %arg15: !adf.plio<In, 128>, %arg16: !adf.plio<In, 128>, %arg17: !adf.plio<In, 128>) attributes {adf.pl = true, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
    %c4 = arith.constant 4 : index
    %c16 = arith.constant 16 : index
    %c8 = arith.constant 8 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
    %alloc_1 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
    %alloc_2 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
    %alloc_3 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
    %alloc_4 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
    %alloc_5 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
    %alloc_6 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
    %alloc_7 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
    %alloc_8 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
    %alloc_9 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
    %alloc_10 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
    %alloc_11 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
    %alloc_12 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
    affine.for %arg18 = 0 to 1 {
      affine.for %arg19 = 0 to 2 {
        affine.for %arg20 = 0 to 2 {
          affine.for %arg21 = 0 to 2 {
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  %0 = affine.apply #map(%arg22, %arg18)
                  %1 = affine.apply #map1(%arg22)
                  %2 = affine.apply #map2(%arg23, %arg20)
                  %3 = affine.apply #map3(%arg23)
                  %4 = affine.apply #map2(%arg24, %arg21)
                  %5 = affine.apply #map4(%arg24)
                  adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_12[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
                }
              }
            } {load = 0 : index, send = 0 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map3(%arg24)
                    %2 = affine.apply #map4(%arg25)
                    adf.io.push(%alloc_12[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg17) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 0 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map2(%arg22, %arg20)
                %1 = affine.apply #map3(%arg22)
                %2 = affine.apply #map2(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%arg1[%0, %2] [%c8, %c4] [%c1, %c1] [] [] [] [], %alloc_11[%1, %3] [%c8, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<32x32xi128>, memref<16x8xi128, 1>)
              }
            } {load = 1 : index, send = 1 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map3(%arg24)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.push(%alloc_11[%0, %1] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg16) {type = f32} : (memref<16x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 1 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map5(%arg22, %arg21)
                %1 = affine.apply #map6(%arg22)
                %2 = affine.apply #map2(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_10[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
              }
            } {load = 2 : index, send = 2 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map6(%arg25)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.push(%alloc_10[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg15) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 2 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  %0 = affine.apply #map(%arg22, %arg18)
                  %1 = affine.apply #map1(%arg22)
                  %2 = affine.apply #map2(%arg23, %arg20)
                  %3 = affine.apply #map3(%arg23)
                  %4 = affine.apply #map7(%arg24, %arg21)
                  %5 = affine.apply #map4(%arg24)
                  adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_9[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
                }
              }
            } {load = 0 : index, send = 3 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map3(%arg24)
                    %2 = affine.apply #map4(%arg25)
                    adf.io.push(%alloc_9[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg14) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 3 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map8(%arg22, %arg21)
                %1 = affine.apply #map6(%arg22)
                %2 = affine.apply #map2(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_8[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
              }
            } {load = 2 : index, send = 4 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map6(%arg25)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.push(%alloc_8[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg13) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 4 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map2(%arg22, %arg20)
                %1 = affine.apply #map3(%arg22)
                %2 = affine.apply #map7(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%arg1[%0, %2] [%c8, %c4] [%c1, %c1] [] [] [] [], %alloc_7[%1, %3] [%c8, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<32x32xi128>, memref<16x8xi128, 1>)
              }
            } {load = 1 : index, send = 5 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map3(%arg24)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.push(%alloc_7[%0, %1] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg11) {type = f32} : (memref<16x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 5 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map5(%arg22, %arg21)
                %1 = affine.apply #map6(%arg22)
                %2 = affine.apply #map7(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_6[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
              }
            } {load = 2 : index, send = 6 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map6(%arg25)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.push(%alloc_6[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg10) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 6 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map8(%arg22, %arg21)
                %1 = affine.apply #map6(%arg22)
                %2 = affine.apply #map7(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_5[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
              }
            } {load = 2 : index, send = 7 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map6(%arg25)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.push(%alloc_5[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg9) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 7 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  %0 = affine.apply #map9(%arg22, %arg18)
                  %1 = affine.apply #map1(%arg22)
                  %2 = affine.apply #map2(%arg23, %arg20)
                  %3 = affine.apply #map3(%arg23)
                  %4 = affine.apply #map2(%arg24, %arg21)
                  %5 = affine.apply #map4(%arg24)
                  adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_4[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
                }
              }
            } {load = 0 : index, send = 8 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map3(%arg24)
                    %2 = affine.apply #map4(%arg25)
                    adf.io.push(%alloc_4[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg7) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 8 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  %0 = affine.apply #map9(%arg22, %arg18)
                  %1 = affine.apply #map1(%arg22)
                  %2 = affine.apply #map2(%arg23, %arg20)
                  %3 = affine.apply #map3(%arg23)
                  %4 = affine.apply #map7(%arg24, %arg21)
                  %5 = affine.apply #map4(%arg24)
                  adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_3[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
                }
              }
            } {load = 0 : index, send = 9 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map3(%arg24)
                    %2 = affine.apply #map4(%arg25)
                    adf.io.push(%alloc_3[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg6) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
                  }
                }
              }
            } {send = 9 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.pop(%arg4, %alloc[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
                  }
                }
              }
            } {receive = 3 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map9(%arg22, %arg18)
                %1 = affine.apply #map1(%arg22)
                %2 = affine.apply #map7(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%alloc[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
              }
            } {hoist = [0, 1], receive = 3 : index, store = 0 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.pop(%arg5, %alloc_0[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
                  }
                }
              }
            } {receive = 2 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map9(%arg22, %arg18)
                %1 = affine.apply #map1(%arg22)
                %2 = affine.apply #map2(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%alloc_0[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
              }
            } {hoist = [0, 1], receive = 2 : index, store = 0 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.pop(%arg8, %alloc_1[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
                  }
                }
              }
            } {receive = 1 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map(%arg22, %arg18)
                %1 = affine.apply #map1(%arg22)
                %2 = affine.apply #map7(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%alloc_1[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
              }
            } {hoist = [0, 1], receive = 1 : index, store = 0 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map1(%arg22)
                    %1 = affine.apply #map4(%arg23)
                    adf.io.pop(%arg12, %alloc_2[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
                  }
                }
              }
            } {receive = 0 : index}
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                %0 = affine.apply #map(%arg22, %arg18)
                %1 = affine.apply #map1(%arg22)
                %2 = affine.apply #map2(%arg23, %arg19)
                %3 = affine.apply #map4(%arg23)
                adf.dma(%alloc_2[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
              }
            } {hoist = [0, 1], receive = 0 : index, store = 0 : index}
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
  func.func @mttkrp(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
    %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %2 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %3 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %5 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %6 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %7 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %8 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %12 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %13 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.cell.launch @adf_cell0 {
      func.call @adf_cell0(%13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
      adf.cell.launch.end
    }
    adf.pl.launch @mttkrp_pl {
      func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %0, %1, %2, %3, %4, %5, %6, %7, %8, %9, %10, %11, %12, %13) {adf.pl} : (memref<8x32x32xi128>, memref<32x32xi128>, memref<128x32xi128>, memref<8x32xi128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>) -> ()
      adf.pl.launch.wait
    }
    return
  }
  func.func @top(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>) attributes {outArgs = [3 : i32], top_func} {
    call @mttkrp(%arg0, %arg1, %arg2, %arg3) : (memref<8x32x32xi128>, memref<32x32xi128>, memref<128x32xi128>, memref<8x32xi128>) -> ()
    return
  }
}