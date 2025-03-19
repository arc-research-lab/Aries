
//===----------------------------------------------------------------------===//
//
// Automatically generated file for host.cpp
//
//===----------------------------------------------------------------------===//
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <fstream>
#include <cstring>
#include <time.h>
#include <vector>
#include <math.h>
#include <string>

// This is used for the PL Kernels
#include "experimental/xrt_bo.h"
#include "experimental/xrt_device.h"
#include "experimental/xrt_kernel.h"


// Using the ADF API that call XRT API
#include "adf/adf_api/XRTConfig.h"
//#include "../aie/adf_graph.h"

using namespace std;


int main(int argc, char **argv) {
  if(argc < 4) {
    std::cout << "Need to provide xclbin(file name), device id (int) and verify(0 or 1)\n";
    return 1;
  }
  char* xclbinFilename = argv[1];
  int deviceId, verify;
  if (sscanf (argv[2], "%i", &deviceId) != 1) {
    fprintf(stderr, "error - not an integer");
  }
  if (sscanf (argv[3], "%i", &verify) != 1) {
    fprintf(stderr, "error - not an integer");
  }
  
  // Open xclbin
  auto device = xrt::device(deviceId); //device index=0
	auto uuid = device.load_xclbin(xclbinFilename);
	auto dhdl = xrtDeviceOpenFromXcl(device);

  // PL control
  auto top_0= xrt::kernel(device, uuid, "top:{top_0}");

  // Define arguments
  std::vector<float> srcVec0;
  std::ifstream ifile0;
  if(verify){
    ifile0.open("data0.sim");
    if (!ifile0.is_open()){
      std::cerr << "Error: Could not open input file.\n";
      return 1;
    }
  }
  auto in_bohdl0 = xrt::bo(device, 16777216 * sizeof(float), top_0.group_id(0));
  auto in_bomapped0 = in_bohdl0.map<float*>();
  if(verify){
    for (unsigned i=0; i < 16777216; i++){
      float num;
      ifile0>> num;
      srcVec0.push_back(num);
    }
  }
  else{
    for (unsigned i=0; i < 16777216; i++){
      float num = (float)(rand()%5);
      srcVec0.push_back(num);
    }
  }
  memcpy(in_bomapped0, srcVec0.data(), srcVec0.size() * sizeof(float));  in_bohdl0.sync(XCL_BO_SYNC_BO_TO_DEVICE, 16777216 * sizeof(float), 0);

  std::vector<float> srcVec1;
  std::ifstream ifile1;
  if(verify){
    ifile1.open("data1.sim");
    if (!ifile1.is_open()){
      std::cerr << "Error: Could not open input file.\n";
      return 1;
    }
  }
  auto in_bohdl1 = xrt::bo(device, 524288 * sizeof(float), top_0.group_id(0));
  auto in_bomapped1 = in_bohdl1.map<float*>();
  if(verify){
    for (unsigned i=0; i < 524288; i++){
      float num;
      ifile1>> num;
      srcVec1.push_back(num);
    }
  }
  else{
    for (unsigned i=0; i < 524288; i++){
      float num = (float)(rand()%5);
      srcVec1.push_back(num);
    }
  }
  memcpy(in_bomapped1, srcVec1.data(), srcVec1.size() * sizeof(float));  in_bohdl1.sync(XCL_BO_SYNC_BO_TO_DEVICE, 524288 * sizeof(float), 0);

  std::vector<float> srcVec2;
  std::ifstream ifile2;
  if(verify){
    ifile2.open("data2.sim");
    if (!ifile2.is_open()){
      std::cerr << "Error: Could not open input file.\n";
      return 1;
    }
  }
  auto in_bohdl2 = xrt::bo(device, 3145728 * sizeof(float), top_0.group_id(0));
  auto in_bomapped2 = in_bohdl2.map<float*>();
  if(verify){
    for (unsigned i=0; i < 3145728; i++){
      float num;
      ifile2>> num;
      srcVec2.push_back(num);
    }
  }
  else{
    for (unsigned i=0; i < 3145728; i++){
      float num = (float)(rand()%5);
      srcVec2.push_back(num);
    }
  }
  memcpy(in_bomapped2, srcVec2.data(), srcVec2.size() * sizeof(float));  in_bohdl2.sync(XCL_BO_SYNC_BO_TO_DEVICE, 3145728 * sizeof(float), 0);

  std::vector<float> srcVec3;
  std::ifstream ifile3;
  if(verify){
    ifile3.open("data3.sim");
    if (!ifile3.is_open()){
      std::cerr << "Error: Could not open input file.\n";
      return 1;
    }
  }
  auto out_bohdl0 = xrt::bo(device, 1572864 * sizeof(float), top_0.group_id(0));
  auto out_bomapped0 = out_bohdl0.map<float*>();

  // AI Engine Graph Control
  std::cout << "Graph run\n";
  auto adf_cell0_gr0= xrt::graph(device, uuid, "adf_cell0_gr0");
  adf_cell0_gr0.run(-1);

  // Set arguments of the PL function
  xrt::run top_0_run= xrt::run(top_0);
  top_0_run.set_arg(0, in_bohdl0);
  top_0_run.set_arg(1, in_bohdl1);
  top_0_run.set_arg(2, in_bohdl2);
  top_0_run.set_arg(3, out_bohdl0);
  std::cout << "Kernel run\n";
  double kernel_time_in_sec = 0;
  std::chrono::duration<double> kernel_time(0);
  auto kernel_start = std::chrono::high_resolution_clock::now();
  top_0_run.start();
  top_0_run.wait();
  auto kernel_end = std::chrono::high_resolution_clock::now();
  kernel_time = std::chrono::duration<double>(kernel_end - kernel_start);
  kernel_time_in_sec = kernel_time.count();
  std::cout << "Kernel run finished!\n";
  std::cout << "Total time is: "<< kernel_time_in_sec<< "s" << std::endl;
  // Sync output buffer back to host
  out_bohdl0.sync(XCL_BO_SYNC_BO_FROM_DEVICE , 1572864 * sizeof(float), 0);
  std::cout << "Output buffer sync back finished\n";

  int errorCount = 0;
  if(verify){
    std::cout << "Start results verification\n";
    for (unsigned i=0; i < 1572864; i++){
      if(abs((float)(srcVec3[i]-out_bomapped0[i])>=1e-4)){
        printf("Error found srcVec3[%d]!=out_bomapped0[%d], %f!=%f ", i, i, srcVec3[i], out_bomapped0[i]);
        errorCount++;
      }
    }
    if (errorCount)
      printf("Test failed with %d errors\n", errorCount);
    else
      printf("TEST PASSED\n");
  }
  if(verify){
    ifile0.close();
    ifile1.close();
    ifile2.close();
    ifile3.close();
  }
  std::cout << "Host Run Finished!\n";
  return 0;
}


