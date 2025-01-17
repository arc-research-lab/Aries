FUNC:=gemm
MLIR:=${FUNC}
PROJECT_NAME:=adf_graph_${FUNC}
KERNEL_NAME:=kernel_${FUNC}
PROJECT_PATH=./${PROJECT_NAME}
PROJECT_AIE_PATH=${PROJECT_PATH}/aie
PROJECT_PL_PATH=${PROJECT_PATH}/kernel
PROJECT_Host_PATH=${PROJECT_PATH}/host
TEMPLATE_PATH = ../../
EN_PL = "true"
PLIOWidth = 128
AXIWidth = 512
ColNum = 50
RowNum = 8
ColOffset = 0 
RowOffset = 0
ColGap = 0
CoreAlgo = 1
FirstCol = 6
NumShim = 39
MidLine = 24
ChalIn = 3
ChalOut = 3
EnableIOCons = "false"
Link_file = 1
L1_0=32
L1_1=32
L1_2=32
L2_0=11
L2_1=8
L2_2=4
L3_0=4
L3_1=6
L3_2=1
BUFF_0=1#1:BRAM 0:URAM
BUFF_1=1
BUFF_2=0
ifeq ($(EN_PL), "true")
	IOType=PLIO
else
	IOType=GMIO
endif

all: fileCreate copyFile pass translate copyplhost printcommand

printcommand:
	@echo "PLIOWidth=${PLIOWidth}, AXIWidth=${AXIWidth}, ColNum=${ColNum}, RowNum=${RowNum}, ColOffset=${ColOffset}, RowOffset=${RowOffset}, ColGap=${ColGap}, CoreAlgo=${CoreAlgo}, FirstCol=${FirstCol}, NumShim=${NumShim}, MidLine=${MidLine}, ChalIn=${ChalIn}, ChalOut=${ChalOut}, EnableIOCons=${EnableIOCons}, L1_0=${L1_0}, L1_1=${L1_1}, L1_2=${L1_2}, L2_0=${L2_0}, L2_1=${L2_1}, L2_2=${L2_2}, L3_0=${L3_0}, L3_1=${L3_1}, L3_2=${L3_2}, IOType=${IOType}" >${PROJECT_PATH}/command

fileCreate:
	mkdir -p ${PROJECT_AIE_PATH}
	mkdir -p ${PROJECT_PL_PATH}
	mkdir -p ${PROJECT_Host_PATH}

copyFile:
	cp -r ${TEMPLATE_PATH}/template_files/Makefile_VCK190 ${PROJECT_PATH}/Makefile

test: doublebuffer

tile:${PROJECT_PATH}/0_${FUNC}.tiled.mlir
${PROJECT_PATH}/0_${FUNC}.tiled.mlir: ${MLIR}.mlir
	aries-opt -o $@ $< \
			-aries-tiling="tile-func-name=gemm l1-tile-sizes=${L1_0},${L1_1},${L1_2} l2-tile-sizes=${L2_0},${L2_1},${L2_2} l3-tile-sizes=${L3_0},${L3_1},${L3_2}"

exfunc: ${PROJECT_PATH}/1_${FUNC}.exfunc.mlir
${PROJECT_PATH}/1_${FUNC}.exfunc.mlir: ${PROJECT_PATH}/0_${FUNC}.tiled.mlir
	aries-opt -o $@ $< \
			-aries-func-extract

loopsim: ${PROJECT_PATH}/2_${FUNC}.loopsim.mlir
${PROJECT_PATH}/2_${FUNC}.loopsim.mlir: ${PROJECT_PATH}/1_${FUNC}.exfunc.mlir
	aries-opt -o $@ $< \
			-aries-loop-simplify

mem: ${PROJECT_PATH}/3_${FUNC}.memsubview.mlir
${PROJECT_PATH}/3_${FUNC}.memsubview.mlir: ${PROJECT_PATH}/2_${FUNC}.loopsim.mlir
	aries-opt -o $@ $< \
			-aries-mem-subview

