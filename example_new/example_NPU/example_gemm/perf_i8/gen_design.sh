#!/bin/bash
set -e
PYTHON=python3
dims=(256 512 1024 2048 4096)
configs=("4 4")

for I in "${dims[@]}"; do
  for K in "${dims[@]}"; do
    for J in "${dims[@]}"; do
      $PYTHON generate_gemm.py --I $I --K $K --J $J
      for cfg in "${configs[@]}"; do
        read PI PJ <<< "$cfg"
        $PYTHON gemm_${I}x${K}x${J}.py --PI $PI --PJ $PJ
      done
    done
  done
done