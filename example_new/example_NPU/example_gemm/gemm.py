import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../../"
sys.path.append(aries_path)
from frontend import *

# GEMM: C[i0, j0] += A[i0, k0] * B[k0, j0]
I, J, K = 1024, 1024, 1024
TI, TJ, TK = 64, 64, 64
ii, ij, ik = 4, 4, 4
bi, bj, bk = TI//ii, TJ//ij, TK//ik

@task_kernel(external_path="aie2/origin/kernel_mm/aie_int16", para = [TI, TJ, TK])
def kernel_gemm(TileA: int16[TI, TK],
                TileB: int16[TK, TJ], 
                TileC: int16[TI, TJ]):
    local_A = aries.detranspose(TileA, [ii,ik], [[1,ik,bk],[0,ii,bi]])
    local_B = aries.detranspose(TileB, [ik,ij], [[1,ij,bj],[0,ik,bk]])
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            for k0 in range(0, TK):
                TileC[i0, j0] += local_A[i0, k0] * local_B[k0, j0]
    tepmC = aries.transpose(TileC, [ii,ij], [[1,ij,bj],[0,ii,bi]])
    np.copyto(TileC, tepmC)

@task_tile(False)
def gemm(A: int16[I, K], B: int16[K, J], C: int16[I, J], **kwargs):
    i, j, k = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    
    L1_A = aries.buffer((TI, TK), "int16")
    L1_B = aries.buffer((TK, TJ), "int16")
    L1_C = aries.buffer((TI, TJ), "int16")
    
    L1_A = aries.load(A, (ti, tk),  [ii,ik], [[1,ik,bk],[0,ii,bi]])
    L1_B = aries.load(B, (tk, tj),  [ik,ij], [[1,ij,bj],[0,ik,bk]])
    L1_C = aries.load(C, (ti, tj),  [ii,ij], [[1,ij,bj],[0,ii,bi]])
    kernel_gemm(L1_A, L1_B, L1_C)
    aries.store(L1_C, C, (ti, tj),  [ii,ij], [[1,ij,bj],[0,ii,bi]])

@task_top()
def top(A: int16[I, K], B: int16[K, J], C: int16[I, J]):
    grid = (I // TI, J // TJ, K // TK)  # 2D grid
    tile_size = (TI, TJ, TK)  # 2D tile size
    gemm_task = gemm[grid, tile_size](A, B, C)
    return gemm_task, C
 
# Set the project dir and template dir
prj_dir= cur_dir + '/my_project'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# Test with 2D array
np.random.seed(0)
A = np.random.randint(-3,3,(I, K)).astype(np.int16)
B = np.random.randint(-3,3,(K, J)).astype(np.int16)
C = np.zeros((I, J)).astype(np.int16)
gemm_task, C = top(A, B, C)
D = np.matmul(A, B)
aries.gen_sim([A, B, D])
sch = Schedule(gemm_task)
sch.parallel(gemm_task, [1, 1, 1])
sch.l2buffer(gemm_task, [1, 1, 1])
sch.bufsel(gemm_task, [1, 1, 0])
sch.redLoop(gemm_task, [2])
sch.to("NPU")
sch.build(module, prj_dir, temp_dir)