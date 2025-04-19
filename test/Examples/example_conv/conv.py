import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../../"
sys.path.append(aries_path)
from frontend import *

# CONV: C[oh, ow, oc] += A[oh+kh, ow+kw, ic] * B[kh, kw, ic, oc]
# OC, OH, OW, IC, KH, KW, = 128, 32, 32, 128, 3, 3
OC, OH, OW, IC, KH, KW, = 64, 16, 16, 64, 3, 3
IH, IW = OH+KH-1, OW+KW-1

TOC, TOH, TOW, TIC, TKH, TKW, = 16, 4, 8, 16, 3, 3
TIH, TIW = TOH+TKH-1, TOW+TKW-1

@task_kernel()
def kernel_conv(TileA: float32[TIH, TIW, TIC], 
                TileB: float32[TKH, TKW, TIC, TOC], 
                TileC: float32[TOH, TOW, TOC]):
    for oc in range(0, TOC):
      for oh in range(0, TOH):
        for ow in range(0, TOW):
          TileC[oh, ow, oc] = float32(0)
          for ic in range(0, TIC):
            for kh in range(0, TKH):
              for kw in range(0, TKW):
                TileC[oh, ow, oc] += TileA[oh+kh, ow+kw, ic] * TileB[kh, kw, ic, oc]

@task_tile()
def conv(A: float32[IH, IW, IC], B: float32[KH, KW, IC, OC], C: float32[OH, OW, OC], **kwargs):
    oc, oh, ow, ic, kh, kw = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    tih = aries.arange(oh*TOH, oh*TOH+TIH)
    tiw = aries.arange(ow*TOW, ow*TOW+TIW)
    tkh = aries.arange(kh*TKW, (kh+1)*TKW)
    tkw = aries.arange(kw*TKH, (kw+1)*TKH)
    toh = aries.arange(oh*TOH, (oh+1)*TOH)
    tow = aries.arange(ow*TOW, (ow+1)*TOW)
    tic = aries.arange(ic*TIC, (ic+1)*TIC)
    toc = aries.arange(oc*TOC, (oc+1)*TOC)
    
    L1_A = aries.buffer((TIH, TIW, TIC), "float32")
    L1_B = aries.buffer((TKH, TKW, TIC, TOC), "float32")
    L1_C = aries.accbuffer((TOH, TOW, TOC), "float32")
    
    L1_A = aries.load(A, (tih, tiw, tic))
    L1_B = aries.load(B, (tkh, tkw, tic, toc))
    kernel_conv(L1_A, L1_B, L1_C)
    aries.accstore(L1_C, C, (toh, tow, toc))

@task_top()
def top(A: float32[IH, IW, IC], B: float32[KH, KW, IC, OC], C: float32[OH, OW, OC]):
    grid = (OC // TOC, OH // TOH, OW // TOW, IC // TIC, KH // TKH, KW // TKW)  # 2D grid
    conv_task = conv[grid](A, B, C)
    return conv_task
  
module = sys.modules[__name__]
  
def conv_sw(A, B):
    C = np.zeros((OH, OW, OC)).astype(np.float32)
    for oc in range(0, OC):
      for oh in range(0, OH):
        for ow in range(0, OW):
          for ic in range(0, IC):
            for kh in range(0, KH):
              for kw in range(0, KW):
                C[oh, ow, oc] += A[oh+kh, ow+kw, ic] * B[kh, kw, ic, oc]
    return C

# Initialize the buffers
np.random.seed(0)
A = np.random.rand(IH, IW, IC).astype(np.float32)
B = np.random.rand(KH, KW, IC, OC).astype(np.float32)
C = np.zeros((OH, OW, OC)).astype(np.float32)

# Execute on CPU
conv_task = top(A, B, C)
C_Golden = conv_sw(A, B)

# Compare the program with golden file
print(np.allclose(C, C_Golden))

# Generate files for on-board test
aries.gen_sim([A, B, C_Golden])

# Specify primitives to optimize hardware design
sch = Schedule(conv_task)

############# Primitives #############
sch.parallel(conv_task, [1, 1, 1, 1, 1, 1]) # AIE Array Parallelism
sch.l2buffer(conv_task, [2, 2, 2, 2, 1, 1]) # L2 buffer data reuse
sch.bufsel(conv_task, [1, 1, 0]) # Select the type of buffer of A, B, C, 1:BRAM; 0:URAM
# If there is reduction loop in the single AIE, then need to specify
sch.aieUnroll(factor=3, option=1) # Specify unroll-full-threshold=3
######################################

sch.to("VCK190")

# Set the project dir and template dir
prj_dir= cur_dir + '/project_conv'
temp_dir= aries_path + '/templates'
# Generate Initial MLIR and ARIES Opts
sch.build(module, prj_dir, temp_dir)