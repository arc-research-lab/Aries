
//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated AIE kernel file supported by Vitis Flow.
//
//===----------------------------------------------------------------------===//
#ifndef __KERNEL_H__
#define __KERNEL_H__
using namespace adf;

void kernel_gemm0(input_buffer<float, extents<1024>>& __restrict in0, input_buffer<float, extents<1024>>& __restrict in1, output_buffer<float, extents<1024>>& __restrict out0);

void kernel_gemm(input_buffer<float, extents<1024>>& __restrict in0, input_buffer<float, extents<1024>>& __restrict in1, input_buffer<float, extents<1024>>& __restrict in2, output_buffer<float, extents<1024>>& __restrict out0);


#endif //__KERNEL_H__/