hoistmem: ${PROJECT_PATH}/4_${FUNC}.hoistmem.mlir
${PROJECT_PATH}/4_${FUNC}.hoistmem.mlir: ${PROJECT_PATH}/3_${FUNC}.memsubview.mlir
	aries-opt -o $@ $< \
			-aries-mem-hoist

copymem: ${PROJECT_PATH}/5_${FUNC}.copymem.mlir
${PROJECT_PATH}/5_${FUNC}.copymem.mlir: ${PROJECT_PATH}/4_${FUNC}.hoistmem.mlir
	aries-opt -o $@ $< \
			-aries-mem-copy

toadf: ${PROJECT_PATH}/6_${FUNC}.adf.mlir
${PROJECT_PATH}/6_${FUNC}.adf.mlir: ${PROJECT_PATH}/5_${FUNC}.copymem.mlir
	aries-opt -o $@ $< \
			-aries-lower-to-adf \
			-canonicalize -cse

flow: ${PROJECT_PATH}/7_${FUNC}.flow.mlir
${PROJECT_PATH}/7_${FUNC}.flow.mlir: ${PROJECT_PATH}/6_${FUNC}.adf.mlir
	aries-opt -o $@ $< \
			-aries-dependency-extract

unrollfunc: ${PROJECT_PATH}/8_${FUNC}.unrollfunc.mlir
${PROJECT_PATH}/8_${FUNC}.unrollfunc.mlir: ${PROJECT_PATH}/7_${FUNC}.flow.mlir
	aries-opt -o $@ $< \
			-aries-func-unroll

dataforward: ${PROJECT_PATH}/9_${FUNC}.dataforward.mlir
${PROJECT_PATH}/9_${FUNC}.dataforward.mlir: ${PROJECT_PATH}/8_${FUNC}.unrollfunc.mlir
	aries-opt -o $@ $< \
			-aries-local-data-forward

kernelio: ${PROJECT_PATH}/10_${FUNC}.kernelio.mlir
${PROJECT_PATH}/10_${FUNC}.kernelio.mlir: ${PROJECT_PATH}/9_${FUNC}.dataforward.mlir
	aries-opt -o $@ $< \
			-aries-kernel-interface-create

dmaio: ${PROJECT_PATH}/11_${FUNC}.dmaio.mlir
${PROJECT_PATH}/11_${FUNC}.dmaio.mlir: ${PROJECT_PATH}/10_${FUNC}.kernelio.mlir
	aries-opt -o $@ $< \
			-aries-dma-to-io="port-type=${IOType} plio-width=${PLIOWidth}" \
			-canonicalize -cse

adfgraph: ${PROJECT_PATH}/12_${FUNC}.adfgraph.mlir
${PROJECT_PATH}/12_${FUNC}.adfgraph.mlir: ${PROJECT_PATH}/11_${FUNC}.dmaio.mlir
	aries-opt -o $@ $< \
			-aries-adf-cell-create

coreplacement: ${PROJECT_PATH}/13_${FUNC}.coreplacement.mlir
${PROJECT_PATH}/13_${FUNC}.coreplacement.mlir: ${PROJECT_PATH}/12_${FUNC}.adfgraph.mlir
	aries-opt -o $@ $< \
			-aries-core-placement="col-num=${ColNum} row-num=${RowNum} col-offset=${ColOffset} row-offset=${RowOffset} core-algo=${CoreAlgo}"

ioplacement: ${PROJECT_PATH}/14_${FUNC}.ioplacement.mlir
${PROJECT_PATH}/14_${FUNC}.ioplacement.mlir: ${PROJECT_PATH}/13_${FUNC}.coreplacement.mlir
	aries-opt -o $@ $< \
			-aries-io-placement="first-col=${FirstCol} num-shim=${NumShim} mid-line=${MidLine} chal-in=${ChalIn} chal-out=${ChalOut} iocons=${EnableIOCons}"

