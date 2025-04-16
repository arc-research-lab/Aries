import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../../../"
sys.path.append(aries_path)
from frontend import *

# TTMc: D[i0, j0, k0] += A[i0, l0, m0] * B[l0, j0] * C[m0, k0]
I, J, K, L, M = 2, 64, 64, 32, 128
TI, TJ, TK, TL, TM = 2, 16, 16, 8, 32
grid = (I//TI, J//TJ, K//TK, L//TL, M//TM) # grid must be a tuple

@task_kernel(external_path="aie1/adf/kernel_ttmc/aie_int32", para = [TI, TJ, TK, TL, TM])
def kernel_ttmc(TileA: int32[TI, TL, TM],
                TileB: int32[TL, TJ],
                TileC: int32[TM, TK],
                TileD: int32[TI, TJ, TK]):
    for i0 in range(0, TI):
        for j0 in range(0, TJ):
            for k0 in range(0, TK):
                TileD[i0, j0, k0] = int32(0)
                for l0 in range(0, TL):
                    for m0 in range(0, TM):
                        TileD[i0, j0, k0] += TileA[i0, l0, m0] * TileB[l0, j0] * TileC[m0, k0]

@task_tile()
def ttmc(A: int32[I, L, M], B: int32[L, J], 
         C: int32[M, K],    D: int32[I, J, K], **kwargs):
    i, j, k, l, m = aries.tile_ranks(**kwargs)

    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    tj = aries.arange(j*TJ, (j+1)*TJ)  # J tile range
    tk = aries.arange(k*TK, (k+1)*TK)  # K tile range
    tl = aries.arange(l*TL, (l+1)*TL)  # L tile range
    tm = aries.arange(m*TM, (m+1)*TM)  # M tile range
    
    L1_A = aries.buffer((TI, TL, TM), "int32")
    L1_B = aries.buffer((TL, TJ), "int32")
    L1_C = aries.buffer((TM, TK), "int32")
    L1_D = aries.accbuffer((TI, TJ, TK), "int32")
    
    L1_A = aries.load(A, (ti, tl, tm))
    L1_B = aries.load(B, (tl, tj))
    L1_C = aries.load(C, (tm, tk))
    kernel_ttmc(L1_A, L1_B, L1_C, L1_D)
    aries.accstore(L1_D, D, (ti, tj, tk))

@task_top()
def top(A: int32[I, L, M], B: int32[L, J], 
        C: int32[M, K],    D: int32[I, J, K]):
    ttmc_task = ttmc[grid](A, B, C, D)
    return ttmc_task

def ttmc_sw(A: int32[I, L, M], B: int32[L, J], C: int32[M, K]):
    D = np.zeros((I, J, K)).astype(np.int32)
    for i0 in range(0, I):
        for j0 in range(0, J):
            for k0 in range(0, K):
                for l0 in range(0, L):
                    for m0 in range(0, M):
                        D[i0, j0, k0] += A[i0, l0, m0] * B[l0, j0] * C[m0, k0]
    return D
 
# Set the project dir and template dir
prj_dir= cur_dir + '/my_project'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]
    
# Initialize the buffers
np.random.seed(0)
A = np.random.randint(-5, 6, size=(I, L, M), dtype=np.int32)
B = np.random.randint(-5, 6, size=(L, J), dtype=np.int32)
C = np.random.randint(-5, 6, size=(M, K), dtype=np.int32)
D = np.zeros((I, J, K)).astype(np.int32)

# Execute ARIES on CPU
ttmc_task = top(A, B, C, D)

# Golden file generation
E = ttmc_sw(A, B, C)

# Compare the program with golden file
print(np.allclose(D, E))

# # Applying schedulings
sch = Schedule(ttmc_task)
sch.parallel(ttmc_task, [1, 2, 2, 1, 2]) # AIE Array Parallelism
sch.l2buffer(ttmc_task, [1, 2, 2, 2, 1]) # L2 buffer data reuse
sch.bufsel(ttmc_task, [0, 1, 0, 1]) # Select the type of buffer of A, B, C, 1:BRAM; 0:URAM
sch.to("VCK190")

# Generate files for on-board test
aries.gen_sim([A, B, C, E])

sch.build(module, prj_dir, temp_dir)