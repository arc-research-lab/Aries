// RUN: aries-opt -aries-pl-buffer-extract="buf-sels=0,1,0,1" -cse -canonicalize %s | FileCheck %s

// CHECK: #map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
// CHECK: #map1 = affine_map<(d0) -> (d0 * 2)>
// CHECK: #map2 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
// CHECK: #map3 = affine_map<(d0) -> (d0 * 8)>
// CHECK: #map4 = affine_map<(d0) -> (d0 * 4)>
// CHECK: #map5 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
// CHECK: #map6 = affine_map<(d0) -> (d0 * 16)>
// CHECK: #map7 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16 + 4)>
// CHECK: #map8 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
// CHECK: #map9 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
// CHECK: module {
// CHECK:   func.func @mttkrp_pl(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: !adf.plio<Out, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<Out, 128>, %arg9: !adf.plio<In, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<Out, 128>, %arg13: !adf.plio<In, 128>, %arg14: !adf.plio<In, 128>, %arg15: !adf.plio<In, 128>, %arg16: !adf.plio<In, 128>, %arg17: !adf.plio<In, 128>) attributes {adf.pl = true, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %alloc = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_0 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_1 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_2 = memref.alloc() {buffer_type = "bram_s2p", init} : memref<4x8xi128, 1>
// CHECK:     %alloc_3 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_4 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_5 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_6 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_7 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
// CHECK:     %alloc_8 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_9 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     %alloc_10 = memref.alloc() {buffer_type = "uram_t2p"} : memref<32x8xi128, 1>
// CHECK:     %alloc_11 = memref.alloc() {buffer_type = "bram_s2p"} : memref<16x8xi128, 1>
// CHECK:     %alloc_12 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x16x8xi128, 1>
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   %0 = affine.apply #map(%arg22, %arg18)
// CHECK:                   %1 = affine.apply #map1(%arg22)
// CHECK:                   %2 = affine.apply #map2(%arg23, %arg20)
// CHECK:                   %3 = affine.apply #map3(%arg23)
// CHECK:                   %4 = affine.apply #map2(%arg24, %arg21)
// CHECK:                   %5 = affine.apply #map4(%arg24)
// CHECK:                   adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_12[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
// CHECK:                 }
// CHECK:               }
// CHECK:             } {load = 0 : index, send = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map3(%arg24)
// CHECK:                     %2 = affine.apply #map4(%arg25)
// CHECK:                     adf.io.push(%alloc_12[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg17) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map2(%arg22, %arg20)
// CHECK:                 %1 = affine.apply #map3(%arg22)
// CHECK:                 %2 = affine.apply #map2(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%arg1[%0, %2] [%c8, %c4] [%c1, %c1] [] [] [] [], %alloc_11[%1, %3] [%c8, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<32x32xi128>, memref<16x8xi128, 1>)
// CHECK:               }
// CHECK:             } {load = 1 : index, send = 1 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map3(%arg24)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.push(%alloc_11[%0, %1] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg16) {type = f32} : (memref<16x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 1 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map5(%arg22, %arg21)
// CHECK:                 %1 = affine.apply #map6(%arg22)
// CHECK:                 %2 = affine.apply #map2(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_10[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
// CHECK:               }
// CHECK:             } {load = 2 : index, send = 2 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map6(%arg25)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.push(%alloc_10[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg15) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 2 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   %0 = affine.apply #map(%arg22, %arg18)
// CHECK:                   %1 = affine.apply #map1(%arg22)
// CHECK:                   %2 = affine.apply #map2(%arg23, %arg20)
// CHECK:                   %3 = affine.apply #map3(%arg23)
// CHECK:                   %4 = affine.apply #map7(%arg24, %arg21)
// CHECK:                   %5 = affine.apply #map4(%arg24)
// CHECK:                   adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_9[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
// CHECK:                 }
// CHECK:               }
// CHECK:             } {load = 0 : index, send = 3 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map3(%arg24)
// CHECK:                     %2 = affine.apply #map4(%arg25)
// CHECK:                     adf.io.push(%alloc_9[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg14) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 3 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map8(%arg22, %arg21)
// CHECK:                 %1 = affine.apply #map6(%arg22)
// CHECK:                 %2 = affine.apply #map2(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_8[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
// CHECK:               }
// CHECK:             } {load = 2 : index, send = 4 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map6(%arg25)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.push(%alloc_8[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg13) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 4 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map2(%arg22, %arg20)
// CHECK:                 %1 = affine.apply #map3(%arg22)
// CHECK:                 %2 = affine.apply #map7(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%arg1[%0, %2] [%c8, %c4] [%c1, %c1] [] [] [] [], %alloc_7[%1, %3] [%c8, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<32x32xi128>, memref<16x8xi128, 1>)
// CHECK:               }
// CHECK:             } {load = 1 : index, send = 5 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map3(%arg24)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.push(%alloc_7[%0, %1] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg11) {type = f32} : (memref<16x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 5 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map5(%arg22, %arg21)
// CHECK:                 %1 = affine.apply #map6(%arg22)
// CHECK:                 %2 = affine.apply #map7(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_6[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
// CHECK:               }
// CHECK:             } {load = 2 : index, send = 6 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map6(%arg25)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.push(%alloc_6[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg10) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 6 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map8(%arg22, %arg21)
// CHECK:                 %1 = affine.apply #map6(%arg22)
// CHECK:                 %2 = affine.apply #map7(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%arg2[%0, %2] [%c16, %c4] [%c1, %c1] [] [] [] [], %alloc_5[%1, %3] [%c16, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<128x32xi128>, memref<32x8xi128, 1>)
// CHECK:               }
// CHECK:             } {load = 2 : index, send = 7 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map6(%arg25)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.push(%alloc_5[%0, %1] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg9) {type = f32} : (memref<32x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 7 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   %0 = affine.apply #map9(%arg22, %arg18)
// CHECK:                   %1 = affine.apply #map1(%arg22)
// CHECK:                   %2 = affine.apply #map2(%arg23, %arg20)
// CHECK:                   %3 = affine.apply #map3(%arg23)
// CHECK:                   %4 = affine.apply #map2(%arg24, %arg21)
// CHECK:                   %5 = affine.apply #map4(%arg24)
// CHECK:                   adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_4[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
// CHECK:                 }
// CHECK:               }
// CHECK:             } {load = 0 : index, send = 8 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map3(%arg24)
// CHECK:                     %2 = affine.apply #map4(%arg25)
// CHECK:                     adf.io.push(%alloc_4[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg7) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 8 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   %0 = affine.apply #map9(%arg22, %arg18)
// CHECK:                   %1 = affine.apply #map1(%arg22)
// CHECK:                   %2 = affine.apply #map2(%arg23, %arg20)
// CHECK:                   %3 = affine.apply #map3(%arg23)
// CHECK:                   %4 = affine.apply #map7(%arg24, %arg21)
// CHECK:                   %5 = affine.apply #map4(%arg24)
// CHECK:                   adf.dma(%arg0[%0, %2, %4] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %alloc_3[%1, %3, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] []) {type = f32} : (memref<8x32x32xi128>, memref<4x16x8xi128, 1>)
// CHECK:                 }
// CHECK:               }
// CHECK:             } {load = 0 : index, send = 9 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map3(%arg24)
// CHECK:                     %2 = affine.apply #map4(%arg25)
// CHECK:                     adf.io.push(%alloc_3[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg6) {type = f32} : (memref<4x16x8xi128, 1>, !adf.plio<In, 128>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {send = 9 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.pop(%arg4, %alloc[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {receive = 3 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map9(%arg22, %arg18)
// CHECK:                 %1 = affine.apply #map1(%arg22)
// CHECK:                 %2 = affine.apply #map7(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%alloc[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
// CHECK:               }
// CHECK:             } {hoist = [0, 1], receive = 3 : index, store = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.pop(%arg5, %alloc_0[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {receive = 2 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map9(%arg22, %arg18)
// CHECK:                 %1 = affine.apply #map1(%arg22)
// CHECK:                 %2 = affine.apply #map2(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%alloc_0[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
// CHECK:               }
// CHECK:             } {hoist = [0, 1], receive = 2 : index, store = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.pop(%arg8, %alloc_1[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {receive = 1 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map(%arg22, %arg18)
// CHECK:                 %1 = affine.apply #map1(%arg22)
// CHECK:                 %2 = affine.apply #map7(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%alloc_1[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
// CHECK:               }
// CHECK:             } {hoist = [0, 1], receive = 1 : index, store = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map1(%arg22)
// CHECK:                     %1 = affine.apply #map4(%arg23)
// CHECK:                     adf.io.pop(%arg12, %alloc_2[%0, %1] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, type = f32} : (!adf.plio<Out, 128>, memref<4x8xi128, 1>)
// CHECK:                   }
// CHECK:                 }
// CHECK:               }
// CHECK:             } {receive = 0 : index}
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 %0 = affine.apply #map(%arg22, %arg18)
// CHECK:                 %1 = affine.apply #map1(%arg22)
// CHECK:                 %2 = affine.apply #map2(%arg23, %arg19)
// CHECK:                 %3 = affine.apply #map4(%arg23)
// CHECK:                 adf.dma(%alloc_2[%1, %3] [%c2, %c4] [%c1, %c1] [] [] [] [], %arg3[%0, %2] [%c2, %c4] [%c1, %c1] [] [] [] []) {type = f32} : (memref<4x8xi128, 1>, memref<8x32xi128>)
// CHECK:               }
// CHECK:             } {hoist = [0, 1], receive = 0 : index, store = 0 : index}
// CHECK:           } {Array_Partition, reduction = 1 : i64}
// CHECK:         } {reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
#map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
#map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
#map3 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16 + 4)>
#map4 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
#map5 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
module {
  func.func @mttkrp_pl(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: !adf.plio<Out, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<Out, 128>, %arg9: !adf.plio<In, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<Out, 128>, %arg13: !adf.plio<In, 128>, %arg14: !adf.plio<In, 128>, %arg15: !adf.plio<In, 128>, %arg16: !adf.plio<In, 128>, %arg17: !adf.plio<In, 128>) attributes {adf.pl = true, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c16 = arith.constant 16 : index
    %c4 = arith.constant 4 : index
    affine.for %arg18 = 0 to 1 {
      affine.for %arg19 = 0 to 2 {
        affine.for %arg20 = 0 to 2 {
          affine.for %arg21 = 0 to 2 {
            affine.for %arg22 = 0 to 2 {
              affine.for %arg23 = 0 to 2 {
                affine.for %arg24 = 0 to 2 {
                  affine.for %arg25 = 0 to 2 {
                    %0 = affine.apply #map(%arg22, %arg18)
                    %1 = affine.apply #map1(%arg24, %arg20)
                    %2 = affine.apply #map1(%arg25, %arg21)
                    %3 = affine.apply #map2(%arg25, %arg21)
                    adf.io.push(%arg0[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg17) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                    %4 = affine.apply #map1(%arg23, %arg19)
                    adf.io.push(%arg1[%1, %4] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg16) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
                    adf.io.push(%arg2[%3, %4] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg15) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                    %5 = affine.apply #map3(%arg25, %arg21)
                    %6 = affine.apply #map4(%arg25, %arg21)
                    adf.io.push(%arg0[%0, %1, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg14) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                    adf.io.push(%arg2[%6, %4] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg13) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                    %7 = affine.apply #map3(%arg23, %arg19)
                    adf.io.push(%arg1[%1, %7] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg11) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
                    adf.io.push(%arg2[%3, %7] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg10) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                    adf.io.push(%arg2[%6, %7] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg9) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                    %8 = affine.apply #map5(%arg22, %arg18)
                    adf.io.push(%arg0[%8, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg7) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                    adf.io.push(%arg0[%8, %1, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg6) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                    adf.io.pop(%arg12, %arg3[%0, %4] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                    adf.io.pop(%arg8, %arg3[%0, %7] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                    adf.io.pop(%arg5, %arg3[%8, %4] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                    adf.io.pop(%arg4, %arg3[%8, %7] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                  } {reduction = 1 : i64}
                } {reduction = 0 : i64}
              }
            }
          } {Array_Partition, reduction = 1 : i64}
        } {reduction = 0 : i64}
      }
    }
    return
  }
}