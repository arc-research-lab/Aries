import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../"
sys.path.append(aries_path)
from newfrontend import *

# TTMc: D[i0, j0, k0] += A[i0, l0, m0] * B[l0, j0] * C[m0, k0]
I, J, K, L, M = 4, 512, 768, 1024, 4096
TI, TJ, TK, TL, TM = 2, 16, 16, 16, 32

@task_kernel(external_path="kernel_ttmc/aie_fp32", para = [TI, TJ, TK, TL, TM])
def kernel_ttmc(TileA: float32[TI, TL, TM],
                TileB: float32[TL, TJ],
                TileC: float32[TM, TK],
                TileD: float32[TI, TJ, TK]):
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            for k0 in range(0, TK):
                  for l0 in range(0, TL):
                      for m0 in range(0, TM):
                        TileD[i0, j0, k0] += TileA[i0, l0, m0] * TileB[l0, j0] * TileC[m0, k0]

@task_tile(False) # Not run it on CPU
def ttmc(A: float32[I, L, M], B: float32[L, J], 
         C: float32[M, K],    D: float32[I, J, K], **kwargs):
    i, j, k, l, m = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    tl = aries.arange(l*TL, (l+1)*TL)  # L tile range
    tm = aries.arange(m*TM, (m+1)*TM)  # M tile range
    
    L1_A = aries.buffer((TI, TL, TM), "float32")
    L1_B = aries.buffer((TL, TJ), "float32")
    L1_C = aries.buffer((TM, TK), "float32")
    L1_D = aries.buffer((TI, TJ, TK), "float32")
    
    L1_A = aries.load(A, (ti, tl, tm))
    L1_B = aries.load(B, (tl, tj))
    L1_C = aries.load(C, (tm, tk))
    L1_D = aries.load(D, (ti, tj, tk))
    kernel_ttmc(L1_A, L1_B, L1_C, L1_D)
    aries.store(L1_D, D, (ti, tj, tk))

@task_top()
def top(A: float32[4, 1024, 4096], B: float32[1024, 512], 
        C: float32[4096, 768],     D: float32[4, 512, 768]):
    grid, size = (I//TI, J//TJ, K//TK, L//TL, M//TM), (TI, TJ, TK, TL, TM)
    ttmc_task = ttmc[grid, size](A, B, C, D)
    return ttmc_task
 
# Set the project dir and template dir
prj_dir= cur_dir + '/my_project'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# Test with 2D array
A = np.random.rand(I, L, M).astype(np.float32)
B = np.random.rand(L, J).astype(np.float32)
C = np.random.rand(M, K).astype(np.float32)
D = np.zeros(I, J, K).astype(np.float32)
ttmc_task = top(A, B, C, D)
sch = Schedule(ttmc_task)
sch.parallel(ttmc_task, [1, 8, 12, 1, 2])
sch.l2buffer(ttmc_task, [1, 2, 2, 8, 8])
sch.bufsel(ttmc_task, [0, 1, 0, 1])
sch.redLoop(ttmc_task, [3, 4])
sch.to("VCK190")
sch.build(module, prj_dir, temp_dir)