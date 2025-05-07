module {
  func.func private @softmax(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: index, %arg3: index, %arg4: index, %arg5: index)
  func.func private @bmm_pl(%arg0: memref<?xi512>, %arg1: memref<?xi512>, %arg2: memref<?xi512>, %arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: index, %arg9: index, %arg10: index, %arg11: index, %arg12: index, %arg13: memref<1xi32, "plio">, %arg14: memref<1xi32, "plio">, %arg15: memref<1xi32, "plio">)
  func.func @top(%arg0: memref<?xi512>, %arg1: memref<?xi512>, %arg2: memref<?xi512>, %arg3: memref<?xi512>, %arg4: memref<?xi512>, %arg5: memref<?xi512>, %arg6: memref<1xi32, "plio">, %arg7: memref<1xi32, "plio">, %arg8: memref<1xi32, "plio">) attributes {outArgs = [2 : i32, 3 : i32, 5 : i32], top_func = "plio"} {
    %c64 = arith.constant 64 : index
    %c2 = arith.constant 2 : index
    %c4 = arith.constant 4 : index
    call @bmm_pl(%arg0, %arg1, %arg2, %c4, %c2, %c2, %c2, %c64, %c64, %c64, %c64, %c64, %c64, %arg6, %arg7, %arg8) : (memref<?xi512>, memref<?xi512>, memref<?xi512>, index, index, index, index, index, index, index, index, index, index, memref<1xi32, "plio">, memref<1xi32, "plio">, memref<1xi32, "plio">) -> ()
    call @softmax(%arg2, %arg3, %c64, %c64, %c64, %c64) : (memref<?xf32>, memref<?xf32>, index, index, index, index) -> ()
    call @bmm_pl(%arg3, %arg4, %arg5, %c4, %c2, %c2, %c2, %c64, %c64, %c64, %c64, %c64, %c64, %arg6, %arg7, %arg8) : (memref<?xi512>, memref<?xi512>, memref<?xi512>, index, index, index, index, index, index, index, index, index, index, memref<1xi32, "plio">, memref<1xi32, "plio">, memref<1xi32, "plio">) -> ()
    return
  }
}