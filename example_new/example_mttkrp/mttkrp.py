import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../"
sys.path.append(aries_path)
from newfrontend import *

# MTTKRP: D[i0, j0] += A[i0, k0, l0] * B[k0, j0] * C[l0, j0]
I, J, K, L = 64, 6144, 768, 2048
TI, TJ, TK, TL = 2, 32, 16, 32

@task_kernel(external_path="kernel_mttkrp/aie_fp32", para = [TI, TJ, TK, TL])
def kernel_mttkrp(TileA: float32[TI, TK, TL],
                  TileB: float32[TK, TJ],
                  TileC: float32[TL, TJ],
                  TileD: float32[TI, TJ]):
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            for k0 in range(0, TK):
                  for l0 in range(0, TL):
                      TileD[i0, j0] += TileA[i0, k0, l0] * TileB[k0, j0] * TileC[l0, j0]

@task_tile(False) # Not run it on CPU
def mttkrp(A: float32[I, K, L], B: float32[K, J], 
           C: float32[L, J],    D: float32[I, J], **kwargs):
    i, j, k, l = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    tl = aries.arange(l*TL, (l+1)*TL)  # L tile range
    
    L1_A = aries.buffer((TI, TK, TL), "float32")
    L1_B = aries.buffer((TK, TJ), "float32")
    L1_C = aries.buffer((TL, TJ), "float32")
    L1_D = aries.buffer((TI, TJ), "float32")
    
    L1_A = aries.load(A, (ti, tk, tl))
    L1_B = aries.load(B, (tk, tj))
    L1_C = aries.load(C, (tl, tj))
    L1_D = aries.load(D, (ti, tj))
    kernel_mttkrp(L1_A, L1_B, L1_C, L1_D)
    aries.store(L1_D, D, (ti, tj))

@task_top()
def top(A: float32[I, K, L], B: float32[K, J], 
        C: float32[L, J],    D: float32[I, J]):
    grid, size = (I//TI, J//TJ, K//TK, L//TL), (TI, TJ, TK, TL)
    mttkrp_task = mttkrp[grid, size](A, B, C, D)
    return mttkrp_task
 
# Set the project dir and template dir
prj_dir= cur_dir + '/my_project'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# Test with 2D array
A = np.random.rand(I, K, L).astype(np.float32)
B = np.random.rand(K, J).astype(np.float32)
C = np.random.rand(L, J).astype(np.float32)
D = np.zeros(I, J).astype(np.float32)
mttkrp_task = top(A, B, C, D)
sch = Schedule(mttkrp_task)
sch.parallel(mttkrp_task, [8, 12, 1, 2])
sch.l2buffer(mttkrp_task, [2, 8, 6, 4])
sch.bufsel(mttkrp_task, [0, 1, 0, 1])
sch.redLoop(mttkrp_task, [2, 3])
sch.to("VCK190")
sch.build(module, prj_dir, temp_dir)