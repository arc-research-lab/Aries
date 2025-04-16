#map0 = affine_map<(d0) -> (32*d0)>
#map1 = affine_map<(d0) -> (32*d0)>
#map2 = affine_map<(d0) -> (32*d0)>
module {
  func.func @kernel_gemm(%TileA: memref<32x32xf32, 2>, %TileB: memref<32x32xf32, 2>, %TileC: memref<32x32xf32, 2>) attributes {adf.kernel} {
    affine.for %i0 = 0 to 32 {
      affine.for %j0 = 0 to 32 {
        %c0 = arith.constant 0.000000 : f32
        affine.store %c0, %TileC[%i0, %j0] : memref<32x32xf32, 2>
        affine.for %k0 = 0 to 32 {
          %v0 = affine.load %TileA[%i0, %k0] : memref<32x32xf32, 2>
          %v1 = affine.load %TileB[%k0, %j0] : memref<32x32xf32, 2>
          %v2 = arith.mulf %v0, %v1 : f32
          %v3 = affine.load %TileC[%i0, %j0] : memref<32x32xf32, 2>
          %v4 = arith.addf %v3, %v2 : f32
          affine.store %v4, %TileC[%i0, %j0] : memref<32x32xf32, 2>
        }
      }
    }
    return
  } 
  func.func @gemm(%A: memref<2816x8192xf32>, %B: memref<8192x3072xf32>, %C: memref<2816x3072xf32>) attributes {adf.func} {
    affine.for %i = 0 to 88 {
      affine.for %j = 0 to 96 {
        affine.for %k = 0 to 256 {
          %L1_A = adf.buffer.create @L1_L1_A() : memref<32x32xf32, 2>
          %L1_B = adf.buffer.create @L1_L1_B() : memref<32x32xf32, 2>
          %L1_C = adf.buffer.create @L1_L1_C() {accumulator} : memref<32x32xf32, 2> 
          %v0 = affine.apply #map0(%i)
          %cti_size = arith.constant 32 : index
          %cti_stride = arith.constant 1 : index
          %v1 = affine.apply #map2(%k)
          %ctk_size = arith.constant 32 : index
          %ctk_stride = arith.constant 1 : index
          adf.dma(%A[%v0 ,%v1] [%cti_size ,%ctk_size] [%cti_stride ,%ctk_stride] [] [] [] [], %L1_A[] [] [] [] [] [] []) : (memref<2816x8192xf32> , memref<32x32xf32, 2>)
          %v2 = affine.apply #map2(%k)
          %ctk_size_1 = arith.constant 32 : index
          %ctk_stride_1 = arith.constant 1 : index
          %v3 = affine.apply #map1(%j)
          %ctj_size = arith.constant 32 : index
          %ctj_stride = arith.constant 1 : index
          adf.dma(%B[%v2 ,%v3] [%ctk_size_1 ,%ctj_size] [%ctk_stride_1 ,%ctj_stride] [] [] [] [], %L1_B[] [] [] [] [] [] []) : (memref<8192x3072xf32> , memref<32x32xf32, 2>)
          func.call @kernel_gemm(%L1_A, %L1_B, %L1_C) : (memref<32x32xf32, 2>, memref<32x32xf32, 2>, memref<32x32xf32, 2>) -> ()
          %v4 = affine.apply #map0(%i)
          %cti_size_1 = arith.constant 32 : index
          %cti_stride_1 = arith.constant 1 : index
          %v5 = affine.apply #map1(%j)
          %ctj_size_1 = arith.constant 32 : index
          %ctj_stride_1 = arith.constant 1 : index
          adf.dma(%L1_C[] [] [] [] [] [] [], %C[%v4 ,%v5] [%cti_size_1 ,%ctj_size_1] [%cti_stride_1 ,%ctj_stride_1] [] [] [] []) {accumulator} : (memref<32x32xf32, 2> , memref<2816x3072xf32>)
        }
      }
    }
    return
  } 
  func.func @top(%A: memref<2816x8192xf32>, %B: memref<8192x3072xf32>, %C: memref<2816x3072xf32>) attributes {top_func} {
    func.call @gemm(%A, %B, %C) : (memref<2816x8192xf32>, memref<8192x3072xf32>, memref<2816x3072xf32>) -> ()
    return
  } 
}
