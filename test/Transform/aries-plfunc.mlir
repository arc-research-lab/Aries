// RUN: aries-opt -aries-pl-func-extract -cse -canonicalize %s | FileCheck %s

// CHECK: #map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
// CHECK: #map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
// CHECK: #map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
// CHECK: #map3 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16 + 4)>
// CHECK: #map4 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
// CHECK: #map5 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
// CHECK: module {
// CHECK:   func.func private @adf_cell0(!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]}
// CHECK:   func.func @mttkrp_pl(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>, %arg4: !adf.plio<Out, 128>, %arg5: !adf.plio<Out, 128>, %arg6: !adf.plio<In, 128>, %arg7: !adf.plio<In, 128>, %arg8: !adf.plio<Out, 128>, %arg9: !adf.plio<In, 128>, %arg10: !adf.plio<In, 128>, %arg11: !adf.plio<In, 128>, %arg12: !adf.plio<Out, 128>, %arg13: !adf.plio<In, 128>, %arg14: !adf.plio<In, 128>, %arg15: !adf.plio<In, 128>, %arg16: !adf.plio<In, 128>, %arg17: !adf.plio<In, 128>) attributes {adf.pl = true, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32]} {
// CHECK:     %c2 = arith.constant 2 : index
// CHECK:     %c1 = arith.constant 1 : index
// CHECK:     %c8 = arith.constant 8 : index
// CHECK:     %c16 = arith.constant 16 : index
// CHECK:     %c4 = arith.constant 4 : index
// CHECK:     affine.for %arg18 = 0 to 1 {
// CHECK:       affine.for %arg19 = 0 to 2 {
// CHECK:         affine.for %arg20 = 0 to 2 {
// CHECK:           affine.for %arg21 = 0 to 2 {
// CHECK:             affine.for %arg22 = 0 to 2 {
// CHECK:               affine.for %arg23 = 0 to 2 {
// CHECK:                 affine.for %arg24 = 0 to 2 {
// CHECK:                   affine.for %arg25 = 0 to 2 {
// CHECK:                     %0 = affine.apply #map(%arg22, %arg18)
// CHECK:                     %1 = affine.apply #map1(%arg24, %arg20)
// CHECK:                     %2 = affine.apply #map1(%arg25, %arg21)
// CHECK:                     %3 = affine.apply #map2(%arg25, %arg21)
// CHECK:                     adf.io.push(%arg0[%0, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg17) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                     %4 = affine.apply #map1(%arg23, %arg19)
// CHECK:                     adf.io.push(%arg1[%1, %4] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg16) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
// CHECK:                     adf.io.push(%arg2[%3, %4] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg15) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                     %5 = affine.apply #map3(%arg25, %arg21)
// CHECK:                     %6 = affine.apply #map4(%arg25, %arg21)
// CHECK:                     adf.io.push(%arg0[%0, %1, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg14) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                     adf.io.push(%arg2[%6, %4] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg13) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                     %7 = affine.apply #map3(%arg23, %arg19)
// CHECK:                     adf.io.push(%arg1[%1, %7] [%c8, %c4] [%c1, %c1] [] [] [] [], %arg11) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
// CHECK:                     adf.io.push(%arg2[%3, %7] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg10) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                     adf.io.push(%arg2[%6, %7] [%c16, %c4] [%c1, %c1] [] [] [] [], %arg9) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
// CHECK:                     %8 = affine.apply #map5(%arg22, %arg18)
// CHECK:                     adf.io.push(%arg0[%8, %1, %2] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg7) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                     adf.io.push(%arg0[%8, %1, %5] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %arg6) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
// CHECK:                     adf.io.pop(%arg12, %arg3[%0, %4] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
// CHECK:                     adf.io.pop(%arg8, %arg3[%0, %7] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
// CHECK:                     adf.io.pop(%arg5, %arg3[%8, %4] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
// CHECK:                     adf.io.pop(%arg4, %arg3[%8, %7] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
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
// CHECK:   func.func @mttkrp(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
// CHECK:     %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     %2 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %3 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     %5 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %6 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %7 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %8 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
// CHECK:     %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %12 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     %13 = adf.graph.io(PLIO) : !adf.plio<In, 128>
// CHECK:     adf.cell.launch @adf_cell0 {
// CHECK:       func.call @adf_cell0(%13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
// CHECK:       adf.cell.launch.end
// CHECK:     }
// CHECK:     adf.pl.launch @mttkrp_pl {
// CHECK:       func.call @mttkrp_pl(%arg0, %arg1, %arg2, %arg3, %0, %1, %2, %3, %4, %5, %6, %7, %8, %9, %10, %11, %12, %13) {adf.pl} : (memref<8x32x32xi128>, memref<32x32xi128>, memref<128x32xi128>, memref<8x32xi128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>) -> ()
// CHECK:       adf.pl.launch.wait
// CHECK:     }
// CHECK:     return
// CHECK:   }
// CHECK: }


