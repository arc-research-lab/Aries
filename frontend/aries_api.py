import itertools
from .aries_types import *

# =================== APIs ====================
class aries:
    @staticmethod
    def arange(start, stop, step=1):
        return slice(start, stop, step)

    @staticmethod
    def reduce_range(start, stop=None, step=1,):
        """Create and return a range iterator with an optional attribute name."""
        if stop is None:
            start, stop = 0, start
        # Create the range iterator
        r = range(start, stop, step)    
        return r
        
    @staticmethod
    def buffer(shape: Tuple[int, ...], dtype: str) -> Tensor:
        if isinstance(shape, int):
            shape = (shape,)
        return Tensor(shape, dtype)
    
    
    # Nothing different than buffer in the frontend, but will provide more info
    # in the backend to hint the compiler reduction might be needed
    @staticmethod
    def accbuffer(shape: Tuple[int, ...], dtype: str) -> Tensor:
        if isinstance(shape, int):
            shape = (shape,)
        return Tensor(shape, dtype)
    
    @staticmethod
    def transpose(array, tile_shape=[], transpose_params=[]):
        return AriesWrapper(array).transpose(tile_shape, transpose_params)

    @staticmethod
    def detranspose(array, tile_shape=[], transpose_params=[]):
        return AriesWrapper(array).detranspose(tile_shape, transpose_params)
    
    @staticmethod
    def load(array, slices, tile_shape=[], transpose_params=[]):
        sliced_array = array[slices]
        if not tile_shape and not transpose_params:
            return AriesWrapper(sliced_array).array  # AriesWrapper should preserve dtype
        elif tile_shape and transpose_params:
            transposed = aries.transpose(sliced_array, tile_shape, transpose_params)
            return transposed.astype(array.dtype)  # Ensure same dtype as input
        else:
            raise ValueError("Invalid input: tile_shape or transpose_params cannot be empty.")
    
    @staticmethod
    def store(data, array, slices, tile_shape=[], transpose_params=[]):
        if not tile_shape and not transpose_params:
            array[slices] = AriesWrapper(data).array
        elif tile_shape and transpose_params:
            transposed_data = aries.detranspose(data, tile_shape, transpose_params)
            array[slices] = transposed_data
        else:
            raise ValueError("Invalid input: tile_shape or transpose_params cannot be empty.")
    
    # Similar to store, but data will be loaded and add to array
    @staticmethod
    def accstore(data, array, slices, tile_shape=[], transpose_params=[]):
        if not tile_shape and not transpose_params:
            array[slices] += AriesWrapper(data).array
        elif tile_shape and transpose_params:
            transposed_data = aries.detranspose(data, tile_shape, transpose_params)
            array[slices] += transposed_data
        else:
            raise ValueError("Invalid input: tile_shape or transpose_params cannot be empty.")
    
    @staticmethod
    def cast(tensor, new_shape):
        """
        Simulates a memref.cast operation for backend lowering.
        Args:
            tensor (array-like): The original tensor (e.g., NumPy array).
            new_shape (list): The new shape, where -1 represents unknown dimensions.

        Returns:
            The same tensor, but marked for backend lowering with the new shape.
        """
        if not isinstance(tensor, (np.ndarray, list)):
            raise TypeError("aries.cast expects a NumPy array or list.")

        original_rank = len(tensor.shape)
        new_rank = len(new_shape)

        if original_rank != new_rank:
            raise ValueError(f"Rank mismatch: Tensor has rank {original_rank}, but new shape is rank {new_rank}.")
        return tensor
    
    @staticmethod
    def tile_ranks(**kwargs):
        ivs = kwargs.get('IVs')
        if len(ivs) == 1:
            return ivs[0]
        else:
            return ivs

    @staticmethod
    def tile_sizes(**kwargs):
        return kwargs.get('TSizes')
      
    @staticmethod
    def gen_sim(arrs):
        for i, arr in enumerate(arrs):
            np_arg = np.array(arr)
            dtype = np_arg.dtype
            if dtype == np.int8 or dtype == np.int16 or dtype == np.int32:
                fmt = '%d'
            elif dtype == np.float32 or dtype == np.float64:
                fmt = '%.6f'
            else:
                fmt = '%s'
            # Flatten or reshape 3D arrays to 2D
            if np_arg.ndim > 2:
                np_arg = np_arg.reshape(-1, np_arg.shape[-1])  # Reshape to 2D
            np.savetxt(f'data{i}.sim', np_arg, fmt=fmt)

