import itertools
from typing import Any, Callable, Tuple

# ================== Decorators ===================
class TaskInstance:
    def __init__(self, func, grid_dims, tile_sizes, instanceIdx, top_flag, call_args, call_kwargs):
        self.func = func
        self.grid_dims = grid_dims
        self.tile_sizes = tile_sizes
        self.instanceIdx = instanceIdx
        self.top_flag = top_flag
        self.call_args = call_args
        self.call_kwargs = call_kwargs

class TaskTileWrapper:
    def __init__(self, func: Callable, run=True):
        self.func = func
        self.grid_dims = None
        self.tile_sizes = None
        self.instanceIdx = 0
        self.run = run

    def __getitem__(self, args: Tuple[Any, ...]):
        assert len(args) >=2
        self.grid_dims = args[0]  # Grid dimensions (e.g., (4, 4) for 2D tiling)
        self.tile_sizes = args[1]  # Tile sizes (e.g., (32, 32))
        if len(args) == 3:
            self.instanceIdx = args[2] # Mark the number of instance
        return self

    def __call__(self, *call_args, **call_kwargs):
        if not self.grid_dims or not self.tile_sizes:
            raise ValueError(
                "Grid dimensions and tile sizes must be specified")
        
        if isinstance(self.grid_dims, int):
            self.grid_dims = (self.grid_dims,)
        
        # Generate all tile index combinations (e.g., (i, j) for a 2D grid)
        call_kwargs['TSizes'] = self.tile_sizes  # Add tuple of sizes
        if self.run:
            for idx in itertools.product(*(range(g) for g in self.grid_dims)):
                call_kwargs['IVs'] = idx  # Add tuple of indices
                self.func(*call_args, **call_kwargs)
        instance = TaskInstance(self.func, self.grid_dims, self.tile_sizes, 
                                self.instanceIdx, False, call_args, call_kwargs)
        return instance

def task_tile(run_flag=True):  
    """Decorator to wrap the function for tiles."""
    def decorator(func: Callable):
        return TaskTileWrapper(func, run_flag)
    return decorator

class TaskKernelWrapper:
    def __init__(self, func: Callable, external_kernel = None, para = []):
        self.func = func
        self.externKrnl = external_kernel
        self.para = para
    def __call__(self, *call_args, **call_kwargs):
        self.func(*call_args, **call_kwargs)

def task_kernel(*, external_path=None, para = []):  
    """Decorator to wrap the function for single AIE."""
    def decorator(func: Callable):
        return TaskKernelWrapper(func, external_path, para)
    return decorator

class TaskTopWrapper:
    def __init__(self, func: Callable):
        self.func = func
    def __call__(self, *call_args, **call_kwargs):
        return self.func(*call_args, **call_kwargs)

def task_top():  
    """Decorator to wrap the function for top function."""
    def decorator(func: Callable):
        return TaskTopWrapper(func)
    return decorator
  
# ======= Reduction range ========
class ReductionRange:
    def __init__(self, start, stop, step=1):
        if stop is None:
            start, stop = 0, start
        self.range = range(start, stop, step)
        
    def __iter__(self):
        return iter(self.range)

# Helper function to create a ReductionRange
def reduction_range(start, stop, step=1):
    return ReductionRange(start, stop, step)