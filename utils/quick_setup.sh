#!/usr/bin/env bash
##===- quick_setup.sh - Setup IRON for Ryzen AI dev ----------*- Script -*-===##
# 
# This file licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# 
##===----------------------------------------------------------------------===##
#
# This script is the quickest path to running the Ryzen AI reference designs.
# Please have the Vitis tools and XRT environment setup before sourcing the 
# script.
#
# source ./utils/quick_setup.sh
#
##===----------------------------------------------------------------------===##

echo "Setting up RyzenAI developement tools..."
if [[ $WSL_DISTRO_NAME == "" ]]; then
  XRTSMI=`which xrt-smi`
  if ! test -f "$XRTSMI"; then 
    echo "XRT is not installed"
    return 1
  fi
  NPU=`/opt/xilinx/xrt/bin/xrt-smi examine | grep RyzenAI`
  if [[ $NPU == *"RyzenAI"* ]]; then
    echo "Ryzen AI NPU found:"
    echo $NPU
  else
    echo "NPU not found. Is the amdxdna driver installed?"
    return 1
  fi
else
  echo "Environment is WSL"
fi
if hash python3.12; then
   echo "Using python version `python3.12 --version`"
   my_python=python3.12
elif hash python3.10; then
   echo "Using python version `python3.10 --version`"
   my_python=python3.10
else
   echo "This script requires python3.10 or python3.12"
   return 1
fi
if ! hash unzip; then
  echo "unzip is not installed"
  return 1
fi
python3 -m pip install --upgrade pip
VPP=`which xchesscc`
if test -f "$VPP"; then
  mkdir -p my_install
  pushd my_install
  pip download mlir_aie==0.0.1.2025010704+30300fa -f https://github.com/Xilinx/mlir-aie/releases/expanded_assets/latest-wheels/
  unzip -q mlir_aie-*_x86_64.whl
  pushd mlir_aie/python
  pip download aie_python_bindings==0.0.1.2025010704+30300fa -f https://github.com/Xilinx/mlir-aie/releases/expanded_assets/latest-wheels/
  unzip -q -o aie_python_bindings*.whl
  rm *.whl
  popd
  pip download mlir==20.0.0.2024121901+f334db92 -f https://github.com/Xilinx/mlir-aie/releases/expanded_assets/mlir-distro/
  unzip -q mlir-*_x86_64.whl
  pip -q download llvm-aie==19.0.0.2025010701+9d60f535 -f https://github.com/Xilinx/llvm-aie/releases/expanded_assets/nightly
  unzip -q llvm_aie*.whl
  rm -rf mlir*.whl
  rm -rf llvm_aie*.whl
  export PEANO_INSTALL_DIR=`realpath llvm-aie`
  popd

  HOST_MLIR_PYTHON_PACKAGE_PREFIX=aie python3 -m pip install git+https://github.com/makslevental/mlir-python-extras@b2b8d72
  source utils/env_setup.sh my_install/mlir_aie my_install/mlir

  # This creates an ipykernel (for use in notebooks) using the aries venv
  python3 -m ipykernel install --user --name aries

  # right now, mlir-aie install dire is generally captures in the $PYTHONPATH by the setup_env script.
  # However, jupyter notebooks don't always get access to the PYTHONPATH (e.g. if they are run with
  # vscode) so we save the ${MLIR_AIE_INSTALL_DIR}/python in a .pth file in the site packages dir of the
  # aries venv; this allows the iron ipykernel to find the install dir regardless of if PYTHONPATH is
  # available or not.
  venv_site_packages=`python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])'`
  echo ${MLIR_AIE_INSTALL_DIR}/python > $venv_site_packages/mlir-aie.pth
  echo "PATH              : $PATH"
  echo "LD_LIBRARY_PATH   : $LD_LIBRARY_PATH"
  echo "PYTHONPATH        : $PYTHONPATH"
else
  echo "Vitis not found! Exiting..."
fi
