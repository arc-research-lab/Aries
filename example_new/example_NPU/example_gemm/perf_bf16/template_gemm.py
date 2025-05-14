import os
import sys
import argparse
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../../../"
sys.path.append(aries_path)
from frontend import *

parser = argparse.ArgumentParser(description="Run GEMM with specified dimensions")
parser.add_argument("--PI", type=int, default=1, help="Parallism for I")
parser.add_argument("--PJ", type=int, default=1, help="Parallism for J")
args = parser.parse_args()

# GEMM: C[i0, j0] += A[i0, k0] * B[k0, j0]
I, K, J = {{I}}, {{K}}, {{J}}
PI, PJ = args.PI, args.PJ
TI, TJ, TK = 64, 64, 64
ii, ij, ik = 4, 4, 8
bi, bj, bk = TI//ii, TJ//ij, TK//ik

@task_kernel(external_path="aie2/origin/kernel_mm/aie_bf16", para = [TI, TJ, TK])
def kernel_gemm(TileA: bfloat16[TI, TK],
                TileB: bfloat16[TK, TJ], 
                TileC: bfloat16[TI, TJ]):
    local_A = aries.detranspose(TileA, [ii,ik], [[1,ik,bk], [0,ii,bi]])
    local_B = aries.detranspose(TileB, [ik,ij], [[1,ij,bj], [0,ik,bk]])
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            TileC[i0, j0] = bfloat16(0)
            for k0 in range(0, TK):
                TileC[i0, j0] += local_A[i0, k0] * local_B[k0, j0]
    tempC = aries.transpose(TileC, [ii,ij], [[1,ij,bj], [0,ii,bi]])
    np.copyto(TileC, tempC)

@task_tile(False)
def gemm(A: bfloat16[I, K], B: bfloat16[K, J], C: bfloat16[I, J], **kwargs):
    i, j, k = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    
    L1_A = aries.buffer((TI, TK), "bfloat16")
    L1_B = aries.buffer((TK, TJ), "bfloat16")
    L1_C = aries.buffer((TI, TJ), "bfloat16")
    
    L1_A = aries.load(A, (ti, tk),  [ii,ik], [[1,ik,bk], [0,ii,bi]])
    L1_B = aries.load(B, (tk, tj),  [ik,ij], [[1,ij,bj], [0,ik,bk]])
    kernel_gemm(L1_A, L1_B, L1_C)
    aries.accstore(L1_C, C, (ti, tj),  [ii,ij], [[1,ij,bj],[0,ii,bi]])

@task_top()
def top(A: bfloat16[I, K], B: bfloat16[K, J], C: bfloat16[I, J]):
    grid = (I // TI, J // TJ, K // TK)  # 2D grid
    tile_size = (TI, TJ, TK)  # 2D tile size
    gemm_task = gemm[grid, tile_size](A, B, C)
    return gemm_task, C

# First function is only for test with large matrix size
def generate_eye_product(I, K, J, dtype):
    D = np.zeros((I, J), dtype=dtype)
    diag_len = min(I, K, J)
    for i in range(diag_len):
        D[i, i] = 1
    return D
 
# Set the project dir and template dir
prj_dir = f"{cur_dir}/gemm_bf16_{I}x{K}x{J}_{PI}x{PJ}"
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# For I >= 2048, it takes long time to be calculated in CPU, current use eye mat
if I >= 2048 or K >= 2048 or J >= 2048:
    # Generate identity matrices
    A = np.eye(I, K, dtype=np.float32)
    B = np.eye(K, J, dtype=np.float32)
    D = generate_eye_product(I, K, J, dtype=np.float32)
else:
    density = 0.1  # 10% non-zeros
    A = np.random.choice([-1.0, 0.0, 1.0], size=(I, K), p=[density/2, 1-density, density/2]).astype(np.float32)
    B = np.random.choice([-1.0, 0.0, 1.0], size=(K, J), p=[density/2, 1-density, density/2]).astype(np.float32)
    # Compute the matrix multiplication directly
    D = np.matmul(A, B)
C = np.zeros((I, J)).astype(np.float32)

# Run the GEMM task
gemm_task, C = top(A, B, C)

aries.gen_sim([A, B, D])
sch = Schedule(gemm_task)
sch.parallel(gemm_task, [PI, PJ, 1])
sch.l2buffer(gemm_task, [1, 1, 1])
sch.to("NPU")
sch.build(module, prj_dir, temp_dir)
sch.compile(aries_path, prj_dir)