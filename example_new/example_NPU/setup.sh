MLIR_AIE_BUILD_DIR=$PWD
source ./aries/bin/activate
source /opt/xilinx/xrt/setup.sh
export MLIR_AIE_INSTALL_DIR=${MLIR_AIE_BUILD_DIR}/my_install/mlir_aie
export PEANO_INSTALL_DIR=${MLIR_AIE_BUILD_DIR}/my_install/llvm-aie
export LLVM_INSTALL_DIR=${MLIR_AIE_BUILD_DIR}/my_install/mlir
export PATH=${PEANO_INSTALL_DIR}/bin:${MLIR_AIE_INSTALL_DIR}/bin:${LLVM_INSTALL_DIR}/bin:${PATH} 
export LD_LIBRARY_PATH=${PEANO_INSTALL_DIR}/bin:${MLIR_AIE_INSTALL_DIR}/lib:${LLVM_INSTALL_DIR}/lib:${LD_LIBRARY_PATH}