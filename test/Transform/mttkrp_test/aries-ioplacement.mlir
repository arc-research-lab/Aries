// RUN: aries-opt -aries-io-placement="first-col=6 num-shim=39 mid-line=24 chal-in=3 chal-out=3 iocons="true" en-pl="true" en-aie2="false"" -cse -canonicalize %s | FileCheck %s

// CHECK: module {
// CHECK:   func.func private @kernel_mttkrp0(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel, edge_kernel}
// CHECK:   func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel}
// CHECK:   func.func @adf_cell0(%arg0: !adf.plio<In, 128>, %arg1: !adf.plio<In, 128>, %arg2: !adf.plio<In, 128>, %arg3: !adf.plio<In, 128>, %arg4: !adf.plio<In, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<In, 128>, %arg9: !adf.plio<Out, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<Out, 128>, %arg13: !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]} {
// CHECK:     %c6 = arith.constant 6 : index
// CHECK:     %c7 = arith.constant 7 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c3 = arith.constant 3 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %c5 = arith.constant 5 : index
// CHECK:     %c25 = arith.constant 25 : index
// CHECK:     %c12288 = arith.constant 12288 : index
// CHECK:     %c4096 = arith.constant 4096 : index
// CHECK:     %c24576 = arith.constant 24576 : index
// CHECK:     %c16384 = arith.constant 16384 : index
// CHECK:     %c8192 = arith.constant 8192 : index
// CHECK:     %c0 = arith.constant 0 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c24 = arith.constant 24 : index
// CHECK:     adf.config.plio(%arg0, 250) {"col, chl" = [24 : index, 4 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg1, 250) {"col, chl" = [24 : index, 2 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg2, 250) {"col, chl" = [23 : index, 4 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg3, 250) {"col, chl" = [23 : index, 2 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg4, 250) {"col, chl" = [25 : index, 4 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg5, 250) {"col, chl" = [24 : index, 4 : index]} : <Out, 128>
// CHECK:     adf.config.plio(%arg6, 250) {"col, chl" = [25 : index, 2 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg7, 250) {"col, chl" = [22 : index, 4 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg8, 250) {"col, chl" = [22 : index, 2 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg9, 250) {"col, chl" = [24 : index, 2 : index]} : <Out, 128>
// CHECK:     adf.config.plio(%arg10, 250) {"col, chl" = [26 : index, 4 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg11, 250) {"col, chl" = [26 : index, 2 : index]} : <In, 128>
// CHECK:     adf.config.plio(%arg12, 250) {"col, chl" = [24 : index, 0 : index]} : <Out, 128>
// CHECK:     adf.config.plio(%arg13, 250) {"col, chl" = [23 : index, 4 : index]} : <Out, 128>
// CHECK:     %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xf32, 2>
// CHECK:     %1 = adf.buffer.create @L1_L1_B() : memref<8x16xf32, 2>
// CHECK:     %2 = adf.buffer.create @L1_L1_C() : memref<16x16xf32, 2>
// CHECK:     %3 = adf.buffer.create @L1_L1_A_1() : memref<2x8x16xf32, 2>
// CHECK:     %4 = adf.buffer.create @L1_L1_B_1() : memref<8x16xf32, 2>
// CHECK:     %5 = adf.buffer.create @L1_L1_C_1() : memref<16x16xf32, 2>
// CHECK:     %6 = adf.buffer.create @L1_L1_D_1() {accumulator} : memref<2x16xf32, 2>
// CHECK:     %7 = adf.buffer.create @L1_L1_A_2() : memref<2x8x16xf32, 2>
// CHECK:     %8 = adf.buffer.create @L1_L1_B_2() : memref<8x16xf32, 2>
// CHECK:     %9 = adf.buffer.create @L1_L1_C_2() : memref<16x16xf32, 2>
// CHECK:     %10 = adf.buffer.create @L1_L1_A_3() : memref<2x8x16xf32, 2>
// CHECK:     %11 = adf.buffer.create @L1_L1_B_3() : memref<8x16xf32, 2>
// CHECK:     %12 = adf.buffer.create @L1_L1_C_3() : memref<16x16xf32, 2>
// CHECK:     %13 = adf.buffer.create @L1_L1_D_3() {accumulator} : memref<2x16xf32, 2>
// CHECK:     %14 = adf.buffer.create @L1_L1_A_4() : memref<2x8x16xf32, 2>
// CHECK:     %15 = adf.buffer.create @L1_L1_B_4() : memref<8x16xf32, 2>
// CHECK:     %16 = adf.buffer.create @L1_L1_C_4() : memref<16x16xf32, 2>
// CHECK:     %17 = adf.buffer.create @L1_L1_A_5() : memref<2x8x16xf32, 2>
// CHECK:     %18 = adf.buffer.create @L1_L1_B_5() : memref<8x16xf32, 2>
// CHECK:     %19 = adf.buffer.create @L1_L1_C_5() : memref<16x16xf32, 2>
// CHECK:     %20 = adf.buffer.create @L1_L1_D_5() {accumulator} : memref<2x16xf32, 2>
// CHECK:     %21 = adf.buffer.create @L1_L1_A_6() : memref<2x8x16xf32, 2>
// CHECK:     %22 = adf.buffer.create @L1_L1_B_6() : memref<8x16xf32, 2>
// CHECK:     %23 = adf.buffer.create @L1_L1_C_6() : memref<16x16xf32, 2>
// CHECK:     %24 = adf.buffer.create @L1_L1_A_7() : memref<2x8x16xf32, 2>
// CHECK:     %25 = adf.buffer.create @L1_L1_B_7() : memref<8x16xf32, 2>
// CHECK:     %26 = adf.buffer.create @L1_L1_C_7() : memref<16x16xf32, 2>
// CHECK:     %27 = adf.buffer.create @L1_L1_D_7() {accumulator} : memref<2x16xf32, 2>
// CHECK:     adf.connect(%arg0, %0) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     adf.connect(%arg0, %7) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     adf.connect(%arg1, %1) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg1, %4) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg1, %15) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg1, %18) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg2, %2) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     adf.connect(%arg2, %16) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     %28 = call @kernel_mttkrp0(%0, %1, %2) {adf.kernel, "col, row" = [24 : index, 0 : index], ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%28, %c24, %c0, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%1, %c24, %c0, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%2, %c24, %c1, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%0, %c24, %c1, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%28, %6) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:     adf.connect(%arg3, %3) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     adf.connect(%arg3, %10) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     adf.connect(%arg4, %5) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     adf.connect(%arg4, %19) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     %29 = call @kernel_mttkrp(%3, %4, %5, %6) {adf.kernel, "col, row" = [24 : index, 1 : index], ivs = [1 : index, 0 : index, 0 : index], kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%29, %c25, %c1, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%4, %c25, %c1, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%5, %c25, %c1, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%3, %c24, %c0, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%29, %arg5) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:     adf.connect(%arg6, %8) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg6, %11) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg6, %22) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg6, %25) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
// CHECK:     adf.connect(%arg7, %9) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     adf.connect(%arg7, %23) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     %30 = call @kernel_mttkrp0(%7, %8, %9) {adf.kernel, "col, row" = [24 : index, 4 : index], ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%30, %c24, %c4, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%8, %c24, %c4, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%9, %c24, %c5, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%7, %c24, %c5, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%30, %13) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:     adf.connect(%arg8, %12) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     adf.connect(%arg8, %26) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
// CHECK:     %31 = call @kernel_mttkrp(%10, %11, %12, %13) {adf.kernel, "col, row" = [24 : index, 5 : index], ivs = [1 : index, 1 : index, 0 : index], kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%31, %c25, %c5, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%11, %c25, %c5, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%12, %c25, %c5, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%10, %c24, %c4, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%31, %arg9) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:     adf.connect(%arg10, %14) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     adf.connect(%arg10, %21) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     %32 = call @kernel_mttkrp0(%14, %15, %16) {adf.kernel, "col, row" = [24 : index, 2 : index], ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%32, %c24, %c2, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%15, %c24, %c2, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%16, %c24, %c3, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%14, %c24, %c3, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%32, %20) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:     adf.connect(%arg11, %17) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     adf.connect(%arg11, %24) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
// CHECK:     %33 = call @kernel_mttkrp(%17, %18, %19, %20) {adf.kernel, "col, row" = [24 : index, 3 : index], ivs = [1 : index, 0 : index, 1 : index], kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%33, %c25, %c3, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%18, %c25, %c3, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%19, %c25, %c3, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%17, %c24, %c2, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%33, %arg12) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:     %34 = call @kernel_mttkrp0(%21, %22, %23) {adf.kernel, "col, row" = [24 : index, 6 : index], ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%34, %c24, %c6, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%22, %c24, %c6, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%23, %c24, %c7, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%21, %c24, %c7, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%34, %27) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
// CHECK:     %35 = call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, "col, row" = [24 : index, 7 : index], ivs = [1 : index, 1 : index, 1 : index], kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
// CHECK:     adf.buffer.location(%35, %c25, %c7, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%25, %c25, %c7, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%26, %c25, %c7, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
// CHECK:     adf.buffer.location(%24, %c24, %c6, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
// CHECK:     adf.connect(%35, %arg13) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
// CHECK:     return
// CHECK:   }
// CHECK: }

