//------------------------------------------------------------------------------
//
// This file originates from the AMD MLIR-AIE open-source project.
// https://github.com/Xilinx/mlir-aie
// We truly appreciate the contributions from AMD.
//
//------------------------------------------------------------------------------
#define NOCPP

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <type_traits>

#define REL_WRITE 0
#define REL_READ 1

#include <aie_api/aie.hpp>
#include "zero.cc"

template <typename T_in, typename T_out, unsigned rowA, unsigned colA,
          unsigned colB, unsigned r, unsigned s, unsigned t>
static inline void matmul_vectorized_4x2_mmul(const T_in *__restrict pA,
                                              const T_in *__restrict pB,
                                              T_out *__restrict pC) {

  using MMUL = aie::mmul<r, s, t, T_in, T_in, accauto>;

  event0();

  for (unsigned z = 0; z < rowA; z += 4)
    chess_prepare_for_pipelining chess_loop_range(4, ) {
      T_out *__restrict pC1 = pC + (z * colB + 0) * MMUL::size_C;
      T_out *__restrict pC2 = pC + ((z + 1) * colB + 0) * MMUL::size_C;
      T_out *__restrict pC3 = pC + ((z + 2) * colB + 0) * MMUL::size_C;
      T_out *__restrict pC4 = pC + ((z + 3) * colB + 0) * MMUL::size_C;

      for (unsigned j = 0; j < colB; j += 2)
#ifdef OPT_PERF_ENABLED
        chess_flatten_loop
#endif
        {
          const T_in *__restrict pA1 = pA + (z * colA + 0) * MMUL::size_A;
          const T_in *__restrict pA2 = pA + ((z + 1) * colA + 0) * MMUL::size_A;
          const T_in *__restrict pA3 = pA + ((z + 2) * colA + 0) * MMUL::size_A;
          const T_in *__restrict pA4 = pA + ((z + 3) * colA + 0) * MMUL::size_A;

          const T_in *__restrict pB1 = pB + (0 * colB + j) * MMUL::size_B;
          const T_in *__restrict pB2 = pB + (0 * colB + (j + 1)) * MMUL::size_B;

          aie::vector<T_in, MMUL::size_A> A01 = aie::load_v<MMUL::size_A>(pA1);
          pA1 += MMUL::size_A;
          aie::vector<T_in, MMUL::size_A> A11 = aie::load_v<MMUL::size_A>(pA2);
          pA2 += MMUL::size_A;
          aie::vector<T_in, MMUL::size_A> A21 = aie::load_v<MMUL::size_A>(pA3);
          pA3 += MMUL::size_A;
          aie::vector<T_in, MMUL::size_A> A31 = aie::load_v<MMUL::size_A>(pA4);
          pA4 += MMUL::size_A;
          aie::vector<T_in, MMUL::size_B> B01 = aie::load_v<MMUL::size_B>(pB1);
          pB1 += (MMUL::size_B * colB);
          aie::vector<T_in, MMUL::size_B> B11 = aie::load_v<MMUL::size_B>(pB2);
          pB2 += (MMUL::size_B * colB);

          aie::vector<T_out, MMUL::size_C> acc_C00 =
              aie::load_v<MMUL::size_C>(pC1);
          aie::vector<T_out, MMUL::size_C> acc_C01 =
              aie::load_v<MMUL::size_C>(pC1 + MMUL::size_C);
          aie::vector<T_out, MMUL::size_C> acc_C10 =
              aie::load_v<MMUL::size_C>(pC2);
          aie::vector<T_out, MMUL::size_C> acc_C11 =
              aie::load_v<MMUL::size_C>(pC2 + MMUL::size_C);
          aie::vector<T_out, MMUL::size_C> acc_C20 =
              aie::load_v<MMUL::size_C>(pC3);
          aie::vector<T_out, MMUL::size_C> acc_C21 =
              aie::load_v<MMUL::size_C>(pC3 + MMUL::size_C);
          aie::vector<T_out, MMUL::size_C> acc_C30 =
              aie::load_v<MMUL::size_C>(pC4);
          aie::vector<T_out, MMUL::size_C> acc_C31 =
              aie::load_v<MMUL::size_C>(pC4 + MMUL::size_C);

          MMUL C00(acc_C00);
          MMUL C01(acc_C01);
          MMUL C10(acc_C10);
          MMUL C11(acc_C11);
          MMUL C20(acc_C20);
          MMUL C21(acc_C21);
          MMUL C30(acc_C30);
          MMUL C31(acc_C31);

          C00.mac(A01, B01);
          C01.mac(A01, B11);
          C10.mac(A11, B01);
          C11.mac(A11, B11);
          C20.mac(A21, B01);
          C21.mac(A21, B11);
          C30.mac(A31, B01);
          C31.mac(A31, B11);

          for (unsigned i = 1; i < colA; i += 1)
#ifdef OPT_PERF_ENABLED
            chess_flatten_loop
#endif
            {
              A01 = aie::load_v<MMUL::size_A>(pA1);
              pA1 += MMUL::size_A;
              A11 = aie::load_v<MMUL::size_A>(pA2);
              pA2 += MMUL::size_A;
              A21 = aie::load_v<MMUL::size_A>(pA3);
              pA3 += MMUL::size_A;
              A31 = aie::load_v<MMUL::size_A>(pA4);
              pA4 += MMUL::size_A;
              B01 = aie::load_v<MMUL::size_B>(pB1);
              pB1 += (MMUL::size_B * colB);
              B11 = aie::load_v<MMUL::size_B>(pB2);
              pB2 += (MMUL::size_B * colB);

              C00.mac(A01, B01);
              C01.mac(A01, B11);
              C10.mac(A11, B01);
              C11.mac(A11, B11);
              C20.mac(A21, B01);
              C21.mac(A21, B11);
              C30.mac(A31, B01);
              C31.mac(A31, B11);
            }

          aie::store_v(pC1, C00.template to_vector<T_out>());
          pC1 += MMUL::size_C;
          aie::store_v(pC1, C01.template to_vector<T_out>());
          pC1 += MMUL::size_C;
          aie::store_v(pC2, C10.template to_vector<T_out>());
          pC2 += MMUL::size_C;
          aie::store_v(pC2, C11.template to_vector<T_out>());
          pC2 += MMUL::size_C;
          aie::store_v(pC3, C20.template to_vector<T_out>());
          pC3 += MMUL::size_C;
          aie::store_v(pC3, C21.template to_vector<T_out>());
          pC3 += MMUL::size_C;
          aie::store_v(pC4, C30.template to_vector<T_out>());
          pC4 += MMUL::size_C;
          aie::store_v(pC4, C31.template to_vector<T_out>());
          pC4 += MMUL::size_C;
        }
    }

  event1();
}

