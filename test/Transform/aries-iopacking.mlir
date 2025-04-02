// RUN: aries-opt -aries-io-packing="plio-width=128" -cse -canonicalize %s | FileCheck %s

// CHECK: #map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
// CHECK: #map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
// CHECK: #map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
// CHECK: #map3 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16 + 4)>
// CHECK: #map4 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
// CHECK: #map5 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
// CHECK: module {
// CHECK:   func.func private @kernel_mttkrp0(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel, edge_kernel}
// CHECK:   func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel}
// CHECK:   func.func @mttkrp(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
// CHECK:     %c4 = arith.constant 4 : index
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
// CHECK:                       %3 = adf.buffer.create @L1_L1_A_1() : memref<2x8x16xf32, 2>
// CHECK:                       %4 = adf.buffer.create @L1_L1_B_1() : memref<8x16xf32, 2>
// CHECK:                       %5 = adf.buffer.create @L1_L1_C_1() : memref<16x16xf32, 2>
// CHECK:                       %6 = adf.buffer.create @L1_L1_D_1() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %7 = adf.buffer.create @L1_L1_A_2() : memref<2x8x16xf32, 2>
// CHECK:                       %8 = adf.buffer.create @L1_L1_B_2() : memref<8x16xf32, 2>
// CHECK:                       %9 = adf.buffer.create @L1_L1_C_2() : memref<16x16xf32, 2>
// CHECK:                       %10 = adf.buffer.create @L1_L1_A_3() : memref<2x8x16xf32, 2>
// CHECK:                       %11 = adf.buffer.create @L1_L1_B_3() : memref<8x16xf32, 2>
// CHECK:                       %12 = adf.buffer.create @L1_L1_C_3() : memref<16x16xf32, 2>
// CHECK:                       %13 = adf.buffer.create @L1_L1_D_3() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %14 = adf.buffer.create @L1_L1_A_4() : memref<2x8x16xf32, 2>
// CHECK:                       %15 = adf.buffer.create @L1_L1_B_4() : memref<8x16xf32, 2>
// CHECK:                       %16 = adf.buffer.create @L1_L1_C_4() : memref<16x16xf32, 2>
// CHECK:                       %17 = adf.buffer.create @L1_L1_A_5() : memref<2x8x16xf32, 2>
// CHECK:                       %18 = adf.buffer.create @L1_L1_B_5() : memref<8x16xf32, 2>
// CHECK:                       %19 = adf.buffer.create @L1_L1_C_5() : memref<16x16xf32, 2>
// CHECK:                       %20 = adf.buffer.create @L1_L1_D_5() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %21 = adf.buffer.create @L1_L1_A_6() : memref<2x8x16xf32, 2>
// CHECK:                       %22 = adf.buffer.create @L1_L1_B_6() : memref<8x16xf32, 2>
// CHECK:                       %23 = adf.buffer.create @L1_L1_C_6() : memref<16x16xf32, 2>
// CHECK:                       %24 = adf.buffer.create @L1_L1_A_7() : memref<2x8x16xf32, 2>
// CHECK:                       %25 = adf.buffer.create @L1_L1_B_7() : memref<8x16xf32, 2>
// CHECK:                       %26 = adf.buffer.create @L1_L1_C_7() : memref<16x16xf32, 2>
// CHECK:                       %27 = adf.buffer.create @L1_L1_D_7() {accumulator} : memref<2x16xf32, 2>
// CHECK:                       %28 = affine.apply #map(%arg8, %arg4)
// CHECK:                       %29 = affine.apply #map1(%arg10, %arg6)
// CHECK:                       %30 = affine.apply #map1(%arg11, %arg7)
// CHECK:                       %31 = affine.apply #map2(%arg11, %arg7)
// CHECK:                       %32 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%32, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg0[%28, %29, %30] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %32) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%32, %0) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.connect(%32, %7) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       %33 = affine.apply #map1(%arg9, %arg5)
// CHECK:                       %34 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%34, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg1[%29, %33] [%c8, %c4] [%c1, %c1] [] [] [] [], %34) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%34, %1) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       adf.connect(%34, %4) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       adf.connect(%34, %15) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       adf.connect(%34, %18) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       %35 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%35, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg2[%31, %33] [%c16, %c4] [%c1, %c1] [] [] [] [], %35) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%35, %2) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       adf.connect(%35, %16) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       %36 = func.call @kernel_mttkrp0(%0, %1, %2) {adf.kernel, ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.connect(%36, %6) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %37 = affine.apply #map3(%arg11, %arg7)
// CHECK:                       %38 = affine.apply #map4(%arg11, %arg7)
// CHECK:                       %39 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%39, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg0[%28, %29, %37] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %39) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%39, %3) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.connect(%39, %10) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       %40 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%40, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg2[%38, %33] [%c16, %c4] [%c1, %c1] [] [] [] [], %40) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%40, %5) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       adf.connect(%40, %19) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       %41 = func.call @kernel_mttkrp(%3, %4, %5, %6) {adf.kernel, ivs = [1 : index, 0 : index, 0 : index], kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       %42 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:                       adf.config.plio(%42, 250) : <Out, 128>
// CHECK:                       adf.connect(%41, %42) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:                       adf.io.pop(%42, %arg3[%28, %33] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
// CHECK:                       %43 = affine.apply #map3(%arg9, %arg5)
// CHECK:                       %44 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%44, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg1[%29, %43] [%c8, %c4] [%c1, %c1] [] [] [] [], %44) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%44, %8) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       adf.connect(%44, %11) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       adf.connect(%44, %22) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       adf.connect(%44, %25) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:                       %45 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%45, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg2[%31, %43] [%c16, %c4] [%c1, %c1] [] [] [] [], %45) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%45, %9) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       adf.connect(%45, %23) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       %46 = func.call @kernel_mttkrp0(%7, %8, %9) {adf.kernel, ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.connect(%46, %13) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %47 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%47, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg2[%38, %43] [%c16, %c4] [%c1, %c1] [] [] [] [], %47) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%47, %12) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       adf.connect(%47, %26) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:                       %48 = func.call @kernel_mttkrp(%10, %11, %12, %13) {adf.kernel, ivs = [1 : index, 1 : index, 0 : index], kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       %49 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:                       adf.config.plio(%49, 250) : <Out, 128>
// CHECK:                       adf.connect(%48, %49) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:                       adf.io.pop(%49, %arg3[%28, %43] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
// CHECK:                       %50 = affine.apply #map5(%arg8, %arg4)
// CHECK:                       %51 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%51, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg0[%50, %29, %30] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %51) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%51, %14) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.connect(%51, %21) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       %52 = func.call @kernel_mttkrp0(%14, %15, %16) {adf.kernel, ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.connect(%52, %20) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %53 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:                       adf.config.plio(%53, 250) : <In, 128>
// CHECK:                       adf.io.push(%arg0[%50, %29, %37] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %53) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                       adf.connect(%53, %17) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       adf.connect(%53, %24) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:                       %54 = func.call @kernel_mttkrp(%17, %18, %19, %20) {adf.kernel, ivs = [1 : index, 0 : index, 1 : index], kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       %55 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:                       adf.config.plio(%55, 250) : <Out, 128>
// CHECK:                       adf.connect(%54, %55) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:                       adf.io.pop(%55, %arg3[%50, %33] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
// CHECK:                       %56 = func.call @kernel_mttkrp0(%21, %22, %23) {adf.kernel, ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       adf.connect(%56, %27) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:                       %57 = func.call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, ivs = [1 : index, 1 : index, 1 : index], kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:                       %58 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:                       adf.config.plio(%58, 250) : <Out, 128>
// CHECK:                       adf.connect(%57, %58) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:                       adf.io.pop(%58, %arg3[%50, %43] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
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
// CHECK:   func.func @top(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>) attributes {outArgs = [3 : i32], top_func} {
// CHECK:     call @mttkrp(%arg0, %arg1, %arg2, %arg3) : (memref<8x32x32xi128>, memref<32x32xi128>, memref<128x32xi128>, memref<8x32xi128>) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
#map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
#map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
#map3 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
#map4 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
module {
  func.func private @kernel_mttkrp0(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel, edge_kernel}
  func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel}
  func.func @mttkrp(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {adf.func, plio = true} {
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
                      %3 = adf.buffer.create @L1_L1_A_1() : memref<2x8x16xf32, 2>
                      %4 = adf.buffer.create @L1_L1_B_1() : memref<8x16xf32, 2>
                      %5 = adf.buffer.create @L1_L1_C_1() : memref<16x16xf32, 2>
                      %6 = adf.buffer.create @L1_L1_D_1() {accumulator} : memref<2x16xf32, 2>
                      %7 = adf.buffer.create @L1_L1_A_2() : memref<2x8x16xf32, 2>
                      %8 = adf.buffer.create @L1_L1_B_2() : memref<8x16xf32, 2>
                      %9 = adf.buffer.create @L1_L1_C_2() : memref<16x16xf32, 2>
                      %10 = adf.buffer.create @L1_L1_A_3() : memref<2x8x16xf32, 2>
                      %11 = adf.buffer.create @L1_L1_B_3() : memref<8x16xf32, 2>
                      %12 = adf.buffer.create @L1_L1_C_3() : memref<16x16xf32, 2>
                      %13 = adf.buffer.create @L1_L1_D_3() {accumulator} : memref<2x16xf32, 2>
                      %14 = adf.buffer.create @L1_L1_A_4() : memref<2x8x16xf32, 2>
                      %15 = adf.buffer.create @L1_L1_B_4() : memref<8x16xf32, 2>
                      %16 = adf.buffer.create @L1_L1_C_4() : memref<16x16xf32, 2>
                      %17 = adf.buffer.create @L1_L1_A_5() : memref<2x8x16xf32, 2>
                      %18 = adf.buffer.create @L1_L1_B_5() : memref<8x16xf32, 2>
                      %19 = adf.buffer.create @L1_L1_C_5() : memref<16x16xf32, 2>
                      %20 = adf.buffer.create @L1_L1_D_5() {accumulator} : memref<2x16xf32, 2>
                      %21 = adf.buffer.create @L1_L1_A_6() : memref<2x8x16xf32, 2>
                      %22 = adf.buffer.create @L1_L1_B_6() : memref<8x16xf32, 2>
                      %23 = adf.buffer.create @L1_L1_C_6() : memref<16x16xf32, 2>
                      %24 = adf.buffer.create @L1_L1_A_7() : memref<2x8x16xf32, 2>
                      %25 = adf.buffer.create @L1_L1_B_7() : memref<8x16xf32, 2>
                      %26 = adf.buffer.create @L1_L1_C_7() : memref<16x16xf32, 2>
                      %27 = adf.buffer.create @L1_L1_D_7() {accumulator} : memref<2x16xf32, 2>
                      %28 = affine.apply #map(%arg8, %arg4)
                      %29 = affine.apply #map1(%arg10, %arg6)
                      %30 = affine.apply #map2(%arg11, %arg7)
                      %31 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%31, 250) : <In, 32>
                      adf.io.push(%arg0[%28, %29, %30] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %31) : (memref<8x32x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%31, %0) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      adf.connect(%31, %7) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      %32 = affine.apply #map2(%arg9, %arg5)
                      %33 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%33, 250) : <In, 32>
                      adf.io.push(%arg1[%29, %32] [%c8, %c16] [%c1, %c1] [] [] [] [], %33) : (memref<32x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%33, %1) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      adf.connect(%33, %4) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      adf.connect(%33, %15) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      adf.connect(%33, %18) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      %34 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%34, 250) : <In, 32>
                      adf.io.push(%arg2[%30, %32] [%c16, %c16] [%c1, %c1] [] [] [] [], %34) : (memref<128x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%34, %2) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      adf.connect(%34, %16) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      %35 = func.call @kernel_mttkrp0(%0, %1, %2) {adf.kernel, ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
                      adf.connect(%35, %6) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      %36 = affine.apply #map3(%arg11, %arg7)
                      %37 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%37, 250) : <In, 32>
                      adf.io.push(%arg0[%28, %29, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %37) : (memref<8x32x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%37, %3) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      adf.connect(%37, %10) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      %38 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%38, 250) : <In, 32>
                      adf.io.push(%arg2[%36, %32] [%c16, %c16] [%c1, %c1] [] [] [] [], %38) : (memref<128x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%38, %5) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      adf.connect(%38, %19) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      %39 = func.call @kernel_mttkrp(%3, %4, %5, %6) {adf.kernel, ivs = [1 : index, 0 : index, 0 : index], kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
                      %40 = adf.graph.io(PLIO) : !adf.plio<Out, 32>
                      adf.config.plio(%40, 250) : <Out, 32>
                      adf.connect(%39, %40) : (memref<2x16xf32, 2>, !adf.plio<Out, 32>)
                      adf.io.pop(%40, %arg3[%28, %32] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1]} : (!adf.plio<Out, 32>, memref<8x128xf32>)
                      %41 = affine.apply #map3(%arg9, %arg5)
                      %42 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%42, 250) : <In, 32>
                      adf.io.push(%arg1[%29, %41] [%c8, %c16] [%c1, %c1] [] [] [] [], %42) : (memref<32x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%42, %8) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      adf.connect(%42, %11) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      adf.connect(%42, %22) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      adf.connect(%42, %25) : (!adf.plio<In, 32>, memref<8x16xf32, 2>)
                      %43 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%43, 250) : <In, 32>
                      adf.io.push(%arg2[%30, %41] [%c16, %c16] [%c1, %c1] [] [] [] [], %43) : (memref<128x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%43, %9) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      adf.connect(%43, %23) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      %44 = func.call @kernel_mttkrp0(%7, %8, %9) {adf.kernel, ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
                      adf.connect(%44, %13) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      %45 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%45, 250) : <In, 32>
                      adf.io.push(%arg2[%36, %41] [%c16, %c16] [%c1, %c1] [] [] [] [], %45) : (memref<128x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%45, %12) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      adf.connect(%45, %26) : (!adf.plio<In, 32>, memref<16x16xf32, 2>)
                      %46 = func.call @kernel_mttkrp(%10, %11, %12, %13) {adf.kernel, ivs = [1 : index, 1 : index, 0 : index], kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
                      %47 = adf.graph.io(PLIO) : !adf.plio<Out, 32>
                      adf.config.plio(%47, 250) : <Out, 32>
                      adf.connect(%46, %47) : (memref<2x16xf32, 2>, !adf.plio<Out, 32>)
                      adf.io.pop(%47, %arg3[%28, %41] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1]} : (!adf.plio<Out, 32>, memref<8x128xf32>)
                      %48 = affine.apply #map4(%arg8, %arg4)
                      %49 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%49, 250) : <In, 32>
                      adf.io.push(%arg0[%48, %29, %30] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %49) : (memref<8x32x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%49, %14) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      adf.connect(%49, %21) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      %50 = func.call @kernel_mttkrp0(%14, %15, %16) {adf.kernel, ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
                      adf.connect(%50, %20) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      %51 = adf.graph.io(PLIO) : !adf.plio<In, 32>
                      adf.config.plio(%51, 250) : <In, 32>
                      adf.io.push(%arg0[%48, %29, %36] [%c2, %c8, %c16] [%c1, %c1, %c1] [] [] [] [], %51) : (memref<8x32x128xf32>, !adf.plio<In, 32>)
                      adf.connect(%51, %17) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      adf.connect(%51, %24) : (!adf.plio<In, 32>, memref<2x8x16xf32, 2>)
                      %52 = func.call @kernel_mttkrp(%17, %18, %19, %20) {adf.kernel, ivs = [1 : index, 0 : index, 1 : index], kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
                      %53 = adf.graph.io(PLIO) : !adf.plio<Out, 32>
                      adf.config.plio(%53, 250) : <Out, 32>
                      adf.connect(%52, %53) : (memref<2x16xf32, 2>, !adf.plio<Out, 32>)
                      adf.io.pop(%53, %arg3[%48, %32] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1]} : (!adf.plio<Out, 32>, memref<8x128xf32>)
                      %54 = func.call @kernel_mttkrp0(%21, %22, %23) {adf.kernel, ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
                      adf.connect(%54, %27) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
                      %55 = func.call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, ivs = [1 : index, 1 : index, 1 : index], kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
                      %56 = adf.graph.io(PLIO) : !adf.plio<Out, 32>
                      adf.config.plio(%56, 250) : <Out, 32>
                      adf.connect(%55, %56) : (memref<2x16xf32, 2>, !adf.plio<Out, 32>)
                      adf.io.pop(%56, %arg3[%48, %41] [%c2, %c16] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1]} : (!adf.plio<Out, 32>, memref<8x128xf32>)
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
  func.func @top(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {outArgs = [3 : i32], top_func} {
    call @mttkrp(%arg0, %arg1, %arg2, %arg3) : (memref<8x32x128xf32>, memref<32x128xf32>, memref<128x128xf32>, memref<8x128xf32>) -> ()
    return
  }
}