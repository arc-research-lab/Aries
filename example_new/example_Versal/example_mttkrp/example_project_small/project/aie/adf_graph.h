
//===----------------------------------------------------------------------===//
//
// Automatically generated file for adf_graph.h
//
//===----------------------------------------------------------------------===//
#ifndef __GRAPH_H__
#define __GRAPH_H__

#include <adf.h>
#include <stdio.h>
#include <iostream>
#include "adf_kernel.h"
using namespace adf;


class adf_cell0: public adf::graph{
private:
  adf::kernel kernel_mttkrp0_k0;
  adf::kernel kernel_mttkrp_k1;
  adf::kernel kernel_mttkrp0_k2;
  adf::kernel kernel_mttkrp_k3;
  adf::kernel kernel_mttkrp0_k4;
  adf::kernel kernel_mttkrp_k5;
  adf::kernel kernel_mttkrp0_k6;
  adf::kernel kernel_mttkrp_k7;

public:
  adf::input_plio v0;
  adf::input_plio v1;
  adf::input_plio v2;
  adf::input_plio v3;
  adf::input_plio v4;
  adf::output_plio v5;
  adf::input_plio v6;
  adf::input_plio v7;
  adf::input_plio v8;
  adf::output_plio v9;
  adf::input_plio v10;
  adf::input_plio v11;
  adf::output_plio v12;
  adf::output_plio v13;

