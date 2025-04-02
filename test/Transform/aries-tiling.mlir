// RUN: aries-opt -aries-tiling="tile-func-name=gemm l1-tile-sizes=2,2,2 l2-tile-sizes=2,2,2 en-newtiling="true"" %s | FileCheck %s

// CHECK: #map = affine_map<(d0, d1, d2) -> (d0 * 32 + d1 * 64 + d2 * 128)>
// CHECK: module {
// CHECK:   func.func @gemm(%arg0: memref<256x256xf32>, %arg1: memref<256x256xf32>, %arg2: memref<256x256xf32>) attributes {adf.func}
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c32 = arith.constant 32 : index
// CHECK:     affine.for %arg3 = 0 to 2 {
// CHECK:       affine.for %arg4 = 0 to 2 {
// CHECK:         affine.for %arg5 = 0 to 2 {
// CHECK:           affine.for %arg6 = 0 to 2 {
// CHECK:             affine.for %arg7 = 0 to 2 {
// CHECK:               affine.for %arg8 = 0 to 2 {
// CHECK:                 adf.cell @cell0 {
// CHECK:                   affine.for %arg9 = 0 to 2 {
// CHECK:                     affine.for %arg10 = 0 to 2 {
// CHECK:                       affine.for %arg11 = 0 to 2 {
// CHECK:                         %0 = adf.buffer.create @L1_L1_A() : memref<32x32xf32, 2>
// CHECK:                         %1 = adf.buffer.create @L1_L1_B() : memref<32x32xf32, 2>
// CHECK:                         %2 = adf.buffer.create @L1_L1_C() {accumulator} : memref<32x32xf32, 2>
// CHECK:                         %3 = affine.apply #map(%arg9, %arg6, %arg3)
// CHECK:                         %4 = affine.apply #map(%arg11, %arg8, %arg5)
// CHECK:                         adf.dma(%arg0[%3, %4] [%c32, %c32] [%c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<256x256xf32>, memref<32x32xf32, 2>)
// CHECK:                         %5 = affine.apply #map(%arg10, %arg7, %arg4)
// CHECK:                         adf.dma(%arg1[%4, %5] [%c32, %c32] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<256x256xf32>, memref<32x32xf32, 2>)
// CHECK:                         func.call @kernel_gemm(%0, %1, %2) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> ()
// CHECK:                         adf.dma(%2[] [] [] [] [] [] [], %arg2[%3, %5] [%c32, %c32] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0]} : (memref<32x32xf32, 2>, memref<256x256xf32>)
// CHECK:                       } {reduction = 0 : i64}
// CHECK:                     }
// CHECK:                   }
// CHECK:                   adf.cell.end
// CHECK:                 }
// CHECK:               } {reduction = 0 : i64}
// CHECK:             }
// CHECK:           }
// CHECK:         } {Array_Partition, reduction = 0 : i64}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0) -> (d0 * 32)>
module {
  func.func @kernel_gemm(%arg0: memref<32x32xf32, 2>, %arg1: memref<32x32xf32, 2>, %arg2: memref<32x32xf32, 2>) attributes {adf.kernel} {
    return
  }
  func.func @gemm(%arg0: memref<256x256xf32>, %arg1: memref<256x256xf32>, %arg2: memref<256x256xf32>) attributes {adf.func} {
    %c1 = arith.constant 1 : index
    %c32 = arith.constant 32 : index
    affine.for %arg3 = 0 to 8 {
      affine.for %arg4 = 0 to 8 {
        affine.for %arg5 = 0 to 8 {
          %0 = adf.buffer.create @L1_L1_A() : memref<32x32xf32, 2>
          %1 = adf.buffer.create @L1_L1_B() : memref<32x32xf32, 2>
          %2 = adf.buffer.create @L1_L1_C() {accumulator} : memref<32x32xf32, 2>
          %3 = affine.apply #map(%arg3)
          %4 = affine.apply #map(%arg5)
          adf.dma(%arg0[%3, %4] [%c32, %c32] [%c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<256x256xf32>, memref<32x32xf32, 2>)
          %5 = affine.apply #map(%arg4)
          adf.dma(%arg1[%4, %5] [%c32, %c32] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<256x256xf32>, memref<32x32xf32, 2>)
          func.call @kernel_gemm(%0, %1, %2) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> ()
          adf.dma(%2[] [] [] [] [] [] [], %arg2[%3, %5] [%c32, %c32] [%c1, %c1] [] [] [] []) {accumulator} : (memref<32x32xf32, 2>, memref<256x256xf32>)
        }
      }
    }
    return
  }
  func.func @top(%arg0: memref<256x256xf32>, %arg1: memref<256x256xf32>, %arg2: memref<256x256xf32>) attributes {outArgs = [2 : i32], top_func} {
    return
  }
}