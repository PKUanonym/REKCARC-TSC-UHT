from __future__ import division
import numpy as np


class EuclideanLoss(object):
    def __init__(self, name):
        self.name = name

    def forward(self, input, target):
        return 0.5 * np.mean(np.sum(np.square(input - target), axis=1))

    def backward(self, input, target):
        return (input - target) / len(input)


class SoftmaxCrossEntropyLoss(object):
    def __init__(self, name):
        self.name = name

    def forward(self, input, target):
        '''Your codes here'''
        input -= np.max(input)
        exp_input = np.exp(input)
        prob = exp_input / (np.sum(exp_input, axis=1, keepdims=True) + 1e-20)  # for stablity
        return np.mean(np.sum(- target * np.log(prob + 1e-20), axis=1))  # for stablity

    def backward(self, input, target):
        input -= np.max(input)
        exp_input = np.exp(input)
        prob = exp_input / (np.sum(exp_input, axis=1, keepdims=True) + 1e-20)  # for stablity
        return (prob - target) / len(input)
