#map0 = affine_map<(d0) -> (2*d0)>
#map1 = affine_map<(d0) -> (16*d0)>
#map2 = affine_map<(d0) -> (16*d0)>
#map3 = affine_map<(d0) -> (4*d0)>
#map4 = affine_map<(d0) -> (32*d0)>
module {
  func.func @kernel_ttmc(%TileA: memref<2x4x32xf32, 2>, %TileB: memref<4x16xf32, 2>, %TileC: memref<32x16xf32, 2>, %TileD: memref<2x16x16xf32, 2>) attributes {adf.kernel} {
    affine.for %i0 = 0 to 2 {
      affine.for %j0 = 0 to 16 {
        affine.for %k0 = 0 to 16 {
          %c0 = arith.constant 0.000000 : f32
          affine.store %c0, %TileD[%i0, %j0, %k0] : memref<2x16x16xf32, 2>
          affine.for %l0 = 0 to 4 {
            affine.for %m0 = 0 to 32 {
              %v0 = affine.load %TileA[%i0, %l0, %m0] : memref<2x4x32xf32, 2>
              %v1 = affine.load %TileB[%l0, %j0] : memref<4x16xf32, 2>
              %v2 = arith.mulf %v0, %v1 : f32
              %v3 = affine.load %TileC[%m0, %k0] : memref<32x16xf32, 2>
              %v4 = arith.mulf %v2, %v3 : f32
              %v5 = affine.load %TileD[%i0, %j0, %k0] : memref<2x16x16xf32, 2>
              %v6 = arith.addf %v5, %v4 : f32
              affine.store %v6, %TileD[%i0, %j0, %k0] : memref<2x16x16xf32, 2>
            }
          }
        }
      }
    }
    return
  } 
  func.func @ttmc(%A: memref<4x16x128xf32>, %B: memref<16x64xf32>, %C: memref<128x64xf32>, %D: memref<4x64x64xf32>) attributes {adf.func} {
    affine.for %i = 0 to 2 {
      affine.for %j = 0 to 4 {
        affine.for %k = 0 to 4 {
          affine.for %l = 0 to 4 {
            affine.for %m = 0 to 4 {
              %L1_A = adf.buffer.create @L1_L1_A() : memref<2x4x32xf32, 2>
              %L1_B = adf.buffer.create @L1_L1_B() : memref<4x16xf32, 2>
              %L1_C = adf.buffer.create @L1_L1_C() : memref<32x16xf32, 2>
              %L1_D = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16x16xf32, 2> 
              %v0 = affine.apply #map0(%i)
              %cti_size = arith.constant 2 : index
              %cti_stride = arith.constant 1 : index
              %v1 = affine.apply #map3(%l)
              %ctl_size = arith.constant 4 : index
              %ctl_stride = arith.constant 1 : index
              %v2 = affine.apply #map4(%m)
              %ctm_size = arith.constant 32 : index
              %ctm_stride = arith.constant 1 : index
              adf.dma(%A[%v0 ,%v1 ,%v2] [%cti_size ,%ctl_size ,%ctm_size] [%cti_stride ,%ctl_stride ,%ctm_stride] [] [] [] [], %L1_A[] [] [] [] [] [] []) : (memref<4x16x128xf32> , memref<2x4x32xf32, 2>)
              %v3 = affine.apply #map3(%l)
              %ctl_size_1 = arith.constant 4 : index
              %ctl_stride_1 = arith.constant 1 : index
              %v4 = affine.apply #map1(%j)
              %ctj_size = arith.constant 16 : index
              %ctj_stride = arith.constant 1 : index
              adf.dma(%B[%v3 ,%v4] [%ctl_size_1 ,%ctj_size] [%ctl_stride_1 ,%ctj_stride] [] [] [] [], %L1_B[] [] [] [] [] [] []) : (memref<16x64xf32> , memref<4x16xf32, 2>)
              %v5 = affine.apply #map4(%m)
              %ctm_size_1 = arith.constant 32 : index
              %ctm_stride_1 = arith.constant 1 : index
              %v6 = affine.apply #map2(%k)
              %ctk_size = arith.constant 16 : index
              %ctk_stride = arith.constant 1 : index
              adf.dma(%C[%v5 ,%v6] [%ctm_size_1 ,%ctk_size] [%ctm_stride_1 ,%ctk_stride] [] [] [] [], %L1_C[] [] [] [] [] [] []) : (memref<128x64xf32> , memref<32x16xf32, 2>)
              func.call @kernel_ttmc(%L1_A, %L1_B, %L1_C, %L1_D) : (memref<2x4x32xf32, 2>, memref<4x16xf32, 2>, memref<32x16xf32, 2>, memref<2x16x16xf32, 2>) -> ()
              %v7 = affine.apply #map0(%i)
              %cti_size_1 = arith.constant 2 : index
              %cti_stride_1 = arith.constant 1 : index
              %v8 = affine.apply #map1(%j)
              %ctj_size_1 = arith.constant 16 : index
              %ctj_stride_1 = arith.constant 1 : index
              %v9 = affine.apply #map2(%k)
              %ctk_size_1 = arith.constant 16 : index
              %ctk_stride_1 = arith.constant 1 : index
              adf.dma(%L1_D[] [] [] [] [] [] [], %D[%v7 ,%v8 ,%v9] [%cti_size_1 ,%ctj_size_1 ,%ctk_size_1] [%cti_stride_1 ,%ctj_stride_1 ,%ctk_stride_1] [] [] [] []) {accumulator} : (memref<2x16x16xf32, 2> , memref<4x64x64xf32>)
            }
          }
        }
      }
    }
    return
  } 
  func.func @top(%A: memref<4x16x128xf32>, %B: memref<16x64xf32>, %C: memref<128x64xf32>, %D: memref<4x64x64xf32>) attributes {top_func} {
    func.call @ttmc(%A, %B, %C, %D) : (memref<4x16x128xf32>, memref<16x64xf32>, memref<128x64xf32>, memref<4x64x64xf32>) -> ()
    return
  } 
}
