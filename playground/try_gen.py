import os
import sys
cur_dir = os.path.dirname(os.path.abspath(__file__))
aries_path = cur_dir + "/../"
sys.path.append(aries_path)
from frontend import *

# Vector Add: C[i0] += A[i0] * B[i0]
I = 256
TI = 32
grid = (I // TI, ) # grid must be a tuple

@task_kernel()
def kernel_relu(TileA: float32[TI], TileC: float32[TI]):
    for i0 in range(0, TI):
        if TileA[i0] > float32(0):
          TileC[i0] = TileA[i0]
        else:
          TileC[i0] = float32(0)

@task_tile()
def relu(A: float32[I], C: float32[I], **kwargs):
    i = aries.tile_ranks(**kwargs)
    
    L1_A = aries.buffer((TI, ), "float32")
    L1_C = aries.buffer((TI, ), "float32")
    
    # Compute tile slices for multiple dimensions
    ti = aries.arange(i*TI, (i+1)*TI)  # I tile range
    
    # Move data between L3 and L1
    L1_A = aries.load(A, (ti, ))
    kernel_relu(L1_A, L1_C)
    aries.store(L1_C, C, (ti, ))

@task_top()
def top(A: float32[I], C: float32[I]):
    relu_task = relu[grid](A, C)
    return relu_task
 
# Initialize the buffers
np.random.seed(0)
A = np.random.rand(I).astype(np.float32)-0.5
C = np.zeros((I)).astype(np.float32)

# Execute on CPU
relu_task = top(A, C)
golden_C = np.maximum(0, A)
print("ARIES vadd output matches golden reference:", np.allclose(C, golden_C))

# Apply schedulings
sch = Schedule(relu_task)
sch.to("VCK190")

# Set the project dir and template dir
prj_dir= cur_dir + '/my_project'
temp_dir= aries_path + '/templates'
module = sys.modules[__name__]

print("ARIES Initial IR:\n")
sch.print_mlir(module)