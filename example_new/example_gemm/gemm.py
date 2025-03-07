import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../"
sys.path.append(aries_path)
from newfrontend import *

# GEMM: C[i0, j0] += A[i0, k0] * B[k0, j0]
I, J, K = 2816, 3072, 8192
TI, TJ, TK = 32, 32, 32

@task_kernel(external_path="kernel_mm/aie_fp32_v0", para = [TI, TJ, TK])
def kernel_gemm(TileA: float32[TI, TK], 
                TileB: float32[TK, TJ], 
                TileC: float32[TI, TJ]):
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            for k0 in range(0, TK):
                TileC[i0, j0] += TileA[i0, k0] * TileB[k0, j0]

@task_tile(False) # Not run it on CPU
def gemm(A: float32[I, K], B: float32[K, J], C: float32[I, J], **kwargs):
    i, j, k = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    
    L1_A = aries.buffer((TI, TK), "float32")
    L1_B = aries.buffer((TK, TJ), "float32")
    L1_C = aries.buffer((TI, TJ), "float32")
    
    L1_A = aries.load(A, (ti, tk))
    L1_B = aries.load(B, (tk, tj))
    L1_C = aries.load(C, (ti, tj))
    kernel_gemm(L1_A, L1_B, L1_C)
    aries.store(L1_C, C, (ti, tj))

@task_top()
def top(A: float32[I, K], B: float32[K, J], C: float32[I, J]):
    grid = (I // TI, J // TJ, K // TK)  # 2D grid
    tile_size = (TI, TJ, TK)  # 2D tile size
    gemm_task = gemm[grid, tile_size](A, B, C)
    return gemm_task
 
# Set the project dir and template dir
prj_dir= cur_dir + '/my_project'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# Test with 2D array
A = np.random.rand(I, K).astype(np.float32)
B = np.random.rand(K, J).astype(np.float32)
C = np.zeros(I, J).astype(np.float32)
gemm_task = top(A, B, C)
sch = Schedule(gemm_task)
sch.parallel(gemm_task, [11, 8, 4])
sch.l2buffer(gemm_task, [4, 6, 1])
sch.bufsel(gemm_task, [1, 1, 0])
sch.redLoop(gemm_task, [2])
sch.to("VCK190")
sch.build(module, prj_dir, temp_dir)