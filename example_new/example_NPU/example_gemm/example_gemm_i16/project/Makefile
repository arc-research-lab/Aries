MLIR_AIE_DIR = ${MLIR_AIE_INSTALL_DIR}/../../
FUNC=gemm
mlir_target=${FUNC}.adf.mlir
kernel_obj = build/kernel_gemm.o
EXTERN_KERNEL = $(wildcard ./aie/*.cc)
xclbin_target = ${FUNC}.xclbin
host_src = host/host.cpp
host_target=hostexe

all: kernel aie host copyhost

kernel: ${kernel_obj}
${kernel_obj}: ${EXTERN_KERNEL}
	mkdir -p ${@D}
	${PEANO_INSTALL_DIR}/bin/clang++ -O2 -v -std=c++20 --target=aie2-none-unknown-elf -Wno-parentheses -Wno-attributes -Wno-macro-redefined -DNDEBUG -I /home/arclab/research/local_Aries/Aries/example_new/example_NPU/example_gemm/../../../templates/aie2/origin/common -I ${MLIR_AIE_INSTALL_DIR}/include -c $< -o ${@}

aie: ${xclbin_target}
${xclbin_target}: ${mlir_target} ${kernel_obj}
			mkdir -p ${@D}
			cd build && ${MLIR_AIE_INSTALL_DIR}/bin/aiecc.py \
			--alloc-scheme=basic-sequential \
			--aie-generate-cdo \
			--no-compile-host \
			--xclbin-name=${@F} \
			--no-xchesscc \
			--no-xbridge \
			--peano ${PEANO_INSTALL_DIR} \
			--aie-generate-npu --npu-insts-name=insts.txt $(<:%=../%)

host:  ${host_target}
${host_target}: ${host_src}
	rm -rf _build
	mkdir -p _build
	cd _build &&  cmake ../ -DMLIR_AIE_DIR=${MLIR_AIE_DIR} -D CMAKE_C_COMPILER=gcc-13 -D CMAKE_CXX_COMPILER=g++-13 -DTARGET_NAME=${host_target} -Dsubdir=host \
						&&  cmake --build . --config Release

copyhost:
	cp -r _build/${host_target} ./

run: all copyhost
	./${host_target} -x build/${xclbin_target} -i build/insts.txt -k MLIR_AIE -v 2 --verify 1 --warmup 1 --iters 100

clean:
	rm -r _build build ${host_target}