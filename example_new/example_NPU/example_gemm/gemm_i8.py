import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../../"
sys.path.append(aries_path)
from frontend import *

# GEMM: C[i0, j0] += A[i0, k0] * B[k0, j0]
I, J, K = 1024, 1024, 1024
TI, TJ, TK = 64, 128, 64
ii, ij, ik = 4, 8, 8
bi, bj, bk = TI//ii, TJ//ij, TK//ik

@task_kernel(external_path="aie2/origin/kernel_mm/aie_int8", para = [TI, TJ, TK])
def kernel_gemm(TileA: int8[TI, TK],
                TileB: int8[TK, TJ], 
                TileC: int8[TI, TJ]):
    local_A = aries.detranspose(TileA, [ii,ik], [[1,ik,bk], [0,ii,bi]])
    local_B = aries.detranspose(TileB, [ik,ij], [[1,ij,bj], [0,ik,bk]])
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            TileC[i0, j0] = int8(0)
            for k0 in range(0, TK):
                TileC[i0, j0] += local_A[i0, k0] * local_B[k0, j0]
    tempC = aries.transpose(TileC, [ii,ij], [[1,ij,bj], [0,ii,bi]])
    np.copyto(TileC, tempC)

@task_tile(False)
def gemm(A: int8[I, K], B: int8[K, J], C: int8[I, J], **kwargs):
    i, j, k = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    
    L1_A = aries.buffer((TI, TK), "int8")
    L1_B = aries.buffer((TK, TJ), "int8")
    L1_C = aries.buffer((TI, TJ), "int8")
    
    L1_A = aries.load(A, (ti, tk),  [ii,ik], [[1,ik,bk], [0,ii,bi]])
    L1_B = aries.load(B, (tk, tj),  [ik,ij], [[1,ij,bj], [0,ik,bk]])
    kernel_gemm(L1_A, L1_B, L1_C)
    aries.accstore(L1_C, C, (ti, tj),  [ii,ij], [[1,ij,bj],[0,ii,bi]])

@task_top()
def top(A: int8[I, K], B: int8[K, J], C: int8[I, J]):
    grid = (I // TI, J // TJ, K // TK)  # 2D grid
    tile_size = (TI, TJ, TK)  # 2D tile size
    gemm_task = gemm[grid, tile_size](A, B, C)
    return gemm_task, C
 
# Set the project dir and template dir
prj_dir= cur_dir + '/my_project_i8'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# Test with 2D array
density = 0.05  # 5% non-zeros
A = np.random.choice([-1, 0, 1], size=(I, K), p=[density/2, 1-density, density/2]).astype(np.int8)
B = np.random.choice([-1, 0, 1], size=(K, J), p=[density/2, 1-density, density/2]).astype(np.int8)
C = np.zeros((I, J), dtype=np.int8)
gemm_task, C = top(A, B, C)
D = np.matmul(A, B)

aries.gen_sim([A, B, D])
sch = Schedule(gemm_task)
sch.parallel(gemm_task, [4, 4, 1])
sch.l2buffer(gemm_task, [1, 1, 1])
sch.to("NPU")
sch.build(module, prj_dir, temp_dir)
sch.compile(aries_path, prj_dir)