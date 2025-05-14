#!/bin/bash
set -e
PYTHON=python3
dims=(256 512 1024 2048 4096)
configs=("2 2" "2 4" "4 4")

for d in "${dims[@]}"; do
  $PYTHON generate_gemm.py --I $d --K $d --J $d
  for cfg in "${configs[@]}"; do
    read PI PJ <<< "$cfg"
    $PYTHON gemm_${d}x${d}x${d}.py --PI $PI --PJ $PJ
  done
done