#map = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8)>
#map1 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16)>
#map2 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64)>
#map3 = affine_map<(d0, d1) -> (d0 * 8 + d1 * 16 + 4)>
#map4 = affine_map<(d0, d1) -> (d0 * 32 + d1 * 64 + 16)>
#map5 = affine_map<(d0, d1) -> (d0 * 4 + d1 * 8 + 2)>
module {
  func.func private @adf_cell0(!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) attributes {adf.cell, tripCount = [2 : index, 2 : index, 2 : index]}
  func.func @mttkrp(%arg0: memref<8x32x32xi128>, %arg1: memref<32x32xi128>, %arg2: memref<128x32xi128>, %arg3: memref<8x32xi128>) attributes {adf.func, mem_idx = [0 : i32, 1 : i32, 2 : i32, 3 : i32], mem_type = [f32, f32, f32, f32], plio = true} {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c16 = arith.constant 16 : index
    %c4 = arith.constant 4 : index
    %0 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %1 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %2 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %3 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %4 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %5 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %6 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %7 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %8 = adf.graph.io(PLIO) : !adf.plio<Out, 128>
    %9 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %10 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %11 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %12 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    %13 = adf.graph.io(PLIO) : !adf.plio<In, 128>
    adf.cell.launch @adf_cell0 {
      affine.for %arg4 = 0 to 1 {
        affine.for %arg5 = 0 to 2 {
          affine.for %arg6 = 0 to 2 {
            affine.for %arg7 = 0 to 2 {
              affine.for %arg8 = 0 to 2 {
                affine.for %arg9 = 0 to 2 {
                  affine.for %arg10 = 0 to 2 {
                    affine.for %arg11 = 0 to 2 {
                      %14 = affine.apply #map(%arg8, %arg4)
                      %15 = affine.apply #map1(%arg10, %arg6)
                      %16 = affine.apply #map1(%arg11, %arg7)
                      %17 = affine.apply #map2(%arg11, %arg7)
                      adf.io.push(%arg0[%14, %15, %16] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %13) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                      %18 = affine.apply #map1(%arg9, %arg5)
                      adf.io.push(%arg1[%15, %18] [%c8, %c4] [%c1, %c1] [] [] [] [], %12) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
                      adf.io.push(%arg2[%17, %18] [%c16, %c4] [%c1, %c1] [] [] [] [], %11) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                      %19 = affine.apply #map3(%arg11, %arg7)
                      %20 = affine.apply #map4(%arg11, %arg7)
                      adf.io.push(%arg0[%14, %15, %19] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %10) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                      adf.io.push(%arg2[%20, %18] [%c16, %c4] [%c1, %c1] [] [] [] [], %9) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                      %21 = affine.apply #map3(%arg9, %arg5)
                      adf.io.push(%arg1[%15, %21] [%c8, %c4] [%c1, %c1] [] [] [] [], %7) {type = f32} : (memref<32x32xi128>, !adf.plio<In, 128>)
                      adf.io.push(%arg2[%17, %21] [%c16, %c4] [%c1, %c1] [] [] [] [], %6) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                      adf.io.push(%arg2[%20, %21] [%c16, %c4] [%c1, %c1] [] [] [] [], %5) {type = f32} : (memref<128x32xi128>, !adf.plio<In, 128>)
                      %22 = affine.apply #map5(%arg8, %arg4)
                      adf.io.push(%arg0[%22, %15, %16] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %3) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                      adf.io.push(%arg0[%22, %15, %19] [%c2, %c8, %c4] [%c1, %c1, %c1] [] [] [] [], %2) {type = f32} : (memref<8x32x32xi128>, !adf.plio<In, 128>)
                      func.call @adf_cell0(%13, %12, %11, %10, %9, %8, %7, %6, %5, %4, %3, %2, %1, %0) {adf.cell} : (!adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<In, 128>, !adf.plio<In, 128>, !adf.plio<Out, 128>, !adf.plio<Out, 128>) -> ()
                      adf.io.pop(%8, %arg3[%14, %18] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                      adf.io.pop(%4, %arg3[%14, %21] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                      adf.io.pop(%1, %arg3[%22, %18] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                      adf.io.pop(%0, %arg3[%22, %21] [%c2, %c4] [%c1, %c1] [] [] [] []) {accumulator, reduction = [0, 1], type = f32} : (!adf.plio<Out, 128>, memref<8x32xi128>)
                      adf.io.wait(%8) : !adf.plio<Out, 128>
                      adf.io.wait(%4) : !adf.plio<Out, 128>
                      adf.io.wait(%1) : !adf.plio<Out, 128>
                      adf.io.wait(%0) : !adf.plio<Out, 128>
                      adf.cell.launch.wait
                    } {reduction = 1 : i64}
                  } {reduction = 0 : i64}
                }
              }
            } {Array_Partition, reduction = 1 : i64}
          } {reduction = 0 : i64}
        }
      }
      adf.cell.launch.end
    }
    return
  }
}