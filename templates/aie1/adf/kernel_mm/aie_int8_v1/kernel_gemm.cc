
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

const int TI={{paraList[0]}}; //i
const int TJ={{paraList[1]}}; //j
const int TK={{paraList[2]}}; //k
const int A_SIZE=TI*TK;
const int B_SIZE=TK*TJ;
const int C_SIZE=TI*TJ;
const int boundary_i=TI/4;
const int boundary_j=TJ/8;
const int boundary_k=TK/16-1;
const int judge_j = boundary_j-1;
const int lhs_jump0= 8*TI;
const int lhs_jump1= (TK/8-1)*(8*TI);
const int lhs_jump2= (TK/8-1)*(8*TI)-32;
const int rhs_jump0= 32;
const int rhs_jump1= -32;
const int rhs_jump2= TK*TJ-32;
const int out_jump0= 16;
const int out_jump1= -(8*TI) + 16;
const int out_jump2= (TJ/8-1)*(8*TI) - 16;

// lhs[TK/8][TI][8] * lhs[TJ/8][TK][8] = out[TJ/8][TI][8]
// The basic block is 4*8*16 (i, j, k)
// The SIDM parallelism is 2*8*8 (i, j, k)
void {{dst_name}}(input_buffer<int8_t, adf::extents<A_SIZE>>& __restrict in0, input_buffer<int8_t, adf::extents<B_SIZE>>& __restrict in1, input_buffer<int8_t, adf::extents<C_SIZE>>& __restrict in2, output_buffer<int8_t, adf::extents<C_SIZE>>& __restrict out0) {
  int8_t * __restrict lhs = (int8_t *)in0.data();
  int8_t * __restrict rhs = (int8_t *)in1.data();
  int8_t * __restrict accin = (int8_t *)in2.data();
  int8_t * __restrict out = (int8_t *)out0.data();

  aie::vector<int8, 32> chess_storage(wc0) lhs0_v32=undef_v32int8(); 
  aie::vector<int8, 32> chess_storage(wc1) lhs1_v32=undef_v32int8();
  aie::vector<int8, 64> chess_storage(xa) rhs0_v64=undef_v64int8();
  aie::vector<int8, 64> chess_storage(xb) rhs1_v64=undef_v64int8();
  
  // Pre-load data
  rhs0_v64 = rhs0_v64.insert(0, aie::load_v<32>(rhs));
  rhs += rhs_jump0;
  lhs0_v32=aie::load_v<32>(lhs);
  lhs += lhs_jump0;
  rhs0_v64 = rhs0_v64.insert(1, aie::load_v<32>(rhs));
  rhs += rhs_jump0;

  aie::accum<acc48,16>  acc2=ups(aie::load_v<16>(accin), 0);
  accin += out_jump0;
  aie::accum<acc48,16>  acc3=ups(aie::load_v<16>(accin), 0);
  accin -= out_jump1;

  for (unsigned int i=0;i<boundary_i;i++) 
	chess_prepare_for_pipelining
	chess_loop_range(boundary_i,boundary_i){
    for (unsigned int j=0; j< boundary_j; j++)
		chess_prepare_for_pipelining
		chess_loop_range(boundary_j,boundary_j){
      int jump_lhs = lhs_jump1;
      int jump_rhs = rhs_jump1;
      int jump_out = out_jump1;
      int jump_acc = out_jump1;
      if(j==judge_j){
          jump_lhs = lhs_jump2;
          jump_rhs = rhs_jump2;
          jump_out = out_jump2;
      }else if(j==judge_j-1){
        jump_acc = out_jump2;
      }
      aie::accum<acc48,16>  acc0=acc2;
      aie::accum<acc48,16>  acc1=acc3;
      for (unsigned int k=0;k<boundary_k;k++)
			chess_prepare_for_pipelining
			chess_loop_range(boundary_k,boundary_k)
			{
        acc0=mac16(acc0,rhs0_v64,0,0x11101110,16,0x3120,lhs0_v32,0,0x44440000,2,0x3210); // A[0-1,0-7] * B[0-7,0-7]
        rhs1_v64 = rhs1_v64.insert(0, aie::load_v<32>(rhs));
        rhs += rhs_jump0;
        lhs1_v32=aie::load_v<32>(lhs);
        lhs += lhs_jump0;

        acc1=mac16(acc1,rhs0_v64,0,0x11101110,16,0x3120,lhs0_v32,0,0xCCCC8888,2,0x3210);
        rhs1_v64 = rhs1_v64.insert(1, aie::load_v<32>(rhs));
        rhs += rhs_jump0;

        acc0=mac16(acc0,rhs1_v64,0,0x11101110,16,0x3120,lhs1_v32,0,0x44440000,2,0x3210);
        rhs0_v64 = rhs0_v64.insert(0, aie::load_v<32>(rhs));
        rhs += rhs_jump0;

        acc1=mac16(acc1,rhs1_v64,0,0x11101110,16,0x3120,lhs1_v32,0,0xCCCC8888,2,0x3210);
        rhs0_v64 = rhs0_v64.insert(1, aie::load_v<32>(rhs));
        rhs += rhs_jump0;
        lhs0_v32=aie::load_v<32>(lhs);
        lhs += lhs_jump0;
      }

      acc0=mac16(acc0,rhs0_v64,0,0x11101110,16,0x3120,lhs0_v32,0,0x44440000,2,0x3210); // A[0-1,0-7] * B[0-7,0-7]
      rhs1_v64 = rhs1_v64.insert(0, aie::load_v<32>(rhs));
      rhs += rhs_jump0;
      lhs1_v32=aie::load_v<32>(lhs);
      lhs -= jump_lhs;
      acc2=ups(aie::load_v<16>(accin), 0);
      accin += out_jump0;

      acc1=mac16(acc1,rhs0_v64,0,0x11101110,16,0x3120,lhs0_v32,0,0xCCCC8888,2,0x3210);
      rhs1_v64 = rhs1_v64.insert(1, aie::load_v<32>(rhs));
      rhs -= jump_rhs;
      acc3=ups(aie::load_v<16>(accin), 0);
      accin -= jump_acc;

      acc0=mac16(acc0,rhs1_v64,0,0x11101110,16,0x3120,lhs1_v32,0,0x44440000,2,0x3210);
      rhs0_v64 = rhs0_v64.insert(0, aie::load_v<32>(rhs));
      rhs += rhs_jump0;
      aie::vector<int8,16> temp0 = bsrs(acc0, 0);
      aie::store_v(out, temp0);
      out += out_jump0;

      acc1=mac16(acc1,rhs1_v64,0,0x11101110,16,0x3120,lhs1_v32,0,0xCCCC8888,2,0x3210);
      rhs0_v64 = rhs0_v64.insert(1, aie::load_v<32>(rhs));
      rhs += rhs_jump0;
      lhs0_v32=aie::load_v<32>(lhs);
      lhs += lhs_jump0;
      aie::vector<int8,16> temp1 = bsrs(acc1, 0);
      aie::store_v(out, temp1);
      out -= jump_out;
    }
  }

  
  return;
}