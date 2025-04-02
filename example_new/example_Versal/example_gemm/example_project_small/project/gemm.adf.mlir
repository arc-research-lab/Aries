#map = affine_map<(d0) -> (d0 * 128 + 127)>
#map1 = affine_map<(d0) -> (d0 * 128)>
module {
  func.func @kernel_gemm0(%arg0: memref<32x32xf32, 2>, %arg1: memref<32x32xf32, 2>) -> memref<32x32xf32, 2> attributes {adf.kernel, edge_kernel} {
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<32x32xf32, 2>
    affine.for %arg2 = 0 to 32 {
      affine.for %arg3 = 0 to 32 {
        affine.store %cst, %alloc[%arg2, %arg3] : memref<32x32xf32, 2>
      }
    }
    affine.for %arg2 = 0 to 32 {
      affine.for %arg3 = 0 to 32 {
        affine.store %cst, %alloc[%arg2, %arg3] : memref<32x32xf32, 2>
        affine.for %arg4 = 0 to 32 {
          %0 = affine.load %arg0[%arg2, %arg4] : memref<32x32xf32, 2>
          %1 = affine.load %arg1[%arg4, %arg3] : memref<32x32xf32, 2>
          %2 = arith.mulf %0, %1 : f32
          %3 = affine.load %alloc[%arg2, %arg3] : memref<32x32xf32, 2>
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %alloc[%arg2, %arg3] : memref<32x32xf32, 2>
        }
      }
    }
    return %alloc : memref<32x32xf32, 2>
  }
  func.func @kernel_gemm(%arg0: memref<32x32xf32, 2>, %arg1: memref<32x32xf32, 2>, %arg2: memref<32x32xf32, 2>) -> memref<32x32xf32, 2> attributes {adf.kernel} {
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<32x32xf32, 2>
    affine.for %arg3 = 0 to 32 {
      affine.for %arg4 = 0 to 32 {
        %0 = affine.load %arg2[%arg3, %arg4] : memref<32x32xf32, 2>
        affine.store %0, %alloc[%arg3, %arg4] : memref<32x32xf32, 2>
        affine.store %cst, %alloc[%arg3, %arg4] : memref<32x32xf32, 2>
        affine.for %arg5 = 0 to 32 {
          %1 = affine.load %arg0[%arg3, %arg5] : memref<32x32xf32, 2>
          %2 = affine.load %arg1[%arg5, %arg4] : memref<32x32xf32, 2>
          %3 = arith.mulf %1, %2 : f32
          %4 = affine.load %alloc[%arg3, %arg4] : memref<32x32xf32, 2>
          %5 = arith.addf %4, %3 : f32
          affine.store %5, %alloc[%arg3, %arg4] : memref<32x32xf32, 2>
        }
      }
    }
    return %alloc : memref<32x32xf32, 2>
  }
  func.func @adf_cell0(%arg0: !adf.plio<In, 128>, %arg1: !adf.plio<In, 128>, %arg2: !adf.plio<In, 128>, %arg3: !adf.plio<In, 128>, %arg4: !adf.plio<Out, 128>, %arg5: !adf.plio<In, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<Out, 128>, %arg8: !adf.plio<In, 128>, %arg9: !adf.plio<In, 128>, %arg10: !adf.plio<Out, 128>, %arg11: !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]} {
    %c4 = arith.constant 4 : index
    %c26 = arith.constant 26 : index
    %c12288 = arith.constant 12288 : index
    %c4096 = arith.constant 4096 : index
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %c24576 = arith.constant 24576 : index
    %c16384 = arith.constant 16384 : index
    %c25 = arith.constant 25 : index
    %c23 = arith.constant 23 : index
    %c8192 = arith.constant 8192 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c24 = arith.constant 24 : index
    adf.config.plio(%arg0, 250) {"col, chl" = [24 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg1, 250) {"col, chl" = [24 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg2, 250) {"col, chl" = [25 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg3, 250) {"col, chl" = [25 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg4, 250) {"col, chl" = [25 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg5, 250) {"col, chl" = [24 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg6, 250) {"col, chl" = [25 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg7, 250) {"col, chl" = [25 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg8, 250) {"col, chl" = [23 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg9, 250) {"col, chl" = [26 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg10, 250) {"col, chl" = [25 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg11, 250) {"col, chl" = [24 : index, 4 : index]} : <Out, 128>
    %0 = adf.buffer.create @L1_L1_A() : memref<32x32xf32, 2>
    %1 = adf.buffer.create @L1_L1_B() : memref<32x32xf32, 2>
    %2 = adf.buffer.create @L1_L1_A_1() : memref<32x32xf32, 2>
    %3 = adf.buffer.create @L1_L1_B_1() : memref<32x32xf32, 2>
    %4 = adf.buffer.create @L1_L1_C_1() {accumulator} : memref<32x32xf32, 2>
    %5 = adf.buffer.create @L1_L1_A_2() : memref<32x32xf32, 2>
    %6 = adf.buffer.create @L1_L1_B_2() : memref<32x32xf32, 2>
    %7 = adf.buffer.create @L1_L1_A_3() : memref<32x32xf32, 2>
    %8 = adf.buffer.create @L1_L1_B_3() : memref<32x32xf32, 2>
    %9 = adf.buffer.create @L1_L1_C_3() {accumulator} : memref<32x32xf32, 2>
    %10 = adf.buffer.create @L1_L1_A_4() : memref<32x32xf32, 2>
    %11 = adf.buffer.create @L1_L1_B_4() : memref<32x32xf32, 2>
    %12 = adf.buffer.create @L1_L1_A_5() : memref<32x32xf32, 2>
    %13 = adf.buffer.create @L1_L1_B_5() : memref<32x32xf32, 2>
    %14 = adf.buffer.create @L1_L1_C_5() {accumulator} : memref<32x32xf32, 2>
    %15 = adf.buffer.create @L1_L1_A_6() : memref<32x32xf32, 2>
    %16 = adf.buffer.create @L1_L1_B_6() : memref<32x32xf32, 2>
    %17 = adf.buffer.create @L1_L1_A_7() : memref<32x32xf32, 2>
    %18 = adf.buffer.create @L1_L1_B_7() : memref<32x32xf32, 2>
    %19 = adf.buffer.create @L1_L1_C_7() {accumulator} : memref<32x32xf32, 2>
    adf.connect(%arg0, %0) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg0, %5) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %1) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %11) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %20 = call @kernel_gemm0(%0, %1) {adf.kernel, "col, row" = [24 : index, 0 : index], ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 0 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%20, %c24, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%1, %c23, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%0, %c24, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%20, %4) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    adf.connect(%arg2, %2) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg2, %7) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %3) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %13) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %21 = call @kernel_gemm(%2, %3, %4) {adf.kernel, "col, row" = [25 : index, 0 : index], ivs = [1 : index, 0 : index, 0 : index], kernel_gemm = 1 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%21, %c25, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%3, %c24, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%2, %c25, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%21, %arg4) : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg5, %6) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %16) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %22 = call @kernel_gemm0(%5, %6) {adf.kernel, "col, row" = [24 : index, 2 : index], ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 2 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%22, %c24, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%6, %c24, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%5, %c24, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%22, %9) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    adf.connect(%arg6, %8) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg6, %18) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %23 = call @kernel_gemm(%7, %8, %9) {adf.kernel, "col, row" = [25 : index, 2 : index], ivs = [1 : index, 1 : index, 0 : index], kernel_gemm = 3 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%23, %c25, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%8, %c25, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%7, %c25, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%23, %arg7) : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg8, %10) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg8, %15) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %24 = call @kernel_gemm0(%10, %11) {adf.kernel, "col, row" = [24 : index, 1 : index], ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 4 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%24, %c25, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%11, %c24, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%10, %c24, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%24, %14) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %12) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %17) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %25 = call @kernel_gemm(%12, %13, %14) {adf.kernel, "col, row" = [25 : index, 1 : index], ivs = [1 : index, 0 : index, 1 : index], kernel_gemm = 5 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%25, %c26, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%13, %c25, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%12, %c25, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%25, %arg10) : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    %26 = call @kernel_gemm0(%15, %16) {adf.kernel, "col, row" = [24 : index, 3 : index], ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 6 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%26, %c25, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%16, %c24, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%15, %c24, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%26, %19) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %27 = call @kernel_gemm(%17, %18, %19) {adf.kernel, "col, row" = [25 : index, 3 : index], ivs = [1 : index, 1 : index, 1 : index], kernel_gemm = 7 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%27, %c26, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%18, %c25, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%17, %c25, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%27, %arg11) : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    return
  }
  func.func @send3_0(%arg0: memref<1xi128, "stream">, %arg1: memref<64x16xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 32 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 8 {
              %0 = affine.load %arg0[0] : memref<1xi128, "stream">
              affine.store %0, %arg1[%arg4 + %arg3 * 32, %arg6 + %arg5 * 8] : memref<64x16xi128, 1>
            } {pipeline_ii = 1 : index}
          }
        }
      }
    }
    return
  }
  func.func @send3_1(%arg0: memref<64x16xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %arg0[%arg6 + %arg5 * 32, %arg7 + %arg4 * 8] : memref<64x16xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "plio">
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @send3(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c4 = arith.constant 4 : index
    %true = arith.constant true
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<64x16xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "bram_s2p"} : memref<64x16xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          %0 = arith.muli %arg3, %c2 : index
          %1 = arith.addi %arg4, %0 : index
          %2 = arith.muli %arg2, %c4 : index
          %3 = arith.addi %1, %2 : index
          %4 = arith.remsi %3, %c2 : index
          %5 = arith.cmpi eq, %4, %c0 : index
          %6 = arith.cmpi ne, %3, %c0 : index
          scf.if %5 {
            func.call @send3_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<64x16xi128, 1>, i1) -> ()
            func.call @send3_1(%alloc_0, %arg0, %6) : (memref<64x16xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          } else {
            func.call @send3_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<64x16xi128, 1>, i1) -> ()
            func.call @send3_1(%alloc, %arg0, %6) : (memref<64x16xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          }
        } {Array_Partition, reduction = 0 : i64}
      }
    }
    call @send3_1(%alloc_0, %arg0, %true) : (memref<64x16xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send3_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send3(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send3(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send3(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send3(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @receive2(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, receive, template} {
    %c32 = arith.constant 32 : index
    %c63 = arith.constant 63 : index
    %c0 = arith.constant 0 : index
    %c95 = arith.constant 95 : index
    %c64 = arith.constant 64 : index
    %c96 = arith.constant 96 : index
    %c31 = arith.constant 31 : index
    %c127 = arith.constant 127 : index
    %c0_i128 = arith.constant 0 : i128
    %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<64x16xi128, 1>
    affine.for %arg2 = 0 to 64 {
      affine.for %arg3 = 0 to 16 {
        affine.store %c0_i128, %alloc[%arg2, %arg3] : memref<64x16xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 32 {
                  affine.for %arg9 = 0 to 8 {
                    %0 = affine.load %arg0[0] : memref<1xi128, "plio">
                    %1 = affine.load %alloc[%arg8 + %arg5 * 32, %arg9 + %arg6 * 8] : memref<64x16xi128, 1>
                    %2 = adf.int_to_apint(%0) : (i128) -> i128
                    %3 = adf.int_to_apint(%1) : (i128) -> i128
                    %4 = adf.int_to_apint(%c0_i128) : (i128) -> i128
                    %5 = adf.get_slice(%2 : i128, %c31, %c0) -> i32
                    %6 = adf.get_slice(%3 : i128, %c31, %c0) -> i32
                    %7 = arith.bitcast %5 : i32 to f32
                    %8 = arith.bitcast %6 : i32 to f32
                    %9 = arith.addf %7, %8 : f32
                    %10 = arith.bitcast %9 : f32 to i32
                    adf.set_slice(%4 : i128, %c31, %c0, %10 : i32)
                    %11 = adf.get_slice(%2 : i128, %c63, %c32) -> i32
                    %12 = adf.get_slice(%3 : i128, %c63, %c32) -> i32
                    %13 = arith.bitcast %11 : i32 to f32
                    %14 = arith.bitcast %12 : i32 to f32
                    %15 = arith.addf %13, %14 : f32
                    %16 = arith.bitcast %15 : f32 to i32
                    adf.set_slice(%4 : i128, %c63, %c32, %16 : i32)
                    %17 = adf.get_slice(%2 : i128, %c95, %c64) -> i32
                    %18 = adf.get_slice(%3 : i128, %c95, %c64) -> i32
                    %19 = arith.bitcast %17 : i32 to f32
                    %20 = arith.bitcast %18 : i32 to f32
                    %21 = arith.addf %19, %20 : f32
                    %22 = arith.bitcast %21 : f32 to i32
                    adf.set_slice(%4 : i128, %c95, %c64, %22 : i32)
                    %23 = adf.get_slice(%2 : i128, %c127, %c96) -> i32
                    %24 = adf.get_slice(%3 : i128, %c127, %c96) -> i32
                    %25 = arith.bitcast %23 : i32 to f32
                    %26 = arith.bitcast %24 : i32 to f32
                    %27 = arith.addf %25, %26 : f32
                    %28 = arith.bitcast %27 : f32 to i32
                    adf.set_slice(%4 : i128, %c127, %c96, %28 : i32)
                    %29 = adf.apint_to_int(%4) : (i128) -> i128
                    affine.store %29, %alloc[%arg8 + %arg5 * 32, %arg9 + %arg6 * 8] : memref<64x16xi128, 1>
                  } {pipeline_ii = 1 : index}
                }
              }
            }
          }
        } {Array_Partition, reduction = 0 : i64}
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 32 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %alloc[%arg5 + %arg4 * 32, %arg7 + %arg6 * 8] : memref<64x16xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "stream">
                affine.store %c0_i128, %alloc[%arg5 + %arg4 * 32, %arg7 + %arg6 * 8] : memref<64x16xi128, 1>
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @receive2_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @receive2(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @send6_0(%arg0: memref<1xi128, "stream">, %arg1: memref<64x16xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 32 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 8 {
              %0 = affine.load %arg0[0] : memref<1xi128, "stream">
              affine.store %0, %arg1[%arg4 + %arg3 * 32, %arg6 + %arg5 * 8] : memref<64x16xi128, 1>
            } {pipeline_ii = 1 : index}
          }
        }
      }
    }
    return
  }
  func.func @send6_1(%arg0: memref<64x16xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %arg0[%arg6 + %arg3 * 32, %arg7 + %arg5 * 8] : memref<64x16xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "plio">
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @send6(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c4 = arith.constant 4 : index
    %true = arith.constant true
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<64x16xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "bram_s2p"} : memref<64x16xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          %0 = arith.muli %arg3, %c2 : index
          %1 = arith.addi %arg4, %0 : index
          %2 = arith.muli %arg2, %c4 : index
          %3 = arith.addi %1, %2 : index
          %4 = arith.remsi %3, %c2 : index
          %5 = arith.cmpi eq, %4, %c0 : index
          %6 = arith.cmpi ne, %3, %c0 : index
          scf.if %5 {
            func.call @send6_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<64x16xi128, 1>, i1) -> ()
            func.call @send6_1(%alloc_0, %arg0, %6) : (memref<64x16xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          } else {
            func.call @send6_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<64x16xi128, 1>, i1) -> ()
            func.call @send6_1(%alloc, %arg0, %6) : (memref<64x16xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          }
        } {Array_Partition, reduction = 0 : i64}
      }
    }
    call @send6_1(%alloc_0, %arg0, %true) : (memref<64x16xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send6_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send6(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @store0_0(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, store, template} {
    %c0_i512 = arith.constant 0 : i512
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 32 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 2 {
                %0 = adf.int_to_apint(%c0_i512) : (i512) -> i512
                affine.for %arg8 = 0 to 4 {
                  %1 = affine.load %arg0[0] : memref<1xi128, "stream">
                  %2 = affine.apply #map(%arg8)
                  %3 = affine.apply #map1(%arg8)
                  adf.set_slice(%0 : i512, %2, %3, %1 : i128)
                } {pipeline_ii = 1 : index}
                affine.store %0, %arg1[0] : memref<1xi512, "stream2">
              } {pipeline_ii = 4 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @store0_0_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @store0_0(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @store0(%arg0: memref<256x16xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
    %c2 = arith.constant 2 : index
    affine.for %arg5 = 0 to 2 {
      affine.for %arg6 = 0 to 2 {
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 32 {
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 4 {
                %0 = arith.cmpi slt, %arg10, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg1[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = affine.load %arg2[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                }
                affine.store %1, %arg0[%arg8 + %arg7 * 64 + %arg5 * 128, %arg10 + %arg9 * 4 + %arg6 * 8] : memref<256x16xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 32 {
            affine.for %arg9 = 0 to 2 {
              affine.for %arg10 = 0 to 4 {
                %0 = arith.cmpi slt, %arg10, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg4[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = affine.load %arg3[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                }
                affine.store %1, %arg0[%arg8 + %arg7 * 64 + %arg5 * 128 + 32, %arg10 + %arg9 * 4 + %arg6 * 8] : memref<256x16xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
      }
    }
    return
  }
  func.func @store0_top(%arg0: memref<256x16xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @store0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<256x16xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load0(%arg0: memref<256x16xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c2 = arith.constant 2 : index
    affine.for %arg5 = 0 to 2 {
      affine.for %arg6 = 0 to 2 {
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 32 {
              affine.for %arg10 = 0 to 2 {
                affine.for %arg11 = 0 to 4 {
                  %0 = affine.load %arg0[%arg9 + %arg8 * 64 + %arg5 * 128, %arg11 + %arg10 * 4 + %arg7 * 8] : memref<256x16xi512>
                  %1 = arith.cmpi slt, %arg11, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                  } else {
                    affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 32 {
              affine.for %arg10 = 0 to 2 {
                affine.for %arg11 = 0 to 4 {
                  %0 = affine.load %arg0[%arg9 + %arg8 * 64 + %arg5 * 128 + 32, %arg11 + %arg10 * 4 + %arg7 * 8] : memref<256x16xi512>
                  %1 = arith.cmpi slt, %arg11, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                  } else {
                    affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
        } {Array_Partition, reduction = 0 : i64}
      }
    }
    return
  }
  func.func @load0_top(%arg0: memref<256x16xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load0(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<256x16xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load0_3(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 2 {
                  %0 = affine.load %arg0[0] : memref<1xi512, "stream2">
                  affine.for %arg9 = 0 to 4 {
                    %1 = affine.apply #map(%arg9)
                    %2 = affine.apply #map1(%arg9)
                    %3 = adf.get_slice(%0 : i512, %1, %2) -> i128
                    affine.store %3, %arg1[0] : memref<1xi128, "stream">
                  } {pipeline_ii = 1 : index}
                } {pipeline_ii = 4 : index}
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @load0_3_top(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @load0_3(%arg0, %arg1) {template = 0 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg2, %arg3) {template = 1 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg4, %arg5) {template = 2 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg6, %arg7) {template = 3 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg8, %arg9) {template = 4 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg10, %arg11) {template = 5 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg12, %arg13) {template = 6 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_3(%arg14, %arg15) {template = 7 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @load1(%arg0: memref<256x16xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c2 = arith.constant 2 : index
    affine.for %arg5 = 0 to 2 {
      affine.for %arg6 = 0 to 2 {
        affine.for %arg7 = 0 to 2 {
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 32 {
              affine.for %arg10 = 0 to 2 {
                affine.for %arg11 = 0 to 4 {
                  %0 = affine.load %arg0[%arg9 + %arg8 * 64 + %arg7 * 128, %arg11 + %arg10 * 4 + %arg6 * 8] : memref<256x16xi512>
                  %1 = arith.cmpi slt, %arg11, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                  } else {
                    affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg8 = 0 to 2 {
            affine.for %arg9 = 0 to 32 {
              affine.for %arg10 = 0 to 2 {
                affine.for %arg11 = 0 to 4 {
                  %0 = affine.load %arg0[%arg9 + %arg8 * 64 + %arg7 * 128 + 32, %arg11 + %arg10 * 4 + %arg6 * 8] : memref<256x16xi512>
                  %1 = arith.cmpi slt, %arg11, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                  } else {
                    affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
        } {Array_Partition, reduction = 0 : i64}
      }
    }
    return
  }
  func.func @load1_top(%arg0: memref<256x16xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load1(%arg0, %arg1, %arg2, %arg3, %arg4) {template = 0 : index} : (memref<256x16xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @gemm_pl(%arg0: memref<256x16xi512>, %arg1: memref<256x16xi512>, %arg2: memref<256x16xi512>, %arg3: memref<1xi128, "plio">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32]} {
    %c0_i128 = arith.constant 0 : i128
    %alloc = memref.alloc() : memref<1xi128, "stream">
    %alloc_0 = memref.alloc() : memref<1xi128, "stream">
    %alloc_1 = memref.alloc() : memref<1xi128, "stream">
    %alloc_2 = memref.alloc() : memref<1xi128, "stream">
    %alloc_3 = memref.alloc() : memref<1xi128, "stream">
    %alloc_4 = memref.alloc() : memref<1xi128, "stream">
    %alloc_5 = memref.alloc() : memref<1xi128, "stream">
    %alloc_6 = memref.alloc() : memref<1xi128, "stream">
    %alloc_7 = memref.alloc() : memref<1xi128, "stream">
    %alloc_8 = memref.alloc() : memref<1xi128, "stream">
    %alloc_9 = memref.alloc() : memref<1xi128, "stream">
    %alloc_10 = memref.alloc() : memref<1xi128, "stream">
    %alloc_11 = memref.alloc() {buffer_type = "uram_t2p"} : memref<64x16xi128, 1>
    affine.for %arg15 = 0 to 64 {
      affine.for %arg16 = 0 to 16 {
        affine.store %c0_i128, %alloc_11[%arg15, %arg16] : memref<64x16xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    %alloc_12 = memref.alloc() {buffer_type = "uram_t2p"} : memref<64x16xi128, 1>
    affine.for %arg15 = 0 to 64 {
      affine.for %arg16 = 0 to 16 {
        affine.store %c0_i128, %alloc_12[%arg15, %arg16] : memref<64x16xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    %alloc_13 = memref.alloc() {buffer_type = "uram_t2p"} : memref<64x16xi128, 1>
    affine.for %arg15 = 0 to 64 {
      affine.for %arg16 = 0 to 16 {
        affine.store %c0_i128, %alloc_13[%arg15, %arg16] : memref<64x16xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    %alloc_14 = memref.alloc() {buffer_type = "uram_t2p"} : memref<64x16xi128, 1>
    affine.for %arg15 = 0 to 64 {
      affine.for %arg16 = 0 to 16 {
        affine.store %c0_i128, %alloc_14[%arg15, %arg16] : memref<64x16xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    %alloc_15 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_16 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_17 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_18 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_19 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_20 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_21 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_22 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_23 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_24 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_25 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_26 = memref.alloc() : memref<1xi512, "stream2">
    call @send3_top(%arg4, %alloc_7, %arg3, %alloc_5, %arg8, %alloc_9, %arg7, %alloc_6) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive2_top(%arg9, %alloc_1, %arg14, %alloc, %arg13, %alloc_2, %arg6, %alloc_0) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send6_top(%arg5, %alloc_4, %arg10, %alloc_10, %arg12, %alloc_3, %arg11, %alloc_8) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @store0_0_top(%alloc_2, %alloc_15, %alloc_1, %alloc_16, %alloc_0, %alloc_17, %alloc, %alloc_18) : (memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_top(%arg2, %alloc_18, %alloc_17, %alloc_15, %alloc_16) : (memref<256x16xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load0_top(%arg0, %alloc_22, %alloc_21, %alloc_19, %alloc_20) : (memref<256x16xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load0_3_top(%alloc_22, %alloc_10, %alloc_21, %alloc_8, %alloc_20, %alloc_4, %alloc_19, %alloc_3, %alloc_26, %alloc_9, %alloc_25, %alloc_7, %alloc_24, %alloc_6, %alloc_23, %alloc_5) : (memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_top(%arg1, %alloc_26, %alloc_24, %alloc_25, %alloc_23) : (memref<256x16xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @gemm(%arg0: memref<256x16xi512>, %arg1: memref<256x16xi512>, %arg2: memref<256x16xi512>, %arg3: memref<1xi128, "plio">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32], plio = true} {
    %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%0, %arg13) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%1, %arg9) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %2 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg12, %2) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %3 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg5, %3) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%4, %arg6) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %5 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg3, %5) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %6 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg7, %6) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %7 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%7, %arg14) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %8 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg4, %8) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg11, %9) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg8, %10) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg10, %11) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    adf.cell.launch @adf_cell0 {
      func.call @adf_cell0(%11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
      adf.cell.launch.end
    }
    adf.pl.launch @gemm_pl {
      func.call @gemm_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14) {adf.pl} : (memref<256x16xi512>, memref<256x16xi512>, memref<256x16xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
      adf.pl.launch.wait
    }
    return
  }
  func.func @top(%arg0: memref<256x16xi512>, %arg1: memref<256x16xi512>, %arg2: memref<256x16xi512>, %arg3: memref<1xi128, "plio">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">) attributes {outArgs = [2 : i32], top_func = "plio"} {
    call @gemm_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14) : (memref<256x16xi512>, memref<256x16xi512>, memref<256x16xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
    return
  }
  func.func private @gemm_host(memref<256x256xf32>, memref<256x256xf32>, memref<256x256xf32>) attributes {origin_func = "gemm"}
  func.func @top_host(%arg0: memref<256x256xf32>, %arg1: memref<256x256xf32>, %arg2: memref<256x256xf32>) attributes {origin_func = "top", outArgs = [2 : i32], top_host} {
    call @gemm_host(%arg0, %arg1, %arg2) {origin_func = "gemm"} : (memref<256x256xf32>, memref<256x256xf32>, memref<256x256xf32>) -> ()
    return
  }
}

