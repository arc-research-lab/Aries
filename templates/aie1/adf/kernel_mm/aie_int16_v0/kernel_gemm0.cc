
//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated file for AIE kernel supported by Vitis Flow.
//
//===----------------------------------------------------------------------===//

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <aie_api/aie.hpp>
#include <aie_api/aie_adf.hpp>
#include <aie_api/utils.hpp>
#include <adf/io_buffer/io_buffer.h>
using namespace adf;

const int h1={{paraList[0]}}; //i
const int w2={{paraList[1]}}; //j
const int w1={{paraList[2]}}; //k
const int A_SIZE=h1*w1;
const int B_SIZE=w1*w2;
const int C_SIZE=h1*w2;
const int boundary_i=h1/2;
const int boundary_j=w2/16;
const int boundary_k=w1/16-1;
const int judge_j = boundary_j-1;
const int lhs_W1=w1;
const int lhs_jump0=w1-8;
const int lhs_jump1=2*w1-8;
const int lhs_jump2=-8;
const int rhs_W2=w2;
const int rhs_jump0=(w1-1)*w2-16;
const int rhs_jump1=w1*w2-16;
const int out_jump0=w2-16;
const int out_jump1=-16;

// Assumes all the operands are row-major
// The basic block is 2*16*16 (i, j, k)
void {{dst_name}}(input_buffer<int16_t, adf::extents<A_SIZE>>& __restrict in0, input_buffer<int16_t, adf::extents<B_SIZE>>& __restrict in1, output_buffer<int16_t, adf::extents<C_SIZE>>& __restrict out0) {
  int16_t * __restrict lhs = (int16_t *)in0.data();
  int16_t * __restrict rhs = (int16_t *)in1.data();
  int16_t * __restrict out = (int16_t *)out0.data();

  aie::vector<int16, 16> chess_storage(wc0) lhs0_v16 = undef_v16int16();
  aie::vector<int16, 16> chess_storage(wc1) lhs1_v16 = undef_v16int16();
  aie::vector<int16, 32> chess_storage(xa) rhs0_v32 = undef_v32int16();
  aie::vector<int16, 32> chess_storage(xb) rhs1_v32 = undef_v32int16();

  for (unsigned int i=0;i<boundary_i;i++) 
	chess_prepare_for_pipelining
	chess_loop_range(boundary_i,boundary_i){
    for (unsigned int j=0; j< boundary_j; j++)
		chess_prepare_for_pipelining
		chess_loop_range(boundary_j,boundary_j){
      aie::accum<acc48,16> acc0 = null_v16acc48();
			aie::accum<acc48,16> acc1 = null_v16acc48();
      int jump_lhs = lhs_jump1;
      int jump_rhs = rhs_jump0;
      int jump_out = out_jump0;
			if (j == judge_j){
        jump_lhs = lhs_jump2;
        jump_rhs = rhs_jump1;
        jump_out = out_jump1;
      }else{
        jump_lhs = lhs_jump1;
        jump_rhs = rhs_jump0;
        jump_out = out_jump0;
      }
      for (unsigned int k=0;k<boundary_k;k++)
			chess_prepare_for_pipelining
			chess_loop_range(boundary_k,boundary_k)
			{ 
        //////////// Vector Preload
        lhs0_v16 = lhs0_v16.insert(0, aie::load_v<8>(lhs));
        lhs += lhs_W1;
        rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        lhs0_v16 = lhs0_v16.insert(1, aie::load_v<8>(lhs));
        lhs -= lhs_jump0;
        rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        ///////////// Calculate first 2*8*16
        acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 0, 0x0, 0x0, 1); // A[0,0-1] * B[0-1,0-15]
        lhs1_v16 = lhs1_v16.insert(0, aie::load_v<8>(lhs));
        lhs += lhs_W1;
        rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 8, 0x0, 0x0, 1); // A[1,0-1] * B[0-1,0-15]
        lhs1_v16 = lhs1_v16.insert(1, aie::load_v<8>(lhs));
        lhs -= lhs_jump0;
        rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 2, 0x0, 0x0, 1); // A[0,2-3] * B[2-3,0-15]
        rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 10, 0x0, 0x0, 1); // A[1,2-3] * B[2-3,0-15]
        rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 4, 0x0, 0x0, 1); // A[0,4-5] * B[4-5,0-15]
        rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 12, 0x0, 0x0, 1); // A[1,4-5] * B[4-5,0-15]
        rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 6, 0x0, 0x0, 1); // A[0,6-7] * B[6-7,0-15]
        rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 14, 0x0, 0x0, 1); // A[1,6-7] * B[6-7,0-15]
        rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        //////////// Calculate second 2*8*16
        acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 0, 0x0, 0x0, 1); // A[0,8-9] * B[8-9,0-15]
        rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 8, 0x0, 0x0, 1); // A[1,8-9] * B[8-9,0-15]
        rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 2, 0x0, 0x0, 1); // A[0,10-11] * B[10-11,0-15]
        rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 10, 0x0, 0x0, 1); // A[1,10-11] * B[10-11,0-15]
        rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 4, 0x0, 0x0, 1); // A[0,12-13] * B[12-13,0-15]
        rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
        rhs += rhs_W2;
        acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 12, 0x0, 0x0, 1); // A[1,12-13] * B[12-13,0-15]
        rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
        rhs += rhs_W2;

        acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 6, 0x0, 0x0, 1); // A[0,14-15] * B[14-15,0-15]
        acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 14, 0x0, 0x0, 1); // A[1,14-15] * B[14-15,0-15]
      }
      // Last reduction iter
      lhs0_v16 = lhs0_v16.insert(0, aie::load_v<8>(lhs));
      lhs += lhs_W1;
      rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      lhs0_v16 = lhs0_v16.insert(1, aie::load_v<8>(lhs));
      lhs -= lhs_jump0;
      rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      ///////////// Calculate first 2*8*16
      acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 0, 0x0, 0x0, 1); // A[0,0-1] * B[0-1,0-15]
      lhs1_v16 = lhs1_v16.insert(0, aie::load_v<8>(lhs));
      lhs += lhs_W1;
      rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 8, 0x0, 0x0, 1); // A[1,0-1] * B[0-1,0-15]
      lhs1_v16 = lhs1_v16.insert(1, aie::load_v<8>(lhs));
      lhs -= jump_lhs;
      rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 2, 0x0, 0x0, 1); // A[0,2-3] * B[2-3,0-15]
      rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 10, 0x0, 0x0, 1); // A[1,2-3] * B[2-3,0-15]
      rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 4, 0x0, 0x0, 1); // A[0,4-5] * B[4-5,0-15]
      rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 12, 0x0, 0x0, 1); // A[1,4-5] * B[4-5,0-15]
      rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 6, 0x0, 0x0, 1); // A[0,6-7] * B[6-7,0-15]
      rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs0_v16, 14, 0x0, 0x0, 1); // A[1,6-7] * B[6-7,0-15]
      rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      //////////// Calculate second 2*8*16
      acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 0, 0x0, 0x0, 1); // A[0,8-9] * B[8-9,0-15]
      rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 8, 0x0, 0x0, 1); // A[1,8-9] * B[8-9,0-15]
      rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 2, 0x0, 0x0, 1); // A[0,10-11] * B[10-11,0-15]
      rhs0_v32 = rhs0_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 10, 0x0, 0x0, 1); // A[1,10-11] * B[10-11,0-15]
      rhs0_v32 = rhs0_v32.insert(1, aie::load_v<16>(rhs));
      rhs += rhs_W2;

      acc0 = mac16(acc0, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 4, 0x0, 0x0, 1); // A[0,12-13] * B[12-13,0-15]
      rhs1_v32 = rhs1_v32.insert(0, aie::load_v<16>(rhs));
      rhs += rhs_W2;
      acc1 = mac16(acc1, rhs0_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 12, 0x0, 0x0, 1); // A[1,12-13] * B[12-13,0-15]
      rhs1_v32 = rhs1_v32.insert(1, aie::load_v<16>(rhs));
      rhs -= jump_rhs;

      acc0 = mac16(acc0, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 6, 0x0, 0x0, 1); // A[0,14-15] * B[14-15,0-15]
      aie::vector<int16,16> temp0 = srs(acc0, 0);
      aie::store_v(out, temp0);
      out += w2;
      acc1 = mac16(acc1, rhs1_v32, 0, 0x73727170, 0x77767574, 0x3120, lhs1_v16, 14, 0x0, 0x0, 1); // A[1,14-15] * B[14-15,0-15]
      aie::vector<int16,16> temp1 = srs(acc1, 0);
      aie::store_v(out, temp1);
      out -= jump_out;
    }
  }
  return;
}