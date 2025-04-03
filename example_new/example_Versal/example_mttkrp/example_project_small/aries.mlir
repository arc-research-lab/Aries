#map0 = affine_map<(d0) -> (2*d0)>
#map1 = affine_map<(d0) -> (16*d0)>
#map2 = affine_map<(d0) -> (8*d0)>
#map3 = affine_map<(d0) -> (16*d0)>
module {
  func.func @kernel_mttkrp(%TileA: memref<2x8x16xi32, 2>, %TileB: memref<8x16xi32, 2>, %TileC: memref<16x16xi32, 2>, %TileD: memref<2x16xi32, 2>) attributes {adf.kernel} {
    affine.for %i0 = 0 to 2 {
      affine.for %j0 = 0 to 16 {
        %c0 = arith.constant 0 : i32
        affine.store %c0, %TileD[%i0, %j0] : memref<2x16xi32, 2>
        affine.for %k0 = 0 to 8 {
          affine.for %l0 = 0 to 16 {
            %v0 = affine.load %TileA[%i0, %k0, %l0] : memref<2x8x16xi32, 2>
            %v1 = affine.load %TileB[%k0, %j0] : memref<8x16xi32, 2>
            %v2 = arith.muli %v0, %v1 : i32
            %v3 = affine.load %TileC[%l0, %j0] : memref<16x16xi32, 2>
            %v4 = arith.muli %v2, %v3 : i32
            %v5 = affine.load %TileD[%i0, %j0] : memref<2x16xi32, 2>
            %v6 = arith.addi %v5, %v4 : i32
            affine.store %v6, %TileD[%i0, %j0] : memref<2x16xi32, 2>
          }
        }
      }
    }
    return
  } 
  func.func @mttkrp(%A: memref<8x32x128xi32>, %B: memref<32x128xi32>, %C: memref<128x128xi32>, %D: memref<8x128xi32>) attributes {adf.func} {
    affine.for %i = 0 to 4 {
      affine.for %j = 0 to 8 {
        affine.for %k = 0 to 4 {
          affine.for %l = 0 to 8 {
            %L1_A = adf.buffer.create @L1_L1_A() : memref<2x8x16xi32, 2>
            %L1_B = adf.buffer.create @L1_L1_B() : memref<8x16xi32, 2>
            %L1_C = adf.buffer.create @L1_L1_C() : memref<16x16xi32, 2>
            %L1_D = adf.buffer.create @L1_L1_D() {accumulator} : memref<2x16xi32, 2> 
            %v0 = affine.apply #map0(%i)
            %cti_size = arith.constant 2 : index
            %cti_stride = arith.constant 1 : index
            %v1 = affine.apply #map2(%k)
            %ctk_size = arith.constant 8 : index
            %ctk_stride = arith.constant 1 : index
            %v2 = affine.apply #map3(%l)
            %ctl_size = arith.constant 16 : index
            %ctl_stride = arith.constant 1 : index
            adf.dma(%A[%v0 ,%v1 ,%v2] [%cti_size ,%ctk_size ,%ctl_size] [%cti_stride ,%ctk_stride ,%ctl_stride] [] [] [] [], %L1_A[] [] [] [] [] [] []) : (memref<8x32x128xi32> , memref<2x8x16xi32, 2>)
            %v3 = affine.apply #map2(%k)
            %ctk_size_1 = arith.constant 8 : index
            %ctk_stride_1 = arith.constant 1 : index
            %v4 = affine.apply #map1(%j)
            %ctj_size = arith.constant 16 : index
            %ctj_stride = arith.constant 1 : index
            adf.dma(%B[%v3 ,%v4] [%ctk_size_1 ,%ctj_size] [%ctk_stride_1 ,%ctj_stride] [] [] [] [], %L1_B[] [] [] [] [] [] []) : (memref<32x128xi32> , memref<8x16xi32, 2>)
            %v5 = affine.apply #map3(%l)
            %ctl_size_1 = arith.constant 16 : index
            %ctl_stride_1 = arith.constant 1 : index
            %v6 = affine.apply #map1(%j)
            %ctj_size_1 = arith.constant 16 : index
            %ctj_stride_1 = arith.constant 1 : index
            adf.dma(%C[%v5 ,%v6] [%ctl_size_1 ,%ctj_size_1] [%ctl_stride_1 ,%ctj_stride_1] [] [] [] [], %L1_C[] [] [] [] [] [] []) : (memref<128x128xi32> , memref<16x16xi32, 2>)
            func.call @kernel_mttkrp(%L1_A, %L1_B, %L1_C, %L1_D) : (memref<2x8x16xi32, 2>, memref<8x16xi32, 2>, memref<16x16xi32, 2>, memref<2x16xi32, 2>) -> ()
            %v7 = affine.apply #map0(%i)
            %cti_size_1 = arith.constant 2 : index
            %cti_stride_1 = arith.constant 1 : index
            %v8 = affine.apply #map1(%j)
            %ctj_size_2 = arith.constant 16 : index
            %ctj_stride_2 = arith.constant 1 : index
            adf.dma(%L1_D[] [] [] [] [] [] [], %D[%v7 ,%v8] [%cti_size_1 ,%ctj_size_2] [%cti_stride_1 ,%ctj_stride_2] [] [] [] []) {accumulator} : (memref<2x16xi32, 2> , memref<8x128xi32>)
          }
        }
      }
    }
    return
  } 
  func.func @top(%A: memref<8x32x128xi32>, %B: memref<32x128xi32>, %C: memref<128x128xi32>, %D: memref<8x128xi32>) attributes {top_func} {
    func.call @mttkrp(%A, %B, %C, %D) : (memref<8x32x128xi32>, memref<32x128xi32>, memref<128x128xi32>, memref<8x128xi32>) -> ()
    return
  } 
}
