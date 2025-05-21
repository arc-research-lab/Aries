##  Reproduce ARIES Experiment Results

## *** Step 1: VCK190 compilation environment setup 

### Download Common Image [VCK190 Setup](../utils/README.md#-vck190-setup)

### Setup Vitis environment
```sh 
source /tools/Xilinx/Vitis/2023.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
unset LD_LIBRARY_PATH (If needed)
source /opt/petalinux/2023.2/environment-setup-cortexa72-cortexa53-xilinx-linux
```

## ***  Step 2: Setup and compile project

you may need to source the Aries python environment again:
```sh
source <PATH_TO_ARIES>/aries/bin/activate
```
### Create ARIES Initial IR and ARIES Makefile from user defined ARIES Python-based frontend.(Within 10 seconds)

```sh
cd example_Versal/example_gemm
python3 gemm.py
```

### Generate code for Host + PL + AIE (Need to have ARIES installed, i.e.,  tools including aries-opt and aries-translate should run correctly) (Within 10 seconds)
```sh
cd my_project
make all
```

### Compile the generated project (Around 1-5 hours according to design complexity and the performance of the build machine)
```sh
cd project
make package EDGE_COMMON_SW_PATH=${PATH_Include_xilinx-versal-common-v2023.2}
```

### On-board execution (After booting the device in petalinux)
#### Run: [executable] [xclbin] [device] [verify] (device is 0, enable verify result or not by setting it to 1 or 0)
```sh
sudo su
cd /run/media/mmcblk0p1
./hostexe vck190_aie_base_graph_hw.xclbin 0 1
```
