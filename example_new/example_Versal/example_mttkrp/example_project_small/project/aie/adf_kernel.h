
//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated AIE kernel file supported by Vitis Flow.
//
//===----------------------------------------------------------------------===//
#ifndef __KERNEL_H__
#define __KERNEL_H__
using namespace adf;

void kernel_mttkrp0(input_buffer<float, extents<256>>& __restrict in0, input_buffer<float, extents<128>>& __restrict in1, input_buffer<float, extents<256>>& __restrict in2, output_buffer<float, extents<32>>& __restrict out0);

void kernel_mttkrp(input_buffer<float, extents<256>>& __restrict in0, input_buffer<float, extents<128>>& __restrict in1, input_buffer<float, extents<256>>& __restrict in2, input_buffer<float, extents<32>>& __restrict in3, output_buffer<float, extents<32>>& __restrict out0);


#endif //__KERNEL_H__/

