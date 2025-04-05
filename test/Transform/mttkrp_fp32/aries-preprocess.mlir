// RUN: aries-opt -aries-preprocess %s | FileCheck %s

// CHECK: #map = affine_map<(d0) -> (d0 * 2)>
// CHECK: #map1 = affine_map<(d0) -> (d0 * 8)>
// CHECK: #map2 = affine_map<(d0) -> (d0 * 16)>
// CHECK: module {
// CHECK:   func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) attributes {adf.kernel}
// CHECK:   func.func @mttkrp(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {adf.func} {
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     affine.for %arg4 = 0 to 4 {
// CHECK:       affine.for %arg5 = 0 to 8 {
// CHECK:         affine.for %arg6 = 0 to 4 {
// CHECK:           affine.for %arg7 = 0 to 8 {
// CHECK:             %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xf32, 2>
// CHECK:             %1 = adf.buffer.create @L1_L1_B() : memref<8x16xf32, 2>
// CHECK:             %2 = adf.buffer.create @L1_L1_C() : memref<16x16xf32, 2>
// CHECK:             %3 = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xf32, 2>
// CHECK:             %4 = affine.apply #map(%arg4)
// CHECK:             %5 = affine.apply #map1(%arg6)
// CHECK:             %6 = affine.apply #map2(%arg7)
// CHECK:             adf.dma(%arg0[%4, %5, %6] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:             %7 = affine.apply #map2(%arg5)
// CHECK:             adf.dma(%arg1[%5, %7] [%c8, %c16] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:             adf.dma(%arg2[%6, %7] [%c16, %c16] [%c1, %c1] [] [] [] [], %2[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:             func.call @kernel_mttkrp(%0, %1, %2, %3) : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:             adf.dma(%3[] [] [] [] [] [] [], %arg3[%4, %7] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @top(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {outArgs = [3 : i32], top_func} {
// CHECK:     call @mttkrp(%arg0, %arg1, %arg2, %arg3) : (memref<8x32x128xf32>, memref<32x128xf32>, memref<128x128xf32>, memref<8x128xf32>) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func private @mttkrp_host(memref<8x32x128xf32>, memref<32x128xf32>, memref<128x128xf32>, memref<8x128xf32>) attributes {origin_func = "mttkrp"}
// CHECK:   func.func @top_host(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {origin_func = "top", outArgs = [3 : i32], top_host} {
// CHECK:     call @mttkrp_host(%arg0, %arg1, %arg2, %arg3) {origin_func = "mttkrp"} : (memref<8x32x128xf32>, memref<32x128xf32>, memref<128x128xf32>, memref<8x128xf32>) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0) -> (d0 * 2)>
#map1 = affine_map<(d0) -> (d0 * 8)>
#map2 = affine_map<(d0) -> (d0 * 16)>
module {
  func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) attributes {adf.kernel}
  func.func @mttkrp(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {adf.func} {
    %c16 = arith.constant 16 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    affine.for %arg4 = 0 to 4 {
      affine.for %arg5 = 0 to 8 {
        affine.for %arg6 = 0 to 4 {
          affine.for %arg7 = 0 to 8 {
            %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xf32, 2>
            %1 = adf.buffer.create @L1_L1_B() : memref<8x16xf32, 2>
            %2 = adf.buffer.create @L1_L1_C() : memref<16x16xf32, 2>
            %3 = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xf32, 2>
            %4 = affine.apply #map(%arg4)
            %5 = affine.apply #map1(%arg6)
            %6 = affine.apply #map2(%arg7)
            adf.dma(%arg0[%4, %5, %6] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
            %7 = affine.apply #map2(%arg5)
            adf.dma(%arg1[%5, %7] [%c8, %c16] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
            adf.dma(%arg2[%6, %7] [%c16, %c16] [%c1, %c1] [] [] [] [], %2[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
            func.call @kernel_mttkrp(%0, %1, %2, %3) : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
            adf.dma(%3[] [] [] [] [] [] [], %arg3[%4, %7] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator} : (memref<2x16xf32, 2>, memref<8x128xf32>)
          }
        }
      }
    }
    return
  }
  func.func @top(%A: memref<8x32x128xf32>, %B: memref<32x128xf32>, %C: memref<128x128xf32>, %D: memref<8x128xf32>) attributes {top_func} {
    func.call @mttkrp(%A, %B, %C, %D) : (memref<8x32x128xf32>, memref<32x128xf32>, memref<128x128xf32>, memref<8x128xf32>) -> ()
    return
  }
}