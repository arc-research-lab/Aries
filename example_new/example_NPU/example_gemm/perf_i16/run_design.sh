#!/bin/bash
set -e

# Run the designs in project directories
for dir in gemm_*/project; do
  if [ -d "$dir" ]; then
    echo "Running in $dir..."
    (cd "$dir" && make run > result.log 2>&1)
  else
    echo "Missing: $dir"
  fi
done