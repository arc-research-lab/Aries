// RUN: aries-opt -aries-pipeline-versal="tile-func-name=mttkrp l1-tile-sizes=2,2,1,2 l2-tile-sizes=2,2,2,2 en-newtiling="true" port-type=PLIO plio-width=128 en-pl="true" en-aie2="false" en-link="true" col-num=50 row-num=8 col-offset=0  row-offset=0 core-gap=0 core-algo=2 first-col=6 num-shim=39 mid-line=24 chal-in=3 chal-out=3 iocons="true" buf-sels=0,1,0,1 axi-width=512 en-serial="true"" -cse --canonicalize %s | FileCheck %s

// CHECK: #map = affine_map<(d0) -> (d0 * 128 + 127)>
// CHECK: #map1 = affine_map<(d0) -> (d0 * 128)>
// CHECK: module {
// CHECK:   func.func @kernel_mttkrp0(%arg0: memref<2x8x16xf32, 2>, %arg1: memref<8x16xf32, 2>, %arg2: memref<16x16xf32, 2>) -> memref<2x16xf32, 2> attributes {adf.kernel, edge_kernel} {
// CHECK:     %cst = arith.constant 0.000000e+00 : f32
// CHECK:     %alloc = memref.alloc() : memref<2x16xf32, 2>
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
// CHECK:     %cst = arith.constant 0.000000e+00 : f32
// CHECK:     %alloc = memref.alloc() : memref<2x16xf32, 2>
// CHECK:     affine.for %arg4 = 0 to 2 {
// CHECK:       affine.for %arg5 = 0 to 16 {
// CHECK:         affine.store %cst, %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:         affine.for %arg6 = 0 to 8 {
// CHECK:           affine.for %arg7 = 0 to 16 {
// CHECK:             %3 = affine.load %arg0[%arg4, %arg6, %arg7] : memref<2x8x16xf32, 2>
// CHECK:             %4 = affine.load %arg1[%arg6, %arg5] : memref<8x16xf32, 2>
// CHECK:             %5 = arith.mulf %3, %4 : f32
// CHECK:             %6 = affine.load %arg2[%arg7, %arg5] : memref<16x16xf32, 2>
// CHECK:             %7 = arith.mulf %5, %6 : f32
// CHECK:             %8 = affine.load %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:             %9 = arith.addf %8, %7 : f32
// CHECK:             affine.store %9, %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:           }
// CHECK:         }
// CHECK:         %0 = affine.load %arg3[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:         %1 = affine.load %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:         %2 = arith.addf %0, %1 : f32
// CHECK:         affine.store %2, %alloc[%arg4, %arg5] : memref<2x16xf32, 2>
// CHECK:       }
// CHECK:     }
// CHECK:     return %alloc : memref<2x16xf32, 2>
// CHECK:   }
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
// CHECK:     %6 = adf.buffer.create @L1_L1_D_1() : memref<2x16xf32, 2>
// CHECK:     %7 = adf.buffer.create @L1_L1_A_2() : memref<2x8x16xf32, 2>
// CHECK:     %8 = adf.buffer.create @L1_L1_B_2() : memref<8x16xf32, 2>
// CHECK:     %9 = adf.buffer.create @L1_L1_C_2() : memref<16x16xf32, 2>
// CHECK:     %10 = adf.buffer.create @L1_L1_A_3() : memref<2x8x16xf32, 2>
// CHECK:     %11 = adf.buffer.create @L1_L1_B_3() : memref<8x16xf32, 2>
// CHECK:     %12 = adf.buffer.create @L1_L1_C_3() : memref<16x16xf32, 2>
// CHECK:     %13 = adf.buffer.create @L1_L1_D_3() : memref<2x16xf32, 2>
// CHECK:     %14 = adf.buffer.create @L1_L1_A_4() : memref<2x8x16xf32, 2>
// CHECK:     %15 = adf.buffer.create @L1_L1_B_4() : memref<8x16xf32, 2>
// CHECK:     %16 = adf.buffer.create @L1_L1_C_4() : memref<16x16xf32, 2>
// CHECK:     %17 = adf.buffer.create @L1_L1_A_5() : memref<2x8x16xf32, 2>
// CHECK:     %18 = adf.buffer.create @L1_L1_B_5() : memref<8x16xf32, 2>
// CHECK:     %19 = adf.buffer.create @L1_L1_C_5() : memref<16x16xf32, 2>
// CHECK:     %20 = adf.buffer.create @L1_L1_D_5() : memref<2x16xf32, 2>
// CHECK:     %21 = adf.buffer.create @L1_L1_A_6() : memref<2x8x16xf32, 2>
// CHECK:     %22 = adf.buffer.create @L1_L1_B_6() : memref<8x16xf32, 2>
// CHECK:     %23 = adf.buffer.create @L1_L1_C_6() : memref<16x16xf32, 2>
// CHECK:     %24 = adf.buffer.create @L1_L1_A_7() : memref<2x8x16xf32, 2>
// CHECK:     %25 = adf.buffer.create @L1_L1_B_7() : memref<8x16xf32, 2>
// CHECK:     %26 = adf.buffer.create @L1_L1_C_7() : memref<16x16xf32, 2>
// CHECK:     %27 = adf.buffer.create @L1_L1_D_7() : memref<2x16xf32, 2>
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
// CHECK:   func.func @load2(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     %c64 = arith.constant 64 : index
// CHECK:     %c32 = arith.constant 32 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg5 = 0 to 1 {
// CHECK:       affine.for %arg6 = 0 to 2 {
// CHECK:         affine.for %arg7 = 0 to 2 {
// CHECK:           affine.for %arg8 = 0 to 2 {
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 16 {
// CHECK:                 affine.for %arg11 = 0 to 2 {
// CHECK:                   affine.for %arg12 = 0 to 2 {
// CHECK:                     %0 = arith.muli %arg11, %c2 : index
// CHECK:                     %1 = arith.addi %arg12, %0 : index
// CHECK:                     %2 = arith.muli %arg6, %c4 : index
// CHECK:                     %3 = arith.addi %1, %2 : index
// CHECK:                     %4 = arith.muli %arg9, %c32 : index
// CHECK:                     %5 = arith.addi %arg10, %4 : index
// CHECK:                     %6 = arith.muli %arg8, %c64 : index
// CHECK:                     %7 = arith.addi %5, %6 : index
// CHECK:                     %8 = arith.muli %7, %c8 : index
// CHECK:                     %9 = arith.addi %3, %8 : index
// CHECK:                     %10 = memref.load %arg0[%9] : memref<?xi512>
// CHECK:                     %11 = arith.cmpi slt, %arg12, %c1 : index
// CHECK:                     scf.if %11 {
// CHECK:                       affine.store %10, %arg4[0] : memref<1xi512, "stream1">
// CHECK:                     } else {
// CHECK:                       affine.store %10, %arg2[0] : memref<1xi512, "stream1">
// CHECK:                     }
// CHECK:                   } {pipeline_ii = 1 : index}
// CHECK:                 }
// CHECK:               }
// CHECK:             } {merge}
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 16 {
// CHECK:                 affine.for %arg11 = 0 to 2 {
// CHECK:                   affine.for %arg12 = 0 to 2 {
// CHECK:                     %0 = arith.muli %arg11, %c2 : index
// CHECK:                     %1 = arith.addi %arg12, %0 : index
// CHECK:                     %2 = arith.muli %arg6, %c4 : index
// CHECK:                     %3 = arith.addi %1, %2 : index
// CHECK:                     %4 = arith.addi %arg10, %c16 : index
// CHECK:                     %5 = arith.muli %arg9, %c32 : index
// CHECK:                     %6 = arith.addi %4, %5 : index
// CHECK:                     %7 = arith.muli %arg8, %c64 : index
// CHECK:                     %8 = arith.addi %6, %7 : index
// CHECK:                     %9 = arith.muli %8, %c8 : index
// CHECK:                     %10 = arith.addi %3, %9 : index
// CHECK:                     %11 = memref.load %arg0[%10] : memref<?xi512>
// CHECK:                     %12 = arith.cmpi slt, %arg12, %c1 : index
// CHECK:                     scf.if %12 {
// CHECK:                       affine.store %11, %arg3[0] : memref<1xi512, "stream1">
// CHECK:                     } else {
// CHECK:                       affine.store %11, %arg1[0] : memref<1xi512, "stream1">
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
// CHECK:   func.func @load2_top(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load2(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
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
// CHECK:   func.func @store0(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg5 = 0 to 1 {
// CHECK:       affine.for %arg6 = 0 to 2 {
// CHECK:         affine.for %arg7 = 0 to 2 {
// CHECK:           affine.for %arg8 = 0 to 2 {
// CHECK:             affine.for %arg9 = 0 to 2 {
// CHECK:               affine.for %arg10 = 0 to 2 {
// CHECK:                 %0 = arith.cmpi slt, %arg10, %c1 : index
// CHECK:                 %1 = scf.if %0 -> (i512) {
// CHECK:                   %12 = affine.load %arg4[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %12 : i512
// CHECK:                 } else {
// CHECK:                   %12 = affine.load %arg3[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %12 : i512
// CHECK:                 }
// CHECK:                 %2 = arith.muli %arg9, %c2 : index
// CHECK:                 %3 = arith.addi %arg10, %2 : index
// CHECK:                 %4 = arith.muli %arg6, %c4 : index
// CHECK:                 %5 = arith.addi %3, %4 : index
// CHECK:                 %6 = arith.muli %arg7, %c4 : index
// CHECK:                 %7 = arith.addi %arg8, %6 : index
// CHECK:                 %8 = arith.muli %arg5, %c8 : index
// CHECK:                 %9 = arith.addi %7, %8 : index
// CHECK:                 %10 = arith.muli %9, %c8 : index
// CHECK:                 %11 = arith.addi %5, %10 : index
// CHECK:                 memref.store %1, %arg0[%11] : memref<?xi512>
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
// CHECK:                   %13 = affine.load %arg2[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %13 : i512
// CHECK:                 } else {
// CHECK:                   %13 = affine.load %arg1[0] : memref<1xi512, "stream1">
// CHECK:                   scf.yield %13 : i512
// CHECK:                 }
// CHECK:                 %2 = arith.muli %arg9, %c2 : index
// CHECK:                 %3 = arith.addi %arg10, %2 : index
// CHECK:                 %4 = arith.muli %arg6, %c4 : index
// CHECK:                 %5 = arith.addi %3, %4 : index
// CHECK:                 %6 = arith.addi %arg8, %c2 : index
// CHECK:                 %7 = arith.muli %arg7, %c4 : index
// CHECK:                 %8 = arith.addi %6, %7 : index
// CHECK:                 %9 = arith.muli %arg5, %c8 : index
// CHECK:                 %10 = arith.addi %8, %9 : index
// CHECK:                 %11 = arith.muli %10, %c8 : index
// CHECK:                 %12 = arith.addi %5, %11 : index
// CHECK:                 memref.store %1, %arg0[%12] : memref<?xi512>
// CHECK:               } {pipeline_ii = 1 : index}
// CHECK:             }
// CHECK:           }
// CHECK:         } {merge}
// CHECK:       }
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @store0_top(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @store0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @load0(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     %c256 = arith.constant 256 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c16 = arith.constant 16 : index
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
// CHECK:                         %0 = arith.muli %arg13, %c2 : index
// CHECK:                         %1 = arith.addi %arg14, %0 : index
// CHECK:                         %2 = arith.muli %arg8, %c4 : index
// CHECK:                         %3 = arith.addi %1, %2 : index
// CHECK:                         %4 = arith.muli %arg10, %c8 : index
// CHECK:                         %5 = arith.addi %arg12, %4 : index
// CHECK:                         %6 = arith.muli %arg7, %c16 : index
// CHECK:                         %7 = arith.addi %5, %6 : index
// CHECK:                         %8 = arith.muli %7, %c8 : index
// CHECK:                         %9 = arith.addi %3, %8 : index
// CHECK:                         %10 = arith.muli %arg9, %c4 : index
// CHECK:                         %11 = arith.addi %arg11, %10 : index
// CHECK:                         %12 = arith.muli %arg5, %c8 : index
// CHECK:                         %13 = arith.addi %11, %12 : index
// CHECK:                         %14 = arith.muli %13, %c256 : index
// CHECK:                         %15 = arith.addi %9, %14 : index
// CHECK:                         %16 = memref.load %arg0[%15] : memref<?xi512>
// CHECK:                         %17 = arith.cmpi slt, %arg14, %c1 : index
// CHECK:                         scf.if %17 {
// CHECK:                           affine.store %16, %arg4[0] : memref<1xi512, "stream1">
// CHECK:                         } else {
// CHECK:                           affine.store %16, %arg3[0] : memref<1xi512, "stream1">
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
// CHECK:                         %0 = arith.muli %arg13, %c2 : index
// CHECK:                         %1 = arith.addi %arg14, %0 : index
// CHECK:                         %2 = arith.muli %arg8, %c4 : index
// CHECK:                         %3 = arith.addi %1, %2 : index
// CHECK:                         %4 = arith.muli %arg10, %c8 : index
// CHECK:                         %5 = arith.addi %arg12, %4 : index
// CHECK:                         %6 = arith.muli %arg7, %c16 : index
// CHECK:                         %7 = arith.addi %5, %6 : index
// CHECK:                         %8 = arith.muli %7, %c8 : index
// CHECK:                         %9 = arith.addi %3, %8 : index
// CHECK:                         %10 = arith.addi %arg11, %c2 : index
// CHECK:                         %11 = arith.muli %arg9, %c4 : index
// CHECK:                         %12 = arith.addi %10, %11 : index
// CHECK:                         %13 = arith.muli %arg5, %c8 : index
// CHECK:                         %14 = arith.addi %12, %13 : index
// CHECK:                         %15 = arith.muli %14, %c256 : index
// CHECK:                         %16 = arith.addi %9, %15 : index
// CHECK:                         %17 = memref.load %arg0[%16] : memref<?xi512>
// CHECK:                         %18 = arith.cmpi slt, %arg14, %c1 : index
// CHECK:                         scf.if %18 {
// CHECK:                           affine.store %17, %arg2[0] : memref<1xi512, "stream1">
// CHECK:                         } else {
// CHECK:                           affine.store %17, %arg1[0] : memref<1xi512, "stream1">
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
// CHECK:   func.func @load0_top(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">, %arg3: memref<1xi512, "stream1">, %arg4: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
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
// CHECK:   func.func @load1(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     affine.for %arg3 = 0 to 1 {
// CHECK:       affine.for %arg4 = 0 to 2 {
// CHECK:         affine.for %arg5 = 0 to 2 {
// CHECK:           affine.for %arg6 = 0 to 2 {
// CHECK:             affine.for %arg7 = 0 to 2 {
// CHECK:               affine.for %arg8 = 0 to 8 {
// CHECK:                 affine.for %arg9 = 0 to 2 {
// CHECK:                   affine.for %arg10 = 0 to 2 {
// CHECK:                     %0 = arith.muli %arg9, %c2 : index
// CHECK:                     %1 = arith.addi %arg10, %0 : index
// CHECK:                     %2 = arith.muli %arg4, %c4 : index
// CHECK:                     %3 = arith.addi %1, %2 : index
// CHECK:                     %4 = arith.muli %arg7, %c8 : index
// CHECK:                     %5 = arith.addi %arg8, %4 : index
// CHECK:                     %6 = arith.muli %arg5, %c16 : index
// CHECK:                     %7 = arith.addi %5, %6 : index
// CHECK:                     %8 = arith.muli %7, %c8 : index
// CHECK:                     %9 = arith.addi %3, %8 : index
// CHECK:                     %10 = memref.load %arg0[%9] : memref<?xi512>
// CHECK:                     %11 = arith.cmpi slt, %arg10, %c1 : index
// CHECK:                     scf.if %11 {
// CHECK:                       affine.store %10, %arg2[0] : memref<1xi512, "stream1">
// CHECK:                     } else {
// CHECK:                       affine.store %10, %arg1[0] : memref<1xi512, "stream1">
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
// CHECK:   func.func @load1_top(%arg0: memref<?xi512>, %arg1: memref<1xi512, "stream1">, %arg2: memref<1xi512, "stream1">) attributes {adf.pl, inline = false} {
// CHECK:     call @load1(%arg0, %arg1, %arg2) {template = 0 : index} : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
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
// CHECK:   func.func @mttkrp_pl(%arg0: memref<?xi512>, %arg1: memref<?xi512>, %arg2: memref<?xi512>, %arg3: memref<?xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
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
// CHECK:     call @load2_top(%arg2, %alloc_13, %alloc_14, %alloc_15, %alloc_16) : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load2_3_top(%alloc_10, %alloc_16, %alloc_8, %alloc_15, %alloc_6, %alloc_14, %alloc_5, %alloc_13) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @send5_top(%arg11, %alloc_7, %arg16, %alloc_11) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @receive2_top(%arg5, %alloc_1, %arg12, %alloc, %arg4, %alloc_2, %arg8, %alloc_0) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @send6_top(%arg10, %alloc_6, %arg13, %alloc_8, %arg9, %alloc_5, %arg15, %alloc_10) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
// CHECK:     call @store0_0_top(%alloc_2, %alloc_17, %alloc_1, %alloc_18, %alloc_0, %alloc_19, %alloc, %alloc_20) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @store0_top(%arg3, %alloc_17, %alloc_18, %alloc_19, %alloc_20) : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_top(%arg0, %alloc_21, %alloc_22, %alloc_23, %alloc_24) : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load0_3_top(%alloc_12, %alloc_24, %alloc_9, %alloc_23, %alloc_4, %alloc_22, %alloc_3, %alloc_21) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load1_top(%arg1, %alloc_25, %alloc_26) : (memref<?xi512>, memref<1xi512, "stream1">, memref<1xi512, "stream1">) -> ()
// CHECK:     call @load1_1_top(%alloc_11, %alloc_26, %alloc_7, %alloc_25) : (memref<1xi128, "stream">, memref<1xi512, "stream1">, memref<1xi128, "stream">, memref<1xi512, "stream1">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @mttkrp(%arg0: memref<?xi512>, %arg1: memref<?xi512>, %arg2: memref<?xi512>, %arg3: memref<?xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
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
// CHECK:       func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) {adf.pl} : (memref<?xi512>, memref<?xi512>, memref<?xi512>, memref<?xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
// CHECK:       adf.pl.launch.wait
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK:   func.func @top(%arg0: memref<?xi512>, %arg1: memref<?xi512>, %arg2: memref<?xi512>, %arg3: memref<?xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">) attributes {outArgs = [3 : i32], top_func = "plio"} {
// CHECK:     call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17) : (memref<?xi512>, memref<?xi512>, memref<?xi512>, memref<?xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
// CHECK:     return
// CHECK:   }
// CHECK:   func.func private @mttkrp_host(memref<32768xf32>, memref<4096xf32>, memref<16384xf32>, memref<1024xf32>) attributes {origin_func = "mttkrp"}
// CHECK:   func.func @top_host(%arg0: memref<32768xf32>, %arg1: memref<4096xf32>, %arg2: memref<16384xf32>, %arg3: memref<1024xf32>) attributes {origin_func = "top", outArgs = [3 : i32], top_host} {
// CHECK:     call @mttkrp_host(%arg0, %arg1, %arg2, %arg3) {origin_func = "mttkrp"} : (memref<32768xf32>, memref<4096xf32>, memref<16384xf32>, memref<1024xf32>) -> ()
// CHECK:     return
// CHECK:   }
// CHECK: }

#map = affine_map<(d0) -> (d0 * 2)>
#map1 = affine_map<(d0) -> (d0 * 8)>
#map2 = affine_map<(d0) -> (d0 * 16)>
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
    affine.for %arg4 = 0 to 4 {
      affine.for %arg5 = 0 to 8 {
        affine.for %arg6 = 0 to 4 {
          affine.for %arg7 = 0 to 8 {
            %0 = adf.buffer.create @L1_L1_A() : memref<2x8x16xf32, 2>
            %1 = adf.buffer.create @L1_L1_B() : memref<8x16xf32, 2>
            %2 = adf.buffer.create @L1_L1_C() : memref<16x16xf32, 2>
            %3 = adf.buffer.create @L1_L1_D() : memref<2x16xf32, 2>
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
  func.func @top(%arg0: memref<8x32x128xf32>, %arg1: memref<32x128xf32>, %arg2: memref<128x128xf32>, %arg3: memref<8x128xf32>) attributes {top_func} {
    call @mttkrp(%arg0, %arg1, %arg2, %arg3) : (memref<8x32x128xf32>, memref<32x128xf32>, memref<128x128xf32>, memref<8x128xf32>) -> ()
    return
  }
}