module {
  aie.device(npu1_4col) {
    func.func private @zero_i16(memref<64x64xi16, 2>)
    %tile_1_1 = aie.tile(1, 1)
    %tile_0_1 = aie.tile(0, 1)
    %tile_2_1 = aie.tile(2, 1)
    %tile_3_1 = aie.tile(3, 1)
    %tile_0_2 = aie.tile(0, 2)
    %tile_1_2 = aie.tile(1, 2)
    %tile_2_2 = aie.tile(2, 2)
    %tile_3_2 = aie.tile(3, 2)
    %tile_0_3 = aie.tile(0, 3)
    %tile_1_3 = aie.tile(1, 3)
    %tile_2_3 = aie.tile(2, 3)
    %tile_3_3 = aie.tile(3, 3)
    %tile_0_4 = aie.tile(0, 4)
    %tile_1_4 = aie.tile(1, 4)
    %tile_2_4 = aie.tile(2, 4)
    %tile_3_4 = aie.tile(3, 4)
    %tile_0_5 = aie.tile(0, 5)
    %tile_1_5 = aie.tile(1, 5)
    %tile_2_5 = aie.tile(2, 5)
    %tile_3_5 = aie.tile(3, 5)
    %tile_1_0 = aie.tile(1, 0)
    %tile_0_0 = aie.tile(0, 0)
    %tile_2_0 = aie.tile(2, 0)
    %tile_3_0 = aie.tile(3, 0)
    func.func private @kernel_gemm(memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) attributes {adf.kernel}
    aie.objectfifo @L2_buf0(%tile_1_0, {%tile_1_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf1(%tile_0_0, {%tile_0_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf2(%tile_1_0, {%tile_1_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf3(%tile_2_0, {%tile_2_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf4(%tile_3_0, {%tile_3_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf5(%tile_0_0, {%tile_0_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf6(%tile_2_0, {%tile_2_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf7(%tile_3_0, {%tile_3_1}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 1>> 
    aie.objectfifo @L2_buf8(%tile_0_1, {%tile_0_0}, 2 : i32) : !aie.objectfifo<memref<256x64xi16, 1>> 
    aie.objectfifo @L2_buf9(%tile_1_1, {%tile_1_0}, 2 : i32) : !aie.objectfifo<memref<256x64xi16, 1>> 
    aie.objectfifo @L2_buf10(%tile_2_1, {%tile_2_0}, 2 : i32) : !aie.objectfifo<memref<256x64xi16, 1>> 
    aie.objectfifo @L2_buf11(%tile_3_1, {%tile_3_0}, 2 : i32) : !aie.objectfifo<memref<256x64xi16, 1>> 
    aie.objectfifo @L1_L1_A(%tile_1_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_0_2, %tile_1_2, %tile_2_2, %tile_3_2}, 2 : i32) {srcName = "L2_buf0"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf0] -> [@L1_L1_A]([] [])
    aie.objectfifo @L1_L1_B(%tile_0_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_0_2, %tile_0_3, %tile_0_4, %tile_0_5}, 2 : i32) {srcName = "L2_buf1"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf1] -> [@L1_L1_B]([] [])
    aie.objectfifo @L1_L1_C(%tile_0_2, {%tile_0_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L1_L1_C, @L1_L1_C_4, @L1_L1_C_8, @L1_L1_C_12] -> [@L2_buf8]([0, 4096, 8192, 12288] [])
    %core_0_2 = aie.core(%tile_0_2) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_A(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_B(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%3, %5, %1) {adf.kernel, "col, row" = [0 : index, 2 : index], kernel_gemm = 0 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_B(Consume, 1)
              aie.objectfifo.release @L1_L1_A(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_B_1(%tile_1_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_1_2, %tile_1_3, %tile_1_4, %tile_1_5}, 2 : i32) {srcName = "L2_buf2"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf2] -> [@L1_L1_B_1]([] [])
    aie.objectfifo @L1_L1_C_1(%tile_1_2, {%tile_1_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L1_L1_C_1, @L1_L1_C_5, @L1_L1_C_9, @L1_L1_C_13] -> [@L2_buf9]([0, 4096, 8192, 12288] [])
    %core_1_2 = aie.core(%tile_1_2) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_1(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_A(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_B_1(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%3, %5, %1) {adf.kernel, "col, row" = [1 : index, 2 : index], kernel_gemm = 1 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_B_1(Consume, 1)
              aie.objectfifo.release @L1_L1_A(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_1(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_B_2(%tile_2_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_2_2, %tile_2_3, %tile_2_4, %tile_2_5}, 2 : i32) {srcName = "L2_buf3"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf3] -> [@L1_L1_B_2]([] [])
    aie.objectfifo @L1_L1_C_2(%tile_2_2, {%tile_2_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L1_L1_C_2, @L1_L1_C_6, @L1_L1_C_10, @L1_L1_C_14] -> [@L2_buf10]([0, 4096, 8192, 12288] [])
    %core_2_2 = aie.core(%tile_2_2) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_2(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_A(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_B_2(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%3, %5, %1) {adf.kernel, "col, row" = [2 : index, 2 : index], kernel_gemm = 2 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_B_2(Consume, 1)
              aie.objectfifo.release @L1_L1_A(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_2(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_B_3(%tile_3_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_3_2, %tile_3_3, %tile_3_4, %tile_3_5}, 2 : i32) {srcName = "L2_buf4"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf4] -> [@L1_L1_B_3]([] [])
    aie.objectfifo @L1_L1_C_3(%tile_3_2, {%tile_3_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L1_L1_C_3, @L1_L1_C_7, @L1_L1_C_11, @L1_L1_C_15] -> [@L2_buf11]([0, 4096, 8192, 12288] [])
    %core_3_2 = aie.core(%tile_3_2) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_3(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_A(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_B_3(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%3, %5, %1) {adf.kernel, "col, row" = [3 : index, 2 : index], kernel_gemm = 3 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_B_3(Consume, 1)
              aie.objectfifo.release @L1_L1_A(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_3(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_A_4(%tile_0_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_0_3, %tile_1_3, %tile_2_3, %tile_3_3}, 2 : i32) {srcName = "L2_buf5"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf5] -> [@L1_L1_A_4]([] [])
    aie.objectfifo @L1_L1_C_4(%tile_0_3, {%tile_0_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_0_3 = aie.core(%tile_0_3) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_4(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_4(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [0 : index, 3 : index], kernel_gemm = 4 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_4(Consume, 1)
              aie.objectfifo.release @L1_L1_B(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_4(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_5(%tile_1_3, {%tile_1_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_1_3 = aie.core(%tile_1_3) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_5(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_1(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_4(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [1 : index, 3 : index], kernel_gemm = 5 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_4(Consume, 1)
              aie.objectfifo.release @L1_L1_B_1(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_5(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_6(%tile_2_3, {%tile_2_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_2_3 = aie.core(%tile_2_3) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_6(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_2(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_4(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [2 : index, 3 : index], kernel_gemm = 6 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_4(Consume, 1)
              aie.objectfifo.release @L1_L1_B_2(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_6(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_7(%tile_3_3, {%tile_3_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_3_3 = aie.core(%tile_3_3) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_7(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_3(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_4(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [3 : index, 3 : index], kernel_gemm = 7 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_4(Consume, 1)
              aie.objectfifo.release @L1_L1_B_3(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_7(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_A_8(%tile_2_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_0_4, %tile_1_4, %tile_2_4, %tile_3_4}, 2 : i32) {srcName = "L2_buf6"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf6] -> [@L1_L1_A_8]([] [])
    aie.objectfifo @L1_L1_C_8(%tile_0_4, {%tile_0_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_0_4 = aie.core(%tile_0_4) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_8(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_8(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [0 : index, 4 : index], kernel_gemm = 8 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_8(Consume, 1)
              aie.objectfifo.release @L1_L1_B(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_8(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_9(%tile_1_4, {%tile_1_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_1_4 = aie.core(%tile_1_4) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_9(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_1(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_8(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [1 : index, 4 : index], kernel_gemm = 9 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_8(Consume, 1)
              aie.objectfifo.release @L1_L1_B_1(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_9(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_10(%tile_2_4, {%tile_2_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_2_4 = aie.core(%tile_2_4) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_10(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_2(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_8(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [2 : index, 4 : index], kernel_gemm = 10 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_8(Consume, 1)
              aie.objectfifo.release @L1_L1_B_2(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_10(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_11(%tile_3_4, {%tile_3_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_3_4 = aie.core(%tile_3_4) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_11(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_3(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_8(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [3 : index, 4 : index], kernel_gemm = 11 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_8(Consume, 1)
              aie.objectfifo.release @L1_L1_B_3(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_11(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_A_12(%tile_3_1 dimensionsToStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>], {%tile_0_5, %tile_1_5, %tile_2_5, %tile_3_5}, 2 : i32) {srcName = "L2_buf7"} : !aie.objectfifo<memref<64x64xi16, 2>> 
    aie.objectfifo.link [@L2_buf7] -> [@L1_L1_A_12]([] [])
    aie.objectfifo @L1_L1_C_12(%tile_0_5, {%tile_0_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_0_5 = aie.core(%tile_0_5) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_12(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_12(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [0 : index, 5 : index], kernel_gemm = 12 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_12(Consume, 1)
              aie.objectfifo.release @L1_L1_B(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_12(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_13(%tile_1_5, {%tile_1_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_1_5 = aie.core(%tile_1_5) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_13(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_1(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_12(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [1 : index, 5 : index], kernel_gemm = 13 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_12(Consume, 1)
              aie.objectfifo.release @L1_L1_B_1(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_13(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_14(%tile_2_5, {%tile_2_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_2_5 = aie.core(%tile_2_5) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_14(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_2(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_12(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [2 : index, 5 : index], kernel_gemm = 14 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_12(Consume, 1)
              aie.objectfifo.release @L1_L1_B_2(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_14(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aie.objectfifo @L1_L1_C_15(%tile_3_5, {%tile_3_1 dimensionsFromStream [<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]}, 2 : i32) : !aie.objectfifo<memref<64x64xi16, 2>> 
    %core_3_5 = aie.core(%tile_3_5) {
      affine.for %arg0 = 0 to 4294967295 {
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %0 = aie.objectfifo.acquire @L1_L1_C_15(Produce, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
            %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
            func.call @zero_i16(%1) : (memref<64x64xi16, 2>) -> ()
            affine.for %arg3 = 0 to 16 {
              %2 = aie.objectfifo.acquire @L1_L1_B_3(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              %4 = aie.objectfifo.acquire @L1_L1_A_12(Consume, 1) : !aie.objectfifosubview<memref<64x64xi16, 2>>
              %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64x64xi16, 2>> -> memref<64x64xi16, 2>
              func.call @kernel_gemm(%5, %3, %1) {adf.kernel, "col, row" = [3 : index, 5 : index], kernel_gemm = 15 : index} : (memref<64x64xi16, 2>, memref<64x64xi16, 2>, memref<64x64xi16, 2>) -> ()
              aie.objectfifo.release @L1_L1_A_12(Consume, 1)
              aie.objectfifo.release @L1_L1_B_3(Consume, 1)
            } {reduction}
            aie.objectfifo.release @L1_L1_C_15(Produce, 1)
          }
        }
      }
      aie.end
    } {link_with = "kernel_gemm.o"}
    aiex.runtime_sequence(%arg0: memref<1024x1024xi16>, %arg1: memref<1024x1024xi16>, %arg2: memref<1024x1024xi16>) {
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 0][4, 16, 64, 64][0, 64, 1024, 1]) {id = 0 : i64, metadata = @L2_buf0} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 0][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 1 : i64, metadata = @L2_buf1} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 64][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 2 : i64, metadata = @L2_buf2} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 128][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 3 : i64, metadata = @L2_buf3} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 192][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 4 : i64, metadata = @L2_buf4} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 65536][4, 16, 64, 64][0, 64, 1024, 1]) {id = 5 : i64, metadata = @L2_buf5} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 131072][4, 16, 64, 64][0, 64, 1024, 1]) {id = 6 : i64, metadata = @L2_buf6} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 196608][4, 16, 64, 64][0, 64, 1024, 1]) {id = 7 : i64, metadata = @L2_buf7} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 0][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf8} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 64][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf9} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 128][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf10} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 192][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf11} : memref<1024x1024xi16>
      aiex.npu.dma_wait {symbol = @L2_buf8}
      aiex.npu.dma_wait {symbol = @L2_buf9}
      aiex.npu.dma_wait {symbol = @L2_buf10}
      aiex.npu.dma_wait {symbol = @L2_buf11}
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 262144][4, 16, 64, 64][0, 64, 1024, 1]) {id = 0 : i64, metadata = @L2_buf0} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 0][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 1 : i64, metadata = @L2_buf1} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 64][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 2 : i64, metadata = @L2_buf2} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 128][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 3 : i64, metadata = @L2_buf3} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 192][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 4 : i64, metadata = @L2_buf4} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 327680][4, 16, 64, 64][0, 64, 1024, 1]) {id = 5 : i64, metadata = @L2_buf5} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 393216][4, 16, 64, 64][0, 64, 1024, 1]) {id = 6 : i64, metadata = @L2_buf6} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 458752][4, 16, 64, 64][0, 64, 1024, 1]) {id = 7 : i64, metadata = @L2_buf7} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 262144][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf8} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 262208][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf9} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 262272][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf10} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 262336][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf11} : memref<1024x1024xi16>
      aiex.npu.dma_wait {symbol = @L2_buf8}
      aiex.npu.dma_wait {symbol = @L2_buf9}
      aiex.npu.dma_wait {symbol = @L2_buf10}
      aiex.npu.dma_wait {symbol = @L2_buf11}
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 524288][4, 16, 64, 64][0, 64, 1024, 1]) {id = 0 : i64, metadata = @L2_buf0} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 0][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 1 : i64, metadata = @L2_buf1} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 64][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 2 : i64, metadata = @L2_buf2} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 128][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 3 : i64, metadata = @L2_buf3} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 192][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 4 : i64, metadata = @L2_buf4} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 589824][4, 16, 64, 64][0, 64, 1024, 1]) {id = 5 : i64, metadata = @L2_buf5} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 655360][4, 16, 64, 64][0, 64, 1024, 1]) {id = 6 : i64, metadata = @L2_buf6} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 720896][4, 16, 64, 64][0, 64, 1024, 1]) {id = 7 : i64, metadata = @L2_buf7} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 524288][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf8} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 524352][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf9} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 524416][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf10} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 524480][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf11} : memref<1024x1024xi16>
      aiex.npu.dma_wait {symbol = @L2_buf8}
      aiex.npu.dma_wait {symbol = @L2_buf9}
      aiex.npu.dma_wait {symbol = @L2_buf10}
      aiex.npu.dma_wait {symbol = @L2_buf11}
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 786432][4, 16, 64, 64][0, 64, 1024, 1]) {id = 0 : i64, metadata = @L2_buf0} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 0][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 1 : i64, metadata = @L2_buf1} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 64][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 2 : i64, metadata = @L2_buf2} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 128][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 3 : i64, metadata = @L2_buf3} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg1[0, 0, 0, 192][4, 16, 64, 64][256, 65536, 1024, 1]) {id = 4 : i64, metadata = @L2_buf4} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 851968][4, 16, 64, 64][0, 64, 1024, 1]) {id = 5 : i64, metadata = @L2_buf5} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 917504][4, 16, 64, 64][0, 64, 1024, 1]) {id = 6 : i64, metadata = @L2_buf6} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg0[0, 0, 0, 983040][4, 16, 64, 64][0, 64, 1024, 1]) {id = 7 : i64, metadata = @L2_buf7} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 786432][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf8} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 786496][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf9} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 786560][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 0 : i64, metadata = @L2_buf10} : memref<1024x1024xi16>
      aiex.npu.dma_memcpy_nd(0, 0, %arg2[0, 0, 0, 786624][1, 4, 256, 64][1024, 256, 1024, 1]) {id = 8 : i64, metadata = @L2_buf11} : memref<1024x1024xi16>
      aiex.npu.dma_wait {symbol = @L2_buf8}
      aiex.npu.dma_wait {symbol = @L2_buf9}
      aiex.npu.dma_wait {symbol = @L2_buf10}
      aiex.npu.dma_wait {symbol = @L2_buf11}
    }
  }
}

