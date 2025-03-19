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
    %alloc = memref.alloc() : memref<32x32xf32, 2>
    affine.for %arg3 = 0 to 32 {
      affine.for %arg4 = 0 to 32 {
        %0 = affine.load %arg2[%arg3, %arg4] : memref<32x32xf32, 2>
        affine.store %0, %alloc[%arg3, %arg4] : memref<32x32xf32, 2>
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
  func.func @adf_cell0(%arg0: !adf.plio<In, 128>, %arg1: !adf.plio<In, 128>, %arg2: !adf.plio<In, 128>, %arg3: !adf.plio<In, 128>, %arg4: !adf.plio<In, 128>, %arg5: !adf.plio<In, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<Out, 128>, %arg9: !adf.plio<In, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<In, 128>, %arg13: !adf.plio<Out, 128>, %arg14: !adf.plio<In, 128>, %arg15: !adf.plio<In, 128>, %arg16: !adf.plio<In, 128>, %arg17: !adf.plio<In, 128>, %arg18: !adf.plio<Out, 128>, %arg19: !adf.plio<In, 128>, %arg20: !adf.plio<In, 128>, %arg21: !adf.plio<In, 128>, %arg22: !adf.plio<In, 128>, %arg23: !adf.plio<Out, 128>, %arg24: !adf.plio<In, 128>, %arg25: !adf.plio<In, 128>, %arg26: !adf.plio<In, 128>, %arg27: !adf.plio<In, 128>, %arg28: !adf.plio<Out, 128>, %arg29: !adf.plio<In, 128>, %arg30: !adf.plio<In, 128>, %arg31: !adf.plio<In, 128>, %arg32: !adf.plio<In, 128>, %arg33: !adf.plio<Out, 128>, %arg34: !adf.plio<In, 128>, %arg35: !adf.plio<In, 128>, %arg36: !adf.plio<In, 128>, %arg37: !adf.plio<In, 128>, %arg38: !adf.plio<Out, 128>, %arg39: !adf.plio<In, 128>, %arg40: !adf.plio<In, 128>, %arg41: !adf.plio<In, 128>, %arg42: !adf.plio<In, 128>, %arg43: !adf.plio<Out, 128>, %arg44: !adf.plio<In, 128>, %arg45: !adf.plio<In, 128>, %arg46: !adf.plio<In, 128>, %arg47: !adf.plio<In, 128>, %arg48: !adf.plio<Out, 128>, %arg49: !adf.plio<Out, 128>, %arg50: !adf.plio<Out, 128>, %arg51: !adf.plio<Out, 128>, %arg52: !adf.plio<Out, 128>, %arg53: !adf.plio<Out, 128>, %arg54: !adf.plio<Out, 128>, %arg55: !adf.plio<Out, 128>, %arg56: !adf.plio<In, 128>, %arg57: !adf.plio<In, 128>, %arg58: !adf.plio<In, 128>, %arg59: !adf.plio<In, 128>, %arg60: !adf.plio<Out, 128>, %arg61: !adf.plio<Out, 128>, %arg62: !adf.plio<Out, 128>, %arg63: !adf.plio<Out, 128>, %arg64: !adf.plio<Out, 128>, %arg65: !adf.plio<Out, 128>, %arg66: !adf.plio<Out, 128>, %arg67: !adf.plio<Out, 128>, %arg68: !adf.plio<In, 128>, %arg69: !adf.plio<In, 128>, %arg70: !adf.plio<In, 128>, %arg71: !adf.plio<In, 128>, %arg72: !adf.plio<Out, 128>, %arg73: !adf.plio<Out, 128>, %arg74: !adf.plio<Out, 128>, %arg75: !adf.plio<Out, 128>, %arg76: !adf.plio<Out, 128>, %arg77: !adf.plio<Out, 128>, %arg78: !adf.plio<Out, 128>, %arg79: !adf.plio<Out, 128>, %arg80: !adf.plio<In, 128>, %arg81: !adf.plio<In, 128>, %arg82: !adf.plio<In, 128>, %arg83: !adf.plio<In, 128>, %arg84: !adf.plio<Out, 128>, %arg85: !adf.plio<Out, 128>, %arg86: !adf.plio<Out, 128>, %arg87: !adf.plio<Out, 128>, %arg88: !adf.plio<Out, 128>, %arg89: !adf.plio<Out, 128>, %arg90: !adf.plio<Out, 128>, %arg91: !adf.plio<Out, 128>, %arg92: !adf.plio<In, 128>, %arg93: !adf.plio<In, 128>, %arg94: !adf.plio<In, 128>, %arg95: !adf.plio<In, 128>, %arg96: !adf.plio<Out, 128>, %arg97: !adf.plio<Out, 128>, %arg98: !adf.plio<Out, 128>, %arg99: !adf.plio<Out, 128>, %arg100: !adf.plio<Out, 128>, %arg101: !adf.plio<Out, 128>, %arg102: !adf.plio<Out, 128>, %arg103: !adf.plio<Out, 128>, %arg104: !adf.plio<In, 128>, %arg105: !adf.plio<In, 128>, %arg106: !adf.plio<In, 128>, %arg107: !adf.plio<In, 128>, %arg108: !adf.plio<Out, 128>, %arg109: !adf.plio<Out, 128>, %arg110: !adf.plio<Out, 128>, %arg111: !adf.plio<Out, 128>, %arg112: !adf.plio<Out, 128>, %arg113: !adf.plio<Out, 128>, %arg114: !adf.plio<Out, 128>, %arg115: !adf.plio<Out, 128>, %arg116: !adf.plio<In, 128>, %arg117: !adf.plio<In, 128>, %arg118: !adf.plio<In, 128>, %arg119: !adf.plio<In, 128>, %arg120: !adf.plio<Out, 128>, %arg121: !adf.plio<Out, 128>, %arg122: !adf.plio<Out, 128>, %arg123: !adf.plio<Out, 128>, %arg124: !adf.plio<Out, 128>, %arg125: !adf.plio<Out, 128>, %arg126: !adf.plio<Out, 128>, %arg127: !adf.plio<Out, 128>, %arg128: !adf.plio<In, 128>, %arg129: !adf.plio<In, 128>, %arg130: !adf.plio<In, 128>, %arg131: !adf.plio<In, 128>, %arg132: !adf.plio<Out, 128>, %arg133: !adf.plio<Out, 128>, %arg134: !adf.plio<Out, 128>, %arg135: !adf.plio<Out, 128>, %arg136: !adf.plio<Out, 128>, %arg137: !adf.plio<Out, 128>, %arg138: !adf.plio<Out, 128>, %arg139: !adf.plio<Out, 128>, %arg140: !adf.plio<In, 128>, %arg141: !adf.plio<In, 128>, %arg142: !adf.plio<In, 128>, %arg143: !adf.plio<In, 128>, %arg144: !adf.plio<Out, 128>, %arg145: !adf.plio<Out, 128>, %arg146: !adf.plio<Out, 128>, %arg147: !adf.plio<Out, 128>, %arg148: !adf.plio<Out, 128>, %arg149: !adf.plio<Out, 128>, %arg150: !adf.plio<Out, 128>, %arg151: !adf.plio<Out, 128>, %arg152: !adf.plio<In, 128>, %arg153: !adf.plio<In, 128>, %arg154: !adf.plio<In, 128>, %arg155: !adf.plio<In, 128>, %arg156: !adf.plio<Out, 128>, %arg157: !adf.plio<Out, 128>, %arg158: !adf.plio<Out, 128>, %arg159: !adf.plio<Out, 128>, %arg160: !adf.plio<Out, 128>, %arg161: !adf.plio<Out, 128>, %arg162: !adf.plio<Out, 128>, %arg163: !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [4 : index, 8 : index, 11 : index]} {
    %c47 = arith.constant 47 : index
    %c46 = arith.constant 46 : index
    %c45 = arith.constant 45 : index
    %c44 = arith.constant 44 : index
    %c43 = arith.constant 43 : index
    %c42 = arith.constant 42 : index
    %c41 = arith.constant 41 : index
    %c40 = arith.constant 40 : index
    %c39 = arith.constant 39 : index
    %c38 = arith.constant 38 : index
    %c37 = arith.constant 37 : index
    %c36 = arith.constant 36 : index
    %c35 = arith.constant 35 : index
    %c34 = arith.constant 34 : index
    %c33 = arith.constant 33 : index
    %c32 = arith.constant 32 : index
    %c31 = arith.constant 31 : index
    %c30 = arith.constant 30 : index
    %c29 = arith.constant 29 : index
    %c28 = arith.constant 28 : index
    %c27 = arith.constant 27 : index
    %c26 = arith.constant 26 : index
    %c25 = arith.constant 25 : index
    %c24 = arith.constant 24 : index
    %c23 = arith.constant 23 : index
    %c22 = arith.constant 22 : index
    %c21 = arith.constant 21 : index
    %c20 = arith.constant 20 : index
    %c19 = arith.constant 19 : index
    %c18 = arith.constant 18 : index
    %c17 = arith.constant 17 : index
    %c16 = arith.constant 16 : index
    %c15 = arith.constant 15 : index
    %c14 = arith.constant 14 : index
    %c13 = arith.constant 13 : index
    %c12 = arith.constant 12 : index
    %c11 = arith.constant 11 : index
    %c10 = arith.constant 10 : index
    %c9 = arith.constant 9 : index
    %c8 = arith.constant 8 : index
    %c7 = arith.constant 7 : index
    %c12288 = arith.constant 12288 : index
    %c4096 = arith.constant 4096 : index
    %c6 = arith.constant 6 : index
    %c5 = arith.constant 5 : index
    %c24576 = arith.constant 24576 : index
    %c16384 = arith.constant 16384 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c8192 = arith.constant 8192 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c3 = arith.constant 3 : index
    adf.config.plio(%arg8, 250) {"col, chl" = [6 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg13, 250) {"col, chl" = [6 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg18, 250) {"col, chl" = [6 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg23, 250) {"col, chl" = [7 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg28, 250) {"col, chl" = [7 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg33, 250) {"col, chl" = [7 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg38, 250) {"col, chl" = [8 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg0, 250) {"col, chl" = [6 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg2, 250) {"col, chl" = [6 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg4, 250) {"col, chl" = [6 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg6, 250) {"col, chl" = [7 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg43, 250) {"col, chl" = [8 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg48, 250) {"col, chl" = [10 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg49, 250) {"col, chl" = [10 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg50, 250) {"col, chl" = [10 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg51, 250) {"col, chl" = [9 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg52, 250) {"col, chl" = [9 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg53, 250) {"col, chl" = [9 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg54, 250) {"col, chl" = [11 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg44, 250) {"col, chl" = [7 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg45, 250) {"col, chl" = [8 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg46, 250) {"col, chl" = [9 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg47, 250) {"col, chl" = [10 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg55, 250) {"col, chl" = [11 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg60, 250) {"col, chl" = [14 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg61, 250) {"col, chl" = [14 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg62, 250) {"col, chl" = [14 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg63, 250) {"col, chl" = [13 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg64, 250) {"col, chl" = [13 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg65, 250) {"col, chl" = [13 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg66, 250) {"col, chl" = [15 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg56, 250) {"col, chl" = [11 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg57, 250) {"col, chl" = [12 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg58, 250) {"col, chl" = [13 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg59, 250) {"col, chl" = [14 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg67, 250) {"col, chl" = [15 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg72, 250) {"col, chl" = [18 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg73, 250) {"col, chl" = [18 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg74, 250) {"col, chl" = [18 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg75, 250) {"col, chl" = [17 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg76, 250) {"col, chl" = [17 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg77, 250) {"col, chl" = [17 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg78, 250) {"col, chl" = [19 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg68, 250) {"col, chl" = [15 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg69, 250) {"col, chl" = [16 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg70, 250) {"col, chl" = [17 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg71, 250) {"col, chl" = [18 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg79, 250) {"col, chl" = [19 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg84, 250) {"col, chl" = [22 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg85, 250) {"col, chl" = [22 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg86, 250) {"col, chl" = [22 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg87, 250) {"col, chl" = [21 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg88, 250) {"col, chl" = [21 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg89, 250) {"col, chl" = [21 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg90, 250) {"col, chl" = [23 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg80, 250) {"col, chl" = [19 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg81, 250) {"col, chl" = [20 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg82, 250) {"col, chl" = [21 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg83, 250) {"col, chl" = [22 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg91, 250) {"col, chl" = [23 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg96, 250) {"col, chl" = [26 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg97, 250) {"col, chl" = [26 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg98, 250) {"col, chl" = [26 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg99, 250) {"col, chl" = [25 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg100, 250) {"col, chl" = [25 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg101, 250) {"col, chl" = [25 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg102, 250) {"col, chl" = [27 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg92, 250) {"col, chl" = [23 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg93, 250) {"col, chl" = [24 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg94, 250) {"col, chl" = [25 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg95, 250) {"col, chl" = [26 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg103, 250) {"col, chl" = [27 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg108, 250) {"col, chl" = [30 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg109, 250) {"col, chl" = [30 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg110, 250) {"col, chl" = [30 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg111, 250) {"col, chl" = [29 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg112, 250) {"col, chl" = [29 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg113, 250) {"col, chl" = [29 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg114, 250) {"col, chl" = [31 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg104, 250) {"col, chl" = [27 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg105, 250) {"col, chl" = [28 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg106, 250) {"col, chl" = [29 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg107, 250) {"col, chl" = [30 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg115, 250) {"col, chl" = [31 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg120, 250) {"col, chl" = [34 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg121, 250) {"col, chl" = [34 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg122, 250) {"col, chl" = [34 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg123, 250) {"col, chl" = [33 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg124, 250) {"col, chl" = [33 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg125, 250) {"col, chl" = [33 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg126, 250) {"col, chl" = [35 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg116, 250) {"col, chl" = [31 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg117, 250) {"col, chl" = [32 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg118, 250) {"col, chl" = [33 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg119, 250) {"col, chl" = [34 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg127, 250) {"col, chl" = [35 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg132, 250) {"col, chl" = [38 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg133, 250) {"col, chl" = [38 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg134, 250) {"col, chl" = [38 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg135, 250) {"col, chl" = [37 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg136, 250) {"col, chl" = [37 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg137, 250) {"col, chl" = [37 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg138, 250) {"col, chl" = [39 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg128, 250) {"col, chl" = [35 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg129, 250) {"col, chl" = [36 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg130, 250) {"col, chl" = [37 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg131, 250) {"col, chl" = [38 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg139, 250) {"col, chl" = [39 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg144, 250) {"col, chl" = [42 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg145, 250) {"col, chl" = [42 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg146, 250) {"col, chl" = [42 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg147, 250) {"col, chl" = [41 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg148, 250) {"col, chl" = [41 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg149, 250) {"col, chl" = [41 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg150, 250) {"col, chl" = [43 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg140, 250) {"col, chl" = [39 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg141, 250) {"col, chl" = [40 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg142, 250) {"col, chl" = [41 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg143, 250) {"col, chl" = [42 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg151, 250) {"col, chl" = [43 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg1, 250) {"col, chl" = [23 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg3, 250) {"col, chl" = [24 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg5, 250) {"col, chl" = [25 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg7, 250) {"col, chl" = [26 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg156, 250) {"col, chl" = [44 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg9, 250) {"col, chl" = [23 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg10, 250) {"col, chl" = [24 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg11, 250) {"col, chl" = [25 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg12, 250) {"col, chl" = [26 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg157, 250) {"col, chl" = [44 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg14, 250) {"col, chl" = [22 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg15, 250) {"col, chl" = [22 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg16, 250) {"col, chl" = [27 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg17, 250) {"col, chl" = [27 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg158, 250) {"col, chl" = [44 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg19, 250) {"col, chl" = [21 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg20, 250) {"col, chl" = [21 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg21, 250) {"col, chl" = [28 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg22, 250) {"col, chl" = [28 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg159, 250) {"col, chl" = [43 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg24, 250) {"col, chl" = [20 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg25, 250) {"col, chl" = [20 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg26, 250) {"col, chl" = [29 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg27, 250) {"col, chl" = [29 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg160, 250) {"col, chl" = [40 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg29, 250) {"col, chl" = [19 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg30, 250) {"col, chl" = [19 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg31, 250) {"col, chl" = [30 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg32, 250) {"col, chl" = [30 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg161, 250) {"col, chl" = [40 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg34, 250) {"col, chl" = [18 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg35, 250) {"col, chl" = [18 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg36, 250) {"col, chl" = [31 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg37, 250) {"col, chl" = [31 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg162, 250) {"col, chl" = [40 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg152, 250) {"col, chl" = [43 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg39, 250) {"col, chl" = [17 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg153, 250) {"col, chl" = [44 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg40, 250) {"col, chl" = [17 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg154, 250) {"col, chl" = [44 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg41, 250) {"col, chl" = [32 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg155, 250) {"col, chl" = [44 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg42, 250) {"col, chl" = [32 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg163, 250) {"col, chl" = [39 : index, 0 : index]} : <Out, 128>
    %0 = adf.buffer.create @L1_L1_A() : memref<32x32xf32, 2>
    %1 = adf.buffer.create @L1_L1_B() : memref<32x32xf32, 2>
    %2 = adf.buffer.create @L1_L1_A_1() : memref<32x32xf32, 2>
    %3 = adf.buffer.create @L1_L1_B_1() : memref<32x32xf32, 2>
    %4 = adf.buffer.create @L1_L1_C_1() : memref<32x32xf32, 2>
    %5 = adf.buffer.create @L1_L1_A_2() : memref<32x32xf32, 2>
    %6 = adf.buffer.create @L1_L1_B_2() : memref<32x32xf32, 2>
    %7 = adf.buffer.create @L1_L1_C_2() : memref<32x32xf32, 2>
    %8 = adf.buffer.create @L1_L1_A_3() : memref<32x32xf32, 2>
    %9 = adf.buffer.create @L1_L1_B_3() : memref<32x32xf32, 2>
    %10 = adf.buffer.create @L1_L1_C_3() : memref<32x32xf32, 2>
    %11 = adf.buffer.create @L1_L1_A_4() : memref<32x32xf32, 2>
    %12 = adf.buffer.create @L1_L1_B_4() : memref<32x32xf32, 2>
    %13 = adf.buffer.create @L1_L1_A_5() : memref<32x32xf32, 2>
    %14 = adf.buffer.create @L1_L1_B_5() : memref<32x32xf32, 2>
    %15 = adf.buffer.create @L1_L1_C_5() : memref<32x32xf32, 2>
    %16 = adf.buffer.create @L1_L1_A_6() : memref<32x32xf32, 2>
    %17 = adf.buffer.create @L1_L1_B_6() : memref<32x32xf32, 2>
    %18 = adf.buffer.create @L1_L1_C_6() : memref<32x32xf32, 2>
    %19 = adf.buffer.create @L1_L1_A_7() : memref<32x32xf32, 2>
    %20 = adf.buffer.create @L1_L1_B_7() : memref<32x32xf32, 2>
    %21 = adf.buffer.create @L1_L1_C_7() : memref<32x32xf32, 2>
    %22 = adf.buffer.create @L1_L1_A_8() : memref<32x32xf32, 2>
    %23 = adf.buffer.create @L1_L1_B_8() : memref<32x32xf32, 2>
    %24 = adf.buffer.create @L1_L1_A_9() : memref<32x32xf32, 2>
    %25 = adf.buffer.create @L1_L1_B_9() : memref<32x32xf32, 2>
    %26 = adf.buffer.create @L1_L1_C_9() : memref<32x32xf32, 2>
    %27 = adf.buffer.create @L1_L1_A_10() : memref<32x32xf32, 2>
    %28 = adf.buffer.create @L1_L1_B_10() : memref<32x32xf32, 2>
    %29 = adf.buffer.create @L1_L1_C_10() : memref<32x32xf32, 2>
    %30 = adf.buffer.create @L1_L1_A_11() : memref<32x32xf32, 2>
    %31 = adf.buffer.create @L1_L1_B_11() : memref<32x32xf32, 2>
    %32 = adf.buffer.create @L1_L1_C_11() : memref<32x32xf32, 2>
    %33 = adf.buffer.create @L1_L1_A_12() : memref<32x32xf32, 2>
    %34 = adf.buffer.create @L1_L1_B_12() : memref<32x32xf32, 2>
    %35 = adf.buffer.create @L1_L1_A_13() : memref<32x32xf32, 2>
    %36 = adf.buffer.create @L1_L1_B_13() : memref<32x32xf32, 2>
    %37 = adf.buffer.create @L1_L1_C_13() : memref<32x32xf32, 2>
    %38 = adf.buffer.create @L1_L1_A_14() : memref<32x32xf32, 2>
    %39 = adf.buffer.create @L1_L1_B_14() : memref<32x32xf32, 2>
    %40 = adf.buffer.create @L1_L1_C_14() : memref<32x32xf32, 2>
    %41 = adf.buffer.create @L1_L1_A_15() : memref<32x32xf32, 2>
    %42 = adf.buffer.create @L1_L1_B_15() : memref<32x32xf32, 2>
    %43 = adf.buffer.create @L1_L1_C_15() : memref<32x32xf32, 2>
    %44 = adf.buffer.create @L1_L1_A_16() : memref<32x32xf32, 2>
    %45 = adf.buffer.create @L1_L1_B_16() : memref<32x32xf32, 2>
    %46 = adf.buffer.create @L1_L1_A_17() : memref<32x32xf32, 2>
    %47 = adf.buffer.create @L1_L1_B_17() : memref<32x32xf32, 2>
    %48 = adf.buffer.create @L1_L1_C_17() : memref<32x32xf32, 2>
    %49 = adf.buffer.create @L1_L1_A_18() : memref<32x32xf32, 2>
    %50 = adf.buffer.create @L1_L1_B_18() : memref<32x32xf32, 2>
    %51 = adf.buffer.create @L1_L1_C_18() : memref<32x32xf32, 2>
    %52 = adf.buffer.create @L1_L1_A_19() : memref<32x32xf32, 2>
    %53 = adf.buffer.create @L1_L1_B_19() : memref<32x32xf32, 2>
    %54 = adf.buffer.create @L1_L1_C_19() : memref<32x32xf32, 2>
    %55 = adf.buffer.create @L1_L1_A_20() : memref<32x32xf32, 2>
    %56 = adf.buffer.create @L1_L1_B_20() : memref<32x32xf32, 2>
    %57 = adf.buffer.create @L1_L1_A_21() : memref<32x32xf32, 2>
    %58 = adf.buffer.create @L1_L1_B_21() : memref<32x32xf32, 2>
    %59 = adf.buffer.create @L1_L1_C_21() : memref<32x32xf32, 2>
    %60 = adf.buffer.create @L1_L1_A_22() : memref<32x32xf32, 2>
    %61 = adf.buffer.create @L1_L1_B_22() : memref<32x32xf32, 2>
    %62 = adf.buffer.create @L1_L1_C_22() : memref<32x32xf32, 2>
    %63 = adf.buffer.create @L1_L1_A_23() : memref<32x32xf32, 2>
    %64 = adf.buffer.create @L1_L1_B_23() : memref<32x32xf32, 2>
    %65 = adf.buffer.create @L1_L1_C_23() : memref<32x32xf32, 2>
    %66 = adf.buffer.create @L1_L1_A_24() : memref<32x32xf32, 2>
    %67 = adf.buffer.create @L1_L1_B_24() : memref<32x32xf32, 2>
    %68 = adf.buffer.create @L1_L1_A_25() : memref<32x32xf32, 2>
    %69 = adf.buffer.create @L1_L1_B_25() : memref<32x32xf32, 2>
    %70 = adf.buffer.create @L1_L1_C_25() : memref<32x32xf32, 2>
    %71 = adf.buffer.create @L1_L1_A_26() : memref<32x32xf32, 2>
    %72 = adf.buffer.create @L1_L1_B_26() : memref<32x32xf32, 2>
    %73 = adf.buffer.create @L1_L1_C_26() : memref<32x32xf32, 2>
    %74 = adf.buffer.create @L1_L1_A_27() : memref<32x32xf32, 2>
    %75 = adf.buffer.create @L1_L1_B_27() : memref<32x32xf32, 2>
    %76 = adf.buffer.create @L1_L1_C_27() : memref<32x32xf32, 2>
    %77 = adf.buffer.create @L1_L1_A_28() : memref<32x32xf32, 2>
    %78 = adf.buffer.create @L1_L1_B_28() : memref<32x32xf32, 2>
    %79 = adf.buffer.create @L1_L1_A_29() : memref<32x32xf32, 2>
    %80 = adf.buffer.create @L1_L1_B_29() : memref<32x32xf32, 2>
    %81 = adf.buffer.create @L1_L1_C_29() : memref<32x32xf32, 2>
    %82 = adf.buffer.create @L1_L1_A_30() : memref<32x32xf32, 2>
    %83 = adf.buffer.create @L1_L1_B_30() : memref<32x32xf32, 2>
    %84 = adf.buffer.create @L1_L1_C_30() : memref<32x32xf32, 2>
    %85 = adf.buffer.create @L1_L1_A_31() : memref<32x32xf32, 2>
    %86 = adf.buffer.create @L1_L1_B_31() : memref<32x32xf32, 2>
    %87 = adf.buffer.create @L1_L1_C_31() : memref<32x32xf32, 2>
    %88 = adf.buffer.create @L1_L1_A_32() : memref<32x32xf32, 2>
    %89 = adf.buffer.create @L1_L1_B_32() : memref<32x32xf32, 2>
    %90 = adf.buffer.create @L1_L1_A_33() : memref<32x32xf32, 2>
    %91 = adf.buffer.create @L1_L1_B_33() : memref<32x32xf32, 2>
    %92 = adf.buffer.create @L1_L1_C_33() : memref<32x32xf32, 2>
    %93 = adf.buffer.create @L1_L1_A_34() : memref<32x32xf32, 2>
    %94 = adf.buffer.create @L1_L1_B_34() : memref<32x32xf32, 2>
    %95 = adf.buffer.create @L1_L1_C_34() : memref<32x32xf32, 2>
    %96 = adf.buffer.create @L1_L1_A_35() : memref<32x32xf32, 2>
    %97 = adf.buffer.create @L1_L1_B_35() : memref<32x32xf32, 2>
    %98 = adf.buffer.create @L1_L1_C_35() : memref<32x32xf32, 2>
    %99 = adf.buffer.create @L1_L1_A_36() : memref<32x32xf32, 2>
    %100 = adf.buffer.create @L1_L1_B_36() : memref<32x32xf32, 2>
    %101 = adf.buffer.create @L1_L1_A_37() : memref<32x32xf32, 2>
    %102 = adf.buffer.create @L1_L1_B_37() : memref<32x32xf32, 2>
    %103 = adf.buffer.create @L1_L1_C_37() : memref<32x32xf32, 2>
    %104 = adf.buffer.create @L1_L1_A_38() : memref<32x32xf32, 2>
    %105 = adf.buffer.create @L1_L1_B_38() : memref<32x32xf32, 2>
    %106 = adf.buffer.create @L1_L1_C_38() : memref<32x32xf32, 2>
    %107 = adf.buffer.create @L1_L1_A_39() : memref<32x32xf32, 2>
    %108 = adf.buffer.create @L1_L1_B_39() : memref<32x32xf32, 2>
    %109 = adf.buffer.create @L1_L1_C_39() : memref<32x32xf32, 2>
    %110 = adf.buffer.create @L1_L1_A_40() : memref<32x32xf32, 2>
    %111 = adf.buffer.create @L1_L1_B_40() : memref<32x32xf32, 2>
    %112 = adf.buffer.create @L1_L1_A_41() : memref<32x32xf32, 2>
    %113 = adf.buffer.create @L1_L1_B_41() : memref<32x32xf32, 2>
    %114 = adf.buffer.create @L1_L1_C_41() : memref<32x32xf32, 2>
    %115 = adf.buffer.create @L1_L1_A_42() : memref<32x32xf32, 2>
    %116 = adf.buffer.create @L1_L1_B_42() : memref<32x32xf32, 2>
    %117 = adf.buffer.create @L1_L1_C_42() : memref<32x32xf32, 2>
    %118 = adf.buffer.create @L1_L1_A_43() : memref<32x32xf32, 2>
    %119 = adf.buffer.create @L1_L1_B_43() : memref<32x32xf32, 2>
    %120 = adf.buffer.create @L1_L1_C_43() : memref<32x32xf32, 2>
    %121 = adf.buffer.create @L1_L1_A_44() : memref<32x32xf32, 2>
    %122 = adf.buffer.create @L1_L1_B_44() : memref<32x32xf32, 2>
    %123 = adf.buffer.create @L1_L1_A_45() : memref<32x32xf32, 2>
    %124 = adf.buffer.create @L1_L1_B_45() : memref<32x32xf32, 2>
    %125 = adf.buffer.create @L1_L1_C_45() : memref<32x32xf32, 2>
    %126 = adf.buffer.create @L1_L1_A_46() : memref<32x32xf32, 2>
    %127 = adf.buffer.create @L1_L1_B_46() : memref<32x32xf32, 2>
    %128 = adf.buffer.create @L1_L1_C_46() : memref<32x32xf32, 2>
    %129 = adf.buffer.create @L1_L1_A_47() : memref<32x32xf32, 2>
    %130 = adf.buffer.create @L1_L1_B_47() : memref<32x32xf32, 2>
    %131 = adf.buffer.create @L1_L1_C_47() : memref<32x32xf32, 2>
    %132 = adf.buffer.create @L1_L1_A_48() : memref<32x32xf32, 2>
    %133 = adf.buffer.create @L1_L1_B_48() : memref<32x32xf32, 2>
    %134 = adf.buffer.create @L1_L1_A_49() : memref<32x32xf32, 2>
    %135 = adf.buffer.create @L1_L1_B_49() : memref<32x32xf32, 2>
    %136 = adf.buffer.create @L1_L1_C_49() : memref<32x32xf32, 2>
    %137 = adf.buffer.create @L1_L1_A_50() : memref<32x32xf32, 2>
    %138 = adf.buffer.create @L1_L1_B_50() : memref<32x32xf32, 2>
    %139 = adf.buffer.create @L1_L1_C_50() : memref<32x32xf32, 2>
    %140 = adf.buffer.create @L1_L1_A_51() : memref<32x32xf32, 2>
    %141 = adf.buffer.create @L1_L1_B_51() : memref<32x32xf32, 2>
    %142 = adf.buffer.create @L1_L1_C_51() : memref<32x32xf32, 2>
    %143 = adf.buffer.create @L1_L1_A_52() : memref<32x32xf32, 2>
    %144 = adf.buffer.create @L1_L1_B_52() : memref<32x32xf32, 2>
    %145 = adf.buffer.create @L1_L1_A_53() : memref<32x32xf32, 2>
    %146 = adf.buffer.create @L1_L1_B_53() : memref<32x32xf32, 2>
    %147 = adf.buffer.create @L1_L1_C_53() : memref<32x32xf32, 2>
    %148 = adf.buffer.create @L1_L1_A_54() : memref<32x32xf32, 2>
    %149 = adf.buffer.create @L1_L1_B_54() : memref<32x32xf32, 2>
    %150 = adf.buffer.create @L1_L1_C_54() : memref<32x32xf32, 2>
    %151 = adf.buffer.create @L1_L1_A_55() : memref<32x32xf32, 2>
    %152 = adf.buffer.create @L1_L1_B_55() : memref<32x32xf32, 2>
    %153 = adf.buffer.create @L1_L1_C_55() : memref<32x32xf32, 2>
    %154 = adf.buffer.create @L1_L1_A_56() : memref<32x32xf32, 2>
    %155 = adf.buffer.create @L1_L1_B_56() : memref<32x32xf32, 2>
    %156 = adf.buffer.create @L1_L1_A_57() : memref<32x32xf32, 2>
    %157 = adf.buffer.create @L1_L1_B_57() : memref<32x32xf32, 2>
    %158 = adf.buffer.create @L1_L1_C_57() : memref<32x32xf32, 2>
    %159 = adf.buffer.create @L1_L1_A_58() : memref<32x32xf32, 2>
    %160 = adf.buffer.create @L1_L1_B_58() : memref<32x32xf32, 2>
    %161 = adf.buffer.create @L1_L1_C_58() : memref<32x32xf32, 2>
    %162 = adf.buffer.create @L1_L1_A_59() : memref<32x32xf32, 2>
    %163 = adf.buffer.create @L1_L1_B_59() : memref<32x32xf32, 2>
    %164 = adf.buffer.create @L1_L1_C_59() : memref<32x32xf32, 2>
    %165 = adf.buffer.create @L1_L1_A_60() : memref<32x32xf32, 2>
    %166 = adf.buffer.create @L1_L1_B_60() : memref<32x32xf32, 2>
    %167 = adf.buffer.create @L1_L1_A_61() : memref<32x32xf32, 2>
    %168 = adf.buffer.create @L1_L1_B_61() : memref<32x32xf32, 2>
    %169 = adf.buffer.create @L1_L1_C_61() : memref<32x32xf32, 2>
    %170 = adf.buffer.create @L1_L1_A_62() : memref<32x32xf32, 2>
    %171 = adf.buffer.create @L1_L1_B_62() : memref<32x32xf32, 2>
    %172 = adf.buffer.create @L1_L1_C_62() : memref<32x32xf32, 2>
    %173 = adf.buffer.create @L1_L1_A_63() : memref<32x32xf32, 2>
    %174 = adf.buffer.create @L1_L1_B_63() : memref<32x32xf32, 2>
    %175 = adf.buffer.create @L1_L1_C_63() : memref<32x32xf32, 2>
    %176 = adf.buffer.create @L1_L1_A_64() : memref<32x32xf32, 2>
    %177 = adf.buffer.create @L1_L1_B_64() : memref<32x32xf32, 2>
    %178 = adf.buffer.create @L1_L1_A_65() : memref<32x32xf32, 2>
    %179 = adf.buffer.create @L1_L1_B_65() : memref<32x32xf32, 2>
    %180 = adf.buffer.create @L1_L1_C_65() : memref<32x32xf32, 2>
    %181 = adf.buffer.create @L1_L1_A_66() : memref<32x32xf32, 2>
    %182 = adf.buffer.create @L1_L1_B_66() : memref<32x32xf32, 2>
    %183 = adf.buffer.create @L1_L1_C_66() : memref<32x32xf32, 2>
    %184 = adf.buffer.create @L1_L1_A_67() : memref<32x32xf32, 2>
    %185 = adf.buffer.create @L1_L1_B_67() : memref<32x32xf32, 2>
    %186 = adf.buffer.create @L1_L1_C_67() : memref<32x32xf32, 2>
    %187 = adf.buffer.create @L1_L1_A_68() : memref<32x32xf32, 2>
    %188 = adf.buffer.create @L1_L1_B_68() : memref<32x32xf32, 2>
    %189 = adf.buffer.create @L1_L1_A_69() : memref<32x32xf32, 2>
    %190 = adf.buffer.create @L1_L1_B_69() : memref<32x32xf32, 2>
    %191 = adf.buffer.create @L1_L1_C_69() : memref<32x32xf32, 2>
    %192 = adf.buffer.create @L1_L1_A_70() : memref<32x32xf32, 2>
    %193 = adf.buffer.create @L1_L1_B_70() : memref<32x32xf32, 2>
    %194 = adf.buffer.create @L1_L1_C_70() : memref<32x32xf32, 2>
    %195 = adf.buffer.create @L1_L1_A_71() : memref<32x32xf32, 2>
    %196 = adf.buffer.create @L1_L1_B_71() : memref<32x32xf32, 2>
    %197 = adf.buffer.create @L1_L1_C_71() : memref<32x32xf32, 2>
    %198 = adf.buffer.create @L1_L1_A_72() : memref<32x32xf32, 2>
    %199 = adf.buffer.create @L1_L1_B_72() : memref<32x32xf32, 2>
    %200 = adf.buffer.create @L1_L1_A_73() : memref<32x32xf32, 2>
    %201 = adf.buffer.create @L1_L1_B_73() : memref<32x32xf32, 2>
    %202 = adf.buffer.create @L1_L1_C_73() : memref<32x32xf32, 2>
    %203 = adf.buffer.create @L1_L1_A_74() : memref<32x32xf32, 2>
    %204 = adf.buffer.create @L1_L1_B_74() : memref<32x32xf32, 2>
    %205 = adf.buffer.create @L1_L1_C_74() : memref<32x32xf32, 2>
    %206 = adf.buffer.create @L1_L1_A_75() : memref<32x32xf32, 2>
    %207 = adf.buffer.create @L1_L1_B_75() : memref<32x32xf32, 2>
    %208 = adf.buffer.create @L1_L1_C_75() : memref<32x32xf32, 2>
    %209 = adf.buffer.create @L1_L1_A_76() : memref<32x32xf32, 2>
    %210 = adf.buffer.create @L1_L1_B_76() : memref<32x32xf32, 2>
    %211 = adf.buffer.create @L1_L1_A_77() : memref<32x32xf32, 2>
    %212 = adf.buffer.create @L1_L1_B_77() : memref<32x32xf32, 2>
    %213 = adf.buffer.create @L1_L1_C_77() : memref<32x32xf32, 2>
    %214 = adf.buffer.create @L1_L1_A_78() : memref<32x32xf32, 2>
    %215 = adf.buffer.create @L1_L1_B_78() : memref<32x32xf32, 2>
    %216 = adf.buffer.create @L1_L1_C_78() : memref<32x32xf32, 2>
    %217 = adf.buffer.create @L1_L1_A_79() : memref<32x32xf32, 2>
    %218 = adf.buffer.create @L1_L1_B_79() : memref<32x32xf32, 2>
    %219 = adf.buffer.create @L1_L1_C_79() : memref<32x32xf32, 2>
    %220 = adf.buffer.create @L1_L1_A_80() : memref<32x32xf32, 2>
    %221 = adf.buffer.create @L1_L1_B_80() : memref<32x32xf32, 2>
    %222 = adf.buffer.create @L1_L1_A_81() : memref<32x32xf32, 2>
    %223 = adf.buffer.create @L1_L1_B_81() : memref<32x32xf32, 2>
    %224 = adf.buffer.create @L1_L1_C_81() : memref<32x32xf32, 2>
    %225 = adf.buffer.create @L1_L1_A_82() : memref<32x32xf32, 2>
    %226 = adf.buffer.create @L1_L1_B_82() : memref<32x32xf32, 2>
    %227 = adf.buffer.create @L1_L1_C_82() : memref<32x32xf32, 2>
    %228 = adf.buffer.create @L1_L1_A_83() : memref<32x32xf32, 2>
    %229 = adf.buffer.create @L1_L1_B_83() : memref<32x32xf32, 2>
    %230 = adf.buffer.create @L1_L1_C_83() : memref<32x32xf32, 2>
    %231 = adf.buffer.create @L1_L1_A_84() : memref<32x32xf32, 2>
    %232 = adf.buffer.create @L1_L1_B_84() : memref<32x32xf32, 2>
    %233 = adf.buffer.create @L1_L1_A_85() : memref<32x32xf32, 2>
    %234 = adf.buffer.create @L1_L1_B_85() : memref<32x32xf32, 2>
    %235 = adf.buffer.create @L1_L1_C_85() : memref<32x32xf32, 2>
    %236 = adf.buffer.create @L1_L1_A_86() : memref<32x32xf32, 2>
    %237 = adf.buffer.create @L1_L1_B_86() : memref<32x32xf32, 2>
    %238 = adf.buffer.create @L1_L1_C_86() : memref<32x32xf32, 2>
    %239 = adf.buffer.create @L1_L1_A_87() : memref<32x32xf32, 2>
    %240 = adf.buffer.create @L1_L1_B_87() : memref<32x32xf32, 2>
    %241 = adf.buffer.create @L1_L1_C_87() : memref<32x32xf32, 2>
    %242 = adf.buffer.create @L1_L1_A_88() : memref<32x32xf32, 2>
    %243 = adf.buffer.create @L1_L1_B_88() : memref<32x32xf32, 2>
    %244 = adf.buffer.create @L1_L1_A_89() : memref<32x32xf32, 2>
    %245 = adf.buffer.create @L1_L1_B_89() : memref<32x32xf32, 2>
    %246 = adf.buffer.create @L1_L1_C_89() : memref<32x32xf32, 2>
    %247 = adf.buffer.create @L1_L1_A_90() : memref<32x32xf32, 2>
    %248 = adf.buffer.create @L1_L1_B_90() : memref<32x32xf32, 2>
    %249 = adf.buffer.create @L1_L1_C_90() : memref<32x32xf32, 2>
    %250 = adf.buffer.create @L1_L1_A_91() : memref<32x32xf32, 2>
    %251 = adf.buffer.create @L1_L1_B_91() : memref<32x32xf32, 2>
    %252 = adf.buffer.create @L1_L1_C_91() : memref<32x32xf32, 2>
    %253 = adf.buffer.create @L1_L1_A_92() : memref<32x32xf32, 2>
    %254 = adf.buffer.create @L1_L1_B_92() : memref<32x32xf32, 2>
    %255 = adf.buffer.create @L1_L1_A_93() : memref<32x32xf32, 2>
    %256 = adf.buffer.create @L1_L1_B_93() : memref<32x32xf32, 2>
    %257 = adf.buffer.create @L1_L1_C_93() : memref<32x32xf32, 2>
    %258 = adf.buffer.create @L1_L1_A_94() : memref<32x32xf32, 2>
    %259 = adf.buffer.create @L1_L1_B_94() : memref<32x32xf32, 2>
    %260 = adf.buffer.create @L1_L1_C_94() : memref<32x32xf32, 2>
    %261 = adf.buffer.create @L1_L1_A_95() : memref<32x32xf32, 2>
    %262 = adf.buffer.create @L1_L1_B_95() : memref<32x32xf32, 2>
    %263 = adf.buffer.create @L1_L1_C_95() : memref<32x32xf32, 2>
    %264 = adf.buffer.create @L1_L1_A_96() : memref<32x32xf32, 2>
    %265 = adf.buffer.create @L1_L1_B_96() : memref<32x32xf32, 2>
    %266 = adf.buffer.create @L1_L1_A_97() : memref<32x32xf32, 2>
    %267 = adf.buffer.create @L1_L1_B_97() : memref<32x32xf32, 2>
    %268 = adf.buffer.create @L1_L1_C_97() : memref<32x32xf32, 2>
    %269 = adf.buffer.create @L1_L1_A_98() : memref<32x32xf32, 2>
    %270 = adf.buffer.create @L1_L1_B_98() : memref<32x32xf32, 2>
    %271 = adf.buffer.create @L1_L1_C_98() : memref<32x32xf32, 2>
    %272 = adf.buffer.create @L1_L1_A_99() : memref<32x32xf32, 2>
    %273 = adf.buffer.create @L1_L1_B_99() : memref<32x32xf32, 2>
    %274 = adf.buffer.create @L1_L1_C_99() : memref<32x32xf32, 2>
    %275 = adf.buffer.create @L1_L1_A_100() : memref<32x32xf32, 2>
    %276 = adf.buffer.create @L1_L1_B_100() : memref<32x32xf32, 2>
    %277 = adf.buffer.create @L1_L1_A_101() : memref<32x32xf32, 2>
    %278 = adf.buffer.create @L1_L1_B_101() : memref<32x32xf32, 2>
    %279 = adf.buffer.create @L1_L1_C_101() : memref<32x32xf32, 2>
    %280 = adf.buffer.create @L1_L1_A_102() : memref<32x32xf32, 2>
    %281 = adf.buffer.create @L1_L1_B_102() : memref<32x32xf32, 2>
    %282 = adf.buffer.create @L1_L1_C_102() : memref<32x32xf32, 2>
    %283 = adf.buffer.create @L1_L1_A_103() : memref<32x32xf32, 2>
    %284 = adf.buffer.create @L1_L1_B_103() : memref<32x32xf32, 2>
    %285 = adf.buffer.create @L1_L1_C_103() : memref<32x32xf32, 2>
    %286 = adf.buffer.create @L1_L1_A_104() : memref<32x32xf32, 2>
    %287 = adf.buffer.create @L1_L1_B_104() : memref<32x32xf32, 2>
    %288 = adf.buffer.create @L1_L1_A_105() : memref<32x32xf32, 2>
    %289 = adf.buffer.create @L1_L1_B_105() : memref<32x32xf32, 2>
    %290 = adf.buffer.create @L1_L1_C_105() : memref<32x32xf32, 2>
    %291 = adf.buffer.create @L1_L1_A_106() : memref<32x32xf32, 2>
    %292 = adf.buffer.create @L1_L1_B_106() : memref<32x32xf32, 2>
    %293 = adf.buffer.create @L1_L1_C_106() : memref<32x32xf32, 2>
    %294 = adf.buffer.create @L1_L1_A_107() : memref<32x32xf32, 2>
    %295 = adf.buffer.create @L1_L1_B_107() : memref<32x32xf32, 2>
    %296 = adf.buffer.create @L1_L1_C_107() : memref<32x32xf32, 2>
    %297 = adf.buffer.create @L1_L1_A_108() : memref<32x32xf32, 2>
    %298 = adf.buffer.create @L1_L1_B_108() : memref<32x32xf32, 2>
    %299 = adf.buffer.create @L1_L1_A_109() : memref<32x32xf32, 2>
    %300 = adf.buffer.create @L1_L1_B_109() : memref<32x32xf32, 2>
    %301 = adf.buffer.create @L1_L1_C_109() : memref<32x32xf32, 2>
    %302 = adf.buffer.create @L1_L1_A_110() : memref<32x32xf32, 2>
    %303 = adf.buffer.create @L1_L1_B_110() : memref<32x32xf32, 2>
    %304 = adf.buffer.create @L1_L1_C_110() : memref<32x32xf32, 2>
    %305 = adf.buffer.create @L1_L1_A_111() : memref<32x32xf32, 2>
    %306 = adf.buffer.create @L1_L1_B_111() : memref<32x32xf32, 2>
    %307 = adf.buffer.create @L1_L1_C_111() : memref<32x32xf32, 2>
    %308 = adf.buffer.create @L1_L1_A_112() : memref<32x32xf32, 2>
    %309 = adf.buffer.create @L1_L1_B_112() : memref<32x32xf32, 2>
    %310 = adf.buffer.create @L1_L1_A_113() : memref<32x32xf32, 2>
    %311 = adf.buffer.create @L1_L1_B_113() : memref<32x32xf32, 2>
    %312 = adf.buffer.create @L1_L1_C_113() : memref<32x32xf32, 2>
    %313 = adf.buffer.create @L1_L1_A_114() : memref<32x32xf32, 2>
    %314 = adf.buffer.create @L1_L1_B_114() : memref<32x32xf32, 2>
    %315 = adf.buffer.create @L1_L1_C_114() : memref<32x32xf32, 2>
    %316 = adf.buffer.create @L1_L1_A_115() : memref<32x32xf32, 2>
    %317 = adf.buffer.create @L1_L1_B_115() : memref<32x32xf32, 2>
    %318 = adf.buffer.create @L1_L1_C_115() : memref<32x32xf32, 2>
    %319 = adf.buffer.create @L1_L1_A_116() : memref<32x32xf32, 2>
    %320 = adf.buffer.create @L1_L1_B_116() : memref<32x32xf32, 2>
    %321 = adf.buffer.create @L1_L1_A_117() : memref<32x32xf32, 2>
    %322 = adf.buffer.create @L1_L1_B_117() : memref<32x32xf32, 2>
    %323 = adf.buffer.create @L1_L1_C_117() : memref<32x32xf32, 2>
    %324 = adf.buffer.create @L1_L1_A_118() : memref<32x32xf32, 2>
    %325 = adf.buffer.create @L1_L1_B_118() : memref<32x32xf32, 2>
    %326 = adf.buffer.create @L1_L1_C_118() : memref<32x32xf32, 2>
    %327 = adf.buffer.create @L1_L1_A_119() : memref<32x32xf32, 2>
    %328 = adf.buffer.create @L1_L1_B_119() : memref<32x32xf32, 2>
    %329 = adf.buffer.create @L1_L1_C_119() : memref<32x32xf32, 2>
    %330 = adf.buffer.create @L1_L1_A_120() : memref<32x32xf32, 2>
    %331 = adf.buffer.create @L1_L1_B_120() : memref<32x32xf32, 2>
    %332 = adf.buffer.create @L1_L1_A_121() : memref<32x32xf32, 2>
    %333 = adf.buffer.create @L1_L1_B_121() : memref<32x32xf32, 2>
    %334 = adf.buffer.create @L1_L1_C_121() : memref<32x32xf32, 2>
    %335 = adf.buffer.create @L1_L1_A_122() : memref<32x32xf32, 2>
    %336 = adf.buffer.create @L1_L1_B_122() : memref<32x32xf32, 2>
    %337 = adf.buffer.create @L1_L1_C_122() : memref<32x32xf32, 2>
    %338 = adf.buffer.create @L1_L1_A_123() : memref<32x32xf32, 2>
    %339 = adf.buffer.create @L1_L1_B_123() : memref<32x32xf32, 2>
    %340 = adf.buffer.create @L1_L1_C_123() : memref<32x32xf32, 2>
    %341 = adf.buffer.create @L1_L1_A_124() : memref<32x32xf32, 2>
    %342 = adf.buffer.create @L1_L1_B_124() : memref<32x32xf32, 2>
    %343 = adf.buffer.create @L1_L1_A_125() : memref<32x32xf32, 2>
    %344 = adf.buffer.create @L1_L1_B_125() : memref<32x32xf32, 2>
    %345 = adf.buffer.create @L1_L1_C_125() : memref<32x32xf32, 2>
    %346 = adf.buffer.create @L1_L1_A_126() : memref<32x32xf32, 2>
    %347 = adf.buffer.create @L1_L1_B_126() : memref<32x32xf32, 2>
    %348 = adf.buffer.create @L1_L1_C_126() : memref<32x32xf32, 2>
    %349 = adf.buffer.create @L1_L1_A_127() : memref<32x32xf32, 2>
    %350 = adf.buffer.create @L1_L1_B_127() : memref<32x32xf32, 2>
    %351 = adf.buffer.create @L1_L1_C_127() : memref<32x32xf32, 2>
    %352 = adf.buffer.create @L1_L1_A_128() : memref<32x32xf32, 2>
    %353 = adf.buffer.create @L1_L1_B_128() : memref<32x32xf32, 2>
    %354 = adf.buffer.create @L1_L1_A_129() : memref<32x32xf32, 2>
    %355 = adf.buffer.create @L1_L1_B_129() : memref<32x32xf32, 2>
    %356 = adf.buffer.create @L1_L1_C_129() : memref<32x32xf32, 2>
    %357 = adf.buffer.create @L1_L1_A_130() : memref<32x32xf32, 2>
    %358 = adf.buffer.create @L1_L1_B_130() : memref<32x32xf32, 2>
    %359 = adf.buffer.create @L1_L1_C_130() : memref<32x32xf32, 2>
    %360 = adf.buffer.create @L1_L1_A_131() : memref<32x32xf32, 2>
    %361 = adf.buffer.create @L1_L1_B_131() : memref<32x32xf32, 2>
    %362 = adf.buffer.create @L1_L1_C_131() : memref<32x32xf32, 2>
    %363 = adf.buffer.create @L1_L1_A_132() : memref<32x32xf32, 2>
    %364 = adf.buffer.create @L1_L1_B_132() : memref<32x32xf32, 2>
    %365 = adf.buffer.create @L1_L1_A_133() : memref<32x32xf32, 2>
    %366 = adf.buffer.create @L1_L1_B_133() : memref<32x32xf32, 2>
    %367 = adf.buffer.create @L1_L1_C_133() : memref<32x32xf32, 2>
    %368 = adf.buffer.create @L1_L1_A_134() : memref<32x32xf32, 2>
    %369 = adf.buffer.create @L1_L1_B_134() : memref<32x32xf32, 2>
    %370 = adf.buffer.create @L1_L1_C_134() : memref<32x32xf32, 2>
    %371 = adf.buffer.create @L1_L1_A_135() : memref<32x32xf32, 2>
    %372 = adf.buffer.create @L1_L1_B_135() : memref<32x32xf32, 2>
    %373 = adf.buffer.create @L1_L1_C_135() : memref<32x32xf32, 2>
    %374 = adf.buffer.create @L1_L1_A_136() : memref<32x32xf32, 2>
    %375 = adf.buffer.create @L1_L1_B_136() : memref<32x32xf32, 2>
    %376 = adf.buffer.create @L1_L1_A_137() : memref<32x32xf32, 2>
    %377 = adf.buffer.create @L1_L1_B_137() : memref<32x32xf32, 2>
    %378 = adf.buffer.create @L1_L1_C_137() : memref<32x32xf32, 2>
    %379 = adf.buffer.create @L1_L1_A_138() : memref<32x32xf32, 2>
    %380 = adf.buffer.create @L1_L1_B_138() : memref<32x32xf32, 2>
    %381 = adf.buffer.create @L1_L1_C_138() : memref<32x32xf32, 2>
    %382 = adf.buffer.create @L1_L1_A_139() : memref<32x32xf32, 2>
    %383 = adf.buffer.create @L1_L1_B_139() : memref<32x32xf32, 2>
    %384 = adf.buffer.create @L1_L1_C_139() : memref<32x32xf32, 2>
    %385 = adf.buffer.create @L1_L1_A_140() : memref<32x32xf32, 2>
    %386 = adf.buffer.create @L1_L1_B_140() : memref<32x32xf32, 2>
    %387 = adf.buffer.create @L1_L1_A_141() : memref<32x32xf32, 2>
    %388 = adf.buffer.create @L1_L1_B_141() : memref<32x32xf32, 2>
    %389 = adf.buffer.create @L1_L1_C_141() : memref<32x32xf32, 2>
    %390 = adf.buffer.create @L1_L1_A_142() : memref<32x32xf32, 2>
    %391 = adf.buffer.create @L1_L1_B_142() : memref<32x32xf32, 2>
    %392 = adf.buffer.create @L1_L1_C_142() : memref<32x32xf32, 2>
    %393 = adf.buffer.create @L1_L1_A_143() : memref<32x32xf32, 2>
    %394 = adf.buffer.create @L1_L1_B_143() : memref<32x32xf32, 2>
    %395 = adf.buffer.create @L1_L1_C_143() : memref<32x32xf32, 2>
    %396 = adf.buffer.create @L1_L1_A_144() : memref<32x32xf32, 2>
    %397 = adf.buffer.create @L1_L1_B_144() : memref<32x32xf32, 2>
    %398 = adf.buffer.create @L1_L1_A_145() : memref<32x32xf32, 2>
    %399 = adf.buffer.create @L1_L1_B_145() : memref<32x32xf32, 2>
    %400 = adf.buffer.create @L1_L1_C_145() : memref<32x32xf32, 2>
    %401 = adf.buffer.create @L1_L1_A_146() : memref<32x32xf32, 2>
    %402 = adf.buffer.create @L1_L1_B_146() : memref<32x32xf32, 2>
    %403 = adf.buffer.create @L1_L1_C_146() : memref<32x32xf32, 2>
    %404 = adf.buffer.create @L1_L1_A_147() : memref<32x32xf32, 2>
    %405 = adf.buffer.create @L1_L1_B_147() : memref<32x32xf32, 2>
    %406 = adf.buffer.create @L1_L1_C_147() : memref<32x32xf32, 2>
    %407 = adf.buffer.create @L1_L1_A_148() : memref<32x32xf32, 2>
    %408 = adf.buffer.create @L1_L1_B_148() : memref<32x32xf32, 2>
    %409 = adf.buffer.create @L1_L1_A_149() : memref<32x32xf32, 2>
    %410 = adf.buffer.create @L1_L1_B_149() : memref<32x32xf32, 2>
    %411 = adf.buffer.create @L1_L1_C_149() : memref<32x32xf32, 2>
    %412 = adf.buffer.create @L1_L1_A_150() : memref<32x32xf32, 2>
    %413 = adf.buffer.create @L1_L1_B_150() : memref<32x32xf32, 2>
    %414 = adf.buffer.create @L1_L1_C_150() : memref<32x32xf32, 2>
    %415 = adf.buffer.create @L1_L1_A_151() : memref<32x32xf32, 2>
    %416 = adf.buffer.create @L1_L1_B_151() : memref<32x32xf32, 2>
    %417 = adf.buffer.create @L1_L1_C_151() : memref<32x32xf32, 2>
    %418 = adf.buffer.create @L1_L1_A_152() : memref<32x32xf32, 2>
    %419 = adf.buffer.create @L1_L1_B_152() : memref<32x32xf32, 2>
    %420 = adf.buffer.create @L1_L1_A_153() : memref<32x32xf32, 2>
    %421 = adf.buffer.create @L1_L1_B_153() : memref<32x32xf32, 2>
    %422 = adf.buffer.create @L1_L1_C_153() : memref<32x32xf32, 2>
    %423 = adf.buffer.create @L1_L1_A_154() : memref<32x32xf32, 2>
    %424 = adf.buffer.create @L1_L1_B_154() : memref<32x32xf32, 2>
    %425 = adf.buffer.create @L1_L1_C_154() : memref<32x32xf32, 2>
    %426 = adf.buffer.create @L1_L1_A_155() : memref<32x32xf32, 2>
    %427 = adf.buffer.create @L1_L1_B_155() : memref<32x32xf32, 2>
    %428 = adf.buffer.create @L1_L1_C_155() : memref<32x32xf32, 2>
    %429 = adf.buffer.create @L1_L1_A_156() : memref<32x32xf32, 2>
    %430 = adf.buffer.create @L1_L1_B_156() : memref<32x32xf32, 2>
    %431 = adf.buffer.create @L1_L1_A_157() : memref<32x32xf32, 2>
    %432 = adf.buffer.create @L1_L1_B_157() : memref<32x32xf32, 2>
    %433 = adf.buffer.create @L1_L1_C_157() : memref<32x32xf32, 2>
    %434 = adf.buffer.create @L1_L1_A_158() : memref<32x32xf32, 2>
    %435 = adf.buffer.create @L1_L1_B_158() : memref<32x32xf32, 2>
    %436 = adf.buffer.create @L1_L1_C_158() : memref<32x32xf32, 2>
    %437 = adf.buffer.create @L1_L1_A_159() : memref<32x32xf32, 2>
    %438 = adf.buffer.create @L1_L1_B_159() : memref<32x32xf32, 2>
    %439 = adf.buffer.create @L1_L1_C_159() : memref<32x32xf32, 2>
    %440 = adf.buffer.create @L1_L1_A_160() : memref<32x32xf32, 2>
    %441 = adf.buffer.create @L1_L1_B_160() : memref<32x32xf32, 2>
    %442 = adf.buffer.create @L1_L1_A_161() : memref<32x32xf32, 2>
    %443 = adf.buffer.create @L1_L1_B_161() : memref<32x32xf32, 2>
    %444 = adf.buffer.create @L1_L1_C_161() : memref<32x32xf32, 2>
    %445 = adf.buffer.create @L1_L1_A_162() : memref<32x32xf32, 2>
    %446 = adf.buffer.create @L1_L1_B_162() : memref<32x32xf32, 2>
    %447 = adf.buffer.create @L1_L1_C_162() : memref<32x32xf32, 2>
    %448 = adf.buffer.create @L1_L1_A_163() : memref<32x32xf32, 2>
    %449 = adf.buffer.create @L1_L1_B_163() : memref<32x32xf32, 2>
    %450 = adf.buffer.create @L1_L1_C_163() : memref<32x32xf32, 2>
    %451 = adf.buffer.create @L1_L1_A_164() : memref<32x32xf32, 2>
    %452 = adf.buffer.create @L1_L1_B_164() : memref<32x32xf32, 2>
    %453 = adf.buffer.create @L1_L1_A_165() : memref<32x32xf32, 2>
    %454 = adf.buffer.create @L1_L1_B_165() : memref<32x32xf32, 2>
    %455 = adf.buffer.create @L1_L1_C_165() : memref<32x32xf32, 2>
    %456 = adf.buffer.create @L1_L1_A_166() : memref<32x32xf32, 2>
    %457 = adf.buffer.create @L1_L1_B_166() : memref<32x32xf32, 2>
    %458 = adf.buffer.create @L1_L1_C_166() : memref<32x32xf32, 2>
    %459 = adf.buffer.create @L1_L1_A_167() : memref<32x32xf32, 2>
    %460 = adf.buffer.create @L1_L1_B_167() : memref<32x32xf32, 2>
    %461 = adf.buffer.create @L1_L1_C_167() : memref<32x32xf32, 2>
    %462 = adf.buffer.create @L1_L1_A_168() : memref<32x32xf32, 2>
    %463 = adf.buffer.create @L1_L1_B_168() : memref<32x32xf32, 2>
    %464 = adf.buffer.create @L1_L1_A_169() : memref<32x32xf32, 2>
    %465 = adf.buffer.create @L1_L1_B_169() : memref<32x32xf32, 2>
    %466 = adf.buffer.create @L1_L1_C_169() : memref<32x32xf32, 2>
    %467 = adf.buffer.create @L1_L1_A_170() : memref<32x32xf32, 2>
    %468 = adf.buffer.create @L1_L1_B_170() : memref<32x32xf32, 2>
    %469 = adf.buffer.create @L1_L1_C_170() : memref<32x32xf32, 2>
    %470 = adf.buffer.create @L1_L1_A_171() : memref<32x32xf32, 2>
    %471 = adf.buffer.create @L1_L1_B_171() : memref<32x32xf32, 2>
    %472 = adf.buffer.create @L1_L1_C_171() : memref<32x32xf32, 2>
    %473 = adf.buffer.create @L1_L1_A_172() : memref<32x32xf32, 2>
    %474 = adf.buffer.create @L1_L1_B_172() : memref<32x32xf32, 2>
    %475 = adf.buffer.create @L1_L1_A_173() : memref<32x32xf32, 2>
    %476 = adf.buffer.create @L1_L1_B_173() : memref<32x32xf32, 2>
    %477 = adf.buffer.create @L1_L1_C_173() : memref<32x32xf32, 2>
    %478 = adf.buffer.create @L1_L1_A_174() : memref<32x32xf32, 2>
    %479 = adf.buffer.create @L1_L1_B_174() : memref<32x32xf32, 2>
    %480 = adf.buffer.create @L1_L1_C_174() : memref<32x32xf32, 2>
    %481 = adf.buffer.create @L1_L1_A_175() : memref<32x32xf32, 2>
    %482 = adf.buffer.create @L1_L1_B_175() : memref<32x32xf32, 2>
    %483 = adf.buffer.create @L1_L1_C_175() : memref<32x32xf32, 2>
    %484 = adf.buffer.create @L1_L1_A_176() : memref<32x32xf32, 2>
    %485 = adf.buffer.create @L1_L1_B_176() : memref<32x32xf32, 2>
    %486 = adf.buffer.create @L1_L1_A_177() : memref<32x32xf32, 2>
    %487 = adf.buffer.create @L1_L1_B_177() : memref<32x32xf32, 2>
    %488 = adf.buffer.create @L1_L1_C_177() : memref<32x32xf32, 2>
    %489 = adf.buffer.create @L1_L1_A_178() : memref<32x32xf32, 2>
    %490 = adf.buffer.create @L1_L1_B_178() : memref<32x32xf32, 2>
    %491 = adf.buffer.create @L1_L1_C_178() : memref<32x32xf32, 2>
    %492 = adf.buffer.create @L1_L1_A_179() : memref<32x32xf32, 2>
    %493 = adf.buffer.create @L1_L1_B_179() : memref<32x32xf32, 2>
    %494 = adf.buffer.create @L1_L1_C_179() : memref<32x32xf32, 2>
    %495 = adf.buffer.create @L1_L1_A_180() : memref<32x32xf32, 2>
    %496 = adf.buffer.create @L1_L1_B_180() : memref<32x32xf32, 2>
    %497 = adf.buffer.create @L1_L1_A_181() : memref<32x32xf32, 2>
    %498 = adf.buffer.create @L1_L1_B_181() : memref<32x32xf32, 2>
    %499 = adf.buffer.create @L1_L1_C_181() : memref<32x32xf32, 2>
    %500 = adf.buffer.create @L1_L1_A_182() : memref<32x32xf32, 2>
    %501 = adf.buffer.create @L1_L1_B_182() : memref<32x32xf32, 2>
    %502 = adf.buffer.create @L1_L1_C_182() : memref<32x32xf32, 2>
    %503 = adf.buffer.create @L1_L1_A_183() : memref<32x32xf32, 2>
    %504 = adf.buffer.create @L1_L1_B_183() : memref<32x32xf32, 2>
    %505 = adf.buffer.create @L1_L1_C_183() : memref<32x32xf32, 2>
    %506 = adf.buffer.create @L1_L1_A_184() : memref<32x32xf32, 2>
    %507 = adf.buffer.create @L1_L1_B_184() : memref<32x32xf32, 2>
    %508 = adf.buffer.create @L1_L1_A_185() : memref<32x32xf32, 2>
    %509 = adf.buffer.create @L1_L1_B_185() : memref<32x32xf32, 2>
    %510 = adf.buffer.create @L1_L1_C_185() : memref<32x32xf32, 2>
    %511 = adf.buffer.create @L1_L1_A_186() : memref<32x32xf32, 2>
    %512 = adf.buffer.create @L1_L1_B_186() : memref<32x32xf32, 2>
    %513 = adf.buffer.create @L1_L1_C_186() : memref<32x32xf32, 2>
    %514 = adf.buffer.create @L1_L1_A_187() : memref<32x32xf32, 2>
    %515 = adf.buffer.create @L1_L1_B_187() : memref<32x32xf32, 2>
    %516 = adf.buffer.create @L1_L1_C_187() : memref<32x32xf32, 2>
    %517 = adf.buffer.create @L1_L1_A_188() : memref<32x32xf32, 2>
    %518 = adf.buffer.create @L1_L1_B_188() : memref<32x32xf32, 2>
    %519 = adf.buffer.create @L1_L1_A_189() : memref<32x32xf32, 2>
    %520 = adf.buffer.create @L1_L1_B_189() : memref<32x32xf32, 2>
    %521 = adf.buffer.create @L1_L1_C_189() : memref<32x32xf32, 2>
    %522 = adf.buffer.create @L1_L1_A_190() : memref<32x32xf32, 2>
    %523 = adf.buffer.create @L1_L1_B_190() : memref<32x32xf32, 2>
    %524 = adf.buffer.create @L1_L1_C_190() : memref<32x32xf32, 2>
    %525 = adf.buffer.create @L1_L1_A_191() : memref<32x32xf32, 2>
    %526 = adf.buffer.create @L1_L1_B_191() : memref<32x32xf32, 2>
    %527 = adf.buffer.create @L1_L1_C_191() : memref<32x32xf32, 2>
    %528 = adf.buffer.create @L1_L1_A_192() : memref<32x32xf32, 2>
    %529 = adf.buffer.create @L1_L1_B_192() : memref<32x32xf32, 2>
    %530 = adf.buffer.create @L1_L1_A_193() : memref<32x32xf32, 2>
    %531 = adf.buffer.create @L1_L1_B_193() : memref<32x32xf32, 2>
    %532 = adf.buffer.create @L1_L1_C_193() : memref<32x32xf32, 2>
    %533 = adf.buffer.create @L1_L1_A_194() : memref<32x32xf32, 2>
    %534 = adf.buffer.create @L1_L1_B_194() : memref<32x32xf32, 2>
    %535 = adf.buffer.create @L1_L1_C_194() : memref<32x32xf32, 2>
    %536 = adf.buffer.create @L1_L1_A_195() : memref<32x32xf32, 2>
    %537 = adf.buffer.create @L1_L1_B_195() : memref<32x32xf32, 2>
    %538 = adf.buffer.create @L1_L1_C_195() : memref<32x32xf32, 2>
    %539 = adf.buffer.create @L1_L1_A_196() : memref<32x32xf32, 2>
    %540 = adf.buffer.create @L1_L1_B_196() : memref<32x32xf32, 2>
    %541 = adf.buffer.create @L1_L1_A_197() : memref<32x32xf32, 2>
    %542 = adf.buffer.create @L1_L1_B_197() : memref<32x32xf32, 2>
    %543 = adf.buffer.create @L1_L1_C_197() : memref<32x32xf32, 2>
    %544 = adf.buffer.create @L1_L1_A_198() : memref<32x32xf32, 2>
    %545 = adf.buffer.create @L1_L1_B_198() : memref<32x32xf32, 2>
    %546 = adf.buffer.create @L1_L1_C_198() : memref<32x32xf32, 2>
    %547 = adf.buffer.create @L1_L1_A_199() : memref<32x32xf32, 2>
    %548 = adf.buffer.create @L1_L1_B_199() : memref<32x32xf32, 2>
    %549 = adf.buffer.create @L1_L1_C_199() : memref<32x32xf32, 2>
    %550 = adf.buffer.create @L1_L1_A_200() : memref<32x32xf32, 2>
    %551 = adf.buffer.create @L1_L1_B_200() : memref<32x32xf32, 2>
    %552 = adf.buffer.create @L1_L1_A_201() : memref<32x32xf32, 2>
    %553 = adf.buffer.create @L1_L1_B_201() : memref<32x32xf32, 2>
    %554 = adf.buffer.create @L1_L1_C_201() : memref<32x32xf32, 2>
    %555 = adf.buffer.create @L1_L1_A_202() : memref<32x32xf32, 2>
    %556 = adf.buffer.create @L1_L1_B_202() : memref<32x32xf32, 2>
    %557 = adf.buffer.create @L1_L1_C_202() : memref<32x32xf32, 2>
    %558 = adf.buffer.create @L1_L1_A_203() : memref<32x32xf32, 2>
    %559 = adf.buffer.create @L1_L1_B_203() : memref<32x32xf32, 2>
    %560 = adf.buffer.create @L1_L1_C_203() : memref<32x32xf32, 2>
    %561 = adf.buffer.create @L1_L1_A_204() : memref<32x32xf32, 2>
    %562 = adf.buffer.create @L1_L1_B_204() : memref<32x32xf32, 2>
    %563 = adf.buffer.create @L1_L1_A_205() : memref<32x32xf32, 2>
    %564 = adf.buffer.create @L1_L1_B_205() : memref<32x32xf32, 2>
    %565 = adf.buffer.create @L1_L1_C_205() : memref<32x32xf32, 2>
    %566 = adf.buffer.create @L1_L1_A_206() : memref<32x32xf32, 2>
    %567 = adf.buffer.create @L1_L1_B_206() : memref<32x32xf32, 2>
    %568 = adf.buffer.create @L1_L1_C_206() : memref<32x32xf32, 2>
    %569 = adf.buffer.create @L1_L1_A_207() : memref<32x32xf32, 2>
    %570 = adf.buffer.create @L1_L1_B_207() : memref<32x32xf32, 2>
    %571 = adf.buffer.create @L1_L1_C_207() : memref<32x32xf32, 2>
    %572 = adf.buffer.create @L1_L1_A_208() : memref<32x32xf32, 2>
    %573 = adf.buffer.create @L1_L1_B_208() : memref<32x32xf32, 2>
    %574 = adf.buffer.create @L1_L1_A_209() : memref<32x32xf32, 2>
    %575 = adf.buffer.create @L1_L1_B_209() : memref<32x32xf32, 2>
    %576 = adf.buffer.create @L1_L1_C_209() : memref<32x32xf32, 2>
    %577 = adf.buffer.create @L1_L1_A_210() : memref<32x32xf32, 2>
    %578 = adf.buffer.create @L1_L1_B_210() : memref<32x32xf32, 2>
    %579 = adf.buffer.create @L1_L1_C_210() : memref<32x32xf32, 2>
    %580 = adf.buffer.create @L1_L1_A_211() : memref<32x32xf32, 2>
    %581 = adf.buffer.create @L1_L1_B_211() : memref<32x32xf32, 2>
    %582 = adf.buffer.create @L1_L1_C_211() : memref<32x32xf32, 2>
    %583 = adf.buffer.create @L1_L1_A_212() : memref<32x32xf32, 2>
    %584 = adf.buffer.create @L1_L1_B_212() : memref<32x32xf32, 2>
    %585 = adf.buffer.create @L1_L1_A_213() : memref<32x32xf32, 2>
    %586 = adf.buffer.create @L1_L1_B_213() : memref<32x32xf32, 2>
    %587 = adf.buffer.create @L1_L1_C_213() : memref<32x32xf32, 2>
    %588 = adf.buffer.create @L1_L1_A_214() : memref<32x32xf32, 2>
    %589 = adf.buffer.create @L1_L1_B_214() : memref<32x32xf32, 2>
    %590 = adf.buffer.create @L1_L1_C_214() : memref<32x32xf32, 2>
    %591 = adf.buffer.create @L1_L1_A_215() : memref<32x32xf32, 2>
    %592 = adf.buffer.create @L1_L1_B_215() : memref<32x32xf32, 2>
    %593 = adf.buffer.create @L1_L1_C_215() : memref<32x32xf32, 2>
    %594 = adf.buffer.create @L1_L1_A_216() : memref<32x32xf32, 2>
    %595 = adf.buffer.create @L1_L1_B_216() : memref<32x32xf32, 2>
    %596 = adf.buffer.create @L1_L1_A_217() : memref<32x32xf32, 2>
    %597 = adf.buffer.create @L1_L1_B_217() : memref<32x32xf32, 2>
    %598 = adf.buffer.create @L1_L1_C_217() : memref<32x32xf32, 2>
    %599 = adf.buffer.create @L1_L1_A_218() : memref<32x32xf32, 2>
    %600 = adf.buffer.create @L1_L1_B_218() : memref<32x32xf32, 2>
    %601 = adf.buffer.create @L1_L1_C_218() : memref<32x32xf32, 2>
    %602 = adf.buffer.create @L1_L1_A_219() : memref<32x32xf32, 2>
    %603 = adf.buffer.create @L1_L1_B_219() : memref<32x32xf32, 2>
    %604 = adf.buffer.create @L1_L1_C_219() : memref<32x32xf32, 2>
    %605 = adf.buffer.create @L1_L1_A_220() : memref<32x32xf32, 2>
    %606 = adf.buffer.create @L1_L1_B_220() : memref<32x32xf32, 2>
    %607 = adf.buffer.create @L1_L1_A_221() : memref<32x32xf32, 2>
    %608 = adf.buffer.create @L1_L1_B_221() : memref<32x32xf32, 2>
    %609 = adf.buffer.create @L1_L1_C_221() : memref<32x32xf32, 2>
    %610 = adf.buffer.create @L1_L1_A_222() : memref<32x32xf32, 2>
    %611 = adf.buffer.create @L1_L1_B_222() : memref<32x32xf32, 2>
    %612 = adf.buffer.create @L1_L1_C_222() : memref<32x32xf32, 2>
    %613 = adf.buffer.create @L1_L1_A_223() : memref<32x32xf32, 2>
    %614 = adf.buffer.create @L1_L1_B_223() : memref<32x32xf32, 2>
    %615 = adf.buffer.create @L1_L1_C_223() : memref<32x32xf32, 2>
    %616 = adf.buffer.create @L1_L1_A_224() : memref<32x32xf32, 2>
    %617 = adf.buffer.create @L1_L1_B_224() : memref<32x32xf32, 2>
    %618 = adf.buffer.create @L1_L1_A_225() : memref<32x32xf32, 2>
    %619 = adf.buffer.create @L1_L1_B_225() : memref<32x32xf32, 2>
    %620 = adf.buffer.create @L1_L1_C_225() : memref<32x32xf32, 2>
    %621 = adf.buffer.create @L1_L1_A_226() : memref<32x32xf32, 2>
    %622 = adf.buffer.create @L1_L1_B_226() : memref<32x32xf32, 2>
    %623 = adf.buffer.create @L1_L1_C_226() : memref<32x32xf32, 2>
    %624 = adf.buffer.create @L1_L1_A_227() : memref<32x32xf32, 2>
    %625 = adf.buffer.create @L1_L1_B_227() : memref<32x32xf32, 2>
    %626 = adf.buffer.create @L1_L1_C_227() : memref<32x32xf32, 2>
    %627 = adf.buffer.create @L1_L1_A_228() : memref<32x32xf32, 2>
    %628 = adf.buffer.create @L1_L1_B_228() : memref<32x32xf32, 2>
    %629 = adf.buffer.create @L1_L1_A_229() : memref<32x32xf32, 2>
    %630 = adf.buffer.create @L1_L1_B_229() : memref<32x32xf32, 2>
    %631 = adf.buffer.create @L1_L1_C_229() : memref<32x32xf32, 2>
    %632 = adf.buffer.create @L1_L1_A_230() : memref<32x32xf32, 2>
    %633 = adf.buffer.create @L1_L1_B_230() : memref<32x32xf32, 2>
    %634 = adf.buffer.create @L1_L1_C_230() : memref<32x32xf32, 2>
    %635 = adf.buffer.create @L1_L1_A_231() : memref<32x32xf32, 2>
    %636 = adf.buffer.create @L1_L1_B_231() : memref<32x32xf32, 2>
    %637 = adf.buffer.create @L1_L1_C_231() : memref<32x32xf32, 2>
    %638 = adf.buffer.create @L1_L1_A_232() : memref<32x32xf32, 2>
    %639 = adf.buffer.create @L1_L1_B_232() : memref<32x32xf32, 2>
    %640 = adf.buffer.create @L1_L1_A_233() : memref<32x32xf32, 2>
    %641 = adf.buffer.create @L1_L1_B_233() : memref<32x32xf32, 2>
    %642 = adf.buffer.create @L1_L1_C_233() : memref<32x32xf32, 2>
    %643 = adf.buffer.create @L1_L1_A_234() : memref<32x32xf32, 2>
    %644 = adf.buffer.create @L1_L1_B_234() : memref<32x32xf32, 2>
    %645 = adf.buffer.create @L1_L1_C_234() : memref<32x32xf32, 2>
    %646 = adf.buffer.create @L1_L1_A_235() : memref<32x32xf32, 2>
    %647 = adf.buffer.create @L1_L1_B_235() : memref<32x32xf32, 2>
    %648 = adf.buffer.create @L1_L1_C_235() : memref<32x32xf32, 2>
    %649 = adf.buffer.create @L1_L1_A_236() : memref<32x32xf32, 2>
    %650 = adf.buffer.create @L1_L1_B_236() : memref<32x32xf32, 2>
    %651 = adf.buffer.create @L1_L1_A_237() : memref<32x32xf32, 2>
    %652 = adf.buffer.create @L1_L1_B_237() : memref<32x32xf32, 2>
    %653 = adf.buffer.create @L1_L1_C_237() : memref<32x32xf32, 2>
    %654 = adf.buffer.create @L1_L1_A_238() : memref<32x32xf32, 2>
    %655 = adf.buffer.create @L1_L1_B_238() : memref<32x32xf32, 2>
    %656 = adf.buffer.create @L1_L1_C_238() : memref<32x32xf32, 2>
    %657 = adf.buffer.create @L1_L1_A_239() : memref<32x32xf32, 2>
    %658 = adf.buffer.create @L1_L1_B_239() : memref<32x32xf32, 2>
    %659 = adf.buffer.create @L1_L1_C_239() : memref<32x32xf32, 2>
    %660 = adf.buffer.create @L1_L1_A_240() : memref<32x32xf32, 2>
    %661 = adf.buffer.create @L1_L1_B_240() : memref<32x32xf32, 2>
    %662 = adf.buffer.create @L1_L1_A_241() : memref<32x32xf32, 2>
    %663 = adf.buffer.create @L1_L1_B_241() : memref<32x32xf32, 2>
    %664 = adf.buffer.create @L1_L1_C_241() : memref<32x32xf32, 2>
    %665 = adf.buffer.create @L1_L1_A_242() : memref<32x32xf32, 2>
    %666 = adf.buffer.create @L1_L1_B_242() : memref<32x32xf32, 2>
    %667 = adf.buffer.create @L1_L1_C_242() : memref<32x32xf32, 2>
    %668 = adf.buffer.create @L1_L1_A_243() : memref<32x32xf32, 2>
    %669 = adf.buffer.create @L1_L1_B_243() : memref<32x32xf32, 2>
    %670 = adf.buffer.create @L1_L1_C_243() : memref<32x32xf32, 2>
    %671 = adf.buffer.create @L1_L1_A_244() : memref<32x32xf32, 2>
    %672 = adf.buffer.create @L1_L1_B_244() : memref<32x32xf32, 2>
    %673 = adf.buffer.create @L1_L1_A_245() : memref<32x32xf32, 2>
    %674 = adf.buffer.create @L1_L1_B_245() : memref<32x32xf32, 2>
    %675 = adf.buffer.create @L1_L1_C_245() : memref<32x32xf32, 2>
    %676 = adf.buffer.create @L1_L1_A_246() : memref<32x32xf32, 2>
    %677 = adf.buffer.create @L1_L1_B_246() : memref<32x32xf32, 2>
    %678 = adf.buffer.create @L1_L1_C_246() : memref<32x32xf32, 2>
    %679 = adf.buffer.create @L1_L1_A_247() : memref<32x32xf32, 2>
    %680 = adf.buffer.create @L1_L1_B_247() : memref<32x32xf32, 2>
    %681 = adf.buffer.create @L1_L1_C_247() : memref<32x32xf32, 2>
    %682 = adf.buffer.create @L1_L1_A_248() : memref<32x32xf32, 2>
    %683 = adf.buffer.create @L1_L1_B_248() : memref<32x32xf32, 2>
    %684 = adf.buffer.create @L1_L1_A_249() : memref<32x32xf32, 2>
    %685 = adf.buffer.create @L1_L1_B_249() : memref<32x32xf32, 2>
    %686 = adf.buffer.create @L1_L1_C_249() : memref<32x32xf32, 2>
    %687 = adf.buffer.create @L1_L1_A_250() : memref<32x32xf32, 2>
    %688 = adf.buffer.create @L1_L1_B_250() : memref<32x32xf32, 2>
    %689 = adf.buffer.create @L1_L1_C_250() : memref<32x32xf32, 2>
    %690 = adf.buffer.create @L1_L1_A_251() : memref<32x32xf32, 2>
    %691 = adf.buffer.create @L1_L1_B_251() : memref<32x32xf32, 2>
    %692 = adf.buffer.create @L1_L1_C_251() : memref<32x32xf32, 2>
    %693 = adf.buffer.create @L1_L1_A_252() : memref<32x32xf32, 2>
    %694 = adf.buffer.create @L1_L1_B_252() : memref<32x32xf32, 2>
    %695 = adf.buffer.create @L1_L1_A_253() : memref<32x32xf32, 2>
    %696 = adf.buffer.create @L1_L1_B_253() : memref<32x32xf32, 2>
    %697 = adf.buffer.create @L1_L1_C_253() : memref<32x32xf32, 2>
    %698 = adf.buffer.create @L1_L1_A_254() : memref<32x32xf32, 2>
    %699 = adf.buffer.create @L1_L1_B_254() : memref<32x32xf32, 2>
    %700 = adf.buffer.create @L1_L1_C_254() : memref<32x32xf32, 2>
    %701 = adf.buffer.create @L1_L1_A_255() : memref<32x32xf32, 2>
    %702 = adf.buffer.create @L1_L1_B_255() : memref<32x32xf32, 2>
    %703 = adf.buffer.create @L1_L1_C_255() : memref<32x32xf32, 2>
    %704 = adf.buffer.create @L1_L1_A_256() : memref<32x32xf32, 2>
    %705 = adf.buffer.create @L1_L1_B_256() : memref<32x32xf32, 2>
    %706 = adf.buffer.create @L1_L1_A_257() : memref<32x32xf32, 2>
    %707 = adf.buffer.create @L1_L1_B_257() : memref<32x32xf32, 2>
    %708 = adf.buffer.create @L1_L1_C_257() : memref<32x32xf32, 2>
    %709 = adf.buffer.create @L1_L1_A_258() : memref<32x32xf32, 2>
    %710 = adf.buffer.create @L1_L1_B_258() : memref<32x32xf32, 2>
    %711 = adf.buffer.create @L1_L1_C_258() : memref<32x32xf32, 2>
    %712 = adf.buffer.create @L1_L1_A_259() : memref<32x32xf32, 2>
    %713 = adf.buffer.create @L1_L1_B_259() : memref<32x32xf32, 2>
    %714 = adf.buffer.create @L1_L1_C_259() : memref<32x32xf32, 2>
    %715 = adf.buffer.create @L1_L1_A_260() : memref<32x32xf32, 2>
    %716 = adf.buffer.create @L1_L1_B_260() : memref<32x32xf32, 2>
    %717 = adf.buffer.create @L1_L1_A_261() : memref<32x32xf32, 2>
    %718 = adf.buffer.create @L1_L1_B_261() : memref<32x32xf32, 2>
    %719 = adf.buffer.create @L1_L1_C_261() : memref<32x32xf32, 2>
    %720 = adf.buffer.create @L1_L1_A_262() : memref<32x32xf32, 2>
    %721 = adf.buffer.create @L1_L1_B_262() : memref<32x32xf32, 2>
    %722 = adf.buffer.create @L1_L1_C_262() : memref<32x32xf32, 2>
    %723 = adf.buffer.create @L1_L1_A_263() : memref<32x32xf32, 2>
    %724 = adf.buffer.create @L1_L1_B_263() : memref<32x32xf32, 2>
    %725 = adf.buffer.create @L1_L1_C_263() : memref<32x32xf32, 2>
    %726 = adf.buffer.create @L1_L1_A_264() : memref<32x32xf32, 2>
    %727 = adf.buffer.create @L1_L1_B_264() : memref<32x32xf32, 2>
    %728 = adf.buffer.create @L1_L1_A_265() : memref<32x32xf32, 2>
    %729 = adf.buffer.create @L1_L1_B_265() : memref<32x32xf32, 2>
    %730 = adf.buffer.create @L1_L1_C_265() : memref<32x32xf32, 2>
    %731 = adf.buffer.create @L1_L1_A_266() : memref<32x32xf32, 2>
    %732 = adf.buffer.create @L1_L1_B_266() : memref<32x32xf32, 2>
    %733 = adf.buffer.create @L1_L1_C_266() : memref<32x32xf32, 2>
    %734 = adf.buffer.create @L1_L1_A_267() : memref<32x32xf32, 2>
    %735 = adf.buffer.create @L1_L1_B_267() : memref<32x32xf32, 2>
    %736 = adf.buffer.create @L1_L1_C_267() : memref<32x32xf32, 2>
    %737 = adf.buffer.create @L1_L1_A_268() : memref<32x32xf32, 2>
    %738 = adf.buffer.create @L1_L1_B_268() : memref<32x32xf32, 2>
    %739 = adf.buffer.create @L1_L1_A_269() : memref<32x32xf32, 2>
    %740 = adf.buffer.create @L1_L1_B_269() : memref<32x32xf32, 2>
    %741 = adf.buffer.create @L1_L1_C_269() : memref<32x32xf32, 2>
    %742 = adf.buffer.create @L1_L1_A_270() : memref<32x32xf32, 2>
    %743 = adf.buffer.create @L1_L1_B_270() : memref<32x32xf32, 2>
    %744 = adf.buffer.create @L1_L1_C_270() : memref<32x32xf32, 2>
    %745 = adf.buffer.create @L1_L1_A_271() : memref<32x32xf32, 2>
    %746 = adf.buffer.create @L1_L1_B_271() : memref<32x32xf32, 2>
    %747 = adf.buffer.create @L1_L1_C_271() : memref<32x32xf32, 2>
    %748 = adf.buffer.create @L1_L1_A_272() : memref<32x32xf32, 2>
    %749 = adf.buffer.create @L1_L1_B_272() : memref<32x32xf32, 2>
    %750 = adf.buffer.create @L1_L1_A_273() : memref<32x32xf32, 2>
    %751 = adf.buffer.create @L1_L1_B_273() : memref<32x32xf32, 2>
    %752 = adf.buffer.create @L1_L1_C_273() : memref<32x32xf32, 2>
    %753 = adf.buffer.create @L1_L1_A_274() : memref<32x32xf32, 2>
    %754 = adf.buffer.create @L1_L1_B_274() : memref<32x32xf32, 2>
    %755 = adf.buffer.create @L1_L1_C_274() : memref<32x32xf32, 2>
    %756 = adf.buffer.create @L1_L1_A_275() : memref<32x32xf32, 2>
    %757 = adf.buffer.create @L1_L1_B_275() : memref<32x32xf32, 2>
    %758 = adf.buffer.create @L1_L1_C_275() : memref<32x32xf32, 2>
    %759 = adf.buffer.create @L1_L1_A_276() : memref<32x32xf32, 2>
    %760 = adf.buffer.create @L1_L1_B_276() : memref<32x32xf32, 2>
    %761 = adf.buffer.create @L1_L1_A_277() : memref<32x32xf32, 2>
    %762 = adf.buffer.create @L1_L1_B_277() : memref<32x32xf32, 2>
    %763 = adf.buffer.create @L1_L1_C_277() : memref<32x32xf32, 2>
    %764 = adf.buffer.create @L1_L1_A_278() : memref<32x32xf32, 2>
    %765 = adf.buffer.create @L1_L1_B_278() : memref<32x32xf32, 2>
    %766 = adf.buffer.create @L1_L1_C_278() : memref<32x32xf32, 2>
    %767 = adf.buffer.create @L1_L1_A_279() : memref<32x32xf32, 2>
    %768 = adf.buffer.create @L1_L1_B_279() : memref<32x32xf32, 2>
    %769 = adf.buffer.create @L1_L1_C_279() : memref<32x32xf32, 2>
    %770 = adf.buffer.create @L1_L1_A_280() : memref<32x32xf32, 2>
    %771 = adf.buffer.create @L1_L1_B_280() : memref<32x32xf32, 2>
    %772 = adf.buffer.create @L1_L1_A_281() : memref<32x32xf32, 2>
    %773 = adf.buffer.create @L1_L1_B_281() : memref<32x32xf32, 2>
    %774 = adf.buffer.create @L1_L1_C_281() : memref<32x32xf32, 2>
    %775 = adf.buffer.create @L1_L1_A_282() : memref<32x32xf32, 2>
    %776 = adf.buffer.create @L1_L1_B_282() : memref<32x32xf32, 2>
    %777 = adf.buffer.create @L1_L1_C_282() : memref<32x32xf32, 2>
    %778 = adf.buffer.create @L1_L1_A_283() : memref<32x32xf32, 2>
    %779 = adf.buffer.create @L1_L1_B_283() : memref<32x32xf32, 2>
    %780 = adf.buffer.create @L1_L1_C_283() : memref<32x32xf32, 2>
    %781 = adf.buffer.create @L1_L1_A_284() : memref<32x32xf32, 2>
    %782 = adf.buffer.create @L1_L1_B_284() : memref<32x32xf32, 2>
    %783 = adf.buffer.create @L1_L1_A_285() : memref<32x32xf32, 2>
    %784 = adf.buffer.create @L1_L1_B_285() : memref<32x32xf32, 2>
    %785 = adf.buffer.create @L1_L1_C_285() : memref<32x32xf32, 2>
    %786 = adf.buffer.create @L1_L1_A_286() : memref<32x32xf32, 2>
    %787 = adf.buffer.create @L1_L1_B_286() : memref<32x32xf32, 2>
    %788 = adf.buffer.create @L1_L1_C_286() : memref<32x32xf32, 2>
    %789 = adf.buffer.create @L1_L1_A_287() : memref<32x32xf32, 2>
    %790 = adf.buffer.create @L1_L1_B_287() : memref<32x32xf32, 2>
    %791 = adf.buffer.create @L1_L1_C_287() : memref<32x32xf32, 2>
    %792 = adf.buffer.create @L1_L1_A_288() : memref<32x32xf32, 2>
    %793 = adf.buffer.create @L1_L1_B_288() : memref<32x32xf32, 2>
    %794 = adf.buffer.create @L1_L1_A_289() : memref<32x32xf32, 2>
    %795 = adf.buffer.create @L1_L1_B_289() : memref<32x32xf32, 2>
    %796 = adf.buffer.create @L1_L1_C_289() : memref<32x32xf32, 2>
    %797 = adf.buffer.create @L1_L1_A_290() : memref<32x32xf32, 2>
    %798 = adf.buffer.create @L1_L1_B_290() : memref<32x32xf32, 2>
    %799 = adf.buffer.create @L1_L1_C_290() : memref<32x32xf32, 2>
    %800 = adf.buffer.create @L1_L1_A_291() : memref<32x32xf32, 2>
    %801 = adf.buffer.create @L1_L1_B_291() : memref<32x32xf32, 2>
    %802 = adf.buffer.create @L1_L1_C_291() : memref<32x32xf32, 2>
    %803 = adf.buffer.create @L1_L1_A_292() : memref<32x32xf32, 2>
    %804 = adf.buffer.create @L1_L1_B_292() : memref<32x32xf32, 2>
    %805 = adf.buffer.create @L1_L1_A_293() : memref<32x32xf32, 2>
    %806 = adf.buffer.create @L1_L1_B_293() : memref<32x32xf32, 2>
    %807 = adf.buffer.create @L1_L1_C_293() : memref<32x32xf32, 2>
    %808 = adf.buffer.create @L1_L1_A_294() : memref<32x32xf32, 2>
    %809 = adf.buffer.create @L1_L1_B_294() : memref<32x32xf32, 2>
    %810 = adf.buffer.create @L1_L1_C_294() : memref<32x32xf32, 2>
    %811 = adf.buffer.create @L1_L1_A_295() : memref<32x32xf32, 2>
    %812 = adf.buffer.create @L1_L1_B_295() : memref<32x32xf32, 2>
    %813 = adf.buffer.create @L1_L1_C_295() : memref<32x32xf32, 2>
    %814 = adf.buffer.create @L1_L1_A_296() : memref<32x32xf32, 2>
    %815 = adf.buffer.create @L1_L1_B_296() : memref<32x32xf32, 2>
    %816 = adf.buffer.create @L1_L1_A_297() : memref<32x32xf32, 2>
    %817 = adf.buffer.create @L1_L1_B_297() : memref<32x32xf32, 2>
    %818 = adf.buffer.create @L1_L1_C_297() : memref<32x32xf32, 2>
    %819 = adf.buffer.create @L1_L1_A_298() : memref<32x32xf32, 2>
    %820 = adf.buffer.create @L1_L1_B_298() : memref<32x32xf32, 2>
    %821 = adf.buffer.create @L1_L1_C_298() : memref<32x32xf32, 2>
    %822 = adf.buffer.create @L1_L1_A_299() : memref<32x32xf32, 2>
    %823 = adf.buffer.create @L1_L1_B_299() : memref<32x32xf32, 2>
    %824 = adf.buffer.create @L1_L1_C_299() : memref<32x32xf32, 2>
    %825 = adf.buffer.create @L1_L1_A_300() : memref<32x32xf32, 2>
    %826 = adf.buffer.create @L1_L1_B_300() : memref<32x32xf32, 2>
    %827 = adf.buffer.create @L1_L1_A_301() : memref<32x32xf32, 2>
    %828 = adf.buffer.create @L1_L1_B_301() : memref<32x32xf32, 2>
    %829 = adf.buffer.create @L1_L1_C_301() : memref<32x32xf32, 2>
    %830 = adf.buffer.create @L1_L1_A_302() : memref<32x32xf32, 2>
    %831 = adf.buffer.create @L1_L1_B_302() : memref<32x32xf32, 2>
    %832 = adf.buffer.create @L1_L1_C_302() : memref<32x32xf32, 2>
    %833 = adf.buffer.create @L1_L1_A_303() : memref<32x32xf32, 2>
    %834 = adf.buffer.create @L1_L1_B_303() : memref<32x32xf32, 2>
    %835 = adf.buffer.create @L1_L1_C_303() : memref<32x32xf32, 2>
    %836 = adf.buffer.create @L1_L1_A_304() : memref<32x32xf32, 2>
    %837 = adf.buffer.create @L1_L1_B_304() : memref<32x32xf32, 2>
    %838 = adf.buffer.create @L1_L1_A_305() : memref<32x32xf32, 2>
    %839 = adf.buffer.create @L1_L1_B_305() : memref<32x32xf32, 2>
    %840 = adf.buffer.create @L1_L1_C_305() : memref<32x32xf32, 2>
    %841 = adf.buffer.create @L1_L1_A_306() : memref<32x32xf32, 2>
    %842 = adf.buffer.create @L1_L1_B_306() : memref<32x32xf32, 2>
    %843 = adf.buffer.create @L1_L1_C_306() : memref<32x32xf32, 2>
    %844 = adf.buffer.create @L1_L1_A_307() : memref<32x32xf32, 2>
    %845 = adf.buffer.create @L1_L1_B_307() : memref<32x32xf32, 2>
    %846 = adf.buffer.create @L1_L1_C_307() : memref<32x32xf32, 2>
    %847 = adf.buffer.create @L1_L1_A_308() : memref<32x32xf32, 2>
    %848 = adf.buffer.create @L1_L1_B_308() : memref<32x32xf32, 2>
    %849 = adf.buffer.create @L1_L1_A_309() : memref<32x32xf32, 2>
    %850 = adf.buffer.create @L1_L1_B_309() : memref<32x32xf32, 2>
    %851 = adf.buffer.create @L1_L1_C_309() : memref<32x32xf32, 2>
    %852 = adf.buffer.create @L1_L1_A_310() : memref<32x32xf32, 2>
    %853 = adf.buffer.create @L1_L1_B_310() : memref<32x32xf32, 2>
    %854 = adf.buffer.create @L1_L1_C_310() : memref<32x32xf32, 2>
    %855 = adf.buffer.create @L1_L1_A_311() : memref<32x32xf32, 2>
    %856 = adf.buffer.create @L1_L1_B_311() : memref<32x32xf32, 2>
    %857 = adf.buffer.create @L1_L1_C_311() : memref<32x32xf32, 2>
    %858 = adf.buffer.create @L1_L1_A_312() : memref<32x32xf32, 2>
    %859 = adf.buffer.create @L1_L1_B_312() : memref<32x32xf32, 2>
    %860 = adf.buffer.create @L1_L1_A_313() : memref<32x32xf32, 2>
    %861 = adf.buffer.create @L1_L1_B_313() : memref<32x32xf32, 2>
    %862 = adf.buffer.create @L1_L1_C_313() : memref<32x32xf32, 2>
    %863 = adf.buffer.create @L1_L1_A_314() : memref<32x32xf32, 2>
    %864 = adf.buffer.create @L1_L1_B_314() : memref<32x32xf32, 2>
    %865 = adf.buffer.create @L1_L1_C_314() : memref<32x32xf32, 2>
    %866 = adf.buffer.create @L1_L1_A_315() : memref<32x32xf32, 2>
    %867 = adf.buffer.create @L1_L1_B_315() : memref<32x32xf32, 2>
    %868 = adf.buffer.create @L1_L1_C_315() : memref<32x32xf32, 2>
    %869 = adf.buffer.create @L1_L1_A_316() : memref<32x32xf32, 2>
    %870 = adf.buffer.create @L1_L1_B_316() : memref<32x32xf32, 2>
    %871 = adf.buffer.create @L1_L1_A_317() : memref<32x32xf32, 2>
    %872 = adf.buffer.create @L1_L1_B_317() : memref<32x32xf32, 2>
    %873 = adf.buffer.create @L1_L1_C_317() : memref<32x32xf32, 2>
    %874 = adf.buffer.create @L1_L1_A_318() : memref<32x32xf32, 2>
    %875 = adf.buffer.create @L1_L1_B_318() : memref<32x32xf32, 2>
    %876 = adf.buffer.create @L1_L1_C_318() : memref<32x32xf32, 2>
    %877 = adf.buffer.create @L1_L1_A_319() : memref<32x32xf32, 2>
    %878 = adf.buffer.create @L1_L1_B_319() : memref<32x32xf32, 2>
    %879 = adf.buffer.create @L1_L1_C_319() : memref<32x32xf32, 2>
    %880 = adf.buffer.create @L1_L1_A_320() : memref<32x32xf32, 2>
    %881 = adf.buffer.create @L1_L1_B_320() : memref<32x32xf32, 2>
    %882 = adf.buffer.create @L1_L1_A_321() : memref<32x32xf32, 2>
    %883 = adf.buffer.create @L1_L1_B_321() : memref<32x32xf32, 2>
    %884 = adf.buffer.create @L1_L1_C_321() : memref<32x32xf32, 2>
    %885 = adf.buffer.create @L1_L1_A_322() : memref<32x32xf32, 2>
    %886 = adf.buffer.create @L1_L1_B_322() : memref<32x32xf32, 2>
    %887 = adf.buffer.create @L1_L1_C_322() : memref<32x32xf32, 2>
    %888 = adf.buffer.create @L1_L1_A_323() : memref<32x32xf32, 2>
    %889 = adf.buffer.create @L1_L1_B_323() : memref<32x32xf32, 2>
    %890 = adf.buffer.create @L1_L1_C_323() : memref<32x32xf32, 2>
    %891 = adf.buffer.create @L1_L1_A_324() : memref<32x32xf32, 2>
    %892 = adf.buffer.create @L1_L1_B_324() : memref<32x32xf32, 2>
    %893 = adf.buffer.create @L1_L1_A_325() : memref<32x32xf32, 2>
    %894 = adf.buffer.create @L1_L1_B_325() : memref<32x32xf32, 2>
    %895 = adf.buffer.create @L1_L1_C_325() : memref<32x32xf32, 2>
    %896 = adf.buffer.create @L1_L1_A_326() : memref<32x32xf32, 2>
    %897 = adf.buffer.create @L1_L1_B_326() : memref<32x32xf32, 2>
    %898 = adf.buffer.create @L1_L1_C_326() : memref<32x32xf32, 2>
    %899 = adf.buffer.create @L1_L1_A_327() : memref<32x32xf32, 2>
    %900 = adf.buffer.create @L1_L1_B_327() : memref<32x32xf32, 2>
    %901 = adf.buffer.create @L1_L1_C_327() : memref<32x32xf32, 2>
    %902 = adf.buffer.create @L1_L1_A_328() : memref<32x32xf32, 2>
    %903 = adf.buffer.create @L1_L1_B_328() : memref<32x32xf32, 2>
    %904 = adf.buffer.create @L1_L1_A_329() : memref<32x32xf32, 2>
    %905 = adf.buffer.create @L1_L1_B_329() : memref<32x32xf32, 2>
    %906 = adf.buffer.create @L1_L1_C_329() : memref<32x32xf32, 2>
    %907 = adf.buffer.create @L1_L1_A_330() : memref<32x32xf32, 2>
    %908 = adf.buffer.create @L1_L1_B_330() : memref<32x32xf32, 2>
    %909 = adf.buffer.create @L1_L1_C_330() : memref<32x32xf32, 2>
    %910 = adf.buffer.create @L1_L1_A_331() : memref<32x32xf32, 2>
    %911 = adf.buffer.create @L1_L1_B_331() : memref<32x32xf32, 2>
    %912 = adf.buffer.create @L1_L1_C_331() : memref<32x32xf32, 2>
    %913 = adf.buffer.create @L1_L1_A_332() : memref<32x32xf32, 2>
    %914 = adf.buffer.create @L1_L1_B_332() : memref<32x32xf32, 2>
    %915 = adf.buffer.create @L1_L1_A_333() : memref<32x32xf32, 2>
    %916 = adf.buffer.create @L1_L1_B_333() : memref<32x32xf32, 2>
    %917 = adf.buffer.create @L1_L1_C_333() : memref<32x32xf32, 2>
    %918 = adf.buffer.create @L1_L1_A_334() : memref<32x32xf32, 2>
    %919 = adf.buffer.create @L1_L1_B_334() : memref<32x32xf32, 2>
    %920 = adf.buffer.create @L1_L1_C_334() : memref<32x32xf32, 2>
    %921 = adf.buffer.create @L1_L1_A_335() : memref<32x32xf32, 2>
    %922 = adf.buffer.create @L1_L1_B_335() : memref<32x32xf32, 2>
    %923 = adf.buffer.create @L1_L1_C_335() : memref<32x32xf32, 2>
    %924 = adf.buffer.create @L1_L1_A_336() : memref<32x32xf32, 2>
    %925 = adf.buffer.create @L1_L1_B_336() : memref<32x32xf32, 2>
    %926 = adf.buffer.create @L1_L1_A_337() : memref<32x32xf32, 2>
    %927 = adf.buffer.create @L1_L1_B_337() : memref<32x32xf32, 2>
    %928 = adf.buffer.create @L1_L1_C_337() : memref<32x32xf32, 2>
    %929 = adf.buffer.create @L1_L1_A_338() : memref<32x32xf32, 2>
    %930 = adf.buffer.create @L1_L1_B_338() : memref<32x32xf32, 2>
    %931 = adf.buffer.create @L1_L1_C_338() : memref<32x32xf32, 2>
    %932 = adf.buffer.create @L1_L1_A_339() : memref<32x32xf32, 2>
    %933 = adf.buffer.create @L1_L1_B_339() : memref<32x32xf32, 2>
    %934 = adf.buffer.create @L1_L1_C_339() : memref<32x32xf32, 2>
    %935 = adf.buffer.create @L1_L1_A_340() : memref<32x32xf32, 2>
    %936 = adf.buffer.create @L1_L1_B_340() : memref<32x32xf32, 2>
    %937 = adf.buffer.create @L1_L1_A_341() : memref<32x32xf32, 2>
    %938 = adf.buffer.create @L1_L1_B_341() : memref<32x32xf32, 2>
    %939 = adf.buffer.create @L1_L1_C_341() : memref<32x32xf32, 2>
    %940 = adf.buffer.create @L1_L1_A_342() : memref<32x32xf32, 2>
    %941 = adf.buffer.create @L1_L1_B_342() : memref<32x32xf32, 2>
    %942 = adf.buffer.create @L1_L1_C_342() : memref<32x32xf32, 2>
    %943 = adf.buffer.create @L1_L1_A_343() : memref<32x32xf32, 2>
    %944 = adf.buffer.create @L1_L1_B_343() : memref<32x32xf32, 2>
    %945 = adf.buffer.create @L1_L1_C_343() : memref<32x32xf32, 2>
    %946 = adf.buffer.create @L1_L1_A_344() : memref<32x32xf32, 2>
    %947 = adf.buffer.create @L1_L1_B_344() : memref<32x32xf32, 2>
    %948 = adf.buffer.create @L1_L1_A_345() : memref<32x32xf32, 2>
    %949 = adf.buffer.create @L1_L1_B_345() : memref<32x32xf32, 2>
    %950 = adf.buffer.create @L1_L1_C_345() : memref<32x32xf32, 2>
    %951 = adf.buffer.create @L1_L1_A_346() : memref<32x32xf32, 2>
    %952 = adf.buffer.create @L1_L1_B_346() : memref<32x32xf32, 2>
    %953 = adf.buffer.create @L1_L1_C_346() : memref<32x32xf32, 2>
    %954 = adf.buffer.create @L1_L1_A_347() : memref<32x32xf32, 2>
    %955 = adf.buffer.create @L1_L1_B_347() : memref<32x32xf32, 2>
    %956 = adf.buffer.create @L1_L1_C_347() : memref<32x32xf32, 2>
    %957 = adf.buffer.create @L1_L1_A_348() : memref<32x32xf32, 2>
    %958 = adf.buffer.create @L1_L1_B_348() : memref<32x32xf32, 2>
    %959 = adf.buffer.create @L1_L1_A_349() : memref<32x32xf32, 2>
    %960 = adf.buffer.create @L1_L1_B_349() : memref<32x32xf32, 2>
    %961 = adf.buffer.create @L1_L1_C_349() : memref<32x32xf32, 2>
    %962 = adf.buffer.create @L1_L1_A_350() : memref<32x32xf32, 2>
    %963 = adf.buffer.create @L1_L1_B_350() : memref<32x32xf32, 2>
    %964 = adf.buffer.create @L1_L1_C_350() : memref<32x32xf32, 2>
    %965 = adf.buffer.create @L1_L1_A_351() : memref<32x32xf32, 2>
    %966 = adf.buffer.create @L1_L1_B_351() : memref<32x32xf32, 2>
    %967 = adf.buffer.create @L1_L1_C_351() : memref<32x32xf32, 2>
    adf.connect(%arg0, %0) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %1) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %968 = call @kernel_gemm0(%0, %1) {adf.kernel, "col, row" = [3 : index, 0 : index], ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 0 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%968, %c3, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%1, %c2, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%0, %c3, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %2) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %3) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%968, %4) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %969 = call @kernel_gemm(%2, %3, %4) {adf.kernel, "col, row" = [4 : index, 0 : index], ivs = [1 : index, 0 : index, 0 : index], kernel_gemm = 1 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%969, %c4, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%3, %c3, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%2, %c4, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %5) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %6) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%969, %7) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %970 = call @kernel_gemm(%5, %6, %7) {adf.kernel, "col, row" = [5 : index, 0 : index], ivs = [2 : index, 0 : index, 0 : index], kernel_gemm = 2 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%970, %c5, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%6, %c4, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%5, %c5, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %8) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %9) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%970, %10) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %971 = call @kernel_gemm(%8, %9, %10) {adf.kernel, "col, row" = [6 : index, 0 : index], ivs = [3 : index, 0 : index, 0 : index], kernel_gemm = 3 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%971, %c6, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%9, %c5, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%8, %c6, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%971, %arg8) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %11) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %12) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %972 = call @kernel_gemm0(%11, %12) {adf.kernel, "col, row" = [3 : index, 1 : index], ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 4 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%972, %c4, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%12, %c3, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%11, %c3, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %13) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %14) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%972, %15) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %973 = call @kernel_gemm(%13, %14, %15) {adf.kernel, "col, row" = [4 : index, 1 : index], ivs = [1 : index, 1 : index, 0 : index], kernel_gemm = 5 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%973, %c5, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%14, %c4, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%13, %c4, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %16) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %17) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%973, %18) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %974 = call @kernel_gemm(%16, %17, %18) {adf.kernel, "col, row" = [5 : index, 1 : index], ivs = [2 : index, 1 : index, 0 : index], kernel_gemm = 6 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%974, %c6, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%17, %c5, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%16, %c5, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %19) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %20) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%974, %21) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %975 = call @kernel_gemm(%19, %20, %21) {adf.kernel, "col, row" = [6 : index, 1 : index], ivs = [3 : index, 1 : index, 0 : index], kernel_gemm = 7 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%975, %c7, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%20, %c6, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%19, %c6, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%975, %arg13) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %22) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %23) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %976 = call @kernel_gemm0(%22, %23) {adf.kernel, "col, row" = [3 : index, 2 : index], ivs = [0 : index, 2 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 8 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%976, %c3, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%23, %c3, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%22, %c3, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %24) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %25) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%976, %26) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %977 = call @kernel_gemm(%24, %25, %26) {adf.kernel, "col, row" = [4 : index, 2 : index], ivs = [1 : index, 2 : index, 0 : index], kernel_gemm = 9 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%977, %c4, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%25, %c4, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%24, %c4, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %27) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %28) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%977, %29) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %978 = call @kernel_gemm(%27, %28, %29) {adf.kernel, "col, row" = [5 : index, 2 : index], ivs = [2 : index, 2 : index, 0 : index], kernel_gemm = 10 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%978, %c5, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%28, %c5, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%27, %c5, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %30) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %31) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%978, %32) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %979 = call @kernel_gemm(%30, %31, %32) {adf.kernel, "col, row" = [6 : index, 2 : index], ivs = [3 : index, 2 : index, 0 : index], kernel_gemm = 11 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%979, %c6, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%31, %c6, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%30, %c6, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%979, %arg18) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %33) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %34) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %980 = call @kernel_gemm0(%33, %34) {adf.kernel, "col, row" = [3 : index, 3 : index], ivs = [0 : index, 3 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 12 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%980, %c4, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%34, %c3, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%33, %c3, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %35) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %36) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%980, %37) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %981 = call @kernel_gemm(%35, %36, %37) {adf.kernel, "col, row" = [4 : index, 3 : index], ivs = [1 : index, 3 : index, 0 : index], kernel_gemm = 13 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%981, %c5, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%36, %c4, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%35, %c4, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %38) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %39) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%981, %40) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %982 = call @kernel_gemm(%38, %39, %40) {adf.kernel, "col, row" = [5 : index, 3 : index], ivs = [2 : index, 3 : index, 0 : index], kernel_gemm = 14 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%982, %c6, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%39, %c5, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%38, %c5, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %41) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %42) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%982, %43) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %983 = call @kernel_gemm(%41, %42, %43) {adf.kernel, "col, row" = [6 : index, 3 : index], ivs = [3 : index, 3 : index, 0 : index], kernel_gemm = 15 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%983, %c7, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%42, %c6, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%41, %c6, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%983, %arg23) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %44) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %45) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %984 = call @kernel_gemm0(%44, %45) {adf.kernel, "col, row" = [3 : index, 4 : index], ivs = [0 : index, 4 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 16 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%984, %c3, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%45, %c3, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%44, %c3, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %46) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %47) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%984, %48) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %985 = call @kernel_gemm(%46, %47, %48) {adf.kernel, "col, row" = [4 : index, 4 : index], ivs = [1 : index, 4 : index, 0 : index], kernel_gemm = 17 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%985, %c4, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%47, %c4, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%46, %c4, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %49) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %50) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%985, %51) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %986 = call @kernel_gemm(%49, %50, %51) {adf.kernel, "col, row" = [5 : index, 4 : index], ivs = [2 : index, 4 : index, 0 : index], kernel_gemm = 18 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%986, %c5, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%50, %c5, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%49, %c5, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %52) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %53) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%986, %54) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %987 = call @kernel_gemm(%52, %53, %54) {adf.kernel, "col, row" = [6 : index, 4 : index], ivs = [3 : index, 4 : index, 0 : index], kernel_gemm = 19 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%987, %c6, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%53, %c6, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%52, %c6, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%987, %arg28) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %55) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %56) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %988 = call @kernel_gemm0(%55, %56) {adf.kernel, "col, row" = [3 : index, 5 : index], ivs = [0 : index, 5 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 20 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%988, %c4, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%56, %c3, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%55, %c3, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %57) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %58) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%988, %59) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %989 = call @kernel_gemm(%57, %58, %59) {adf.kernel, "col, row" = [4 : index, 5 : index], ivs = [1 : index, 5 : index, 0 : index], kernel_gemm = 21 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%989, %c5, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%58, %c4, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%57, %c4, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %60) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %61) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%989, %62) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %990 = call @kernel_gemm(%60, %61, %62) {adf.kernel, "col, row" = [5 : index, 5 : index], ivs = [2 : index, 5 : index, 0 : index], kernel_gemm = 22 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%990, %c6, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%61, %c5, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%60, %c5, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %63) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %64) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%990, %65) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %991 = call @kernel_gemm(%63, %64, %65) {adf.kernel, "col, row" = [6 : index, 5 : index], ivs = [3 : index, 5 : index, 0 : index], kernel_gemm = 23 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%991, %c7, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%64, %c6, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%63, %c6, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%991, %arg33) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %66) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %67) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %992 = call @kernel_gemm0(%66, %67) {adf.kernel, "col, row" = [3 : index, 6 : index], ivs = [0 : index, 6 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 24 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%992, %c3, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%67, %c3, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%66, %c3, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %68) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %69) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%992, %70) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %993 = call @kernel_gemm(%68, %69, %70) {adf.kernel, "col, row" = [4 : index, 6 : index], ivs = [1 : index, 6 : index, 0 : index], kernel_gemm = 25 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%993, %c4, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%69, %c4, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%68, %c4, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %71) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %72) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%993, %73) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %994 = call @kernel_gemm(%71, %72, %73) {adf.kernel, "col, row" = [5 : index, 6 : index], ivs = [2 : index, 6 : index, 0 : index], kernel_gemm = 26 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%994, %c5, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%72, %c5, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%71, %c5, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %74) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %75) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%994, %76) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %995 = call @kernel_gemm(%74, %75, %76) {adf.kernel, "col, row" = [6 : index, 6 : index], ivs = [3 : index, 6 : index, 0 : index], kernel_gemm = 27 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%995, %c6, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%75, %c6, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%74, %c6, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%995, %arg38) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %77) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %78) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %996 = call @kernel_gemm0(%77, %78) {adf.kernel, "col, row" = [3 : index, 7 : index], ivs = [0 : index, 7 : index, 0 : index], kernel = 0 : index, kernel_gemm0 = 28 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%996, %c4, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%78, %c3, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%77, %c3, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg2, %79) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %80) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%996, %81) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %997 = call @kernel_gemm(%79, %80, %81) {adf.kernel, "col, row" = [4 : index, 7 : index], ivs = [1 : index, 7 : index, 0 : index], kernel_gemm = 29 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%997, %c5, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%80, %c4, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%79, %c4, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg4, %82) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %83) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%997, %84) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %998 = call @kernel_gemm(%82, %83, %84) {adf.kernel, "col, row" = [5 : index, 7 : index], ivs = [2 : index, 7 : index, 0 : index], kernel_gemm = 30 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%998, %c6, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%83, %c5, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%82, %c5, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg6, %85) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %86) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%998, %87) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %999 = call @kernel_gemm(%85, %86, %87) {adf.kernel, "col, row" = [6 : index, 7 : index], ivs = [3 : index, 7 : index, 0 : index], kernel_gemm = 31 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%999, %c7, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%86, %c6, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%85, %c6, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%999, %arg43) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %88) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %89) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1000 = call @kernel_gemm0(%88, %89) {adf.kernel, "col, row" = [7 : index, 0 : index], ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 32 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1000, %c7, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%89, %c6, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%88, %c7, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %90) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %91) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1000, %92) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1001 = call @kernel_gemm(%90, %91, %92) {adf.kernel, "col, row" = [8 : index, 0 : index], ivs = [1 : index, 0 : index, 1 : index], kernel_gemm = 33 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1001, %c8, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%91, %c7, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%90, %c8, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %93) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %94) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1001, %95) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1002 = call @kernel_gemm(%93, %94, %95) {adf.kernel, "col, row" = [9 : index, 0 : index], ivs = [2 : index, 0 : index, 1 : index], kernel_gemm = 34 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1002, %c9, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%94, %c8, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%93, %c9, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %96) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %97) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1002, %98) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1003 = call @kernel_gemm(%96, %97, %98) {adf.kernel, "col, row" = [10 : index, 0 : index], ivs = [3 : index, 0 : index, 1 : index], kernel_gemm = 35 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1003, %c10, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%97, %c9, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%96, %c10, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1003, %arg48) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %99) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %100) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1004 = call @kernel_gemm0(%99, %100) {adf.kernel, "col, row" = [7 : index, 1 : index], ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 36 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1004, %c8, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%100, %c7, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%99, %c7, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %101) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %102) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1004, %103) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1005 = call @kernel_gemm(%101, %102, %103) {adf.kernel, "col, row" = [8 : index, 1 : index], ivs = [1 : index, 1 : index, 1 : index], kernel_gemm = 37 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1005, %c9, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%102, %c8, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%101, %c8, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %104) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %105) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1005, %106) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1006 = call @kernel_gemm(%104, %105, %106) {adf.kernel, "col, row" = [9 : index, 1 : index], ivs = [2 : index, 1 : index, 1 : index], kernel_gemm = 38 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1006, %c10, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%105, %c9, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%104, %c9, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %107) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %108) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1006, %109) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1007 = call @kernel_gemm(%107, %108, %109) {adf.kernel, "col, row" = [10 : index, 1 : index], ivs = [3 : index, 1 : index, 1 : index], kernel_gemm = 39 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1007, %c11, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%108, %c10, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%107, %c10, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1007, %arg49) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %110) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %111) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1008 = call @kernel_gemm0(%110, %111) {adf.kernel, "col, row" = [7 : index, 2 : index], ivs = [0 : index, 2 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 40 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1008, %c7, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%111, %c7, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%110, %c7, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %112) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %113) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1008, %114) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1009 = call @kernel_gemm(%112, %113, %114) {adf.kernel, "col, row" = [8 : index, 2 : index], ivs = [1 : index, 2 : index, 1 : index], kernel_gemm = 41 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1009, %c8, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%113, %c8, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%112, %c8, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %115) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %116) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1009, %117) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1010 = call @kernel_gemm(%115, %116, %117) {adf.kernel, "col, row" = [9 : index, 2 : index], ivs = [2 : index, 2 : index, 1 : index], kernel_gemm = 42 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1010, %c9, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%116, %c9, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%115, %c9, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %118) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %119) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1010, %120) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1011 = call @kernel_gemm(%118, %119, %120) {adf.kernel, "col, row" = [10 : index, 2 : index], ivs = [3 : index, 2 : index, 1 : index], kernel_gemm = 43 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1011, %c10, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%119, %c10, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%118, %c10, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1011, %arg50) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %121) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %122) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1012 = call @kernel_gemm0(%121, %122) {adf.kernel, "col, row" = [7 : index, 3 : index], ivs = [0 : index, 3 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 44 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1012, %c8, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%122, %c7, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%121, %c7, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %123) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %124) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1012, %125) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1013 = call @kernel_gemm(%123, %124, %125) {adf.kernel, "col, row" = [8 : index, 3 : index], ivs = [1 : index, 3 : index, 1 : index], kernel_gemm = 45 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1013, %c9, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%124, %c8, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%123, %c8, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %126) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %127) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1013, %128) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1014 = call @kernel_gemm(%126, %127, %128) {adf.kernel, "col, row" = [9 : index, 3 : index], ivs = [2 : index, 3 : index, 1 : index], kernel_gemm = 46 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1014, %c10, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%127, %c9, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%126, %c9, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %129) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %130) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1014, %131) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1015 = call @kernel_gemm(%129, %130, %131) {adf.kernel, "col, row" = [10 : index, 3 : index], ivs = [3 : index, 3 : index, 1 : index], kernel_gemm = 47 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1015, %c11, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%130, %c10, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%129, %c10, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1015, %arg51) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %132) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %133) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1016 = call @kernel_gemm0(%132, %133) {adf.kernel, "col, row" = [7 : index, 4 : index], ivs = [0 : index, 4 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 48 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1016, %c7, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%133, %c7, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%132, %c7, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %134) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %135) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1016, %136) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1017 = call @kernel_gemm(%134, %135, %136) {adf.kernel, "col, row" = [8 : index, 4 : index], ivs = [1 : index, 4 : index, 1 : index], kernel_gemm = 49 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1017, %c8, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%135, %c8, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%134, %c8, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %137) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %138) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1017, %139) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1018 = call @kernel_gemm(%137, %138, %139) {adf.kernel, "col, row" = [9 : index, 4 : index], ivs = [2 : index, 4 : index, 1 : index], kernel_gemm = 50 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1018, %c9, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%138, %c9, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%137, %c9, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %140) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %141) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1018, %142) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1019 = call @kernel_gemm(%140, %141, %142) {adf.kernel, "col, row" = [10 : index, 4 : index], ivs = [3 : index, 4 : index, 1 : index], kernel_gemm = 51 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1019, %c10, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%141, %c10, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%140, %c10, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1019, %arg52) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %143) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %144) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1020 = call @kernel_gemm0(%143, %144) {adf.kernel, "col, row" = [7 : index, 5 : index], ivs = [0 : index, 5 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 52 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1020, %c8, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%144, %c7, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%143, %c7, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %145) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %146) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1020, %147) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1021 = call @kernel_gemm(%145, %146, %147) {adf.kernel, "col, row" = [8 : index, 5 : index], ivs = [1 : index, 5 : index, 1 : index], kernel_gemm = 53 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1021, %c9, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%146, %c8, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%145, %c8, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %148) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %149) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1021, %150) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1022 = call @kernel_gemm(%148, %149, %150) {adf.kernel, "col, row" = [9 : index, 5 : index], ivs = [2 : index, 5 : index, 1 : index], kernel_gemm = 54 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1022, %c10, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%149, %c9, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%148, %c9, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %151) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %152) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1022, %153) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1023 = call @kernel_gemm(%151, %152, %153) {adf.kernel, "col, row" = [10 : index, 5 : index], ivs = [3 : index, 5 : index, 1 : index], kernel_gemm = 55 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1023, %c11, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%152, %c10, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%151, %c10, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1023, %arg53) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %154) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %155) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1024 = call @kernel_gemm0(%154, %155) {adf.kernel, "col, row" = [7 : index, 6 : index], ivs = [0 : index, 6 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 56 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1024, %c7, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%155, %c7, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%154, %c7, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %156) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %157) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1024, %158) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1025 = call @kernel_gemm(%156, %157, %158) {adf.kernel, "col, row" = [8 : index, 6 : index], ivs = [1 : index, 6 : index, 1 : index], kernel_gemm = 57 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1025, %c8, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%157, %c8, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%156, %c8, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %159) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %160) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1025, %161) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1026 = call @kernel_gemm(%159, %160, %161) {adf.kernel, "col, row" = [9 : index, 6 : index], ivs = [2 : index, 6 : index, 1 : index], kernel_gemm = 58 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1026, %c9, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%160, %c9, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%159, %c9, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %162) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %163) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1026, %164) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1027 = call @kernel_gemm(%162, %163, %164) {adf.kernel, "col, row" = [10 : index, 6 : index], ivs = [3 : index, 6 : index, 1 : index], kernel_gemm = 59 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1027, %c10, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%163, %c10, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%162, %c10, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1027, %arg54) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg44, %165) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %166) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1028 = call @kernel_gemm0(%165, %166) {adf.kernel, "col, row" = [7 : index, 7 : index], ivs = [0 : index, 7 : index, 1 : index], kernel = 0 : index, kernel_gemm0 = 60 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1028, %c8, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%166, %c7, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%165, %c7, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg45, %167) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %168) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1028, %169) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1029 = call @kernel_gemm(%167, %168, %169) {adf.kernel, "col, row" = [8 : index, 7 : index], ivs = [1 : index, 7 : index, 1 : index], kernel_gemm = 61 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1029, %c9, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%168, %c8, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%167, %c8, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg46, %170) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %171) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1029, %172) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1030 = call @kernel_gemm(%170, %171, %172) {adf.kernel, "col, row" = [9 : index, 7 : index], ivs = [2 : index, 7 : index, 1 : index], kernel_gemm = 62 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1030, %c10, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%171, %c9, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%170, %c9, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg47, %173) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %174) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1030, %175) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1031 = call @kernel_gemm(%173, %174, %175) {adf.kernel, "col, row" = [10 : index, 7 : index], ivs = [3 : index, 7 : index, 1 : index], kernel_gemm = 63 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1031, %c11, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%174, %c10, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%173, %c10, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1031, %arg55) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %176) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %177) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1032 = call @kernel_gemm0(%176, %177) {adf.kernel, "col, row" = [11 : index, 0 : index], ivs = [0 : index, 0 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 64 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1032, %c11, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%177, %c10, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%176, %c11, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %178) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %179) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1032, %180) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1033 = call @kernel_gemm(%178, %179, %180) {adf.kernel, "col, row" = [12 : index, 0 : index], ivs = [1 : index, 0 : index, 2 : index], kernel_gemm = 65 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1033, %c12, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%179, %c11, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%178, %c12, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %181) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %182) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1033, %183) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1034 = call @kernel_gemm(%181, %182, %183) {adf.kernel, "col, row" = [13 : index, 0 : index], ivs = [2 : index, 0 : index, 2 : index], kernel_gemm = 66 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1034, %c13, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%182, %c12, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%181, %c13, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %184) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %185) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1034, %186) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1035 = call @kernel_gemm(%184, %185, %186) {adf.kernel, "col, row" = [14 : index, 0 : index], ivs = [3 : index, 0 : index, 2 : index], kernel_gemm = 67 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1035, %c14, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%185, %c13, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%184, %c14, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1035, %arg60) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %187) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %188) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1036 = call @kernel_gemm0(%187, %188) {adf.kernel, "col, row" = [11 : index, 1 : index], ivs = [0 : index, 1 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 68 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1036, %c12, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%188, %c11, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%187, %c11, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %189) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %190) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1036, %191) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1037 = call @kernel_gemm(%189, %190, %191) {adf.kernel, "col, row" = [12 : index, 1 : index], ivs = [1 : index, 1 : index, 2 : index], kernel_gemm = 69 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1037, %c13, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%190, %c12, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%189, %c12, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %192) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %193) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1037, %194) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1038 = call @kernel_gemm(%192, %193, %194) {adf.kernel, "col, row" = [13 : index, 1 : index], ivs = [2 : index, 1 : index, 2 : index], kernel_gemm = 70 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1038, %c14, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%193, %c13, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%192, %c13, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %195) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %196) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1038, %197) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1039 = call @kernel_gemm(%195, %196, %197) {adf.kernel, "col, row" = [14 : index, 1 : index], ivs = [3 : index, 1 : index, 2 : index], kernel_gemm = 71 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1039, %c15, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%196, %c14, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%195, %c14, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1039, %arg61) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %198) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %199) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1040 = call @kernel_gemm0(%198, %199) {adf.kernel, "col, row" = [11 : index, 2 : index], ivs = [0 : index, 2 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 72 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1040, %c11, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%199, %c11, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%198, %c11, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %200) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %201) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1040, %202) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1041 = call @kernel_gemm(%200, %201, %202) {adf.kernel, "col, row" = [12 : index, 2 : index], ivs = [1 : index, 2 : index, 2 : index], kernel_gemm = 73 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1041, %c12, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%201, %c12, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%200, %c12, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %203) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %204) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1041, %205) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1042 = call @kernel_gemm(%203, %204, %205) {adf.kernel, "col, row" = [13 : index, 2 : index], ivs = [2 : index, 2 : index, 2 : index], kernel_gemm = 74 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1042, %c13, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%204, %c13, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%203, %c13, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %206) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %207) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1042, %208) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1043 = call @kernel_gemm(%206, %207, %208) {adf.kernel, "col, row" = [14 : index, 2 : index], ivs = [3 : index, 2 : index, 2 : index], kernel_gemm = 75 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1043, %c14, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%207, %c14, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%206, %c14, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1043, %arg62) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %209) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %210) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1044 = call @kernel_gemm0(%209, %210) {adf.kernel, "col, row" = [11 : index, 3 : index], ivs = [0 : index, 3 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 76 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1044, %c12, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%210, %c11, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%209, %c11, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %211) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %212) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1044, %213) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1045 = call @kernel_gemm(%211, %212, %213) {adf.kernel, "col, row" = [12 : index, 3 : index], ivs = [1 : index, 3 : index, 2 : index], kernel_gemm = 77 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1045, %c13, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%212, %c12, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%211, %c12, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %214) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %215) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1045, %216) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1046 = call @kernel_gemm(%214, %215, %216) {adf.kernel, "col, row" = [13 : index, 3 : index], ivs = [2 : index, 3 : index, 2 : index], kernel_gemm = 78 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1046, %c14, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%215, %c13, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%214, %c13, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %217) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %218) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1046, %219) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1047 = call @kernel_gemm(%217, %218, %219) {adf.kernel, "col, row" = [14 : index, 3 : index], ivs = [3 : index, 3 : index, 2 : index], kernel_gemm = 79 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1047, %c15, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%218, %c14, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%217, %c14, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1047, %arg63) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %220) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %221) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1048 = call @kernel_gemm0(%220, %221) {adf.kernel, "col, row" = [11 : index, 4 : index], ivs = [0 : index, 4 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 80 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1048, %c11, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%221, %c11, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%220, %c11, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %222) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %223) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1048, %224) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1049 = call @kernel_gemm(%222, %223, %224) {adf.kernel, "col, row" = [12 : index, 4 : index], ivs = [1 : index, 4 : index, 2 : index], kernel_gemm = 81 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1049, %c12, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%223, %c12, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%222, %c12, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %225) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %226) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1049, %227) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1050 = call @kernel_gemm(%225, %226, %227) {adf.kernel, "col, row" = [13 : index, 4 : index], ivs = [2 : index, 4 : index, 2 : index], kernel_gemm = 82 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1050, %c13, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%226, %c13, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%225, %c13, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %228) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %229) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1050, %230) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1051 = call @kernel_gemm(%228, %229, %230) {adf.kernel, "col, row" = [14 : index, 4 : index], ivs = [3 : index, 4 : index, 2 : index], kernel_gemm = 83 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1051, %c14, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%229, %c14, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%228, %c14, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1051, %arg64) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %231) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %232) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1052 = call @kernel_gemm0(%231, %232) {adf.kernel, "col, row" = [11 : index, 5 : index], ivs = [0 : index, 5 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 84 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1052, %c12, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%232, %c11, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%231, %c11, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %233) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %234) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1052, %235) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1053 = call @kernel_gemm(%233, %234, %235) {adf.kernel, "col, row" = [12 : index, 5 : index], ivs = [1 : index, 5 : index, 2 : index], kernel_gemm = 85 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1053, %c13, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%234, %c12, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%233, %c12, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %236) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %237) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1053, %238) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1054 = call @kernel_gemm(%236, %237, %238) {adf.kernel, "col, row" = [13 : index, 5 : index], ivs = [2 : index, 5 : index, 2 : index], kernel_gemm = 86 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1054, %c14, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%237, %c13, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%236, %c13, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %239) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %240) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1054, %241) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1055 = call @kernel_gemm(%239, %240, %241) {adf.kernel, "col, row" = [14 : index, 5 : index], ivs = [3 : index, 5 : index, 2 : index], kernel_gemm = 87 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1055, %c15, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%240, %c14, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%239, %c14, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1055, %arg65) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %242) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %243) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1056 = call @kernel_gemm0(%242, %243) {adf.kernel, "col, row" = [11 : index, 6 : index], ivs = [0 : index, 6 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 88 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1056, %c11, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%243, %c11, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%242, %c11, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %244) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %245) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1056, %246) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1057 = call @kernel_gemm(%244, %245, %246) {adf.kernel, "col, row" = [12 : index, 6 : index], ivs = [1 : index, 6 : index, 2 : index], kernel_gemm = 89 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1057, %c12, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%245, %c12, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%244, %c12, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %247) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %248) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1057, %249) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1058 = call @kernel_gemm(%247, %248, %249) {adf.kernel, "col, row" = [13 : index, 6 : index], ivs = [2 : index, 6 : index, 2 : index], kernel_gemm = 90 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1058, %c13, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%248, %c13, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%247, %c13, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %250) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %251) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1058, %252) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1059 = call @kernel_gemm(%250, %251, %252) {adf.kernel, "col, row" = [14 : index, 6 : index], ivs = [3 : index, 6 : index, 2 : index], kernel_gemm = 91 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1059, %c14, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%251, %c14, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%250, %c14, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1059, %arg66) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg56, %253) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %254) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1060 = call @kernel_gemm0(%253, %254) {adf.kernel, "col, row" = [11 : index, 7 : index], ivs = [0 : index, 7 : index, 2 : index], kernel = 0 : index, kernel_gemm0 = 92 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1060, %c12, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%254, %c11, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%253, %c11, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg57, %255) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %256) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1060, %257) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1061 = call @kernel_gemm(%255, %256, %257) {adf.kernel, "col, row" = [12 : index, 7 : index], ivs = [1 : index, 7 : index, 2 : index], kernel_gemm = 93 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1061, %c13, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%256, %c12, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%255, %c12, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg58, %258) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %259) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1061, %260) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1062 = call @kernel_gemm(%258, %259, %260) {adf.kernel, "col, row" = [13 : index, 7 : index], ivs = [2 : index, 7 : index, 2 : index], kernel_gemm = 94 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1062, %c14, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%259, %c13, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%258, %c13, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg59, %261) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %262) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1062, %263) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1063 = call @kernel_gemm(%261, %262, %263) {adf.kernel, "col, row" = [14 : index, 7 : index], ivs = [3 : index, 7 : index, 2 : index], kernel_gemm = 95 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1063, %c15, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%262, %c14, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%261, %c14, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1063, %arg67) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %264) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %265) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1064 = call @kernel_gemm0(%264, %265) {adf.kernel, "col, row" = [15 : index, 0 : index], ivs = [0 : index, 0 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 96 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1064, %c15, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%265, %c14, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%264, %c15, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %266) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %267) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1064, %268) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1065 = call @kernel_gemm(%266, %267, %268) {adf.kernel, "col, row" = [16 : index, 0 : index], ivs = [1 : index, 0 : index, 3 : index], kernel_gemm = 97 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1065, %c16, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%267, %c15, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%266, %c16, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %269) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %270) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1065, %271) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1066 = call @kernel_gemm(%269, %270, %271) {adf.kernel, "col, row" = [17 : index, 0 : index], ivs = [2 : index, 0 : index, 3 : index], kernel_gemm = 98 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1066, %c17, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%270, %c16, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%269, %c17, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %272) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %273) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1066, %274) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1067 = call @kernel_gemm(%272, %273, %274) {adf.kernel, "col, row" = [18 : index, 0 : index], ivs = [3 : index, 0 : index, 3 : index], kernel_gemm = 99 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1067, %c18, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%273, %c17, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%272, %c18, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1067, %arg72) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %275) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %276) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1068 = call @kernel_gemm0(%275, %276) {adf.kernel, "col, row" = [15 : index, 1 : index], ivs = [0 : index, 1 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 100 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1068, %c16, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%276, %c15, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%275, %c15, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %277) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %278) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1068, %279) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1069 = call @kernel_gemm(%277, %278, %279) {adf.kernel, "col, row" = [16 : index, 1 : index], ivs = [1 : index, 1 : index, 3 : index], kernel_gemm = 101 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1069, %c17, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%278, %c16, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%277, %c16, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %280) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %281) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1069, %282) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1070 = call @kernel_gemm(%280, %281, %282) {adf.kernel, "col, row" = [17 : index, 1 : index], ivs = [2 : index, 1 : index, 3 : index], kernel_gemm = 102 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1070, %c18, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%281, %c17, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%280, %c17, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %283) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %284) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1070, %285) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1071 = call @kernel_gemm(%283, %284, %285) {adf.kernel, "col, row" = [18 : index, 1 : index], ivs = [3 : index, 1 : index, 3 : index], kernel_gemm = 103 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1071, %c19, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%284, %c18, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%283, %c18, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1071, %arg73) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %286) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %287) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1072 = call @kernel_gemm0(%286, %287) {adf.kernel, "col, row" = [15 : index, 2 : index], ivs = [0 : index, 2 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 104 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1072, %c15, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%287, %c15, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%286, %c15, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %288) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %289) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1072, %290) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1073 = call @kernel_gemm(%288, %289, %290) {adf.kernel, "col, row" = [16 : index, 2 : index], ivs = [1 : index, 2 : index, 3 : index], kernel_gemm = 105 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1073, %c16, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%289, %c16, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%288, %c16, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %291) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %292) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1073, %293) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1074 = call @kernel_gemm(%291, %292, %293) {adf.kernel, "col, row" = [17 : index, 2 : index], ivs = [2 : index, 2 : index, 3 : index], kernel_gemm = 106 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1074, %c17, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%292, %c17, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%291, %c17, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %294) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %295) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1074, %296) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1075 = call @kernel_gemm(%294, %295, %296) {adf.kernel, "col, row" = [18 : index, 2 : index], ivs = [3 : index, 2 : index, 3 : index], kernel_gemm = 107 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1075, %c18, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%295, %c18, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%294, %c18, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1075, %arg74) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %297) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %298) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1076 = call @kernel_gemm0(%297, %298) {adf.kernel, "col, row" = [15 : index, 3 : index], ivs = [0 : index, 3 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 108 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1076, %c16, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%298, %c15, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%297, %c15, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %299) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %300) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1076, %301) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1077 = call @kernel_gemm(%299, %300, %301) {adf.kernel, "col, row" = [16 : index, 3 : index], ivs = [1 : index, 3 : index, 3 : index], kernel_gemm = 109 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1077, %c17, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%300, %c16, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%299, %c16, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %302) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %303) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1077, %304) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1078 = call @kernel_gemm(%302, %303, %304) {adf.kernel, "col, row" = [17 : index, 3 : index], ivs = [2 : index, 3 : index, 3 : index], kernel_gemm = 110 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1078, %c18, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%303, %c17, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%302, %c17, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %305) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %306) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1078, %307) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1079 = call @kernel_gemm(%305, %306, %307) {adf.kernel, "col, row" = [18 : index, 3 : index], ivs = [3 : index, 3 : index, 3 : index], kernel_gemm = 111 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1079, %c19, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%306, %c18, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%305, %c18, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1079, %arg75) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %308) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %309) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1080 = call @kernel_gemm0(%308, %309) {adf.kernel, "col, row" = [15 : index, 4 : index], ivs = [0 : index, 4 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 112 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1080, %c15, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%309, %c15, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%308, %c15, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %310) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %311) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1080, %312) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1081 = call @kernel_gemm(%310, %311, %312) {adf.kernel, "col, row" = [16 : index, 4 : index], ivs = [1 : index, 4 : index, 3 : index], kernel_gemm = 113 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1081, %c16, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%311, %c16, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%310, %c16, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %313) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %314) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1081, %315) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1082 = call @kernel_gemm(%313, %314, %315) {adf.kernel, "col, row" = [17 : index, 4 : index], ivs = [2 : index, 4 : index, 3 : index], kernel_gemm = 114 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1082, %c17, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%314, %c17, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%313, %c17, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %316) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %317) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1082, %318) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1083 = call @kernel_gemm(%316, %317, %318) {adf.kernel, "col, row" = [18 : index, 4 : index], ivs = [3 : index, 4 : index, 3 : index], kernel_gemm = 115 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1083, %c18, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%317, %c18, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%316, %c18, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1083, %arg76) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %319) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %320) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1084 = call @kernel_gemm0(%319, %320) {adf.kernel, "col, row" = [15 : index, 5 : index], ivs = [0 : index, 5 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 116 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1084, %c16, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%320, %c15, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%319, %c15, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %321) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %322) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1084, %323) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1085 = call @kernel_gemm(%321, %322, %323) {adf.kernel, "col, row" = [16 : index, 5 : index], ivs = [1 : index, 5 : index, 3 : index], kernel_gemm = 117 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1085, %c17, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%322, %c16, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%321, %c16, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %324) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %325) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1085, %326) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1086 = call @kernel_gemm(%324, %325, %326) {adf.kernel, "col, row" = [17 : index, 5 : index], ivs = [2 : index, 5 : index, 3 : index], kernel_gemm = 118 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1086, %c18, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%325, %c17, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%324, %c17, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %327) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %328) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1086, %329) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1087 = call @kernel_gemm(%327, %328, %329) {adf.kernel, "col, row" = [18 : index, 5 : index], ivs = [3 : index, 5 : index, 3 : index], kernel_gemm = 119 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1087, %c19, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%328, %c18, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%327, %c18, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1087, %arg77) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %330) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %331) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1088 = call @kernel_gemm0(%330, %331) {adf.kernel, "col, row" = [15 : index, 6 : index], ivs = [0 : index, 6 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 120 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1088, %c15, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%331, %c15, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%330, %c15, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %332) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %333) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1088, %334) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1089 = call @kernel_gemm(%332, %333, %334) {adf.kernel, "col, row" = [16 : index, 6 : index], ivs = [1 : index, 6 : index, 3 : index], kernel_gemm = 121 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1089, %c16, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%333, %c16, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%332, %c16, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %335) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %336) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1089, %337) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1090 = call @kernel_gemm(%335, %336, %337) {adf.kernel, "col, row" = [17 : index, 6 : index], ivs = [2 : index, 6 : index, 3 : index], kernel_gemm = 122 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1090, %c17, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%336, %c17, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%335, %c17, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %338) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %339) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1090, %340) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1091 = call @kernel_gemm(%338, %339, %340) {adf.kernel, "col, row" = [18 : index, 6 : index], ivs = [3 : index, 6 : index, 3 : index], kernel_gemm = 123 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1091, %c18, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%339, %c18, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%338, %c18, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1091, %arg78) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg68, %341) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %342) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1092 = call @kernel_gemm0(%341, %342) {adf.kernel, "col, row" = [15 : index, 7 : index], ivs = [0 : index, 7 : index, 3 : index], kernel = 0 : index, kernel_gemm0 = 124 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1092, %c16, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%342, %c15, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%341, %c15, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg69, %343) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %344) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1092, %345) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1093 = call @kernel_gemm(%343, %344, %345) {adf.kernel, "col, row" = [16 : index, 7 : index], ivs = [1 : index, 7 : index, 3 : index], kernel_gemm = 125 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1093, %c17, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%344, %c16, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%343, %c16, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg70, %346) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %347) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1093, %348) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1094 = call @kernel_gemm(%346, %347, %348) {adf.kernel, "col, row" = [17 : index, 7 : index], ivs = [2 : index, 7 : index, 3 : index], kernel_gemm = 126 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1094, %c18, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%347, %c17, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%346, %c17, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg71, %349) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %350) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1094, %351) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1095 = call @kernel_gemm(%349, %350, %351) {adf.kernel, "col, row" = [18 : index, 7 : index], ivs = [3 : index, 7 : index, 3 : index], kernel_gemm = 127 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1095, %c19, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%350, %c18, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%349, %c18, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1095, %arg79) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %352) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %353) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1096 = call @kernel_gemm0(%352, %353) {adf.kernel, "col, row" = [19 : index, 0 : index], ivs = [0 : index, 0 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 128 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1096, %c19, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%353, %c18, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%352, %c19, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %354) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %355) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1096, %356) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1097 = call @kernel_gemm(%354, %355, %356) {adf.kernel, "col, row" = [20 : index, 0 : index], ivs = [1 : index, 0 : index, 4 : index], kernel_gemm = 129 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1097, %c20, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%355, %c19, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%354, %c20, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %357) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %358) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1097, %359) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1098 = call @kernel_gemm(%357, %358, %359) {adf.kernel, "col, row" = [21 : index, 0 : index], ivs = [2 : index, 0 : index, 4 : index], kernel_gemm = 130 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1098, %c21, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%358, %c20, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%357, %c21, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %360) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %361) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1098, %362) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1099 = call @kernel_gemm(%360, %361, %362) {adf.kernel, "col, row" = [22 : index, 0 : index], ivs = [3 : index, 0 : index, 4 : index], kernel_gemm = 131 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1099, %c22, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%361, %c21, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%360, %c22, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1099, %arg84) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %363) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %364) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1100 = call @kernel_gemm0(%363, %364) {adf.kernel, "col, row" = [19 : index, 1 : index], ivs = [0 : index, 1 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 132 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1100, %c20, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%364, %c19, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%363, %c19, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %365) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %366) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1100, %367) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1101 = call @kernel_gemm(%365, %366, %367) {adf.kernel, "col, row" = [20 : index, 1 : index], ivs = [1 : index, 1 : index, 4 : index], kernel_gemm = 133 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1101, %c21, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%366, %c20, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%365, %c20, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %368) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %369) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1101, %370) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1102 = call @kernel_gemm(%368, %369, %370) {adf.kernel, "col, row" = [21 : index, 1 : index], ivs = [2 : index, 1 : index, 4 : index], kernel_gemm = 134 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1102, %c22, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%369, %c21, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%368, %c21, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %371) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %372) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1102, %373) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1103 = call @kernel_gemm(%371, %372, %373) {adf.kernel, "col, row" = [22 : index, 1 : index], ivs = [3 : index, 1 : index, 4 : index], kernel_gemm = 135 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1103, %c23, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%372, %c22, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%371, %c22, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1103, %arg85) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %374) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %375) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1104 = call @kernel_gemm0(%374, %375) {adf.kernel, "col, row" = [19 : index, 2 : index], ivs = [0 : index, 2 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 136 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1104, %c19, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%375, %c19, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%374, %c19, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %376) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %377) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1104, %378) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1105 = call @kernel_gemm(%376, %377, %378) {adf.kernel, "col, row" = [20 : index, 2 : index], ivs = [1 : index, 2 : index, 4 : index], kernel_gemm = 137 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1105, %c20, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%377, %c20, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%376, %c20, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %379) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %380) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1105, %381) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1106 = call @kernel_gemm(%379, %380, %381) {adf.kernel, "col, row" = [21 : index, 2 : index], ivs = [2 : index, 2 : index, 4 : index], kernel_gemm = 138 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1106, %c21, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%380, %c21, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%379, %c21, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %382) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %383) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1106, %384) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1107 = call @kernel_gemm(%382, %383, %384) {adf.kernel, "col, row" = [22 : index, 2 : index], ivs = [3 : index, 2 : index, 4 : index], kernel_gemm = 139 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1107, %c22, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%383, %c22, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%382, %c22, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1107, %arg86) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %385) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %386) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1108 = call @kernel_gemm0(%385, %386) {adf.kernel, "col, row" = [19 : index, 3 : index], ivs = [0 : index, 3 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 140 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1108, %c20, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%386, %c19, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%385, %c19, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %387) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %388) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1108, %389) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1109 = call @kernel_gemm(%387, %388, %389) {adf.kernel, "col, row" = [20 : index, 3 : index], ivs = [1 : index, 3 : index, 4 : index], kernel_gemm = 141 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1109, %c21, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%388, %c20, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%387, %c20, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %390) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %391) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1109, %392) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1110 = call @kernel_gemm(%390, %391, %392) {adf.kernel, "col, row" = [21 : index, 3 : index], ivs = [2 : index, 3 : index, 4 : index], kernel_gemm = 142 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1110, %c22, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%391, %c21, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%390, %c21, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %393) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %394) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1110, %395) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1111 = call @kernel_gemm(%393, %394, %395) {adf.kernel, "col, row" = [22 : index, 3 : index], ivs = [3 : index, 3 : index, 4 : index], kernel_gemm = 143 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1111, %c23, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%394, %c22, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%393, %c22, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1111, %arg87) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %396) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %397) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1112 = call @kernel_gemm0(%396, %397) {adf.kernel, "col, row" = [19 : index, 4 : index], ivs = [0 : index, 4 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 144 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1112, %c19, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%397, %c19, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%396, %c19, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %398) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %399) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1112, %400) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1113 = call @kernel_gemm(%398, %399, %400) {adf.kernel, "col, row" = [20 : index, 4 : index], ivs = [1 : index, 4 : index, 4 : index], kernel_gemm = 145 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1113, %c20, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%399, %c20, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%398, %c20, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %401) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %402) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1113, %403) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1114 = call @kernel_gemm(%401, %402, %403) {adf.kernel, "col, row" = [21 : index, 4 : index], ivs = [2 : index, 4 : index, 4 : index], kernel_gemm = 146 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1114, %c21, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%402, %c21, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%401, %c21, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %404) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %405) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1114, %406) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1115 = call @kernel_gemm(%404, %405, %406) {adf.kernel, "col, row" = [22 : index, 4 : index], ivs = [3 : index, 4 : index, 4 : index], kernel_gemm = 147 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1115, %c22, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%405, %c22, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%404, %c22, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1115, %arg88) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %407) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %408) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1116 = call @kernel_gemm0(%407, %408) {adf.kernel, "col, row" = [19 : index, 5 : index], ivs = [0 : index, 5 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 148 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1116, %c20, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%408, %c19, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%407, %c19, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %409) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %410) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1116, %411) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1117 = call @kernel_gemm(%409, %410, %411) {adf.kernel, "col, row" = [20 : index, 5 : index], ivs = [1 : index, 5 : index, 4 : index], kernel_gemm = 149 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1117, %c21, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%410, %c20, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%409, %c20, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %412) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %413) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1117, %414) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1118 = call @kernel_gemm(%412, %413, %414) {adf.kernel, "col, row" = [21 : index, 5 : index], ivs = [2 : index, 5 : index, 4 : index], kernel_gemm = 150 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1118, %c22, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%413, %c21, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%412, %c21, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %415) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %416) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1118, %417) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1119 = call @kernel_gemm(%415, %416, %417) {adf.kernel, "col, row" = [22 : index, 5 : index], ivs = [3 : index, 5 : index, 4 : index], kernel_gemm = 151 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1119, %c23, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%416, %c22, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%415, %c22, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1119, %arg89) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %418) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %419) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1120 = call @kernel_gemm0(%418, %419) {adf.kernel, "col, row" = [19 : index, 6 : index], ivs = [0 : index, 6 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 152 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1120, %c19, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%419, %c19, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%418, %c19, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %420) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %421) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1120, %422) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1121 = call @kernel_gemm(%420, %421, %422) {adf.kernel, "col, row" = [20 : index, 6 : index], ivs = [1 : index, 6 : index, 4 : index], kernel_gemm = 153 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1121, %c20, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%421, %c20, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%420, %c20, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %423) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %424) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1121, %425) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1122 = call @kernel_gemm(%423, %424, %425) {adf.kernel, "col, row" = [21 : index, 6 : index], ivs = [2 : index, 6 : index, 4 : index], kernel_gemm = 154 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1122, %c21, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%424, %c21, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%423, %c21, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %426) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %427) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1122, %428) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1123 = call @kernel_gemm(%426, %427, %428) {adf.kernel, "col, row" = [22 : index, 6 : index], ivs = [3 : index, 6 : index, 4 : index], kernel_gemm = 155 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1123, %c22, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%427, %c22, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%426, %c22, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1123, %arg90) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg80, %429) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %430) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1124 = call @kernel_gemm0(%429, %430) {adf.kernel, "col, row" = [19 : index, 7 : index], ivs = [0 : index, 7 : index, 4 : index], kernel = 0 : index, kernel_gemm0 = 156 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1124, %c20, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%430, %c19, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%429, %c19, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg81, %431) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %432) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1124, %433) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1125 = call @kernel_gemm(%431, %432, %433) {adf.kernel, "col, row" = [20 : index, 7 : index], ivs = [1 : index, 7 : index, 4 : index], kernel_gemm = 157 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1125, %c21, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%432, %c20, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%431, %c20, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg82, %434) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %435) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1125, %436) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1126 = call @kernel_gemm(%434, %435, %436) {adf.kernel, "col, row" = [21 : index, 7 : index], ivs = [2 : index, 7 : index, 4 : index], kernel_gemm = 158 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1126, %c22, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%435, %c21, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%434, %c21, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg83, %437) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %438) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1126, %439) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1127 = call @kernel_gemm(%437, %438, %439) {adf.kernel, "col, row" = [22 : index, 7 : index], ivs = [3 : index, 7 : index, 4 : index], kernel_gemm = 159 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1127, %c23, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%438, %c22, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%437, %c22, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1127, %arg91) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %440) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %441) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1128 = call @kernel_gemm0(%440, %441) {adf.kernel, "col, row" = [23 : index, 0 : index], ivs = [0 : index, 0 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 160 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1128, %c23, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%441, %c22, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%440, %c23, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %442) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %443) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1128, %444) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1129 = call @kernel_gemm(%442, %443, %444) {adf.kernel, "col, row" = [24 : index, 0 : index], ivs = [1 : index, 0 : index, 5 : index], kernel_gemm = 161 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1129, %c24, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%443, %c23, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%442, %c24, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %445) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %446) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1129, %447) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1130 = call @kernel_gemm(%445, %446, %447) {adf.kernel, "col, row" = [25 : index, 0 : index], ivs = [2 : index, 0 : index, 5 : index], kernel_gemm = 162 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1130, %c25, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%446, %c24, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%445, %c25, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %448) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %449) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1130, %450) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1131 = call @kernel_gemm(%448, %449, %450) {adf.kernel, "col, row" = [26 : index, 0 : index], ivs = [3 : index, 0 : index, 5 : index], kernel_gemm = 163 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1131, %c26, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%449, %c25, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%448, %c26, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1131, %arg96) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %451) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %452) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1132 = call @kernel_gemm0(%451, %452) {adf.kernel, "col, row" = [23 : index, 1 : index], ivs = [0 : index, 1 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 164 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1132, %c24, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%452, %c23, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%451, %c23, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %453) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %454) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1132, %455) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1133 = call @kernel_gemm(%453, %454, %455) {adf.kernel, "col, row" = [24 : index, 1 : index], ivs = [1 : index, 1 : index, 5 : index], kernel_gemm = 165 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1133, %c25, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%454, %c24, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%453, %c24, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %456) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %457) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1133, %458) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1134 = call @kernel_gemm(%456, %457, %458) {adf.kernel, "col, row" = [25 : index, 1 : index], ivs = [2 : index, 1 : index, 5 : index], kernel_gemm = 166 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1134, %c26, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%457, %c25, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%456, %c25, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %459) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %460) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1134, %461) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1135 = call @kernel_gemm(%459, %460, %461) {adf.kernel, "col, row" = [26 : index, 1 : index], ivs = [3 : index, 1 : index, 5 : index], kernel_gemm = 167 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1135, %c27, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%460, %c26, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%459, %c26, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1135, %arg97) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %462) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %463) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1136 = call @kernel_gemm0(%462, %463) {adf.kernel, "col, row" = [23 : index, 2 : index], ivs = [0 : index, 2 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 168 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1136, %c23, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%463, %c23, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%462, %c23, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %464) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %465) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1136, %466) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1137 = call @kernel_gemm(%464, %465, %466) {adf.kernel, "col, row" = [24 : index, 2 : index], ivs = [1 : index, 2 : index, 5 : index], kernel_gemm = 169 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1137, %c24, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%465, %c24, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%464, %c24, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %467) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %468) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1137, %469) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1138 = call @kernel_gemm(%467, %468, %469) {adf.kernel, "col, row" = [25 : index, 2 : index], ivs = [2 : index, 2 : index, 5 : index], kernel_gemm = 170 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1138, %c25, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%468, %c25, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%467, %c25, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %470) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %471) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1138, %472) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1139 = call @kernel_gemm(%470, %471, %472) {adf.kernel, "col, row" = [26 : index, 2 : index], ivs = [3 : index, 2 : index, 5 : index], kernel_gemm = 171 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1139, %c26, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%471, %c26, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%470, %c26, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1139, %arg98) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %473) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %474) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1140 = call @kernel_gemm0(%473, %474) {adf.kernel, "col, row" = [23 : index, 3 : index], ivs = [0 : index, 3 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 172 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1140, %c24, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%474, %c23, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%473, %c23, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %475) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %476) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1140, %477) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1141 = call @kernel_gemm(%475, %476, %477) {adf.kernel, "col, row" = [24 : index, 3 : index], ivs = [1 : index, 3 : index, 5 : index], kernel_gemm = 173 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1141, %c25, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%476, %c24, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%475, %c24, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %478) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %479) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1141, %480) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1142 = call @kernel_gemm(%478, %479, %480) {adf.kernel, "col, row" = [25 : index, 3 : index], ivs = [2 : index, 3 : index, 5 : index], kernel_gemm = 174 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1142, %c26, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%479, %c25, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%478, %c25, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %481) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %482) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1142, %483) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1143 = call @kernel_gemm(%481, %482, %483) {adf.kernel, "col, row" = [26 : index, 3 : index], ivs = [3 : index, 3 : index, 5 : index], kernel_gemm = 175 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1143, %c27, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%482, %c26, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%481, %c26, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1143, %arg99) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %484) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %485) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1144 = call @kernel_gemm0(%484, %485) {adf.kernel, "col, row" = [23 : index, 4 : index], ivs = [0 : index, 4 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 176 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1144, %c23, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%485, %c23, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%484, %c23, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %486) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %487) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1144, %488) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1145 = call @kernel_gemm(%486, %487, %488) {adf.kernel, "col, row" = [24 : index, 4 : index], ivs = [1 : index, 4 : index, 5 : index], kernel_gemm = 177 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1145, %c24, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%487, %c24, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%486, %c24, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %489) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %490) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1145, %491) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1146 = call @kernel_gemm(%489, %490, %491) {adf.kernel, "col, row" = [25 : index, 4 : index], ivs = [2 : index, 4 : index, 5 : index], kernel_gemm = 178 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1146, %c25, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%490, %c25, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%489, %c25, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %492) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %493) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1146, %494) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1147 = call @kernel_gemm(%492, %493, %494) {adf.kernel, "col, row" = [26 : index, 4 : index], ivs = [3 : index, 4 : index, 5 : index], kernel_gemm = 179 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1147, %c26, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%493, %c26, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%492, %c26, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1147, %arg100) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %495) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %496) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1148 = call @kernel_gemm0(%495, %496) {adf.kernel, "col, row" = [23 : index, 5 : index], ivs = [0 : index, 5 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 180 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1148, %c24, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%496, %c23, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%495, %c23, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %497) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %498) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1148, %499) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1149 = call @kernel_gemm(%497, %498, %499) {adf.kernel, "col, row" = [24 : index, 5 : index], ivs = [1 : index, 5 : index, 5 : index], kernel_gemm = 181 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1149, %c25, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%498, %c24, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%497, %c24, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %500) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %501) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1149, %502) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1150 = call @kernel_gemm(%500, %501, %502) {adf.kernel, "col, row" = [25 : index, 5 : index], ivs = [2 : index, 5 : index, 5 : index], kernel_gemm = 182 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1150, %c26, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%501, %c25, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%500, %c25, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %503) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %504) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1150, %505) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1151 = call @kernel_gemm(%503, %504, %505) {adf.kernel, "col, row" = [26 : index, 5 : index], ivs = [3 : index, 5 : index, 5 : index], kernel_gemm = 183 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1151, %c27, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%504, %c26, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%503, %c26, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1151, %arg101) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %506) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %507) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1152 = call @kernel_gemm0(%506, %507) {adf.kernel, "col, row" = [23 : index, 6 : index], ivs = [0 : index, 6 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 184 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1152, %c23, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%507, %c23, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%506, %c23, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %508) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %509) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1152, %510) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1153 = call @kernel_gemm(%508, %509, %510) {adf.kernel, "col, row" = [24 : index, 6 : index], ivs = [1 : index, 6 : index, 5 : index], kernel_gemm = 185 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1153, %c24, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%509, %c24, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%508, %c24, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %511) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %512) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1153, %513) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1154 = call @kernel_gemm(%511, %512, %513) {adf.kernel, "col, row" = [25 : index, 6 : index], ivs = [2 : index, 6 : index, 5 : index], kernel_gemm = 186 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1154, %c25, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%512, %c25, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%511, %c25, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %514) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %515) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1154, %516) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1155 = call @kernel_gemm(%514, %515, %516) {adf.kernel, "col, row" = [26 : index, 6 : index], ivs = [3 : index, 6 : index, 5 : index], kernel_gemm = 187 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1155, %c26, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%515, %c26, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%514, %c26, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1155, %arg102) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %517) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %518) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1156 = call @kernel_gemm0(%517, %518) {adf.kernel, "col, row" = [23 : index, 7 : index], ivs = [0 : index, 7 : index, 5 : index], kernel = 0 : index, kernel_gemm0 = 188 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1156, %c24, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%518, %c23, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%517, %c23, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %519) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %520) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1156, %521) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1157 = call @kernel_gemm(%519, %520, %521) {adf.kernel, "col, row" = [24 : index, 7 : index], ivs = [1 : index, 7 : index, 5 : index], kernel_gemm = 189 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1157, %c25, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%520, %c24, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%519, %c24, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg94, %522) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %523) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1157, %524) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1158 = call @kernel_gemm(%522, %523, %524) {adf.kernel, "col, row" = [25 : index, 7 : index], ivs = [2 : index, 7 : index, 5 : index], kernel_gemm = 190 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1158, %c26, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%523, %c25, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%522, %c25, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg95, %525) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %526) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1158, %527) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1159 = call @kernel_gemm(%525, %526, %527) {adf.kernel, "col, row" = [26 : index, 7 : index], ivs = [3 : index, 7 : index, 5 : index], kernel_gemm = 191 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1159, %c27, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%526, %c26, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%525, %c26, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1159, %arg103) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %528) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %529) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1160 = call @kernel_gemm0(%528, %529) {adf.kernel, "col, row" = [27 : index, 0 : index], ivs = [0 : index, 0 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 192 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1160, %c27, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%529, %c26, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%528, %c27, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %530) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %531) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1160, %532) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1161 = call @kernel_gemm(%530, %531, %532) {adf.kernel, "col, row" = [28 : index, 0 : index], ivs = [1 : index, 0 : index, 6 : index], kernel_gemm = 193 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1161, %c28, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%531, %c27, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%530, %c28, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %533) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %534) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1161, %535) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1162 = call @kernel_gemm(%533, %534, %535) {adf.kernel, "col, row" = [29 : index, 0 : index], ivs = [2 : index, 0 : index, 6 : index], kernel_gemm = 194 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1162, %c29, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%534, %c28, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%533, %c29, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %536) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %537) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1162, %538) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1163 = call @kernel_gemm(%536, %537, %538) {adf.kernel, "col, row" = [30 : index, 0 : index], ivs = [3 : index, 0 : index, 6 : index], kernel_gemm = 195 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1163, %c30, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%537, %c29, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%536, %c30, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1163, %arg108) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %539) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %540) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1164 = call @kernel_gemm0(%539, %540) {adf.kernel, "col, row" = [27 : index, 1 : index], ivs = [0 : index, 1 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 196 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1164, %c28, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%540, %c27, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%539, %c27, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %541) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %542) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1164, %543) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1165 = call @kernel_gemm(%541, %542, %543) {adf.kernel, "col, row" = [28 : index, 1 : index], ivs = [1 : index, 1 : index, 6 : index], kernel_gemm = 197 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1165, %c29, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%542, %c28, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%541, %c28, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %544) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %545) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1165, %546) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1166 = call @kernel_gemm(%544, %545, %546) {adf.kernel, "col, row" = [29 : index, 1 : index], ivs = [2 : index, 1 : index, 6 : index], kernel_gemm = 198 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1166, %c30, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%545, %c29, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%544, %c29, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %547) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %548) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1166, %549) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1167 = call @kernel_gemm(%547, %548, %549) {adf.kernel, "col, row" = [30 : index, 1 : index], ivs = [3 : index, 1 : index, 6 : index], kernel_gemm = 199 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1167, %c31, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%548, %c30, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%547, %c30, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1167, %arg109) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %550) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %551) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1168 = call @kernel_gemm0(%550, %551) {adf.kernel, "col, row" = [27 : index, 2 : index], ivs = [0 : index, 2 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 200 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1168, %c27, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%551, %c27, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%550, %c27, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %552) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %553) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1168, %554) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1169 = call @kernel_gemm(%552, %553, %554) {adf.kernel, "col, row" = [28 : index, 2 : index], ivs = [1 : index, 2 : index, 6 : index], kernel_gemm = 201 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1169, %c28, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%553, %c28, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%552, %c28, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %555) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %556) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1169, %557) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1170 = call @kernel_gemm(%555, %556, %557) {adf.kernel, "col, row" = [29 : index, 2 : index], ivs = [2 : index, 2 : index, 6 : index], kernel_gemm = 202 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1170, %c29, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%556, %c29, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%555, %c29, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %558) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %559) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1170, %560) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1171 = call @kernel_gemm(%558, %559, %560) {adf.kernel, "col, row" = [30 : index, 2 : index], ivs = [3 : index, 2 : index, 6 : index], kernel_gemm = 203 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1171, %c30, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%559, %c30, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%558, %c30, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1171, %arg110) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %561) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %562) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1172 = call @kernel_gemm0(%561, %562) {adf.kernel, "col, row" = [27 : index, 3 : index], ivs = [0 : index, 3 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 204 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1172, %c28, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%562, %c27, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%561, %c27, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %563) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %564) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1172, %565) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1173 = call @kernel_gemm(%563, %564, %565) {adf.kernel, "col, row" = [28 : index, 3 : index], ivs = [1 : index, 3 : index, 6 : index], kernel_gemm = 205 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1173, %c29, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%564, %c28, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%563, %c28, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %566) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %567) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1173, %568) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1174 = call @kernel_gemm(%566, %567, %568) {adf.kernel, "col, row" = [29 : index, 3 : index], ivs = [2 : index, 3 : index, 6 : index], kernel_gemm = 206 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1174, %c30, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%567, %c29, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%566, %c29, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %569) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %570) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1174, %571) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1175 = call @kernel_gemm(%569, %570, %571) {adf.kernel, "col, row" = [30 : index, 3 : index], ivs = [3 : index, 3 : index, 6 : index], kernel_gemm = 207 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1175, %c31, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%570, %c30, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%569, %c30, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1175, %arg111) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %572) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %573) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1176 = call @kernel_gemm0(%572, %573) {adf.kernel, "col, row" = [27 : index, 4 : index], ivs = [0 : index, 4 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 208 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1176, %c27, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%573, %c27, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%572, %c27, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %574) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %575) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1176, %576) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1177 = call @kernel_gemm(%574, %575, %576) {adf.kernel, "col, row" = [28 : index, 4 : index], ivs = [1 : index, 4 : index, 6 : index], kernel_gemm = 209 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1177, %c28, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%575, %c28, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%574, %c28, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %577) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %578) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1177, %579) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1178 = call @kernel_gemm(%577, %578, %579) {adf.kernel, "col, row" = [29 : index, 4 : index], ivs = [2 : index, 4 : index, 6 : index], kernel_gemm = 210 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1178, %c29, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%578, %c29, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%577, %c29, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %580) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %581) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1178, %582) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1179 = call @kernel_gemm(%580, %581, %582) {adf.kernel, "col, row" = [30 : index, 4 : index], ivs = [3 : index, 4 : index, 6 : index], kernel_gemm = 211 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1179, %c30, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%581, %c30, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%580, %c30, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1179, %arg112) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %583) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %584) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1180 = call @kernel_gemm0(%583, %584) {adf.kernel, "col, row" = [27 : index, 5 : index], ivs = [0 : index, 5 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 212 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1180, %c28, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%584, %c27, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%583, %c27, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %585) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %586) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1180, %587) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1181 = call @kernel_gemm(%585, %586, %587) {adf.kernel, "col, row" = [28 : index, 5 : index], ivs = [1 : index, 5 : index, 6 : index], kernel_gemm = 213 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1181, %c29, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%586, %c28, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%585, %c28, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %588) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %589) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1181, %590) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1182 = call @kernel_gemm(%588, %589, %590) {adf.kernel, "col, row" = [29 : index, 5 : index], ivs = [2 : index, 5 : index, 6 : index], kernel_gemm = 214 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1182, %c30, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%589, %c29, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%588, %c29, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %591) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %592) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1182, %593) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1183 = call @kernel_gemm(%591, %592, %593) {adf.kernel, "col, row" = [30 : index, 5 : index], ivs = [3 : index, 5 : index, 6 : index], kernel_gemm = 215 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1183, %c31, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%592, %c30, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%591, %c30, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1183, %arg113) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %594) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %595) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1184 = call @kernel_gemm0(%594, %595) {adf.kernel, "col, row" = [27 : index, 6 : index], ivs = [0 : index, 6 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 216 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1184, %c27, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%595, %c27, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%594, %c27, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %596) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %597) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1184, %598) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1185 = call @kernel_gemm(%596, %597, %598) {adf.kernel, "col, row" = [28 : index, 6 : index], ivs = [1 : index, 6 : index, 6 : index], kernel_gemm = 217 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1185, %c28, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%597, %c28, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%596, %c28, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %599) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %600) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1185, %601) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1186 = call @kernel_gemm(%599, %600, %601) {adf.kernel, "col, row" = [29 : index, 6 : index], ivs = [2 : index, 6 : index, 6 : index], kernel_gemm = 218 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1186, %c29, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%600, %c29, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%599, %c29, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %602) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %603) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1186, %604) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1187 = call @kernel_gemm(%602, %603, %604) {adf.kernel, "col, row" = [30 : index, 6 : index], ivs = [3 : index, 6 : index, 6 : index], kernel_gemm = 219 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1187, %c30, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%603, %c30, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%602, %c30, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1187, %arg114) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg104, %605) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %606) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1188 = call @kernel_gemm0(%605, %606) {adf.kernel, "col, row" = [27 : index, 7 : index], ivs = [0 : index, 7 : index, 6 : index], kernel = 0 : index, kernel_gemm0 = 220 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1188, %c28, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%606, %c27, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%605, %c27, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg105, %607) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %608) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1188, %609) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1189 = call @kernel_gemm(%607, %608, %609) {adf.kernel, "col, row" = [28 : index, 7 : index], ivs = [1 : index, 7 : index, 6 : index], kernel_gemm = 221 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1189, %c29, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%608, %c28, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%607, %c28, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg106, %610) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %611) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1189, %612) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1190 = call @kernel_gemm(%610, %611, %612) {adf.kernel, "col, row" = [29 : index, 7 : index], ivs = [2 : index, 7 : index, 6 : index], kernel_gemm = 222 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1190, %c30, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%611, %c29, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%610, %c29, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %613) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %614) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1190, %615) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1191 = call @kernel_gemm(%613, %614, %615) {adf.kernel, "col, row" = [30 : index, 7 : index], ivs = [3 : index, 7 : index, 6 : index], kernel_gemm = 223 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1191, %c31, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%614, %c30, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%613, %c30, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1191, %arg115) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %616) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %617) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1192 = call @kernel_gemm0(%616, %617) {adf.kernel, "col, row" = [31 : index, 0 : index], ivs = [0 : index, 0 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 224 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1192, %c31, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%617, %c30, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%616, %c31, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %618) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %619) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1192, %620) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1193 = call @kernel_gemm(%618, %619, %620) {adf.kernel, "col, row" = [32 : index, 0 : index], ivs = [1 : index, 0 : index, 7 : index], kernel_gemm = 225 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1193, %c32, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%619, %c31, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%618, %c32, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %621) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %622) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1193, %623) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1194 = call @kernel_gemm(%621, %622, %623) {adf.kernel, "col, row" = [33 : index, 0 : index], ivs = [2 : index, 0 : index, 7 : index], kernel_gemm = 226 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1194, %c33, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%622, %c32, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%621, %c33, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %624) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %625) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1194, %626) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1195 = call @kernel_gemm(%624, %625, %626) {adf.kernel, "col, row" = [34 : index, 0 : index], ivs = [3 : index, 0 : index, 7 : index], kernel_gemm = 227 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1195, %c34, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%625, %c33, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%624, %c34, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1195, %arg120) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %627) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %628) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1196 = call @kernel_gemm0(%627, %628) {adf.kernel, "col, row" = [31 : index, 1 : index], ivs = [0 : index, 1 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 228 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1196, %c32, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%628, %c31, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%627, %c31, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %629) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %630) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1196, %631) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1197 = call @kernel_gemm(%629, %630, %631) {adf.kernel, "col, row" = [32 : index, 1 : index], ivs = [1 : index, 1 : index, 7 : index], kernel_gemm = 229 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1197, %c33, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%630, %c32, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%629, %c32, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %632) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %633) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1197, %634) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1198 = call @kernel_gemm(%632, %633, %634) {adf.kernel, "col, row" = [33 : index, 1 : index], ivs = [2 : index, 1 : index, 7 : index], kernel_gemm = 230 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1198, %c34, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%633, %c33, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%632, %c33, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %635) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %636) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1198, %637) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1199 = call @kernel_gemm(%635, %636, %637) {adf.kernel, "col, row" = [34 : index, 1 : index], ivs = [3 : index, 1 : index, 7 : index], kernel_gemm = 231 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1199, %c35, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%636, %c34, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%635, %c34, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1199, %arg121) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %638) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %639) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1200 = call @kernel_gemm0(%638, %639) {adf.kernel, "col, row" = [31 : index, 2 : index], ivs = [0 : index, 2 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 232 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1200, %c31, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%639, %c31, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%638, %c31, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %640) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %641) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1200, %642) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1201 = call @kernel_gemm(%640, %641, %642) {adf.kernel, "col, row" = [32 : index, 2 : index], ivs = [1 : index, 2 : index, 7 : index], kernel_gemm = 233 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1201, %c32, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%641, %c32, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%640, %c32, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %643) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %644) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1201, %645) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1202 = call @kernel_gemm(%643, %644, %645) {adf.kernel, "col, row" = [33 : index, 2 : index], ivs = [2 : index, 2 : index, 7 : index], kernel_gemm = 234 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1202, %c33, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%644, %c33, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%643, %c33, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %646) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %647) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1202, %648) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1203 = call @kernel_gemm(%646, %647, %648) {adf.kernel, "col, row" = [34 : index, 2 : index], ivs = [3 : index, 2 : index, 7 : index], kernel_gemm = 235 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1203, %c34, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%647, %c34, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%646, %c34, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1203, %arg122) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %649) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %650) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1204 = call @kernel_gemm0(%649, %650) {adf.kernel, "col, row" = [31 : index, 3 : index], ivs = [0 : index, 3 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 236 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1204, %c32, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%650, %c31, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%649, %c31, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %651) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %652) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1204, %653) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1205 = call @kernel_gemm(%651, %652, %653) {adf.kernel, "col, row" = [32 : index, 3 : index], ivs = [1 : index, 3 : index, 7 : index], kernel_gemm = 237 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1205, %c33, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%652, %c32, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%651, %c32, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %654) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %655) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1205, %656) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1206 = call @kernel_gemm(%654, %655, %656) {adf.kernel, "col, row" = [33 : index, 3 : index], ivs = [2 : index, 3 : index, 7 : index], kernel_gemm = 238 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1206, %c34, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%655, %c33, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%654, %c33, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %657) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %658) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1206, %659) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1207 = call @kernel_gemm(%657, %658, %659) {adf.kernel, "col, row" = [34 : index, 3 : index], ivs = [3 : index, 3 : index, 7 : index], kernel_gemm = 239 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1207, %c35, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%658, %c34, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%657, %c34, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1207, %arg123) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %660) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %661) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1208 = call @kernel_gemm0(%660, %661) {adf.kernel, "col, row" = [31 : index, 4 : index], ivs = [0 : index, 4 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 240 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1208, %c31, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%661, %c31, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%660, %c31, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %662) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %663) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1208, %664) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1209 = call @kernel_gemm(%662, %663, %664) {adf.kernel, "col, row" = [32 : index, 4 : index], ivs = [1 : index, 4 : index, 7 : index], kernel_gemm = 241 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1209, %c32, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%663, %c32, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%662, %c32, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %665) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %666) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1209, %667) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1210 = call @kernel_gemm(%665, %666, %667) {adf.kernel, "col, row" = [33 : index, 4 : index], ivs = [2 : index, 4 : index, 7 : index], kernel_gemm = 242 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1210, %c33, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%666, %c33, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%665, %c33, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %668) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %669) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1210, %670) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1211 = call @kernel_gemm(%668, %669, %670) {adf.kernel, "col, row" = [34 : index, 4 : index], ivs = [3 : index, 4 : index, 7 : index], kernel_gemm = 243 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1211, %c34, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%669, %c34, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%668, %c34, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1211, %arg124) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %671) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %672) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1212 = call @kernel_gemm0(%671, %672) {adf.kernel, "col, row" = [31 : index, 5 : index], ivs = [0 : index, 5 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 244 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1212, %c32, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%672, %c31, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%671, %c31, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %673) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %674) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1212, %675) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1213 = call @kernel_gemm(%673, %674, %675) {adf.kernel, "col, row" = [32 : index, 5 : index], ivs = [1 : index, 5 : index, 7 : index], kernel_gemm = 245 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1213, %c33, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%674, %c32, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%673, %c32, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %676) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %677) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1213, %678) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1214 = call @kernel_gemm(%676, %677, %678) {adf.kernel, "col, row" = [33 : index, 5 : index], ivs = [2 : index, 5 : index, 7 : index], kernel_gemm = 246 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1214, %c34, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%677, %c33, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%676, %c33, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %679) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %680) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1214, %681) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1215 = call @kernel_gemm(%679, %680, %681) {adf.kernel, "col, row" = [34 : index, 5 : index], ivs = [3 : index, 5 : index, 7 : index], kernel_gemm = 247 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1215, %c35, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%680, %c34, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%679, %c34, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1215, %arg125) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %682) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %683) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1216 = call @kernel_gemm0(%682, %683) {adf.kernel, "col, row" = [31 : index, 6 : index], ivs = [0 : index, 6 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 248 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1216, %c31, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%683, %c31, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%682, %c31, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %684) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %685) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1216, %686) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1217 = call @kernel_gemm(%684, %685, %686) {adf.kernel, "col, row" = [32 : index, 6 : index], ivs = [1 : index, 6 : index, 7 : index], kernel_gemm = 249 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1217, %c32, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%685, %c32, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%684, %c32, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %687) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %688) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1217, %689) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1218 = call @kernel_gemm(%687, %688, %689) {adf.kernel, "col, row" = [33 : index, 6 : index], ivs = [2 : index, 6 : index, 7 : index], kernel_gemm = 250 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1218, %c33, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%688, %c33, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%687, %c33, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %690) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %691) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1218, %692) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1219 = call @kernel_gemm(%690, %691, %692) {adf.kernel, "col, row" = [34 : index, 6 : index], ivs = [3 : index, 6 : index, 7 : index], kernel_gemm = 251 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1219, %c34, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%691, %c34, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%690, %c34, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1219, %arg126) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg116, %693) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %694) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1220 = call @kernel_gemm0(%693, %694) {adf.kernel, "col, row" = [31 : index, 7 : index], ivs = [0 : index, 7 : index, 7 : index], kernel = 0 : index, kernel_gemm0 = 252 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1220, %c32, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%694, %c31, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%693, %c31, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg117, %695) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %696) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1220, %697) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1221 = call @kernel_gemm(%695, %696, %697) {adf.kernel, "col, row" = [32 : index, 7 : index], ivs = [1 : index, 7 : index, 7 : index], kernel_gemm = 253 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1221, %c33, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%696, %c32, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%695, %c32, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg118, %698) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %699) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1221, %700) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1222 = call @kernel_gemm(%698, %699, %700) {adf.kernel, "col, row" = [33 : index, 7 : index], ivs = [2 : index, 7 : index, 7 : index], kernel_gemm = 254 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1222, %c34, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%699, %c33, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%698, %c33, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg119, %701) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %702) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1222, %703) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1223 = call @kernel_gemm(%701, %702, %703) {adf.kernel, "col, row" = [34 : index, 7 : index], ivs = [3 : index, 7 : index, 7 : index], kernel_gemm = 255 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1223, %c35, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%702, %c34, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%701, %c34, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1223, %arg127) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %704) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %705) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1224 = call @kernel_gemm0(%704, %705) {adf.kernel, "col, row" = [35 : index, 0 : index], ivs = [0 : index, 0 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 256 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1224, %c35, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%705, %c34, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%704, %c35, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %706) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %707) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1224, %708) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1225 = call @kernel_gemm(%706, %707, %708) {adf.kernel, "col, row" = [36 : index, 0 : index], ivs = [1 : index, 0 : index, 8 : index], kernel_gemm = 257 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1225, %c36, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%707, %c35, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%706, %c36, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %709) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %710) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1225, %711) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1226 = call @kernel_gemm(%709, %710, %711) {adf.kernel, "col, row" = [37 : index, 0 : index], ivs = [2 : index, 0 : index, 8 : index], kernel_gemm = 258 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1226, %c37, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%710, %c36, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%709, %c37, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %712) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %713) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1226, %714) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1227 = call @kernel_gemm(%712, %713, %714) {adf.kernel, "col, row" = [38 : index, 0 : index], ivs = [3 : index, 0 : index, 8 : index], kernel_gemm = 259 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1227, %c38, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%713, %c37, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%712, %c38, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1227, %arg132) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %715) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %716) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1228 = call @kernel_gemm0(%715, %716) {adf.kernel, "col, row" = [35 : index, 1 : index], ivs = [0 : index, 1 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 260 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1228, %c36, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%716, %c35, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%715, %c35, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %717) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %718) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1228, %719) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1229 = call @kernel_gemm(%717, %718, %719) {adf.kernel, "col, row" = [36 : index, 1 : index], ivs = [1 : index, 1 : index, 8 : index], kernel_gemm = 261 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1229, %c37, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%718, %c36, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%717, %c36, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %720) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %721) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1229, %722) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1230 = call @kernel_gemm(%720, %721, %722) {adf.kernel, "col, row" = [37 : index, 1 : index], ivs = [2 : index, 1 : index, 8 : index], kernel_gemm = 262 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1230, %c38, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%721, %c37, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%720, %c37, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %723) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %724) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1230, %725) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1231 = call @kernel_gemm(%723, %724, %725) {adf.kernel, "col, row" = [38 : index, 1 : index], ivs = [3 : index, 1 : index, 8 : index], kernel_gemm = 263 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1231, %c39, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%724, %c38, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%723, %c38, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1231, %arg133) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %726) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %727) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1232 = call @kernel_gemm0(%726, %727) {adf.kernel, "col, row" = [35 : index, 2 : index], ivs = [0 : index, 2 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 264 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1232, %c35, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%727, %c35, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%726, %c35, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %728) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %729) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1232, %730) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1233 = call @kernel_gemm(%728, %729, %730) {adf.kernel, "col, row" = [36 : index, 2 : index], ivs = [1 : index, 2 : index, 8 : index], kernel_gemm = 265 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1233, %c36, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%729, %c36, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%728, %c36, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %731) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %732) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1233, %733) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1234 = call @kernel_gemm(%731, %732, %733) {adf.kernel, "col, row" = [37 : index, 2 : index], ivs = [2 : index, 2 : index, 8 : index], kernel_gemm = 266 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1234, %c37, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%732, %c37, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%731, %c37, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %734) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %735) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1234, %736) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1235 = call @kernel_gemm(%734, %735, %736) {adf.kernel, "col, row" = [38 : index, 2 : index], ivs = [3 : index, 2 : index, 8 : index], kernel_gemm = 267 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1235, %c38, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%735, %c38, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%734, %c38, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1235, %arg134) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %737) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %738) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1236 = call @kernel_gemm0(%737, %738) {adf.kernel, "col, row" = [35 : index, 3 : index], ivs = [0 : index, 3 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 268 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1236, %c36, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%738, %c35, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%737, %c35, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %739) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %740) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1236, %741) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1237 = call @kernel_gemm(%739, %740, %741) {adf.kernel, "col, row" = [36 : index, 3 : index], ivs = [1 : index, 3 : index, 8 : index], kernel_gemm = 269 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1237, %c37, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%740, %c36, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%739, %c36, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %742) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %743) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1237, %744) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1238 = call @kernel_gemm(%742, %743, %744) {adf.kernel, "col, row" = [37 : index, 3 : index], ivs = [2 : index, 3 : index, 8 : index], kernel_gemm = 270 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1238, %c38, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%743, %c37, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%742, %c37, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %745) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %746) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1238, %747) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1239 = call @kernel_gemm(%745, %746, %747) {adf.kernel, "col, row" = [38 : index, 3 : index], ivs = [3 : index, 3 : index, 8 : index], kernel_gemm = 271 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1239, %c39, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%746, %c38, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%745, %c38, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1239, %arg135) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %748) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %749) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1240 = call @kernel_gemm0(%748, %749) {adf.kernel, "col, row" = [35 : index, 4 : index], ivs = [0 : index, 4 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 272 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1240, %c35, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%749, %c35, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%748, %c35, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %750) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %751) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1240, %752) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1241 = call @kernel_gemm(%750, %751, %752) {adf.kernel, "col, row" = [36 : index, 4 : index], ivs = [1 : index, 4 : index, 8 : index], kernel_gemm = 273 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1241, %c36, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%751, %c36, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%750, %c36, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %753) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %754) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1241, %755) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1242 = call @kernel_gemm(%753, %754, %755) {adf.kernel, "col, row" = [37 : index, 4 : index], ivs = [2 : index, 4 : index, 8 : index], kernel_gemm = 274 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1242, %c37, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%754, %c37, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%753, %c37, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %756) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %757) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1242, %758) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1243 = call @kernel_gemm(%756, %757, %758) {adf.kernel, "col, row" = [38 : index, 4 : index], ivs = [3 : index, 4 : index, 8 : index], kernel_gemm = 275 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1243, %c38, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%757, %c38, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%756, %c38, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1243, %arg136) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %759) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %760) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1244 = call @kernel_gemm0(%759, %760) {adf.kernel, "col, row" = [35 : index, 5 : index], ivs = [0 : index, 5 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 276 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1244, %c36, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%760, %c35, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%759, %c35, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %761) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %762) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1244, %763) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1245 = call @kernel_gemm(%761, %762, %763) {adf.kernel, "col, row" = [36 : index, 5 : index], ivs = [1 : index, 5 : index, 8 : index], kernel_gemm = 277 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1245, %c37, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%762, %c36, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%761, %c36, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %764) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %765) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1245, %766) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1246 = call @kernel_gemm(%764, %765, %766) {adf.kernel, "col, row" = [37 : index, 5 : index], ivs = [2 : index, 5 : index, 8 : index], kernel_gemm = 278 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1246, %c38, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%765, %c37, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%764, %c37, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %767) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %768) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1246, %769) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1247 = call @kernel_gemm(%767, %768, %769) {adf.kernel, "col, row" = [38 : index, 5 : index], ivs = [3 : index, 5 : index, 8 : index], kernel_gemm = 279 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1247, %c39, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%768, %c38, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%767, %c38, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1247, %arg137) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %770) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %771) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1248 = call @kernel_gemm0(%770, %771) {adf.kernel, "col, row" = [35 : index, 6 : index], ivs = [0 : index, 6 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 280 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1248, %c35, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%771, %c35, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%770, %c35, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %772) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %773) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1248, %774) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1249 = call @kernel_gemm(%772, %773, %774) {adf.kernel, "col, row" = [36 : index, 6 : index], ivs = [1 : index, 6 : index, 8 : index], kernel_gemm = 281 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1249, %c36, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%773, %c36, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%772, %c36, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %775) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %776) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1249, %777) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1250 = call @kernel_gemm(%775, %776, %777) {adf.kernel, "col, row" = [37 : index, 6 : index], ivs = [2 : index, 6 : index, 8 : index], kernel_gemm = 282 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1250, %c37, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%776, %c37, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%775, %c37, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %778) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %779) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1250, %780) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1251 = call @kernel_gemm(%778, %779, %780) {adf.kernel, "col, row" = [38 : index, 6 : index], ivs = [3 : index, 6 : index, 8 : index], kernel_gemm = 283 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1251, %c38, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%779, %c38, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%778, %c38, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1251, %arg138) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg128, %781) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %782) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1252 = call @kernel_gemm0(%781, %782) {adf.kernel, "col, row" = [35 : index, 7 : index], ivs = [0 : index, 7 : index, 8 : index], kernel = 0 : index, kernel_gemm0 = 284 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1252, %c36, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%782, %c35, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%781, %c35, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg129, %783) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %784) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1252, %785) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1253 = call @kernel_gemm(%783, %784, %785) {adf.kernel, "col, row" = [36 : index, 7 : index], ivs = [1 : index, 7 : index, 8 : index], kernel_gemm = 285 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1253, %c37, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%784, %c36, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%783, %c36, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg130, %786) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %787) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1253, %788) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1254 = call @kernel_gemm(%786, %787, %788) {adf.kernel, "col, row" = [37 : index, 7 : index], ivs = [2 : index, 7 : index, 8 : index], kernel_gemm = 286 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1254, %c38, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%787, %c37, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%786, %c37, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg131, %789) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %790) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1254, %791) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1255 = call @kernel_gemm(%789, %790, %791) {adf.kernel, "col, row" = [38 : index, 7 : index], ivs = [3 : index, 7 : index, 8 : index], kernel_gemm = 287 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1255, %c39, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%790, %c38, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%789, %c38, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1255, %arg139) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %792) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %793) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1256 = call @kernel_gemm0(%792, %793) {adf.kernel, "col, row" = [39 : index, 0 : index], ivs = [0 : index, 0 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 288 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1256, %c39, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%793, %c38, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%792, %c39, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %794) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %795) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1256, %796) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1257 = call @kernel_gemm(%794, %795, %796) {adf.kernel, "col, row" = [40 : index, 0 : index], ivs = [1 : index, 0 : index, 9 : index], kernel_gemm = 289 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1257, %c40, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%795, %c39, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%794, %c40, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %797) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %798) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1257, %799) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1258 = call @kernel_gemm(%797, %798, %799) {adf.kernel, "col, row" = [41 : index, 0 : index], ivs = [2 : index, 0 : index, 9 : index], kernel_gemm = 290 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1258, %c41, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%798, %c40, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%797, %c41, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %800) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %801) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1258, %802) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1259 = call @kernel_gemm(%800, %801, %802) {adf.kernel, "col, row" = [42 : index, 0 : index], ivs = [3 : index, 0 : index, 9 : index], kernel_gemm = 291 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1259, %c42, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%801, %c41, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%800, %c42, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1259, %arg144) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %803) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %804) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1260 = call @kernel_gemm0(%803, %804) {adf.kernel, "col, row" = [39 : index, 1 : index], ivs = [0 : index, 1 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 292 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1260, %c40, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%804, %c39, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%803, %c39, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %805) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %806) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1260, %807) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1261 = call @kernel_gemm(%805, %806, %807) {adf.kernel, "col, row" = [40 : index, 1 : index], ivs = [1 : index, 1 : index, 9 : index], kernel_gemm = 293 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1261, %c41, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%806, %c40, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%805, %c40, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %808) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %809) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1261, %810) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1262 = call @kernel_gemm(%808, %809, %810) {adf.kernel, "col, row" = [41 : index, 1 : index], ivs = [2 : index, 1 : index, 9 : index], kernel_gemm = 294 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1262, %c42, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%809, %c41, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%808, %c41, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %811) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %812) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1262, %813) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1263 = call @kernel_gemm(%811, %812, %813) {adf.kernel, "col, row" = [42 : index, 1 : index], ivs = [3 : index, 1 : index, 9 : index], kernel_gemm = 295 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1263, %c43, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%812, %c42, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%811, %c42, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1263, %arg145) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %814) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %815) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1264 = call @kernel_gemm0(%814, %815) {adf.kernel, "col, row" = [39 : index, 2 : index], ivs = [0 : index, 2 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 296 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1264, %c39, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%815, %c39, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%814, %c39, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %816) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %817) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1264, %818) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1265 = call @kernel_gemm(%816, %817, %818) {adf.kernel, "col, row" = [40 : index, 2 : index], ivs = [1 : index, 2 : index, 9 : index], kernel_gemm = 297 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1265, %c40, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%817, %c40, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%816, %c40, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %819) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %820) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1265, %821) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1266 = call @kernel_gemm(%819, %820, %821) {adf.kernel, "col, row" = [41 : index, 2 : index], ivs = [2 : index, 2 : index, 9 : index], kernel_gemm = 298 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1266, %c41, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%820, %c41, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%819, %c41, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %822) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %823) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1266, %824) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1267 = call @kernel_gemm(%822, %823, %824) {adf.kernel, "col, row" = [42 : index, 2 : index], ivs = [3 : index, 2 : index, 9 : index], kernel_gemm = 299 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1267, %c42, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%823, %c42, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%822, %c42, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1267, %arg146) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %825) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %826) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1268 = call @kernel_gemm0(%825, %826) {adf.kernel, "col, row" = [39 : index, 3 : index], ivs = [0 : index, 3 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 300 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1268, %c40, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%826, %c39, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%825, %c39, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %827) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %828) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1268, %829) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1269 = call @kernel_gemm(%827, %828, %829) {adf.kernel, "col, row" = [40 : index, 3 : index], ivs = [1 : index, 3 : index, 9 : index], kernel_gemm = 301 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1269, %c41, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%828, %c40, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%827, %c40, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %830) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %831) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1269, %832) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1270 = call @kernel_gemm(%830, %831, %832) {adf.kernel, "col, row" = [41 : index, 3 : index], ivs = [2 : index, 3 : index, 9 : index], kernel_gemm = 302 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1270, %c42, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%831, %c41, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%830, %c41, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %833) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %834) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1270, %835) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1271 = call @kernel_gemm(%833, %834, %835) {adf.kernel, "col, row" = [42 : index, 3 : index], ivs = [3 : index, 3 : index, 9 : index], kernel_gemm = 303 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1271, %c43, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%834, %c42, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%833, %c42, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1271, %arg147) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %836) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %837) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1272 = call @kernel_gemm0(%836, %837) {adf.kernel, "col, row" = [39 : index, 4 : index], ivs = [0 : index, 4 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 304 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1272, %c39, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%837, %c39, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%836, %c39, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %838) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %839) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1272, %840) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1273 = call @kernel_gemm(%838, %839, %840) {adf.kernel, "col, row" = [40 : index, 4 : index], ivs = [1 : index, 4 : index, 9 : index], kernel_gemm = 305 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1273, %c40, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%839, %c40, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%838, %c40, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %841) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %842) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1273, %843) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1274 = call @kernel_gemm(%841, %842, %843) {adf.kernel, "col, row" = [41 : index, 4 : index], ivs = [2 : index, 4 : index, 9 : index], kernel_gemm = 306 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1274, %c41, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%842, %c41, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%841, %c41, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %844) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %845) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1274, %846) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1275 = call @kernel_gemm(%844, %845, %846) {adf.kernel, "col, row" = [42 : index, 4 : index], ivs = [3 : index, 4 : index, 9 : index], kernel_gemm = 307 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1275, %c42, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%845, %c42, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%844, %c42, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1275, %arg148) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %847) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %848) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1276 = call @kernel_gemm0(%847, %848) {adf.kernel, "col, row" = [39 : index, 5 : index], ivs = [0 : index, 5 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 308 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1276, %c40, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%848, %c39, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%847, %c39, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %849) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %850) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1276, %851) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1277 = call @kernel_gemm(%849, %850, %851) {adf.kernel, "col, row" = [40 : index, 5 : index], ivs = [1 : index, 5 : index, 9 : index], kernel_gemm = 309 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1277, %c41, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%850, %c40, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%849, %c40, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %852) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %853) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1277, %854) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1278 = call @kernel_gemm(%852, %853, %854) {adf.kernel, "col, row" = [41 : index, 5 : index], ivs = [2 : index, 5 : index, 9 : index], kernel_gemm = 310 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1278, %c42, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%853, %c41, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%852, %c41, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %855) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %856) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1278, %857) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1279 = call @kernel_gemm(%855, %856, %857) {adf.kernel, "col, row" = [42 : index, 5 : index], ivs = [3 : index, 5 : index, 9 : index], kernel_gemm = 311 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1279, %c43, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%856, %c42, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%855, %c42, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1279, %arg149) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %858) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %859) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1280 = call @kernel_gemm0(%858, %859) {adf.kernel, "col, row" = [39 : index, 6 : index], ivs = [0 : index, 6 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 312 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1280, %c39, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%859, %c39, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%858, %c39, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %860) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %861) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1280, %862) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1281 = call @kernel_gemm(%860, %861, %862) {adf.kernel, "col, row" = [40 : index, 6 : index], ivs = [1 : index, 6 : index, 9 : index], kernel_gemm = 313 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1281, %c40, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%861, %c40, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%860, %c40, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %863) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %864) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1281, %865) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1282 = call @kernel_gemm(%863, %864, %865) {adf.kernel, "col, row" = [41 : index, 6 : index], ivs = [2 : index, 6 : index, 9 : index], kernel_gemm = 314 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1282, %c41, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%864, %c41, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%863, %c41, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %866) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %867) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1282, %868) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1283 = call @kernel_gemm(%866, %867, %868) {adf.kernel, "col, row" = [42 : index, 6 : index], ivs = [3 : index, 6 : index, 9 : index], kernel_gemm = 315 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1283, %c42, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%867, %c42, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%866, %c42, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1283, %arg150) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg140, %869) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %870) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1284 = call @kernel_gemm0(%869, %870) {adf.kernel, "col, row" = [39 : index, 7 : index], ivs = [0 : index, 7 : index, 9 : index], kernel = 0 : index, kernel_gemm0 = 316 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1284, %c40, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%870, %c39, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%869, %c39, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg141, %871) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %872) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1284, %873) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1285 = call @kernel_gemm(%871, %872, %873) {adf.kernel, "col, row" = [40 : index, 7 : index], ivs = [1 : index, 7 : index, 9 : index], kernel_gemm = 317 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1285, %c41, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%872, %c40, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%871, %c40, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg142, %874) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %875) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1285, %876) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1286 = call @kernel_gemm(%874, %875, %876) {adf.kernel, "col, row" = [41 : index, 7 : index], ivs = [2 : index, 7 : index, 9 : index], kernel_gemm = 318 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1286, %c42, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%875, %c41, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%874, %c41, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg143, %877) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %878) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1286, %879) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1287 = call @kernel_gemm(%877, %878, %879) {adf.kernel, "col, row" = [42 : index, 7 : index], ivs = [3 : index, 7 : index, 9 : index], kernel_gemm = 319 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1287, %c43, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%878, %c42, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%877, %c42, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1287, %arg151) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %880) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg1, %881) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1288 = call @kernel_gemm0(%880, %881) {adf.kernel, "col, row" = [43 : index, 0 : index], ivs = [0 : index, 0 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 320 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1288, %c43, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%881, %c42, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%880, %c43, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %882) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg3, %883) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1288, %884) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1289 = call @kernel_gemm(%882, %883, %884) {adf.kernel, "col, row" = [44 : index, 0 : index], ivs = [1 : index, 0 : index, 10 : index], kernel_gemm = 321 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1289, %c44, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%883, %c43, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%882, %c44, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %885) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg5, %886) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1289, %887) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1290 = call @kernel_gemm(%885, %886, %887) {adf.kernel, "col, row" = [45 : index, 0 : index], ivs = [2 : index, 0 : index, 10 : index], kernel_gemm = 322 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1290, %c45, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%886, %c44, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%885, %c45, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %888) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg7, %889) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1290, %890) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1291 = call @kernel_gemm(%888, %889, %890) {adf.kernel, "col, row" = [46 : index, 0 : index], ivs = [3 : index, 0 : index, 10 : index], kernel_gemm = 323 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1291, %c46, %c0, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%889, %c45, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%888, %c46, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1291, %arg156) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %891) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg9, %892) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1292 = call @kernel_gemm0(%891, %892) {adf.kernel, "col, row" = [43 : index, 1 : index], ivs = [0 : index, 1 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 324 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1292, %c44, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%892, %c43, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%891, %c43, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %893) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg10, %894) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1292, %895) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1293 = call @kernel_gemm(%893, %894, %895) {adf.kernel, "col, row" = [44 : index, 1 : index], ivs = [1 : index, 1 : index, 10 : index], kernel_gemm = 325 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1293, %c45, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%894, %c44, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%893, %c44, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %896) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg11, %897) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1293, %898) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1294 = call @kernel_gemm(%896, %897, %898) {adf.kernel, "col, row" = [45 : index, 1 : index], ivs = [2 : index, 1 : index, 10 : index], kernel_gemm = 326 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1294, %c46, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%897, %c45, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%896, %c45, %c0, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %899) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg12, %900) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1294, %901) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1295 = call @kernel_gemm(%899, %900, %901) {adf.kernel, "col, row" = [46 : index, 1 : index], ivs = [3 : index, 1 : index, 10 : index], kernel_gemm = 327 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1295, %c47, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%900, %c46, %c2, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%899, %c46, %c0, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1295, %arg157) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %902) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg14, %903) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1296 = call @kernel_gemm0(%902, %903) {adf.kernel, "col, row" = [43 : index, 2 : index], ivs = [0 : index, 2 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 328 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1296, %c43, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%903, %c43, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%902, %c43, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %904) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg15, %905) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1296, %906) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1297 = call @kernel_gemm(%904, %905, %906) {adf.kernel, "col, row" = [44 : index, 2 : index], ivs = [1 : index, 2 : index, 10 : index], kernel_gemm = 329 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1297, %c44, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%905, %c44, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%904, %c44, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %907) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg16, %908) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1297, %909) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1298 = call @kernel_gemm(%907, %908, %909) {adf.kernel, "col, row" = [45 : index, 2 : index], ivs = [2 : index, 2 : index, 10 : index], kernel_gemm = 330 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1298, %c45, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%908, %c45, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%907, %c45, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %910) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg17, %911) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1298, %912) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1299 = call @kernel_gemm(%910, %911, %912) {adf.kernel, "col, row" = [46 : index, 2 : index], ivs = [3 : index, 2 : index, 10 : index], kernel_gemm = 331 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1299, %c46, %c2, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%911, %c46, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%910, %c46, %c1, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1299, %arg158) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %913) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg19, %914) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1300 = call @kernel_gemm0(%913, %914) {adf.kernel, "col, row" = [43 : index, 3 : index], ivs = [0 : index, 3 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 332 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1300, %c44, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%914, %c43, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%913, %c43, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %915) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg20, %916) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1300, %917) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1301 = call @kernel_gemm(%915, %916, %917) {adf.kernel, "col, row" = [44 : index, 3 : index], ivs = [1 : index, 3 : index, 10 : index], kernel_gemm = 333 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1301, %c45, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%916, %c44, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%915, %c44, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %918) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg21, %919) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1301, %920) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1302 = call @kernel_gemm(%918, %919, %920) {adf.kernel, "col, row" = [45 : index, 3 : index], ivs = [2 : index, 3 : index, 10 : index], kernel_gemm = 334 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1302, %c46, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%919, %c45, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%918, %c45, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %921) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg22, %922) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1302, %923) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1303 = call @kernel_gemm(%921, %922, %923) {adf.kernel, "col, row" = [46 : index, 3 : index], ivs = [3 : index, 3 : index, 10 : index], kernel_gemm = 335 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1303, %c47, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%922, %c46, %c4, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%921, %c46, %c2, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1303, %arg159) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %924) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg24, %925) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1304 = call @kernel_gemm0(%924, %925) {adf.kernel, "col, row" = [43 : index, 4 : index], ivs = [0 : index, 4 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 336 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1304, %c43, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%925, %c43, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%924, %c43, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %926) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg25, %927) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1304, %928) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1305 = call @kernel_gemm(%926, %927, %928) {adf.kernel, "col, row" = [44 : index, 4 : index], ivs = [1 : index, 4 : index, 10 : index], kernel_gemm = 337 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1305, %c44, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%927, %c44, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%926, %c44, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %929) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg26, %930) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1305, %931) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1306 = call @kernel_gemm(%929, %930, %931) {adf.kernel, "col, row" = [45 : index, 4 : index], ivs = [2 : index, 4 : index, 10 : index], kernel_gemm = 338 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1306, %c45, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%930, %c45, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%929, %c45, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %932) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg27, %933) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1306, %934) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1307 = call @kernel_gemm(%932, %933, %934) {adf.kernel, "col, row" = [46 : index, 4 : index], ivs = [3 : index, 4 : index, 10 : index], kernel_gemm = 339 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1307, %c46, %c4, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%933, %c46, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%932, %c46, %c3, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1307, %arg160) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %935) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg29, %936) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1308 = call @kernel_gemm0(%935, %936) {adf.kernel, "col, row" = [43 : index, 5 : index], ivs = [0 : index, 5 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 340 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1308, %c44, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%936, %c43, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%935, %c43, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %937) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg30, %938) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1308, %939) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1309 = call @kernel_gemm(%937, %938, %939) {adf.kernel, "col, row" = [44 : index, 5 : index], ivs = [1 : index, 5 : index, 10 : index], kernel_gemm = 341 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1309, %c45, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%938, %c44, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%937, %c44, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %940) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg31, %941) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1309, %942) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1310 = call @kernel_gemm(%940, %941, %942) {adf.kernel, "col, row" = [45 : index, 5 : index], ivs = [2 : index, 5 : index, 10 : index], kernel_gemm = 342 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1310, %c46, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%941, %c45, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%940, %c45, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %943) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg32, %944) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1310, %945) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1311 = call @kernel_gemm(%943, %944, %945) {adf.kernel, "col, row" = [46 : index, 5 : index], ivs = [3 : index, 5 : index, 10 : index], kernel_gemm = 343 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1311, %c47, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%944, %c46, %c6, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%943, %c46, %c4, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1311, %arg161) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %946) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg34, %947) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1312 = call @kernel_gemm0(%946, %947) {adf.kernel, "col, row" = [43 : index, 6 : index], ivs = [0 : index, 6 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 344 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1312, %c43, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%947, %c43, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%946, %c43, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %948) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg35, %949) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1312, %950) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1313 = call @kernel_gemm(%948, %949, %950) {adf.kernel, "col, row" = [44 : index, 6 : index], ivs = [1 : index, 6 : index, 10 : index], kernel_gemm = 345 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1313, %c44, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%949, %c44, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%948, %c44, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %951) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg36, %952) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1313, %953) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1314 = call @kernel_gemm(%951, %952, %953) {adf.kernel, "col, row" = [45 : index, 6 : index], ivs = [2 : index, 6 : index, 10 : index], kernel_gemm = 346 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1314, %c45, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%952, %c45, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%951, %c45, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %954) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg37, %955) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1314, %956) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1315 = call @kernel_gemm(%954, %955, %956) {adf.kernel, "col, row" = [46 : index, 6 : index], ivs = [3 : index, 6 : index, 10 : index], kernel_gemm = 347 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1315, %c46, %c6, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%955, %c46, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%954, %c46, %c5, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1315, %arg162) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg152, %957) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg39, %958) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %1316 = call @kernel_gemm0(%957, %958) {adf.kernel, "col, row" = [43 : index, 7 : index], ivs = [0 : index, 7 : index, 10 : index], kernel = 0 : index, kernel_gemm0 = 348 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1316, %c44, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%958, %c43, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%957, %c43, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg153, %959) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg40, %960) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1316, %961) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1317 = call @kernel_gemm(%959, %960, %961) {adf.kernel, "col, row" = [44 : index, 7 : index], ivs = [1 : index, 7 : index, 10 : index], kernel_gemm = 349 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1317, %c45, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%960, %c44, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%959, %c44, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg154, %962) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg41, %963) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1317, %964) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1318 = call @kernel_gemm(%962, %963, %964) {adf.kernel, "col, row" = [45 : index, 7 : index], ivs = [2 : index, 7 : index, 10 : index], kernel_gemm = 350 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1318, %c46, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%963, %c45, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%962, %c45, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%arg155, %965) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%arg42, %966) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%1318, %967) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>)
    %1319 = call @kernel_gemm(%965, %966, %967) {adf.kernel, "col, row" = [46 : index, 7 : index], ivs = [3 : index, 7 : index, 10 : index], kernel_gemm = 351 : index} : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> memref<32x32xf32, 2>
    adf.buffer.location(%1319, %c47, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%966, %c46, %c7, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%965, %c46, %c6, %c4096, %c12288) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.connect(%1319, %arg163) {write = 3 : index} : (memref<32x32xf32, 2>, !adf.plio<Out, 128>)
    return
  }
  func.func @receive13(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, receive, template} {
    %c64 = arith.constant 64 : index
    %c95 = arith.constant 95 : index
    %c32 = arith.constant 32 : index
    %c63 = arith.constant 63 : index
    %c0 = arith.constant 0 : index
    %c31 = arith.constant 31 : index
    %c0_i128 = arith.constant 0 : i128
    %c96 = arith.constant 96 : index
    %c127 = arith.constant 127 : index
    %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<128x48xi128, 1>
    affine.for %arg2 = 0 to 128 {
      affine.for %arg3 = 0 to 48 {
        affine.store %c0_i128, %alloc[%arg2, %arg3] : memref<128x48xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 64 {
          affine.for %arg5 = 0 to 4 {
            affine.for %arg6 = 0 to 6 {
              affine.for %arg7 = 0 to 1 {
                affine.for %arg8 = 0 to 32 {
                  affine.for %arg9 = 0 to 8 {
                    %0 = affine.load %arg0[0] : memref<1xi128, "plio">
                    %1 = affine.load %alloc[%arg8 + %arg5 * 32, %arg9 + %arg6 * 8] : memref<128x48xi128, 1>
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
                    affine.store %29, %alloc[%arg8 + %arg5 * 32, %arg9 + %arg6 * 8] : memref<128x48xi128, 1>
                  } {pipeline_ii = 1 : index}
                }
              }
            }
          }
        } {Array_Partition, reduction}
        affine.for %arg4 = 0 to 4 {
          affine.for %arg5 = 0 to 32 {
            affine.for %arg6 = 0 to 6 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %alloc[%arg5 + %arg4 * 32, %arg7 + %arg6 * 8] : memref<128x48xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "stream">
                affine.store %c0_i128, %alloc[%arg5 + %arg4 * 32, %arg7 + %arg6 * 8] : memref<128x48xi128, 1>
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @receive13_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "stream">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "stream">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "stream">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "stream">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "stream">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "stream">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "stream">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "stream">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "stream">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "stream">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "stream">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "stream">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "stream">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "stream">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "stream">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "stream">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "stream">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "stream">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "stream">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "stream">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "stream">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "stream">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "stream">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "stream">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "stream">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "stream">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "stream">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "stream">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "stream">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "stream">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "stream">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "stream">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "stream">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "stream">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "stream">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "stream">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "stream">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "stream">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "stream">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "stream">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "stream">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "stream">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "stream">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "stream">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "stream">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "stream">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "stream">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "stream">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "stream">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "stream">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "stream">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "stream">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "stream">, %arg152: memref<1xi128, "plio">, %arg153: memref<1xi128, "stream">, %arg154: memref<1xi128, "plio">, %arg155: memref<1xi128, "stream">, %arg156: memref<1xi128, "plio">, %arg157: memref<1xi128, "stream">, %arg158: memref<1xi128, "plio">, %arg159: memref<1xi128, "stream">, %arg160: memref<1xi128, "plio">, %arg161: memref<1xi128, "stream">, %arg162: memref<1xi128, "plio">, %arg163: memref<1xi128, "stream">, %arg164: memref<1xi128, "plio">, %arg165: memref<1xi128, "stream">, %arg166: memref<1xi128, "plio">, %arg167: memref<1xi128, "stream">, %arg168: memref<1xi128, "plio">, %arg169: memref<1xi128, "stream">, %arg170: memref<1xi128, "plio">, %arg171: memref<1xi128, "stream">, %arg172: memref<1xi128, "plio">, %arg173: memref<1xi128, "stream">, %arg174: memref<1xi128, "plio">, %arg175: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @receive13(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg8, %arg9) {template = 4 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg10, %arg11) {template = 5 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg12, %arg13) {template = 6 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg14, %arg15) {template = 7 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg16, %arg17) {template = 8 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg18, %arg19) {template = 9 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg20, %arg21) {template = 10 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg22, %arg23) {template = 11 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg24, %arg25) {template = 12 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg26, %arg27) {template = 13 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg28, %arg29) {template = 14 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg30, %arg31) {template = 15 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg32, %arg33) {template = 16 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg34, %arg35) {template = 17 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg36, %arg37) {template = 18 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg38, %arg39) {template = 19 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg40, %arg41) {template = 20 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg42, %arg43) {template = 21 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg44, %arg45) {template = 22 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg46, %arg47) {template = 23 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg48, %arg49) {template = 24 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg50, %arg51) {template = 25 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg52, %arg53) {template = 26 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg54, %arg55) {template = 27 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg56, %arg57) {template = 28 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg58, %arg59) {template = 29 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg60, %arg61) {template = 30 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg62, %arg63) {template = 31 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg64, %arg65) {template = 32 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg66, %arg67) {template = 33 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg68, %arg69) {template = 34 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg70, %arg71) {template = 35 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg72, %arg73) {template = 36 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg74, %arg75) {template = 37 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg76, %arg77) {template = 38 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg78, %arg79) {template = 39 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg80, %arg81) {template = 40 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg82, %arg83) {template = 41 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg84, %arg85) {template = 42 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg86, %arg87) {template = 43 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg88, %arg89) {template = 44 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg90, %arg91) {template = 45 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg92, %arg93) {template = 46 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg94, %arg95) {template = 47 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg96, %arg97) {template = 48 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg98, %arg99) {template = 49 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg100, %arg101) {template = 50 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg102, %arg103) {template = 51 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg104, %arg105) {template = 52 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg106, %arg107) {template = 53 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg108, %arg109) {template = 54 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg110, %arg111) {template = 55 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg112, %arg113) {template = 56 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg114, %arg115) {template = 57 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg116, %arg117) {template = 58 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg118, %arg119) {template = 59 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg120, %arg121) {template = 60 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg122, %arg123) {template = 61 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg124, %arg125) {template = 62 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg126, %arg127) {template = 63 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg128, %arg129) {template = 64 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg130, %arg131) {template = 65 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg132, %arg133) {template = 66 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg134, %arg135) {template = 67 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg136, %arg137) {template = 68 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg138, %arg139) {template = 69 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg140, %arg141) {template = 70 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg142, %arg143) {template = 71 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg144, %arg145) {template = 72 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg146, %arg147) {template = 73 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg148, %arg149) {template = 74 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg150, %arg151) {template = 75 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg152, %arg153) {template = 76 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg154, %arg155) {template = 77 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg156, %arg157) {template = 78 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg158, %arg159) {template = 79 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg160, %arg161) {template = 80 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg162, %arg163) {template = 81 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg164, %arg165) {template = 82 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg166, %arg167) {template = 83 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg168, %arg169) {template = 84 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg170, %arg171) {template = 85 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg172, %arg173) {template = 86 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg174, %arg175) {template = 87 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @send29_0(%arg0: memref<1xi128, "stream">, %arg1: memref<32x48xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 1 {
        affine.for %arg4 = 0 to 32 {
          affine.for %arg5 = 0 to 6 {
            affine.for %arg6 = 0 to 8 {
              %0 = affine.load %arg0[0] : memref<1xi128, "stream">
              affine.store %0, %arg1[%arg4 + %arg3 * 32, %arg6 + %arg5 * 8] : memref<32x48xi128, 1>
            } {pipeline_ii = 1 : index}
          }
        }
      }
    }
    return
  }
  func.func @send29_1(%arg0: memref<32x48xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 4 {
        affine.for %arg4 = 0 to 6 {
          affine.for %arg5 = 0 to 1 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %arg0[%arg6 + %arg5 * 32, %arg7 + %arg4 * 8] : memref<32x48xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "plio">
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @send29(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c128 = arith.constant 128 : index
    %true = arith.constant true
    %c64 = arith.constant 64 : index
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<32x48xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "bram_s2p"} : memref<32x48xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 64 {
          %0 = arith.muli %arg3, %c64 : index
          %1 = arith.addi %arg4, %0 : index
          %2 = arith.muli %arg2, %c128 : index
          %3 = arith.addi %1, %2 : index
          %4 = arith.remsi %3, %c2 : index
          %5 = arith.cmpi eq, %4, %c0 : index
          %6 = arith.cmpi ne, %3, %c0 : index
          scf.if %5 {
            func.call @send29_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<32x48xi128, 1>, i1) -> ()
            func.call @send29_1(%alloc_0, %arg0, %6) : (memref<32x48xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          } else {
            func.call @send29_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<32x48xi128, 1>, i1) -> ()
            func.call @send29_1(%alloc, %arg0, %6) : (memref<32x48xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          }
        } {Array_Partition, reduction}
      }
    }
    call @send29_1(%alloc_0, %arg0, %true) : (memref<32x48xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send29_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "stream">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "stream">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "stream">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "stream">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "stream">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "stream">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "stream">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "stream">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send29(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg8, %arg9) {template = 4 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg10, %arg11) {template = 5 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg12, %arg13) {template = 6 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg14, %arg15) {template = 7 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg16, %arg17) {template = 8 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg18, %arg19) {template = 9 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg20, %arg21) {template = 10 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg22, %arg23) {template = 11 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg24, %arg25) {template = 12 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg26, %arg27) {template = 13 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg28, %arg29) {template = 14 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg30, %arg31) {template = 15 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg32, %arg33) {template = 16 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg34, %arg35) {template = 17 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg36, %arg37) {template = 18 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg38, %arg39) {template = 19 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg40, %arg41) {template = 20 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg42, %arg43) {template = 21 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg44, %arg45) {template = 22 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg46, %arg47) {template = 23 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg48, %arg49) {template = 24 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg50, %arg51) {template = 25 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg52, %arg53) {template = 26 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg54, %arg55) {template = 27 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg56, %arg57) {template = 28 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg58, %arg59) {template = 29 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg60, %arg61) {template = 30 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29(%arg62, %arg63) {template = 31 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @send39_0(%arg0: memref<1xi128, "stream">, %arg1: memref<128x8xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 4 {
        affine.for %arg4 = 0 to 32 {
          affine.for %arg5 = 0 to 1 {
            affine.for %arg6 = 0 to 8 {
              %0 = affine.load %arg0[0] : memref<1xi128, "stream">
              affine.store %0, %arg1[%arg4 + %arg3 * 32, %arg6 + %arg5 * 8] : memref<128x8xi128, 1>
            } {pipeline_ii = 1 : index}
          }
        }
      }
    }
    return
  }
  func.func @send39_1(%arg0: memref<128x8xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 4 {
        affine.for %arg4 = 0 to 6 {
          affine.for %arg5 = 0 to 1 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %arg0[%arg6 + %arg3 * 32, %arg7 + %arg5 * 8] : memref<128x8xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "plio">
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @send39(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c128 = arith.constant 128 : index
    %true = arith.constant true
    %c64 = arith.constant 64 : index
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<128x8xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "bram_s2p"} : memref<128x8xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 64 {
          %0 = arith.muli %arg3, %c64 : index
          %1 = arith.addi %arg4, %0 : index
          %2 = arith.muli %arg2, %c128 : index
          %3 = arith.addi %1, %2 : index
          %4 = arith.remsi %3, %c2 : index
          %5 = arith.cmpi eq, %4, %c0 : index
          %6 = arith.cmpi ne, %3, %c0 : index
          scf.if %5 {
            func.call @send39_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<128x8xi128, 1>, i1) -> ()
            func.call @send39_1(%alloc_0, %arg0, %6) : (memref<128x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          } else {
            func.call @send39_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<128x8xi128, 1>, i1) -> ()
            func.call @send39_1(%alloc, %arg0, %6) : (memref<128x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
          }
        } {Array_Partition, reduction}
      }
    }
    call @send39_1(%alloc_0, %arg0, %true) : (memref<128x8xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send39_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "stream">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "stream">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "stream">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "stream">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "stream">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "stream">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "stream">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "stream">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "stream">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "stream">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "stream">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "stream">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "stream">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "stream">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "stream">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "stream">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "stream">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "stream">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "stream">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "stream">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send39(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg8, %arg9) {template = 4 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg10, %arg11) {template = 5 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg12, %arg13) {template = 6 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg14, %arg15) {template = 7 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg16, %arg17) {template = 8 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg18, %arg19) {template = 9 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg20, %arg21) {template = 10 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg22, %arg23) {template = 11 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg24, %arg25) {template = 12 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg26, %arg27) {template = 13 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg28, %arg29) {template = 14 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg30, %arg31) {template = 15 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg32, %arg33) {template = 16 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg34, %arg35) {template = 17 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg36, %arg37) {template = 18 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg38, %arg39) {template = 19 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg40, %arg41) {template = 20 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg42, %arg43) {template = 21 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg44, %arg45) {template = 22 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg46, %arg47) {template = 23 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg48, %arg49) {template = 24 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg50, %arg51) {template = 25 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg52, %arg53) {template = 26 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg54, %arg55) {template = 27 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg56, %arg57) {template = 28 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg58, %arg59) {template = 29 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg60, %arg61) {template = 30 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg62, %arg63) {template = 31 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg64, %arg65) {template = 32 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg66, %arg67) {template = 33 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg68, %arg69) {template = 34 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg70, %arg71) {template = 35 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg72, %arg73) {template = 36 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg74, %arg75) {template = 37 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg76, %arg77) {template = 38 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg78, %arg79) {template = 39 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg80, %arg81) {template = 40 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg82, %arg83) {template = 41 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg84, %arg85) {template = 42 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39(%arg86, %arg87) {template = 43 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @store0_0(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, store, template} {
    %c0_i512 = arith.constant 0 : i512
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 4 {
          affine.for %arg5 = 0 to 32 {
            affine.for %arg6 = 0 to 6 {
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
  func.func @store0_0_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi128, "stream">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi128, "stream">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi128, "stream">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi128, "stream">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi128, "stream">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi128, "stream">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi128, "stream">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi128, "stream">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi128, "stream">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi128, "stream">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi128, "stream">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi128, "stream">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi128, "stream">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi128, "stream">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi128, "stream">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi128, "stream">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi128, "stream">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi128, "stream">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi128, "stream">, %arg45: memref<1xi512, "stream2">, %arg46: memref<1xi128, "stream">, %arg47: memref<1xi512, "stream2">, %arg48: memref<1xi128, "stream">, %arg49: memref<1xi512, "stream2">, %arg50: memref<1xi128, "stream">, %arg51: memref<1xi512, "stream2">, %arg52: memref<1xi128, "stream">, %arg53: memref<1xi512, "stream2">, %arg54: memref<1xi128, "stream">, %arg55: memref<1xi512, "stream2">, %arg56: memref<1xi128, "stream">, %arg57: memref<1xi512, "stream2">, %arg58: memref<1xi128, "stream">, %arg59: memref<1xi512, "stream2">, %arg60: memref<1xi128, "stream">, %arg61: memref<1xi512, "stream2">, %arg62: memref<1xi128, "stream">, %arg63: memref<1xi512, "stream2">, %arg64: memref<1xi128, "stream">, %arg65: memref<1xi512, "stream2">, %arg66: memref<1xi128, "stream">, %arg67: memref<1xi512, "stream2">, %arg68: memref<1xi128, "stream">, %arg69: memref<1xi512, "stream2">, %arg70: memref<1xi128, "stream">, %arg71: memref<1xi512, "stream2">, %arg72: memref<1xi128, "stream">, %arg73: memref<1xi512, "stream2">, %arg74: memref<1xi128, "stream">, %arg75: memref<1xi512, "stream2">, %arg76: memref<1xi128, "stream">, %arg77: memref<1xi512, "stream2">, %arg78: memref<1xi128, "stream">, %arg79: memref<1xi512, "stream2">, %arg80: memref<1xi128, "stream">, %arg81: memref<1xi512, "stream2">, %arg82: memref<1xi128, "stream">, %arg83: memref<1xi512, "stream2">, %arg84: memref<1xi128, "stream">, %arg85: memref<1xi512, "stream2">, %arg86: memref<1xi128, "stream">, %arg87: memref<1xi512, "stream2">, %arg88: memref<1xi128, "stream">, %arg89: memref<1xi512, "stream2">, %arg90: memref<1xi128, "stream">, %arg91: memref<1xi512, "stream2">, %arg92: memref<1xi128, "stream">, %arg93: memref<1xi512, "stream2">, %arg94: memref<1xi128, "stream">, %arg95: memref<1xi512, "stream2">, %arg96: memref<1xi128, "stream">, %arg97: memref<1xi512, "stream2">, %arg98: memref<1xi128, "stream">, %arg99: memref<1xi512, "stream2">, %arg100: memref<1xi128, "stream">, %arg101: memref<1xi512, "stream2">, %arg102: memref<1xi128, "stream">, %arg103: memref<1xi512, "stream2">, %arg104: memref<1xi128, "stream">, %arg105: memref<1xi512, "stream2">, %arg106: memref<1xi128, "stream">, %arg107: memref<1xi512, "stream2">, %arg108: memref<1xi128, "stream">, %arg109: memref<1xi512, "stream2">, %arg110: memref<1xi128, "stream">, %arg111: memref<1xi512, "stream2">, %arg112: memref<1xi128, "stream">, %arg113: memref<1xi512, "stream2">, %arg114: memref<1xi128, "stream">, %arg115: memref<1xi512, "stream2">, %arg116: memref<1xi128, "stream">, %arg117: memref<1xi512, "stream2">, %arg118: memref<1xi128, "stream">, %arg119: memref<1xi512, "stream2">, %arg120: memref<1xi128, "stream">, %arg121: memref<1xi512, "stream2">, %arg122: memref<1xi128, "stream">, %arg123: memref<1xi512, "stream2">, %arg124: memref<1xi128, "stream">, %arg125: memref<1xi512, "stream2">, %arg126: memref<1xi128, "stream">, %arg127: memref<1xi512, "stream2">, %arg128: memref<1xi128, "stream">, %arg129: memref<1xi512, "stream2">, %arg130: memref<1xi128, "stream">, %arg131: memref<1xi512, "stream2">, %arg132: memref<1xi128, "stream">, %arg133: memref<1xi512, "stream2">, %arg134: memref<1xi128, "stream">, %arg135: memref<1xi512, "stream2">, %arg136: memref<1xi128, "stream">, %arg137: memref<1xi512, "stream2">, %arg138: memref<1xi128, "stream">, %arg139: memref<1xi512, "stream2">, %arg140: memref<1xi128, "stream">, %arg141: memref<1xi512, "stream2">, %arg142: memref<1xi128, "stream">, %arg143: memref<1xi512, "stream2">, %arg144: memref<1xi128, "stream">, %arg145: memref<1xi512, "stream2">, %arg146: memref<1xi128, "stream">, %arg147: memref<1xi512, "stream2">, %arg148: memref<1xi128, "stream">, %arg149: memref<1xi512, "stream2">, %arg150: memref<1xi128, "stream">, %arg151: memref<1xi512, "stream2">, %arg152: memref<1xi128, "stream">, %arg153: memref<1xi512, "stream2">, %arg154: memref<1xi128, "stream">, %arg155: memref<1xi512, "stream2">, %arg156: memref<1xi128, "stream">, %arg157: memref<1xi512, "stream2">, %arg158: memref<1xi128, "stream">, %arg159: memref<1xi512, "stream2">, %arg160: memref<1xi128, "stream">, %arg161: memref<1xi512, "stream2">, %arg162: memref<1xi128, "stream">, %arg163: memref<1xi512, "stream2">, %arg164: memref<1xi128, "stream">, %arg165: memref<1xi512, "stream2">, %arg166: memref<1xi128, "stream">, %arg167: memref<1xi512, "stream2">, %arg168: memref<1xi128, "stream">, %arg169: memref<1xi512, "stream2">, %arg170: memref<1xi128, "stream">, %arg171: memref<1xi512, "stream2">, %arg172: memref<1xi128, "stream">, %arg173: memref<1xi512, "stream2">, %arg174: memref<1xi128, "stream">, %arg175: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @store0_0(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg8, %arg9) {template = 4 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg10, %arg11) {template = 5 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg12, %arg13) {template = 6 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg14, %arg15) {template = 7 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg16, %arg17) {template = 8 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg18, %arg19) {template = 9 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg20, %arg21) {template = 10 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg22, %arg23) {template = 11 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg24, %arg25) {template = 12 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg26, %arg27) {template = 13 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg28, %arg29) {template = 14 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg30, %arg31) {template = 15 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg32, %arg33) {template = 16 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg34, %arg35) {template = 17 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg36, %arg37) {template = 18 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg38, %arg39) {template = 19 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg40, %arg41) {template = 20 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg42, %arg43) {template = 21 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg44, %arg45) {template = 22 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg46, %arg47) {template = 23 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg48, %arg49) {template = 24 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg50, %arg51) {template = 25 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg52, %arg53) {template = 26 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg54, %arg55) {template = 27 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg56, %arg57) {template = 28 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg58, %arg59) {template = 29 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg60, %arg61) {template = 30 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg62, %arg63) {template = 31 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg64, %arg65) {template = 32 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg66, %arg67) {template = 33 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg68, %arg69) {template = 34 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg70, %arg71) {template = 35 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg72, %arg73) {template = 36 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg74, %arg75) {template = 37 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg76, %arg77) {template = 38 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg78, %arg79) {template = 39 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg80, %arg81) {template = 40 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg82, %arg83) {template = 41 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg84, %arg85) {template = 42 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg86, %arg87) {template = 43 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg88, %arg89) {template = 44 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg90, %arg91) {template = 45 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg92, %arg93) {template = 46 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg94, %arg95) {template = 47 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg96, %arg97) {template = 48 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg98, %arg99) {template = 49 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg100, %arg101) {template = 50 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg102, %arg103) {template = 51 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg104, %arg105) {template = 52 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg106, %arg107) {template = 53 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg108, %arg109) {template = 54 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg110, %arg111) {template = 55 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg112, %arg113) {template = 56 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg114, %arg115) {template = 57 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg116, %arg117) {template = 58 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg118, %arg119) {template = 59 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg120, %arg121) {template = 60 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg122, %arg123) {template = 61 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg124, %arg125) {template = 62 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg126, %arg127) {template = 63 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg128, %arg129) {template = 64 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg130, %arg131) {template = 65 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg132, %arg133) {template = 66 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg134, %arg135) {template = 67 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg136, %arg137) {template = 68 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg138, %arg139) {template = 69 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg140, %arg141) {template = 70 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg142, %arg143) {template = 71 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg144, %arg145) {template = 72 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg146, %arg147) {template = 73 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg148, %arg149) {template = 74 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg150, %arg151) {template = 75 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg152, %arg153) {template = 76 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg154, %arg155) {template = 77 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg156, %arg157) {template = 78 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg158, %arg159) {template = 79 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg160, %arg161) {template = 80 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg162, %arg163) {template = 81 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg164, %arg165) {template = 82 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg166, %arg167) {template = 83 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg168, %arg169) {template = 84 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg170, %arg171) {template = 85 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg172, %arg173) {template = 86 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg174, %arg175) {template = 87 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @store0(%arg0: memref<2816x192xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi512, "stream2">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi512, "stream2">, %arg48: memref<1xi512, "stream2">, %arg49: memref<1xi512, "stream2">, %arg50: memref<1xi512, "stream2">, %arg51: memref<1xi512, "stream2">, %arg52: memref<1xi512, "stream2">, %arg53: memref<1xi512, "stream2">, %arg54: memref<1xi512, "stream2">, %arg55: memref<1xi512, "stream2">, %arg56: memref<1xi512, "stream2">, %arg57: memref<1xi512, "stream2">, %arg58: memref<1xi512, "stream2">, %arg59: memref<1xi512, "stream2">, %arg60: memref<1xi512, "stream2">, %arg61: memref<1xi512, "stream2">, %arg62: memref<1xi512, "stream2">, %arg63: memref<1xi512, "stream2">, %arg64: memref<1xi512, "stream2">, %arg65: memref<1xi512, "stream2">, %arg66: memref<1xi512, "stream2">, %arg67: memref<1xi512, "stream2">, %arg68: memref<1xi512, "stream2">, %arg69: memref<1xi512, "stream2">, %arg70: memref<1xi512, "stream2">, %arg71: memref<1xi512, "stream2">, %arg72: memref<1xi512, "stream2">, %arg73: memref<1xi512, "stream2">, %arg74: memref<1xi512, "stream2">, %arg75: memref<1xi512, "stream2">, %arg76: memref<1xi512, "stream2">, %arg77: memref<1xi512, "stream2">, %arg78: memref<1xi512, "stream2">, %arg79: memref<1xi512, "stream2">, %arg80: memref<1xi512, "stream2">, %arg81: memref<1xi512, "stream2">, %arg82: memref<1xi512, "stream2">, %arg83: memref<1xi512, "stream2">, %arg84: memref<1xi512, "stream2">, %arg85: memref<1xi512, "stream2">, %arg86: memref<1xi512, "stream2">, %arg87: memref<1xi512, "stream2">, %arg88: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
    %c14 = arith.constant 14 : index
    %c12 = arith.constant 12 : index
    %c10 = arith.constant 10 : index
    %c8 = arith.constant 8 : index
    %c6 = arith.constant 6 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    affine.for %arg89 = 0 to 2 {
      affine.for %arg90 = 0 to 2 {
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg8[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg61[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg2[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg65[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg28[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg31[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg82[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg67[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg80[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg35[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg69[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg59[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg81[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg27[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg14[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg5[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 32, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg40[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg76[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg87[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg79[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg4[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg18[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg30[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg42[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 64, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg41[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg74[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg66[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg53[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg37[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg34[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg22[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg16[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 96, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg7[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg20[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg15[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg56[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg63[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg50[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg44[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg21[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 128, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg75[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg72[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg60[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg9[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg12[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg11[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg85[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg24[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 160, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg77[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg3[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg29[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg52[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg55[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg68[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg38[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg78[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 192, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg49[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg51[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg19[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg10[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg64[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg46[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg13[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg54[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 224, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg17[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg45[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg25[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg39[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg26[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg86[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg62[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg88[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 256, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg47[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg48[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg57[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg32[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg1[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg33[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg58[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg83[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 288, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg91 = 0 to 4 {
          affine.for %arg92 = 0 to 32 {
            affine.for %arg93 = 0 to 6 {
              affine.for %arg94 = 0 to 16 {
                %0 = arith.cmpi slt, %arg94, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg70[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg94, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg43[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg94, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg23[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg94, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg71[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg94, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg73[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg94, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg6[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg94, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg36[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = affine.load %arg84[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            }
                            scf.yield %13 : i512
                          }
                          scf.yield %11 : i512
                        }
                        scf.yield %9 : i512
                      }
                      scf.yield %7 : i512
                    }
                    scf.yield %5 : i512
                  }
                  scf.yield %3 : i512
                }
                affine.store %1, %arg0[%arg92 + %arg91 * 352 + %arg89 * 1408 + 320, %arg94 + %arg93 * 16 + %arg90 * 96] : memref<2816x192xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
      }
    }
    return
  }
  func.func @store0_top(%arg0: memref<2816x192xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi512, "stream2">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi512, "stream2">, %arg48: memref<1xi512, "stream2">, %arg49: memref<1xi512, "stream2">, %arg50: memref<1xi512, "stream2">, %arg51: memref<1xi512, "stream2">, %arg52: memref<1xi512, "stream2">, %arg53: memref<1xi512, "stream2">, %arg54: memref<1xi512, "stream2">, %arg55: memref<1xi512, "stream2">, %arg56: memref<1xi512, "stream2">, %arg57: memref<1xi512, "stream2">, %arg58: memref<1xi512, "stream2">, %arg59: memref<1xi512, "stream2">, %arg60: memref<1xi512, "stream2">, %arg61: memref<1xi512, "stream2">, %arg62: memref<1xi512, "stream2">, %arg63: memref<1xi512, "stream2">, %arg64: memref<1xi512, "stream2">, %arg65: memref<1xi512, "stream2">, %arg66: memref<1xi512, "stream2">, %arg67: memref<1xi512, "stream2">, %arg68: memref<1xi512, "stream2">, %arg69: memref<1xi512, "stream2">, %arg70: memref<1xi512, "stream2">, %arg71: memref<1xi512, "stream2">, %arg72: memref<1xi512, "stream2">, %arg73: memref<1xi512, "stream2">, %arg74: memref<1xi512, "stream2">, %arg75: memref<1xi512, "stream2">, %arg76: memref<1xi512, "stream2">, %arg77: memref<1xi512, "stream2">, %arg78: memref<1xi512, "stream2">, %arg79: memref<1xi512, "stream2">, %arg80: memref<1xi512, "stream2">, %arg81: memref<1xi512, "stream2">, %arg82: memref<1xi512, "stream2">, %arg83: memref<1xi512, "stream2">, %arg84: memref<1xi512, "stream2">, %arg85: memref<1xi512, "stream2">, %arg86: memref<1xi512, "stream2">, %arg87: memref<1xi512, "stream2">, %arg88: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @store0(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44, %arg45, %arg46, %arg47, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68, %arg69, %arg70, %arg71, %arg72, %arg73, %arg74, %arg75, %arg76, %arg77, %arg78, %arg79, %arg80, %arg81, %arg82, %arg83, %arg84, %arg85, %arg86, %arg87, %arg88) {template = 0 : index} : (memref<2816x192xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load0(%arg0: memref<2816x512xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c6 = arith.constant 6 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    affine.for %arg45 = 0 to 2 {
      affine.for %arg46 = 0 to 2 {
        affine.for %arg47 = 0 to 64 {
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg34[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg14[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg21[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg12[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 32, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg9[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg18[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg17[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 64, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg11[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg31[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg43[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 96, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg5[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg16[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg30[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg8[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 128, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg20[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg23[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg33[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 160, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg28[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg29[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg41[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg22[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 192, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg32[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg15[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg27[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 224, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg6[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg19[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg35[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg7[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 256, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg26[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg24[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg38[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg13[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 288, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg36[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg10[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg25[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg37[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg48 = 0 to 4 {
            affine.for %arg49 = 0 to 32 {
              affine.for %arg50 = 0 to 1 {
                affine.for %arg51 = 0 to 8 {
                  %0 = affine.load %arg0[%arg49 + %arg48 * 352 + %arg45 * 1408 + 320, %arg51 + %arg50 * 8 + %arg47 * 8] : memref<2816x512xi512>
                  %1 = arith.cmpi slt, %arg51, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg39[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg51, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg40[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg51, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg42[0] : memref<1xi512, "stream2">
                      } else {
                        affine.store %0, %arg44[0] : memref<1xi512, "stream2">
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
        } {Array_Partition, reduction}
      }
    }
    return
  }
  func.func @load0_top(%arg0: memref<2816x512xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load0(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44) {template = 0 : index} : (memref<2816x512xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load0_43(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 64 {
          affine.for %arg5 = 0 to 4 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 1 {
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
  func.func @load0_43_top(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi128, "stream">, %arg48: memref<1xi512, "stream2">, %arg49: memref<1xi128, "stream">, %arg50: memref<1xi512, "stream2">, %arg51: memref<1xi128, "stream">, %arg52: memref<1xi512, "stream2">, %arg53: memref<1xi128, "stream">, %arg54: memref<1xi512, "stream2">, %arg55: memref<1xi128, "stream">, %arg56: memref<1xi512, "stream2">, %arg57: memref<1xi128, "stream">, %arg58: memref<1xi512, "stream2">, %arg59: memref<1xi128, "stream">, %arg60: memref<1xi512, "stream2">, %arg61: memref<1xi128, "stream">, %arg62: memref<1xi512, "stream2">, %arg63: memref<1xi128, "stream">, %arg64: memref<1xi512, "stream2">, %arg65: memref<1xi128, "stream">, %arg66: memref<1xi512, "stream2">, %arg67: memref<1xi128, "stream">, %arg68: memref<1xi512, "stream2">, %arg69: memref<1xi128, "stream">, %arg70: memref<1xi512, "stream2">, %arg71: memref<1xi128, "stream">, %arg72: memref<1xi512, "stream2">, %arg73: memref<1xi128, "stream">, %arg74: memref<1xi512, "stream2">, %arg75: memref<1xi128, "stream">, %arg76: memref<1xi512, "stream2">, %arg77: memref<1xi128, "stream">, %arg78: memref<1xi512, "stream2">, %arg79: memref<1xi128, "stream">, %arg80: memref<1xi512, "stream2">, %arg81: memref<1xi128, "stream">, %arg82: memref<1xi512, "stream2">, %arg83: memref<1xi128, "stream">, %arg84: memref<1xi512, "stream2">, %arg85: memref<1xi128, "stream">, %arg86: memref<1xi512, "stream2">, %arg87: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @load0_43(%arg0, %arg1) {template = 0 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg2, %arg3) {template = 1 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg4, %arg5) {template = 2 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg6, %arg7) {template = 3 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg8, %arg9) {template = 4 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg10, %arg11) {template = 5 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg12, %arg13) {template = 6 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg14, %arg15) {template = 7 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg16, %arg17) {template = 8 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg18, %arg19) {template = 9 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg20, %arg21) {template = 10 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg22, %arg23) {template = 11 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg24, %arg25) {template = 12 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg26, %arg27) {template = 13 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg28, %arg29) {template = 14 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg30, %arg31) {template = 15 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg32, %arg33) {template = 16 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg34, %arg35) {template = 17 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg36, %arg37) {template = 18 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg38, %arg39) {template = 19 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg40, %arg41) {template = 20 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg42, %arg43) {template = 21 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg44, %arg45) {template = 22 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg46, %arg47) {template = 23 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg48, %arg49) {template = 24 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg50, %arg51) {template = 25 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg52, %arg53) {template = 26 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg54, %arg55) {template = 27 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg56, %arg57) {template = 28 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg58, %arg59) {template = 29 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg60, %arg61) {template = 30 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg62, %arg63) {template = 31 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg64, %arg65) {template = 32 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg66, %arg67) {template = 33 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg68, %arg69) {template = 34 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg70, %arg71) {template = 35 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg72, %arg73) {template = 36 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg74, %arg75) {template = 37 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg76, %arg77) {template = 38 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg78, %arg79) {template = 39 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg80, %arg81) {template = 40 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg82, %arg83) {template = 41 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg84, %arg85) {template = 42 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_43(%arg86, %arg87) {template = 43 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @load1(%arg0: memref<8192x192xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c14 = arith.constant 14 : index
    %c12 = arith.constant 12 : index
    %c10 = arith.constant 10 : index
    %c8 = arith.constant 8 : index
    %c6 = arith.constant 6 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    affine.for %arg33 = 0 to 2 {
      affine.for %arg34 = 0 to 2 {
        affine.for %arg35 = 0 to 64 {
          affine.for %arg36 = 0 to 1 {
            affine.for %arg37 = 0 to 32 {
              affine.for %arg38 = 0 to 6 {
                affine.for %arg39 = 0 to 16 {
                  %0 = affine.load %arg0[%arg37 + %arg36 * 128 + %arg35 * 128, %arg39 + %arg38 * 16 + %arg34 * 96] : memref<8192x192xi512>
                  %1 = arith.cmpi slt, %arg39, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg6[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg39, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg39, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg27[0] : memref<1xi512, "stream2">
                      } else {
                        %4 = arith.cmpi slt, %arg39, %c8 : index
                        scf.if %4 {
                          affine.store %0, %arg29[0] : memref<1xi512, "stream2">
                        } else {
                          %5 = arith.cmpi slt, %arg39, %c10 : index
                          scf.if %5 {
                            affine.store %0, %arg20[0] : memref<1xi512, "stream2">
                          } else {
                            %6 = arith.cmpi slt, %arg39, %c12 : index
                            scf.if %6 {
                              affine.store %0, %arg5[0] : memref<1xi512, "stream2">
                            } else {
                              %7 = arith.cmpi slt, %arg39, %c14 : index
                              scf.if %7 {
                                affine.store %0, %arg19[0] : memref<1xi512, "stream2">
                              } else {
                                affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg36 = 0 to 1 {
            affine.for %arg37 = 0 to 32 {
              affine.for %arg38 = 0 to 6 {
                affine.for %arg39 = 0 to 16 {
                  %0 = affine.load %arg0[%arg37 + %arg36 * 128 + %arg35 * 128 + 32, %arg39 + %arg38 * 16 + %arg34 * 96] : memref<8192x192xi512>
                  %1 = arith.cmpi slt, %arg39, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg8[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg39, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg12[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg39, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg17[0] : memref<1xi512, "stream2">
                      } else {
                        %4 = arith.cmpi slt, %arg39, %c8 : index
                        scf.if %4 {
                          affine.store %0, %arg18[0] : memref<1xi512, "stream2">
                        } else {
                          %5 = arith.cmpi slt, %arg39, %c10 : index
                          scf.if %5 {
                            affine.store %0, %arg21[0] : memref<1xi512, "stream2">
                          } else {
                            %6 = arith.cmpi slt, %arg39, %c12 : index
                            scf.if %6 {
                              affine.store %0, %arg14[0] : memref<1xi512, "stream2">
                            } else {
                              %7 = arith.cmpi slt, %arg39, %c14 : index
                              scf.if %7 {
                                affine.store %0, %arg15[0] : memref<1xi512, "stream2">
                              } else {
                                affine.store %0, %arg10[0] : memref<1xi512, "stream2">
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg36 = 0 to 1 {
            affine.for %arg37 = 0 to 32 {
              affine.for %arg38 = 0 to 6 {
                affine.for %arg39 = 0 to 16 {
                  %0 = affine.load %arg0[%arg37 + %arg36 * 128 + %arg35 * 128 + 64, %arg39 + %arg38 * 16 + %arg34 * 96] : memref<8192x192xi512>
                  %1 = arith.cmpi slt, %arg39, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg39, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg22[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg39, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg11[0] : memref<1xi512, "stream2">
                      } else {
                        %4 = arith.cmpi slt, %arg39, %c8 : index
                        scf.if %4 {
                          affine.store %0, %arg32[0] : memref<1xi512, "stream2">
                        } else {
                          %5 = arith.cmpi slt, %arg39, %c10 : index
                          scf.if %5 {
                            affine.store %0, %arg26[0] : memref<1xi512, "stream2">
                          } else {
                            %6 = arith.cmpi slt, %arg39, %c12 : index
                            scf.if %6 {
                              affine.store %0, %arg23[0] : memref<1xi512, "stream2">
                            } else {
                              %7 = arith.cmpi slt, %arg39, %c14 : index
                              scf.if %7 {
                                affine.store %0, %arg9[0] : memref<1xi512, "stream2">
                              } else {
                                affine.store %0, %arg7[0] : memref<1xi512, "stream2">
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
          affine.for %arg36 = 0 to 1 {
            affine.for %arg37 = 0 to 32 {
              affine.for %arg38 = 0 to 6 {
                affine.for %arg39 = 0 to 16 {
                  %0 = affine.load %arg0[%arg37 + %arg36 * 128 + %arg35 * 128 + 96, %arg39 + %arg38 * 16 + %arg34 * 96] : memref<8192x192xi512>
                  %1 = arith.cmpi slt, %arg39, %c2 : index
                  scf.if %1 {
                    affine.store %0, %arg13[0] : memref<1xi512, "stream2">
                  } else {
                    %2 = arith.cmpi slt, %arg39, %c4 : index
                    scf.if %2 {
                      affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                    } else {
                      %3 = arith.cmpi slt, %arg39, %c6 : index
                      scf.if %3 {
                        affine.store %0, %arg28[0] : memref<1xi512, "stream2">
                      } else {
                        %4 = arith.cmpi slt, %arg39, %c8 : index
                        scf.if %4 {
                          affine.store %0, %arg25[0] : memref<1xi512, "stream2">
                        } else {
                          %5 = arith.cmpi slt, %arg39, %c10 : index
                          scf.if %5 {
                            affine.store %0, %arg16[0] : memref<1xi512, "stream2">
                          } else {
                            %6 = arith.cmpi slt, %arg39, %c12 : index
                            scf.if %6 {
                              affine.store %0, %arg24[0] : memref<1xi512, "stream2">
                            } else {
                              %7 = arith.cmpi slt, %arg39, %c14 : index
                              scf.if %7 {
                                affine.store %0, %arg31[0] : memref<1xi512, "stream2">
                              } else {
                                affine.store %0, %arg30[0] : memref<1xi512, "stream2">
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                } {pipeline_ii = 1 : index}
              }
            }
          } {merge}
        } {Array_Partition, reduction}
      }
    }
    return
  }
  func.func @load1_top(%arg0: memref<8192x192xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load1(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32) {template = 0 : index} : (memref<8192x192xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load1_31(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 64 {
          affine.for %arg5 = 0 to 1 {
            affine.for %arg6 = 0 to 32 {
              affine.for %arg7 = 0 to 6 {
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
  func.func @load1_31_top(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi128, "stream">, %arg48: memref<1xi512, "stream2">, %arg49: memref<1xi128, "stream">, %arg50: memref<1xi512, "stream2">, %arg51: memref<1xi128, "stream">, %arg52: memref<1xi512, "stream2">, %arg53: memref<1xi128, "stream">, %arg54: memref<1xi512, "stream2">, %arg55: memref<1xi128, "stream">, %arg56: memref<1xi512, "stream2">, %arg57: memref<1xi128, "stream">, %arg58: memref<1xi512, "stream2">, %arg59: memref<1xi128, "stream">, %arg60: memref<1xi512, "stream2">, %arg61: memref<1xi128, "stream">, %arg62: memref<1xi512, "stream2">, %arg63: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @load1_31(%arg0, %arg1) {template = 0 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg2, %arg3) {template = 1 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg4, %arg5) {template = 2 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg6, %arg7) {template = 3 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg8, %arg9) {template = 4 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg10, %arg11) {template = 5 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg12, %arg13) {template = 6 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg14, %arg15) {template = 7 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg16, %arg17) {template = 8 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg18, %arg19) {template = 9 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg20, %arg21) {template = 10 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg22, %arg23) {template = 11 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg24, %arg25) {template = 12 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg26, %arg27) {template = 13 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg28, %arg29) {template = 14 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg30, %arg31) {template = 15 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg32, %arg33) {template = 16 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg34, %arg35) {template = 17 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg36, %arg37) {template = 18 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg38, %arg39) {template = 19 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg40, %arg41) {template = 20 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg42, %arg43) {template = 21 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg44, %arg45) {template = 22 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg46, %arg47) {template = 23 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg48, %arg49) {template = 24 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg50, %arg51) {template = 25 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg52, %arg53) {template = 26 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg54, %arg55) {template = 27 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg56, %arg57) {template = 28 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg58, %arg59) {template = 29 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg60, %arg61) {template = 30 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_31(%arg62, %arg63) {template = 31 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @gemm_pl(%arg0: memref<2816x512xi512>, %arg1: memref<8192x192xi512>, %arg2: memref<2816x192xi512>, %arg3: memref<1xi128, "plio">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "plio">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "plio">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "plio">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "plio">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "plio">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "plio">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "plio">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "plio">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "plio">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "plio">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "plio">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "plio">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "plio">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "plio">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "plio">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "plio">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "plio">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "plio">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "plio">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "plio">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "plio">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "plio">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "plio">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "plio">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "plio">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "plio">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "plio">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "plio">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "plio">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "plio">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "plio">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "plio">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "plio">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "plio">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "plio">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "plio">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "plio">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "plio">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "plio">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "plio">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "plio">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "plio">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "plio">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "plio">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "plio">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "plio">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "plio">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "plio">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "plio">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "plio">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "plio">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "plio">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "plio">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "plio">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "plio">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "plio">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "plio">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "plio">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "plio">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "plio">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "plio">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "plio">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "plio">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "plio">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "plio">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "plio">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "plio">, %arg152: memref<1xi128, "plio">, %arg153: memref<1xi128, "plio">, %arg154: memref<1xi128, "plio">, %arg155: memref<1xi128, "plio">, %arg156: memref<1xi128, "plio">, %arg157: memref<1xi128, "plio">, %arg158: memref<1xi128, "plio">, %arg159: memref<1xi128, "plio">, %arg160: memref<1xi128, "plio">, %arg161: memref<1xi128, "plio">, %arg162: memref<1xi128, "plio">, %arg163: memref<1xi128, "plio">, %arg164: memref<1xi128, "plio">, %arg165: memref<1xi128, "plio">, %arg166: memref<1xi128, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32], mem_type = [f32, f32, f32]} {
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
    %alloc_11 = memref.alloc() : memref<1xi128, "stream">
    %alloc_12 = memref.alloc() : memref<1xi128, "stream">
    %alloc_13 = memref.alloc() : memref<1xi128, "stream">
    %alloc_14 = memref.alloc() : memref<1xi128, "stream">
    %alloc_15 = memref.alloc() : memref<1xi128, "stream">
    %alloc_16 = memref.alloc() : memref<1xi128, "stream">
    %alloc_17 = memref.alloc() : memref<1xi128, "stream">
    %alloc_18 = memref.alloc() : memref<1xi128, "stream">
    %alloc_19 = memref.alloc() : memref<1xi128, "stream">
    %alloc_20 = memref.alloc() : memref<1xi128, "stream">
    %alloc_21 = memref.alloc() : memref<1xi128, "stream">
    %alloc_22 = memref.alloc() : memref<1xi128, "stream">
    %alloc_23 = memref.alloc() : memref<1xi128, "stream">
    %alloc_24 = memref.alloc() : memref<1xi128, "stream">
    %alloc_25 = memref.alloc() : memref<1xi128, "stream">
    %alloc_26 = memref.alloc() : memref<1xi128, "stream">
    %alloc_27 = memref.alloc() : memref<1xi128, "stream">
    %alloc_28 = memref.alloc() : memref<1xi128, "stream">
    %alloc_29 = memref.alloc() : memref<1xi128, "stream">
    %alloc_30 = memref.alloc() : memref<1xi128, "stream">
    %alloc_31 = memref.alloc() : memref<1xi128, "stream">
    %alloc_32 = memref.alloc() : memref<1xi128, "stream">
    %alloc_33 = memref.alloc() : memref<1xi128, "stream">
    %alloc_34 = memref.alloc() : memref<1xi128, "stream">
    %alloc_35 = memref.alloc() : memref<1xi128, "stream">
    %alloc_36 = memref.alloc() : memref<1xi128, "stream">
    %alloc_37 = memref.alloc() : memref<1xi128, "stream">
    %alloc_38 = memref.alloc() : memref<1xi128, "stream">
    %alloc_39 = memref.alloc() : memref<1xi128, "stream">
    %alloc_40 = memref.alloc() : memref<1xi128, "stream">
    %alloc_41 = memref.alloc() : memref<1xi128, "stream">
    %alloc_42 = memref.alloc() : memref<1xi128, "stream">
    %alloc_43 = memref.alloc() : memref<1xi128, "stream">
    %alloc_44 = memref.alloc() : memref<1xi128, "stream">
    %alloc_45 = memref.alloc() : memref<1xi128, "stream">
    %alloc_46 = memref.alloc() : memref<1xi128, "stream">
    %alloc_47 = memref.alloc() : memref<1xi128, "stream">
    %alloc_48 = memref.alloc() : memref<1xi128, "stream">
    %alloc_49 = memref.alloc() : memref<1xi128, "stream">
    %alloc_50 = memref.alloc() : memref<1xi128, "stream">
    %alloc_51 = memref.alloc() : memref<1xi128, "stream">
    %alloc_52 = memref.alloc() : memref<1xi128, "stream">
    %alloc_53 = memref.alloc() : memref<1xi128, "stream">
    %alloc_54 = memref.alloc() : memref<1xi128, "stream">
    %alloc_55 = memref.alloc() : memref<1xi128, "stream">
    %alloc_56 = memref.alloc() : memref<1xi128, "stream">
    %alloc_57 = memref.alloc() : memref<1xi128, "stream">
    %alloc_58 = memref.alloc() : memref<1xi128, "stream">
    %alloc_59 = memref.alloc() : memref<1xi128, "stream">
    %alloc_60 = memref.alloc() : memref<1xi128, "stream">
    %alloc_61 = memref.alloc() : memref<1xi128, "stream">
    %alloc_62 = memref.alloc() : memref<1xi128, "stream">
    %alloc_63 = memref.alloc() : memref<1xi128, "stream">
    %alloc_64 = memref.alloc() : memref<1xi128, "stream">
    %alloc_65 = memref.alloc() : memref<1xi128, "stream">
    %alloc_66 = memref.alloc() : memref<1xi128, "stream">
    %alloc_67 = memref.alloc() : memref<1xi128, "stream">
    %alloc_68 = memref.alloc() : memref<1xi128, "stream">
    %alloc_69 = memref.alloc() : memref<1xi128, "stream">
    %alloc_70 = memref.alloc() : memref<1xi128, "stream">
    %alloc_71 = memref.alloc() : memref<1xi128, "stream">
    %alloc_72 = memref.alloc() : memref<1xi128, "stream">
    %alloc_73 = memref.alloc() : memref<1xi128, "stream">
    %alloc_74 = memref.alloc() : memref<1xi128, "stream">
    %alloc_75 = memref.alloc() : memref<1xi128, "stream">
    %alloc_76 = memref.alloc() : memref<1xi128, "stream">
    %alloc_77 = memref.alloc() : memref<1xi128, "stream">
    %alloc_78 = memref.alloc() : memref<1xi128, "stream">
    %alloc_79 = memref.alloc() : memref<1xi128, "stream">
    %alloc_80 = memref.alloc() : memref<1xi128, "stream">
    %alloc_81 = memref.alloc() : memref<1xi128, "stream">
    %alloc_82 = memref.alloc() : memref<1xi128, "stream">
    %alloc_83 = memref.alloc() : memref<1xi128, "stream">
    %alloc_84 = memref.alloc() : memref<1xi128, "stream">
    %alloc_85 = memref.alloc() : memref<1xi128, "stream">
    %alloc_86 = memref.alloc() : memref<1xi128, "stream">
    %alloc_87 = memref.alloc() : memref<1xi128, "stream">
    %alloc_88 = memref.alloc() : memref<1xi128, "stream">
    %alloc_89 = memref.alloc() : memref<1xi128, "stream">
    %alloc_90 = memref.alloc() : memref<1xi128, "stream">
    %alloc_91 = memref.alloc() : memref<1xi128, "stream">
    %alloc_92 = memref.alloc() : memref<1xi128, "stream">
    %alloc_93 = memref.alloc() : memref<1xi128, "stream">
    %alloc_94 = memref.alloc() : memref<1xi128, "stream">
    %alloc_95 = memref.alloc() : memref<1xi128, "stream">
    %alloc_96 = memref.alloc() : memref<1xi128, "stream">
    %alloc_97 = memref.alloc() : memref<1xi128, "stream">
    %alloc_98 = memref.alloc() : memref<1xi128, "stream">
    %alloc_99 = memref.alloc() : memref<1xi128, "stream">
    %alloc_100 = memref.alloc() : memref<1xi128, "stream">
    %alloc_101 = memref.alloc() : memref<1xi128, "stream">
    %alloc_102 = memref.alloc() : memref<1xi128, "stream">
    %alloc_103 = memref.alloc() : memref<1xi128, "stream">
    %alloc_104 = memref.alloc() : memref<1xi128, "stream">
    %alloc_105 = memref.alloc() : memref<1xi128, "stream">
    %alloc_106 = memref.alloc() : memref<1xi128, "stream">
    %alloc_107 = memref.alloc() : memref<1xi128, "stream">
    %alloc_108 = memref.alloc() : memref<1xi128, "stream">
    %alloc_109 = memref.alloc() : memref<1xi128, "stream">
    %alloc_110 = memref.alloc() : memref<1xi128, "stream">
    %alloc_111 = memref.alloc() : memref<1xi128, "stream">
    %alloc_112 = memref.alloc() : memref<1xi128, "stream">
    %alloc_113 = memref.alloc() : memref<1xi128, "stream">
    %alloc_114 = memref.alloc() : memref<1xi128, "stream">
    %alloc_115 = memref.alloc() : memref<1xi128, "stream">
    %alloc_116 = memref.alloc() : memref<1xi128, "stream">
    %alloc_117 = memref.alloc() : memref<1xi128, "stream">
    %alloc_118 = memref.alloc() : memref<1xi128, "stream">
    %alloc_119 = memref.alloc() : memref<1xi128, "stream">
    %alloc_120 = memref.alloc() : memref<1xi128, "stream">
    %alloc_121 = memref.alloc() : memref<1xi128, "stream">
    %alloc_122 = memref.alloc() : memref<1xi128, "stream">
    %alloc_123 = memref.alloc() : memref<1xi128, "stream">
    %alloc_124 = memref.alloc() : memref<1xi128, "stream">
    %alloc_125 = memref.alloc() : memref<1xi128, "stream">
    %alloc_126 = memref.alloc() : memref<1xi128, "stream">
    %alloc_127 = memref.alloc() : memref<1xi128, "stream">
    %alloc_128 = memref.alloc() : memref<1xi128, "stream">
    %alloc_129 = memref.alloc() : memref<1xi128, "stream">
    %alloc_130 = memref.alloc() : memref<1xi128, "stream">
    %alloc_131 = memref.alloc() : memref<1xi128, "stream">
    %alloc_132 = memref.alloc() : memref<1xi128, "stream">
    %alloc_133 = memref.alloc() : memref<1xi128, "stream">
    %alloc_134 = memref.alloc() : memref<1xi128, "stream">
    %alloc_135 = memref.alloc() : memref<1xi128, "stream">
    %alloc_136 = memref.alloc() : memref<1xi128, "stream">
    %alloc_137 = memref.alloc() : memref<1xi128, "stream">
    %alloc_138 = memref.alloc() : memref<1xi128, "stream">
    %alloc_139 = memref.alloc() : memref<1xi128, "stream">
    %alloc_140 = memref.alloc() : memref<1xi128, "stream">
    %alloc_141 = memref.alloc() : memref<1xi128, "stream">
    %alloc_142 = memref.alloc() : memref<1xi128, "stream">
    %alloc_143 = memref.alloc() : memref<1xi128, "stream">
    %alloc_144 = memref.alloc() : memref<1xi128, "stream">
    %alloc_145 = memref.alloc() : memref<1xi128, "stream">
    %alloc_146 = memref.alloc() : memref<1xi128, "stream">
    %alloc_147 = memref.alloc() : memref<1xi128, "stream">
    %alloc_148 = memref.alloc() : memref<1xi128, "stream">
    %alloc_149 = memref.alloc() : memref<1xi128, "stream">
    %alloc_150 = memref.alloc() : memref<1xi128, "stream">
    %alloc_151 = memref.alloc() : memref<1xi128, "stream">
    %alloc_152 = memref.alloc() : memref<1xi128, "stream">
    %alloc_153 = memref.alloc() : memref<1xi128, "stream">
    %alloc_154 = memref.alloc() : memref<1xi128, "stream">
    %alloc_155 = memref.alloc() : memref<1xi128, "stream">
    %alloc_156 = memref.alloc() : memref<1xi128, "stream">
    %alloc_157 = memref.alloc() : memref<1xi128, "stream">
    %alloc_158 = memref.alloc() : memref<1xi128, "stream">
    %alloc_159 = memref.alloc() : memref<1xi128, "stream">
    %alloc_160 = memref.alloc() : memref<1xi128, "stream">
    %alloc_161 = memref.alloc() : memref<1xi128, "stream">
    %alloc_162 = memref.alloc() : memref<1xi128, "stream">
    %alloc_163 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_164 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_165 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_166 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_167 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_168 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_169 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_170 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_171 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_172 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_173 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_174 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_175 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_176 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_177 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_178 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_179 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_180 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_181 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_182 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_183 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_184 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_185 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_186 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_187 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_188 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_189 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_190 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_191 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_192 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_193 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_194 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_195 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_196 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_197 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_198 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_199 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_200 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_201 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_202 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_203 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_204 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_205 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_206 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_207 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_208 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_209 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_210 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_211 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_212 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_213 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_214 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_215 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_216 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_217 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_218 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_219 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_220 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_221 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_222 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_223 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_224 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_225 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_226 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_227 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_228 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_229 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_230 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_231 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_232 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_233 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_234 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_235 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_236 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_237 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_238 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_239 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_240 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_241 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_242 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_243 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_244 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_245 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_246 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_247 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_248 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_249 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_250 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_251 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_252 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_253 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_254 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_255 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_256 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_257 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_258 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_259 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_260 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_261 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_262 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_263 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_264 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_265 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_266 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_267 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_268 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_269 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_270 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_271 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_272 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_273 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_274 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_275 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_276 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_277 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_278 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_279 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_280 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_281 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_282 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_283 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_284 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_285 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_286 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_287 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_288 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_289 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_290 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_291 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_292 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_293 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_294 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_295 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_296 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_297 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_298 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_299 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_300 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_301 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_302 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_303 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_304 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_305 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_306 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_307 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_308 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_309 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_310 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_311 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_312 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_313 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_314 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_315 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_316 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_317 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_318 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_319 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_320 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_321 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_322 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_323 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_324 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_325 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_326 = memref.alloc() : memref<1xi512, "stream2">
    call @receive13_top(%arg3, %alloc_12, %arg18, %alloc_26, %arg28, %alloc_1, %arg44, %alloc_41, %arg8, %alloc_11, %arg97, %alloc_43, %arg9, %alloc_86, %arg56, %alloc_72, %arg138, %alloc_62, %arg74, %alloc_9, %arg104, %alloc_50, %arg69, %alloc, %arg108, %alloc_60, %arg34, %alloc_55, %arg150, %alloc_23, %arg59, %alloc_52, %arg30, %alloc_71, %arg83, %alloc_57, %arg47, %alloc_61, %arg40, %alloc_30, %arg149, %alloc_42, %arg165, %alloc_44, %arg14, %alloc_28, %arg85, %alloc_73, %arg67, %alloc_79, %arg64, %alloc_53, %arg87, %alloc_20, %arg55, %alloc_76, %arg16, %alloc_49, %arg141, %alloc_78, %arg137, %alloc_58, %arg151, %alloc_16, %arg144, %alloc_54, %arg112, %alloc_51, %arg158, %alloc_68, %arg6, %alloc_38, %arg37, %alloc_83, %arg45, %alloc_59, %arg39, %alloc_46, %arg147, %alloc_17, %arg159, %alloc_70, %arg41, %alloc_74, %arg68, %alloc_8, %arg86, %alloc_7, %arg166, %alloc_39, %arg129, %alloc_14, %arg57, %alloc_47, %arg135, %alloc_19, %arg62, %alloc_18, %arg153, %alloc_37, %arg73, %alloc_13, %arg96, %alloc_40, %arg103, %alloc_48, %arg139, %alloc_0, %arg20, %alloc_21, %arg101, %alloc_69, %arg155, %alloc_36, %arg70, %alloc_32, %arg54, %alloc_45, %arg66, %alloc_15, %arg33, %alloc_34, %arg7, %alloc_4, %arg145, %alloc_77, %arg19, %alloc_65, %arg12, %alloc_27, %arg29, %alloc_10, %arg36, %alloc_5, %arg161, %alloc_84, %arg113, %alloc_82, %arg27, %alloc_33, %arg58, %alloc_6, %arg50, %alloc_81, %arg90, %alloc_66, %arg125, %alloc_64, %arg89, %alloc_75, %arg43, %alloc_56, %arg119, %alloc_22, %arg72, %alloc_67, %arg52, %alloc_2, %arg116, %alloc_85, %arg118, %alloc_63, %arg102, %alloc_29, %arg65, %alloc_35, %arg120, %alloc_24, %arg81, %alloc_3, %arg35, %alloc_25, %arg121, %alloc_31, %arg92, %alloc_80) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29_top(%arg100, %alloc_133, %arg61, %alloc_141, %arg78, %alloc_140, %arg142, %alloc_145, %arg71, %alloc_136, %arg76, %alloc_132, %arg105, %alloc_130, %arg128, %alloc_142, %arg130, %alloc_138, %arg146, %alloc_159, %arg49, %alloc_143, %arg127, %alloc_134, %arg152, %alloc_154, %arg115, %alloc_149, %arg156, %alloc_135, %arg131, %alloc_150, %arg117, %alloc_147, %arg94, %alloc_146, %arg48, %alloc_137, %arg124, %alloc_144, %arg25, %alloc_131, %arg82, %alloc_155, %arg46, %alloc_139, %arg109, %alloc_151, %arg114, %alloc_153, %arg126, %alloc_127, %arg10, %alloc_152, %arg110, %alloc_128, %arg163, %alloc_148, %arg160, %alloc_129, %arg136, %alloc_157, %arg32, %alloc_161) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39_top(%arg106, %alloc_123, %arg26, %alloc_87, %arg132, %alloc_102, %arg123, %alloc_88, %arg77, %alloc_116, %arg122, %alloc_103, %arg111, %alloc_119, %arg93, %alloc_91, %arg98, %alloc_94, %arg162, %alloc_114, %arg24, %alloc_156, %arg22, %alloc_113, %arg148, %alloc_109, %arg88, %alloc_112, %arg143, %alloc_124, %arg133, %alloc_120, %arg17, %alloc_160, %arg91, %alloc_98, %arg4, %alloc_105, %arg75, %alloc_107, %arg11, %alloc_89, %arg99, %alloc_108, %arg15, %alloc_106, %arg23, %alloc_101, %arg13, %alloc_92, %arg164, %alloc_90, %arg154, %alloc_162, %arg60, %alloc_158, %arg5, %alloc_117, %arg51, %alloc_115, %arg107, %alloc_97, %arg53, %alloc_126, %arg31, %alloc_122, %arg80, %alloc_95, %arg157, %alloc_118, %arg134, %alloc_111, %arg84, %alloc_93, %arg140, %alloc_104, %arg38, %alloc_110, %arg79, %alloc_96, %arg42, %alloc_100, %arg63, %alloc_121, %arg95, %alloc_99, %arg21, %alloc_125) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @store0_0_top(%alloc, %alloc_163, %alloc_0, %alloc_164, %alloc_1, %alloc_165, %alloc_2, %alloc_166, %alloc_3, %alloc_167, %alloc_4, %alloc_168, %alloc_5, %alloc_169, %alloc_6, %alloc_170, %alloc_7, %alloc_171, %alloc_8, %alloc_172, %alloc_9, %alloc_173, %alloc_10, %alloc_174, %alloc_11, %alloc_175, %alloc_12, %alloc_176, %alloc_13, %alloc_177, %alloc_14, %alloc_178, %alloc_15, %alloc_179, %alloc_16, %alloc_180, %alloc_17, %alloc_181, %alloc_18, %alloc_182, %alloc_19, %alloc_183, %alloc_20, %alloc_184, %alloc_21, %alloc_185, %alloc_22, %alloc_186, %alloc_23, %alloc_187, %alloc_24, %alloc_188, %alloc_25, %alloc_189, %alloc_26, %alloc_190, %alloc_27, %alloc_191, %alloc_28, %alloc_192, %alloc_29, %alloc_193, %alloc_30, %alloc_194, %alloc_31, %alloc_195, %alloc_32, %alloc_196, %alloc_33, %alloc_197, %alloc_34, %alloc_198, %alloc_35, %alloc_199, %alloc_36, %alloc_200, %alloc_37, %alloc_201, %alloc_38, %alloc_202, %alloc_39, %alloc_203, %alloc_40, %alloc_204, %alloc_41, %alloc_205, %alloc_42, %alloc_206, %alloc_43, %alloc_207, %alloc_44, %alloc_208, %alloc_45, %alloc_209, %alloc_46, %alloc_210, %alloc_47, %alloc_211, %alloc_48, %alloc_212, %alloc_49, %alloc_213, %alloc_50, %alloc_214, %alloc_51, %alloc_215, %alloc_52, %alloc_216, %alloc_53, %alloc_217, %alloc_54, %alloc_218, %alloc_55, %alloc_219, %alloc_56, %alloc_220, %alloc_57, %alloc_221, %alloc_58, %alloc_222, %alloc_59, %alloc_223, %alloc_60, %alloc_224, %alloc_61, %alloc_225, %alloc_62, %alloc_226, %alloc_63, %alloc_227, %alloc_64, %alloc_228, %alloc_65, %alloc_229, %alloc_66, %alloc_230, %alloc_67, %alloc_231, %alloc_68, %alloc_232, %alloc_69, %alloc_233, %alloc_70, %alloc_234, %alloc_71, %alloc_235, %alloc_72, %alloc_236, %alloc_73, %alloc_237, %alloc_74, %alloc_238, %alloc_75, %alloc_239, %alloc_76, %alloc_240, %alloc_77, %alloc_241, %alloc_78, %alloc_242, %alloc_79, %alloc_243, %alloc_80, %alloc_244, %alloc_81, %alloc_245, %alloc_82, %alloc_246, %alloc_83, %alloc_247, %alloc_84, %alloc_248, %alloc_85, %alloc_249, %alloc_86, %alloc_250) : (memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_top(%arg2, %alloc_239, %alloc_165, %alloc_212, %alloc_183, %alloc_178, %alloc_248, %alloc_195, %alloc_163, %alloc_206, %alloc_222, %alloc_208, %alloc_207, %alloc_225, %alloc_177, %alloc_197, %alloc_194, %alloc_227, %alloc_184, %alloc_221, %alloc_196, %alloc_202, %alloc_193, %alloc_245, %alloc_210, %alloc_229, %alloc_231, %alloc_176, %alloc_167, %alloc_213, %alloc_185, %alloc_168, %alloc_238, %alloc_240, %alloc_192, %alloc_172, %alloc_249, %alloc_191, %alloc_217, %alloc_230, %alloc_179, %alloc_187, %alloc_186, %alloc_244, %alloc_201, %alloc_228, %alloc_224, %alloc_235, %alloc_236, %alloc_219, %alloc_200, %alloc_220, %alloc_214, %alloc_190, %alloc_226, %alloc_215, %alloc_198, %alloc_237, %alloc_241, %alloc_174, %alloc_205, %alloc_164, %alloc_233, %alloc_199, %alloc_223, %alloc_166, %alloc_189, %alloc_170, %alloc_216, %alloc_173, %alloc_243, %alloc_246, %alloc_204, %alloc_247, %alloc_188, %alloc_203, %alloc_180, %alloc_211, %alloc_218, %alloc_182, %alloc_171, %alloc_175, %alloc_169, %alloc_242, %alloc_250, %alloc_209, %alloc_232, %alloc_181, %alloc_234) : (memref<2816x192xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load0_top(%arg0, %alloc_283, %alloc_270, %alloc_275, %alloc_289, %alloc_282, %alloc_266, %alloc_263, %alloc_279, %alloc_290, %alloc_257, %alloc_286, %alloc_291, %alloc_259, %alloc_293, %alloc_268, %alloc_281, %alloc_287, %alloc_288, %alloc_265, %alloc_278, %alloc_292, %alloc_271, %alloc_277, %alloc_261, %alloc_256, %alloc_262, %alloc_267, %alloc_274, %alloc_273, %alloc_280, %alloc_285, %alloc_269, %alloc_276, %alloc_294, %alloc_264, %alloc_258, %alloc_255, %alloc_260, %alloc_254, %alloc_253, %alloc_272, %alloc_252, %alloc_284, %alloc_251) : (memref<2816x512xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load0_43_top(%alloc_294, %alloc_162, %alloc_293, %alloc_160, %alloc_292, %alloc_158, %alloc_291, %alloc_156, %alloc_290, %alloc_126, %alloc_289, %alloc_125, %alloc_288, %alloc_124, %alloc_287, %alloc_123, %alloc_286, %alloc_122, %alloc_285, %alloc_121, %alloc_284, %alloc_120, %alloc_283, %alloc_119, %alloc_282, %alloc_118, %alloc_281, %alloc_117, %alloc_280, %alloc_116, %alloc_279, %alloc_115, %alloc_278, %alloc_114, %alloc_277, %alloc_113, %alloc_276, %alloc_112, %alloc_275, %alloc_111, %alloc_274, %alloc_110, %alloc_273, %alloc_109, %alloc_272, %alloc_108, %alloc_271, %alloc_107, %alloc_270, %alloc_106, %alloc_269, %alloc_105, %alloc_268, %alloc_104, %alloc_267, %alloc_103, %alloc_266, %alloc_102, %alloc_265, %alloc_101, %alloc_264, %alloc_100, %alloc_263, %alloc_99, %alloc_262, %alloc_98, %alloc_261, %alloc_97, %alloc_260, %alloc_96, %alloc_259, %alloc_95, %alloc_258, %alloc_94, %alloc_257, %alloc_93, %alloc_256, %alloc_92, %alloc_255, %alloc_91, %alloc_254, %alloc_90, %alloc_253, %alloc_89, %alloc_252, %alloc_88, %alloc_251, %alloc_87) : (memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_top(%arg1, %alloc_324, %alloc_298, %alloc_322, %alloc_319, %alloc_306, %alloc_326, %alloc_296, %alloc_325, %alloc_300, %alloc_297, %alloc_316, %alloc_321, %alloc_323, %alloc_305, %alloc_301, %alloc_307, %alloc_317, %alloc_313, %alloc_302, %alloc_310, %alloc_309, %alloc_320, %alloc_304, %alloc_303, %alloc_311, %alloc_308, %alloc_318, %alloc_315, %alloc_314, %alloc_295, %alloc_299, %alloc_312) : (memref<8192x192xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load1_31_top(%alloc_326, %alloc_161, %alloc_325, %alloc_159, %alloc_324, %alloc_157, %alloc_323, %alloc_155, %alloc_322, %alloc_154, %alloc_321, %alloc_153, %alloc_320, %alloc_152, %alloc_319, %alloc_151, %alloc_318, %alloc_150, %alloc_317, %alloc_149, %alloc_316, %alloc_148, %alloc_315, %alloc_147, %alloc_314, %alloc_146, %alloc_313, %alloc_145, %alloc_312, %alloc_144, %alloc_311, %alloc_143, %alloc_310, %alloc_142, %alloc_309, %alloc_141, %alloc_308, %alloc_140, %alloc_307, %alloc_139, %alloc_306, %alloc_138, %alloc_305, %alloc_137, %alloc_304, %alloc_136, %alloc_303, %alloc_135, %alloc_302, %alloc_134, %alloc_301, %alloc_133, %alloc_300, %alloc_132, %alloc_299, %alloc_131, %alloc_298, %alloc_130, %alloc_297, %alloc_129, %alloc_296, %alloc_128, %alloc_295, %alloc_127) : (memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @gemm(%arg0: memref<2816x512xi512>, %arg1: memref<8192x192xi512>, %arg2: memref<2816x192xi512>, %arg3: memref<1xi128, "plio">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "plio">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "plio">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "plio">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "plio">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "plio">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "plio">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "plio">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "plio">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "plio">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "plio">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "plio">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "plio">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "plio">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "plio">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "plio">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "plio">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "plio">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "plio">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "plio">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "plio">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "plio">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "plio">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "plio">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "plio">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "plio">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "plio">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "plio">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "plio">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "plio">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "plio">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "plio">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "plio">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "plio">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "plio">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "plio">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "plio">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "plio">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "plio">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "plio">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "plio">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "plio">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "plio">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "plio">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "plio">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "plio">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "plio">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "plio">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "plio">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "plio">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "plio">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "plio">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "plio">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "plio">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "plio">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "plio">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "plio">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "plio">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "plio">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "plio">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "plio">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "plio">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "plio">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "plio">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "plio">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "plio">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "plio">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "plio">, %arg152: memref<1xi128, "plio">, %arg153: memref<1xi128, "plio">, %arg154: memref<1xi128, "plio">, %arg155: memref<1xi128, "plio">, %arg156: memref<1xi128, "plio">, %arg157: memref<1xi128, "plio">, %arg158: memref<1xi128, "plio">, %arg159: memref<1xi128, "plio">, %arg160: memref<1xi128, "plio">, %arg161: memref<1xi128, "plio">, %arg162: memref<1xi128, "plio">, %arg163: memref<1xi128, "plio">, %arg164: memref<1xi128, "plio">, %arg165: memref<1xi128, "plio">, %arg166: memref<1xi128, "plio">) attributes {adf.func, plio = true} {
    %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%0, %arg9) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%1, %arg116) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %2 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%2, %arg161) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %3 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%3, %arg37) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%4, %arg113) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %5 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%5, %arg50) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %6 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%6, %arg92) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %7 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%7, %arg67) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %8 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg26, %8) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg123, %9) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg11, %10) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg164, %11) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %12 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%12, %arg141) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %13 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%13, %arg145) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %14 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%14, %arg55) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %15 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%15, %arg89) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %16 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%16, %arg41) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %17 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%17, %arg85) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %18 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%18, %arg56) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %19 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%19, %arg30) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %20 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg93, %20) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %21 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg13, %21) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %22 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg84, %22) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %23 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg98, %23) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %24 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%24, %arg159) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %25 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%25, %arg101) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %26 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%26, %arg158) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %27 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%27, %arg72) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %28 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%28, %arg90) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %29 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%29, %arg19) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %30 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%30, %arg125) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %31 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%31, %arg118) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %32 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg80, %32) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %33 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg79, %33) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %34 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg107, %34) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %35 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg91, %35) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %36 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%36, %arg138) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %37 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%37, %arg47) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %38 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%38, %arg108) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %39 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%39, %arg45) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %40 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%40, %arg137) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %41 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%41, %arg83) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %42 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%42, %arg43) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %43 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%43, %arg34) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %44 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg95, %44) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %45 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg42, %45) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %46 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg23, %46) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %47 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg132, %47) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %48 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%48, %arg144) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %49 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%49, %arg64) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %50 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%50, %arg59) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %51 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%51, %arg112) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %52 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%52, %arg104) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %53 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%53, %arg16) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %54 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%54, %arg103) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %55 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%55, %arg57) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %56 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg122, %56) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %57 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg140, %57) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %58 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg4, %58) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %59 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg15, %59) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %60 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%60, %arg39) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %61 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%61, %arg54) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %62 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%62, %arg165) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %63 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%63, %arg97) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %64 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%64, %arg149) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %65 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%65, %arg44) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %66 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%66, %arg96) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %67 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%67, %arg166) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %68 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg75, %68) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %69 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg99, %69) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %70 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg148, %70) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %71 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg38, %71) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %72 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%72, %arg6) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %73 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%73, %arg153) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %74 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%74, %arg155) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %75 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%75, %arg65) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %76 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%76, %arg33) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %77 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%77, %arg27) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %78 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%78, %arg70) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %79 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%79, %arg121) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %80 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg134, %80) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %81 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg88, %81) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %82 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg22, %82) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %83 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg162, %83) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %84 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%84, %arg40) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %85 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%85, %arg102) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %86 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%86, %arg14) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %87 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%87, %arg12) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %88 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%88, %arg18) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %89 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%89, %arg35) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %90 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%90, %arg120) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %91 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%91, %arg150) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %92 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg51, %92) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %93 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg77, %93) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %94 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg5, %94) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %95 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg157, %95) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %96 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%96, %arg119) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %97 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%97, %arg20) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %98 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%98, %arg87) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %99 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%99, %arg135) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %100 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%100, %arg62) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %101 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%101, %arg147) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %102 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%102, %arg151) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %103 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%103, %arg66) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %104 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg111, %104) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %105 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg133, %105) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %106 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg63, %106) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %107 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg31, %107) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %108 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%108, %arg129) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %109 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%109, %arg73) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %110 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%110, %arg3) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %111 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%111, %arg8) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %112 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%112, %arg29) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %113 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%113, %arg74) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %114 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%114, %arg68) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %115 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%115, %arg86) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %116 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg106, %116) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %117 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg143, %117) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %118 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg21, %118) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %119 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg53, %119) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %120 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%120, %arg58) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %121 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg126, %121) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %122 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg110, %122) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %123 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg160, %123) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %124 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg105, %124) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %125 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%125, %arg36) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %126 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg25, %126) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %127 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg76, %127) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %128 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg100, %128) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %129 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg127, %129) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %130 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%130, %arg7) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %131 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg156, %131) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %132 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg71, %132) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %133 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg48, %133) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %134 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg130, %134) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %135 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%135, %arg81) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %136 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg46, %136) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %137 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg78, %137) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %138 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg61, %138) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %139 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg128, %139) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %140 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%140, %arg52) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %141 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg49, %141) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %142 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg124, %142) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %143 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg142, %143) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %144 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg94, %144) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %145 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%145, %arg28) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %146 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg117, %146) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %147 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg163, %147) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %148 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg115, %148) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %149 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg131, %149) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %150 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%150, %arg139) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %151 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg109, %151) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %152 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg10, %152) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %153 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg114, %153) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %154 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg152, %154) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %155 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%155, %arg69) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %156 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg82, %156) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %157 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg24, %157) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %158 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg136, %158) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %159 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg60, %159) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %160 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg146, %160) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %161 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg17, %161) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %162 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg32, %162) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %163 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg154, %163) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    adf.cell.launch @adf_cell0 {
      func.call @adf_cell0(%163, %162, %161, %160, %159, %158, %157, %156, %155, %154, %153, %152, %151, %150, %149, %148, %147, %146, %145, %144, %143, %142, %141, %140, %139, %138, %137, %136, %135, %134, %133, %132, %131, %130, %129, %128, %127, %126, %125, %124, %123, %122, %121, %120, %119, %118, %117, %116, %115, %114, %113, %112, %111, %110, %109, %108, %107, %106, %105, %104, %103, %102, %101, %100, %99, %98, %97, %96, %95, %94, %93, %92, %91, %90, %89, %88, %87, %86, %85, %84, %83, %82, %81, %80, %79, %78, %77, %76, %75, %74, %73, %72, %71, %70, %69, %68, %67, %66, %65, %64, %63, %62, %61, %60, %59, %58, %57, %56, %55, %54, %53, %52, %51, %50, %49, %48, %47, %46, %45, %44, %43, %42, %41, %40, %39, %38, %37, %36, %35, %34, %33, %32, %31, %30, %29, %28, %27, %26, %25, %24, %23, %22, %21, %20, %19, %18, %17, %16, %15, %14, %13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
      adf.cell.launch.end
    }
    adf.pl.launch @gemm_pl {
      func.call @gemm_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44, %arg45, %arg46, %arg47, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68, %arg69, %arg70, %arg71, %arg72, %arg73, %arg74, %arg75, %arg76, %arg77, %arg78, %arg79, %arg80, %arg81, %arg82, %arg83, %arg84, %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96, %arg97, %arg98, %arg99, %arg100, %arg101, %arg102, %arg103, %arg104, %arg105, %arg106, %arg107, %arg108, %arg109, %arg110, %arg111, %arg112, %arg113, %arg114, %arg115, %arg116, %arg117, %arg118, %arg119, %arg120, %arg121, %arg122, %arg123, %arg124, %arg125, %arg126, %arg127, %arg128, %arg129, %arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145, %arg146, %arg147, %arg148, %arg149, %arg150, %arg151, %arg152, %arg153, %arg154, %arg155, %arg156, %arg157, %arg158, %arg159, %arg160, %arg161, %arg162, %arg163, %arg164, %arg165, %arg166) {adf.pl} : (memref<2816x512xi512>, memref<8192x192xi512>, memref<2816x192xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
      adf.pl.launch.wait
    }
    return
  }
  func.func @top(%arg0: memref<2816x512xi512>, %arg1: memref<8192x192xi512>, %arg2: memref<2816x192xi512>, %arg3: memref<1xi128, "plio">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "plio">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "plio">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "plio">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "plio">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "plio">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "plio">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "plio">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "plio">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "plio">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "plio">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "plio">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "plio">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "plio">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "plio">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "plio">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "plio">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "plio">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "plio">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "plio">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "plio">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "plio">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "plio">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "plio">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "plio">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "plio">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "plio">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "plio">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "plio">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "plio">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "plio">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "plio">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "plio">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "plio">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "plio">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "plio">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "plio">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "plio">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "plio">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "plio">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "plio">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "plio">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "plio">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "plio">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "plio">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "plio">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "plio">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "plio">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "plio">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "plio">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "plio">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "plio">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "plio">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "plio">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "plio">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "plio">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "plio">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "plio">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "plio">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "plio">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "plio">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "plio">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "plio">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "plio">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "plio">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "plio">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "plio">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "plio">, %arg152: memref<1xi128, "plio">, %arg153: memref<1xi128, "plio">, %arg154: memref<1xi128, "plio">, %arg155: memref<1xi128, "plio">, %arg156: memref<1xi128, "plio">, %arg157: memref<1xi128, "plio">, %arg158: memref<1xi128, "plio">, %arg159: memref<1xi128, "plio">, %arg160: memref<1xi128, "plio">, %arg161: memref<1xi128, "plio">, %arg162: memref<1xi128, "plio">, %arg163: memref<1xi128, "plio">, %arg164: memref<1xi128, "plio">, %arg165: memref<1xi128, "plio">, %arg166: memref<1xi128, "plio">) attributes {outArgs = [2 : i32], top_func = "plio"} {
    call @gemm_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44, %arg45, %arg46, %arg47, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68, %arg69, %arg70, %arg71, %arg72, %arg73, %arg74, %arg75, %arg76, %arg77, %arg78, %arg79, %arg80, %arg81, %arg82, %arg83, %arg84, %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96, %arg97, %arg98, %arg99, %arg100, %arg101, %arg102, %arg103, %arg104, %arg105, %arg106, %arg107, %arg108, %arg109, %arg110, %arg111, %arg112, %arg113, %arg114, %arg115, %arg116, %arg117, %arg118, %arg119, %arg120, %arg121, %arg122, %arg123, %arg124, %arg125, %arg126, %arg127, %arg128, %arg129, %arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145, %arg146, %arg147, %arg148, %arg149, %arg150, %arg151, %arg152, %arg153, %arg154, %arg155, %arg156, %arg157, %arg158, %arg159, %arg160, %arg161, %arg162, %arg163, %arg164, %arg165, %arg166) : (memref<2816x512xi512>, memref<8192x192xi512>, memref<2816x192xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
    return
  }
  func.func private @gemm_host(memref<2816x8192xf32>, memref<8192x3072xf32>, memref<2816x3072xf32>) attributes {origin_func = "gemm"}
  func.func @top_host(%arg0: memref<2816x8192xf32>, %arg1: memref<8192x3072xf32>, %arg2: memref<2816x3072xf32>) attributes {origin_func = "top", outArgs = [2 : i32], top_host} {
    call @gemm_host(%arg0, %arg1, %arg2) {origin_func = "gemm"} : (memref<2816x8192xf32>, memref<8192x3072xf32>, memref<2816x3072xf32>) -> ()
    return
  }
}

