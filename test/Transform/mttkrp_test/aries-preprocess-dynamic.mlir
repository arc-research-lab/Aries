// RUN: aries-opt -aries-preprocess %s | FileCheck %s

// CHECK: #map = affine_map<(d0) -> (d0 * 2)>
// CHECK: #map1 = affine_map<(d0) -> (d0 * 8)>
// CHECK: #map2 = affine_map<(d0) -> (d0 * 16)>
// CHECK: module {
// CHECK:   func.func private @kernel_mttkrp(memref<2x8x16xi32, 2>, memref<8x16xi32, 2>, memref<16x16xi32, 2>, memref<2x16xi32, 2>) attributes {adf.kernel}
// CHECK:   func.func @mttkrp(%arg0: memref<?x?x?xi32>, %arg1: memref<?x?xi32>, %arg2: memref<?x?xi32>, %arg3: memref<?x?xi32>, %arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: index, %arg9: index, %arg10: index, %arg11: index, %arg12: index) 
// CHECK-SAME:  attributes {adf.func, meta_data = [
// CHECK-SAME:  [0, 8, 9], [1, 10], [2, 11], [3, 12]]} {
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     affine.for %arg13 = 0 to %arg4 {
// CHECK:       affine.for %arg14 = 0 to %arg5 {
// CHECK:         affine.for %arg15 = 0 to %arg6 {
// CHECK:           affine.for %arg16 = 0 to %arg7 {
// CHECK:             %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xi32, 2>
// CHECK:             %1 = adf.buffer.create @L1_L1_B() : memref<8x16xi32, 2>
// CHECK:             %2 = adf.buffer.create @L1_L1_C() : memref<16x16xi32, 2>
// CHECK:             %3 = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xi32, 2>
// CHECK:             %4 = affine.apply #map(%arg13)
// CHECK:             %5 = affine.apply #map1(%arg15)
// CHECK:             %6 = affine.apply #map2(%arg16)
// CHECK:             adf.dma(%arg0[%4, %5, %6] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<?x?x?xi32>, memref<2x8x16xi32, 2>)
// CHECK:             %7 = affine.apply #map2(%arg14)
// CHECK:             adf.dma(%arg1[%5, %7] [%c8, %c16] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<?x?xi32>, memref<8x16xi32, 2>)
// CHECK:             adf.dma(%arg2[%6, %7] [%c16, %c16] [%c1, %c1] [] [] [] [], %2[] [] [] [] [] [] []) : (memref<?x?xi32>, memref<16x16xi32, 2>)
// CHECK:             func.call @kernel_mttkrp(%0, %1, %2, %3) : (memref<2x8x16xi32, 2>, memref<8x16xi32, 2>, memref<16x16xi32, 2>, memref<2x16xi32, 2>) -> ()
// CHECK:             adf.dma(%3[] [] [] [] [] [] [], %arg3[%4, %7] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator} : (memref<2x16xi32, 2>, memref<?x?xi32>)
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @top(%arg0: memref<8x32x128xi32>, %arg1: memref<32x128xi32>, %arg2: memref<128x128xi32>, %arg3: memref<8x128xi32>) attributes {outArgs = [3 : i32], top_func} {
// CHECK:     %c128 = arith.constant 128 : index
// CHECK:     %c32 = arith.constant 32 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %cast = memref.cast %arg0 : memref<8x32x128xi32> to memref<?x?x?xi32>
// CHECK:     %cast_0 = memref.cast %arg1 : memref<32x128xi32> to memref<?x?xi32>
// CHECK:     %cast_1 = memref.cast %arg2 : memref<128x128xi32> to memref<?x?xi32>
// CHECK:     %cast_2 = memref.cast %arg3 : memref<8x128xi32> to memref<?x?xi32>
// CHECK:     call @mttkrp(%cast, %cast_0, %cast_1, %cast_2, %c4, %c8, %c4, %c8, %c32, %c128, %c128, %c128, %c128) : (memref<?x?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, index, index, index, index, index, index, index, index, index) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func private @mttkrp_host(memref<?x?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, index, index, index, index, index, index, index, index, index) 
// CHECK-SAME:  attributes {meta_data = [
// CHECK-SAME:  [0, 8, 9], [1, 10], [2, 11], [3, 12]], origin_func = "mttkrp"}
// CHECK:   func.func @top_host(%arg0: memref<8x32x128xi32>, %arg1: memref<32x128xi32>, %arg2: memref<128x128xi32>, %arg3: memref<8x128xi32>) attributes {origin_func = "top", outArgs = [3 : i32], top_host} {
// CHECK:     %c128 = arith.constant 128 : index
// CHECK:     %c32 = arith.constant 32 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %cast = memref.cast %arg0 : memref<8x32x128xi32> to memref<?x?x?xi32>
// CHECK:     %cast_0 = memref.cast %arg1 : memref<32x128xi32> to memref<?x?xi32>
// CHECK:     %cast_1 = memref.cast %arg2 : memref<128x128xi32> to memref<?x?xi32>
// CHECK:     %cast_2 = memref.cast %arg3 : memref<8x128xi32> to memref<?x?xi32>
// CHECK:     call @mttkrp_host(%cast, %cast_0, %cast_1, %cast_2, %c4, %c8, %c4, %c8, %c32, %c128, %c128, %c128, %c128) {origin_func = "mttkrp"} : (memref<?x?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, index, index, index, index, index, index, index, index, index) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0) -> (d0 * 2)>
#map1 = affine_map<(d0) -> (d0 * 8)>
#map2 = affine_map<(d0) -> (d0 * 16)>
module {
  func.func private @kernel_mttkrp(memref<2x8x16xi32, 2>, memref<8x16xi32, 2>, memref<16x16xi32, 2>, memref<2x16xi32, 2>) attributes {adf.kernel}
  func.func @mttkrp(%arg0: memref<?x?x?xi32>, %arg1: memref<?x?xi32>, %arg2: memref<?x?xi32>, %arg3: memref<?x?xi32>, %arg4: index, %arg5: index, %arg6: index, %arg7: index) attributes {adf.func} {
    %c16 = arith.constant 16 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    affine.for %arg8 = 0 to %arg4 {
      affine.for %arg9 = 0 to %arg5 {
        affine.for %arg10 = 0 to %arg6 {
          affine.for %arg11 = 0 to %arg7 {
            %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xi32, 2>
            %1 = adf.buffer.create @L1_L1_B() : memref<8x16xi32, 2>
            %2 = adf.buffer.create @L1_L1_C() : memref<16x16xi32, 2>
            %3 = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xi32, 2>
            %4 = affine.apply #map(%arg8)
            %5 = affine.apply #map1(%arg10)
            %6 = affine.apply #map2(%arg11)
            adf.dma(%arg0[%4, %5, %6] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<?x?x?xi32>, memref<2x8x16xi32, 2>)
            %7 = affine.apply #map2(%arg9)
            adf.dma(%arg1[%5, %7] [%c8, %c16] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<?x?xi32>, memref<8x16xi32, 2>)
            adf.dma(%arg2[%6, %7] [%c16, %c16] [%c1, %c1] [] [] [] [], %2[] [] [] [] [] [] []) : (memref<?x?xi32>, memref<16x16xi32, 2>)
            func.call @kernel_mttkrp(%0, %1, %2, %3) : (memref<2x8x16xi32, 2>, memref<8x16xi32, 2>, memref<16x16xi32, 2>, memref<2x16xi32, 2>) -> ()
            adf.dma(%3[] [] [] [] [] [] [], %arg3[%4, %7] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator} : (memref<2x16xi32, 2>, memref<?x?xi32>)
          }
        }
      }
    }
    return
  }
  func.func @top(%arg0: memref<8x32x128xi32>, %arg1: memref<32x128xi32>, %arg2: memref<128x128xi32>, %arg3: memref<8x128xi32>) attributes {top_func} {
    %c8 = arith.constant 8 : index
    %c4 = arith.constant 4 : index
    %cast = memref.cast %arg0 : memref<8x32x128xi32> to memref<?x?x?xi32>
    %cast_0 = memref.cast %arg1 : memref<32x128xi32> to memref<?x?xi32>
    %cast_1 = memref.cast %arg2 : memref<128x128xi32> to memref<?x?xi32>
    %cast_2 = memref.cast %arg3 : memref<8x128xi32> to memref<?x?xi32>
    call @mttkrp(%cast, %cast_0, %cast_1, %cast_2, %c4, %c8, %c4, %c8) : (memref<?x?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, memref<?x?xi32>, index, index, index, index) -> ()
    return
  }
}