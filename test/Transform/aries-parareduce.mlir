// RUN: aries-opt -aries-parallel-reduction %s | FileCheck %s

// CHECK: #map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
// CHECK: #map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
// CHECK: #map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
// CHECK: #map3 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
// CHECK: #map4 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
// CHECK: module {
// CHECK:   func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) attributes {adf.kernel}
// CHECK:   func.func @mttkrp(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {adf.func} {
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     affine.for %arg4 = 0 to 1 {
// CHECK:       affine.for %arg5 = 0 to 2 {
// CHECK:         affine.for %arg6 = 0 to 2 {
// CHECK:           affine.for %arg7 = 0 to 2 {
// CHECK:             affine.for %arg8 = 0 to 2 {
// CHECK:               affine.for %arg9 = 0 to 2 {
// CHECK:                 affine.for %arg10 = 0 to 2 {
// CHECK:                   affine.for %arg11 = 0 to 2 {
// CHECK:                     adf.cell @cell0 {
// CHECK:                       %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xf32, 2>
// CHECK:                       %1 = adf.buffer.create @L1_L1_B() : memref<8x16xf32, 2>
// CHECK:                       %2 = adf.buffer.create @L1_L1_C() : memref<16x16xf32, 2>
// CHECK:                       %3 = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %4 = adf.buffer.create @L1_L1_A_1() : memref<2x8x16xf32, 2>
// CHECK:                       %5 = adf.buffer.create @L1_L1_B_1() : memref<8x16xf32, 2>
// CHECK:                       %6 = adf.buffer.create @L1_L1_C_1() : memref<16x16xf32, 2>
// CHECK:                       %7 = adf.buffer.create @L1_L1_D_1() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %8 = adf.buffer.create @L1_L1_A_2() : memref<2x8x16xf32, 2>
// CHECK:                       %9 = adf.buffer.create @L1_L1_B_2() : memref<8x16xf32, 2>
// CHECK:                       %10 = adf.buffer.create @L1_L1_C_2() : memref<16x16xf32, 2>
// CHECK:                       %11 = adf.buffer.create @L1_L1_D_2() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %12 = adf.buffer.create @L1_L1_A_3() : memref<2x8x16xf32, 2>
// CHECK:                       %13 = adf.buffer.create @L1_L1_B_3() : memref<8x16xf32, 2>
// CHECK:                       %14 = adf.buffer.create @L1_L1_C_3() : memref<16x16xf32, 2>
// CHECK:                       %15 = adf.buffer.create @L1_L1_D_3() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %16 = adf.buffer.create @L1_L1_A_4() : memref<2x8x16xf32, 2>
// CHECK:                       %17 = adf.buffer.create @L1_L1_B_4() : memref<8x16xf32, 2>
// CHECK:                       %18 = adf.buffer.create @L1_L1_C_4() : memref<16x16xf32, 2>
// CHECK:                       %19 = adf.buffer.create @L1_L1_D_4() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %20 = adf.buffer.create @L1_L1_A_5() : memref<2x8x16xf32, 2>
// CHECK:                       %21 = adf.buffer.create @L1_L1_B_5() : memref<8x16xf32, 2>
// CHECK:                       %22 = adf.buffer.create @L1_L1_C_5() : memref<16x16xf32, 2>
// CHECK:                       %23 = adf.buffer.create @L1_L1_D_5() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %24 = adf.buffer.create @L1_L1_A_6() : memref<2x8x16xf32, 2>
// CHECK:                       %25 = adf.buffer.create @L1_L1_B_6() : memref<8x16xf32, 2>
// CHECK:                       %26 = adf.buffer.create @L1_L1_C_6() : memref<16x16xf32, 2>
// CHECK:                       %27 = adf.buffer.create @L1_L1_D_6() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %28 = adf.buffer.create @L1_L1_A_7() : memref<2x8x16xf32, 2>
// CHECK:                       %29 = adf.buffer.create @L1_L1_B_7() : memref<8x16xf32, 2>
// CHECK:                       %30 = adf.buffer.create @L1_L1_C_7() : memref<16x16xf32, 2>
// CHECK:                       %31 = adf.buffer.create @L1_L1_D_7() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %32 = affine.apply #map(%arg8, %arg4)
// CHECK:                       %33 = affine.apply #map1(%arg10, %arg6)
// CHECK:                       %34 = affine.apply #map2(%arg11, %arg7)
// CHECK:                       adf.dma(%arg0[%32, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       %35 = affine.apply #map2(%arg9, %arg5)
// CHECK:                       adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%34, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %2[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%0, %1, %2, %3) {adf.kernel, ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%3[] [] [] [] [] [] [], %7[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %36 = affine.apply #map3(%arg11, %arg7)
// CHECK:                       adf.dma(%arg0[%32, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %4[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %5[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%36, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %6[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%4, %5, %6, %7) {adf.kernel, ivs = [1 : index, 0 : index, 0 : index], kernel = 1 : index, kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%7[] [] [] [] [] [] [], %arg3[%32, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       adf.dma(%arg0[%32, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %8[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       %37 = affine.apply #map3(%arg9, %arg5)
// CHECK:                       adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %9[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%34, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %10[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%8, %9, %10, %11) {adf.kernel, ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%11[] [] [] [] [] [] [], %15[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       adf.dma(%arg0[%32, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %12[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %13[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%36, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %14[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%12, %13, %14, %15) {adf.kernel, ivs = [1 : index, 1 : index, 0 : index], kernel = 1 : index, kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%15[] [] [] [] [] [] [], %arg3[%32, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       %38 = affine.apply #map4(%arg8, %arg4)
// CHECK:                       adf.dma(%arg0[%38, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %16[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %17[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%34, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %18[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%16, %17, %18, %19) {adf.kernel, ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%19[] [] [] [] [] [] [], %23[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       adf.dma(%arg0[%38, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %20[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %21[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%36, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %22[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%20, %21, %22, %23) {adf.kernel, ivs = [1 : index, 0 : index, 1 : index], kernel = 1 : index, kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%23[] [] [] [] [] [] [], %arg3[%38, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       adf.dma(%arg0[%38, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %24[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %25[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%34, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %26[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%27[] [] [] [] [] [] [], %31[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       adf.dma(%arg0[%38, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %28[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %29[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma(%arg2[%36, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %30[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
// CHECK:                       func.call @kernel_mttkrp(%28, %29, %30, %31) {adf.kernel, ivs = [1 : index, 1 : index, 1 : index], kernel = 1 : index, kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
// CHECK:                       adf.dma(%31[] [] [] [] [] [] [], %arg3[%38, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       adf.cell.end
// CHECK:                     } {tripCount = [2 : index, 2 : index, 2 : index]}
// CHECK:                   } {reduction = 1 : i64}
// CHECK:                 } {reduction = 0 : i64}
// CHECK:               }
// CHECK:             }
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
#map3 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
#map4 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
module {
  func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) attributes {adf.kernel}
  func.func @mttkrp(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {adf.func} {
    %c16 = arith.constant 16 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    affine.for %arg4 = 0 to 1 {
      affine.for %arg5 = 0 to 2 {
        affine.for %arg6 = 0 to 2 {
          affine.for %arg7 = 0 to 2 {
            affine.for %arg8 = 0 to 2 {
              affine.for %arg9 = 0 to 2 {
                affine.for %arg10 = 0 to 2 {
                  affine.for %arg11 = 0 to 2 {
                    adf.cell @cell0 {
                      %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xf32, 2>
                      %1 = adf.buffer.create @L1_L1_B() : memref<8x16xf32, 2>
                      %2 = adf.buffer.create @L1_L1_C() : memref<16x16xf32, 2>
                      %3 = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xf32, 2>
                      %4 = adf.buffer.create @L1_L1_A_1() : memref<2x8x16xf32, 2>
                      %5 = adf.buffer.create @L1_L1_B_1() : memref<8x16xf32, 2>
                      %6 = adf.buffer.create @L1_L1_C_1() : memref<16x16xf32, 2>
                      %7 = adf.buffer.create @L1_L1_D_1() {accumulator} : memref<2x16xf32, 2>
                      %8 = adf.buffer.create @L1_L1_A_2() : memref<2x8x16xf32, 2>
                      %9 = adf.buffer.create @L1_L1_B_2() : memref<8x16xf32, 2>
                      %10 = adf.buffer.create @L1_L1_C_2() : memref<16x16xf32, 2>
                      %11 = adf.buffer.create @L1_L1_D_2() {accumulator} : memref<2x16xf32, 2>
                      %12 = adf.buffer.create @L1_L1_A_3() : memref<2x8x16xf32, 2>
                      %13 = adf.buffer.create @L1_L1_B_3() : memref<8x16xf32, 2>
                      %14 = adf.buffer.create @L1_L1_C_3() : memref<16x16xf32, 2>
                      %15 = adf.buffer.create @L1_L1_D_3() {accumulator} : memref<2x16xf32, 2>
                      %16 = adf.buffer.create @L1_L1_A_4() : memref<2x8x16xf32, 2>
                      %17 = adf.buffer.create @L1_L1_B_4() : memref<8x16xf32, 2>
                      %18 = adf.buffer.create @L1_L1_C_4() : memref<16x16xf32, 2>
                      %19 = adf.buffer.create @L1_L1_D_4() {accumulator} : memref<2x16xf32, 2>
                      %20 = adf.buffer.create @L1_L1_A_5() : memref<2x8x16xf32, 2>
                      %21 = adf.buffer.create @L1_L1_B_5() : memref<8x16xf32, 2>
                      %22 = adf.buffer.create @L1_L1_C_5() : memref<16x16xf32, 2>
                      %23 = adf.buffer.create @L1_L1_D_5() {accumulator} : memref<2x16xf32, 2>
                      %24 = adf.buffer.create @L1_L1_A_6() : memref<2x8x16xf32, 2>
                      %25 = adf.buffer.create @L1_L1_B_6() : memref<8x16xf32, 2>
                      %26 = adf.buffer.create @L1_L1_C_6() : memref<16x16xf32, 2>
                      %27 = adf.buffer.create @L1_L1_D_6() {accumulator} : memref<2x16xf32, 2>
                      %28 = adf.buffer.create @L1_L1_A_7() : memref<2x8x16xf32, 2>
                      %29 = adf.buffer.create @L1_L1_B_7() : memref<8x16xf32, 2>
                      %30 = adf.buffer.create @L1_L1_C_7() : memref<16x16xf32, 2>
                      %31 = adf.buffer.create @L1_L1_D_7() {accumulator} : memref<2x16xf32, 2>
                      %32 = affine.apply #map(%arg8, %arg4)
                      %33 = affine.apply #map1(%arg10, %arg6)
                      %34 = affine.apply #map2(%arg11, %arg7)
                      adf.dma(%arg0[%32, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %0[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      %35 = affine.apply #map2(%arg9, %arg5)
                      adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %1[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%34, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %2[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%0, %1, %2, %3) {adf.kernel, ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%3[] [] [] [] [] [] [], %arg3[%32, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 0 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      %36 = affine.apply #map3(%arg11, %arg7)
                      adf.dma(%arg0[%32, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %4[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %5[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%36, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %6[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%4, %5, %6, %7) {adf.kernel, ivs = [1 : index, 0 : index, 0 : index], kernel = 1 : index, kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%7[] [] [] [] [] [] [], %arg3[%32, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      adf.dma(%arg0[%32, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %8[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      %37 = affine.apply #map3(%arg9, %arg5)
                      adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %9[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%34, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %10[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%8, %9, %10, %11) {adf.kernel, ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%11[] [] [] [] [] [] [], %arg3[%32, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 0 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      adf.dma(%arg0[%32, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %12[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %13[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%36, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %14[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%12, %13, %14, %15) {adf.kernel, ivs = [1 : index, 1 : index, 0 : index], kernel = 1 : index, kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%15[] [] [] [] [] [] [], %arg3[%32, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      %38 = affine.apply #map4(%arg8, %arg4)
                      adf.dma(%arg0[%38, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %16[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %17[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%34, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %18[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%16, %17, %18, %19) {adf.kernel, ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%19[] [] [] [] [] [] [], %arg3[%38, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 0 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      adf.dma(%arg0[%38, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %20[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      adf.dma(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], %21[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%36, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], %22[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%20, %21, %22, %23) {adf.kernel, ivs = [1 : index, 0 : index, 1 : index], kernel = 1 : index, kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%23[] [] [] [] [] [] [], %arg3[%38, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      adf.dma(%arg0[%38, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %24[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %25[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%34, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %26[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%27[] [] [] [] [] [] [], %arg3[%38, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 0 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      adf.dma(%arg0[%38, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %28[] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>)
                      adf.dma(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], %29[] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>)
                      adf.dma(%arg2[%36, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], %30[] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%28, %29, %30, %31) {adf.kernel, ivs = [1 : index, 1 : index, 1 : index], kernel = 1 : index, kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%31[] [] [] [] [] [] [], %arg3[%38, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      adf.cell.end
                    } {tripCount = [2 : index, 2 : index, 2 : index]}
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