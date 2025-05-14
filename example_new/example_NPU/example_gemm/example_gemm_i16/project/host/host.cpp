  
//===----------------------------------------------------------------------===//
//
// Automatically generated file for NPU test.cpp
//
//===----------------------------------------------------------------------===//
#include <boost/program_options.hpp>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "xrt/xrt_bo.h"
#include "xrt/xrt_device.h"
#include "xrt/xrt_kernel.h"

#include "test_utils.h"

namespace po = boost::program_options;

int main(int argc, const char *argv[]) {

  // Program arguments parser
  po::options_description desc("Allowed options");
  po::variables_map vm;
  test_utils::add_default_options(desc);

  test_utils::parse_options(argc, argv, desc, vm);
  int verbosity = vm["verbosity"].as<int>();
  int do_verify = vm["verify"].as<bool>();
  int n_iterations = vm["iters"].as<int>();
  int n_warmup_iterations = vm["warmup"].as<int>();
  int trace_size = vm["trace_sz"].as<int>();

  // Load instruction
  std::vector<uint32_t> instr_v =
      test_utils::load_instr_sequence(vm["instr"].as<std::string>());
  if (verbosity >= 1)
    std::cout << "Sequence instr count: " << instr_v.size() << "\n";

  // Get a device handle
  unsigned int device_index = 0;
  auto device = xrt::device(device_index);

  // Load the xclbin
  if (verbosity >= 1)
    std::cout << "Loading xclbin: " << vm["xclbin"].as<std::string>() << "\n";
  auto xclbin = xrt::xclbin(vm["xclbin"].as<std::string>());

  if (verbosity >= 1)
    std::cout << "Kernel opcode: " << vm["kernel"].as<std::string>() << "\n";
  std::string Node = vm["kernel"].as<std::string>();

  // Get the kernel from the xclbin
  auto xkernels = xclbin.get_kernels();
  auto xkernel = *std::find_if(xkernels.begin(), xkernels.end(),
                               [Node, verbosity](xrt::xclbin::kernel &k) {
                                 auto name = k.get_name();
                                 if (verbosity >= 1) {
                                   std::cout << "Name: " << name << std::endl;
                                 }
                                 return name.rfind(Node, 0) == 0;
                               });
  auto kernelName = xkernel.get_name();

  // Register the xclbin
  if (verbosity >= 1)
    std::cout << "Registering xclbin: " << vm["xclbin"].as<std::string>()
              << "\n";
  device.register_xclbin(xclbin);

  // Get a hardware context
  if (verbosity >= 1)
    std::cout << "Getting hardware context.\n";
  xrt::hw_context context(device, xclbin.get_uuid());

  // Get a kernel handle
  if (verbosity >= 1)
    std::cout << "Getting handle to kernel:" << kernelName << "\n";
  auto kernel = xrt::kernel(context, kernelName);

  // Initialize input/ output buffer
  auto bo_instr = xrt::bo(device, instr_v.size() * sizeof(int),
                          XCL_BO_FLAGS_CACHEABLE, kernel.group_id(1));
  void *bufInstr = bo_instr.map<void *>();
  memcpy(bufInstr, instr_v.data(), instr_v.size() * sizeof(int));

  // Read data from files
  std::ifstream ifile0("data0.sim");
  if (!ifile0.is_open()) {
    std::cerr << "Error: Could not open input file.\n";
    return 1;
  }
  std::vector<int16_t> srcVec0;
  for (int i = 0; i < 1048576; i++) {
    int16_t num;
    ifile0 >> num;
    srcVec0.push_back(num);
  }
  auto bo_A = xrt::bo(device, 1048576 * sizeof(int16_t),
                      XRT_BO_FLAGS_HOST_ONLY, kernel.group_id(4));
  // Initialized buffer
  int16_t *bufA = bo_A.map<int16_t *>();
  memcpy(bufA, srcVec0.data(), (srcVec0.size() * sizeof(int16_t)));

  // Read data from files
  std::ifstream ifile1("data1.sim");
  if (!ifile1.is_open()) {
    std::cerr << "Error: Could not open input file.\n";
    return 1;
  }
  std::vector<int16_t> srcVec1;
  for (int i = 0; i < 1048576; i++) {
    int16_t num;
    ifile1 >> num;
    srcVec1.push_back(num);
  }
  auto bo_B = xrt::bo(device, 1048576 * sizeof(int16_t),
                      XRT_BO_FLAGS_HOST_ONLY, kernel.group_id(5));
  // Initialized buffer
  int16_t *bufB = bo_B.map<int16_t *>();
  memcpy(bufB, srcVec1.data(), (srcVec1.size() * sizeof(int16_t)));

  // Read data from files
  std::ifstream ifile2("data2.sim");
  if (!ifile2.is_open()) {
    std::cerr << "Error: Could not open input file.\n";
    return 1;
  }
  std::vector<int16_t> srcVec2;
  for (int i = 0; i < 1048576; i++) {
    int16_t num;
    ifile2 >> num;
    srcVec2.push_back(num);
  }
  auto bo_C = xrt::bo(device, 1048576 * sizeof(int16_t),
                      XRT_BO_FLAGS_HOST_ONLY, kernel.group_id(6));
  // Sync input from host to device
  bo_instr.sync(XCL_BO_SYNC_BO_TO_DEVICE);
  bo_A.sync(XCL_BO_SYNC_BO_TO_DEVICE);
  bo_B.sync(XCL_BO_SYNC_BO_TO_DEVICE);
  std::cout << "Warmup Kernel.\n";
  for (int i = 0; i < n_warmup_iterations; i++) {
    unsigned int opcode = 3;
    auto run = kernel(opcode, bo_instr, instr_v.size(), bo_A, bo_B, bo_C);
    run.wait();
  }

  if (verbosity >= 1){
    std::cout << "Running Kernel.\n";
  }

  double kernel_time_in_sec = 0;
  std::chrono::duration<double> kernel_time(0);
  auto kernel_start = std::chrono::high_resolution_clock::now();
  for (int i = 0; i < n_iterations; i++) {
    unsigned int opcode = 3;
    auto run = kernel(opcode, bo_instr, instr_v.size(), bo_A, bo_B, bo_C);
    run.wait();
  }

  auto kernel_end = std::chrono::high_resolution_clock::now();
  kernel_time = std::chrono::duration<double>(kernel_end - kernel_start);
  kernel_time_in_sec = kernel_time.count()/n_iterations;
  std::cout << "NPU execution time: " << kernel_time_in_sec << "s\n";

  // Sync output from device to host
  bo_C.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
  int16_t *bufC = bo_C.map<int16_t *>();
  int errorCount = 0;
  if(do_verify){
    for (int i = 0; i < 1048576; i++) {
      if(abs((float)(srcVec2[i])-bufC[i])>=1e-4){
        printf("Error found srcVec2[%d]!=bufC[%d], %d!=%d \n", i, i, srcVec2[i], bufC[i]);
        errorCount++;
      }
    }
  }

  if (errorCount)
    printf("TEST failed with %d errors\n", errorCount);
  else
    printf("TEST PASSED\n");
  ifile0.close();
  ifile1.close();
  ifile2.close();
}