class AriesWrapper:
    """A wrapper for NumPy arrays to support method chaining in `aries`."""
    
    def __init__(self, array):
        self.array = array  # Store the NumPy array
    
    def __getitem__(self, index):
        """Allows indexing like a NumPy array."""
        return self.array[index]  # Delegate to NumPy array

    def __setitem__(self, index, value):
        """Allows assignment like a NumPy array."""
        self.array[index] = value  # Delegate to NumPy array
    
    def __array__(self, dtype=None):
        """Allows transparent conversion back to a NumPy array when needed."""
        return np.asarray(self.array, dtype=dtype)

    def __repr__(self):
        """Helper function for printing."""
        return f"AriesWrapper({self.array.shape}, dtype={self.array.dtype})"
    
    def detranspose(self, tile_shape, transpose_params):
        """
        This function defines inverse operation compared with the transpose
        """
        if isinstance(transpose_params, list) and all(not isinstance(i, list) for i in transpose_params):
            transpose_params = [transpose_params]  # Convert 1D list to 2D list by wrapping it
        
        assert len(tile_shape) == len(transpose_params), "Tile shape and transpose parameters must match dimensions."

        # Get original shape
        original_shape = self.array.shape
        num_dims = len(original_shape)

        # Validate that dimensions are within range
        dims, strides, wraps = [], [], []
        
        for dim, stride, wrap in transpose_params:
            assert 0 <= dim < num_dims, f"Invalid dimension {dim} for array with {num_dims} dimensions."
            dims.append(dim)
            strides.append(stride)
            wraps.append(wrap)
        
        # Initialize reshaped array
        reshaped_array = np.zeros_like(self.array)
        array_1d = self.array.flatten()
        tile_size = np.prod(tile_shape)
        
        reversed_wraps = wraps[::-1]
        sorted_strides = [0] * num_dims
        for idx, dim in enumerate(dims):
            sorted_strides[dim] = strides[idx]
        for idx, reversed_idx in enumerate(itertools.product(*(range(s) for s in reversed_wraps))):
            # Convert the flattend tile from 1d to nd with shape = tile_shape
            temp_tile = array_1d[idx*tile_size:(idx+1)*tile_size]
            original_tile = temp_tile.reshape(tile_shape)
            wrap_idx = reversed_idx[::-1]
            sorted_warp_idx = [0] * num_dims
            for idx, dim in enumerate(dims):
                sorted_warp_idx[dim] = wrap_idx[idx]
            pos = np.array(sorted_warp_idx) * np.array(sorted_strides)
            slices = tuple(slice(start, start + size, 1) for start, size in zip(pos, tile_shape))
            reshaped_array[slices] = original_tile
        return reshaped_array
    
    def transpose(self, tile_shape, transpose_params):
        """
        Transposes the array by slicing into small tiles and rearranging them based on given strides and wraps.

        Args:
            tile_shape (list): The shape of each tile (e.g., [4,3] for a 2D case).
            transpose_params (list of lists): Each inner list contains [dim, stride, wrap].
        
        Example:
            For an 8(dim=0) * 9(dim=1) array, row-major, dim=n is consecutive:
            [[ 0.  1.  2.  3.  4.  5.  6.  7.  8.]
             [ 9. 10. 11. 12. 13. 14. 15. 16. 17.]
             [18. 19. 20. 21. 22. 23. 24. 25. 26.]
             [27. 28. 29. 30. 31. 32. 33. 34. 35.]
             [36. 37. 38. 39. 40. 41. 42. 43. 44.]
             [45. 46. 47. 48. 49. 50. 51. 52. 53.]
             [54. 55. 56. 57. 58. 59. 60. 61. 62.]
             [63. 64. 65. 66. 67. 68. 69. 70. 71.]]
            
            new_array = array.transpose([4,3], [[0,4,2],[1,3,3]])
            It means, slicing 4*3 tiles, go through dim=0 first, stride=4, and in dim=0, there are two slices (wrap=2).
            Then the slice goes through dim=1, stride=3, there are 3 slices along this dim (wrap=3).
            Results:
            [[ 0.  1.  2.  9. 10. 11. 18. 19. 20.]
             [27. 28. 29. 36. 37. 38. 45. 46. 47.]
             [54. 55. 56. 63. 64. 65.  3.  4.  5.]
             [12. 13. 14. 21. 22. 23. 30. 31. 32.]
             [39. 40. 41. 48. 49. 50. 57. 58. 59.]
             [66. 67. 68.  6.  7.  8. 15. 16. 17.]
             [24. 25. 26. 33. 34. 35. 42. 43. 44.]
             [51. 52. 53. 60. 61. 62. 69. 70. 71.]]
             
            new_array = array.transpose([4,3], [[1,3,3],[0,4,2]])
            Results:
            [[ 0.  1.  2.  9. 10. 11. 18. 19. 20.]
             [27. 28. 29.  3.  4.  5. 12. 13. 14.]
             [21. 22. 23. 30. 31. 32.  6.  7.  8.]
             [15. 16. 17. 24. 25. 26. 33. 34. 35.]
             [36. 37. 38. 45. 46. 47. 54. 55. 56.]
             [63. 64. 65. 39. 40. 41. 48. 49. 50.]
             [57. 58. 59. 66. 67. 68. 42. 43. 44.]
             [51. 52. 53. 60. 61. 62. 69. 70. 71.]]
        """
        
        if isinstance(transpose_params, list) and all(not isinstance(i, list) for i in transpose_params):
            transpose_params = [transpose_params]  # Convert 1D list to 2D list by wrapping it
        
        assert len(tile_shape) == len(transpose_params), "Tile shape and transpose parameters must match dimensions."

        # Get original shape
        original_shape = self.array.shape
        num_dims = len(original_shape)

        # Validate that dimensions are within range
        dims, strides, wraps = [], [], []
        
        for dim, stride, wrap in transpose_params:
            assert 0 <= dim < num_dims, f"Invalid dimension {dim} for array with {num_dims} dimensions."
            dims.append(dim)
            strides.append(stride)
            wraps.append(wrap)
        
        # dim 0 need to be traversed first, where the order is different when tranversing wraps
        merged_array = np.array([], dtype=self.array.dtype)
        reversed_wraps = wraps[::-1]
        sorted_strides = [0] * num_dims
        for idx, dim in enumerate(dims):
            sorted_strides[dim] = strides[idx]
        for reversed_idx in itertools.product(*(range(s) for s in reversed_wraps)):
            wrap_idx = reversed_idx[::-1]
            sorted_warp_idx = [0] * num_dims
            for idx, dim in enumerate(dims):
                sorted_warp_idx[dim] = wrap_idx[idx]
            # print(f"sorted_warp_idx is : {sorted_warp_idx}")
            pos = np.array(sorted_warp_idx) * np.array(sorted_strides)
            slices = tuple(slice(start, start + size, 1) for start, size in zip(pos, tile_shape))
            
            temp_slice = self.array[slices]
            flatten_slice = temp_slice.reshape(-1)
            merged_array = np.concatenate((merged_array, flatten_slice))
            # print(f"{sorted_warp_idx}: {flatten_slice}")
        reshaped_array = merged_array.reshape(self.array.shape)
        return reshaped_array