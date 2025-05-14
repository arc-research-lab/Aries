#map0 = affine_map<(d0) -> (64*d0)>
#map1 = affine_map<(d0) -> (64*d0)>
#map2 = affine_map<(d0) -> (64*d0)>
module {


  func.func private @kernel_gemm(%TileA: memref<64x64xi16, 2>, %TileB: memref<64x64xi16, 2>, %TileC: memref<64x64xi16, 2>) attributes {adf.kernel}

  func.func @gemm(%A: memref<1024x1024xi16>, %B: memref<1024x1024xi16>, %C: memref<1024x1024xi16>) attributes {adf.func} {
    affine.for %i = 0 to 16 {
      affine.for %j = 0 to 16 {
        affine.for %k = 0 to 16 {
          %L1_A = adf.buffer.create @L1_L1_A() : memref<64x64xi16, 2>
          %L1_B = adf.buffer.create @L1_L1_B() : memref<64x64xi16, 2>
          %L1_C = adf.buffer.create @L1_L1_C() : memref<64x64xi16, 2>
          %v0 = affine.apply #map0(%i)
          %cti_size = arith.constant 64 : index
          %cti_stride = arith.constant 1 : index
          %v1 = affine.apply #map2(%k)
          %ctk_size = arith.constant 64 : index
          %ctk_stride = arith.constant 1 : index
          %c4 = arith.constant 4 : index
          %c4_1 = arith.constant 4 : index
          %c1 = arith.constant 1 : index
          %c4_2 = arith.constant 4 : index
          %c16 = arith.constant 16 : index
          %c0 = arith.constant 0 : index
          %c4_3 = arith.constant 4 : index
          %c16_1 = arith.constant 16 : index
          adf.dma(%A[%v0 ,%v1] [%cti_size ,%ctk_size] [%cti_stride ,%ctk_stride] [%c4 ,%c4_1] [%c1 ,%c0] [%c4_2 ,%c4_3] [%c16 ,%c16_1], %L1_A[] [] [] [] [] [] []) : (memref<1024x1024xi16> , memref<64x64xi16, 2>)
          %v2 = affine.apply #map2(%k)
          %ctk_size_1 = arith.constant 64 : index
          %ctk_stride_1 = arith.constant 1 : index
          %v3 = affine.apply #map1(%j)
          %ctj_size = arith.constant 64 : index
          %ctj_stride = arith.constant 1 : index
          %c4_4 = arith.constant 4 : index
          %c4_5 = arith.constant 4 : index
          %c1_1 = arith.constant 1 : index
          %c4_6 = arith.constant 4 : index
          %c16_2 = arith.constant 16 : index
          %c0_1 = arith.constant 0 : index
          %c4_7 = arith.constant 4 : index
          %c16_3 = arith.constant 16 : index
          adf.dma(%B[%v2 ,%v3] [%ctk_size_1 ,%ctj_size] [%ctk_stride_1 ,%ctj_stride] [%c4_4 ,%c4_5] [%c1_1 ,%c0_1] [%c4_6 ,%c4_7] [%c16_2 ,%c16_3], %L1_B[] [] [] [] [] [] []) : (memref<1024x1024xi16> , memref<64x64xi16, 2>)
          func.call @kernel_gemm(%L1_A, %L1_B, %L1_C) : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
          %v4 = affine.apply #map0(%i)
          %cti_size_1 = arith.constant 64 : index
          %cti_stride_1 = arith.constant 1 : index
          %v5 = affine.apply #map1(%j)
          %ctj_size_1 = arith.constant 64 : index
          %ctj_stride_1 = arith.constant 1 : index
          %c4_8 = arith.constant 4 : index
          %c4_9 = arith.constant 4 : index
          %c1_2 = arith.constant 1 : index
          %c4_10 = arith.constant 4 : index
          %c16_4 = arith.constant 16 : index
          %c0_2 = arith.constant 0 : index
          %c4_11 = arith.constant 4 : index
          %c16_5 = arith.constant 16 : index
          adf.dma(%L1_C[] [] [] [] [] [] [], %C[%v4 ,%v5] [%cti_size_1 ,%ctj_size_1] [%cti_stride_1 ,%ctj_stride_1] [%c4_8 ,%c4_9] [%c1_2 ,%c0_2] [%c4_10 ,%c4_11] [%c16_4 ,%c16_5]) {accumulator} : (memref<64x64xi16, 2> , memref<1024x1024xi16>)
        }
      }
    }
    return
  } 

  func.func @top(%A: memref<1024x1024xi16>, %B: memref<1024x1024xi16>, %C: memref<1024x1024xi16>) attributes {top_func} {
    func.call @gemm(%A, %B, %C) : (memref<1024x1024xi16>, memref<1024x1024xi16>, memref<1024x1024xi16>) -> ()
    return
  } 
}
