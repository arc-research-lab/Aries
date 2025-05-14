import numpy as np
from typing import Tuple, Generic, TypeVar, Tuple, Union

# =================== Types ====================
Shape = TypeVar("Shape", bound=Tuple[int, ...])

# Define a generic Tensor type as a wrapper around ndarray
class Tensor(np.ndarray, Generic[Shape]):
    def __new__(cls, shape: Tuple[int, ...], dtype: str):
        # Ensure shape is a tuple, even for 1D
        if isinstance(shape, int):
            shape = (shape,)
        # Create an ndarray of the given shape and dtype
        # Fallback to float32 for unsupported types like bfloat16
        if dtype == "bfloat16":
            dtype = "float32"  # Use float32 for storage, we'll emulate bfloat16 precision
        obj = np.empty(shape, dtype=dtype).view(cls)
        obj.dtype_str = dtype
        obj.shape = shape
        return obj

    def __getitem__(self, key: Union[slice, Tuple[slice, ...]]):
        # Handle slicing, and return a new Tensor (which is just a view of ndarray)
        result = super().__getitem__(key)
        # We return a new Tensor object, but it's essentially just a view of the ndarray
        return result.view(Tensor)

    def __repr__(self):
        return f"Tensor<{self.dtype_str}[shape={self.shape}]>"

    def get_shape(self) -> Tuple[int, ...]:
        return self.shape

    def get_dtype(self) -> str:
        return self.dtype_str

class TensorAnnotation:
    def __init__(self, dtype: str, shape: Tuple[int, ...]):
        self.dtype_str = dtype
        self.shape = shape

    def __repr__(self):
        return f"{self.dtype_str}[{', '.join(map(str, self.shape))}]"

    def get_shape(self):
        return self.shape

    def get_dtype(self):
        return self.dtype_str

# Dynamic Tensor Factory
class TensorType:
    dtype: str = ""
    @classmethod
    def __class_getitem__(cls, shape) -> "Tensor":
        # Normalize shape
        if isinstance(shape, int):
            shape = (shape,)
        elif not isinstance(shape, tuple):
            raise TypeError(f"Expected int or tuple of ints, got {type(shape)}")

        # Construct tensor or annotation
        if any(dim == -1 for dim in shape):
            return TensorAnnotation(cls.dtype, shape)
        return Tensor(shape, cls.dtype)

class NumericTensor(int, TensorType):
    def __new__(cls, value=0):
        return super().__new__(cls, value)

class FloatingTensor(float, TensorType):
    def __new__(cls, value=0.0):
        return super().__new__(cls, value)

class int8(NumericTensor): dtype = "int8"
class int16(NumericTensor): dtype = "int16"
class int32(NumericTensor): dtype = "int32"
class float32(FloatingTensor): dtype = "float32"
# Emulated bfloat16 (using float32 but reducing precision to match bfloat16)
class bfloat16(FloatingTensor): 
    dtype = "bfloat16"
    def __new__(cls, value=0.0):
        # Use float32 to store the value, then reduce precision to emulate bfloat16
        value = np.float32(value)  # Convert to float32
        # Emulate bfloat16 precision by truncating after 7 significant digits
        return super().__new__(cls, np.round(value, decimals=7))
    def get_bfloat16_value(self):
        # Convert value back to simulate bfloat16
        return np.float32(self).item()