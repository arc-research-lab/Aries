import numpy as np

def softmax(x, y):
    exp_x = np.exp(x - np.max(x, axis=-1, keepdims=True))
    np.divide(exp_x, np.sum(exp_x, axis=-1, keepdims=True), out=y)

def softmax_sw(x):
    exp_x = np.exp(x - np.max(x, axis=-1, keepdims=True))
    return exp_x / np.sum(exp_x, axis=-1, keepdims=True)