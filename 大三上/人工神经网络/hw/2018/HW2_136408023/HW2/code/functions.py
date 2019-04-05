import numpy as np
from scipy.signal import convolve


def conv2d_forward(input, W, b, kernel_size, pad):
    '''
    Args:
        input: shape = n (#sample) x c_in (#input channel) x h_in (#height) x w_in (#width)
        W: weight, shape = c_out (#output channel) x c_in (#input channel) x k (#kernel_size) x k (#kernel_size)
        b: bias, shape = c_out
        kernel_size: size of the convolving kernel (or filter)
        pad: number of zero added to both sides of input

    Returns:
        output: shape = n (#sample) x c_out (#output channel) x h_out x w_out,
            where h_out, w_out is the height and width of output, after convolution
    '''
    n, c_in, h_in, w_in = input.shape
    h_pad, w_pad = h_in + 2 * pad, w_in+2*pad
    padded_input = np.zeros((n, c_in, h_pad, w_pad))
    padded_input[:, :, pad:h_in + pad, pad:w_in + pad] = input
    h_out, w_out = h_pad - kernel_size + 1, w_pad - kernel_size + 1
    c_out = W.shape[0]

    output = np.zeros((n, c_out, h_out, w_out))

    for i in range(c_out):
        for j in range(c_in):
            ker = np.rot90(W[i, j], 2)[np.newaxis, :, :]
            output[:, i] += convolve(padded_input[:, j], ker, 'valid')

    output += b[np.newaxis, :, np.newaxis, np.newaxis]

    return output


def conv2d_backward(input, grad_output, W, b, kernel_size, pad):
    '''
    Args:
        input: shape = n (#sample) x c_in (#input channel) x h_in (#height) x w_in (#width)
        grad_output: shape = n (#sample) x c_out (#output channel) x h_out x w_out
        W: weight, shape = c_out (#output channel) x c_in (#input channel) x k (#kernel_size) x k (#kernel_size)
        b: bias, shape = c_out
        kernel_size: size of the convolving kernel (or filter)
        pad: number of zero added to both sides of input

    Returns:
        grad_input: gradient of input, shape = n (#sample) x c_in (#input channel) x h_in (#height) x w_in (#width)
        grad_W: gradient of W, shape = c_out (#output channel) x c_in (#input channel) x k (#kernel_size) x k (#kernel_size)
        grad_b: gradient of b, shape = c_out
    '''
    n, c_in, h_in, w_in = input.shape
    _, _, h_out, w_out = grad_output.shape
    assert h_out == h_in + 2 * pad - kernel_size + 1 and w_out == w_in + 2 * pad - kernel_size + 1, \
    "grad_output shape not consistent with output"

    h_pad, w_pad = h_in + 2 * pad, w_in + 2 * pad
    c_out = W.shape[0]

    # grad_input
    padded_grad_input = np.zeros((n, c_in, h_pad, w_pad))
    for i in range(c_in):
        for j in range(c_out):
            padded_grad_input[:, i] += convolve(grad_output[:, j], W[j, i][np.newaxis, :, :], 'full')
    grad_input = padded_grad_input[:, :, pad:h_in + pad, pad:w_in + pad]

    # grad_W
    padded_input = np.zeros((n, c_in, h_pad, w_pad))
    padded_input[:, :, pad:h_in + pad, pad:w_in + pad] = input

    grad_W = np.zeros((c_out, c_in, kernel_size, kernel_size))
    for i in range(c_in):
        for j in range(c_out):
            delta = np.flip(np.rot90(grad_output[:, j], 2, (1, 2)), 0)
            grad_W[j, i] += convolve(padded_input[:, i], delta, 'valid').squeeze()
    # grad_b
    grad_b = np.sum(grad_output, (0, 2, 3))
    return grad_input, grad_W, grad_b


def avgpool2d_forward(input, kernel_size, pad):
    '''
    Args:
        input: shape = n (#sample) x c_in (#input channel) x h_in (#height) x w_in (#width)
        kernel_size: size of the window to take average over
        pad: number of zero added to both sides of input

    Returns:
        output: shape = n (#sample) x c_in (#input channel) x h_out x w_out,
            where h_out, w_out is the height and width of output, after average pooling over input
    '''
    n, c_in, h_in, w_in = input.shape
    h_pad, w_pad = h_in + 2 * pad, w_in + 2 * pad
    padded_input = np.zeros((n, c_in, h_pad, w_pad))
    padded_input[:, :, pad:h_in + pad, pad:w_in + pad] = input

    h_out, w_out = int(h_pad / kernel_size), int(w_pad / kernel_size)

    output_1 = np.zeros((n, c_in, h_out, w_pad))
    for i in range(kernel_size):
        output_1 += padded_input[:, :, i:h_pad:kernel_size, :]

    output_2 = np.zeros((n, c_in, h_out, w_out))
    for i in range(kernel_size):
        output_2 += output_1[:, :, :, i:w_pad:kernel_size]

    output = output_2 / (kernel_size * kernel_size)

    return output


def avgpool2d_backward(input, grad_output, kernel_size, pad):
    '''
    Args:
        input: shape = n (#sample) x c_in (#input channel) x h_in (#height) x w_in (#width)
        grad_output: shape = n (#sample) x c_in (#input channel) x h_out x w_out
        kernel_size: size of the window to take average over
        pad: number of zero added to both sides of input

    Returns:
        grad_input: gradient of input, shape = n (#sample) x c_in (#input channel) x h_in (#height) x w_in (#width)
    '''
    n, c_in, h_in, w_in = input.shape
    _, _, h_out, w_out = grad_output.shape
    assert h_out == (h_in + 2 * pad) / kernel_size and w_out == (w_in + 2 * pad) / kernel_size, \
    "grad_output shape not consistent with output"
    h_pad, w_pad = h_in + 2 * pad, w_in + 2 * pad

    padded_grad_input_1 = np.zeros((n, c_in, h_pad, w_out))
    for i in range(kernel_size):
        padded_grad_input_1[:, :, i:h_pad:kernel_size, :] = grad_output

    padded_grad_input_2 = np.zeros((n, c_in, h_pad, w_pad))
    for i in range(kernel_size):
        padded_grad_input_2[:, :, :, i:w_pad:kernel_size] = padded_grad_input_1

    grad_input = padded_grad_input_2[:, :, pad:h_in + pad, pad:w_in + pad] / (kernel_size * kernel_size)

    return grad_input
