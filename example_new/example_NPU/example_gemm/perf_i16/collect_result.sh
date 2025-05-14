#!/bin/bash
echo "Directory, NPU execution time" > summary_results.txt
for dir in gemm_*/project; do
  log_file="$dir/result.log"
  [ -f "$log_file" ] && grep -m 1 "NPU execution time:" "$log_file" | \
  awk -v d=$(basename "$(dirname "$dir")") '{print d ", " $0}' >> summary_results.txt
done
echo "Collected results saved to summary_results.txt"