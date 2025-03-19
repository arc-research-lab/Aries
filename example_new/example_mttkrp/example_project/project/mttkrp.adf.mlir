#map = affine_map<(d0) -> (d0 * 128 + 127)>
#map1 = affine_map<(d0) -> (d0 * 128)>
module {
  func.func @kernel_mttkrp0(%arg0: memref<2x16x32xf32, 2>, %arg1: memref<16x32xf32, 2>, %arg2: memref<32x32xf32, 2>) -> memref<2x32xf32, 2> attributes {adf.kernel, edge_kernel} {
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<2x32xf32, 2>
    affine.for %arg3 = 0 to 2 {
      affine.for %arg4 = 0 to 32 {
        affine.store %cst, %alloc[%arg3, %arg4] : memref<2x32xf32, 2>
      }
    }
    affine.for %arg3 = 0 to 2 {
      affine.for %arg4 = 0 to 32 {
        affine.for %arg5 = 0 to 16 {
          affine.for %arg6 = 0 to 32 {
            %0 = affine.load %arg0[%arg3, %arg5, %arg6] : memref<2x16x32xf32, 2>
            %1 = affine.load %arg1[%arg5, %arg4] : memref<16x32xf32, 2>
            %2 = arith.mulf %0, %1 : f32
            %3 = affine.load %arg2[%arg6, %arg4] : memref<32x32xf32, 2>
            %4 = arith.mulf %2, %3 : f32
            %5 = affine.load %alloc[%arg3, %arg4] : memref<2x32xf32, 2>
            %6 = arith.addf %5, %4 : f32
            affine.store %6, %alloc[%arg3, %arg4] : memref<2x32xf32, 2>
          }
        }
      }
    }
    return %alloc : memref<2x32xf32, 2>
  }
  func.func @kernel_mttkrp(%arg0: memref<2x16x32xf32, 2>, %arg1: memref<16x32xf32, 2>, %arg2: memref<32x32xf32, 2>, %arg3: memref<2x32xf32, 2>) -> memref<2x32xf32, 2> attributes {adf.kernel} {
    %alloc = memref.alloc() : memref<2x32xf32, 2>
    affine.for %arg4 = 0 to 2 {
      affine.for %arg5 = 0 to 32 {
        %0 = affine.load %arg3[%arg4, %arg5] : memref<2x32xf32, 2>
        affine.store %0, %alloc[%arg4, %arg5] : memref<2x32xf32, 2>
        affine.for %arg6 = 0 to 16 {
          affine.for %arg7 = 0 to 32 {
            %1 = affine.load %arg0[%arg4, %arg6, %arg7] : memref<2x16x32xf32, 2>
            %2 = affine.load %arg1[%arg6, %arg5] : memref<16x32xf32, 2>
            %3 = arith.mulf %1, %2 : f32
            %4 = affine.load %arg2[%arg7, %arg5] : memref<32x32xf32, 2>
            %5 = arith.mulf %3, %4 : f32
            %6 = affine.load %alloc[%arg4, %arg5] : memref<2x32xf32, 2>
            %7 = arith.addf %6, %5 : f32
            affine.store %7, %alloc[%arg4, %arg5] : memref<2x32xf32, 2>
          }
        }
      }
    }
    return %alloc : memref<2x32xf32, 2>
  }
  func.func @adf_cell0(%arg0: !adf.plio<In, 128>, %arg1: !adf.plio<In, 128>, %arg2: !adf.plio<In, 128>, %arg3: !adf.plio<In, 128>, %arg4: !adf.plio<In, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<In, 128>, %arg9: !adf.plio<Out, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<In, 128>, %arg13: !adf.plio<Out, 128>, %arg14: !adf.plio<In, 128>, %arg15: !adf.plio<In, 128>, %arg16: !adf.plio<In, 128>, %arg17: !adf.plio<Out, 128>, %arg18: !adf.plio<In, 128>, %arg19: !adf.plio<In, 128>, %arg20: !adf.plio<In, 128>, %arg21: !adf.plio<Out, 128>, %arg22: !adf.plio<In, 128>, %arg23: !adf.plio<In, 128>, %arg24: !adf.plio<In, 128>, %arg25: !adf.plio<Out, 128>, %arg26: !adf.plio<In, 128>, %arg27: !adf.plio<In, 128>, %arg28: !adf.plio<In, 128>, %arg29: !adf.plio<Out, 128>, %arg30: !adf.plio<In, 128>, %arg31: !adf.plio<In, 128>, %arg32: !adf.plio<In, 128>, %arg33: !adf.plio<Out, 128>, %arg34: !adf.plio<In, 128>, %arg35: !adf.plio<In, 128>, %arg36: !adf.plio<In, 128>, %arg37: !adf.plio<Out, 128>, %arg38: !adf.plio<In, 128>, %arg39: !adf.plio<In, 128>, %arg40: !adf.plio<In, 128>, %arg41: !adf.plio<Out, 128>, %arg42: !adf.plio<In, 128>, %arg43: !adf.plio<In, 128>, %arg44: !adf.plio<In, 128>, %arg45: !adf.plio<Out, 128>, %arg46: !adf.plio<In, 128>, %arg47: !adf.plio<In, 128>, %arg48: !adf.plio<In, 128>, %arg49: !adf.plio<Out, 128>, %arg50: !adf.plio<In, 128>, %arg51: !adf.plio<In, 128>, %arg52: !adf.plio<Out, 128>, %arg53: !adf.plio<Out, 128>, %arg54: !adf.plio<Out, 128>, %arg55: !adf.plio<Out, 128>, %arg56: !adf.plio<Out, 128>, %arg57: !adf.plio<Out, 128>, %arg58: !adf.plio<Out, 128>, %arg59: !adf.plio<Out, 128>, %arg60: !adf.plio<Out, 128>, %arg61: !adf.plio<Out, 128>, %arg62: !adf.plio<Out, 128>, %arg63: !adf.plio<Out, 128>, %arg64: !adf.plio<In, 128>, %arg65: !adf.plio<In, 128>, %arg66: !adf.plio<Out, 128>, %arg67: !adf.plio<Out, 128>, %arg68: !adf.plio<Out, 128>, %arg69: !adf.plio<Out, 128>, %arg70: !adf.plio<Out, 128>, %arg71: !adf.plio<Out, 128>, %arg72: !adf.plio<Out, 128>, %arg73: !adf.plio<Out, 128>, %arg74: !adf.plio<Out, 128>, %arg75: !adf.plio<Out, 128>, %arg76: !adf.plio<Out, 128>, %arg77: !adf.plio<Out, 128>, %arg78: !adf.plio<In, 128>, %arg79: !adf.plio<In, 128>, %arg80: !adf.plio<Out, 128>, %arg81: !adf.plio<Out, 128>, %arg82: !adf.plio<Out, 128>, %arg83: !adf.plio<Out, 128>, %arg84: !adf.plio<Out, 128>, %arg85: !adf.plio<Out, 128>, %arg86: !adf.plio<Out, 128>, %arg87: !adf.plio<Out, 128>, %arg88: !adf.plio<Out, 128>, %arg89: !adf.plio<Out, 128>, %arg90: !adf.plio<Out, 128>, %arg91: !adf.plio<Out, 128>, %arg92: !adf.plio<In, 128>, %arg93: !adf.plio<In, 128>, %arg94: !adf.plio<Out, 128>, %arg95: !adf.plio<Out, 128>, %arg96: !adf.plio<Out, 128>, %arg97: !adf.plio<Out, 128>, %arg98: !adf.plio<Out, 128>, %arg99: !adf.plio<Out, 128>, %arg100: !adf.plio<Out, 128>, %arg101: !adf.plio<Out, 128>, %arg102: !adf.plio<Out, 128>, %arg103: !adf.plio<Out, 128>, %arg104: !adf.plio<Out, 128>, %arg105: !adf.plio<Out, 128>, %arg106: !adf.plio<In, 128>, %arg107: !adf.plio<In, 128>, %arg108: !adf.plio<Out, 128>, %arg109: !adf.plio<Out, 128>, %arg110: !adf.plio<Out, 128>, %arg111: !adf.plio<Out, 128>, %arg112: !adf.plio<Out, 128>, %arg113: !adf.plio<Out, 128>, %arg114: !adf.plio<Out, 128>, %arg115: !adf.plio<Out, 128>, %arg116: !adf.plio<Out, 128>, %arg117: !adf.plio<Out, 128>, %arg118: !adf.plio<Out, 128>, %arg119: !adf.plio<Out, 128>, %arg120: !adf.plio<In, 128>, %arg121: !adf.plio<In, 128>, %arg122: !adf.plio<Out, 128>, %arg123: !adf.plio<Out, 128>, %arg124: !adf.plio<Out, 128>, %arg125: !adf.plio<Out, 128>, %arg126: !adf.plio<Out, 128>, %arg127: !adf.plio<Out, 128>, %arg128: !adf.plio<Out, 128>, %arg129: !adf.plio<Out, 128>, %arg130: !adf.plio<Out, 128>, %arg131: !adf.plio<Out, 128>, %arg132: !adf.plio<Out, 128>, %arg133: !adf.plio<Out, 128>, %arg134: !adf.plio<In, 128>, %arg135: !adf.plio<In, 128>, %arg136: !adf.plio<Out, 128>, %arg137: !adf.plio<Out, 128>, %arg138: !adf.plio<Out, 128>, %arg139: !adf.plio<Out, 128>, %arg140: !adf.plio<Out, 128>, %arg141: !adf.plio<Out, 128>, %arg142: !adf.plio<Out, 128>, %arg143: !adf.plio<Out, 128>, %arg144: !adf.plio<Out, 128>, %arg145: !adf.plio<Out, 128>, %arg146: !adf.plio<Out, 128>, %arg147: !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 12 : index, 8 : index]} {
    %c48 = arith.constant 48 : index
    %c47 = arith.constant 47 : index
    %c44 = arith.constant 44 : index
    %c43 = arith.constant 43 : index
    %c40 = arith.constant 40 : index
    %c39 = arith.constant 39 : index
    %c36 = arith.constant 36 : index
    %c35 = arith.constant 35 : index
    %c32 = arith.constant 32 : index
    %c31 = arith.constant 31 : index
    %c28 = arith.constant 28 : index
    %c27 = arith.constant 27 : index
    %c24 = arith.constant 24 : index
    %c23 = arith.constant 23 : index
    %c20 = arith.constant 20 : index
    %c19 = arith.constant 19 : index
    %c16 = arith.constant 16 : index
    %c15 = arith.constant 15 : index
    %c12 = arith.constant 12 : index
    %c11 = arith.constant 11 : index
    %c8 = arith.constant 8 : index
    %c7 = arith.constant 7 : index
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c46 = arith.constant 46 : index
    %c45 = arith.constant 45 : index
    %c42 = arith.constant 42 : index
    %c41 = arith.constant 41 : index
    %c38 = arith.constant 38 : index
    %c37 = arith.constant 37 : index
    %c34 = arith.constant 34 : index
    %c33 = arith.constant 33 : index
    %c30 = arith.constant 30 : index
    %c29 = arith.constant 29 : index
    %c26 = arith.constant 26 : index
    %c25 = arith.constant 25 : index
    %c22 = arith.constant 22 : index
    %c21 = arith.constant 21 : index
    %c18 = arith.constant 18 : index
    %c17 = arith.constant 17 : index
    %c14 = arith.constant 14 : index
    %c13 = arith.constant 13 : index
    %c10 = arith.constant 10 : index
    %c9 = arith.constant 9 : index
    %c6 = arith.constant 6 : index
    %c5 = arith.constant 5 : index
    %c2 = arith.constant 2 : index
    %c12288 = arith.constant 12288 : index
    %c4096 = arith.constant 4096 : index
    %c24576 = arith.constant 24576 : index
    %c16384 = arith.constant 16384 : index
    %c8192 = arith.constant 8192 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    adf.config.plio(%arg5, 250) {"col, chl" = [6 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg9, 250) {"col, chl" = [6 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg13, 250) {"col, chl" = [9 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg17, 250) {"col, chl" = [13 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg21, 250) {"col, chl" = [17 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg25, 250) {"col, chl" = [21 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg29, 250) {"col, chl" = [25 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg33, 250) {"col, chl" = [29 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg37, 250) {"col, chl" = [33 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg41, 250) {"col, chl" = [37 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg45, 250) {"col, chl" = [41 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg0, 250) {"col, chl" = [23 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg3, 250) {"col, chl" = [23 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg49, 250) {"col, chl" = [44 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg52, 250) {"col, chl" = [6 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg53, 250) {"col, chl" = [7 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg54, 250) {"col, chl" = [9 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg55, 250) {"col, chl" = [13 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg56, 250) {"col, chl" = [17 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg57, 250) {"col, chl" = [21 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg58, 250) {"col, chl" = [25 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg59, 250) {"col, chl" = [29 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg60, 250) {"col, chl" = [33 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg61, 250) {"col, chl" = [37 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg62, 250) {"col, chl" = [41 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg50, 250) {"col, chl" = [23 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg51, 250) {"col, chl" = [22 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg63, 250) {"col, chl" = [44 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg66, 250) {"col, chl" = [7 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg67, 250) {"col, chl" = [7 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg68, 250) {"col, chl" = [9 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg69, 250) {"col, chl" = [13 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg70, 250) {"col, chl" = [17 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg71, 250) {"col, chl" = [21 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg72, 250) {"col, chl" = [25 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg73, 250) {"col, chl" = [29 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg74, 250) {"col, chl" = [33 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg75, 250) {"col, chl" = [37 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg76, 250) {"col, chl" = [41 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg64, 250) {"col, chl" = [22 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg65, 250) {"col, chl" = [22 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg77, 250) {"col, chl" = [44 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg80, 250) {"col, chl" = [8 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg81, 250) {"col, chl" = [8 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg82, 250) {"col, chl" = [8 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg83, 250) {"col, chl" = [12 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg84, 250) {"col, chl" = [16 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg85, 250) {"col, chl" = [20 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg86, 250) {"col, chl" = [24 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg87, 250) {"col, chl" = [28 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg88, 250) {"col, chl" = [32 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg89, 250) {"col, chl" = [36 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg90, 250) {"col, chl" = [40 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg78, 250) {"col, chl" = [24 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg79, 250) {"col, chl" = [24 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg91, 250) {"col, chl" = [43 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg94, 250) {"col, chl" = [10 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg95, 250) {"col, chl" = [10 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg96, 250) {"col, chl" = [11 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg97, 250) {"col, chl" = [15 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg98, 250) {"col, chl" = [19 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg99, 250) {"col, chl" = [23 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg100, 250) {"col, chl" = [27 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg101, 250) {"col, chl" = [31 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg102, 250) {"col, chl" = [35 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg103, 250) {"col, chl" = [39 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg104, 250) {"col, chl" = [43 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg92, 250) {"col, chl" = [25 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg93, 250) {"col, chl" = [25 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg105, 250) {"col, chl" = [43 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg108, 250) {"col, chl" = [10 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg109, 250) {"col, chl" = [11 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg110, 250) {"col, chl" = [11 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg111, 250) {"col, chl" = [15 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg112, 250) {"col, chl" = [19 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg113, 250) {"col, chl" = [23 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg114, 250) {"col, chl" = [27 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg115, 250) {"col, chl" = [31 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg116, 250) {"col, chl" = [35 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg117, 250) {"col, chl" = [39 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg118, 250) {"col, chl" = [42 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg106, 250) {"col, chl" = [25 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg107, 250) {"col, chl" = [24 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg119, 250) {"col, chl" = [42 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg122, 250) {"col, chl" = [12 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg123, 250) {"col, chl" = [12 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg124, 250) {"col, chl" = [14 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg125, 250) {"col, chl" = [15 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg126, 250) {"col, chl" = [19 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg127, 250) {"col, chl" = [23 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg128, 250) {"col, chl" = [27 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg129, 250) {"col, chl" = [31 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg130, 250) {"col, chl" = [35 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg131, 250) {"col, chl" = [39 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg132, 250) {"col, chl" = [42 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg120, 250) {"col, chl" = [26 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg121, 250) {"col, chl" = [26 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg133, 250) {"col, chl" = [40 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg2, 250) {"col, chl" = [6 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg1, 250) {"col, chl" = [7 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg4, 250) {"col, chl" = [8 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg136, 250) {"col, chl" = [14 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg7, 250) {"col, chl" = [8 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg6, 250) {"col, chl" = [9 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg8, 250) {"col, chl" = [9 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg137, 250) {"col, chl" = [14 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg11, 250) {"col, chl" = [10 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg10, 250) {"col, chl" = [10 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg12, 250) {"col, chl" = [10 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg138, 250) {"col, chl" = [16 : index, 2 : index]} : <Out, 128>
    adf.config.plio(%arg15, 250) {"col, chl" = [14 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg14, 250) {"col, chl" = [14 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg16, 250) {"col, chl" = [14 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg139, 250) {"col, chl" = [16 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg19, 250) {"col, chl" = [18 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg18, 250) {"col, chl" = [18 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg20, 250) {"col, chl" = [18 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg140, 250) {"col, chl" = [18 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg23, 250) {"col, chl" = [21 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg22, 250) {"col, chl" = [21 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg24, 250) {"col, chl" = [21 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg141, 250) {"col, chl" = [22 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg27, 250) {"col, chl" = [26 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg26, 250) {"col, chl" = [27 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg28, 250) {"col, chl" = [27 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg142, 250) {"col, chl" = [26 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg31, 250) {"col, chl" = [30 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg30, 250) {"col, chl" = [30 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg32, 250) {"col, chl" = [30 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg143, 250) {"col, chl" = [30 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg35, 250) {"col, chl" = [34 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg34, 250) {"col, chl" = [34 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg36, 250) {"col, chl" = [34 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg144, 250) {"col, chl" = [34 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg39, 250) {"col, chl" = [38 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg38, 250) {"col, chl" = [38 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg40, 250) {"col, chl" = [38 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg145, 250) {"col, chl" = [38 : index, 4 : index]} : <Out, 128>
    adf.config.plio(%arg43, 250) {"col, chl" = [42 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg42, 250) {"col, chl" = [42 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg44, 250) {"col, chl" = [41 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg146, 250) {"col, chl" = [40 : index, 0 : index]} : <Out, 128>
    adf.config.plio(%arg134, 250) {"col, chl" = [27 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg47, 250) {"col, chl" = [44 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg135, 250) {"col, chl" = [28 : index, 4 : index]} : <In, 128>
    adf.config.plio(%arg46, 250) {"col, chl" = [43 : index, 0 : index]} : <In, 128>
    adf.config.plio(%arg48, 250) {"col, chl" = [41 : index, 2 : index]} : <In, 128>
    adf.config.plio(%arg147, 250) {"col, chl" = [38 : index, 2 : index]} : <Out, 128>
    %0 = adf.buffer.create @L1_L1_A() : memref<2x16x32xf32, 2>
    %1 = adf.buffer.create @L1_L1_B() : memref<16x32xf32, 2>
    %2 = adf.buffer.create @L1_L1_C() : memref<32x32xf32, 2>
    %3 = adf.buffer.create @L1_L1_A_1() : memref<2x16x32xf32, 2>
    %4 = adf.buffer.create @L1_L1_B_1() : memref<16x32xf32, 2>
    %5 = adf.buffer.create @L1_L1_C_1() : memref<32x32xf32, 2>
    %6 = adf.buffer.create @L1_L1_D_1() : memref<2x32xf32, 2>
    %7 = adf.buffer.create @L1_L1_A_2() : memref<2x16x32xf32, 2>
    %8 = adf.buffer.create @L1_L1_B_2() : memref<16x32xf32, 2>
    %9 = adf.buffer.create @L1_L1_C_2() : memref<32x32xf32, 2>
    %10 = adf.buffer.create @L1_L1_A_3() : memref<2x16x32xf32, 2>
    %11 = adf.buffer.create @L1_L1_B_3() : memref<16x32xf32, 2>
    %12 = adf.buffer.create @L1_L1_C_3() : memref<32x32xf32, 2>
    %13 = adf.buffer.create @L1_L1_D_3() : memref<2x32xf32, 2>
    %14 = adf.buffer.create @L1_L1_A_4() : memref<2x16x32xf32, 2>
    %15 = adf.buffer.create @L1_L1_B_4() : memref<16x32xf32, 2>
    %16 = adf.buffer.create @L1_L1_C_4() : memref<32x32xf32, 2>
    %17 = adf.buffer.create @L1_L1_A_5() : memref<2x16x32xf32, 2>
    %18 = adf.buffer.create @L1_L1_B_5() : memref<16x32xf32, 2>
    %19 = adf.buffer.create @L1_L1_C_5() : memref<32x32xf32, 2>
    %20 = adf.buffer.create @L1_L1_D_5() : memref<2x32xf32, 2>
    %21 = adf.buffer.create @L1_L1_A_6() : memref<2x16x32xf32, 2>
    %22 = adf.buffer.create @L1_L1_B_6() : memref<16x32xf32, 2>
    %23 = adf.buffer.create @L1_L1_C_6() : memref<32x32xf32, 2>
    %24 = adf.buffer.create @L1_L1_A_7() : memref<2x16x32xf32, 2>
    %25 = adf.buffer.create @L1_L1_B_7() : memref<16x32xf32, 2>
    %26 = adf.buffer.create @L1_L1_C_7() : memref<32x32xf32, 2>
    %27 = adf.buffer.create @L1_L1_D_7() : memref<2x32xf32, 2>
    %28 = adf.buffer.create @L1_L1_A_8() : memref<2x16x32xf32, 2>
    %29 = adf.buffer.create @L1_L1_B_8() : memref<16x32xf32, 2>
    %30 = adf.buffer.create @L1_L1_C_8() : memref<32x32xf32, 2>
    %31 = adf.buffer.create @L1_L1_A_9() : memref<2x16x32xf32, 2>
    %32 = adf.buffer.create @L1_L1_B_9() : memref<16x32xf32, 2>
    %33 = adf.buffer.create @L1_L1_C_9() : memref<32x32xf32, 2>
    %34 = adf.buffer.create @L1_L1_D_9() : memref<2x32xf32, 2>
    %35 = adf.buffer.create @L1_L1_A_10() : memref<2x16x32xf32, 2>
    %36 = adf.buffer.create @L1_L1_B_10() : memref<16x32xf32, 2>
    %37 = adf.buffer.create @L1_L1_C_10() : memref<32x32xf32, 2>
    %38 = adf.buffer.create @L1_L1_A_11() : memref<2x16x32xf32, 2>
    %39 = adf.buffer.create @L1_L1_B_11() : memref<16x32xf32, 2>
    %40 = adf.buffer.create @L1_L1_C_11() : memref<32x32xf32, 2>
    %41 = adf.buffer.create @L1_L1_D_11() : memref<2x32xf32, 2>
    %42 = adf.buffer.create @L1_L1_A_12() : memref<2x16x32xf32, 2>
    %43 = adf.buffer.create @L1_L1_B_12() : memref<16x32xf32, 2>
    %44 = adf.buffer.create @L1_L1_C_12() : memref<32x32xf32, 2>
    %45 = adf.buffer.create @L1_L1_A_13() : memref<2x16x32xf32, 2>
    %46 = adf.buffer.create @L1_L1_B_13() : memref<16x32xf32, 2>
    %47 = adf.buffer.create @L1_L1_C_13() : memref<32x32xf32, 2>
    %48 = adf.buffer.create @L1_L1_D_13() : memref<2x32xf32, 2>
    %49 = adf.buffer.create @L1_L1_A_14() : memref<2x16x32xf32, 2>
    %50 = adf.buffer.create @L1_L1_B_14() : memref<16x32xf32, 2>
    %51 = adf.buffer.create @L1_L1_C_14() : memref<32x32xf32, 2>
    %52 = adf.buffer.create @L1_L1_A_15() : memref<2x16x32xf32, 2>
    %53 = adf.buffer.create @L1_L1_B_15() : memref<16x32xf32, 2>
    %54 = adf.buffer.create @L1_L1_C_15() : memref<32x32xf32, 2>
    %55 = adf.buffer.create @L1_L1_D_15() : memref<2x32xf32, 2>
    %56 = adf.buffer.create @L1_L1_A_16() : memref<2x16x32xf32, 2>
    %57 = adf.buffer.create @L1_L1_B_16() : memref<16x32xf32, 2>
    %58 = adf.buffer.create @L1_L1_C_16() : memref<32x32xf32, 2>
    %59 = adf.buffer.create @L1_L1_A_17() : memref<2x16x32xf32, 2>
    %60 = adf.buffer.create @L1_L1_B_17() : memref<16x32xf32, 2>
    %61 = adf.buffer.create @L1_L1_C_17() : memref<32x32xf32, 2>
    %62 = adf.buffer.create @L1_L1_D_17() : memref<2x32xf32, 2>
    %63 = adf.buffer.create @L1_L1_A_18() : memref<2x16x32xf32, 2>
    %64 = adf.buffer.create @L1_L1_B_18() : memref<16x32xf32, 2>
    %65 = adf.buffer.create @L1_L1_C_18() : memref<32x32xf32, 2>
    %66 = adf.buffer.create @L1_L1_A_19() : memref<2x16x32xf32, 2>
    %67 = adf.buffer.create @L1_L1_B_19() : memref<16x32xf32, 2>
    %68 = adf.buffer.create @L1_L1_C_19() : memref<32x32xf32, 2>
    %69 = adf.buffer.create @L1_L1_D_19() : memref<2x32xf32, 2>
    %70 = adf.buffer.create @L1_L1_A_20() : memref<2x16x32xf32, 2>
    %71 = adf.buffer.create @L1_L1_B_20() : memref<16x32xf32, 2>
    %72 = adf.buffer.create @L1_L1_C_20() : memref<32x32xf32, 2>
    %73 = adf.buffer.create @L1_L1_A_21() : memref<2x16x32xf32, 2>
    %74 = adf.buffer.create @L1_L1_B_21() : memref<16x32xf32, 2>
    %75 = adf.buffer.create @L1_L1_C_21() : memref<32x32xf32, 2>
    %76 = adf.buffer.create @L1_L1_D_21() : memref<2x32xf32, 2>
    %77 = adf.buffer.create @L1_L1_A_22() : memref<2x16x32xf32, 2>
    %78 = adf.buffer.create @L1_L1_B_22() : memref<16x32xf32, 2>
    %79 = adf.buffer.create @L1_L1_C_22() : memref<32x32xf32, 2>
    %80 = adf.buffer.create @L1_L1_A_23() : memref<2x16x32xf32, 2>
    %81 = adf.buffer.create @L1_L1_B_23() : memref<16x32xf32, 2>
    %82 = adf.buffer.create @L1_L1_C_23() : memref<32x32xf32, 2>
    %83 = adf.buffer.create @L1_L1_D_23() : memref<2x32xf32, 2>
    %84 = adf.buffer.create @L1_L1_A_24() : memref<2x16x32xf32, 2>
    %85 = adf.buffer.create @L1_L1_B_24() : memref<16x32xf32, 2>
    %86 = adf.buffer.create @L1_L1_C_24() : memref<32x32xf32, 2>
    %87 = adf.buffer.create @L1_L1_A_25() : memref<2x16x32xf32, 2>
    %88 = adf.buffer.create @L1_L1_B_25() : memref<16x32xf32, 2>
    %89 = adf.buffer.create @L1_L1_C_25() : memref<32x32xf32, 2>
    %90 = adf.buffer.create @L1_L1_D_25() : memref<2x32xf32, 2>
    %91 = adf.buffer.create @L1_L1_A_26() : memref<2x16x32xf32, 2>
    %92 = adf.buffer.create @L1_L1_B_26() : memref<16x32xf32, 2>
    %93 = adf.buffer.create @L1_L1_C_26() : memref<32x32xf32, 2>
    %94 = adf.buffer.create @L1_L1_A_27() : memref<2x16x32xf32, 2>
    %95 = adf.buffer.create @L1_L1_B_27() : memref<16x32xf32, 2>
    %96 = adf.buffer.create @L1_L1_C_27() : memref<32x32xf32, 2>
    %97 = adf.buffer.create @L1_L1_D_27() : memref<2x32xf32, 2>
    %98 = adf.buffer.create @L1_L1_A_28() : memref<2x16x32xf32, 2>
    %99 = adf.buffer.create @L1_L1_B_28() : memref<16x32xf32, 2>
    %100 = adf.buffer.create @L1_L1_C_28() : memref<32x32xf32, 2>
    %101 = adf.buffer.create @L1_L1_A_29() : memref<2x16x32xf32, 2>
    %102 = adf.buffer.create @L1_L1_B_29() : memref<16x32xf32, 2>
    %103 = adf.buffer.create @L1_L1_C_29() : memref<32x32xf32, 2>
    %104 = adf.buffer.create @L1_L1_D_29() : memref<2x32xf32, 2>
    %105 = adf.buffer.create @L1_L1_A_30() : memref<2x16x32xf32, 2>
    %106 = adf.buffer.create @L1_L1_B_30() : memref<16x32xf32, 2>
    %107 = adf.buffer.create @L1_L1_C_30() : memref<32x32xf32, 2>
    %108 = adf.buffer.create @L1_L1_A_31() : memref<2x16x32xf32, 2>
    %109 = adf.buffer.create @L1_L1_B_31() : memref<16x32xf32, 2>
    %110 = adf.buffer.create @L1_L1_C_31() : memref<32x32xf32, 2>
    %111 = adf.buffer.create @L1_L1_D_31() : memref<2x32xf32, 2>
    %112 = adf.buffer.create @L1_L1_A_32() : memref<2x16x32xf32, 2>
    %113 = adf.buffer.create @L1_L1_B_32() : memref<16x32xf32, 2>
    %114 = adf.buffer.create @L1_L1_C_32() : memref<32x32xf32, 2>
    %115 = adf.buffer.create @L1_L1_A_33() : memref<2x16x32xf32, 2>
    %116 = adf.buffer.create @L1_L1_B_33() : memref<16x32xf32, 2>
    %117 = adf.buffer.create @L1_L1_C_33() : memref<32x32xf32, 2>
    %118 = adf.buffer.create @L1_L1_D_33() : memref<2x32xf32, 2>
    %119 = adf.buffer.create @L1_L1_A_34() : memref<2x16x32xf32, 2>
    %120 = adf.buffer.create @L1_L1_B_34() : memref<16x32xf32, 2>
    %121 = adf.buffer.create @L1_L1_C_34() : memref<32x32xf32, 2>
    %122 = adf.buffer.create @L1_L1_A_35() : memref<2x16x32xf32, 2>
    %123 = adf.buffer.create @L1_L1_B_35() : memref<16x32xf32, 2>
    %124 = adf.buffer.create @L1_L1_C_35() : memref<32x32xf32, 2>
    %125 = adf.buffer.create @L1_L1_D_35() : memref<2x32xf32, 2>
    %126 = adf.buffer.create @L1_L1_A_36() : memref<2x16x32xf32, 2>
    %127 = adf.buffer.create @L1_L1_B_36() : memref<16x32xf32, 2>
    %128 = adf.buffer.create @L1_L1_C_36() : memref<32x32xf32, 2>
    %129 = adf.buffer.create @L1_L1_A_37() : memref<2x16x32xf32, 2>
    %130 = adf.buffer.create @L1_L1_B_37() : memref<16x32xf32, 2>
    %131 = adf.buffer.create @L1_L1_C_37() : memref<32x32xf32, 2>
    %132 = adf.buffer.create @L1_L1_D_37() : memref<2x32xf32, 2>
    %133 = adf.buffer.create @L1_L1_A_38() : memref<2x16x32xf32, 2>
    %134 = adf.buffer.create @L1_L1_B_38() : memref<16x32xf32, 2>
    %135 = adf.buffer.create @L1_L1_C_38() : memref<32x32xf32, 2>
    %136 = adf.buffer.create @L1_L1_A_39() : memref<2x16x32xf32, 2>
    %137 = adf.buffer.create @L1_L1_B_39() : memref<16x32xf32, 2>
    %138 = adf.buffer.create @L1_L1_C_39() : memref<32x32xf32, 2>
    %139 = adf.buffer.create @L1_L1_D_39() : memref<2x32xf32, 2>
    %140 = adf.buffer.create @L1_L1_A_40() : memref<2x16x32xf32, 2>
    %141 = adf.buffer.create @L1_L1_B_40() : memref<16x32xf32, 2>
    %142 = adf.buffer.create @L1_L1_C_40() : memref<32x32xf32, 2>
    %143 = adf.buffer.create @L1_L1_A_41() : memref<2x16x32xf32, 2>
    %144 = adf.buffer.create @L1_L1_B_41() : memref<16x32xf32, 2>
    %145 = adf.buffer.create @L1_L1_C_41() : memref<32x32xf32, 2>
    %146 = adf.buffer.create @L1_L1_D_41() : memref<2x32xf32, 2>
    %147 = adf.buffer.create @L1_L1_A_42() : memref<2x16x32xf32, 2>
    %148 = adf.buffer.create @L1_L1_B_42() : memref<16x32xf32, 2>
    %149 = adf.buffer.create @L1_L1_C_42() : memref<32x32xf32, 2>
    %150 = adf.buffer.create @L1_L1_A_43() : memref<2x16x32xf32, 2>
    %151 = adf.buffer.create @L1_L1_B_43() : memref<16x32xf32, 2>
    %152 = adf.buffer.create @L1_L1_C_43() : memref<32x32xf32, 2>
    %153 = adf.buffer.create @L1_L1_D_43() : memref<2x32xf32, 2>
    %154 = adf.buffer.create @L1_L1_A_44() : memref<2x16x32xf32, 2>
    %155 = adf.buffer.create @L1_L1_B_44() : memref<16x32xf32, 2>
    %156 = adf.buffer.create @L1_L1_C_44() : memref<32x32xf32, 2>
    %157 = adf.buffer.create @L1_L1_A_45() : memref<2x16x32xf32, 2>
    %158 = adf.buffer.create @L1_L1_B_45() : memref<16x32xf32, 2>
    %159 = adf.buffer.create @L1_L1_C_45() : memref<32x32xf32, 2>
    %160 = adf.buffer.create @L1_L1_D_45() : memref<2x32xf32, 2>
    %161 = adf.buffer.create @L1_L1_A_46() : memref<2x16x32xf32, 2>
    %162 = adf.buffer.create @L1_L1_B_46() : memref<16x32xf32, 2>
    %163 = adf.buffer.create @L1_L1_C_46() : memref<32x32xf32, 2>
    %164 = adf.buffer.create @L1_L1_A_47() : memref<2x16x32xf32, 2>
    %165 = adf.buffer.create @L1_L1_B_47() : memref<16x32xf32, 2>
    %166 = adf.buffer.create @L1_L1_C_47() : memref<32x32xf32, 2>
    %167 = adf.buffer.create @L1_L1_D_47() : memref<2x32xf32, 2>
    %168 = adf.buffer.create @L1_L1_A_48() : memref<2x16x32xf32, 2>
    %169 = adf.buffer.create @L1_L1_B_48() : memref<16x32xf32, 2>
    %170 = adf.buffer.create @L1_L1_C_48() : memref<32x32xf32, 2>
    %171 = adf.buffer.create @L1_L1_A_49() : memref<2x16x32xf32, 2>
    %172 = adf.buffer.create @L1_L1_B_49() : memref<16x32xf32, 2>
    %173 = adf.buffer.create @L1_L1_C_49() : memref<32x32xf32, 2>
    %174 = adf.buffer.create @L1_L1_D_49() : memref<2x32xf32, 2>
    %175 = adf.buffer.create @L1_L1_A_50() : memref<2x16x32xf32, 2>
    %176 = adf.buffer.create @L1_L1_B_50() : memref<16x32xf32, 2>
    %177 = adf.buffer.create @L1_L1_C_50() : memref<32x32xf32, 2>
    %178 = adf.buffer.create @L1_L1_A_51() : memref<2x16x32xf32, 2>
    %179 = adf.buffer.create @L1_L1_B_51() : memref<16x32xf32, 2>
    %180 = adf.buffer.create @L1_L1_C_51() : memref<32x32xf32, 2>
    %181 = adf.buffer.create @L1_L1_D_51() : memref<2x32xf32, 2>
    %182 = adf.buffer.create @L1_L1_A_52() : memref<2x16x32xf32, 2>
    %183 = adf.buffer.create @L1_L1_B_52() : memref<16x32xf32, 2>
    %184 = adf.buffer.create @L1_L1_C_52() : memref<32x32xf32, 2>
    %185 = adf.buffer.create @L1_L1_A_53() : memref<2x16x32xf32, 2>
    %186 = adf.buffer.create @L1_L1_B_53() : memref<16x32xf32, 2>
    %187 = adf.buffer.create @L1_L1_C_53() : memref<32x32xf32, 2>
    %188 = adf.buffer.create @L1_L1_D_53() : memref<2x32xf32, 2>
    %189 = adf.buffer.create @L1_L1_A_54() : memref<2x16x32xf32, 2>
    %190 = adf.buffer.create @L1_L1_B_54() : memref<16x32xf32, 2>
    %191 = adf.buffer.create @L1_L1_C_54() : memref<32x32xf32, 2>
    %192 = adf.buffer.create @L1_L1_A_55() : memref<2x16x32xf32, 2>
    %193 = adf.buffer.create @L1_L1_B_55() : memref<16x32xf32, 2>
    %194 = adf.buffer.create @L1_L1_C_55() : memref<32x32xf32, 2>
    %195 = adf.buffer.create @L1_L1_D_55() : memref<2x32xf32, 2>
    %196 = adf.buffer.create @L1_L1_A_56() : memref<2x16x32xf32, 2>
    %197 = adf.buffer.create @L1_L1_B_56() : memref<16x32xf32, 2>
    %198 = adf.buffer.create @L1_L1_C_56() : memref<32x32xf32, 2>
    %199 = adf.buffer.create @L1_L1_A_57() : memref<2x16x32xf32, 2>
    %200 = adf.buffer.create @L1_L1_B_57() : memref<16x32xf32, 2>
    %201 = adf.buffer.create @L1_L1_C_57() : memref<32x32xf32, 2>
    %202 = adf.buffer.create @L1_L1_D_57() : memref<2x32xf32, 2>
    %203 = adf.buffer.create @L1_L1_A_58() : memref<2x16x32xf32, 2>
    %204 = adf.buffer.create @L1_L1_B_58() : memref<16x32xf32, 2>
    %205 = adf.buffer.create @L1_L1_C_58() : memref<32x32xf32, 2>
    %206 = adf.buffer.create @L1_L1_A_59() : memref<2x16x32xf32, 2>
    %207 = adf.buffer.create @L1_L1_B_59() : memref<16x32xf32, 2>
    %208 = adf.buffer.create @L1_L1_C_59() : memref<32x32xf32, 2>
    %209 = adf.buffer.create @L1_L1_D_59() : memref<2x32xf32, 2>
    %210 = adf.buffer.create @L1_L1_A_60() : memref<2x16x32xf32, 2>
    %211 = adf.buffer.create @L1_L1_B_60() : memref<16x32xf32, 2>
    %212 = adf.buffer.create @L1_L1_C_60() : memref<32x32xf32, 2>
    %213 = adf.buffer.create @L1_L1_A_61() : memref<2x16x32xf32, 2>
    %214 = adf.buffer.create @L1_L1_B_61() : memref<16x32xf32, 2>
    %215 = adf.buffer.create @L1_L1_C_61() : memref<32x32xf32, 2>
    %216 = adf.buffer.create @L1_L1_D_61() : memref<2x32xf32, 2>
    %217 = adf.buffer.create @L1_L1_A_62() : memref<2x16x32xf32, 2>
    %218 = adf.buffer.create @L1_L1_B_62() : memref<16x32xf32, 2>
    %219 = adf.buffer.create @L1_L1_C_62() : memref<32x32xf32, 2>
    %220 = adf.buffer.create @L1_L1_A_63() : memref<2x16x32xf32, 2>
    %221 = adf.buffer.create @L1_L1_B_63() : memref<16x32xf32, 2>
    %222 = adf.buffer.create @L1_L1_C_63() : memref<32x32xf32, 2>
    %223 = adf.buffer.create @L1_L1_D_63() : memref<2x32xf32, 2>
    %224 = adf.buffer.create @L1_L1_A_64() : memref<2x16x32xf32, 2>
    %225 = adf.buffer.create @L1_L1_B_64() : memref<16x32xf32, 2>
    %226 = adf.buffer.create @L1_L1_C_64() : memref<32x32xf32, 2>
    %227 = adf.buffer.create @L1_L1_A_65() : memref<2x16x32xf32, 2>
    %228 = adf.buffer.create @L1_L1_B_65() : memref<16x32xf32, 2>
    %229 = adf.buffer.create @L1_L1_C_65() : memref<32x32xf32, 2>
    %230 = adf.buffer.create @L1_L1_D_65() : memref<2x32xf32, 2>
    %231 = adf.buffer.create @L1_L1_A_66() : memref<2x16x32xf32, 2>
    %232 = adf.buffer.create @L1_L1_B_66() : memref<16x32xf32, 2>
    %233 = adf.buffer.create @L1_L1_C_66() : memref<32x32xf32, 2>
    %234 = adf.buffer.create @L1_L1_A_67() : memref<2x16x32xf32, 2>
    %235 = adf.buffer.create @L1_L1_B_67() : memref<16x32xf32, 2>
    %236 = adf.buffer.create @L1_L1_C_67() : memref<32x32xf32, 2>
    %237 = adf.buffer.create @L1_L1_D_67() : memref<2x32xf32, 2>
    %238 = adf.buffer.create @L1_L1_A_68() : memref<2x16x32xf32, 2>
    %239 = adf.buffer.create @L1_L1_B_68() : memref<16x32xf32, 2>
    %240 = adf.buffer.create @L1_L1_C_68() : memref<32x32xf32, 2>
    %241 = adf.buffer.create @L1_L1_A_69() : memref<2x16x32xf32, 2>
    %242 = adf.buffer.create @L1_L1_B_69() : memref<16x32xf32, 2>
    %243 = adf.buffer.create @L1_L1_C_69() : memref<32x32xf32, 2>
    %244 = adf.buffer.create @L1_L1_D_69() : memref<2x32xf32, 2>
    %245 = adf.buffer.create @L1_L1_A_70() : memref<2x16x32xf32, 2>
    %246 = adf.buffer.create @L1_L1_B_70() : memref<16x32xf32, 2>
    %247 = adf.buffer.create @L1_L1_C_70() : memref<32x32xf32, 2>
    %248 = adf.buffer.create @L1_L1_A_71() : memref<2x16x32xf32, 2>
    %249 = adf.buffer.create @L1_L1_B_71() : memref<16x32xf32, 2>
    %250 = adf.buffer.create @L1_L1_C_71() : memref<32x32xf32, 2>
    %251 = adf.buffer.create @L1_L1_D_71() : memref<2x32xf32, 2>
    %252 = adf.buffer.create @L1_L1_A_72() : memref<2x16x32xf32, 2>
    %253 = adf.buffer.create @L1_L1_B_72() : memref<16x32xf32, 2>
    %254 = adf.buffer.create @L1_L1_C_72() : memref<32x32xf32, 2>
    %255 = adf.buffer.create @L1_L1_A_73() : memref<2x16x32xf32, 2>
    %256 = adf.buffer.create @L1_L1_B_73() : memref<16x32xf32, 2>
    %257 = adf.buffer.create @L1_L1_C_73() : memref<32x32xf32, 2>
    %258 = adf.buffer.create @L1_L1_D_73() : memref<2x32xf32, 2>
    %259 = adf.buffer.create @L1_L1_A_74() : memref<2x16x32xf32, 2>
    %260 = adf.buffer.create @L1_L1_B_74() : memref<16x32xf32, 2>
    %261 = adf.buffer.create @L1_L1_C_74() : memref<32x32xf32, 2>
    %262 = adf.buffer.create @L1_L1_A_75() : memref<2x16x32xf32, 2>
    %263 = adf.buffer.create @L1_L1_B_75() : memref<16x32xf32, 2>
    %264 = adf.buffer.create @L1_L1_C_75() : memref<32x32xf32, 2>
    %265 = adf.buffer.create @L1_L1_D_75() : memref<2x32xf32, 2>
    %266 = adf.buffer.create @L1_L1_A_76() : memref<2x16x32xf32, 2>
    %267 = adf.buffer.create @L1_L1_B_76() : memref<16x32xf32, 2>
    %268 = adf.buffer.create @L1_L1_C_76() : memref<32x32xf32, 2>
    %269 = adf.buffer.create @L1_L1_A_77() : memref<2x16x32xf32, 2>
    %270 = adf.buffer.create @L1_L1_B_77() : memref<16x32xf32, 2>
    %271 = adf.buffer.create @L1_L1_C_77() : memref<32x32xf32, 2>
    %272 = adf.buffer.create @L1_L1_D_77() : memref<2x32xf32, 2>
    %273 = adf.buffer.create @L1_L1_A_78() : memref<2x16x32xf32, 2>
    %274 = adf.buffer.create @L1_L1_B_78() : memref<16x32xf32, 2>
    %275 = adf.buffer.create @L1_L1_C_78() : memref<32x32xf32, 2>
    %276 = adf.buffer.create @L1_L1_A_79() : memref<2x16x32xf32, 2>
    %277 = adf.buffer.create @L1_L1_B_79() : memref<16x32xf32, 2>
    %278 = adf.buffer.create @L1_L1_C_79() : memref<32x32xf32, 2>
    %279 = adf.buffer.create @L1_L1_D_79() : memref<2x32xf32, 2>
    %280 = adf.buffer.create @L1_L1_A_80() : memref<2x16x32xf32, 2>
    %281 = adf.buffer.create @L1_L1_B_80() : memref<16x32xf32, 2>
    %282 = adf.buffer.create @L1_L1_C_80() : memref<32x32xf32, 2>
    %283 = adf.buffer.create @L1_L1_A_81() : memref<2x16x32xf32, 2>
    %284 = adf.buffer.create @L1_L1_B_81() : memref<16x32xf32, 2>
    %285 = adf.buffer.create @L1_L1_C_81() : memref<32x32xf32, 2>
    %286 = adf.buffer.create @L1_L1_D_81() : memref<2x32xf32, 2>
    %287 = adf.buffer.create @L1_L1_A_82() : memref<2x16x32xf32, 2>
    %288 = adf.buffer.create @L1_L1_B_82() : memref<16x32xf32, 2>
    %289 = adf.buffer.create @L1_L1_C_82() : memref<32x32xf32, 2>
    %290 = adf.buffer.create @L1_L1_A_83() : memref<2x16x32xf32, 2>
    %291 = adf.buffer.create @L1_L1_B_83() : memref<16x32xf32, 2>
    %292 = adf.buffer.create @L1_L1_C_83() : memref<32x32xf32, 2>
    %293 = adf.buffer.create @L1_L1_D_83() : memref<2x32xf32, 2>
    %294 = adf.buffer.create @L1_L1_A_84() : memref<2x16x32xf32, 2>
    %295 = adf.buffer.create @L1_L1_B_84() : memref<16x32xf32, 2>
    %296 = adf.buffer.create @L1_L1_C_84() : memref<32x32xf32, 2>
    %297 = adf.buffer.create @L1_L1_A_85() : memref<2x16x32xf32, 2>
    %298 = adf.buffer.create @L1_L1_B_85() : memref<16x32xf32, 2>
    %299 = adf.buffer.create @L1_L1_C_85() : memref<32x32xf32, 2>
    %300 = adf.buffer.create @L1_L1_D_85() : memref<2x32xf32, 2>
    %301 = adf.buffer.create @L1_L1_A_86() : memref<2x16x32xf32, 2>
    %302 = adf.buffer.create @L1_L1_B_86() : memref<16x32xf32, 2>
    %303 = adf.buffer.create @L1_L1_C_86() : memref<32x32xf32, 2>
    %304 = adf.buffer.create @L1_L1_A_87() : memref<2x16x32xf32, 2>
    %305 = adf.buffer.create @L1_L1_B_87() : memref<16x32xf32, 2>
    %306 = adf.buffer.create @L1_L1_C_87() : memref<32x32xf32, 2>
    %307 = adf.buffer.create @L1_L1_D_87() : memref<2x32xf32, 2>
    %308 = adf.buffer.create @L1_L1_A_88() : memref<2x16x32xf32, 2>
    %309 = adf.buffer.create @L1_L1_B_88() : memref<16x32xf32, 2>
    %310 = adf.buffer.create @L1_L1_C_88() : memref<32x32xf32, 2>
    %311 = adf.buffer.create @L1_L1_A_89() : memref<2x16x32xf32, 2>
    %312 = adf.buffer.create @L1_L1_B_89() : memref<16x32xf32, 2>
    %313 = adf.buffer.create @L1_L1_C_89() : memref<32x32xf32, 2>
    %314 = adf.buffer.create @L1_L1_D_89() : memref<2x32xf32, 2>
    %315 = adf.buffer.create @L1_L1_A_90() : memref<2x16x32xf32, 2>
    %316 = adf.buffer.create @L1_L1_B_90() : memref<16x32xf32, 2>
    %317 = adf.buffer.create @L1_L1_C_90() : memref<32x32xf32, 2>
    %318 = adf.buffer.create @L1_L1_A_91() : memref<2x16x32xf32, 2>
    %319 = adf.buffer.create @L1_L1_B_91() : memref<16x32xf32, 2>
    %320 = adf.buffer.create @L1_L1_C_91() : memref<32x32xf32, 2>
    %321 = adf.buffer.create @L1_L1_D_91() : memref<2x32xf32, 2>
    %322 = adf.buffer.create @L1_L1_A_92() : memref<2x16x32xf32, 2>
    %323 = adf.buffer.create @L1_L1_B_92() : memref<16x32xf32, 2>
    %324 = adf.buffer.create @L1_L1_C_92() : memref<32x32xf32, 2>
    %325 = adf.buffer.create @L1_L1_A_93() : memref<2x16x32xf32, 2>
    %326 = adf.buffer.create @L1_L1_B_93() : memref<16x32xf32, 2>
    %327 = adf.buffer.create @L1_L1_C_93() : memref<32x32xf32, 2>
    %328 = adf.buffer.create @L1_L1_D_93() : memref<2x32xf32, 2>
    %329 = adf.buffer.create @L1_L1_A_94() : memref<2x16x32xf32, 2>
    %330 = adf.buffer.create @L1_L1_B_94() : memref<16x32xf32, 2>
    %331 = adf.buffer.create @L1_L1_C_94() : memref<32x32xf32, 2>
    %332 = adf.buffer.create @L1_L1_A_95() : memref<2x16x32xf32, 2>
    %333 = adf.buffer.create @L1_L1_B_95() : memref<16x32xf32, 2>
    %334 = adf.buffer.create @L1_L1_C_95() : memref<32x32xf32, 2>
    %335 = adf.buffer.create @L1_L1_D_95() : memref<2x32xf32, 2>
    %336 = adf.buffer.create @L1_L1_A_96() : memref<2x16x32xf32, 2>
    %337 = adf.buffer.create @L1_L1_B_96() : memref<16x32xf32, 2>
    %338 = adf.buffer.create @L1_L1_C_96() : memref<32x32xf32, 2>
    %339 = adf.buffer.create @L1_L1_A_97() : memref<2x16x32xf32, 2>
    %340 = adf.buffer.create @L1_L1_B_97() : memref<16x32xf32, 2>
    %341 = adf.buffer.create @L1_L1_C_97() : memref<32x32xf32, 2>
    %342 = adf.buffer.create @L1_L1_D_97() : memref<2x32xf32, 2>
    %343 = adf.buffer.create @L1_L1_A_98() : memref<2x16x32xf32, 2>
    %344 = adf.buffer.create @L1_L1_B_98() : memref<16x32xf32, 2>
    %345 = adf.buffer.create @L1_L1_C_98() : memref<32x32xf32, 2>
    %346 = adf.buffer.create @L1_L1_A_99() : memref<2x16x32xf32, 2>
    %347 = adf.buffer.create @L1_L1_B_99() : memref<16x32xf32, 2>
    %348 = adf.buffer.create @L1_L1_C_99() : memref<32x32xf32, 2>
    %349 = adf.buffer.create @L1_L1_D_99() : memref<2x32xf32, 2>
    %350 = adf.buffer.create @L1_L1_A_100() : memref<2x16x32xf32, 2>
    %351 = adf.buffer.create @L1_L1_B_100() : memref<16x32xf32, 2>
    %352 = adf.buffer.create @L1_L1_C_100() : memref<32x32xf32, 2>
    %353 = adf.buffer.create @L1_L1_A_101() : memref<2x16x32xf32, 2>
    %354 = adf.buffer.create @L1_L1_B_101() : memref<16x32xf32, 2>
    %355 = adf.buffer.create @L1_L1_C_101() : memref<32x32xf32, 2>
    %356 = adf.buffer.create @L1_L1_D_101() : memref<2x32xf32, 2>
    %357 = adf.buffer.create @L1_L1_A_102() : memref<2x16x32xf32, 2>
    %358 = adf.buffer.create @L1_L1_B_102() : memref<16x32xf32, 2>
    %359 = adf.buffer.create @L1_L1_C_102() : memref<32x32xf32, 2>
    %360 = adf.buffer.create @L1_L1_A_103() : memref<2x16x32xf32, 2>
    %361 = adf.buffer.create @L1_L1_B_103() : memref<16x32xf32, 2>
    %362 = adf.buffer.create @L1_L1_C_103() : memref<32x32xf32, 2>
    %363 = adf.buffer.create @L1_L1_D_103() : memref<2x32xf32, 2>
    %364 = adf.buffer.create @L1_L1_A_104() : memref<2x16x32xf32, 2>
    %365 = adf.buffer.create @L1_L1_B_104() : memref<16x32xf32, 2>
    %366 = adf.buffer.create @L1_L1_C_104() : memref<32x32xf32, 2>
    %367 = adf.buffer.create @L1_L1_A_105() : memref<2x16x32xf32, 2>
    %368 = adf.buffer.create @L1_L1_B_105() : memref<16x32xf32, 2>
    %369 = adf.buffer.create @L1_L1_C_105() : memref<32x32xf32, 2>
    %370 = adf.buffer.create @L1_L1_D_105() : memref<2x32xf32, 2>
    %371 = adf.buffer.create @L1_L1_A_106() : memref<2x16x32xf32, 2>
    %372 = adf.buffer.create @L1_L1_B_106() : memref<16x32xf32, 2>
    %373 = adf.buffer.create @L1_L1_C_106() : memref<32x32xf32, 2>
    %374 = adf.buffer.create @L1_L1_A_107() : memref<2x16x32xf32, 2>
    %375 = adf.buffer.create @L1_L1_B_107() : memref<16x32xf32, 2>
    %376 = adf.buffer.create @L1_L1_C_107() : memref<32x32xf32, 2>
    %377 = adf.buffer.create @L1_L1_D_107() : memref<2x32xf32, 2>
    %378 = adf.buffer.create @L1_L1_A_108() : memref<2x16x32xf32, 2>
    %379 = adf.buffer.create @L1_L1_B_108() : memref<16x32xf32, 2>
    %380 = adf.buffer.create @L1_L1_C_108() : memref<32x32xf32, 2>
    %381 = adf.buffer.create @L1_L1_A_109() : memref<2x16x32xf32, 2>
    %382 = adf.buffer.create @L1_L1_B_109() : memref<16x32xf32, 2>
    %383 = adf.buffer.create @L1_L1_C_109() : memref<32x32xf32, 2>
    %384 = adf.buffer.create @L1_L1_D_109() : memref<2x32xf32, 2>
    %385 = adf.buffer.create @L1_L1_A_110() : memref<2x16x32xf32, 2>
    %386 = adf.buffer.create @L1_L1_B_110() : memref<16x32xf32, 2>
    %387 = adf.buffer.create @L1_L1_C_110() : memref<32x32xf32, 2>
    %388 = adf.buffer.create @L1_L1_A_111() : memref<2x16x32xf32, 2>
    %389 = adf.buffer.create @L1_L1_B_111() : memref<16x32xf32, 2>
    %390 = adf.buffer.create @L1_L1_C_111() : memref<32x32xf32, 2>
    %391 = adf.buffer.create @L1_L1_D_111() : memref<2x32xf32, 2>
    %392 = adf.buffer.create @L1_L1_A_112() : memref<2x16x32xf32, 2>
    %393 = adf.buffer.create @L1_L1_B_112() : memref<16x32xf32, 2>
    %394 = adf.buffer.create @L1_L1_C_112() : memref<32x32xf32, 2>
    %395 = adf.buffer.create @L1_L1_A_113() : memref<2x16x32xf32, 2>
    %396 = adf.buffer.create @L1_L1_B_113() : memref<16x32xf32, 2>
    %397 = adf.buffer.create @L1_L1_C_113() : memref<32x32xf32, 2>
    %398 = adf.buffer.create @L1_L1_D_113() : memref<2x32xf32, 2>
    %399 = adf.buffer.create @L1_L1_A_114() : memref<2x16x32xf32, 2>
    %400 = adf.buffer.create @L1_L1_B_114() : memref<16x32xf32, 2>
    %401 = adf.buffer.create @L1_L1_C_114() : memref<32x32xf32, 2>
    %402 = adf.buffer.create @L1_L1_A_115() : memref<2x16x32xf32, 2>
    %403 = adf.buffer.create @L1_L1_B_115() : memref<16x32xf32, 2>
    %404 = adf.buffer.create @L1_L1_C_115() : memref<32x32xf32, 2>
    %405 = adf.buffer.create @L1_L1_D_115() : memref<2x32xf32, 2>
    %406 = adf.buffer.create @L1_L1_A_116() : memref<2x16x32xf32, 2>
    %407 = adf.buffer.create @L1_L1_B_116() : memref<16x32xf32, 2>
    %408 = adf.buffer.create @L1_L1_C_116() : memref<32x32xf32, 2>
    %409 = adf.buffer.create @L1_L1_A_117() : memref<2x16x32xf32, 2>
    %410 = adf.buffer.create @L1_L1_B_117() : memref<16x32xf32, 2>
    %411 = adf.buffer.create @L1_L1_C_117() : memref<32x32xf32, 2>
    %412 = adf.buffer.create @L1_L1_D_117() : memref<2x32xf32, 2>
    %413 = adf.buffer.create @L1_L1_A_118() : memref<2x16x32xf32, 2>
    %414 = adf.buffer.create @L1_L1_B_118() : memref<16x32xf32, 2>
    %415 = adf.buffer.create @L1_L1_C_118() : memref<32x32xf32, 2>
    %416 = adf.buffer.create @L1_L1_A_119() : memref<2x16x32xf32, 2>
    %417 = adf.buffer.create @L1_L1_B_119() : memref<16x32xf32, 2>
    %418 = adf.buffer.create @L1_L1_C_119() : memref<32x32xf32, 2>
    %419 = adf.buffer.create @L1_L1_D_119() : memref<2x32xf32, 2>
    %420 = adf.buffer.create @L1_L1_A_120() : memref<2x16x32xf32, 2>
    %421 = adf.buffer.create @L1_L1_B_120() : memref<16x32xf32, 2>
    %422 = adf.buffer.create @L1_L1_C_120() : memref<32x32xf32, 2>
    %423 = adf.buffer.create @L1_L1_A_121() : memref<2x16x32xf32, 2>
    %424 = adf.buffer.create @L1_L1_B_121() : memref<16x32xf32, 2>
    %425 = adf.buffer.create @L1_L1_C_121() : memref<32x32xf32, 2>
    %426 = adf.buffer.create @L1_L1_D_121() : memref<2x32xf32, 2>
    %427 = adf.buffer.create @L1_L1_A_122() : memref<2x16x32xf32, 2>
    %428 = adf.buffer.create @L1_L1_B_122() : memref<16x32xf32, 2>
    %429 = adf.buffer.create @L1_L1_C_122() : memref<32x32xf32, 2>
    %430 = adf.buffer.create @L1_L1_A_123() : memref<2x16x32xf32, 2>
    %431 = adf.buffer.create @L1_L1_B_123() : memref<16x32xf32, 2>
    %432 = adf.buffer.create @L1_L1_C_123() : memref<32x32xf32, 2>
    %433 = adf.buffer.create @L1_L1_D_123() : memref<2x32xf32, 2>
    %434 = adf.buffer.create @L1_L1_A_124() : memref<2x16x32xf32, 2>
    %435 = adf.buffer.create @L1_L1_B_124() : memref<16x32xf32, 2>
    %436 = adf.buffer.create @L1_L1_C_124() : memref<32x32xf32, 2>
    %437 = adf.buffer.create @L1_L1_A_125() : memref<2x16x32xf32, 2>
    %438 = adf.buffer.create @L1_L1_B_125() : memref<16x32xf32, 2>
    %439 = adf.buffer.create @L1_L1_C_125() : memref<32x32xf32, 2>
    %440 = adf.buffer.create @L1_L1_D_125() : memref<2x32xf32, 2>
    %441 = adf.buffer.create @L1_L1_A_126() : memref<2x16x32xf32, 2>
    %442 = adf.buffer.create @L1_L1_B_126() : memref<16x32xf32, 2>
    %443 = adf.buffer.create @L1_L1_C_126() : memref<32x32xf32, 2>
    %444 = adf.buffer.create @L1_L1_A_127() : memref<2x16x32xf32, 2>
    %445 = adf.buffer.create @L1_L1_B_127() : memref<16x32xf32, 2>
    %446 = adf.buffer.create @L1_L1_C_127() : memref<32x32xf32, 2>
    %447 = adf.buffer.create @L1_L1_D_127() : memref<2x32xf32, 2>
    %448 = adf.buffer.create @L1_L1_A_128() : memref<2x16x32xf32, 2>
    %449 = adf.buffer.create @L1_L1_B_128() : memref<16x32xf32, 2>
    %450 = adf.buffer.create @L1_L1_C_128() : memref<32x32xf32, 2>
    %451 = adf.buffer.create @L1_L1_A_129() : memref<2x16x32xf32, 2>
    %452 = adf.buffer.create @L1_L1_B_129() : memref<16x32xf32, 2>
    %453 = adf.buffer.create @L1_L1_C_129() : memref<32x32xf32, 2>
    %454 = adf.buffer.create @L1_L1_D_129() : memref<2x32xf32, 2>
    %455 = adf.buffer.create @L1_L1_A_130() : memref<2x16x32xf32, 2>
    %456 = adf.buffer.create @L1_L1_B_130() : memref<16x32xf32, 2>
    %457 = adf.buffer.create @L1_L1_C_130() : memref<32x32xf32, 2>
    %458 = adf.buffer.create @L1_L1_A_131() : memref<2x16x32xf32, 2>
    %459 = adf.buffer.create @L1_L1_B_131() : memref<16x32xf32, 2>
    %460 = adf.buffer.create @L1_L1_C_131() : memref<32x32xf32, 2>
    %461 = adf.buffer.create @L1_L1_D_131() : memref<2x32xf32, 2>
    %462 = adf.buffer.create @L1_L1_A_132() : memref<2x16x32xf32, 2>
    %463 = adf.buffer.create @L1_L1_B_132() : memref<16x32xf32, 2>
    %464 = adf.buffer.create @L1_L1_C_132() : memref<32x32xf32, 2>
    %465 = adf.buffer.create @L1_L1_A_133() : memref<2x16x32xf32, 2>
    %466 = adf.buffer.create @L1_L1_B_133() : memref<16x32xf32, 2>
    %467 = adf.buffer.create @L1_L1_C_133() : memref<32x32xf32, 2>
    %468 = adf.buffer.create @L1_L1_D_133() : memref<2x32xf32, 2>
    %469 = adf.buffer.create @L1_L1_A_134() : memref<2x16x32xf32, 2>
    %470 = adf.buffer.create @L1_L1_B_134() : memref<16x32xf32, 2>
    %471 = adf.buffer.create @L1_L1_C_134() : memref<32x32xf32, 2>
    %472 = adf.buffer.create @L1_L1_A_135() : memref<2x16x32xf32, 2>
    %473 = adf.buffer.create @L1_L1_B_135() : memref<16x32xf32, 2>
    %474 = adf.buffer.create @L1_L1_C_135() : memref<32x32xf32, 2>
    %475 = adf.buffer.create @L1_L1_D_135() : memref<2x32xf32, 2>
    %476 = adf.buffer.create @L1_L1_A_136() : memref<2x16x32xf32, 2>
    %477 = adf.buffer.create @L1_L1_B_136() : memref<16x32xf32, 2>
    %478 = adf.buffer.create @L1_L1_C_136() : memref<32x32xf32, 2>
    %479 = adf.buffer.create @L1_L1_A_137() : memref<2x16x32xf32, 2>
    %480 = adf.buffer.create @L1_L1_B_137() : memref<16x32xf32, 2>
    %481 = adf.buffer.create @L1_L1_C_137() : memref<32x32xf32, 2>
    %482 = adf.buffer.create @L1_L1_D_137() : memref<2x32xf32, 2>
    %483 = adf.buffer.create @L1_L1_A_138() : memref<2x16x32xf32, 2>
    %484 = adf.buffer.create @L1_L1_B_138() : memref<16x32xf32, 2>
    %485 = adf.buffer.create @L1_L1_C_138() : memref<32x32xf32, 2>
    %486 = adf.buffer.create @L1_L1_A_139() : memref<2x16x32xf32, 2>
    %487 = adf.buffer.create @L1_L1_B_139() : memref<16x32xf32, 2>
    %488 = adf.buffer.create @L1_L1_C_139() : memref<32x32xf32, 2>
    %489 = adf.buffer.create @L1_L1_D_139() : memref<2x32xf32, 2>
    %490 = adf.buffer.create @L1_L1_A_140() : memref<2x16x32xf32, 2>
    %491 = adf.buffer.create @L1_L1_B_140() : memref<16x32xf32, 2>
    %492 = adf.buffer.create @L1_L1_C_140() : memref<32x32xf32, 2>
    %493 = adf.buffer.create @L1_L1_A_141() : memref<2x16x32xf32, 2>
    %494 = adf.buffer.create @L1_L1_B_141() : memref<16x32xf32, 2>
    %495 = adf.buffer.create @L1_L1_C_141() : memref<32x32xf32, 2>
    %496 = adf.buffer.create @L1_L1_D_141() : memref<2x32xf32, 2>
    %497 = adf.buffer.create @L1_L1_A_142() : memref<2x16x32xf32, 2>
    %498 = adf.buffer.create @L1_L1_B_142() : memref<16x32xf32, 2>
    %499 = adf.buffer.create @L1_L1_C_142() : memref<32x32xf32, 2>
    %500 = adf.buffer.create @L1_L1_A_143() : memref<2x16x32xf32, 2>
    %501 = adf.buffer.create @L1_L1_B_143() : memref<16x32xf32, 2>
    %502 = adf.buffer.create @L1_L1_C_143() : memref<32x32xf32, 2>
    %503 = adf.buffer.create @L1_L1_D_143() : memref<2x32xf32, 2>
    %504 = adf.buffer.create @L1_L1_A_144() : memref<2x16x32xf32, 2>
    %505 = adf.buffer.create @L1_L1_B_144() : memref<16x32xf32, 2>
    %506 = adf.buffer.create @L1_L1_C_144() : memref<32x32xf32, 2>
    %507 = adf.buffer.create @L1_L1_A_145() : memref<2x16x32xf32, 2>
    %508 = adf.buffer.create @L1_L1_B_145() : memref<16x32xf32, 2>
    %509 = adf.buffer.create @L1_L1_C_145() : memref<32x32xf32, 2>
    %510 = adf.buffer.create @L1_L1_D_145() : memref<2x32xf32, 2>
    %511 = adf.buffer.create @L1_L1_A_146() : memref<2x16x32xf32, 2>
    %512 = adf.buffer.create @L1_L1_B_146() : memref<16x32xf32, 2>
    %513 = adf.buffer.create @L1_L1_C_146() : memref<32x32xf32, 2>
    %514 = adf.buffer.create @L1_L1_A_147() : memref<2x16x32xf32, 2>
    %515 = adf.buffer.create @L1_L1_B_147() : memref<16x32xf32, 2>
    %516 = adf.buffer.create @L1_L1_C_147() : memref<32x32xf32, 2>
    %517 = adf.buffer.create @L1_L1_D_147() : memref<2x32xf32, 2>
    %518 = adf.buffer.create @L1_L1_A_148() : memref<2x16x32xf32, 2>
    %519 = adf.buffer.create @L1_L1_B_148() : memref<16x32xf32, 2>
    %520 = adf.buffer.create @L1_L1_C_148() : memref<32x32xf32, 2>
    %521 = adf.buffer.create @L1_L1_A_149() : memref<2x16x32xf32, 2>
    %522 = adf.buffer.create @L1_L1_B_149() : memref<16x32xf32, 2>
    %523 = adf.buffer.create @L1_L1_C_149() : memref<32x32xf32, 2>
    %524 = adf.buffer.create @L1_L1_D_149() : memref<2x32xf32, 2>
    %525 = adf.buffer.create @L1_L1_A_150() : memref<2x16x32xf32, 2>
    %526 = adf.buffer.create @L1_L1_B_150() : memref<16x32xf32, 2>
    %527 = adf.buffer.create @L1_L1_C_150() : memref<32x32xf32, 2>
    %528 = adf.buffer.create @L1_L1_A_151() : memref<2x16x32xf32, 2>
    %529 = adf.buffer.create @L1_L1_B_151() : memref<16x32xf32, 2>
    %530 = adf.buffer.create @L1_L1_C_151() : memref<32x32xf32, 2>
    %531 = adf.buffer.create @L1_L1_D_151() : memref<2x32xf32, 2>
    %532 = adf.buffer.create @L1_L1_A_152() : memref<2x16x32xf32, 2>
    %533 = adf.buffer.create @L1_L1_B_152() : memref<16x32xf32, 2>
    %534 = adf.buffer.create @L1_L1_C_152() : memref<32x32xf32, 2>
    %535 = adf.buffer.create @L1_L1_A_153() : memref<2x16x32xf32, 2>
    %536 = adf.buffer.create @L1_L1_B_153() : memref<16x32xf32, 2>
    %537 = adf.buffer.create @L1_L1_C_153() : memref<32x32xf32, 2>
    %538 = adf.buffer.create @L1_L1_D_153() : memref<2x32xf32, 2>
    %539 = adf.buffer.create @L1_L1_A_154() : memref<2x16x32xf32, 2>
    %540 = adf.buffer.create @L1_L1_B_154() : memref<16x32xf32, 2>
    %541 = adf.buffer.create @L1_L1_C_154() : memref<32x32xf32, 2>
    %542 = adf.buffer.create @L1_L1_A_155() : memref<2x16x32xf32, 2>
    %543 = adf.buffer.create @L1_L1_B_155() : memref<16x32xf32, 2>
    %544 = adf.buffer.create @L1_L1_C_155() : memref<32x32xf32, 2>
    %545 = adf.buffer.create @L1_L1_D_155() : memref<2x32xf32, 2>
    %546 = adf.buffer.create @L1_L1_A_156() : memref<2x16x32xf32, 2>
    %547 = adf.buffer.create @L1_L1_B_156() : memref<16x32xf32, 2>
    %548 = adf.buffer.create @L1_L1_C_156() : memref<32x32xf32, 2>
    %549 = adf.buffer.create @L1_L1_A_157() : memref<2x16x32xf32, 2>
    %550 = adf.buffer.create @L1_L1_B_157() : memref<16x32xf32, 2>
    %551 = adf.buffer.create @L1_L1_C_157() : memref<32x32xf32, 2>
    %552 = adf.buffer.create @L1_L1_D_157() : memref<2x32xf32, 2>
    %553 = adf.buffer.create @L1_L1_A_158() : memref<2x16x32xf32, 2>
    %554 = adf.buffer.create @L1_L1_B_158() : memref<16x32xf32, 2>
    %555 = adf.buffer.create @L1_L1_C_158() : memref<32x32xf32, 2>
    %556 = adf.buffer.create @L1_L1_A_159() : memref<2x16x32xf32, 2>
    %557 = adf.buffer.create @L1_L1_B_159() : memref<16x32xf32, 2>
    %558 = adf.buffer.create @L1_L1_C_159() : memref<32x32xf32, 2>
    %559 = adf.buffer.create @L1_L1_D_159() : memref<2x32xf32, 2>
    %560 = adf.buffer.create @L1_L1_A_160() : memref<2x16x32xf32, 2>
    %561 = adf.buffer.create @L1_L1_B_160() : memref<16x32xf32, 2>
    %562 = adf.buffer.create @L1_L1_C_160() : memref<32x32xf32, 2>
    %563 = adf.buffer.create @L1_L1_A_161() : memref<2x16x32xf32, 2>
    %564 = adf.buffer.create @L1_L1_B_161() : memref<16x32xf32, 2>
    %565 = adf.buffer.create @L1_L1_C_161() : memref<32x32xf32, 2>
    %566 = adf.buffer.create @L1_L1_D_161() : memref<2x32xf32, 2>
    %567 = adf.buffer.create @L1_L1_A_162() : memref<2x16x32xf32, 2>
    %568 = adf.buffer.create @L1_L1_B_162() : memref<16x32xf32, 2>
    %569 = adf.buffer.create @L1_L1_C_162() : memref<32x32xf32, 2>
    %570 = adf.buffer.create @L1_L1_A_163() : memref<2x16x32xf32, 2>
    %571 = adf.buffer.create @L1_L1_B_163() : memref<16x32xf32, 2>
    %572 = adf.buffer.create @L1_L1_C_163() : memref<32x32xf32, 2>
    %573 = adf.buffer.create @L1_L1_D_163() : memref<2x32xf32, 2>
    %574 = adf.buffer.create @L1_L1_A_164() : memref<2x16x32xf32, 2>
    %575 = adf.buffer.create @L1_L1_B_164() : memref<16x32xf32, 2>
    %576 = adf.buffer.create @L1_L1_C_164() : memref<32x32xf32, 2>
    %577 = adf.buffer.create @L1_L1_A_165() : memref<2x16x32xf32, 2>
    %578 = adf.buffer.create @L1_L1_B_165() : memref<16x32xf32, 2>
    %579 = adf.buffer.create @L1_L1_C_165() : memref<32x32xf32, 2>
    %580 = adf.buffer.create @L1_L1_D_165() : memref<2x32xf32, 2>
    %581 = adf.buffer.create @L1_L1_A_166() : memref<2x16x32xf32, 2>
    %582 = adf.buffer.create @L1_L1_B_166() : memref<16x32xf32, 2>
    %583 = adf.buffer.create @L1_L1_C_166() : memref<32x32xf32, 2>
    %584 = adf.buffer.create @L1_L1_A_167() : memref<2x16x32xf32, 2>
    %585 = adf.buffer.create @L1_L1_B_167() : memref<16x32xf32, 2>
    %586 = adf.buffer.create @L1_L1_C_167() : memref<32x32xf32, 2>
    %587 = adf.buffer.create @L1_L1_D_167() : memref<2x32xf32, 2>
    %588 = adf.buffer.create @L1_L1_A_168() : memref<2x16x32xf32, 2>
    %589 = adf.buffer.create @L1_L1_B_168() : memref<16x32xf32, 2>
    %590 = adf.buffer.create @L1_L1_C_168() : memref<32x32xf32, 2>
    %591 = adf.buffer.create @L1_L1_A_169() : memref<2x16x32xf32, 2>
    %592 = adf.buffer.create @L1_L1_B_169() : memref<16x32xf32, 2>
    %593 = adf.buffer.create @L1_L1_C_169() : memref<32x32xf32, 2>
    %594 = adf.buffer.create @L1_L1_D_169() : memref<2x32xf32, 2>
    %595 = adf.buffer.create @L1_L1_A_170() : memref<2x16x32xf32, 2>
    %596 = adf.buffer.create @L1_L1_B_170() : memref<16x32xf32, 2>
    %597 = adf.buffer.create @L1_L1_C_170() : memref<32x32xf32, 2>
    %598 = adf.buffer.create @L1_L1_A_171() : memref<2x16x32xf32, 2>
    %599 = adf.buffer.create @L1_L1_B_171() : memref<16x32xf32, 2>
    %600 = adf.buffer.create @L1_L1_C_171() : memref<32x32xf32, 2>
    %601 = adf.buffer.create @L1_L1_D_171() : memref<2x32xf32, 2>
    %602 = adf.buffer.create @L1_L1_A_172() : memref<2x16x32xf32, 2>
    %603 = adf.buffer.create @L1_L1_B_172() : memref<16x32xf32, 2>
    %604 = adf.buffer.create @L1_L1_C_172() : memref<32x32xf32, 2>
    %605 = adf.buffer.create @L1_L1_A_173() : memref<2x16x32xf32, 2>
    %606 = adf.buffer.create @L1_L1_B_173() : memref<16x32xf32, 2>
    %607 = adf.buffer.create @L1_L1_C_173() : memref<32x32xf32, 2>
    %608 = adf.buffer.create @L1_L1_D_173() : memref<2x32xf32, 2>
    %609 = adf.buffer.create @L1_L1_A_174() : memref<2x16x32xf32, 2>
    %610 = adf.buffer.create @L1_L1_B_174() : memref<16x32xf32, 2>
    %611 = adf.buffer.create @L1_L1_C_174() : memref<32x32xf32, 2>
    %612 = adf.buffer.create @L1_L1_A_175() : memref<2x16x32xf32, 2>
    %613 = adf.buffer.create @L1_L1_B_175() : memref<16x32xf32, 2>
    %614 = adf.buffer.create @L1_L1_C_175() : memref<32x32xf32, 2>
    %615 = adf.buffer.create @L1_L1_D_175() : memref<2x32xf32, 2>
    %616 = adf.buffer.create @L1_L1_A_176() : memref<2x16x32xf32, 2>
    %617 = adf.buffer.create @L1_L1_B_176() : memref<16x32xf32, 2>
    %618 = adf.buffer.create @L1_L1_C_176() : memref<32x32xf32, 2>
    %619 = adf.buffer.create @L1_L1_A_177() : memref<2x16x32xf32, 2>
    %620 = adf.buffer.create @L1_L1_B_177() : memref<16x32xf32, 2>
    %621 = adf.buffer.create @L1_L1_C_177() : memref<32x32xf32, 2>
    %622 = adf.buffer.create @L1_L1_D_177() : memref<2x32xf32, 2>
    %623 = adf.buffer.create @L1_L1_A_178() : memref<2x16x32xf32, 2>
    %624 = adf.buffer.create @L1_L1_B_178() : memref<16x32xf32, 2>
    %625 = adf.buffer.create @L1_L1_C_178() : memref<32x32xf32, 2>
    %626 = adf.buffer.create @L1_L1_A_179() : memref<2x16x32xf32, 2>
    %627 = adf.buffer.create @L1_L1_B_179() : memref<16x32xf32, 2>
    %628 = adf.buffer.create @L1_L1_C_179() : memref<32x32xf32, 2>
    %629 = adf.buffer.create @L1_L1_D_179() : memref<2x32xf32, 2>
    %630 = adf.buffer.create @L1_L1_A_180() : memref<2x16x32xf32, 2>
    %631 = adf.buffer.create @L1_L1_B_180() : memref<16x32xf32, 2>
    %632 = adf.buffer.create @L1_L1_C_180() : memref<32x32xf32, 2>
    %633 = adf.buffer.create @L1_L1_A_181() : memref<2x16x32xf32, 2>
    %634 = adf.buffer.create @L1_L1_B_181() : memref<16x32xf32, 2>
    %635 = adf.buffer.create @L1_L1_C_181() : memref<32x32xf32, 2>
    %636 = adf.buffer.create @L1_L1_D_181() : memref<2x32xf32, 2>
    %637 = adf.buffer.create @L1_L1_A_182() : memref<2x16x32xf32, 2>
    %638 = adf.buffer.create @L1_L1_B_182() : memref<16x32xf32, 2>
    %639 = adf.buffer.create @L1_L1_C_182() : memref<32x32xf32, 2>
    %640 = adf.buffer.create @L1_L1_A_183() : memref<2x16x32xf32, 2>
    %641 = adf.buffer.create @L1_L1_B_183() : memref<16x32xf32, 2>
    %642 = adf.buffer.create @L1_L1_C_183() : memref<32x32xf32, 2>
    %643 = adf.buffer.create @L1_L1_D_183() : memref<2x32xf32, 2>
    %644 = adf.buffer.create @L1_L1_A_184() : memref<2x16x32xf32, 2>
    %645 = adf.buffer.create @L1_L1_B_184() : memref<16x32xf32, 2>
    %646 = adf.buffer.create @L1_L1_C_184() : memref<32x32xf32, 2>
    %647 = adf.buffer.create @L1_L1_A_185() : memref<2x16x32xf32, 2>
    %648 = adf.buffer.create @L1_L1_B_185() : memref<16x32xf32, 2>
    %649 = adf.buffer.create @L1_L1_C_185() : memref<32x32xf32, 2>
    %650 = adf.buffer.create @L1_L1_D_185() : memref<2x32xf32, 2>
    %651 = adf.buffer.create @L1_L1_A_186() : memref<2x16x32xf32, 2>
    %652 = adf.buffer.create @L1_L1_B_186() : memref<16x32xf32, 2>
    %653 = adf.buffer.create @L1_L1_C_186() : memref<32x32xf32, 2>
    %654 = adf.buffer.create @L1_L1_A_187() : memref<2x16x32xf32, 2>
    %655 = adf.buffer.create @L1_L1_B_187() : memref<16x32xf32, 2>
    %656 = adf.buffer.create @L1_L1_C_187() : memref<32x32xf32, 2>
    %657 = adf.buffer.create @L1_L1_D_187() : memref<2x32xf32, 2>
    %658 = adf.buffer.create @L1_L1_A_188() : memref<2x16x32xf32, 2>
    %659 = adf.buffer.create @L1_L1_B_188() : memref<16x32xf32, 2>
    %660 = adf.buffer.create @L1_L1_C_188() : memref<32x32xf32, 2>
    %661 = adf.buffer.create @L1_L1_A_189() : memref<2x16x32xf32, 2>
    %662 = adf.buffer.create @L1_L1_B_189() : memref<16x32xf32, 2>
    %663 = adf.buffer.create @L1_L1_C_189() : memref<32x32xf32, 2>
    %664 = adf.buffer.create @L1_L1_D_189() : memref<2x32xf32, 2>
    %665 = adf.buffer.create @L1_L1_A_190() : memref<2x16x32xf32, 2>
    %666 = adf.buffer.create @L1_L1_B_190() : memref<16x32xf32, 2>
    %667 = adf.buffer.create @L1_L1_C_190() : memref<32x32xf32, 2>
    %668 = adf.buffer.create @L1_L1_A_191() : memref<2x16x32xf32, 2>
    %669 = adf.buffer.create @L1_L1_B_191() : memref<16x32xf32, 2>
    %670 = adf.buffer.create @L1_L1_C_191() : memref<32x32xf32, 2>
    %671 = adf.buffer.create @L1_L1_D_191() : memref<2x32xf32, 2>
    adf.connect(%arg0, %0) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %1) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %2) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %672 = call @kernel_mttkrp0(%0, %1, %2) {adf.kernel, "col, row" = [1 : index, 0 : index], ivs = [0 : index, 0 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 0 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%672, %c1, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%1, %c1, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%2, %c1, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%0, %c1, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %3) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %4) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %5) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%672, %6) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %673 = call @kernel_mttkrp(%3, %4, %5, %6) {adf.kernel, "col, row" = [1 : index, 1 : index], ivs = [1 : index, 0 : index, 0 : index], kernel_mttkrp = 1 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%673, %c2, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%4, %c2, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%5, %c2, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%3, %c1, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%673, %arg5) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %7) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %8) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %9) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %674 = call @kernel_mttkrp0(%7, %8, %9) {adf.kernel, "col, row" = [5 : index, 0 : index], ivs = [0 : index, 1 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 2 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%674, %c5, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%8, %c5, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%9, %c5, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%7, %c5, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %10) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %11) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %12) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%674, %13) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %675 = call @kernel_mttkrp(%10, %11, %12, %13) {adf.kernel, "col, row" = [5 : index, 1 : index], ivs = [1 : index, 1 : index, 0 : index], kernel_mttkrp = 3 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%675, %c6, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%11, %c6, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%12, %c6, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%10, %c5, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%675, %arg9) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %14) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %15) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %16) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %676 = call @kernel_mttkrp0(%14, %15, %16) {adf.kernel, "col, row" = [9 : index, 0 : index], ivs = [0 : index, 2 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 4 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%676, %c9, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%15, %c9, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%16, %c9, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%14, %c9, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %17) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %18) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %19) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%676, %20) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %677 = call @kernel_mttkrp(%17, %18, %19, %20) {adf.kernel, "col, row" = [9 : index, 1 : index], ivs = [1 : index, 2 : index, 0 : index], kernel_mttkrp = 5 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%677, %c10, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%18, %c10, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%19, %c10, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%17, %c9, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%677, %arg13) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %21) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %22) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %23) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %678 = call @kernel_mttkrp0(%21, %22, %23) {adf.kernel, "col, row" = [13 : index, 0 : index], ivs = [0 : index, 3 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 6 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%678, %c13, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%22, %c13, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%23, %c13, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%21, %c13, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %24) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %25) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %26) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%678, %27) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %679 = call @kernel_mttkrp(%24, %25, %26, %27) {adf.kernel, "col, row" = [13 : index, 1 : index], ivs = [1 : index, 3 : index, 0 : index], kernel_mttkrp = 7 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%679, %c14, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%25, %c14, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%26, %c14, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%24, %c13, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%679, %arg17) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %28) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %29) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %30) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %680 = call @kernel_mttkrp0(%28, %29, %30) {adf.kernel, "col, row" = [17 : index, 0 : index], ivs = [0 : index, 4 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 8 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%680, %c17, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%29, %c17, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%30, %c17, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%28, %c17, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %31) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %32) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %33) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%680, %34) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %681 = call @kernel_mttkrp(%31, %32, %33, %34) {adf.kernel, "col, row" = [17 : index, 1 : index], ivs = [1 : index, 4 : index, 0 : index], kernel_mttkrp = 9 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%681, %c18, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%32, %c18, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%33, %c18, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%31, %c17, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%681, %arg21) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %35) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %36) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %37) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %682 = call @kernel_mttkrp0(%35, %36, %37) {adf.kernel, "col, row" = [21 : index, 0 : index], ivs = [0 : index, 5 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 10 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%682, %c21, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%36, %c21, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%37, %c21, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%35, %c21, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %38) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %39) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %40) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%682, %41) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %683 = call @kernel_mttkrp(%38, %39, %40, %41) {adf.kernel, "col, row" = [21 : index, 1 : index], ivs = [1 : index, 5 : index, 0 : index], kernel_mttkrp = 11 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%683, %c22, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%39, %c22, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%40, %c22, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%38, %c21, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%683, %arg25) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %42) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %43) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %44) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %684 = call @kernel_mttkrp0(%42, %43, %44) {adf.kernel, "col, row" = [25 : index, 0 : index], ivs = [0 : index, 6 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 12 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%684, %c25, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%43, %c25, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%44, %c25, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%42, %c25, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %45) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %46) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %47) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%684, %48) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %685 = call @kernel_mttkrp(%45, %46, %47, %48) {adf.kernel, "col, row" = [25 : index, 1 : index], ivs = [1 : index, 6 : index, 0 : index], kernel_mttkrp = 13 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%685, %c26, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%46, %c26, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%47, %c26, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%45, %c25, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%685, %arg29) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %49) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %50) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %51) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %686 = call @kernel_mttkrp0(%49, %50, %51) {adf.kernel, "col, row" = [29 : index, 0 : index], ivs = [0 : index, 7 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 14 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%686, %c29, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%50, %c29, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%51, %c29, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%49, %c29, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %52) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %53) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %54) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%686, %55) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %687 = call @kernel_mttkrp(%52, %53, %54, %55) {adf.kernel, "col, row" = [29 : index, 1 : index], ivs = [1 : index, 7 : index, 0 : index], kernel_mttkrp = 15 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%687, %c30, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%53, %c30, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%54, %c30, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%52, %c29, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%687, %arg33) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %56) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %57) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %58) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %688 = call @kernel_mttkrp0(%56, %57, %58) {adf.kernel, "col, row" = [33 : index, 0 : index], ivs = [0 : index, 8 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 16 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%688, %c33, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%57, %c33, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%58, %c33, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%56, %c33, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %59) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %60) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %61) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%688, %62) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %689 = call @kernel_mttkrp(%59, %60, %61, %62) {adf.kernel, "col, row" = [33 : index, 1 : index], ivs = [1 : index, 8 : index, 0 : index], kernel_mttkrp = 17 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%689, %c34, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%60, %c34, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%61, %c34, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%59, %c33, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%689, %arg37) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %63) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %64) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %65) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %690 = call @kernel_mttkrp0(%63, %64, %65) {adf.kernel, "col, row" = [37 : index, 0 : index], ivs = [0 : index, 9 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 18 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%690, %c37, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%64, %c37, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%65, %c37, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%63, %c37, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %66) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %67) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %68) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%690, %69) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %691 = call @kernel_mttkrp(%66, %67, %68, %69) {adf.kernel, "col, row" = [37 : index, 1 : index], ivs = [1 : index, 9 : index, 0 : index], kernel_mttkrp = 19 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%691, %c38, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%67, %c38, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%68, %c38, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%66, %c37, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%691, %arg41) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %70) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %71) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %72) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %692 = call @kernel_mttkrp0(%70, %71, %72) {adf.kernel, "col, row" = [41 : index, 0 : index], ivs = [0 : index, 10 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 20 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%692, %c41, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%71, %c41, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%72, %c41, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%70, %c41, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %73) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %74) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %75) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%692, %76) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %693 = call @kernel_mttkrp(%73, %74, %75, %76) {adf.kernel, "col, row" = [41 : index, 1 : index], ivs = [1 : index, 10 : index, 0 : index], kernel_mttkrp = 21 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%693, %c42, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%74, %c42, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%75, %c42, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%73, %c41, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%693, %arg45) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg0, %77) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %78) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %79) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %694 = call @kernel_mttkrp0(%77, %78, %79) {adf.kernel, "col, row" = [45 : index, 0 : index], ivs = [0 : index, 11 : index, 0 : index], kernel = 0 : index, kernel_mttkrp0 = 22 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%694, %c45, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%78, %c45, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%79, %c45, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%77, %c45, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg3, %80) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %81) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %82) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%694, %83) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %695 = call @kernel_mttkrp(%80, %81, %82, %83) {adf.kernel, "col, row" = [45 : index, 1 : index], ivs = [1 : index, 11 : index, 0 : index], kernel_mttkrp = 23 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%695, %c46, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%81, %c46, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%82, %c46, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%80, %c45, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%695, %arg49) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %84) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %85) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %86) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %696 = call @kernel_mttkrp0(%84, %85, %86) {adf.kernel, "col, row" = [1 : index, 2 : index], ivs = [0 : index, 0 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 24 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%696, %c1, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%85, %c1, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%86, %c1, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%84, %c1, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %87) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %88) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %89) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%696, %90) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %697 = call @kernel_mttkrp(%87, %88, %89, %90) {adf.kernel, "col, row" = [1 : index, 3 : index], ivs = [1 : index, 0 : index, 1 : index], kernel_mttkrp = 25 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%697, %c2, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%88, %c2, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%89, %c2, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%87, %c1, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%697, %arg52) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %91) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %92) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %93) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %698 = call @kernel_mttkrp0(%91, %92, %93) {adf.kernel, "col, row" = [5 : index, 2 : index], ivs = [0 : index, 1 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 26 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%698, %c5, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%92, %c5, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%93, %c5, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%91, %c5, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %94) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %95) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %96) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%698, %97) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %699 = call @kernel_mttkrp(%94, %95, %96, %97) {adf.kernel, "col, row" = [5 : index, 3 : index], ivs = [1 : index, 1 : index, 1 : index], kernel_mttkrp = 27 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%699, %c6, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%95, %c6, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%96, %c6, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%94, %c5, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%699, %arg53) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %98) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %99) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %100) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %700 = call @kernel_mttkrp0(%98, %99, %100) {adf.kernel, "col, row" = [9 : index, 2 : index], ivs = [0 : index, 2 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 28 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%700, %c9, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%99, %c9, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%100, %c9, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%98, %c9, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %101) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %102) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %103) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%700, %104) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %701 = call @kernel_mttkrp(%101, %102, %103, %104) {adf.kernel, "col, row" = [9 : index, 3 : index], ivs = [1 : index, 2 : index, 1 : index], kernel_mttkrp = 29 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%701, %c10, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%102, %c10, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%103, %c10, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%101, %c9, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%701, %arg54) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %105) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %106) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %107) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %702 = call @kernel_mttkrp0(%105, %106, %107) {adf.kernel, "col, row" = [13 : index, 2 : index], ivs = [0 : index, 3 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 30 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%702, %c13, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%106, %c13, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%107, %c13, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%105, %c13, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %108) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %109) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %110) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%702, %111) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %703 = call @kernel_mttkrp(%108, %109, %110, %111) {adf.kernel, "col, row" = [13 : index, 3 : index], ivs = [1 : index, 3 : index, 1 : index], kernel_mttkrp = 31 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%703, %c14, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%109, %c14, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%110, %c14, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%108, %c13, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%703, %arg55) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %112) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %113) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %114) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %704 = call @kernel_mttkrp0(%112, %113, %114) {adf.kernel, "col, row" = [17 : index, 2 : index], ivs = [0 : index, 4 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 32 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%704, %c17, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%113, %c17, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%114, %c17, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%112, %c17, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %115) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %116) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %117) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%704, %118) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %705 = call @kernel_mttkrp(%115, %116, %117, %118) {adf.kernel, "col, row" = [17 : index, 3 : index], ivs = [1 : index, 4 : index, 1 : index], kernel_mttkrp = 33 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%705, %c18, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%116, %c18, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%117, %c18, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%115, %c17, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%705, %arg56) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %119) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %120) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %121) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %706 = call @kernel_mttkrp0(%119, %120, %121) {adf.kernel, "col, row" = [21 : index, 2 : index], ivs = [0 : index, 5 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 34 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%706, %c21, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%120, %c21, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%121, %c21, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%119, %c21, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %122) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %123) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %124) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%706, %125) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %707 = call @kernel_mttkrp(%122, %123, %124, %125) {adf.kernel, "col, row" = [21 : index, 3 : index], ivs = [1 : index, 5 : index, 1 : index], kernel_mttkrp = 35 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%707, %c22, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%123, %c22, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%124, %c22, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%122, %c21, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%707, %arg57) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %126) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %127) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %128) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %708 = call @kernel_mttkrp0(%126, %127, %128) {adf.kernel, "col, row" = [25 : index, 2 : index], ivs = [0 : index, 6 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 36 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%708, %c25, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%127, %c25, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%128, %c25, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%126, %c25, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %129) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %130) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %131) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%708, %132) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %709 = call @kernel_mttkrp(%129, %130, %131, %132) {adf.kernel, "col, row" = [25 : index, 3 : index], ivs = [1 : index, 6 : index, 1 : index], kernel_mttkrp = 37 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%709, %c26, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%130, %c26, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%131, %c26, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%129, %c25, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%709, %arg58) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %133) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %134) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %135) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %710 = call @kernel_mttkrp0(%133, %134, %135) {adf.kernel, "col, row" = [29 : index, 2 : index], ivs = [0 : index, 7 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 38 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%710, %c29, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%134, %c29, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%135, %c29, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%133, %c29, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %136) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %137) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %138) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%710, %139) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %711 = call @kernel_mttkrp(%136, %137, %138, %139) {adf.kernel, "col, row" = [29 : index, 3 : index], ivs = [1 : index, 7 : index, 1 : index], kernel_mttkrp = 39 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%711, %c30, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%137, %c30, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%138, %c30, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%136, %c29, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%711, %arg59) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %140) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %141) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %142) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %712 = call @kernel_mttkrp0(%140, %141, %142) {adf.kernel, "col, row" = [33 : index, 2 : index], ivs = [0 : index, 8 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 40 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%712, %c33, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%141, %c33, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%142, %c33, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%140, %c33, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %143) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %144) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %145) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%712, %146) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %713 = call @kernel_mttkrp(%143, %144, %145, %146) {adf.kernel, "col, row" = [33 : index, 3 : index], ivs = [1 : index, 8 : index, 1 : index], kernel_mttkrp = 41 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%713, %c34, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%144, %c34, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%145, %c34, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%143, %c33, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%713, %arg60) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %147) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %148) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %149) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %714 = call @kernel_mttkrp0(%147, %148, %149) {adf.kernel, "col, row" = [37 : index, 2 : index], ivs = [0 : index, 9 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 42 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%714, %c37, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%148, %c37, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%149, %c37, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%147, %c37, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %150) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %151) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %152) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%714, %153) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %715 = call @kernel_mttkrp(%150, %151, %152, %153) {adf.kernel, "col, row" = [37 : index, 3 : index], ivs = [1 : index, 9 : index, 1 : index], kernel_mttkrp = 43 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%715, %c38, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%151, %c38, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%152, %c38, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%150, %c37, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%715, %arg61) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %154) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %155) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %156) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %716 = call @kernel_mttkrp0(%154, %155, %156) {adf.kernel, "col, row" = [41 : index, 2 : index], ivs = [0 : index, 10 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 44 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%716, %c41, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%155, %c41, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%156, %c41, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%154, %c41, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %157) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %158) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %159) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%716, %160) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %717 = call @kernel_mttkrp(%157, %158, %159, %160) {adf.kernel, "col, row" = [41 : index, 3 : index], ivs = [1 : index, 10 : index, 1 : index], kernel_mttkrp = 45 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%717, %c42, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%158, %c42, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%159, %c42, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%157, %c41, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%717, %arg62) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg50, %161) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %162) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %163) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %718 = call @kernel_mttkrp0(%161, %162, %163) {adf.kernel, "col, row" = [45 : index, 2 : index], ivs = [0 : index, 11 : index, 1 : index], kernel = 0 : index, kernel_mttkrp0 = 46 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%718, %c45, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%162, %c45, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%163, %c45, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%161, %c45, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg51, %164) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %165) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %166) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%718, %167) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %719 = call @kernel_mttkrp(%164, %165, %166, %167) {adf.kernel, "col, row" = [45 : index, 3 : index], ivs = [1 : index, 11 : index, 1 : index], kernel_mttkrp = 47 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%719, %c46, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%165, %c46, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%166, %c46, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%164, %c45, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%719, %arg63) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %168) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %169) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %170) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %720 = call @kernel_mttkrp0(%168, %169, %170) {adf.kernel, "col, row" = [1 : index, 4 : index], ivs = [0 : index, 0 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 48 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%720, %c1, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%169, %c1, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%170, %c1, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%168, %c1, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %171) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %172) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %173) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%720, %174) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %721 = call @kernel_mttkrp(%171, %172, %173, %174) {adf.kernel, "col, row" = [1 : index, 5 : index], ivs = [1 : index, 0 : index, 2 : index], kernel_mttkrp = 49 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%721, %c2, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%172, %c2, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%173, %c2, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%171, %c1, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%721, %arg66) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %175) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %176) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %177) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %722 = call @kernel_mttkrp0(%175, %176, %177) {adf.kernel, "col, row" = [5 : index, 4 : index], ivs = [0 : index, 1 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 50 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%722, %c5, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%176, %c5, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%177, %c5, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%175, %c5, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %178) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %179) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %180) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%722, %181) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %723 = call @kernel_mttkrp(%178, %179, %180, %181) {adf.kernel, "col, row" = [5 : index, 5 : index], ivs = [1 : index, 1 : index, 2 : index], kernel_mttkrp = 51 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%723, %c6, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%179, %c6, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%180, %c6, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%178, %c5, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%723, %arg67) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %182) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %183) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %184) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %724 = call @kernel_mttkrp0(%182, %183, %184) {adf.kernel, "col, row" = [9 : index, 4 : index], ivs = [0 : index, 2 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 52 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%724, %c9, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%183, %c9, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%184, %c9, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%182, %c9, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %185) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %186) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %187) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%724, %188) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %725 = call @kernel_mttkrp(%185, %186, %187, %188) {adf.kernel, "col, row" = [9 : index, 5 : index], ivs = [1 : index, 2 : index, 2 : index], kernel_mttkrp = 53 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%725, %c10, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%186, %c10, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%187, %c10, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%185, %c9, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%725, %arg68) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %189) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %190) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %191) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %726 = call @kernel_mttkrp0(%189, %190, %191) {adf.kernel, "col, row" = [13 : index, 4 : index], ivs = [0 : index, 3 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 54 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%726, %c13, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%190, %c13, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%191, %c13, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%189, %c13, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %192) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %193) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %194) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%726, %195) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %727 = call @kernel_mttkrp(%192, %193, %194, %195) {adf.kernel, "col, row" = [13 : index, 5 : index], ivs = [1 : index, 3 : index, 2 : index], kernel_mttkrp = 55 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%727, %c14, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%193, %c14, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%194, %c14, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%192, %c13, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%727, %arg69) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %196) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %197) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %198) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %728 = call @kernel_mttkrp0(%196, %197, %198) {adf.kernel, "col, row" = [17 : index, 4 : index], ivs = [0 : index, 4 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 56 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%728, %c17, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%197, %c17, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%198, %c17, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%196, %c17, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %199) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %200) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %201) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%728, %202) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %729 = call @kernel_mttkrp(%199, %200, %201, %202) {adf.kernel, "col, row" = [17 : index, 5 : index], ivs = [1 : index, 4 : index, 2 : index], kernel_mttkrp = 57 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%729, %c18, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%200, %c18, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%201, %c18, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%199, %c17, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%729, %arg70) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %203) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %204) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %205) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %730 = call @kernel_mttkrp0(%203, %204, %205) {adf.kernel, "col, row" = [21 : index, 4 : index], ivs = [0 : index, 5 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 58 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%730, %c21, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%204, %c21, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%205, %c21, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%203, %c21, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %206) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %207) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %208) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%730, %209) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %731 = call @kernel_mttkrp(%206, %207, %208, %209) {adf.kernel, "col, row" = [21 : index, 5 : index], ivs = [1 : index, 5 : index, 2 : index], kernel_mttkrp = 59 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%731, %c22, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%207, %c22, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%208, %c22, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%206, %c21, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%731, %arg71) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %210) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %211) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %212) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %732 = call @kernel_mttkrp0(%210, %211, %212) {adf.kernel, "col, row" = [25 : index, 4 : index], ivs = [0 : index, 6 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 60 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%732, %c25, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%211, %c25, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%212, %c25, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%210, %c25, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %213) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %214) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %215) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%732, %216) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %733 = call @kernel_mttkrp(%213, %214, %215, %216) {adf.kernel, "col, row" = [25 : index, 5 : index], ivs = [1 : index, 6 : index, 2 : index], kernel_mttkrp = 61 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%733, %c26, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%214, %c26, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%215, %c26, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%213, %c25, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%733, %arg72) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %217) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %218) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %219) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %734 = call @kernel_mttkrp0(%217, %218, %219) {adf.kernel, "col, row" = [29 : index, 4 : index], ivs = [0 : index, 7 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 62 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%734, %c29, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%218, %c29, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%219, %c29, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%217, %c29, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %220) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %221) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %222) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%734, %223) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %735 = call @kernel_mttkrp(%220, %221, %222, %223) {adf.kernel, "col, row" = [29 : index, 5 : index], ivs = [1 : index, 7 : index, 2 : index], kernel_mttkrp = 63 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%735, %c30, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%221, %c30, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%222, %c30, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%220, %c29, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%735, %arg73) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %224) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %225) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %226) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %736 = call @kernel_mttkrp0(%224, %225, %226) {adf.kernel, "col, row" = [33 : index, 4 : index], ivs = [0 : index, 8 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 64 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%736, %c33, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%225, %c33, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%226, %c33, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%224, %c33, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %227) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %228) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %229) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%736, %230) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %737 = call @kernel_mttkrp(%227, %228, %229, %230) {adf.kernel, "col, row" = [33 : index, 5 : index], ivs = [1 : index, 8 : index, 2 : index], kernel_mttkrp = 65 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%737, %c34, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%228, %c34, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%229, %c34, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%227, %c33, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%737, %arg74) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %231) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %232) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %233) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %738 = call @kernel_mttkrp0(%231, %232, %233) {adf.kernel, "col, row" = [37 : index, 4 : index], ivs = [0 : index, 9 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 66 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%738, %c37, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%232, %c37, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%233, %c37, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%231, %c37, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %234) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %235) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %236) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%738, %237) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %739 = call @kernel_mttkrp(%234, %235, %236, %237) {adf.kernel, "col, row" = [37 : index, 5 : index], ivs = [1 : index, 9 : index, 2 : index], kernel_mttkrp = 67 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%739, %c38, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%235, %c38, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%236, %c38, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%234, %c37, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%739, %arg75) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %238) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %239) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %240) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %740 = call @kernel_mttkrp0(%238, %239, %240) {adf.kernel, "col, row" = [41 : index, 4 : index], ivs = [0 : index, 10 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 68 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%740, %c41, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%239, %c41, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%240, %c41, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%238, %c41, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %241) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %242) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %243) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%740, %244) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %741 = call @kernel_mttkrp(%241, %242, %243, %244) {adf.kernel, "col, row" = [41 : index, 5 : index], ivs = [1 : index, 10 : index, 2 : index], kernel_mttkrp = 69 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%741, %c42, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%242, %c42, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%243, %c42, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%241, %c41, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%741, %arg76) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg64, %245) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %246) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %247) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %742 = call @kernel_mttkrp0(%245, %246, %247) {adf.kernel, "col, row" = [45 : index, 4 : index], ivs = [0 : index, 11 : index, 2 : index], kernel = 0 : index, kernel_mttkrp0 = 70 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%742, %c45, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%246, %c45, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%247, %c45, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%245, %c45, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg65, %248) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %249) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %250) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%742, %251) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %743 = call @kernel_mttkrp(%248, %249, %250, %251) {adf.kernel, "col, row" = [45 : index, 5 : index], ivs = [1 : index, 11 : index, 2 : index], kernel_mttkrp = 71 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%743, %c46, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%249, %c46, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%250, %c46, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%248, %c45, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%743, %arg77) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %252) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %253) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %254) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %744 = call @kernel_mttkrp0(%252, %253, %254) {adf.kernel, "col, row" = [1 : index, 6 : index], ivs = [0 : index, 0 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 72 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%744, %c1, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%253, %c1, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%254, %c1, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%252, %c1, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %255) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %256) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %257) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%744, %258) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %745 = call @kernel_mttkrp(%255, %256, %257, %258) {adf.kernel, "col, row" = [1 : index, 7 : index], ivs = [1 : index, 0 : index, 3 : index], kernel_mttkrp = 73 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%745, %c2, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%256, %c2, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%257, %c2, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%255, %c1, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%745, %arg80) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %259) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %260) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %261) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %746 = call @kernel_mttkrp0(%259, %260, %261) {adf.kernel, "col, row" = [5 : index, 6 : index], ivs = [0 : index, 1 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 74 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%746, %c5, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%260, %c5, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%261, %c5, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%259, %c5, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %262) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %263) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %264) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%746, %265) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %747 = call @kernel_mttkrp(%262, %263, %264, %265) {adf.kernel, "col, row" = [5 : index, 7 : index], ivs = [1 : index, 1 : index, 3 : index], kernel_mttkrp = 75 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%747, %c6, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%263, %c6, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%264, %c6, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%262, %c5, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%747, %arg81) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %266) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %267) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %268) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %748 = call @kernel_mttkrp0(%266, %267, %268) {adf.kernel, "col, row" = [9 : index, 6 : index], ivs = [0 : index, 2 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 76 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%748, %c9, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%267, %c9, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%268, %c9, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%266, %c9, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %269) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %270) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %271) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%748, %272) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %749 = call @kernel_mttkrp(%269, %270, %271, %272) {adf.kernel, "col, row" = [9 : index, 7 : index], ivs = [1 : index, 2 : index, 3 : index], kernel_mttkrp = 77 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%749, %c10, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%270, %c10, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%271, %c10, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%269, %c9, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%749, %arg82) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %273) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %274) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %275) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %750 = call @kernel_mttkrp0(%273, %274, %275) {adf.kernel, "col, row" = [13 : index, 6 : index], ivs = [0 : index, 3 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 78 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%750, %c13, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%274, %c13, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%275, %c13, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%273, %c13, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %276) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %277) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %278) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%750, %279) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %751 = call @kernel_mttkrp(%276, %277, %278, %279) {adf.kernel, "col, row" = [13 : index, 7 : index], ivs = [1 : index, 3 : index, 3 : index], kernel_mttkrp = 79 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%751, %c14, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%277, %c14, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%278, %c14, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%276, %c13, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%751, %arg83) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %280) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %281) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %282) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %752 = call @kernel_mttkrp0(%280, %281, %282) {adf.kernel, "col, row" = [17 : index, 6 : index], ivs = [0 : index, 4 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 80 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%752, %c17, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%281, %c17, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%282, %c17, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%280, %c17, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %283) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %284) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %285) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%752, %286) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %753 = call @kernel_mttkrp(%283, %284, %285, %286) {adf.kernel, "col, row" = [17 : index, 7 : index], ivs = [1 : index, 4 : index, 3 : index], kernel_mttkrp = 81 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%753, %c18, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%284, %c18, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%285, %c18, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%283, %c17, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%753, %arg84) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %287) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %288) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %289) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %754 = call @kernel_mttkrp0(%287, %288, %289) {adf.kernel, "col, row" = [21 : index, 6 : index], ivs = [0 : index, 5 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 82 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%754, %c21, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%288, %c21, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%289, %c21, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%287, %c21, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %290) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %291) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %292) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%754, %293) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %755 = call @kernel_mttkrp(%290, %291, %292, %293) {adf.kernel, "col, row" = [21 : index, 7 : index], ivs = [1 : index, 5 : index, 3 : index], kernel_mttkrp = 83 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%755, %c22, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%291, %c22, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%292, %c22, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%290, %c21, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%755, %arg85) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %294) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %295) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %296) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %756 = call @kernel_mttkrp0(%294, %295, %296) {adf.kernel, "col, row" = [25 : index, 6 : index], ivs = [0 : index, 6 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 84 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%756, %c25, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%295, %c25, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%296, %c25, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%294, %c25, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %297) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %298) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %299) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%756, %300) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %757 = call @kernel_mttkrp(%297, %298, %299, %300) {adf.kernel, "col, row" = [25 : index, 7 : index], ivs = [1 : index, 6 : index, 3 : index], kernel_mttkrp = 85 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%757, %c26, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%298, %c26, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%299, %c26, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%297, %c25, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%757, %arg86) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %301) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %302) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %303) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %758 = call @kernel_mttkrp0(%301, %302, %303) {adf.kernel, "col, row" = [29 : index, 6 : index], ivs = [0 : index, 7 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 86 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%758, %c29, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%302, %c29, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%303, %c29, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%301, %c29, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %304) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %305) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %306) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%758, %307) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %759 = call @kernel_mttkrp(%304, %305, %306, %307) {adf.kernel, "col, row" = [29 : index, 7 : index], ivs = [1 : index, 7 : index, 3 : index], kernel_mttkrp = 87 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%759, %c30, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%305, %c30, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%306, %c30, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%304, %c29, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%759, %arg87) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %308) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %309) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %310) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %760 = call @kernel_mttkrp0(%308, %309, %310) {adf.kernel, "col, row" = [33 : index, 6 : index], ivs = [0 : index, 8 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 88 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%760, %c33, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%309, %c33, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%310, %c33, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%308, %c33, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %311) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %312) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %313) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%760, %314) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %761 = call @kernel_mttkrp(%311, %312, %313, %314) {adf.kernel, "col, row" = [33 : index, 7 : index], ivs = [1 : index, 8 : index, 3 : index], kernel_mttkrp = 89 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%761, %c34, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%312, %c34, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%313, %c34, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%311, %c33, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%761, %arg88) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %315) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %316) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %317) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %762 = call @kernel_mttkrp0(%315, %316, %317) {adf.kernel, "col, row" = [37 : index, 6 : index], ivs = [0 : index, 9 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 90 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%762, %c37, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%316, %c37, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%317, %c37, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%315, %c37, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %318) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %319) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %320) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%762, %321) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %763 = call @kernel_mttkrp(%318, %319, %320, %321) {adf.kernel, "col, row" = [37 : index, 7 : index], ivs = [1 : index, 9 : index, 3 : index], kernel_mttkrp = 91 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%763, %c38, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%319, %c38, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%320, %c38, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%318, %c37, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%763, %arg89) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %322) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %323) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %324) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %764 = call @kernel_mttkrp0(%322, %323, %324) {adf.kernel, "col, row" = [41 : index, 6 : index], ivs = [0 : index, 10 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 92 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%764, %c41, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%323, %c41, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%324, %c41, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%322, %c41, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %325) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %326) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %327) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%764, %328) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %765 = call @kernel_mttkrp(%325, %326, %327, %328) {adf.kernel, "col, row" = [41 : index, 7 : index], ivs = [1 : index, 10 : index, 3 : index], kernel_mttkrp = 93 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%765, %c42, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%326, %c42, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%327, %c42, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%325, %c41, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%765, %arg90) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg78, %329) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %330) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %331) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %766 = call @kernel_mttkrp0(%329, %330, %331) {adf.kernel, "col, row" = [45 : index, 6 : index], ivs = [0 : index, 11 : index, 3 : index], kernel = 0 : index, kernel_mttkrp0 = 94 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%766, %c45, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%330, %c45, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%331, %c45, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%329, %c45, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg79, %332) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %333) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %334) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%766, %335) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %767 = call @kernel_mttkrp(%332, %333, %334, %335) {adf.kernel, "col, row" = [45 : index, 7 : index], ivs = [1 : index, 11 : index, 3 : index], kernel_mttkrp = 95 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%767, %c46, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%333, %c46, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%334, %c46, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%332, %c45, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%767, %arg91) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %336) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %337) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %338) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %768 = call @kernel_mttkrp0(%336, %337, %338) {adf.kernel, "col, row" = [3 : index, 0 : index], ivs = [0 : index, 0 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 96 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%768, %c3, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%337, %c3, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%338, %c3, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%336, %c3, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %339) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %340) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %341) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%768, %342) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %769 = call @kernel_mttkrp(%339, %340, %341, %342) {adf.kernel, "col, row" = [3 : index, 1 : index], ivs = [1 : index, 0 : index, 4 : index], kernel_mttkrp = 97 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%769, %c4, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%340, %c4, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%341, %c4, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%339, %c3, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%769, %arg94) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %343) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %344) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %345) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %770 = call @kernel_mttkrp0(%343, %344, %345) {adf.kernel, "col, row" = [7 : index, 0 : index], ivs = [0 : index, 1 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 98 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%770, %c7, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%344, %c7, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%345, %c7, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%343, %c7, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %346) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %347) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %348) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%770, %349) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %771 = call @kernel_mttkrp(%346, %347, %348, %349) {adf.kernel, "col, row" = [7 : index, 1 : index], ivs = [1 : index, 1 : index, 4 : index], kernel_mttkrp = 99 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%771, %c8, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%347, %c8, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%348, %c8, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%346, %c7, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%771, %arg95) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %350) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %351) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %352) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %772 = call @kernel_mttkrp0(%350, %351, %352) {adf.kernel, "col, row" = [11 : index, 0 : index], ivs = [0 : index, 2 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 100 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%772, %c11, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%351, %c11, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%352, %c11, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%350, %c11, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %353) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %354) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %355) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%772, %356) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %773 = call @kernel_mttkrp(%353, %354, %355, %356) {adf.kernel, "col, row" = [11 : index, 1 : index], ivs = [1 : index, 2 : index, 4 : index], kernel_mttkrp = 101 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%773, %c12, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%354, %c12, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%355, %c12, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%353, %c11, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%773, %arg96) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %357) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %358) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %359) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %774 = call @kernel_mttkrp0(%357, %358, %359) {adf.kernel, "col, row" = [15 : index, 0 : index], ivs = [0 : index, 3 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 102 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%774, %c15, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%358, %c15, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%359, %c15, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%357, %c15, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %360) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %361) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %362) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%774, %363) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %775 = call @kernel_mttkrp(%360, %361, %362, %363) {adf.kernel, "col, row" = [15 : index, 1 : index], ivs = [1 : index, 3 : index, 4 : index], kernel_mttkrp = 103 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%775, %c16, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%361, %c16, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%362, %c16, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%360, %c15, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%775, %arg97) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %364) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %365) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %366) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %776 = call @kernel_mttkrp0(%364, %365, %366) {adf.kernel, "col, row" = [19 : index, 0 : index], ivs = [0 : index, 4 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 104 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%776, %c19, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%365, %c19, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%366, %c19, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%364, %c19, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %367) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %368) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %369) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%776, %370) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %777 = call @kernel_mttkrp(%367, %368, %369, %370) {adf.kernel, "col, row" = [19 : index, 1 : index], ivs = [1 : index, 4 : index, 4 : index], kernel_mttkrp = 105 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%777, %c20, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%368, %c20, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%369, %c20, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%367, %c19, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%777, %arg98) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %371) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %372) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %373) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %778 = call @kernel_mttkrp0(%371, %372, %373) {adf.kernel, "col, row" = [23 : index, 0 : index], ivs = [0 : index, 5 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 106 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%778, %c23, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%372, %c23, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%373, %c23, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%371, %c23, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %374) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %375) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %376) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%778, %377) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %779 = call @kernel_mttkrp(%374, %375, %376, %377) {adf.kernel, "col, row" = [23 : index, 1 : index], ivs = [1 : index, 5 : index, 4 : index], kernel_mttkrp = 107 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%779, %c24, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%375, %c24, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%376, %c24, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%374, %c23, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%779, %arg99) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %378) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %379) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %380) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %780 = call @kernel_mttkrp0(%378, %379, %380) {adf.kernel, "col, row" = [27 : index, 0 : index], ivs = [0 : index, 6 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 108 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%780, %c27, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%379, %c27, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%380, %c27, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%378, %c27, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %381) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %382) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %383) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%780, %384) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %781 = call @kernel_mttkrp(%381, %382, %383, %384) {adf.kernel, "col, row" = [27 : index, 1 : index], ivs = [1 : index, 6 : index, 4 : index], kernel_mttkrp = 109 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%781, %c28, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%382, %c28, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%383, %c28, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%381, %c27, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%781, %arg100) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %385) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %386) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %387) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %782 = call @kernel_mttkrp0(%385, %386, %387) {adf.kernel, "col, row" = [31 : index, 0 : index], ivs = [0 : index, 7 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 110 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%782, %c31, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%386, %c31, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%387, %c31, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%385, %c31, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %388) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %389) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %390) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%782, %391) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %783 = call @kernel_mttkrp(%388, %389, %390, %391) {adf.kernel, "col, row" = [31 : index, 1 : index], ivs = [1 : index, 7 : index, 4 : index], kernel_mttkrp = 111 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%783, %c32, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%389, %c32, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%390, %c32, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%388, %c31, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%783, %arg101) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %392) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %393) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %394) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %784 = call @kernel_mttkrp0(%392, %393, %394) {adf.kernel, "col, row" = [35 : index, 0 : index], ivs = [0 : index, 8 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 112 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%784, %c35, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%393, %c35, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%394, %c35, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%392, %c35, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %395) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %396) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %397) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%784, %398) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %785 = call @kernel_mttkrp(%395, %396, %397, %398) {adf.kernel, "col, row" = [35 : index, 1 : index], ivs = [1 : index, 8 : index, 4 : index], kernel_mttkrp = 113 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%785, %c36, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%396, %c36, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%397, %c36, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%395, %c35, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%785, %arg102) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %399) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %400) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %401) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %786 = call @kernel_mttkrp0(%399, %400, %401) {adf.kernel, "col, row" = [39 : index, 0 : index], ivs = [0 : index, 9 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 114 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%786, %c39, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%400, %c39, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%401, %c39, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%399, %c39, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %402) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %403) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %404) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%786, %405) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %787 = call @kernel_mttkrp(%402, %403, %404, %405) {adf.kernel, "col, row" = [39 : index, 1 : index], ivs = [1 : index, 9 : index, 4 : index], kernel_mttkrp = 115 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%787, %c40, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%403, %c40, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%404, %c40, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%402, %c39, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%787, %arg103) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %406) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %407) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %408) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %788 = call @kernel_mttkrp0(%406, %407, %408) {adf.kernel, "col, row" = [43 : index, 0 : index], ivs = [0 : index, 10 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 116 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%788, %c43, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%407, %c43, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%408, %c43, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%406, %c43, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %409) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %410) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %411) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%788, %412) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %789 = call @kernel_mttkrp(%409, %410, %411, %412) {adf.kernel, "col, row" = [43 : index, 1 : index], ivs = [1 : index, 10 : index, 4 : index], kernel_mttkrp = 117 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%789, %c44, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%410, %c44, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%411, %c44, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%409, %c43, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%789, %arg104) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg92, %413) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %414) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %415) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %790 = call @kernel_mttkrp0(%413, %414, %415) {adf.kernel, "col, row" = [47 : index, 0 : index], ivs = [0 : index, 11 : index, 4 : index], kernel = 0 : index, kernel_mttkrp0 = 118 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%790, %c47, %c0, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%414, %c47, %c0, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%415, %c47, %c1, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%413, %c47, %c1, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg93, %416) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %417) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %418) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%790, %419) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %791 = call @kernel_mttkrp(%416, %417, %418, %419) {adf.kernel, "col, row" = [47 : index, 1 : index], ivs = [1 : index, 11 : index, 4 : index], kernel_mttkrp = 119 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%791, %c48, %c1, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%417, %c48, %c1, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%418, %c48, %c1, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%416, %c47, %c0, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%791, %arg105) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %420) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %421) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %422) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %792 = call @kernel_mttkrp0(%420, %421, %422) {adf.kernel, "col, row" = [3 : index, 2 : index], ivs = [0 : index, 0 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 120 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%792, %c3, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%421, %c3, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%422, %c3, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%420, %c3, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %423) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %424) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %425) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%792, %426) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %793 = call @kernel_mttkrp(%423, %424, %425, %426) {adf.kernel, "col, row" = [3 : index, 3 : index], ivs = [1 : index, 0 : index, 5 : index], kernel_mttkrp = 121 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%793, %c4, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%424, %c4, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%425, %c4, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%423, %c3, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%793, %arg108) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %427) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %428) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %429) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %794 = call @kernel_mttkrp0(%427, %428, %429) {adf.kernel, "col, row" = [7 : index, 2 : index], ivs = [0 : index, 1 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 122 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%794, %c7, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%428, %c7, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%429, %c7, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%427, %c7, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %430) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %431) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %432) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%794, %433) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %795 = call @kernel_mttkrp(%430, %431, %432, %433) {adf.kernel, "col, row" = [7 : index, 3 : index], ivs = [1 : index, 1 : index, 5 : index], kernel_mttkrp = 123 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%795, %c8, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%431, %c8, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%432, %c8, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%430, %c7, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%795, %arg109) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %434) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %435) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %436) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %796 = call @kernel_mttkrp0(%434, %435, %436) {adf.kernel, "col, row" = [11 : index, 2 : index], ivs = [0 : index, 2 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 124 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%796, %c11, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%435, %c11, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%436, %c11, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%434, %c11, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %437) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %438) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %439) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%796, %440) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %797 = call @kernel_mttkrp(%437, %438, %439, %440) {adf.kernel, "col, row" = [11 : index, 3 : index], ivs = [1 : index, 2 : index, 5 : index], kernel_mttkrp = 125 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%797, %c12, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%438, %c12, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%439, %c12, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%437, %c11, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%797, %arg110) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %441) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %442) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %443) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %798 = call @kernel_mttkrp0(%441, %442, %443) {adf.kernel, "col, row" = [15 : index, 2 : index], ivs = [0 : index, 3 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 126 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%798, %c15, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%442, %c15, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%443, %c15, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%441, %c15, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %444) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %445) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %446) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%798, %447) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %799 = call @kernel_mttkrp(%444, %445, %446, %447) {adf.kernel, "col, row" = [15 : index, 3 : index], ivs = [1 : index, 3 : index, 5 : index], kernel_mttkrp = 127 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%799, %c16, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%445, %c16, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%446, %c16, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%444, %c15, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%799, %arg111) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %448) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %449) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %450) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %800 = call @kernel_mttkrp0(%448, %449, %450) {adf.kernel, "col, row" = [19 : index, 2 : index], ivs = [0 : index, 4 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 128 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%800, %c19, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%449, %c19, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%450, %c19, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%448, %c19, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %451) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %452) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %453) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%800, %454) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %801 = call @kernel_mttkrp(%451, %452, %453, %454) {adf.kernel, "col, row" = [19 : index, 3 : index], ivs = [1 : index, 4 : index, 5 : index], kernel_mttkrp = 129 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%801, %c20, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%452, %c20, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%453, %c20, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%451, %c19, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%801, %arg112) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %455) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %456) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %457) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %802 = call @kernel_mttkrp0(%455, %456, %457) {adf.kernel, "col, row" = [23 : index, 2 : index], ivs = [0 : index, 5 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 130 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%802, %c23, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%456, %c23, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%457, %c23, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%455, %c23, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %458) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %459) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %460) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%802, %461) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %803 = call @kernel_mttkrp(%458, %459, %460, %461) {adf.kernel, "col, row" = [23 : index, 3 : index], ivs = [1 : index, 5 : index, 5 : index], kernel_mttkrp = 131 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%803, %c24, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%459, %c24, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%460, %c24, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%458, %c23, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%803, %arg113) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %462) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %463) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %464) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %804 = call @kernel_mttkrp0(%462, %463, %464) {adf.kernel, "col, row" = [27 : index, 2 : index], ivs = [0 : index, 6 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 132 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%804, %c27, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%463, %c27, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%464, %c27, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%462, %c27, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %465) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %466) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %467) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%804, %468) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %805 = call @kernel_mttkrp(%465, %466, %467, %468) {adf.kernel, "col, row" = [27 : index, 3 : index], ivs = [1 : index, 6 : index, 5 : index], kernel_mttkrp = 133 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%805, %c28, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%466, %c28, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%467, %c28, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%465, %c27, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%805, %arg114) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %469) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %470) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %471) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %806 = call @kernel_mttkrp0(%469, %470, %471) {adf.kernel, "col, row" = [31 : index, 2 : index], ivs = [0 : index, 7 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 134 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%806, %c31, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%470, %c31, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%471, %c31, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%469, %c31, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %472) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %473) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %474) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%806, %475) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %807 = call @kernel_mttkrp(%472, %473, %474, %475) {adf.kernel, "col, row" = [31 : index, 3 : index], ivs = [1 : index, 7 : index, 5 : index], kernel_mttkrp = 135 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%807, %c32, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%473, %c32, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%474, %c32, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%472, %c31, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%807, %arg115) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %476) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %477) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %478) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %808 = call @kernel_mttkrp0(%476, %477, %478) {adf.kernel, "col, row" = [35 : index, 2 : index], ivs = [0 : index, 8 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 136 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%808, %c35, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%477, %c35, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%478, %c35, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%476, %c35, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %479) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %480) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %481) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%808, %482) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %809 = call @kernel_mttkrp(%479, %480, %481, %482) {adf.kernel, "col, row" = [35 : index, 3 : index], ivs = [1 : index, 8 : index, 5 : index], kernel_mttkrp = 137 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%809, %c36, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%480, %c36, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%481, %c36, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%479, %c35, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%809, %arg116) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %483) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %484) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %485) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %810 = call @kernel_mttkrp0(%483, %484, %485) {adf.kernel, "col, row" = [39 : index, 2 : index], ivs = [0 : index, 9 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 138 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%810, %c39, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%484, %c39, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%485, %c39, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%483, %c39, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %486) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %487) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %488) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%810, %489) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %811 = call @kernel_mttkrp(%486, %487, %488, %489) {adf.kernel, "col, row" = [39 : index, 3 : index], ivs = [1 : index, 9 : index, 5 : index], kernel_mttkrp = 139 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%811, %c40, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%487, %c40, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%488, %c40, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%486, %c39, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%811, %arg117) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %490) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %491) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %492) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %812 = call @kernel_mttkrp0(%490, %491, %492) {adf.kernel, "col, row" = [43 : index, 2 : index], ivs = [0 : index, 10 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 140 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%812, %c43, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%491, %c43, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%492, %c43, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%490, %c43, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %493) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %494) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %495) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%812, %496) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %813 = call @kernel_mttkrp(%493, %494, %495, %496) {adf.kernel, "col, row" = [43 : index, 3 : index], ivs = [1 : index, 10 : index, 5 : index], kernel_mttkrp = 141 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%813, %c44, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%494, %c44, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%495, %c44, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%493, %c43, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%813, %arg118) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg106, %497) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %498) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %499) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %814 = call @kernel_mttkrp0(%497, %498, %499) {adf.kernel, "col, row" = [47 : index, 2 : index], ivs = [0 : index, 11 : index, 5 : index], kernel = 0 : index, kernel_mttkrp0 = 142 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%814, %c47, %c2, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%498, %c47, %c2, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%499, %c47, %c3, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%497, %c47, %c3, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg107, %500) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %501) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %502) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%814, %503) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %815 = call @kernel_mttkrp(%500, %501, %502, %503) {adf.kernel, "col, row" = [47 : index, 3 : index], ivs = [1 : index, 11 : index, 5 : index], kernel_mttkrp = 143 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%815, %c48, %c3, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%501, %c48, %c3, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%502, %c48, %c3, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%500, %c47, %c2, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%815, %arg119) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %504) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %505) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %506) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %816 = call @kernel_mttkrp0(%504, %505, %506) {adf.kernel, "col, row" = [3 : index, 4 : index], ivs = [0 : index, 0 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 144 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%816, %c3, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%505, %c3, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%506, %c3, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%504, %c3, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %507) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %508) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %509) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%816, %510) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %817 = call @kernel_mttkrp(%507, %508, %509, %510) {adf.kernel, "col, row" = [3 : index, 5 : index], ivs = [1 : index, 0 : index, 6 : index], kernel_mttkrp = 145 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%817, %c4, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%508, %c4, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%509, %c4, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%507, %c3, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%817, %arg122) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %511) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %512) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %513) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %818 = call @kernel_mttkrp0(%511, %512, %513) {adf.kernel, "col, row" = [7 : index, 4 : index], ivs = [0 : index, 1 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 146 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%818, %c7, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%512, %c7, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%513, %c7, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%511, %c7, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %514) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %515) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %516) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%818, %517) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %819 = call @kernel_mttkrp(%514, %515, %516, %517) {adf.kernel, "col, row" = [7 : index, 5 : index], ivs = [1 : index, 1 : index, 6 : index], kernel_mttkrp = 147 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%819, %c8, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%515, %c8, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%516, %c8, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%514, %c7, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%819, %arg123) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %518) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %519) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %520) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %820 = call @kernel_mttkrp0(%518, %519, %520) {adf.kernel, "col, row" = [11 : index, 4 : index], ivs = [0 : index, 2 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 148 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%820, %c11, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%519, %c11, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%520, %c11, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%518, %c11, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %521) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %522) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %523) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%820, %524) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %821 = call @kernel_mttkrp(%521, %522, %523, %524) {adf.kernel, "col, row" = [11 : index, 5 : index], ivs = [1 : index, 2 : index, 6 : index], kernel_mttkrp = 149 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%821, %c12, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%522, %c12, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%523, %c12, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%521, %c11, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%821, %arg124) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %525) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %526) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %527) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %822 = call @kernel_mttkrp0(%525, %526, %527) {adf.kernel, "col, row" = [15 : index, 4 : index], ivs = [0 : index, 3 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 150 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%822, %c15, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%526, %c15, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%527, %c15, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%525, %c15, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %528) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %529) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %530) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%822, %531) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %823 = call @kernel_mttkrp(%528, %529, %530, %531) {adf.kernel, "col, row" = [15 : index, 5 : index], ivs = [1 : index, 3 : index, 6 : index], kernel_mttkrp = 151 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%823, %c16, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%529, %c16, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%530, %c16, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%528, %c15, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%823, %arg125) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %532) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %533) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %534) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %824 = call @kernel_mttkrp0(%532, %533, %534) {adf.kernel, "col, row" = [19 : index, 4 : index], ivs = [0 : index, 4 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 152 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%824, %c19, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%533, %c19, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%534, %c19, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%532, %c19, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %535) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %536) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %537) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%824, %538) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %825 = call @kernel_mttkrp(%535, %536, %537, %538) {adf.kernel, "col, row" = [19 : index, 5 : index], ivs = [1 : index, 4 : index, 6 : index], kernel_mttkrp = 153 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%825, %c20, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%536, %c20, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%537, %c20, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%535, %c19, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%825, %arg126) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %539) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %540) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %541) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %826 = call @kernel_mttkrp0(%539, %540, %541) {adf.kernel, "col, row" = [23 : index, 4 : index], ivs = [0 : index, 5 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 154 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%826, %c23, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%540, %c23, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%541, %c23, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%539, %c23, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %542) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %543) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %544) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%826, %545) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %827 = call @kernel_mttkrp(%542, %543, %544, %545) {adf.kernel, "col, row" = [23 : index, 5 : index], ivs = [1 : index, 5 : index, 6 : index], kernel_mttkrp = 155 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%827, %c24, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%543, %c24, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%544, %c24, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%542, %c23, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%827, %arg127) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %546) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %547) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %548) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %828 = call @kernel_mttkrp0(%546, %547, %548) {adf.kernel, "col, row" = [27 : index, 4 : index], ivs = [0 : index, 6 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 156 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%828, %c27, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%547, %c27, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%548, %c27, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%546, %c27, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %549) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %550) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %551) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%828, %552) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %829 = call @kernel_mttkrp(%549, %550, %551, %552) {adf.kernel, "col, row" = [27 : index, 5 : index], ivs = [1 : index, 6 : index, 6 : index], kernel_mttkrp = 157 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%829, %c28, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%550, %c28, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%551, %c28, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%549, %c27, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%829, %arg128) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %553) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %554) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %555) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %830 = call @kernel_mttkrp0(%553, %554, %555) {adf.kernel, "col, row" = [31 : index, 4 : index], ivs = [0 : index, 7 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 158 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%830, %c31, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%554, %c31, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%555, %c31, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%553, %c31, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %556) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %557) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %558) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%830, %559) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %831 = call @kernel_mttkrp(%556, %557, %558, %559) {adf.kernel, "col, row" = [31 : index, 5 : index], ivs = [1 : index, 7 : index, 6 : index], kernel_mttkrp = 159 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%831, %c32, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%557, %c32, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%558, %c32, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%556, %c31, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%831, %arg129) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %560) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %561) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %562) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %832 = call @kernel_mttkrp0(%560, %561, %562) {adf.kernel, "col, row" = [35 : index, 4 : index], ivs = [0 : index, 8 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 160 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%832, %c35, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%561, %c35, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%562, %c35, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%560, %c35, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %563) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %564) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %565) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%832, %566) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %833 = call @kernel_mttkrp(%563, %564, %565, %566) {adf.kernel, "col, row" = [35 : index, 5 : index], ivs = [1 : index, 8 : index, 6 : index], kernel_mttkrp = 161 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%833, %c36, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%564, %c36, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%565, %c36, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%563, %c35, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%833, %arg130) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %567) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %568) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %569) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %834 = call @kernel_mttkrp0(%567, %568, %569) {adf.kernel, "col, row" = [39 : index, 4 : index], ivs = [0 : index, 9 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 162 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%834, %c39, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%568, %c39, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%569, %c39, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%567, %c39, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %570) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %571) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %572) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%834, %573) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %835 = call @kernel_mttkrp(%570, %571, %572, %573) {adf.kernel, "col, row" = [39 : index, 5 : index], ivs = [1 : index, 9 : index, 6 : index], kernel_mttkrp = 163 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%835, %c40, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%571, %c40, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%572, %c40, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%570, %c39, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%835, %arg131) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %574) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %575) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %576) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %836 = call @kernel_mttkrp0(%574, %575, %576) {adf.kernel, "col, row" = [43 : index, 4 : index], ivs = [0 : index, 10 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 164 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%836, %c43, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%575, %c43, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%576, %c43, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%574, %c43, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %577) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %578) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %579) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%836, %580) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %837 = call @kernel_mttkrp(%577, %578, %579, %580) {adf.kernel, "col, row" = [43 : index, 5 : index], ivs = [1 : index, 10 : index, 6 : index], kernel_mttkrp = 165 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%837, %c44, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%578, %c44, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%579, %c44, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%577, %c43, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%837, %arg132) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg120, %581) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %582) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %583) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %838 = call @kernel_mttkrp0(%581, %582, %583) {adf.kernel, "col, row" = [47 : index, 4 : index], ivs = [0 : index, 11 : index, 6 : index], kernel = 0 : index, kernel_mttkrp0 = 166 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%838, %c47, %c4, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%582, %c47, %c4, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%583, %c47, %c5, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%581, %c47, %c5, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg121, %584) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %585) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %586) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%838, %587) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %839 = call @kernel_mttkrp(%584, %585, %586, %587) {adf.kernel, "col, row" = [47 : index, 5 : index], ivs = [1 : index, 11 : index, 6 : index], kernel_mttkrp = 167 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%839, %c48, %c5, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%585, %c48, %c5, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%586, %c48, %c5, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%584, %c47, %c4, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%839, %arg133) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %588) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %589) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg2, %590) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %840 = call @kernel_mttkrp0(%588, %589, %590) {adf.kernel, "col, row" = [3 : index, 6 : index], ivs = [0 : index, 0 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 168 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%840, %c3, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%589, %c3, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%590, %c3, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%588, %c3, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %591) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg1, %592) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg4, %593) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%840, %594) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %841 = call @kernel_mttkrp(%591, %592, %593, %594) {adf.kernel, "col, row" = [3 : index, 7 : index], ivs = [1 : index, 0 : index, 7 : index], kernel_mttkrp = 169 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%841, %c4, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%592, %c4, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%593, %c4, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%591, %c3, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%841, %arg136) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %595) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %596) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg7, %597) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %842 = call @kernel_mttkrp0(%595, %596, %597) {adf.kernel, "col, row" = [7 : index, 6 : index], ivs = [0 : index, 1 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 170 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%842, %c7, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%596, %c7, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%597, %c7, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%595, %c7, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %598) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg6, %599) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg8, %600) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%842, %601) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %843 = call @kernel_mttkrp(%598, %599, %600, %601) {adf.kernel, "col, row" = [7 : index, 7 : index], ivs = [1 : index, 1 : index, 7 : index], kernel_mttkrp = 171 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%843, %c8, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%599, %c8, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%600, %c8, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%598, %c7, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%843, %arg137) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %602) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %603) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg11, %604) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %844 = call @kernel_mttkrp0(%602, %603, %604) {adf.kernel, "col, row" = [11 : index, 6 : index], ivs = [0 : index, 2 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 172 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%844, %c11, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%603, %c11, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%604, %c11, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%602, %c11, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %605) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg10, %606) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg12, %607) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%844, %608) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %845 = call @kernel_mttkrp(%605, %606, %607, %608) {adf.kernel, "col, row" = [11 : index, 7 : index], ivs = [1 : index, 2 : index, 7 : index], kernel_mttkrp = 173 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%845, %c12, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%606, %c12, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%607, %c12, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%605, %c11, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%845, %arg138) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %609) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %610) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg15, %611) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %846 = call @kernel_mttkrp0(%609, %610, %611) {adf.kernel, "col, row" = [15 : index, 6 : index], ivs = [0 : index, 3 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 174 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%846, %c15, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%610, %c15, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%611, %c15, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%609, %c15, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %612) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg14, %613) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg16, %614) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%846, %615) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %847 = call @kernel_mttkrp(%612, %613, %614, %615) {adf.kernel, "col, row" = [15 : index, 7 : index], ivs = [1 : index, 3 : index, 7 : index], kernel_mttkrp = 175 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%847, %c16, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%613, %c16, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%614, %c16, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%612, %c15, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%847, %arg139) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %616) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %617) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg19, %618) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %848 = call @kernel_mttkrp0(%616, %617, %618) {adf.kernel, "col, row" = [19 : index, 6 : index], ivs = [0 : index, 4 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 176 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%848, %c19, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%617, %c19, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%618, %c19, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%616, %c19, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %619) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg18, %620) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg20, %621) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%848, %622) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %849 = call @kernel_mttkrp(%619, %620, %621, %622) {adf.kernel, "col, row" = [19 : index, 7 : index], ivs = [1 : index, 4 : index, 7 : index], kernel_mttkrp = 177 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%849, %c20, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%620, %c20, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%621, %c20, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%619, %c19, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%849, %arg140) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %623) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %624) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg23, %625) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %850 = call @kernel_mttkrp0(%623, %624, %625) {adf.kernel, "col, row" = [23 : index, 6 : index], ivs = [0 : index, 5 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 178 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%850, %c23, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%624, %c23, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%625, %c23, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%623, %c23, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %626) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg22, %627) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg24, %628) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%850, %629) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %851 = call @kernel_mttkrp(%626, %627, %628, %629) {adf.kernel, "col, row" = [23 : index, 7 : index], ivs = [1 : index, 5 : index, 7 : index], kernel_mttkrp = 179 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%851, %c24, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%627, %c24, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%628, %c24, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%626, %c23, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%851, %arg141) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %630) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %631) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg27, %632) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %852 = call @kernel_mttkrp0(%630, %631, %632) {adf.kernel, "col, row" = [27 : index, 6 : index], ivs = [0 : index, 6 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 180 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%852, %c27, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%631, %c27, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%632, %c27, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%630, %c27, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %633) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg26, %634) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg28, %635) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%852, %636) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %853 = call @kernel_mttkrp(%633, %634, %635, %636) {adf.kernel, "col, row" = [27 : index, 7 : index], ivs = [1 : index, 6 : index, 7 : index], kernel_mttkrp = 181 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%853, %c28, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%634, %c28, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%635, %c28, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%633, %c27, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%853, %arg142) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %637) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %638) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg31, %639) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %854 = call @kernel_mttkrp0(%637, %638, %639) {adf.kernel, "col, row" = [31 : index, 6 : index], ivs = [0 : index, 7 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 182 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%854, %c31, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%638, %c31, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%639, %c31, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%637, %c31, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %640) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg30, %641) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg32, %642) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%854, %643) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %855 = call @kernel_mttkrp(%640, %641, %642, %643) {adf.kernel, "col, row" = [31 : index, 7 : index], ivs = [1 : index, 7 : index, 7 : index], kernel_mttkrp = 183 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%855, %c32, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%641, %c32, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%642, %c32, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%640, %c31, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%855, %arg143) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %644) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %645) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg35, %646) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %856 = call @kernel_mttkrp0(%644, %645, %646) {adf.kernel, "col, row" = [35 : index, 6 : index], ivs = [0 : index, 8 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 184 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%856, %c35, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%645, %c35, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%646, %c35, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%644, %c35, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %647) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg34, %648) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg36, %649) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%856, %650) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %857 = call @kernel_mttkrp(%647, %648, %649, %650) {adf.kernel, "col, row" = [35 : index, 7 : index], ivs = [1 : index, 8 : index, 7 : index], kernel_mttkrp = 185 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%857, %c36, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%648, %c36, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%649, %c36, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%647, %c35, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%857, %arg144) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %651) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %652) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg39, %653) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %858 = call @kernel_mttkrp0(%651, %652, %653) {adf.kernel, "col, row" = [39 : index, 6 : index], ivs = [0 : index, 9 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 186 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%858, %c39, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%652, %c39, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%653, %c39, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%651, %c39, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %654) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg38, %655) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg40, %656) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%858, %657) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %859 = call @kernel_mttkrp(%654, %655, %656, %657) {adf.kernel, "col, row" = [39 : index, 7 : index], ivs = [1 : index, 9 : index, 7 : index], kernel_mttkrp = 187 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%859, %c40, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%655, %c40, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%656, %c40, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%654, %c39, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%859, %arg145) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %658) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %659) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg43, %660) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %860 = call @kernel_mttkrp0(%658, %659, %660) {adf.kernel, "col, row" = [43 : index, 6 : index], ivs = [0 : index, 10 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 188 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%860, %c43, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%659, %c43, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%660, %c43, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%658, %c43, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %661) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg42, %662) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg44, %663) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%860, %664) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %861 = call @kernel_mttkrp(%661, %662, %663, %664) {adf.kernel, "col, row" = [43 : index, 7 : index], ivs = [1 : index, 10 : index, 7 : index], kernel_mttkrp = 189 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%861, %c44, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%662, %c44, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%663, %c44, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%661, %c43, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%861, %arg146) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    adf.connect(%arg134, %665) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %666) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg47, %667) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    %862 = call @kernel_mttkrp0(%665, %666, %667) {adf.kernel, "col, row" = [47 : index, 6 : index], ivs = [0 : index, 11 : index, 7 : index], kernel = 0 : index, kernel_mttkrp0 = 190 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%862, %c47, %c6, %c16384, %c24576) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%666, %c47, %c6, %c0, %c8192) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%667, %c47, %c7, %c16384, %c24576) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%665, %c47, %c7, %c0, %c8192) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%arg135, %668) : (!adf.plio<In, 128>, memref<2x16x32xf32, 2>)
    adf.connect(%arg46, %669) : (!adf.plio<In, 128>, memref<16x32xf32, 2>)
    adf.connect(%arg48, %670) : (!adf.plio<In, 128>, memref<32x32xf32, 2>)
    adf.connect(%862, %671) : (memref<2x32xf32, 2>, memref<2x32xf32, 2>)
    %863 = call @kernel_mttkrp(%668, %669, %670, %671) {adf.kernel, "col, row" = [47 : index, 7 : index], ivs = [1 : index, 11 : index, 7 : index], kernel_mttkrp = 191 : index} : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> memref<2x32xf32, 2>
    adf.buffer.location(%863, %c48, %c7, %c4096, %c12288) : (memref<2x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%669, %c48, %c7, %c16384, %c24576) : (memref<16x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%670, %c48, %c7, %c0, %c8192) : (memref<32x32xf32, 2>, index, index, index, index)
    adf.buffer.location(%668, %c47, %c6, %c4096, %c12288) : (memref<2x16x32xf32, 2>, index, index, index, index)
    adf.connect(%863, %arg147) {write = 1 : index} : (memref<2x32xf32, 2>, !adf.plio<Out, 128>)
    return
  }
  func.func @receive13(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, receive, template} {
    %c64 = arith.constant 64 : index
    %c95 = arith.constant 95 : index
    %c0 = arith.constant 0 : index
    %c127 = arith.constant 127 : index
    %c96 = arith.constant 96 : index
    %c31 = arith.constant 31 : index
    %c63 = arith.constant 63 : index
    %c32 = arith.constant 32 : index
    %c0_i128 = arith.constant 0 : i128
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<4x64xi128, 1>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 64 {
        affine.store %c0_i128, %alloc[%arg2, %arg3] : memref<4x64xi128, 1>
      } {pipeline_ii = 1 : index}
    }
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 8 {
                affine.for %arg8 = 0 to 6 {
                  affine.for %arg9 = 0 to 4 {
                    affine.for %arg10 = 0 to 2 {
                      affine.for %arg11 = 0 to 8 {
                        %0 = affine.load %arg0[0] : memref<1xi128, "plio">
                        %1 = affine.load %alloc[%arg10 + %arg6 * 2, %arg11 + %arg7 * 8] : memref<4x64xi128, 1>
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
                        affine.store %29, %alloc[%arg10 + %arg6 * 2, %arg11 + %arg7 * 8] : memref<4x64xi128, 1>
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            }
          } {Array_Partition, reduction}
        } {reduction}
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 8 {
              affine.for %arg7 = 0 to 8 {
                %0 = affine.load %alloc[%arg5 + %arg4 * 2, %arg7 + %arg6 * 8] : memref<4x64xi128, 1>
                affine.store %0, %arg1[0] : memref<1xi128, "stream">
                affine.store %c0_i128, %alloc[%arg5 + %arg4 * 2, %arg7 + %arg6 * 8] : memref<4x64xi128, 1>
              } {pipeline_ii = 1 : index}
            }
          }
        }
      }
    }
    return
  }
  func.func @receive13_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "stream">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "stream">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "stream">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "stream">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "stream">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "stream">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "stream">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "stream">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "stream">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "stream">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "stream">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "stream">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "stream">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "stream">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "stream">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "stream">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "stream">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "stream">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "stream">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "stream">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "stream">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "stream">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "stream">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "stream">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "stream">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "stream">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "stream">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "stream">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "stream">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "stream">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "stream">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "stream">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "stream">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "stream">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "stream">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "stream">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "stream">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "stream">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "stream">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "stream">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "stream">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "stream">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "stream">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "stream">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "stream">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "stream">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "stream">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "stream">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "stream">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "stream">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "stream">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "stream">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "stream">, %arg152: memref<1xi128, "plio">, %arg153: memref<1xi128, "stream">, %arg154: memref<1xi128, "plio">, %arg155: memref<1xi128, "stream">, %arg156: memref<1xi128, "plio">, %arg157: memref<1xi128, "stream">, %arg158: memref<1xi128, "plio">, %arg159: memref<1xi128, "stream">, %arg160: memref<1xi128, "plio">, %arg161: memref<1xi128, "stream">, %arg162: memref<1xi128, "plio">, %arg163: memref<1xi128, "stream">, %arg164: memref<1xi128, "plio">, %arg165: memref<1xi128, "stream">, %arg166: memref<1xi128, "plio">, %arg167: memref<1xi128, "stream">, %arg168: memref<1xi128, "plio">, %arg169: memref<1xi128, "stream">, %arg170: memref<1xi128, "plio">, %arg171: memref<1xi128, "stream">, %arg172: memref<1xi128, "plio">, %arg173: memref<1xi128, "stream">, %arg174: memref<1xi128, "plio">, %arg175: memref<1xi128, "stream">, %arg176: memref<1xi128, "plio">, %arg177: memref<1xi128, "stream">, %arg178: memref<1xi128, "plio">, %arg179: memref<1xi128, "stream">, %arg180: memref<1xi128, "plio">, %arg181: memref<1xi128, "stream">, %arg182: memref<1xi128, "plio">, %arg183: memref<1xi128, "stream">, %arg184: memref<1xi128, "plio">, %arg185: memref<1xi128, "stream">, %arg186: memref<1xi128, "plio">, %arg187: memref<1xi128, "stream">, %arg188: memref<1xi128, "plio">, %arg189: memref<1xi128, "stream">, %arg190: memref<1xi128, "plio">, %arg191: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
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
    call @receive13(%arg176, %arg177) {template = 88 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg178, %arg179) {template = 89 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg180, %arg181) {template = 90 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg182, %arg183) {template = 91 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg184, %arg185) {template = 92 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg186, %arg187) {template = 93 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg188, %arg189) {template = 94 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @receive13(%arg190, %arg191) {template = 95 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @send29_0(%arg0: memref<1xi128, "stream">, %arg1: memref<96x64xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 6 {
        affine.for %arg4 = 0 to 16 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 8 {
              %0 = affine.load %arg0[0] : memref<1xi128, "stream">
              affine.store %0, %arg1[%arg4 + %arg3 * 16, %arg6 + %arg5 * 8] : memref<96x64xi128, 1>
            } {pipeline_ii = 1 : index}
          }
        }
      }
    }
    return
  }
  func.func @send29_1(%arg0: memref<96x64xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 6 {
            affine.for %arg6 = 0 to 4 {
              affine.for %arg7 = 0 to 16 {
                affine.for %arg8 = 0 to 8 {
                  %0 = affine.load %arg0[%arg7 + %arg5 * 16, %arg8 + %arg4 * 8] : memref<96x64xi128, 1>
                  affine.store %0, %arg1[0] : memref<1xi128, "plio">
                } {pipeline_ii = 1 : index}
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @send29(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c128 = arith.constant 128 : index
    %c64 = arith.constant 64 : index
    %true = arith.constant true
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "bram_s2p"} : memref<96x64xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "bram_s2p"} : memref<96x64xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            %0 = arith.muli %arg4, %c8 : index
            %1 = arith.addi %arg5, %0 : index
            %2 = arith.muli %arg3, %c64 : index
            %3 = arith.addi %1, %2 : index
            %4 = arith.muli %arg2, %c128 : index
            %5 = arith.addi %3, %4 : index
            %6 = arith.remsi %5, %c2 : index
            %7 = arith.cmpi eq, %6, %c0 : index
            %8 = arith.cmpi ne, %5, %c0 : index
            scf.if %7 {
              func.call @send29_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<96x64xi128, 1>, i1) -> ()
              func.call @send29_1(%alloc_0, %arg0, %8) : (memref<96x64xi128, 1>, memref<1xi128, "plio">, i1) -> ()
            } else {
              func.call @send29_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<96x64xi128, 1>, i1) -> ()
              func.call @send29_1(%alloc, %arg0, %8) : (memref<96x64xi128, 1>, memref<1xi128, "plio">, i1) -> ()
            }
          } {Array_Partition, reduction}
        } {reduction}
      }
    }
    call @send29_1(%alloc_0, %arg0, %true) : (memref<96x64xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send29_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
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
    return
  }
  func.func @send21_0(%arg0: memref<1xi128, "stream">, %arg1: memref<128x64xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 4 {
        affine.for %arg4 = 0 to 32 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 8 {
              %0 = affine.load %arg0[0] : memref<1xi128, "stream">
              affine.store %0, %arg1[%arg4 + %arg3 * 32, %arg6 + %arg5 * 8] : memref<128x64xi128, 1>
            } {pipeline_ii = 1 : index}
          }
        }
      }
    }
    return
  }
  func.func @send21_1(%arg0: memref<128x64xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 6 {
            affine.for %arg6 = 0 to 4 {
              affine.for %arg7 = 0 to 32 {
                affine.for %arg8 = 0 to 8 {
                  %0 = affine.load %arg0[%arg7 + %arg6 * 32, %arg8 + %arg4 * 8] : memref<128x64xi128, 1>
                  affine.store %0, %arg1[0] : memref<1xi128, "plio">
                } {pipeline_ii = 1 : index}
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @send21(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c128 = arith.constant 128 : index
    %c64 = arith.constant 64 : index
    %true = arith.constant true
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<128x64xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "uram_t2p"} : memref<128x64xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            %0 = arith.muli %arg4, %c8 : index
            %1 = arith.addi %arg5, %0 : index
            %2 = arith.muli %arg3, %c64 : index
            %3 = arith.addi %1, %2 : index
            %4 = arith.muli %arg2, %c128 : index
            %5 = arith.addi %3, %4 : index
            %6 = arith.remsi %5, %c2 : index
            %7 = arith.cmpi eq, %6, %c0 : index
            %8 = arith.cmpi ne, %5, %c0 : index
            scf.if %7 {
              func.call @send21_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<128x64xi128, 1>, i1) -> ()
              func.call @send21_1(%alloc_0, %arg0, %8) : (memref<128x64xi128, 1>, memref<1xi128, "plio">, i1) -> ()
            } else {
              func.call @send21_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<128x64xi128, 1>, i1) -> ()
              func.call @send21_1(%alloc, %arg0, %8) : (memref<128x64xi128, 1>, memref<1xi128, "plio">, i1) -> ()
            }
          } {Array_Partition, reduction}
        } {reduction}
      }
    }
    call @send21_1(%alloc_0, %arg0, %true) : (memref<128x64xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send21_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @send21(%arg0, %arg1) {template = 0 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg2, %arg3) {template = 1 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg4, %arg5) {template = 2 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg6, %arg7) {template = 3 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg8, %arg9) {template = 4 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg10, %arg11) {template = 5 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg12, %arg13) {template = 6 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg14, %arg15) {template = 7 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg16, %arg17) {template = 8 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg18, %arg19) {template = 9 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg20, %arg21) {template = 10 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg22, %arg23) {template = 11 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg24, %arg25) {template = 12 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg26, %arg27) {template = 13 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg28, %arg29) {template = 14 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg30, %arg31) {template = 15 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg32, %arg33) {template = 16 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg34, %arg35) {template = 17 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg36, %arg37) {template = 18 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg38, %arg39) {template = 19 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg40, %arg41) {template = 20 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg42, %arg43) {template = 21 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg44, %arg45) {template = 22 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21(%arg46, %arg47) {template = 23 : index} : (memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @send39_0(%arg0: memref<1xi128, "stream">, %arg1: memref<4x96x32xi128, 1>, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 6 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 16 {
              affine.for %arg7 = 0 to 4 {
                affine.for %arg8 = 0 to 8 {
                  %0 = affine.load %arg0[0] : memref<1xi128, "stream">
                  affine.store %0, %arg1[%arg5 + %arg3 * 2, %arg6 + %arg4 * 16, %arg8 + %arg7 * 8] : memref<4x96x32xi128, 1>
                } {pipeline_ii = 1 : index}
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @send39_1(%arg0: memref<4x96x32xi128, 1>, %arg1: memref<1xi128, "plio">, %arg2: i1) attributes {adf.pl, inline = false} {
    scf.if %arg2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 6 {
            affine.for %arg6 = 0 to 4 {
              affine.for %arg7 = 0 to 2 {
                affine.for %arg8 = 0 to 16 {
                  affine.for %arg9 = 0 to 8 {
                    %0 = affine.load %arg0[%arg7 + %arg3 * 2, %arg8 + %arg5 * 16, %arg9 + %arg6 * 8] : memref<4x96x32xi128, 1>
                    affine.store %0, %arg1[0] : memref<1xi128, "plio">
                  } {pipeline_ii = 1 : index}
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func.func @send39(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, send, template} {
    %c128 = arith.constant 128 : index
    %c64 = arith.constant 64 : index
    %true = arith.constant true
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %c2 = arith.constant 2 : index
    %alloc = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x96x32xi128, 1>
    %alloc_0 = memref.alloc() {buffer_type = "uram_t2p"} : memref<4x96x32xi128, 1>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            %0 = arith.muli %arg4, %c8 : index
            %1 = arith.addi %arg5, %0 : index
            %2 = arith.muli %arg3, %c64 : index
            %3 = arith.addi %1, %2 : index
            %4 = arith.muli %arg2, %c128 : index
            %5 = arith.addi %3, %4 : index
            %6 = arith.remsi %5, %c2 : index
            %7 = arith.cmpi eq, %6, %c0 : index
            %8 = arith.cmpi ne, %5, %c0 : index
            scf.if %7 {
              func.call @send39_0(%arg1, %alloc, %true) : (memref<1xi128, "stream">, memref<4x96x32xi128, 1>, i1) -> ()
              func.call @send39_1(%alloc_0, %arg0, %8) : (memref<4x96x32xi128, 1>, memref<1xi128, "plio">, i1) -> ()
            } else {
              func.call @send39_0(%arg1, %alloc_0, %true) : (memref<1xi128, "stream">, memref<4x96x32xi128, 1>, i1) -> ()
              func.call @send39_1(%alloc, %arg0, %8) : (memref<4x96x32xi128, 1>, memref<1xi128, "plio">, i1) -> ()
            }
          } {Array_Partition, reduction}
        } {reduction}
      }
    }
    call @send39_1(%alloc_0, %arg0, %true) : (memref<4x96x32xi128, 1>, memref<1xi128, "plio">, i1) -> ()
    return
  }
  func.func @send39_top(%arg0: memref<1xi128, "plio">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi128, "plio">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
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
    return
  }
  func.func @store0_0(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, store, template} {
    %c0_i512 = arith.constant 0 : i512
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 2 {
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 8 {
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
  func.func @store0_0_top(%arg0: memref<1xi128, "stream">, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi128, "stream">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi128, "stream">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi128, "stream">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi128, "stream">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi128, "stream">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi128, "stream">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi128, "stream">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi128, "stream">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi128, "stream">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi128, "stream">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi128, "stream">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi128, "stream">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi128, "stream">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi128, "stream">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi128, "stream">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi128, "stream">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi128, "stream">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi128, "stream">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi128, "stream">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi128, "stream">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi128, "stream">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi128, "stream">, %arg45: memref<1xi512, "stream2">, %arg46: memref<1xi128, "stream">, %arg47: memref<1xi512, "stream2">, %arg48: memref<1xi128, "stream">, %arg49: memref<1xi512, "stream2">, %arg50: memref<1xi128, "stream">, %arg51: memref<1xi512, "stream2">, %arg52: memref<1xi128, "stream">, %arg53: memref<1xi512, "stream2">, %arg54: memref<1xi128, "stream">, %arg55: memref<1xi512, "stream2">, %arg56: memref<1xi128, "stream">, %arg57: memref<1xi512, "stream2">, %arg58: memref<1xi128, "stream">, %arg59: memref<1xi512, "stream2">, %arg60: memref<1xi128, "stream">, %arg61: memref<1xi512, "stream2">, %arg62: memref<1xi128, "stream">, %arg63: memref<1xi512, "stream2">, %arg64: memref<1xi128, "stream">, %arg65: memref<1xi512, "stream2">, %arg66: memref<1xi128, "stream">, %arg67: memref<1xi512, "stream2">, %arg68: memref<1xi128, "stream">, %arg69: memref<1xi512, "stream2">, %arg70: memref<1xi128, "stream">, %arg71: memref<1xi512, "stream2">, %arg72: memref<1xi128, "stream">, %arg73: memref<1xi512, "stream2">, %arg74: memref<1xi128, "stream">, %arg75: memref<1xi512, "stream2">, %arg76: memref<1xi128, "stream">, %arg77: memref<1xi512, "stream2">, %arg78: memref<1xi128, "stream">, %arg79: memref<1xi512, "stream2">, %arg80: memref<1xi128, "stream">, %arg81: memref<1xi512, "stream2">, %arg82: memref<1xi128, "stream">, %arg83: memref<1xi512, "stream2">, %arg84: memref<1xi128, "stream">, %arg85: memref<1xi512, "stream2">, %arg86: memref<1xi128, "stream">, %arg87: memref<1xi512, "stream2">, %arg88: memref<1xi128, "stream">, %arg89: memref<1xi512, "stream2">, %arg90: memref<1xi128, "stream">, %arg91: memref<1xi512, "stream2">, %arg92: memref<1xi128, "stream">, %arg93: memref<1xi512, "stream2">, %arg94: memref<1xi128, "stream">, %arg95: memref<1xi512, "stream2">, %arg96: memref<1xi128, "stream">, %arg97: memref<1xi512, "stream2">, %arg98: memref<1xi128, "stream">, %arg99: memref<1xi512, "stream2">, %arg100: memref<1xi128, "stream">, %arg101: memref<1xi512, "stream2">, %arg102: memref<1xi128, "stream">, %arg103: memref<1xi512, "stream2">, %arg104: memref<1xi128, "stream">, %arg105: memref<1xi512, "stream2">, %arg106: memref<1xi128, "stream">, %arg107: memref<1xi512, "stream2">, %arg108: memref<1xi128, "stream">, %arg109: memref<1xi512, "stream2">, %arg110: memref<1xi128, "stream">, %arg111: memref<1xi512, "stream2">, %arg112: memref<1xi128, "stream">, %arg113: memref<1xi512, "stream2">, %arg114: memref<1xi128, "stream">, %arg115: memref<1xi512, "stream2">, %arg116: memref<1xi128, "stream">, %arg117: memref<1xi512, "stream2">, %arg118: memref<1xi128, "stream">, %arg119: memref<1xi512, "stream2">, %arg120: memref<1xi128, "stream">, %arg121: memref<1xi512, "stream2">, %arg122: memref<1xi128, "stream">, %arg123: memref<1xi512, "stream2">, %arg124: memref<1xi128, "stream">, %arg125: memref<1xi512, "stream2">, %arg126: memref<1xi128, "stream">, %arg127: memref<1xi512, "stream2">, %arg128: memref<1xi128, "stream">, %arg129: memref<1xi512, "stream2">, %arg130: memref<1xi128, "stream">, %arg131: memref<1xi512, "stream2">, %arg132: memref<1xi128, "stream">, %arg133: memref<1xi512, "stream2">, %arg134: memref<1xi128, "stream">, %arg135: memref<1xi512, "stream2">, %arg136: memref<1xi128, "stream">, %arg137: memref<1xi512, "stream2">, %arg138: memref<1xi128, "stream">, %arg139: memref<1xi512, "stream2">, %arg140: memref<1xi128, "stream">, %arg141: memref<1xi512, "stream2">, %arg142: memref<1xi128, "stream">, %arg143: memref<1xi512, "stream2">, %arg144: memref<1xi128, "stream">, %arg145: memref<1xi512, "stream2">, %arg146: memref<1xi128, "stream">, %arg147: memref<1xi512, "stream2">, %arg148: memref<1xi128, "stream">, %arg149: memref<1xi512, "stream2">, %arg150: memref<1xi128, "stream">, %arg151: memref<1xi512, "stream2">, %arg152: memref<1xi128, "stream">, %arg153: memref<1xi512, "stream2">, %arg154: memref<1xi128, "stream">, %arg155: memref<1xi512, "stream2">, %arg156: memref<1xi128, "stream">, %arg157: memref<1xi512, "stream2">, %arg158: memref<1xi128, "stream">, %arg159: memref<1xi512, "stream2">, %arg160: memref<1xi128, "stream">, %arg161: memref<1xi512, "stream2">, %arg162: memref<1xi128, "stream">, %arg163: memref<1xi512, "stream2">, %arg164: memref<1xi128, "stream">, %arg165: memref<1xi512, "stream2">, %arg166: memref<1xi128, "stream">, %arg167: memref<1xi512, "stream2">, %arg168: memref<1xi128, "stream">, %arg169: memref<1xi512, "stream2">, %arg170: memref<1xi128, "stream">, %arg171: memref<1xi512, "stream2">, %arg172: memref<1xi128, "stream">, %arg173: memref<1xi512, "stream2">, %arg174: memref<1xi128, "stream">, %arg175: memref<1xi512, "stream2">, %arg176: memref<1xi128, "stream">, %arg177: memref<1xi512, "stream2">, %arg178: memref<1xi128, "stream">, %arg179: memref<1xi512, "stream2">, %arg180: memref<1xi128, "stream">, %arg181: memref<1xi512, "stream2">, %arg182: memref<1xi128, "stream">, %arg183: memref<1xi512, "stream2">, %arg184: memref<1xi128, "stream">, %arg185: memref<1xi512, "stream2">, %arg186: memref<1xi128, "stream">, %arg187: memref<1xi512, "stream2">, %arg188: memref<1xi128, "stream">, %arg189: memref<1xi512, "stream2">, %arg190: memref<1xi128, "stream">, %arg191: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
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
    call @store0_0(%arg176, %arg177) {template = 88 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg178, %arg179) {template = 89 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg180, %arg181) {template = 90 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg182, %arg183) {template = 91 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg184, %arg185) {template = 92 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg186, %arg187) {template = 93 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg188, %arg189) {template = 94 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_0(%arg190, %arg191) {template = 95 : index} : (memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @store0(%arg0: memref<64x384xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi512, "stream2">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi512, "stream2">, %arg48: memref<1xi512, "stream2">, %arg49: memref<1xi512, "stream2">, %arg50: memref<1xi512, "stream2">, %arg51: memref<1xi512, "stream2">, %arg52: memref<1xi512, "stream2">, %arg53: memref<1xi512, "stream2">, %arg54: memref<1xi512, "stream2">, %arg55: memref<1xi512, "stream2">, %arg56: memref<1xi512, "stream2">, %arg57: memref<1xi512, "stream2">, %arg58: memref<1xi512, "stream2">, %arg59: memref<1xi512, "stream2">, %arg60: memref<1xi512, "stream2">, %arg61: memref<1xi512, "stream2">, %arg62: memref<1xi512, "stream2">, %arg63: memref<1xi512, "stream2">, %arg64: memref<1xi512, "stream2">, %arg65: memref<1xi512, "stream2">, %arg66: memref<1xi512, "stream2">, %arg67: memref<1xi512, "stream2">, %arg68: memref<1xi512, "stream2">, %arg69: memref<1xi512, "stream2">, %arg70: memref<1xi512, "stream2">, %arg71: memref<1xi512, "stream2">, %arg72: memref<1xi512, "stream2">, %arg73: memref<1xi512, "stream2">, %arg74: memref<1xi512, "stream2">, %arg75: memref<1xi512, "stream2">, %arg76: memref<1xi512, "stream2">, %arg77: memref<1xi512, "stream2">, %arg78: memref<1xi512, "stream2">, %arg79: memref<1xi512, "stream2">, %arg80: memref<1xi512, "stream2">, %arg81: memref<1xi512, "stream2">, %arg82: memref<1xi512, "stream2">, %arg83: memref<1xi512, "stream2">, %arg84: memref<1xi512, "stream2">, %arg85: memref<1xi512, "stream2">, %arg86: memref<1xi512, "stream2">, %arg87: memref<1xi512, "stream2">, %arg88: memref<1xi512, "stream2">, %arg89: memref<1xi512, "stream2">, %arg90: memref<1xi512, "stream2">, %arg91: memref<1xi512, "stream2">, %arg92: memref<1xi512, "stream2">, %arg93: memref<1xi512, "stream2">, %arg94: memref<1xi512, "stream2">, %arg95: memref<1xi512, "stream2">, %arg96: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, mem_idx = [0 : i32], mem_type = [f32], store, template} {
    %c22 = arith.constant 22 : index
    %c20 = arith.constant 20 : index
    %c18 = arith.constant 18 : index
    %c16 = arith.constant 16 : index
    %c14 = arith.constant 14 : index
    %c12 = arith.constant 12 : index
    %c10 = arith.constant 10 : index
    %c8 = arith.constant 8 : index
    %c6 = arith.constant 6 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    affine.for %arg97 = 0 to 2 {
      affine.for %arg98 = 0 to 2 {
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg30[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg89[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg79[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg52[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg38[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg20[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg39[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg12[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg13[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg46[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg90[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg31[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg18[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg41[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg72[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg28[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg5[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg91[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg69[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg3[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg10[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg44[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg83[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg75[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 2, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg11[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg15[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg63[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg93[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg56[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg73[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg96[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg48[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg34[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg6[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg27[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg16[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 4, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg67[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg17[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg92[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg29[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg49[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg59[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg65[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg62[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg80[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg2[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg84[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg32[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 6, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg1[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg70[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg35[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg76[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg57[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg8[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg43[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg66[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg77[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg36[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg47[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg45[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 8, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg64[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg50[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg85[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg37[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg25[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg4[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg82[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg74[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg7[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg68[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg9[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg55[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 10, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg14[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg21[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg78[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg81[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg42[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg88[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg95[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg61[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg86[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg24[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg51[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg23[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 12, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
        affine.for %arg99 = 0 to 2 {
          affine.for %arg100 = 0 to 2 {
            affine.for %arg101 = 0 to 8 {
              affine.for %arg102 = 0 to 24 {
                %0 = arith.cmpi slt, %arg102, %c2 : index
                %1 = scf.if %0 -> (i512) {
                  %2 = affine.load %arg53[0] : memref<1xi512, "stream2">
                  scf.yield %2 : i512
                } else {
                  %2 = arith.cmpi slt, %arg102, %c4 : index
                  %3 = scf.if %2 -> (i512) {
                    %4 = affine.load %arg54[0] : memref<1xi512, "stream2">
                    scf.yield %4 : i512
                  } else {
                    %4 = arith.cmpi slt, %arg102, %c6 : index
                    %5 = scf.if %4 -> (i512) {
                      %6 = affine.load %arg94[0] : memref<1xi512, "stream2">
                      scf.yield %6 : i512
                    } else {
                      %6 = arith.cmpi slt, %arg102, %c8 : index
                      %7 = scf.if %6 -> (i512) {
                        %8 = affine.load %arg19[0] : memref<1xi512, "stream2">
                        scf.yield %8 : i512
                      } else {
                        %8 = arith.cmpi slt, %arg102, %c10 : index
                        %9 = scf.if %8 -> (i512) {
                          %10 = affine.load %arg60[0] : memref<1xi512, "stream2">
                          scf.yield %10 : i512
                        } else {
                          %10 = arith.cmpi slt, %arg102, %c12 : index
                          %11 = scf.if %10 -> (i512) {
                            %12 = affine.load %arg71[0] : memref<1xi512, "stream2">
                            scf.yield %12 : i512
                          } else {
                            %12 = arith.cmpi slt, %arg102, %c14 : index
                            %13 = scf.if %12 -> (i512) {
                              %14 = affine.load %arg22[0] : memref<1xi512, "stream2">
                              scf.yield %14 : i512
                            } else {
                              %14 = arith.cmpi slt, %arg102, %c16 : index
                              %15 = scf.if %14 -> (i512) {
                                %16 = affine.load %arg40[0] : memref<1xi512, "stream2">
                                scf.yield %16 : i512
                              } else {
                                %16 = arith.cmpi slt, %arg102, %c18 : index
                                %17 = scf.if %16 -> (i512) {
                                  %18 = affine.load %arg87[0] : memref<1xi512, "stream2">
                                  scf.yield %18 : i512
                                } else {
                                  %18 = arith.cmpi slt, %arg102, %c20 : index
                                  %19 = scf.if %18 -> (i512) {
                                    %20 = affine.load %arg26[0] : memref<1xi512, "stream2">
                                    scf.yield %20 : i512
                                  } else {
                                    %20 = arith.cmpi slt, %arg102, %c22 : index
                                    %21 = scf.if %20 -> (i512) {
                                      %22 = affine.load %arg33[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    } else {
                                      %22 = affine.load %arg58[0] : memref<1xi512, "stream2">
                                      scf.yield %22 : i512
                                    }
                                    scf.yield %21 : i512
                                  }
                                  scf.yield %19 : i512
                                }
                                scf.yield %17 : i512
                              }
                              scf.yield %15 : i512
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
                affine.store %1, %arg0[%arg100 + %arg99 * 16 + %arg97 * 32 + 14, %arg102 + %arg101 * 24 + %arg98 * 192] : memref<64x384xi512>
              } {pipeline_ii = 1 : index}
            }
          }
        } {merge}
      }
    }
    return
  }
  func.func @store0_top(%arg0: memref<64x384xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi512, "stream2">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi512, "stream2">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi512, "stream2">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi512, "stream2">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi512, "stream2">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi512, "stream2">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi512, "stream2">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi512, "stream2">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi512, "stream2">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi512, "stream2">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi512, "stream2">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi512, "stream2">, %arg48: memref<1xi512, "stream2">, %arg49: memref<1xi512, "stream2">, %arg50: memref<1xi512, "stream2">, %arg51: memref<1xi512, "stream2">, %arg52: memref<1xi512, "stream2">, %arg53: memref<1xi512, "stream2">, %arg54: memref<1xi512, "stream2">, %arg55: memref<1xi512, "stream2">, %arg56: memref<1xi512, "stream2">, %arg57: memref<1xi512, "stream2">, %arg58: memref<1xi512, "stream2">, %arg59: memref<1xi512, "stream2">, %arg60: memref<1xi512, "stream2">, %arg61: memref<1xi512, "stream2">, %arg62: memref<1xi512, "stream2">, %arg63: memref<1xi512, "stream2">, %arg64: memref<1xi512, "stream2">, %arg65: memref<1xi512, "stream2">, %arg66: memref<1xi512, "stream2">, %arg67: memref<1xi512, "stream2">, %arg68: memref<1xi512, "stream2">, %arg69: memref<1xi512, "stream2">, %arg70: memref<1xi512, "stream2">, %arg71: memref<1xi512, "stream2">, %arg72: memref<1xi512, "stream2">, %arg73: memref<1xi512, "stream2">, %arg74: memref<1xi512, "stream2">, %arg75: memref<1xi512, "stream2">, %arg76: memref<1xi512, "stream2">, %arg77: memref<1xi512, "stream2">, %arg78: memref<1xi512, "stream2">, %arg79: memref<1xi512, "stream2">, %arg80: memref<1xi512, "stream2">, %arg81: memref<1xi512, "stream2">, %arg82: memref<1xi512, "stream2">, %arg83: memref<1xi512, "stream2">, %arg84: memref<1xi512, "stream2">, %arg85: memref<1xi512, "stream2">, %arg86: memref<1xi512, "stream2">, %arg87: memref<1xi512, "stream2">, %arg88: memref<1xi512, "stream2">, %arg89: memref<1xi512, "stream2">, %arg90: memref<1xi512, "stream2">, %arg91: memref<1xi512, "stream2">, %arg92: memref<1xi512, "stream2">, %arg93: memref<1xi512, "stream2">, %arg94: memref<1xi512, "stream2">, %arg95: memref<1xi512, "stream2">, %arg96: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @store0(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44, %arg45, %arg46, %arg47, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68, %arg69, %arg70, %arg71, %arg72, %arg73, %arg74, %arg75, %arg76, %arg77, %arg78, %arg79, %arg80, %arg81, %arg82, %arg83, %arg84, %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96) {template = 0 : index} : (memref<64x384xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load0(%arg0: memref<64x768x128xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c2 = arith.constant 2 : index
    affine.for %arg17 = 0 to 2 {
      affine.for %arg18 = 0 to 2 {
        affine.for %arg19 = 0 to 8 {
          affine.for %arg20 = 0 to 8 {
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 2, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg11[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 4, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg7[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg15[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 6, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg14[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 8, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg16[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg13[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 10, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg10[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg12[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 12, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg8[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg9[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
            affine.for %arg21 = 0 to 2 {
              affine.for %arg22 = 0 to 6 {
                affine.for %arg23 = 0 to 2 {
                  affine.for %arg24 = 0 to 16 {
                    affine.for %arg25 = 0 to 4 {
                      affine.for %arg26 = 0 to 4 {
                        %0 = affine.load %arg0[%arg23 + %arg21 * 16 + %arg17 * 32 + 14, %arg24 + %arg22 * 16 + %arg19 * 96, %arg26 + %arg25 * 4 + %arg20 * 16] : memref<64x768x128xi512>
                        %1 = arith.cmpi slt, %arg26, %c2 : index
                        scf.if %1 {
                          affine.store %0, %arg6[0] : memref<1xi512, "stream2">
                        } else {
                          affine.store %0, %arg5[0] : memref<1xi512, "stream2">
                        }
                      } {pipeline_ii = 1 : index}
                    }
                  }
                }
              }
            } {merge}
          } {Array_Partition, reduction}
        } {reduction}
      }
    }
    return
  }
  func.func @load0_top(%arg0: memref<64x768x128xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load0(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16) {template = 0 : index} : (memref<64x768x128xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load0_15(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 2 {
              affine.for %arg7 = 0 to 6 {
                affine.for %arg8 = 0 to 2 {
                  affine.for %arg9 = 0 to 16 {
                    affine.for %arg10 = 0 to 4 {
                      affine.for %arg11 = 0 to 2 {
                        %0 = affine.load %arg0[0] : memref<1xi512, "stream2">
                        affine.for %arg12 = 0 to 4 {
                          %1 = affine.apply #map(%arg12)
                          %2 = affine.apply #map1(%arg12)
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
        }
      }
    }
    return
  }
  func.func @load0_15_top(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @load0_15(%arg0, %arg1) {template = 0 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg2, %arg3) {template = 1 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg4, %arg5) {template = 2 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg6, %arg7) {template = 3 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg8, %arg9) {template = 4 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg10, %arg11) {template = 5 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg12, %arg13) {template = 6 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg14, %arg15) {template = 7 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg16, %arg17) {template = 8 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg18, %arg19) {template = 9 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg20, %arg21) {template = 10 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg22, %arg23) {template = 11 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg24, %arg25) {template = 12 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg26, %arg27) {template = 13 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg28, %arg29) {template = 14 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load0_15(%arg30, %arg31) {template = 15 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @load2(%arg0: memref<2048x384xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c22 = arith.constant 22 : index
    %c20 = arith.constant 20 : index
    %c18 = arith.constant 18 : index
    %c16 = arith.constant 16 : index
    %c14 = arith.constant 14 : index
    %c12 = arith.constant 12 : index
    %c10 = arith.constant 10 : index
    %c8 = arith.constant 8 : index
    %c6 = arith.constant 6 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    affine.for %arg25 = 0 to 2 {
      affine.for %arg26 = 0 to 2 {
        affine.for %arg27 = 0 to 8 {
          affine.for %arg28 = 0 to 8 {
            affine.for %arg29 = 0 to 4 {
              affine.for %arg30 = 0 to 32 {
                affine.for %arg31 = 0 to 8 {
                  affine.for %arg32 = 0 to 24 {
                    %0 = affine.load %arg0[%arg30 + %arg29 * 64 + %arg28 * 256, %arg32 + %arg31 * 24 + %arg26 * 192] : memref<2048x384xi512>
                    %1 = arith.cmpi slt, %arg32, %c2 : index
                    scf.if %1 {
                      affine.store %0, %arg21[0] : memref<1xi512, "stream2">
                    } else {
                      %2 = arith.cmpi slt, %arg32, %c4 : index
                      scf.if %2 {
                        affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                      } else {
                        %3 = arith.cmpi slt, %arg32, %c6 : index
                        scf.if %3 {
                          affine.store %0, %arg18[0] : memref<1xi512, "stream2">
                        } else {
                          %4 = arith.cmpi slt, %arg32, %c8 : index
                          scf.if %4 {
                            affine.store %0, %arg15[0] : memref<1xi512, "stream2">
                          } else {
                            %5 = arith.cmpi slt, %arg32, %c10 : index
                            scf.if %5 {
                              affine.store %0, %arg6[0] : memref<1xi512, "stream2">
                            } else {
                              %6 = arith.cmpi slt, %arg32, %c12 : index
                              scf.if %6 {
                                affine.store %0, %arg22[0] : memref<1xi512, "stream2">
                              } else {
                                %7 = arith.cmpi slt, %arg32, %c14 : index
                                scf.if %7 {
                                  affine.store %0, %arg7[0] : memref<1xi512, "stream2">
                                } else {
                                  %8 = arith.cmpi slt, %arg32, %c16 : index
                                  scf.if %8 {
                                    affine.store %0, %arg17[0] : memref<1xi512, "stream2">
                                  } else {
                                    %9 = arith.cmpi slt, %arg32, %c18 : index
                                    scf.if %9 {
                                      affine.store %0, %arg5[0] : memref<1xi512, "stream2">
                                    } else {
                                      %10 = arith.cmpi slt, %arg32, %c20 : index
                                      scf.if %10 {
                                        affine.store %0, %arg19[0] : memref<1xi512, "stream2">
                                      } else {
                                        %11 = arith.cmpi slt, %arg32, %c22 : index
                                        scf.if %11 {
                                          affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                                        } else {
                                          affine.store %0, %arg10[0] : memref<1xi512, "stream2">
                                        }
                                      }
                                    }
                                  }
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
            affine.for %arg29 = 0 to 4 {
              affine.for %arg30 = 0 to 32 {
                affine.for %arg31 = 0 to 8 {
                  affine.for %arg32 = 0 to 24 {
                    %0 = affine.load %arg0[%arg30 + %arg29 * 64 + %arg28 * 256 + 32, %arg32 + %arg31 * 24 + %arg26 * 192] : memref<2048x384xi512>
                    %1 = arith.cmpi slt, %arg32, %c2 : index
                    scf.if %1 {
                      affine.store %0, %arg23[0] : memref<1xi512, "stream2">
                    } else {
                      %2 = arith.cmpi slt, %arg32, %c4 : index
                      scf.if %2 {
                        affine.store %0, %arg14[0] : memref<1xi512, "stream2">
                      } else {
                        %3 = arith.cmpi slt, %arg32, %c6 : index
                        scf.if %3 {
                          affine.store %0, %arg16[0] : memref<1xi512, "stream2">
                        } else {
                          %4 = arith.cmpi slt, %arg32, %c8 : index
                          scf.if %4 {
                            affine.store %0, %arg24[0] : memref<1xi512, "stream2">
                          } else {
                            %5 = arith.cmpi slt, %arg32, %c10 : index
                            scf.if %5 {
                              affine.store %0, %arg9[0] : memref<1xi512, "stream2">
                            } else {
                              %6 = arith.cmpi slt, %arg32, %c12 : index
                              scf.if %6 {
                                affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                              } else {
                                %7 = arith.cmpi slt, %arg32, %c14 : index
                                scf.if %7 {
                                  affine.store %0, %arg13[0] : memref<1xi512, "stream2">
                                } else {
                                  %8 = arith.cmpi slt, %arg32, %c16 : index
                                  scf.if %8 {
                                    affine.store %0, %arg20[0] : memref<1xi512, "stream2">
                                  } else {
                                    %9 = arith.cmpi slt, %arg32, %c18 : index
                                    scf.if %9 {
                                      affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                                    } else {
                                      %10 = arith.cmpi slt, %arg32, %c20 : index
                                      scf.if %10 {
                                        affine.store %0, %arg11[0] : memref<1xi512, "stream2">
                                      } else {
                                        %11 = arith.cmpi slt, %arg32, %c22 : index
                                        scf.if %11 {
                                          affine.store %0, %arg8[0] : memref<1xi512, "stream2">
                                        } else {
                                          affine.store %0, %arg12[0] : memref<1xi512, "stream2">
                                        }
                                      }
                                    }
                                  }
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
        } {reduction}
      }
    }
    return
  }
  func.func @load2_top(%arg0: memref<2048x384xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi512, "stream2">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi512, "stream2">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi512, "stream2">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi512, "stream2">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi512, "stream2">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi512, "stream2">, %arg24: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load2(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24) {template = 0 : index} : (memref<2048x384xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load2_23(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 4 {
              affine.for %arg7 = 0 to 32 {
                affine.for %arg8 = 0 to 8 {
                  affine.for %arg9 = 0 to 2 {
                    %0 = affine.load %arg0[0] : memref<1xi512, "stream2">
                    affine.for %arg10 = 0 to 4 {
                      %1 = affine.apply #map(%arg10)
                      %2 = affine.apply #map1(%arg10)
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
    }
    return
  }
  func.func @load2_23_top(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi128, "stream">, %arg24: memref<1xi512, "stream2">, %arg25: memref<1xi128, "stream">, %arg26: memref<1xi512, "stream2">, %arg27: memref<1xi128, "stream">, %arg28: memref<1xi512, "stream2">, %arg29: memref<1xi128, "stream">, %arg30: memref<1xi512, "stream2">, %arg31: memref<1xi128, "stream">, %arg32: memref<1xi512, "stream2">, %arg33: memref<1xi128, "stream">, %arg34: memref<1xi512, "stream2">, %arg35: memref<1xi128, "stream">, %arg36: memref<1xi512, "stream2">, %arg37: memref<1xi128, "stream">, %arg38: memref<1xi512, "stream2">, %arg39: memref<1xi128, "stream">, %arg40: memref<1xi512, "stream2">, %arg41: memref<1xi128, "stream">, %arg42: memref<1xi512, "stream2">, %arg43: memref<1xi128, "stream">, %arg44: memref<1xi512, "stream2">, %arg45: memref<1xi128, "stream">, %arg46: memref<1xi512, "stream2">, %arg47: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @load2_23(%arg0, %arg1) {template = 0 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg2, %arg3) {template = 1 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg4, %arg5) {template = 2 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg6, %arg7) {template = 3 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg8, %arg9) {template = 4 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg10, %arg11) {template = 5 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg12, %arg13) {template = 6 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg14, %arg15) {template = 7 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg16, %arg17) {template = 8 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg18, %arg19) {template = 9 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg20, %arg21) {template = 10 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg22, %arg23) {template = 11 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg24, %arg25) {template = 12 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg26, %arg27) {template = 13 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg28, %arg29) {template = 14 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg30, %arg31) {template = 15 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg32, %arg33) {template = 16 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg34, %arg35) {template = 17 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg36, %arg37) {template = 18 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg38, %arg39) {template = 19 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg40, %arg41) {template = 20 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg42, %arg43) {template = 21 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg44, %arg45) {template = 22 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_23(%arg46, %arg47) {template = 23 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @load1(%arg0: memref<768x384xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">) attributes {adf.pl, inline = false, load, mem_idx = [0 : i32], mem_type = [f32], template} {
    %c22 = arith.constant 22 : index
    %c20 = arith.constant 20 : index
    %c18 = arith.constant 18 : index
    %c16 = arith.constant 16 : index
    %c14 = arith.constant 14 : index
    %c12 = arith.constant 12 : index
    %c10 = arith.constant 10 : index
    %c8 = arith.constant 8 : index
    %c6 = arith.constant 6 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    affine.for %arg13 = 0 to 2 {
      affine.for %arg14 = 0 to 2 {
        affine.for %arg15 = 0 to 8 {
          affine.for %arg16 = 0 to 8 {
            affine.for %arg17 = 0 to 6 {
              affine.for %arg18 = 0 to 16 {
                affine.for %arg19 = 0 to 8 {
                  affine.for %arg20 = 0 to 24 {
                    %0 = affine.load %arg0[%arg18 + %arg17 * 16 + %arg15 * 96, %arg20 + %arg19 * 24 + %arg14 * 192] : memref<768x384xi512>
                    %1 = arith.cmpi slt, %arg20, %c2 : index
                    scf.if %1 {
                      affine.store %0, %arg3[0] : memref<1xi512, "stream2">
                    } else {
                      %2 = arith.cmpi slt, %arg20, %c4 : index
                      scf.if %2 {
                        affine.store %0, %arg2[0] : memref<1xi512, "stream2">
                      } else {
                        %3 = arith.cmpi slt, %arg20, %c6 : index
                        scf.if %3 {
                          affine.store %0, %arg11[0] : memref<1xi512, "stream2">
                        } else {
                          %4 = arith.cmpi slt, %arg20, %c8 : index
                          scf.if %4 {
                            affine.store %0, %arg9[0] : memref<1xi512, "stream2">
                          } else {
                            %5 = arith.cmpi slt, %arg20, %c10 : index
                            scf.if %5 {
                              affine.store %0, %arg6[0] : memref<1xi512, "stream2">
                            } else {
                              %6 = arith.cmpi slt, %arg20, %c12 : index
                              scf.if %6 {
                                affine.store %0, %arg10[0] : memref<1xi512, "stream2">
                              } else {
                                %7 = arith.cmpi slt, %arg20, %c14 : index
                                scf.if %7 {
                                  affine.store %0, %arg12[0] : memref<1xi512, "stream2">
                                } else {
                                  %8 = arith.cmpi slt, %arg20, %c16 : index
                                  scf.if %8 {
                                    affine.store %0, %arg1[0] : memref<1xi512, "stream2">
                                  } else {
                                    %9 = arith.cmpi slt, %arg20, %c18 : index
                                    scf.if %9 {
                                      affine.store %0, %arg4[0] : memref<1xi512, "stream2">
                                    } else {
                                      %10 = arith.cmpi slt, %arg20, %c20 : index
                                      scf.if %10 {
                                        affine.store %0, %arg7[0] : memref<1xi512, "stream2">
                                      } else {
                                        %11 = arith.cmpi slt, %arg20, %c22 : index
                                        scf.if %11 {
                                          affine.store %0, %arg5[0] : memref<1xi512, "stream2">
                                        } else {
                                          affine.store %0, %arg8[0] : memref<1xi512, "stream2">
                                        }
                                      }
                                    }
                                  }
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
        } {reduction}
      }
    }
    return
  }
  func.func @load1_top(%arg0: memref<768x384xi512>, %arg1: memref<1xi512, "stream2">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi512, "stream2">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi512, "stream2">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi512, "stream2">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi512, "stream2">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi512, "stream2">, %arg12: memref<1xi512, "stream2">) attributes {adf.pl, inline = false} {
    call @load1(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12) {template = 0 : index} : (memref<768x384xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    return
  }
  func.func @load1_11(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">) attributes {adf.pl, inline = false, load, template} {
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 6 {
              affine.for %arg7 = 0 to 16 {
                affine.for %arg8 = 0 to 8 {
                  affine.for %arg9 = 0 to 2 {
                    %0 = affine.load %arg0[0] : memref<1xi512, "stream2">
                    affine.for %arg10 = 0 to 4 {
                      %1 = affine.apply #map(%arg10)
                      %2 = affine.apply #map1(%arg10)
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
    }
    return
  }
  func.func @load1_11_top(%arg0: memref<1xi512, "stream2">, %arg1: memref<1xi128, "stream">, %arg2: memref<1xi512, "stream2">, %arg3: memref<1xi128, "stream">, %arg4: memref<1xi512, "stream2">, %arg5: memref<1xi128, "stream">, %arg6: memref<1xi512, "stream2">, %arg7: memref<1xi128, "stream">, %arg8: memref<1xi512, "stream2">, %arg9: memref<1xi128, "stream">, %arg10: memref<1xi512, "stream2">, %arg11: memref<1xi128, "stream">, %arg12: memref<1xi512, "stream2">, %arg13: memref<1xi128, "stream">, %arg14: memref<1xi512, "stream2">, %arg15: memref<1xi128, "stream">, %arg16: memref<1xi512, "stream2">, %arg17: memref<1xi128, "stream">, %arg18: memref<1xi512, "stream2">, %arg19: memref<1xi128, "stream">, %arg20: memref<1xi512, "stream2">, %arg21: memref<1xi128, "stream">, %arg22: memref<1xi512, "stream2">, %arg23: memref<1xi128, "stream">) attributes {adf.pl, inline = false} {
    call @load1_11(%arg0, %arg1) {template = 0 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg2, %arg3) {template = 1 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg4, %arg5) {template = 2 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg6, %arg7) {template = 3 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg8, %arg9) {template = 4 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg10, %arg11) {template = 5 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg12, %arg13) {template = 6 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg14, %arg15) {template = 7 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg16, %arg17) {template = 8 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg18, %arg19) {template = 9 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg20, %arg21) {template = 10 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_11(%arg22, %arg23) {template = 11 : index} : (memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @mttkrp_pl(%arg0: memref<64x768x128xi512>, %arg1: memref<768x384xi512>, %arg2: memref<2048x384xi512>, %arg3: memref<64x384xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "plio">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "plio">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "plio">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "plio">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "plio">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "plio">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "plio">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "plio">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "plio">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "plio">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "plio">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "plio">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "plio">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "plio">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "plio">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "plio">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "plio">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "plio">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "plio">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "plio">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "plio">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "plio">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "plio">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "plio">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "plio">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "plio">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "plio">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "plio">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "plio">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "plio">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "plio">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "plio">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "plio">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "plio">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "plio">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "plio">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "plio">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "plio">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "plio">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "plio">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "plio">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "plio">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "plio">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "plio">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "plio">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "plio">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "plio">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "plio">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "plio">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "plio">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "plio">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "plio">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "plio">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "plio">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "plio">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "plio">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "plio">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "plio">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "plio">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "plio">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "plio">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "plio">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "plio">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "plio">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "plio">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "plio">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "plio">) attributes {adf.pl = true, dataflow, inline = false, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
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
    %alloc_147 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_148 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_149 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_150 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_151 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_152 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_153 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_154 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_155 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_156 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_157 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_158 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_159 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_160 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_161 = memref.alloc() : memref<1xi512, "stream2">
    %alloc_162 = memref.alloc() : memref<1xi512, "stream2">
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
    call @receive13_top(%arg143, %alloc_12, %arg27, %alloc_26, %arg96, %alloc_1, %arg68, %alloc_41, %arg57, %alloc_11, %arg103, %alloc_92, %arg41, %alloc_43, %arg15, %alloc_86, %arg122, %alloc_72, %arg94, %alloc_91, %arg65, %alloc_62, %arg140, %alloc_9, %arg125, %alloc_50, %arg67, %alloc_94, %arg6, %alloc_93, %arg95, %alloc, %arg52, %alloc_60, %arg39, %alloc_55, %arg5, %alloc_23, %arg70, %alloc_52, %arg139, %alloc_71, %arg150, %alloc_57, %arg58, %alloc_61, %arg144, %alloc_30, %arg88, %alloc_42, %arg98, %alloc_44, %arg29, %alloc_28, %arg7, %alloc_73, %arg119, %alloc_79, %arg135, %alloc_53, %arg151, %alloc_20, %arg38, %alloc_76, %arg50, %alloc_49, %arg149, %alloc_78, %arg124, %alloc_58, %arg108, %alloc_16, %arg23, %alloc_54, %arg141, %alloc_51, %arg48, %alloc_68, %arg82, %alloc_38, %arg114, %alloc_7, %arg54, %alloc_83, %arg51, %alloc_59, %arg115, %alloc_46, %arg105, %alloc_17, %arg145, %alloc_70, %arg34, %alloc_74, %arg110, %alloc_8, %arg66, %alloc_90, %arg99, %alloc_39, %arg14, %alloc_14, %arg84, %alloc_47, %arg16, %alloc_19, %arg136, %alloc_18, %arg148, %alloc_37, %arg20, %alloc_40, %arg111, %alloc_88, %arg134, %alloc_13, %arg44, %alloc_48, %arg107, %alloc_0, %arg102, %alloc_21, %arg78, %alloc_69, %arg72, %alloc_36, %arg87, %alloc_32, %arg42, %alloc_45, %arg109, %alloc_15, %arg56, %alloc_34, %arg55, %alloc_4, %arg133, %alloc_77, %arg30, %alloc_2, %arg85, %alloc_65, %arg21, %alloc_27, %arg123, %alloc_10, %arg128, %alloc_5, %arg69, %alloc_84, %arg142, %alloc_82, %arg71, %alloc_33, %arg112, %alloc_6, %arg126, %alloc_56, %arg90, %alloc_81, %arg81, %alloc_64, %arg74, %alloc_66, %arg118, %alloc_75, %arg147, %alloc_22, %arg40, %alloc_89, %arg49, %alloc_67, %arg86, %alloc_85, %arg127, %alloc_63, %arg10, %alloc_29, %arg47, %alloc_35, %arg12, %alloc_87, %arg106, %alloc_3, %arg43, %alloc_24, %arg60, %alloc_25, %arg93, %alloc_31, %arg121, %alloc_80) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send29_top(%arg62, %alloc_117, %arg131, %alloc_129, %arg117, %alloc_120, %arg53, %alloc_114, %arg100, %alloc_126, %arg101, %alloc_138, %arg11, %alloc_123, %arg37, %alloc_135, %arg45, %alloc_111, %arg26, %alloc_132, %arg63, %alloc_141, %arg138, %alloc_145) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send21_top(%arg13, %alloc_125, %arg132, %alloc_124, %arg64, %alloc_116, %arg129, %alloc_140, %arg79, %alloc_122, %arg76, %alloc_127, %arg18, %alloc_118, %arg33, %alloc_133, %arg25, %alloc_119, %arg24, %alloc_134, %arg19, %alloc_144, %arg91, %alloc_131, %arg46, %alloc_130, %arg77, %alloc_121, %arg75, %alloc_128, %arg116, %alloc_115, %arg31, %alloc_142, %arg36, %alloc_139, %arg4, %alloc_110, %arg104, %alloc_137, %arg92, %alloc_136, %arg120, %alloc_112, %arg89, %alloc_113, %arg137, %alloc_109) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @send39_top(%arg32, %alloc_107, %arg113, %alloc_100, %arg73, %alloc_103, %arg9, %alloc_98, %arg28, %alloc_97, %arg35, %alloc_143, %arg146, %alloc_96, %arg8, %alloc_108, %arg130, %alloc_104, %arg61, %alloc_146, %arg22, %alloc_101, %arg80, %alloc_99, %arg59, %alloc_106, %arg83, %alloc_102, %arg97, %alloc_95, %arg17, %alloc_105) : (memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">, memref<1xi128, "plio">, memref<1xi128, "stream">) -> ()
    call @store0_0_top(%alloc, %alloc_147, %alloc_0, %alloc_148, %alloc_1, %alloc_149, %alloc_2, %alloc_150, %alloc_3, %alloc_151, %alloc_4, %alloc_152, %alloc_5, %alloc_153, %alloc_6, %alloc_154, %alloc_7, %alloc_155, %alloc_8, %alloc_156, %alloc_9, %alloc_157, %alloc_10, %alloc_158, %alloc_11, %alloc_159, %alloc_12, %alloc_160, %alloc_13, %alloc_161, %alloc_14, %alloc_162, %alloc_15, %alloc_163, %alloc_16, %alloc_164, %alloc_17, %alloc_165, %alloc_18, %alloc_166, %alloc_19, %alloc_167, %alloc_20, %alloc_168, %alloc_21, %alloc_169, %alloc_22, %alloc_170, %alloc_23, %alloc_171, %alloc_24, %alloc_172, %alloc_25, %alloc_173, %alloc_26, %alloc_174, %alloc_27, %alloc_175, %alloc_28, %alloc_176, %alloc_29, %alloc_177, %alloc_30, %alloc_178, %alloc_31, %alloc_179, %alloc_32, %alloc_180, %alloc_33, %alloc_181, %alloc_34, %alloc_182, %alloc_35, %alloc_183, %alloc_36, %alloc_184, %alloc_37, %alloc_185, %alloc_38, %alloc_186, %alloc_39, %alloc_187, %alloc_40, %alloc_188, %alloc_41, %alloc_189, %alloc_42, %alloc_190, %alloc_43, %alloc_191, %alloc_44, %alloc_192, %alloc_45, %alloc_193, %alloc_46, %alloc_194, %alloc_47, %alloc_195, %alloc_48, %alloc_196, %alloc_49, %alloc_197, %alloc_50, %alloc_198, %alloc_51, %alloc_199, %alloc_52, %alloc_200, %alloc_53, %alloc_201, %alloc_54, %alloc_202, %alloc_55, %alloc_203, %alloc_56, %alloc_204, %alloc_57, %alloc_205, %alloc_58, %alloc_206, %alloc_59, %alloc_207, %alloc_60, %alloc_208, %alloc_61, %alloc_209, %alloc_62, %alloc_210, %alloc_63, %alloc_211, %alloc_64, %alloc_212, %alloc_65, %alloc_213, %alloc_66, %alloc_214, %alloc_67, %alloc_215, %alloc_68, %alloc_216, %alloc_69, %alloc_217, %alloc_70, %alloc_218, %alloc_71, %alloc_219, %alloc_72, %alloc_220, %alloc_73, %alloc_221, %alloc_74, %alloc_222, %alloc_75, %alloc_223, %alloc_76, %alloc_224, %alloc_77, %alloc_225, %alloc_78, %alloc_226, %alloc_79, %alloc_227, %alloc_80, %alloc_228, %alloc_81, %alloc_229, %alloc_82, %alloc_230, %alloc_83, %alloc_231, %alloc_84, %alloc_232, %alloc_85, %alloc_233, %alloc_86, %alloc_234, %alloc_87, %alloc_235, %alloc_88, %alloc_236, %alloc_89, %alloc_237, %alloc_90, %alloc_238, %alloc_91, %alloc_239, %alloc_92, %alloc_240, %alloc_93, %alloc_241, %alloc_94, %alloc_242) : (memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">) -> ()
    call @store0_top(%arg3, %alloc_195, %alloc_192, %alloc_166, %alloc_212, %alloc_163, %alloc_180, %alloc_215, %alloc_200, %alloc_217, %alloc_167, %alloc_171, %alloc_154, %alloc_155, %alloc_219, %alloc_172, %alloc_182, %alloc_184, %alloc_159, %alloc_234, %alloc_152, %alloc_220, %alloc_237, %alloc_230, %alloc_228, %alloc_211, %alloc_240, %alloc_181, %alloc_162, %alloc_186, %alloc_147, %alloc_158, %alloc_194, %alloc_241, %alloc_179, %alloc_197, %alloc_204, %alloc_210, %alloc_151, %alloc_153, %alloc_238, %alloc_160, %alloc_223, %alloc_201, %alloc_168, %alloc_206, %alloc_156, %alloc_205, %alloc_178, %alloc_187, %alloc_208, %alloc_229, %alloc_150, %alloc_231, %alloc_232, %alloc_218, %alloc_175, %alloc_199, %alloc_242, %alloc_188, %alloc_235, %alloc_226, %alloc_190, %alloc_173, %alloc_207, %alloc_189, %alloc_202, %alloc_183, %alloc_216, %alloc_165, %alloc_196, %alloc_236, %alloc_161, %alloc_176, %alloc_214, %alloc_170, %alloc_198, %alloc_203, %alloc_221, %alloc_149, %alloc_191, %alloc_222, %alloc_213, %alloc_169, %alloc_193, %alloc_209, %alloc_227, %alloc_239, %alloc_224, %alloc_148, %alloc_157, %alloc_164, %alloc_185, %alloc_174, %alloc_233, %alloc_225, %alloc_177) : (memref<64x384xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load0_top(%arg0, %alloc_258, %alloc_256, %alloc_251, %alloc_257, %alloc_243, %alloc_244, %alloc_254, %alloc_246, %alloc_245, %alloc_248, %alloc_255, %alloc_247, %alloc_249, %alloc_252, %alloc_253, %alloc_250) : (memref<64x768x128xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load0_15_top(%alloc_258, %alloc_146, %alloc_257, %alloc_143, %alloc_256, %alloc_108, %alloc_255, %alloc_107, %alloc_254, %alloc_106, %alloc_253, %alloc_105, %alloc_252, %alloc_104, %alloc_251, %alloc_103, %alloc_250, %alloc_102, %alloc_249, %alloc_101, %alloc_248, %alloc_100, %alloc_247, %alloc_99, %alloc_246, %alloc_98, %alloc_245, %alloc_97, %alloc_244, %alloc_96, %alloc_243, %alloc_95) : (memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load2_top(%arg2, %alloc_262, %alloc_265, %alloc_271, %alloc_280, %alloc_266, %alloc_274, %alloc_270, %alloc_261, %alloc_273, %alloc_260, %alloc_263, %alloc_259, %alloc_269, %alloc_279, %alloc_276, %alloc_277, %alloc_268, %alloc_278, %alloc_264, %alloc_267, %alloc_282, %alloc_272, %alloc_281, %alloc_275) : (memref<2048x384xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load2_23_top(%alloc_282, %alloc_144, %alloc_281, %alloc_142, %alloc_280, %alloc_140, %alloc_279, %alloc_139, %alloc_278, %alloc_137, %alloc_277, %alloc_136, %alloc_276, %alloc_134, %alloc_275, %alloc_133, %alloc_274, %alloc_131, %alloc_273, %alloc_130, %alloc_272, %alloc_128, %alloc_271, %alloc_127, %alloc_270, %alloc_125, %alloc_269, %alloc_124, %alloc_268, %alloc_122, %alloc_267, %alloc_121, %alloc_266, %alloc_119, %alloc_265, %alloc_118, %alloc_264, %alloc_116, %alloc_263, %alloc_115, %alloc_262, %alloc_113, %alloc_261, %alloc_112, %alloc_260, %alloc_110, %alloc_259, %alloc_109) : (memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    call @load1_top(%arg1, %alloc_287, %alloc_293, %alloc_294, %alloc_286, %alloc_284, %alloc_290, %alloc_285, %alloc_283, %alloc_291, %alloc_289, %alloc_292, %alloc_288) : (memref<768x384xi512>, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">, memref<1xi512, "stream2">) -> ()
    call @load1_11_top(%alloc_294, %alloc_145, %alloc_293, %alloc_141, %alloc_292, %alloc_138, %alloc_291, %alloc_135, %alloc_290, %alloc_132, %alloc_289, %alloc_129, %alloc_288, %alloc_126, %alloc_287, %alloc_123, %alloc_286, %alloc_120, %alloc_285, %alloc_117, %alloc_284, %alloc_114, %alloc_283, %alloc_111) : (memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">, memref<1xi512, "stream2">, memref<1xi128, "stream">) -> ()
    return
  }
  func.func @mttkrp(%arg0: memref<64x768x128xi512>, %arg1: memref<768x384xi512>, %arg2: memref<2048x384xi512>, %arg3: memref<64x384xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "plio">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "plio">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "plio">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "plio">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "plio">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "plio">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "plio">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "plio">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "plio">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "plio">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "plio">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "plio">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "plio">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "plio">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "plio">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "plio">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "plio">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "plio">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "plio">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "plio">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "plio">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "plio">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "plio">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "plio">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "plio">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "plio">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "plio">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "plio">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "plio">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "plio">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "plio">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "plio">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "plio">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "plio">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "plio">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "plio">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "plio">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "plio">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "plio">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "plio">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "plio">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "plio">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "plio">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "plio">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "plio">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "plio">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "plio">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "plio">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "plio">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "plio">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "plio">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "plio">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "plio">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "plio">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "plio">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "plio">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "plio">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "plio">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "plio">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "plio">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "plio">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "plio">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "plio">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "plio">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "plio">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "plio">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "plio">) attributes {adf.func, plio = true} {
    %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%0, %arg67) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%1, %arg6) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %2 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%2, %arg103) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %3 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%3, %arg94) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%4, %arg66) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %5 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%5, %arg40) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %6 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%6, %arg111) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %7 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%7, %arg12) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %8 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%8, %arg15) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %9 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%9, %arg86) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %10 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%10, %arg69) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %11 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%11, %arg54) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %12 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg97, %12) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %13 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg146, %13) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %14 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%14, %arg142) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %15 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%15, %arg90) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %16 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%16, %arg121) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %17 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%17, %arg119) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %18 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%18, %arg149) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %19 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%19, %arg133) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %20 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%20, %arg38) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %21 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%21, %arg118) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %22 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%22, %arg34) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %23 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%23, %arg7) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %24 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%24, %arg122) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %25 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%25, %arg139) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %26 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg28, %26) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %27 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg9, %27) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %28 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%28, %arg145) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %29 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%29, %arg78) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %30 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%30, %arg48) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %31 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%31, %arg49) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %32 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%32, %arg74) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %33 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%33, %arg85) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %34 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%34, %arg81) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %35 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%35, %arg127) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %36 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%36, %arg65) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %37 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%37, %arg58) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %38 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%38, %arg52) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %39 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%39, %arg51) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %40 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg80, %40) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %41 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg113, %41) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %42 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%42, %arg124) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %43 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%43, %arg150) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %44 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%44, %arg126) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %45 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%45, %arg39) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %46 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%46, %arg23) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %47 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%47, %arg135) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %48 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%48, %arg70) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %49 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%49, %arg141) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %50 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%50, %arg125) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %51 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%51, %arg50) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %52 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%52, %arg44) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %53 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%53, %arg84) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %54 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg22, %54) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %55 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg83, %55) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %56 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%56, %arg115) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %57 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%57, %arg42) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %58 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%58, %arg98) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %59 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%59, %arg41) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %60 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%60, %arg88) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %61 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%61, %arg68) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %62 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%62, %arg20) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %63 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%63, %arg99) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %64 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%64, %arg82) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %65 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%65, %arg148) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %66 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%66, %arg72) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %67 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%67, %arg47) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %68 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg73, %68) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %69 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg130, %69) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %70 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%70, %arg56) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %71 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%71, %arg71) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %72 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%72, %arg87) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %73 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%73, %arg93) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %74 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%74, %arg144) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %75 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%75, %arg10) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %76 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%76, %arg29) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %77 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%77, %arg21) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %78 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%78, %arg27) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %79 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%79, %arg60) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %80 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%80, %arg43) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %81 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%81, %arg5) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %82 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg17, %82) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %83 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg59, %83) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %84 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%84, %arg147) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %85 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%85, %arg102) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %86 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%86, %arg151) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %87 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%87, %arg16) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %88 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%88, %arg136) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %89 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%89, %arg105) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %90 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%90, %arg108) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %91 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%91, %arg109) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %92 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%92, %arg14) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %93 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%93, %arg134) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %94 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%94, %arg143) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %95 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%95, %arg57) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %96 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg32, %96) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %97 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg8, %97) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %98 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%98, %arg123) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %99 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg137, %99) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %100 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg4, %100) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %101 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg45, %101) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %102 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%102, %arg140) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %103 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg120, %103) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %104 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg89, %104) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %105 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg53, %105) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %106 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%106, %arg110) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %107 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg116, %107) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %108 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg64, %108) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %109 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg62, %109) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %110 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%110, %arg114) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %111 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg18, %111) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %112 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg25, %112) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %113 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg117, %113) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %114 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%114, %arg112) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %115 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg77, %115) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %116 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg79, %116) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %117 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg11, %117) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %118 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%118, %arg128) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %119 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg132, %119) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %120 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg13, %120) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %121 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg100, %121) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %122 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%122, %arg55) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %123 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg76, %123) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %124 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg75, %124) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %125 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg131, %125) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %126 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%126, %arg106) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %127 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg46, %127) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %128 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg91, %128) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %129 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg26, %129) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %130 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%130, %arg30) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %131 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg33, %131) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %132 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg24, %132) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %133 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg37, %133) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %134 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%134, %arg96) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %135 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg92, %135) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %136 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg104, %136) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %137 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg101, %137) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %138 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%138, %arg107) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %139 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg36, %139) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %140 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg129, %140) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %141 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg63, %141) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %142 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    adf.connect(%142, %arg95) {top_config} : (!adf.plio<Out, 128>, memref<1xi128, "plio">)
    %143 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg31, %143) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %144 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg35, %144) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %145 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg19, %145) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %146 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg138, %146) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    %147 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.connect(%arg61, %147) {top_config} : (memref<1xi128, "plio">, !adf.plio<In, 128>)
    adf.cell.launch @adf_cell0 {
      func.call @adf_cell0(%147, %146, %145, %144, %143, %142, %141, %140, %139, %138, %137, %136, %135, %134, %133, %132, %131, %130, %129, %128, %127, %126, %125, %124, %123, %122, %121, %120, %119, %118, %117, %116, %115, %114, %113, %112, %111, %110, %109, %108, %107, %106, %105, %104, %103, %102, %101, %100, %99, %98, %97, %96, %95, %94, %93, %92, %91, %90, %89, %88, %87, %86, %85, %84, %83, %82, %81, %80, %79, %78, %77, %76, %75, %74, %73, %72, %71, %70, %69, %68, %67, %66, %65, %64, %63, %62, %61, %60, %59, %58, %57, %56, %55, %54, %53, %52, %51, %50, %49, %48, %47, %46, %45, %44, %43, %42, %41, %40, %39, %38, %37, %36, %35, %34, %33, %32, %31, %30, %29, %28, %27, %26, %25, %24, %23, %22, %21, %20, %19, %18, %17, %16, %15, %14, %13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
      adf.cell.launch.end
    }
    adf.pl.launch @mttkrp_pl {
      func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44, %arg45, %arg46, %arg47, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68, %arg69, %arg70, %arg71, %arg72, %arg73, %arg74, %arg75, %arg76, %arg77, %arg78, %arg79, %arg80, %arg81, %arg82, %arg83, %arg84, %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96, %arg97, %arg98, %arg99, %arg100, %arg101, %arg102, %arg103, %arg104, %arg105, %arg106, %arg107, %arg108, %arg109, %arg110, %arg111, %arg112, %arg113, %arg114, %arg115, %arg116, %arg117, %arg118, %arg119, %arg120, %arg121, %arg122, %arg123, %arg124, %arg125, %arg126, %arg127, %arg128, %arg129, %arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145, %arg146, %arg147, %arg148, %arg149, %arg150, %arg151) {adf.pl} : (memref<64x768x128xi512>, memref<768x384xi512>, memref<2048x384xi512>, memref<64x384xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
      adf.pl.launch.wait
    }
    return
  }
  func.func @top(%arg0: memref<64x768x128xi512>, %arg1: memref<768x384xi512>, %arg2: memref<2048x384xi512>, %arg3: memref<64x384xi512>, %arg4: memref<1xi128, "plio">, %arg5: memref<1xi128, "plio">, %arg6: memref<1xi128, "plio">, %arg7: memref<1xi128, "plio">, %arg8: memref<1xi128, "plio">, %arg9: memref<1xi128, "plio">, %arg10: memref<1xi128, "plio">, %arg11: memref<1xi128, "plio">, %arg12: memref<1xi128, "plio">, %arg13: memref<1xi128, "plio">, %arg14: memref<1xi128, "plio">, %arg15: memref<1xi128, "plio">, %arg16: memref<1xi128, "plio">, %arg17: memref<1xi128, "plio">, %arg18: memref<1xi128, "plio">, %arg19: memref<1xi128, "plio">, %arg20: memref<1xi128, "plio">, %arg21: memref<1xi128, "plio">, %arg22: memref<1xi128, "plio">, %arg23: memref<1xi128, "plio">, %arg24: memref<1xi128, "plio">, %arg25: memref<1xi128, "plio">, %arg26: memref<1xi128, "plio">, %arg27: memref<1xi128, "plio">, %arg28: memref<1xi128, "plio">, %arg29: memref<1xi128, "plio">, %arg30: memref<1xi128, "plio">, %arg31: memref<1xi128, "plio">, %arg32: memref<1xi128, "plio">, %arg33: memref<1xi128, "plio">, %arg34: memref<1xi128, "plio">, %arg35: memref<1xi128, "plio">, %arg36: memref<1xi128, "plio">, %arg37: memref<1xi128, "plio">, %arg38: memref<1xi128, "plio">, %arg39: memref<1xi128, "plio">, %arg40: memref<1xi128, "plio">, %arg41: memref<1xi128, "plio">, %arg42: memref<1xi128, "plio">, %arg43: memref<1xi128, "plio">, %arg44: memref<1xi128, "plio">, %arg45: memref<1xi128, "plio">, %arg46: memref<1xi128, "plio">, %arg47: memref<1xi128, "plio">, %arg48: memref<1xi128, "plio">, %arg49: memref<1xi128, "plio">, %arg50: memref<1xi128, "plio">, %arg51: memref<1xi128, "plio">, %arg52: memref<1xi128, "plio">, %arg53: memref<1xi128, "plio">, %arg54: memref<1xi128, "plio">, %arg55: memref<1xi128, "plio">, %arg56: memref<1xi128, "plio">, %arg57: memref<1xi128, "plio">, %arg58: memref<1xi128, "plio">, %arg59: memref<1xi128, "plio">, %arg60: memref<1xi128, "plio">, %arg61: memref<1xi128, "plio">, %arg62: memref<1xi128, "plio">, %arg63: memref<1xi128, "plio">, %arg64: memref<1xi128, "plio">, %arg65: memref<1xi128, "plio">, %arg66: memref<1xi128, "plio">, %arg67: memref<1xi128, "plio">, %arg68: memref<1xi128, "plio">, %arg69: memref<1xi128, "plio">, %arg70: memref<1xi128, "plio">, %arg71: memref<1xi128, "plio">, %arg72: memref<1xi128, "plio">, %arg73: memref<1xi128, "plio">, %arg74: memref<1xi128, "plio">, %arg75: memref<1xi128, "plio">, %arg76: memref<1xi128, "plio">, %arg77: memref<1xi128, "plio">, %arg78: memref<1xi128, "plio">, %arg79: memref<1xi128, "plio">, %arg80: memref<1xi128, "plio">, %arg81: memref<1xi128, "plio">, %arg82: memref<1xi128, "plio">, %arg83: memref<1xi128, "plio">, %arg84: memref<1xi128, "plio">, %arg85: memref<1xi128, "plio">, %arg86: memref<1xi128, "plio">, %arg87: memref<1xi128, "plio">, %arg88: memref<1xi128, "plio">, %arg89: memref<1xi128, "plio">, %arg90: memref<1xi128, "plio">, %arg91: memref<1xi128, "plio">, %arg92: memref<1xi128, "plio">, %arg93: memref<1xi128, "plio">, %arg94: memref<1xi128, "plio">, %arg95: memref<1xi128, "plio">, %arg96: memref<1xi128, "plio">, %arg97: memref<1xi128, "plio">, %arg98: memref<1xi128, "plio">, %arg99: memref<1xi128, "plio">, %arg100: memref<1xi128, "plio">, %arg101: memref<1xi128, "plio">, %arg102: memref<1xi128, "plio">, %arg103: memref<1xi128, "plio">, %arg104: memref<1xi128, "plio">, %arg105: memref<1xi128, "plio">, %arg106: memref<1xi128, "plio">, %arg107: memref<1xi128, "plio">, %arg108: memref<1xi128, "plio">, %arg109: memref<1xi128, "plio">, %arg110: memref<1xi128, "plio">, %arg111: memref<1xi128, "plio">, %arg112: memref<1xi128, "plio">, %arg113: memref<1xi128, "plio">, %arg114: memref<1xi128, "plio">, %arg115: memref<1xi128, "plio">, %arg116: memref<1xi128, "plio">, %arg117: memref<1xi128, "plio">, %arg118: memref<1xi128, "plio">, %arg119: memref<1xi128, "plio">, %arg120: memref<1xi128, "plio">, %arg121: memref<1xi128, "plio">, %arg122: memref<1xi128, "plio">, %arg123: memref<1xi128, "plio">, %arg124: memref<1xi128, "plio">, %arg125: memref<1xi128, "plio">, %arg126: memref<1xi128, "plio">, %arg127: memref<1xi128, "plio">, %arg128: memref<1xi128, "plio">, %arg129: memref<1xi128, "plio">, %arg130: memref<1xi128, "plio">, %arg131: memref<1xi128, "plio">, %arg132: memref<1xi128, "plio">, %arg133: memref<1xi128, "plio">, %arg134: memref<1xi128, "plio">, %arg135: memref<1xi128, "plio">, %arg136: memref<1xi128, "plio">, %arg137: memref<1xi128, "plio">, %arg138: memref<1xi128, "plio">, %arg139: memref<1xi128, "plio">, %arg140: memref<1xi128, "plio">, %arg141: memref<1xi128, "plio">, %arg142: memref<1xi128, "plio">, %arg143: memref<1xi128, "plio">, %arg144: memref<1xi128, "plio">, %arg145: memref<1xi128, "plio">, %arg146: memref<1xi128, "plio">, %arg147: memref<1xi128, "plio">, %arg148: memref<1xi128, "plio">, %arg149: memref<1xi128, "plio">, %arg150: memref<1xi128, "plio">, %arg151: memref<1xi128, "plio">) attributes {outArgs = [3 : i32], top_func = "plio"} {
    call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21, %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29, %arg30, %arg31, %arg32, %arg33, %arg34, %arg35, %arg36, %arg37, %arg38, %arg39, %arg40, %arg41, %arg42, %arg43, %arg44, %arg45, %arg46, %arg47, %arg48, %arg49, %arg50, %arg51, %arg52, %arg53, %arg54, %arg55, %arg56, %arg57, %arg58, %arg59, %arg60, %arg61, %arg62, %arg63, %arg64, %arg65, %arg66, %arg67, %arg68, %arg69, %arg70, %arg71, %arg72, %arg73, %arg74, %arg75, %arg76, %arg77, %arg78, %arg79, %arg80, %arg81, %arg82, %arg83, %arg84, %arg85, %arg86, %arg87, %arg88, %arg89, %arg90, %arg91, %arg92, %arg93, %arg94, %arg95, %arg96, %arg97, %arg98, %arg99, %arg100, %arg101, %arg102, %arg103, %arg104, %arg105, %arg106, %arg107, %arg108, %arg109, %arg110, %arg111, %arg112, %arg113, %arg114, %arg115, %arg116, %arg117, %arg118, %arg119, %arg120, %arg121, %arg122, %arg123, %arg124, %arg125, %arg126, %arg127, %arg128, %arg129, %arg130, %arg131, %arg132, %arg133, %arg134, %arg135, %arg136, %arg137, %arg138, %arg139, %arg140, %arg141, %arg142, %arg143, %arg144, %arg145, %arg146, %arg147, %arg148, %arg149, %arg150, %arg151) : (memref<64x768x128xi512>, memref<768x384xi512>, memref<2048x384xi512>, memref<64x384xi512>, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">, memref<1xi128, "plio">) -> ()
    return
  }
  func.func private @mttkrp_host(memref<64x768x2048xf32>, memref<768x6144xf32>, memref<2048x6144xf32>, memref<64x6144xf32>) attributes {origin_func = "mttkrp"}
  func.func @top_host(%arg0: memref<64x768x2048xf32>, %arg1: memref<768x6144xf32>, %arg2: memref<2048x6144xf32>, %arg3: memref<64x6144xf32>) attributes {origin_func = "top", outArgs = [3 : i32], top_host} {
    call @mttkrp_host(%arg0, %arg1, %arg2, %arg3) {origin_func = "mttkrp"} : (memref<64x768x2048xf32>, memref<768x6144xf32>, memref<2048x6144xf32>, memref<64x6144xf32>) -> ()
    return
  }
}