iomaterialize: ${PROJECT_PATH}/15_${FUNC}.iomaterialize.mlir
${PROJECT_PATH}/15_${FUNC}.iomaterialize.mlir: ${PROJECT_PATH}/14_${FUNC}.ioplacement.mlir
	aries-opt -o $@ $< \
			-aries-gmio-materialize \
			-aries-plio-materialize="buf-sels=${BUFF_0},${BUFF_1},${BUFF_2}"

axipacking: ${PROJECT_PATH}/16_${FUNC}.axipacking.mlir
${PROJECT_PATH}/16_${FUNC}.axipacking.mlir: ${PROJECT_PATH}/15_${FUNC}.iomaterialize.mlir
	aries-opt -o $@ $< \
			-aries-axi-packing="axi-width=${AXIWidth}"

pldataflow: ${PROJECT_PATH}/17_${FUNC}.pldataflow.mlir
${PROJECT_PATH}/17_${FUNC}.pldataflow.mlir: ${PROJECT_PATH}/16_${FUNC}.axipacking.mlir
	aries-opt -o $@ $< \
			-aries-pl-dataflow \
			-canonicalize -cse

burstDetect: ${PROJECT_PATH}/18_${FUNC}.burstdetect.mlir
${PROJECT_PATH}/18_${FUNC}.burstdetect.mlir: ${PROJECT_PATH}/17_${FUNC}.pldataflow.mlir
	aries-opt -o $@ $< \
			-aries-burst-detection

funcEliminate: ${PROJECT_PATH}/19_${FUNC}.funcEliminate.mlir
${PROJECT_PATH}/19_${FUNC}.funcEliminate.mlir: ${PROJECT_PATH}/18_${FUNC}.burstdetect.mlir
	aries-opt -o $@ $< \
			-aries-func-eliminate

doublebuffer: ${PROJECT_PATH}/20_${FUNC}.doublebuffer.mlir
${PROJECT_PATH}/20_${FUNC}.doublebuffer.mlir: ${PROJECT_PATH}/19_${FUNC}.funcEliminate.mlir
	aries-opt -o $@ $< \
			-aries-pl-double-buffer \
			-canonicalize -cse

testgen: ${PROJECT_AIE_PATH}/adf_graph_test.cpp
${PROJECT_AIE_PATH}/adf_graph_test.cpp: ${PROJECT_PATH}/20_${FUNC}.doublebuffer.mlir
	aries-translate -o $@ $< \
		-emit-aries-kernels

pass: ${PROJECT_PATH}/${FUNC}.adf.mlir
${PROJECT_PATH}/${FUNC}.adf.mlir: ${MLIR}.mlir
	aries-opt -o $@ $< \
			-aries-tiling="tile-func-name=gemm l1-tile-sizes=${L1_0},${L1_1},${L1_2} l2-tile-sizes=${L2_0},${L2_1},${L2_2} l3-tile-sizes=${L3_0},${L3_1},${L3_2}" \
			-aries-func-extract \
			-aries-loop-simplify \
			-aries-mem-subview \
			-aries-mem-hoist \
			-aries-mem-copy \
			-aries-lower-to-adf \
			-canonicalize -cse \
			-aries-dependency-extract \
			-aries-func-unroll \
			-aries-local-data-forward \
			-aries-kernel-interface-create \
			-aries-dma-to-io="port-type=${IOType} plio-width=${PLIOWidth}" \
			-canonicalize -cse \
			-aries-adf-cell-create \
			-aries-core-placement="col-num=${ColNum} row-num=${RowNum} col-offset=${ColOffset} row-offset=${RowOffset} core-gap=${ColGap} core-algo=${CoreAlgo}" \
			-aries-io-placement="first-col=${FirstCol} num-shim=${NumShim} mid-line=${MidLine} chal-in=${ChalIn} chal-out=${ChalOut} iocons=${EnableIOCons}" \
			-aries-gmio-materialize \
			-aries-plio-materialize="buf-sels=${BUFF_0},${BUFF_1},${BUFF_2}" \
			-aries-axi-packing="axi-width=${AXIWidth}" \
			-aries-pl-dataflow \
			-canonicalize -cse \
			-aries-burst-detection \
			-aries-func-eliminate  \
			-aries-pl-double-buffer\
			-canonicalize -cse