  adf_cell0() {
    kernel_mttkrp0_k0 = adf::kernel::create(kernel_mttkrp0);
    adf::source(kernel_mttkrp0_k0) = "kernel_mttkrp0.cc";
    adf::runtime<ratio>(kernel_mttkrp0_k0) = 1;
    adf::location<kernel>(kernel_mttkrp0_k0) = adf::tile(24, 0);
    adf::location<stack>(kernel_mttkrp0_k0) = adf::bank(24, 0, 3);
    kernel_mttkrp_k1 = adf::kernel::create(kernel_mttkrp);
    adf::source(kernel_mttkrp_k1) = "kernel_mttkrp.cc";
    adf::runtime<ratio>(kernel_mttkrp_k1) = 1;
    adf::location<kernel>(kernel_mttkrp_k1) = adf::tile(24, 1);
    adf::location<stack>(kernel_mttkrp_k1) = adf::bank(24, 1, 3);
    kernel_mttkrp0_k2 = adf::kernel::create(kernel_mttkrp0);
    adf::source(kernel_mttkrp0_k2) = "kernel_mttkrp0.cc";
    adf::runtime<ratio>(kernel_mttkrp0_k2) = 1;
    adf::location<kernel>(kernel_mttkrp0_k2) = adf::tile(24, 4);
    adf::location<stack>(kernel_mttkrp0_k2) = adf::bank(24, 4, 3);
    kernel_mttkrp_k3 = adf::kernel::create(kernel_mttkrp);
    adf::source(kernel_mttkrp_k3) = "kernel_mttkrp.cc";
    adf::runtime<ratio>(kernel_mttkrp_k3) = 1;
    adf::location<kernel>(kernel_mttkrp_k3) = adf::tile(24, 5);
    adf::location<stack>(kernel_mttkrp_k3) = adf::bank(24, 5, 3);
    kernel_mttkrp0_k4 = adf::kernel::create(kernel_mttkrp0);
    adf::source(kernel_mttkrp0_k4) = "kernel_mttkrp0.cc";
    adf::runtime<ratio>(kernel_mttkrp0_k4) = 1;
    adf::location<kernel>(kernel_mttkrp0_k4) = adf::tile(24, 2);
    adf::location<stack>(kernel_mttkrp0_k4) = adf::bank(24, 2, 3);
    kernel_mttkrp_k5 = adf::kernel::create(kernel_mttkrp);
    adf::source(kernel_mttkrp_k5) = "kernel_mttkrp.cc";
    adf::runtime<ratio>(kernel_mttkrp_k5) = 1;
    adf::location<kernel>(kernel_mttkrp_k5) = adf::tile(24, 3);
    adf::location<stack>(kernel_mttkrp_k5) = adf::bank(24, 3, 3);
    kernel_mttkrp0_k6 = adf::kernel::create(kernel_mttkrp0);
    adf::source(kernel_mttkrp0_k6) = "kernel_mttkrp0.cc";
    adf::runtime<ratio>(kernel_mttkrp0_k6) = 1;
    adf::location<kernel>(kernel_mttkrp0_k6) = adf::tile(24, 6);
    adf::location<stack>(kernel_mttkrp0_k6) = adf::bank(24, 6, 3);
    kernel_mttkrp_k7 = adf::kernel::create(kernel_mttkrp);
    adf::source(kernel_mttkrp_k7) = "kernel_mttkrp.cc";
    adf::runtime<ratio>(kernel_mttkrp_k7) = 1;
    adf::location<kernel>(kernel_mttkrp_k7) = adf::tile(24, 7);
    adf::location<stack>(kernel_mttkrp_k7) = adf::bank(24, 7, 3);
    v0 = adf::input_plio::create("v0", plio_128_bits, "data/v0.txt", 250);
    adf::location<PLIO>(v0) = shim(24, 4);
    v1 = adf::input_plio::create("v1", plio_128_bits, "data/v1.txt", 250);
    adf::location<PLIO>(v1) = shim(24, 2);
    v2 = adf::input_plio::create("v2", plio_128_bits, "data/v2.txt", 250);
    adf::location<PLIO>(v2) = shim(23, 4);
    v3 = adf::input_plio::create("v3", plio_128_bits, "data/v3.txt", 250);
    adf::location<PLIO>(v3) = shim(23, 2);
    v4 = adf::input_plio::create("v4", plio_128_bits, "data/v4.txt", 250);
    adf::location<PLIO>(v4) = shim(25, 4);
    v5 = adf::output_plio::create("v5", plio_128_bits, "data/v5.txt", 250);
    adf::location<PLIO>(v5) = shim(24, 4);
    v6 = adf::input_plio::create("v6", plio_128_bits, "data/v6.txt", 250);
    adf::location<PLIO>(v6) = shim(25, 2);
    v7 = adf::input_plio::create("v7", plio_128_bits, "data/v7.txt", 250);
    adf::location<PLIO>(v7) = shim(22, 4);
    v8 = adf::input_plio::create("v8", plio_128_bits, "data/v8.txt", 250);
    adf::location<PLIO>(v8) = shim(22, 2);
    v9 = adf::output_plio::create("v9", plio_128_bits, "data/v9.txt", 250);
    adf::location<PLIO>(v9) = shim(24, 2);
    v10 = adf::input_plio::create("v10", plio_128_bits, "data/v10.txt", 250);
    adf::location<PLIO>(v10) = shim(26, 4);
    v11 = adf::input_plio::create("v11", plio_128_bits, "data/v11.txt", 250);
    adf::location<PLIO>(v11) = shim(26, 2);
    v12 = adf::output_plio::create("v12", plio_128_bits, "data/v12.txt", 250);
    adf::location<PLIO>(v12) = shim(24, 0);
    v13 = adf::output_plio::create("v13", plio_128_bits, "data/v13.txt", 250);
    adf::location<PLIO>(v13) = shim(23, 4);
    adf::connect<>(v0.out[0], kernel_mttkrp0_k0.in[0]);
    adf::connect<>(v0.out[0], kernel_mttkrp0_k2.in[0]);
    adf::connect<>(v1.out[0], kernel_mttkrp0_k0.in[1]);
    adf::connect<>(v1.out[0], kernel_mttkrp_k1.in[1]);
    adf::connect<>(v1.out[0], kernel_mttkrp0_k4.in[1]);
    adf::connect<>(v1.out[0], kernel_mttkrp_k5.in[1]);
    adf::connect<>(v2.out[0], kernel_mttkrp0_k0.in[2]);
    adf::connect<>(v2.out[0], kernel_mttkrp0_k4.in[2]);
    location<buffer>(kernel_mttkrp0_k0.out[0]) =
    { address(24, 0, 0x4000),
      address(24, 0, 0x6000)};
    location<buffer>(kernel_mttkrp0_k0.in[1]) =
    { address(24, 0, 0x0000),
      address(24, 0, 0x2000)};
    location<buffer>(kernel_mttkrp0_k0.in[2]) =
    { address(24, 1, 0x4000),
      address(24, 1, 0x6000)};
    location<buffer>(kernel_mttkrp0_k0.in[0]) =
    { address(24, 1, 0x0000),
      address(24, 1, 0x2000)};
    adf::connect<>(kernel_mttkrp0_k0.out[0], kernel_mttkrp_k1.in[3]);
    adf::connect<>(v3.out[0], kernel_mttkrp_k1.in[0]);
    adf::connect<>(v3.out[0], kernel_mttkrp_k3.in[0]);
    adf::connect<>(v4.out[0], kernel_mttkrp_k1.in[2]);
    adf::connect<>(v4.out[0], kernel_mttkrp_k5.in[2]);
    location<buffer>(kernel_mttkrp_k1.out[0]) =
    { address(25, 1, 0x1000),
      address(25, 1, 0x3000)};
    location<buffer>(kernel_mttkrp_k1.in[1]) =
    { address(25, 1, 0x4000),
      address(25, 1, 0x6000)};
    location<buffer>(kernel_mttkrp_k1.in[2]) =
    { address(25, 1, 0x0000),
      address(25, 1, 0x2000)};
    location<buffer>(kernel_mttkrp_k1.in[0]) =
    { address(24, 0, 0x1000),
      address(24, 0, 0x3000)};
    adf::connect<>(kernel_mttkrp_k1.out[0], v5.in[0]);
    adf::connect<>(v6.out[0], kernel_mttkrp0_k2.in[1]);
    adf::connect<>(v6.out[0], kernel_mttkrp_k3.in[1]);
    adf::connect<>(v6.out[0], kernel_mttkrp0_k6.in[1]);
    adf::connect<>(v6.out[0], kernel_mttkrp_k7.in[1]);
    adf::connect<>(v7.out[0], kernel_mttkrp0_k2.in[2]);
    adf::connect<>(v7.out[0], kernel_mttkrp0_k6.in[2]);
    location<buffer>(kernel_mttkrp0_k2.out[0]) =
    { address(24, 4, 0x4000),
      address(24, 4, 0x6000)};
    location<buffer>(kernel_mttkrp0_k2.in[1]) =
    { address(24, 4, 0x0000),
      address(24, 4, 0x2000)};
    location<buffer>(kernel_mttkrp0_k2.in[2]) =
    { address(24, 5, 0x4000),
      address(24, 5, 0x6000)};
    location<buffer>(kernel_mttkrp0_k2.in[0]) =
    { address(24, 5, 0x0000),
      address(24, 5, 0x2000)};
    adf::connect<>(kernel_mttkrp0_k2.out[0], kernel_mttkrp_k3.in[3]);
    adf::connect<>(v8.out[0], kernel_mttkrp_k3.in[2]);
    adf::connect<>(v8.out[0], kernel_mttkrp_k7.in[2]);
    location<buffer>(kernel_mttkrp_k3.out[0]) =
    { address(25, 5, 0x1000),
      address(25, 5, 0x3000)};
    location<buffer>(kernel_mttkrp_k3.in[1]) =
    { address(25, 5, 0x4000),
      address(25, 5, 0x6000)};
    location<buffer>(kernel_mttkrp_k3.in[2]) =
    { address(25, 5, 0x0000),
      address(25, 5, 0x2000)};
    location<buffer>(kernel_mttkrp_k3.in[0]) =
    { address(24, 4, 0x1000),
      address(24, 4, 0x3000)};
    adf::connect<>(kernel_mttkrp_k3.out[0], v9.in[0]);
    adf::connect<>(v10.out[0], kernel_mttkrp0_k4.in[0]);
    adf::connect<>(v10.out[0], kernel_mttkrp0_k6.in[0]);
    location<buffer>(kernel_mttkrp0_k4.out[0]) =
    { address(24, 2, 0x4000),
      address(24, 2, 0x6000)};
    location<buffer>(kernel_mttkrp0_k4.in[1]) =
    { address(24, 2, 0x0000),
      address(24, 2, 0x2000)};
    location<buffer>(kernel_mttkrp0_k4.in[2]) =
    { address(24, 3, 0x4000),
      address(24, 3, 0x6000)};
    location<buffer>(kernel_mttkrp0_k4.in[0]) =
    { address(24, 3, 0x0000),
      address(24, 3, 0x2000)};
    adf::connect<>(kernel_mttkrp0_k4.out[0], kernel_mttkrp_k5.in[3]);
    adf::connect<>(v11.out[0], kernel_mttkrp_k5.in[0]);
    adf::connect<>(v11.out[0], kernel_mttkrp_k7.in[0]);
    location<buffer>(kernel_mttkrp_k5.out[0]) =
    { address(25, 3, 0x1000),
      address(25, 3, 0x3000)};
    location<buffer>(kernel_mttkrp_k5.in[1]) =
    { address(25, 3, 0x4000),
      address(25, 3, 0x6000)};
    location<buffer>(kernel_mttkrp_k5.in[2]) =
    { address(25, 3, 0x0000),
      address(25, 3, 0x2000)};
    location<buffer>(kernel_mttkrp_k5.in[0]) =
    { address(24, 2, 0x1000),
      address(24, 2, 0x3000)};
    adf::connect<>(kernel_mttkrp_k5.out[0], v12.in[0]);
    location<buffer>(kernel_mttkrp0_k6.out[0]) =
    { address(24, 6, 0x4000),
      address(24, 6, 0x6000)};
    location<buffer>(kernel_mttkrp0_k6.in[1]) =
    { address(24, 6, 0x0000),
      address(24, 6, 0x2000)};
    location<buffer>(kernel_mttkrp0_k6.in[2]) =
    { address(24, 7, 0x4000),
      address(24, 7, 0x6000)};
    location<buffer>(kernel_mttkrp0_k6.in[0]) =
    { address(24, 7, 0x0000),
      address(24, 7, 0x2000)};
    adf::connect<>(kernel_mttkrp0_k6.out[0], kernel_mttkrp_k7.in[3]);
    location<buffer>(kernel_mttkrp_k7.out[0]) =
    { address(25, 7, 0x1000),
      address(25, 7, 0x3000)};
    location<buffer>(kernel_mttkrp_k7.in[1]) =
    { address(25, 7, 0x4000),
      address(25, 7, 0x6000)};
    location<buffer>(kernel_mttkrp_k7.in[2]) =
    { address(25, 7, 0x0000),
      address(25, 7, 0x2000)};
    location<buffer>(kernel_mttkrp_k7.in[0]) =
    { address(24, 6, 0x1000),
      address(24, 6, 0x3000)};
    adf::connect<>(kernel_mttkrp_k7.out[0], v13.in[0]);
  }
};

#endif //__GRAPH_H__

