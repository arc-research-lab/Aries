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
static inline void matmul_vectorized_2x2_mmul(const T_in *__restrict pA,
                                              const T_in *__restrict pB,
                                              T_out *__restrict pC) {

  using MMUL = aie::mmul<r, s, t, T_in, T_in, accauto>;

  event0();

  for (unsigned z = 0; z < rowA; z += 2)
    chess_prepare_for_pipelining chess_loop_range(4, ) {
      T_out *__restrict pC1 = pC + (z * colB + 0) * MMUL::size_C;
      T_out *__restrict pC2 = pC + ((z + 1) * colB + 0) * MMUL::size_C;

      for (unsigned j = 0; j < colB; j += 2)
#ifdef OPT_PERF_ENABLED
        chess_flatten_loop
#endif
        {
          const T_in *__restrict pA1 = pA + (z * colA + 0) * MMUL::size_A;
          const T_in *__restrict pA2 = pA + ((z + 1) * colA + 0) * MMUL::size_A;
          const T_in *__restrict pB1 = pB + (0 * colB + j) * MMUL::size_B;
          const T_in *__restrict pB2 = pB + (0 * colB + (j + 1)) * MMUL::size_B;

          aie::vector<T_in, MMUL::size_A> A0 = aie::load_v<MMUL::size_A>(pA1);
          pA1 += MMUL::size_A;
          aie::vector<T_in, MMUL::size_A> A1 = aie::load_v<MMUL::size_A>(pA2);
          pA2 += MMUL::size_A;
          aie::vector<T_in, MMUL::size_B> B0 = aie::load_v<MMUL::size_B>(pB1);
          pB1 += MMUL::size_B * colB;
          aie::vector<T_in, MMUL::size_B> B1 = aie::load_v<MMUL::size_B>(pB2);
          pB2 += MMUL::size_B * colB;

          // Load partial results from C buffer for accumulation in-place. The
          // zero.cc function handles the zeroing of data when a new
          // accumulation is needed (after the 'K' reduction dimension)
          aie::vector<T_out, MMUL::size_C> acc_C00 =
              aie::load_v<MMUL::size_C>(pC1);
          aie::vector<T_out, MMUL::size_C> acc_C01 =
              aie::load_v<MMUL::size_C>(pC1 + MMUL::size_C);
          aie::vector<T_out, MMUL::size_C> acc_C10 =
              aie::load_v<MMUL::size_C>(pC2);
          aie::vector<T_out, MMUL::size_C> acc_C11 =
              aie::load_v<MMUL::size_C>(pC2 + MMUL::size_C);

          MMUL C00(acc_C00);
          MMUL C01(acc_C01);
          MMUL C10(acc_C10);
          MMUL C11(acc_C11);

          C00.mac(A0, B0);
          C01.mac(A0, B1);
          C10.mac(A1, B0);
          C11.mac(A1, B1);

          for (unsigned i = 1; i < colA; ++i)
#ifdef OPT_PERF_ENABLED
            chess_flatten_loop
#endif
            {
              A0 = aie::load_v<MMUL::size_A>(pA1);
              pA1 += MMUL::size_A;
              A1 = aie::load_v<MMUL::size_A>(pA2);
              pA2 += MMUL::size_A;
              B0 = aie::load_v<MMUL::size_B>(pB1);
              pB1 += MMUL::size_B * colB;
              B1 = aie::load_v<MMUL::size_B>(pB2);
              pB2 += MMUL::size_B * colB;

              C00.mac(A0, B0);
              C01.mac(A0, B1);
              C10.mac(A1, B0);
              C11.mac(A1, B1);
            }

          // TODO make shift right here to keep most significat bits
          // when lowering the output
          // example below shows how to shift right 10 bits
          // #define SHIFT 10
          // aie::store_v(pC1, C00.template to_vector<T_out>(SHIFT));
          aie::store_v(pC1, C00.template to_vector<T_out>());
          pC1 += MMUL::size_C;
          aie::store_v(pC1, C01.template to_vector<T_out>());
          pC1 += MMUL::size_C;
          aie::store_v(pC2, C10.template to_vector<T_out>());
          pC2 += MMUL::size_C;
          aie::store_v(pC2, C11.template to_vector<T_out>());
          pC2 += MMUL::size_C;
        }
    }

  event1();
}

// int16 MatMul kernel definion with int16 outputs.
template <typename T_in, typename T_out, unsigned m, unsigned k, unsigned n>
static inline void matmul_vectorized_4x4x4(const T_in *__restrict pA,
                                                   const T_in *__restrict pB,
                                                   T_out *__restrict pC) {

  // After extensive experimentation, the 4x4x4 aie::mmul size was found to be
  // optimal for AIE2, in combination with the 2x2 mmul expanded kernel
  constexpr int r = 4;
  constexpr int s = 4;
  constexpr int t = 4;

  // Since the kernel has been expanded twice for both A ('m' dimension) and B
  // ('n' dimension), the following assertions veirify this even division for
  // the single AIE MatMul dimensionality Notice that 'k' dimension is not
  // spatially expanded.
  static_assert(m % (2 * r) == 0); // 'm' dimension
  static_assert(k % s == 0);       // 'k' dimension
  static_assert(n % (2 * t) == 0); // 'n' dimension

  return matmul_vectorized_2x2_mmul<T_in, T_out, (m / r), (k / s), (n / t), r,
                                    s, t>(pA, pB, pC);
}

extern "C" {
#define TI 64
#define TJ 64
#define TK 64


using T_IN = int16;
using T_OUT = int16;

void zero_i16(T_OUT*__restrict c){
  zero_vectorized<T_OUT, TI, TJ>(c);
}

void kernel_gemm(const T_IN*__restrict A, const T_IN* __restrict B, 
                 T_OUT*__restrict C) {
  matmul_vectorized_4x4x4<T_IN, T_OUT, TI, TK, TJ>(A, B, C);
}

} // extern "C"