translate: file_split kernel_file_split kernel_link clean_kernel_vec
file_split: tempfile
	aries-opt <${MLIR}.mlir \
		-aries-file-split="inputfile-name=temp.cpp path-name=${PROJECT_AIE_PATH}/" \
		>/dev/null
tempfile: ${PROJECT_AIE_PATH}/temp.cpp
${PROJECT_AIE_PATH}/temp.cpp: ${PROJECT_PATH}/${FUNC}.adf.mlir
	aries-translate -o $@ $< \
		-emit-aries-kernels

copyplhost:
ifeq ($(EN_PL), "true")
	mv ${PROJECT_AIE_PATH}/host.cpp ${PROJECT_Host_PATH}
	mv ${PROJECT_AIE_PATH}/hls.cpp ${PROJECT_PL_PATH}
	mv ${PROJECT_AIE_PATH}/system.cfg ${PROJECT_PATH}
endif

kernel_split: ${PROJECT_PATH}/${KERNEL_NAME}.mlir
${PROJECT_PATH}/${KERNEL_NAME}.mlir: ${PROJECT_PATH}/${FUNC}.adf.mlir
	aries-opt -o $@ $< \
		-aries-kernel-split

kernel_vec: ${PROJECT_PATH}/auto_${KERNEL_NAME}_aie.mlir
${PROJECT_PATH}/auto_${KERNEL_NAME}_aie.mlir: ${PROJECT_PATH}/${KERNEL_NAME}_vector.mlir
	aries-opt -o $@ $< \
		--aie-vectorize \
		-unaligned-loads-check=false \
		-canonicalize -cse
${PROJECT_PATH}/${KERNEL_NAME}_vector.mlir: ${PROJECT_PATH}/${KERNEL_NAME}_unroll.mlir
	aries-opt -o $@ $< \
		--affine-super-vectorize="virtual-vector-size=8 vectorize-reductions" \
		--canonicalize
${PROJECT_PATH}/${KERNEL_NAME}_unroll.mlir: ${PROJECT_PATH}/${KERNEL_NAME}.mlir
	aries-opt -o $@ $< \
		--affine-loop-unroll="unroll-factor=8" \
		--canonicalize

kernel_file_split: kernel_cc
	aries-opt <${MLIR}.mlir \
		-aries-file-split="inputfile-name=temp.cc path-name=${PROJECT_AIE_PATH}/" \
		>/dev/null
kernel_cc: ${PROJECT_AIE_PATH}/temp.cc
${PROJECT_AIE_PATH}/temp.cc: ${PROJECT_PATH}/auto_${KERNEL_NAME}_aie.mlir
	aries-translate -o $@ $< \
		-emit-kenrel-func

ifeq ($(Link_file),1)
kernel_link:
	cp -r ${TEMPLATE_PATH}/template_files/kernel_mm/aie_int32_v1/kernel_gemm* ${PROJECT_AIE_PATH}
endif

clean_kernel_vec:
	rm -rf ${PROJECT_PATH}/${KERNEL_NAME}_vector.mlir ${PROJECT_PATH}/${KERNEL_NAME}_unroll.mlir ${PROJECT_PATH}/${KERNEL_NAME}.mlir

clean_test:
	rm -rf ${PROJECT_PATH}/*_${FUNC}.*

clean_testgen:
	rm -rf ${PROJECT_AIE_PATH}/adf_graph_test.cpp

clean_translate:
	rm -rf ${PROJECT_AIE_PATH}/adf_graph.cpp ${PROJECT_AIE_PATH}/kernel.h ${PROJECT_AIE_PATH}/${KERNEL_NAME}.cc

clean_pass:
	rm -rf ${PROJECT_PATH}/${FUNC}.adf.mlir

clean:
	rm -rf ${PROJECT_PATH}