#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <aie_api/aie.hpp>
#include <aie_api/aie_adf.hpp>
#include <aie_api/utils.hpp>
#include <adf/io_buffer/io_buffer.h>

using namespace adf;

const int I={{paraList[0]}};
const int J={{paraList[1]}};
const int K={{paraList[2]}};
const int L={{paraList[3]}};
const int A_SIZE=I*K*L;
const int B_SIZE=K*J;
const int C_SIZE=L*J;
const int D_SIZE=I*J;
const int boundary_i=I/2;
const int boundary_j=J/8;
const int boundary_k=K;
const int boundary_l=L/8-1;
const int judge_j=boundary_j-1;
const int judge_k=boundary_k-1;
const int A_jump0=L*K;
const int A_jump1=A_jump0-4;
const int A_jump2=2*A_jump0-4;
const int A_jump3=-4;
const int B_jump0=(K-1)*J-8;
const int B_jump1=K*J-8;
const int C_jump0=(L-1)*J;
const int C_jump1=C_jump0-8;
const int C_jump2=L*J-8;
const int OUT_jump0=J-8;
const int OUT_jump1=-8;

// Assumes all the operands are row-major
// The basic block is 2*8*8 (i, j, l)
// D(i, j)+ = A(i, k, l) * B(k, j) * C(l, j)
void {{dst_name}}(input_buffer<int32_t, extents<A_SIZE>>&  in0, input_buffer<int32_t, extents<B_SIZE>>&  in1, input_buffer<int32_t, extents<C_SIZE>>&  in2, input_buffer<int32_t, extents<D_SIZE>>&  in3, output_buffer<int32_t, extents<D_SIZE>>&  out0){
  int32_t *  A = (int32_t *)in0.data();
  int32_t *  B = (int32_t *)in1.data();
  int32_t *  C = (int32_t *)in2.data();
  int32_t *  ACC_IN = (int32_t *)in3.data();
  int32_t *  D_OUT = (int32_t *)out0.data();

  aie::vector<int32, 16> chess_storage(xa) a_v16 = null_v16int32();
  aie::vector<int32, 16> chess_storage(xb) c_v16 = null_v16int32();
  aie::vector<int32, 16> chess_storage(xc) b_v16 = null_v16int32();
  
  aie::accum<acc80,8> chess_storage(bm0) acc0 = null_v8acc80();
	aie::accum<acc80,8> chess_storage(bm1) acc1 = null_v8acc80();
  aie::accum<acc80,8> chess_storage(bm2) acc2 = null_v8acc80();
	aie::accum<acc80,8> chess_storage(bm3) acc3 = null_v8acc80();

  for (unsigned int i=0;i<boundary_i;i++)
  chess_prepare_for_pipelining
	chess_loop_range(boundary_i,boundary_i)
  {
    for (unsigned int j=0; j< boundary_j; j++)
    chess_prepare_for_pipelining
		chess_loop_range(boundary_j,boundary_j)
    {
      int OUT_jump = OUT_jump0;
      if(j == judge_j){
        OUT_jump = OUT_jump1;
      }
      aie::accum<acc80,8> acc2 = lups(aie::load_v<8>(ACC_IN), 0);
      ACC_IN += J;
			aie::accum<acc80,8> acc3 = lups(aie::load_v<8>(ACC_IN), 0);
      ACC_IN -= OUT_jump;
      for (unsigned int k=0;k<boundary_k;k++)
      chess_prepare_for_pipelining
		  chess_loop_range(boundary_k,boundary_k)
      {  
        int A_jump = A_jump1;
        int C_jump = C_jump0;
        int B_jump = -J;
        if(k == judge_k){
          if(j == judge_j){
            A_jump = A_jump3;
            B_jump = B_jump1;
            C_jump = C_jump2;
          }else{
            A_jump = A_jump2;
            B_jump = B_jump0;
            C_jump = C_jump1;
          }
        }
        b_v16 = b_v16.insert(0, aie::load_v<8>(B));
        B -= B_jump;
        for (unsigned int l=0;l<boundary_l;l++)
        chess_prepare_for_pipelining
		    chess_loop_range(boundary_l,boundary_l)
        {
          //////////// Vector Preload
          a_v16 = a_v16.insert(0, aie::load_v<4>(A));
          A += A_jump0;
          c_v16 = c_v16.insert(0, aie::load_v<8>(C));
          C += J;
          a_v16 = a_v16.insert(1, aie::load_v<4>(A));
          A -= A_jump1;

          ///////////// Calculate first 2*4*8
          // l=0
          acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 0, 0x0);  //A[0][0][0] * C[0][0-7]
          a_v16 = a_v16.insert(2, aie::load_v<4>(A));
          A += A_jump0;
          c_v16 = c_v16.insert(1, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 4, 0x0);  //A[1][0][0] * C[0][0-7]
          a_v16 = a_v16.insert(3, aie::load_v<4>(A));
          A -= A_jump1;

          // l=1
          acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 1, 0x0);
          c_v16 = c_v16.insert(0, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 5, 0x0);

          // l=2
          acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 2, 0x0);
          c_v16 = c_v16.insert(1, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 6, 0x0);
  
          // l=3
          acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 3, 0x0);
          c_v16 = c_v16.insert(0, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 7, 0x0);

          //////////// Calculate second 2*4*8
          // l=4
          acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 0, 0x0);
          c_v16 = c_v16.insert(1, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 4, 0x0);

          // l=5
          acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 1, 0x0);
          c_v16 = c_v16.insert(0, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 5, 0x0);

          // l=6
          acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 2, 0x0);
          c_v16 = c_v16.insert(1, aie::load_v<8>(C));
          C += J;
          acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 6, 0x0);

          // l=7
          acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 3, 0x0);
          acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 7, 0x0);
        }
        //////////// Vector Preload
        a_v16 = a_v16.insert(0, aie::load_v<4>(A));
        A += A_jump0;
        c_v16 = c_v16.insert(0, aie::load_v<8>(C));
        C += J;
        a_v16 = a_v16.insert(1, aie::load_v<4>(A));
        A -= A_jump1;

        ///////////// Calculate first 2*4*8
        // l=0
        acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 0, 0x0);  //A[0][0][0] * C[0][0-7]
        a_v16 = a_v16.insert(2, aie::load_v<4>(A));
        A += A_jump0;
        c_v16 = c_v16.insert(1, aie::load_v<8>(C));
        C += J;
        acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 4, 0x0);  //A[1][0][0] * C[0][0-7]
        a_v16 = a_v16.insert(3, aie::load_v<4>(A));
        A -= A_jump;

        // l=1
        acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 1, 0x0);
        c_v16 = c_v16.insert(0, aie::load_v<8>(C));
        C += J;
        acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 5, 0x0);

        // l=2
        acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 2, 0x0);
        c_v16 = c_v16.insert(1, aie::load_v<8>(C));
        C += J;
        acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(0), 6, 0x0);
  
        // l=3
        acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 3, 0x0);
        c_v16 = c_v16.insert(0, aie::load_v<8>(C));
        C += J;
        acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(0), 7, 0x0);

        //////////// Calculate second 2*4*8
        // l=4
        acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 0, 0x0);
        c_v16 = c_v16.insert(1, aie::load_v<8>(C));
        C += J;
        acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 4, 0x0);

        // l=5
        acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 1, 0x0);
        c_v16 = c_v16.insert(0, aie::load_v<8>(C));
        C += J;
        acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 5, 0x0);

        // l=6
        acc0 = lmac8(acc0, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 2, 0x0);
        c_v16 = c_v16.insert(1, aie::load_v<8>(C));
        C -= C_jump;
        acc1 = lmac8(acc1, c_v16, 0, 0x76543210, a_v16.extract<8>(1), 6, 0x0);

        // l=7
        acc0 = lmac8(acc0, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 3, 0x0);
        acc1 = lmac8(acc1, c_v16, 8, 0x76543210, a_v16.extract<8>(1), 7, 0x0);
        aie::vector<int32, 8> sub_sum0 = srs(acc0, 0);
        aie::vector<int32, 8> sub_sum1 = srs(acc1, 0);
        acc0 = null_v8acc80();
			  acc1 = null_v8acc80();
        chess_separator_scheduler();
        acc2 = lmac8(acc2, b_v16, 0, 0x76543210, sub_sum0, 0, 0x76543210);  //B[0][0-7] * subsum[i:0][k:0][j:0-7]
        acc3 = lmac8(acc3, b_v16, 0, 0x76543210, sub_sum1, 0, 0x76543210);  //B[0][0-7] * subsum[i:0][k:0][j:0-7]
      }
      chess_separator_scheduler();
      aie::vector<int32, 8> temp0 = srs(acc2, 0);
      aie::store_v(D_OUT, temp0);
      D_OUT += J;
      aie::vector<int32, 8> temp1 = srs(acc3, 0);
      aie::store_v(D_OUT, temp1);
      D_OUT -= OUT_jump;
    }
  }
}