module {
  func.func private @kernel_mttkrp0(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel, edge_kernel}
  func.func private @kernel_mttkrp(memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel}
  func.func @adf_cell0(%arg0: !adf.plio<In, 128>, %arg1: !adf.plio<In, 128>, %arg2: !adf.plio<In, 128>, %arg3: !adf.plio<In, 128>, %arg4: !adf.plio<In, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<In, 128>, %arg9: !adf.plio<Out, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<Out, 128>, %arg13: !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]} {
    %c6 = arith.constant 6 : index
    %c7 = arith.constant 7 : index
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %c4 = arith.constant 4 : index
    %c5 = arith.constant 5 : index
    %c25 = arith.constant 25 : index
    %c12288 = arith.constant 12288 : index
    %c4096 = arith.constant 4096 : index
    %c24576 = arith.constant 24576 : index
    %c16384 = arith.constant 16384 : index
    %c8192 = arith.constant 8192 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c24 = arith.constant 24 : index
    adf.config.plio(%arg0, 250) : <In, 128>
    adf.config.plio(%arg1, 250) : <In, 128>
    adf.config.plio(%arg2, 250) : <In, 128>
    adf.config.plio(%arg3, 250) : <In, 128>
    adf.config.plio(%arg4, 250) : <In, 128>
    adf.config.plio(%arg5, 250) : <Out, 128>
    adf.config.plio(%arg6, 250) : <In, 128>
    adf.config.plio(%arg7, 250) : <In, 128>
    adf.config.plio(%arg8, 250) : <In, 128>
    adf.config.plio(%arg9, 250) : <Out, 128>
    adf.config.plio(%arg10, 250) : <In, 128>
    adf.config.plio(%arg11, 250) : <In, 128>
    adf.config.plio(%arg12, 250) : <Out, 128>
    adf.config.plio(%arg13, 250) : <Out, 128>
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
    adf.connect(%arg0, %0) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    adf.connect(%arg0, %7) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    adf.connect(%arg1, %1) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg1, %4) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg1, %15) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg1, %18) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg2, %2) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    adf.connect(%arg2, %16) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    %28 = call @kernel_mttkrp0(%0, %1, %2) {adf.kernel, "col, row" = [24 : index, 0 : index], ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 0 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%28, %c24, %c0, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%1, %c24, %c0, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%2, %c24, %c1, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%0, %c24, %c1, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%28, %6) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
    adf.connect(%arg3, %3) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    adf.connect(%arg3, %10) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    adf.connect(%arg4, %5) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    adf.connect(%arg4, %19) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    %29 = call @kernel_mttkrp(%3, %4, %5, %6) {adf.kernel, "col, row" = [24 : index, 1 : index], ivs = [1 : index, 0 : index, 0 : index], kernel_mttkrp = 1 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%29, %c25, %c1, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%4, %c25, %c1, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%5, %c25, %c1, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%3, %c24, %c0, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%29, %arg5) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg6, %8) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg6, %11) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg6, %22) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg6, %25) : (!adf.plio<In, 128>, memref<8x16xf32, 2>)
    adf.connect(%arg7, %9) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    adf.connect(%arg7, %23) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    %30 = call @kernel_mttkrp0(%7, %8, %9) {adf.kernel, "col, row" = [24 : index, 4 : index], ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 2 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%30, %c24, %c4, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%8, %c24, %c4, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%9, %c24, %c5, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%7, %c24, %c5, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%30, %13) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
    adf.connect(%arg8, %12) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    adf.connect(%arg8, %26) : (!adf.plio<In, 128>, memref<16x16xf32, 2>)
    %31 = call @kernel_mttkrp(%10, %11, %12, %13) {adf.kernel, "col, row" = [24 : index, 5 : index], ivs = [1 : index, 1 : index, 0 : index], kernel_mttkrp = 3 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%31, %c25, %c5, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%11, %c25, %c5, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%12, %c25, %c5, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%10, %c24, %c4, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%31, %arg9) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg10, %14) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    adf.connect(%arg10, %21) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    %32 = call @kernel_mttkrp0(%14, %15, %16) {adf.kernel, "col, row" = [24 : index, 2 : index], ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 4 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%32, %c24, %c2, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%15, %c24, %c2, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%16, %c24, %c3, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%14, %c24, %c3, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%32, %20) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
    adf.connect(%arg11, %17) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    adf.connect(%arg11, %24) : (!adf.plio<In, 128>, memref<2x8x16xf32, 2>)
    %33 = call @kernel_mttkrp(%17, %18, %19, %20) {adf.kernel, "col, row" = [24 : index, 3 : index], ivs = [1 : index, 0 : index, 1 : index], kernel_mttkrp = 5 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%33, %c25, %c3, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%18, %c25, %c3, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%19, %c25, %c3, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%17, %c24, %c2, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%33, %arg12) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
    %34 = call @kernel_mttkrp0(%21, %22, %23) {adf.kernel, "col, row" = [24 : index, 6 : index], ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 6 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%34, %c24, %c6, %c16384, %c24576) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%22, %c24, %c6, %c0, %c8192) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%23, %c24, %c7, %c16384, %c24576) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%21, %c24, %c7, %c0, %c8192) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%34, %27) : (memref<2x16xf32, 2>, memref<2x16xf32, 2>)
    %35 = call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, "col, row" = [24 : index, 7 : index], ivs = [1 : index, 1 : index, 1 : index], kernel_mttkrp = 7 : index} : (memref<2x8x16xf32, 2>, memref<8x16xf32, 2>, memref<16x16xf32, 2>, memref<2x16xf32, 2>) -> memref<2x16xf32, 2>
    adf.buffer.location(%35, %c25, %c7, %c4096, %c12288) : (memref<2x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%25, %c25, %c7, %c16384, %c24576) : (memref<8x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%26, %c25, %c7, %c0, %c8192) : (memref<16x16xf32, 2>, index, index, index, index)
    adf.buffer.location(%24, %c24, %c6, %c4096, %c12288) : (memref<2x8x16xf32, 2>, index, index, index, index)
    adf.connect(%35, %arg13) : (memref<2x16xf32, 2>, !adf.plio<Out, 128>)
    return
  }
}