// int8 MatMul kernel definion with int8 outputs.
template <typename T_in, typename T_out, unsigned m, unsigned k, unsigned n>
static inline void matmul_vectorized_4x8x8(const T_in *__restrict pA,
                                                 const T_in *__restrict pB,
                                                 T_out *__restrict pC) {

  // After extensive experimentation, the 4x8x8 aie::mmul size was found to be
  // optimal for AIE2, in combination with the 4x2 mmul expanded kernel
  constexpr int r = 4;
  constexpr int s = 8;
  constexpr int t = 8;

  // Since the kernel has been expanded 4 times for A ('m' dimension) and 2
  // times for B ('n' dimension), the following assertions veirify this even
  // division for the single AIE MatMul dimensionality Notice that 'k' dimension
  // is not spatially expanded.
  static_assert(m % (4 * r) == 0); // 'm' dimension
  static_assert(k % s == 0);       // 'k' dimension
  static_assert(n % (2 * t) == 0); // 'n' dimension

  return matmul_vectorized_4x2_mmul<T_in, T_out, (m / r), (k / s), (n / t), r, 
                                    s, t>(pA, pB, pC);
}

extern "C" {
#define TI {{paraList[0]}}
#define TJ {{paraList[1]}}
#define TK {{paraList[2]}}

using T_IN = int8;
using T_OUT = int8;

void zero_i8(int8 *__restrict c){
  zero_vectorized<int8, TI, TJ>(c);
}

void zero_i16(int16*__restrict c){
  zero_vectorized<int16, TI, TJ>(c);
}

void {{dst_name}}(const T_IN*__restrict A, const T_IN* __restrict B, 
                 T_OUT*__restrict C) {
  matmul_vectorized_4x8x8<T_IN, T_OUT, TI, TK, TJ>(A, B, C);
}

} // extern "C"