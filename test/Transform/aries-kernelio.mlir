// RUN: aries-opt -aries-kernel-interface-create %s | FileCheck %s

// CHECK: #map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
// CHECK: #map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
// CHECK: #map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
// CHECK: #map3 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
// CHECK: #map4 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
// CHECK: module {
// CHECK:   func.func @kernel_mttkrp0(%arg0: memref<2x8x16xf32, 2>, %arg1: memref<8x16xf32, 2>, %arg2: memref<16x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel, edge_kernel} {
// CHECK:     %alloc = memref.alloc() : memref<2x16xf32, 2>
// CHECK:     affine.for %arg3 = 0 to 2 {
// CHECK:       affine.for %arg4 = 0 to 16 {
// CHECK:         %cst_0 = arith.constant 0.000000e+00 : f32
// CHECK:         affine.store %cst_0, %alloc[%arg3, %arg4] : memref<2x16xf32, 2>
// CHECK:       }
// CHECK:     }
// CHECK:     %cst = arith.constant 0.000000e+00 : f32
// CHECK:     affine.for %arg3 = 0 to 2 {
// CHECK:       affine.for %arg4 = 0 to 16 {
// CHECK:         affine.store %cst, %alloc[%arg3, %arg4] : memref<2x16xf32, 2>
// CHECK:         affine.for %arg5 = 0 to 8 {
// CHECK:           affine.for %arg6 = 0 to 16 {
// CHECK:             %0 = affine.load %arg0[%arg3, %arg5, %arg6] : memref<2x8x16xf32, 2>
// CHECK:             %1 = affine.load %arg1[%arg5, %arg4] : memref<8x16xf32, 2>
// CHECK:             %2 = arith.mulf %0, %1 : f32
// CHECK:             %3 = affine.load %arg2[%arg6, %arg4] : memref<16x16xf32, 2>
// CHECK:             %4 = arith.mulf %2, %3 : f32
// CHECK:             %5 = affine.load %alloc[%arg3, %arg4] : memref<2x16xf32, 2>
// CHECK:             %6 = arith.addf %5, %4 : f32
// CHECK:             affine.store %6, %alloc[%arg3, %arg4] : memref<2x16xf32, 2>
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return %alloc : memref<2x16xf32, 2>
// CHECK:   }
// CHECK:   func.func @kernel_mttkrp(%arg0: memref<2x8x16xf32, 2>, %arg1: memref<8x16xf32, 2>, %arg2: memref<16x16xf32, 2>, %arg3: memref<2x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel} {
// CHECK:     %alloc = memref.alloc() : memref<2x16xf32, 2>
// CHECK:     %cst = arith.constant 0.000000e+00 : f32
// CHECK:     affine.for %arg4 = 0 to 2 {
// CHECK:       affine.for %arg5 = 0 to 16 {
// CHECK:         %0 = affine.load %arg3[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:         affine.store %0, %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:         affine.store %cst, %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:         affine.for %arg6 = 0 to 8 {
// CHECK:           affine.for %arg7 = 0 to 16 {
// CHECK:             %1 = affine.load %arg0[%arg4, %arg6, %arg7] : memref<2x8x16xf32, 2>
// CHECK:             %2 = affine.load %arg1[%arg6, %arg5] : memref<8x16xf32, 2>
// CHECK:             %3 = arith.mulf %1, %2 : f32
// CHECK:             %4 = affine.load %arg2[%arg7, %arg5] : memref<16x16xf32, 2>
// CHECK:             %5 = arith.mulf %3, %4 : f32
// CHECK:             %6 = affine.load %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:             %7 = arith.addf %6, %5 : f32
// CHECK:             affine.store %7, %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:           }
// CHECK:         }
// CHECK:       }
// CHECK:     }
// CHECK:     return %alloc : memref<2x16xf32, 2>
// CHECK:   }
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
// CHECK:                       adf.dma.broadcast(%arg0[%32, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%0, %8} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
// CHECK:                       %35 = affine.apply #map2(%arg9, %arg5)
// CHECK:                       adf.dma.broadcast(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], {%1, %5, %17, %21} [] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma.broadcast(%arg2[%34, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], {%2, %18} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
// CHECK:                       %36 = func.call @kernel_mttkrp0(%0, %1, %2) {adf.kernel, ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%36[] [] [] [] [] [] [], %7[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %37 = affine.apply #map3(%arg11, %arg7)
// CHECK:                       adf.dma.broadcast(%arg0[%32, %33, %37] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%4, %12} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.dma.broadcast(%arg2[%37, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], {%6, %22} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
// CHECK:                       %38 = func.call @kernel_mttkrp(%4, %5, %6, %7) {adf.kernel, ivs = [1 : index, 0 : index, 0 : index], kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%38[] [] [] [] [] [] [], %arg3[%32, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       %39 = affine.apply #map3(%arg9, %arg5)
// CHECK:                       adf.dma.broadcast(%arg1[%33, %39] [%c8, %c16] [%c1, %c1] [] [] [] [], {%9, %13, %25, %29} [] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>)
// CHECK:                       adf.dma.broadcast(%arg2[%34, %39] [%c16, %c16] [%c1, %c1] [] [] [] [], {%10, %26} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
// CHECK:                       %40 = func.call @kernel_mttkrp0(%8, %9, %10) {adf.kernel, ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%40[] [] [] [] [] [] [], %15[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       adf.dma.broadcast(%arg2[%37, %39] [%c16, %c16] [%c1, %c1] [] [] [] [], {%14, %30} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
// CHECK:                       %41 = func.call @kernel_mttkrp(%12, %13, %14, %15) {adf.kernel, ivs = [1 : index, 1 : index, 0 : index], kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%41[] [] [] [] [] [] [], %arg3[%32, %39] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       %42 = affine.apply #map4(%arg8, %arg4)
// CHECK:                       adf.dma.broadcast(%arg0[%42, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%16, %24} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
// CHECK:                       %43 = func.call @kernel_mttkrp0(%16, %17, %18) {adf.kernel, ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%43[] [] [] [] [] [] [], %23[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       adf.dma.broadcast(%arg0[%42, %33, %37] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%20, %28} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
// CHECK:                       %44 = func.call @kernel_mttkrp(%20, %21, %22, %23) {adf.kernel, ivs = [1 : index, 0 : index, 1 : index], kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%44[] [] [] [] [] [] [], %arg3[%42, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
// CHECK:                       %45 = func.call @kernel_mttkrp0(%24, %25, %26) {adf.kernel, ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%45[] [] [] [] [] [] [], %31[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %46 = func.call @kernel_mttkrp(%28, %29, %30, %31) {adf.kernel, ivs = [1 : index, 1 : index, 1 : index], kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.dma(%46[] [] [] [] [] [] [], %arg3[%42, %39] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
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
  func.func @kernel_mttkrp(%arg0: memref<2x8x16xf32, 2>, %arg1: memref<8x16xf32, 2>, %arg2: memref<16x16xf32, 2>, %arg3: memref<2x16xf32, 2>) attributes {adf.kernel} {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg4 = 0 to 2 {
      affine.for %arg5 = 0 to 16 {
        affine.store %cst, %arg3[%arg4, %arg5] : memref<2x16xf32, 2>
        affine.for %arg6 = 0 to 8 {
          affine.for %arg7 = 0 to 16 {
            %0 = affine.load %arg0[%arg4, %arg6, %arg7] : memref<2x8x16xf32, 2>
            %1 = affine.load %arg1[%arg6, %arg5] : memref<8x16xf32, 2>
            %2 = arith.mulf %0, %1 : f32
            %3 = affine.load %arg2[%arg7, %arg5] : memref<16x16xf32, 2>
            %4 = arith.mulf %2, %3 : f32
            %5 = affine.load %arg3[%arg4, %arg5] : memref<2x16xf32, 2>
            %6 = arith.addf %5, %4 : f32
            affine.store %6, %arg3[%arg4, %arg5] : memref<2x16xf32, 2>
          }
        }
      }
    }
    return
  }
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
                      adf.dma.broadcast(%arg0[%32, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%0, %8} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
                      %35 = affine.apply #map2(%arg9, %arg5)
                      adf.dma.broadcast(%arg1[%33, %35] [%c8, %c16] [%c1, %c1] [] [] [] [], {%1, %5, %17, %21} [] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>)
                      adf.dma.broadcast(%arg2[%34, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], {%2, %18} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%0, %1, %2, %3) {adf.kernel, ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%3[] [] [] [] [] [] [], %7[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      %36 = affine.apply #map3(%arg11, %arg7)
                      adf.dma.broadcast(%arg0[%32, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%4, %12} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
                      adf.dma.broadcast(%arg2[%36, %35] [%c16, %c16] [%c1, %c1] [] [] [] [], {%6, %22} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%4, %5, %6, %7) {adf.kernel, ivs = [1 : index, 0 : index, 0 : index], kernel = 1 : index, kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%7[] [] [] [] [] [] [], %arg3[%32, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      %37 = affine.apply #map3(%arg9, %arg5)
                      adf.dma.broadcast(%arg1[%33, %37] [%c8, %c16] [%c1, %c1] [] [] [] [], {%9, %13, %25, %29} [] [] [] [] [] [] []) : (memref<32x128xf32>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>, memref<8x16xf32, 2>)
                      adf.dma.broadcast(%arg2[%34, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], {%10, %26} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%8, %9, %10, %11) {adf.kernel, ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%11[] [] [] [] [] [] [], %15[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      adf.dma.broadcast(%arg2[%36, %37] [%c16, %c16] [%c1, %c1] [] [] [] [], {%14, %30} [] [] [] [] [] [] []) : (memref<128x128xf32>, memref<16x16xf32, 2>, memref<16x16xf32, 2>)
                      func.call @kernel_mttkrp(%12, %13, %14, %15) {adf.kernel, ivs = [1 : index, 1 : index, 0 : index], kernel = 1 : index, kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%15[] [] [] [] [] [] [], %arg3[%32, %37] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      %38 = affine.apply #map4(%arg8, %arg4)
                      adf.dma.broadcast(%arg0[%38, %33, %34] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%16, %24} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
                      func.call @kernel_mttkrp(%16, %17, %18, %19) {adf.kernel, ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%19[] [] [] [] [] [] [], %23[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      adf.dma.broadcast(%arg0[%38, %33, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], {%20, %28} [] [] [] [] [] [] []) : (memref<8x32x128xf32>, memref<2x8x16xf32, 2>, memref<2x8x16xf32, 2>)
                      func.call @kernel_mttkrp(%20, %21, %22, %23) {adf.kernel, ivs = [1 : index, 0 : index, 1 : index], kernel = 1 : index, kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%23[] [] [] [] [] [] [], %arg3[%38, %35] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator = 1 : index, reduction = [0, 1]} : (memref<2x16xf32, 2>, memref<8x128xf32>)
                      func.call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> ()
                      adf.dma(%27[] [] [] [] [] [] [], %31[] [] [] [] [] [] []) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
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