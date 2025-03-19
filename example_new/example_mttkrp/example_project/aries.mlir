#map0 = affine_map<(d0) -> (2*d0)>
#map1 = affine_map<(d0) -> (32*d0)>
#map2 = affine_map<(d0) -> (16*d0)>
#map3 = affine_map<(d0) -> (32*d0)>
module {
  func.func @kernel_mttkrp(%TileA: memref<2x16x32xf32, 2>, %TileB: memref<16x32xf32, 2>, %TileC: memref<32x32xf32, 2>, %TileD: memref<2x32xf32, 2>) attributes {adf.kernel} {
    affine.for %i0 = 0 to 2 {
      affine.for %j0 = 0 to 32 {
        affine.for %k0 = 0 to 16 {
          affine.for %l0 = 0 to 32 {
            %v0 = affine.load %TileA[%i0, %k0, %l0] : memref<2x16x32xf32, 2>
            %v1 = affine.load %TileB[%k0, %j0] : memref<16x32xf32, 2>
            %v2 = arith.mulf %v0, %v1 : f32
            %v3 = affine.load %TileC[%l0, %j0] : memref<32x32xf32, 2>
            %v4 = arith.mulf %v2, %v3 : f32
            %v5 = affine.load %TileD[%i0, %j0] : memref<2x32xf32, 2>
            %v6 = arith.addf %v5, %v4 : f32
            affine.store %v6, %TileD[%i0, %j0] : memref<2x32xf32, 2>
          }
        }
      }
    }
    return
  } 
  func.func @mttkrp(%A: memref<64x768x2048xf32>, %B: memref<768x6144xf32>, %C: memref<2048x6144xf32>, %D: memref<64x6144xf32>) attributes {adf.func} {
    affine.for %i = 0 to 32 {
      affine.for %j = 0 to 192 {
        affine.for %k = 0 to 48 {
          affine.for %l = 0 to 64 {
            %L1_A = adf.buffer.create @L1_L1_A() : memref<2x16x32xf32, 2>
            %L1_B = adf.buffer.create @L1_L1_B() : memref<16x32xf32, 2>
            %L1_C = adf.buffer.create @L1_L1_C() : memref<32x32xf32, 2>
            %L1_D = adf.buffer.create @L1_L1_D() : memref<2x32xf32, 2>
            %v0 = affine.apply #map0(%i)
            %cti_size = arith.constant 2 : index
            %cti_stride = arith.constant 1 : index
            %v1 = affine.apply #map2(%k)
            %ctk_size = arith.constant 16 : index
            %ctk_stride = arith.constant 1 : index
            %v2 = affine.apply #map3(%l)
            %ctl_size = arith.constant 32 : index
            %ctl_stride = arith.constant 1 : index
            adf.dma(%A[%v0 ,%v1 ,%v2] [%cti_size ,%ctk_size ,%ctl_size] [%cti_stride ,%ctk_stride ,%ctl_stride] [] [] [] [], %L1_A[] [] [] [] [] [] []) : (memref<64x768x2048xf32> , memref<2x16x32xf32, 2>)
            %v3 = affine.apply #map2(%k)
            %ctk_size_1 = arith.constant 16 : index
            %ctk_stride_1 = arith.constant 1 : index
            %v4 = affine.apply #map1(%j)
            %ctj_size = arith.constant 32 : index
            %ctj_stride = arith.constant 1 : index
            adf.dma(%B[%v3 ,%v4] [%ctk_size_1 ,%ctj_size] [%ctk_stride_1 ,%ctj_stride] [] [] [] [], %L1_B[] [] [] [] [] [] []) : (memref<768x6144xf32> , memref<16x32xf32, 2>)
            %v5 = affine.apply #map3(%l)
            %ctl_size_1 = arith.constant 32 : index
            %ctl_stride_1 = arith.constant 1 : index
            %v6 = affine.apply #map1(%j)
            %ctj_size_1 = arith.constant 32 : index
            %ctj_stride_1 = arith.constant 1 : index
            adf.dma(%C[%v5 ,%v6] [%ctl_size_1 ,%ctj_size_1] [%ctl_stride_1 ,%ctj_stride_1] [] [] [] [], %L1_C[] [] [] [] [] [] []) : (memref<2048x6144xf32> , memref<32x32xf32, 2>)
            %v7 = affine.apply #map0(%i)
            %cti_size_1 = arith.constant 2 : index
            %cti_stride_1 = arith.constant 1 : index
            %v8 = affine.apply #map1(%j)
            %ctj_size_2 = arith.constant 32 : index
            %ctj_stride_2 = arith.constant 1 : index
            adf.dma(%D[%v7 ,%v8] [%cti_size_1 ,%ctj_size_2] [%cti_stride_1 ,%ctj_stride_2] [] [] [] [], %L1_D[] [] [] [] [] [] []) : (memref<64x6144xf32> , memref<2x32xf32, 2>)
            func.call @kernel_mttkrp(%L1_A, %L1_B, %L1_C, %L1_D) : (memref<2x16x32xf32, 2>, memref<16x32xf32, 2>, memref<32x32xf32, 2>, memref<2x32xf32, 2>) -> ()
            %v9 = affine.apply #map0(%i)
            %cti_size_2 = arith.constant 2 : index
            %cti_stride_2 = arith.constant 1 : index
            %v10 = affine.apply #map1(%j)
            %ctj_size_3 = arith.constant 32 : index
            %ctj_stride_3 = arith.constant 1 : index
            adf.dma(%L1_D[] [] [] [] [] [] [], %D[%v9 ,%v10] [%cti_size_2 ,%ctj_size_3] [%cti_stride_2 ,%ctj_stride_3] [] [] [] []) : (memref<2x32xf32, 2> , memref<64x6144xf32>)
          }{reduction}
        }{reduction}
      }
    }
    return
  } 
  func.func @top(%A: memref<64x768x2048xf32>, %B: memref<768x6144xf32>, %C: memref<2048x6144xf32>, %D: memref<64x6144xf32>) attributes {top_func} {
    func.call @mttkrp(%A, %B, %C, %D) : (memref<64x768x2048xf32>, memref<768x6144xf32>, memref<2048x6144xf32>, memref<64x6144xf32>) -> ()
    return
  } 
}
