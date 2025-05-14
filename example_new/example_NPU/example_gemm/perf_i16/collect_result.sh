#!/bin/bash
echo "Directory, Test Result, NPU Execution Time" > summary_results.txt
for dir in gemm_*/project; do
  log_file="$dir/result.log"
  [ -f "$log_file" ] && { 
    test_result=$(grep -m 1 "^TEST" "$log_file")
    npu_time=$(grep -m 1 "^NPU execution time:" "$log_file")
    echo "$(basename "$(dirname "$dir")"), \"$test_result\", \"$npu_time\"" >> summary_results.txt
  }
done
echo "Collected results saved to summary_results.txt"