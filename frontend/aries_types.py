import numpy as np
from typing import Tuple, Generic, TypeVar, Tuple, Union

# =================== Types ====================
Shape = TypeVar("Shape", bound=Tuple[int, ...])

class NumericType(int):  # Base class for int-like types
    def __new__(cls, value: int):
        return super().__new__(cls, value)

class FloatingType(float):  # Base class for float-like types
    def __new__(cls, value: float):
        return super().__new__(cls, value)

# Define a generic Tensor type as a wrapper around ndarray
class Tensor(np.ndarray, Generic[Shape]):
    def __new__(cls, shape: Tuple[int, ...], dtype: str):
        # Ensure shape is a tuple, even for 1D
        if isinstance(shape, int):
            shape = (shape,)
        # Create an ndarray of the given shape and dtype
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
class int8(NumericType):
    def __class_getitem__(cls, shape: Tuple[int, ...]) -> Tensor:
        if any(dim == -1 for dim in shape):
            return TensorAnnotation("int8", shape)
        return Tensor(shape, "int8")

class int16(NumericType):
    def __class_getitem__(cls, shape: Tuple[int, ...]) -> Tensor:
        if any(dim == -1 for dim in shape):
            return TensorAnnotation("int16", shape)
        return Tensor(shape, "int16")

class int32(NumericType):
    def __class_getitem__(cls, shape: Tuple[int, ...]) -> Tensor:
        if any(dim == -1 for dim in shape):
            return TensorAnnotation("int32", shape)
        return Tensor(shape, "int32")

class float32(FloatingType):
    def __class_getitem__(cls, shape: Tuple[int, ...]) -> Tensor:
        if any(dim == -1 for dim in shape):
            return TensorAnnotation("float32", shape)
        return Tensor(shape, "float32")