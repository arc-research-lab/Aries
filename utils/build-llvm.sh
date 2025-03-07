PRO_PATH=$PWD
LLVM_DIR=`realpath ${1:-"$PWD/externals/llvm-project"}`
CMAKE=`realpath ${2:-"$PWD/aries/bin/cmake"}`
BUILD_DIR=build
INSTALL_DIR=install

mkdir -p $LLVM_DIR/$BUILD_DIR
mkdir -p $LLVM_DIR/$INSTALL_DIR
LLVM_ENABLE_RTTI=${LLVM_ENABLE_RTTI:OFF}

# Enter a sub-shell to avoid messing up with current directory in case of error
(
cd $LLVM_DIR/$BUILD_DIR
set -o pipefail
set -e

CMAKE_CONFIGS="\
    -GNinja \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_USE_LINKER=lld \
    -DPython3_FIND_VIRTUALENV=ONLY \
    -DLLVM_BUILD_LLVM_DYLIB=OFF \
    -DLLVM_LINK_LLVM_DYLIB=OFF \
    -DLLVM_BUILD_EXAMPLES=OFF \
    -DLLVM_BUILD_UTILS=ON \
    -DLLVM_ENABLE_RTTI=$LLVM_ENABLE_RTTI \
    -DLLVM_INSTALL_UTILS=ON \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DCMAKE_INSTALL_PREFIX=../$INSTALL_DIR \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_TARGETS_TO_BUILD:STRING=X86 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PLATFORM_NO_VERSIONED_SONAME=ON \
    -DCMAKE_VISIBILITY_INLINES_HIDDEN=ON \
    -DCMAKE_C_VISIBILITY_PRESET=hidden \
    -DCMAKE_CXX_VISIBILITY_PRESET=hidden \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=1"


$CMAKE $CMAKE_CONFIGS ../llvm 2>&1 | tee cmake.log
ninja 2>&1 | tee ninja.log
ninja install 2>&1 | tee ninja-install.log
)

cd ${PRO_PATH}