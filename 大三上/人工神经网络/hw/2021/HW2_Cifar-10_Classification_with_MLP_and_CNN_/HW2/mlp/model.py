# -*- coding: utf-8 -*-

import torch
from torch import nn
from torch.nn import init
from torch.nn.parameter import Parameter
class BatchNorm1d(nn.Module):
	# TODO START
	def __init__(self, num_features, momentum=1e-2, eps=1e-5):
		super(BatchNorm1d, self).__init__()

		device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

		self.num_features = num_features
		self.momentum = momentum
		self.eps = eps

		# Parameters
		self.weight = torch.ones(num_features,device=device)
		self.bias = torch.zeros(num_features,device=device)
		
		# Store the average mean and variance
		self.register_buffer('running_mean', torch.zeros(num_features,device=device))
		self.register_buffer('running_var', torch.ones(num_features,device=device))
		
		# Initialize your parameter

	def forward(self, input):
		# input: [batch_size, num_feature_map * height * width]
		if self.training is False:
			BN = (input - self.running_mean)/torch.sqrt(self.running_var + self.eps)
			return self.weight * BN + self.bias
		input_mean = input.mean([0])
		input_var = input.var([0],unbiased=False)
		self.running_mean = (1-self.momentum)*input_mean + \
                    self.momentum * self.running_mean
		self.running_var = (1-self.momentum)*input_var + \
                    self.momentum * self.running_var
		BN = (input - input_mean)/torch.sqrt(input_var + self.eps)
		res = self.weight * BN + self.bias
		return res
	# TODO END

class Dropout(nn.Module):
	# TODO START
	def __init__(self, p=0.5):
		super(Dropout, self).__init__()
		self.p = p

	def forward(self, input):
		# input: [batch_size, num_feature_map * height * width]
		if self.training is False:
			return input
		return input * torch.bernoulli((1-self.p)*torch.ones_like(input,device=input.device))
	# TODO END

class Model(nn.Module):
	def __init__(self, drop_rate=0.5):
		super(Model, self).__init__()
		# TODO START
		INPUT_DIM = 32 * 32 * 3
		HIDDEN_DIM = 512
		OUTPUT_DIM = 10
		self.linear1 = nn.Linear(INPUT_DIM, HIDDEN_DIM)
		self.bn = BatchNorm1d(HIDDEN_DIM)
		self.relu = nn.ReLU()
		self.dropout = Dropout(drop_rate)
		self.linear2 = nn.Linear(HIDDEN_DIM, OUTPUT_DIM)
		# TODO END
		self.loss = nn.CrossEntropyLoss()

	def forward(self, x, y=None):
		# TODO START
		# the 10-class prediction output is named as "logits"
		cal = self.linear1(x)
		cal = self.bn(cal)
		cal = self.relu(cal)
		cal = self.dropout(cal)
		logits = self.linear2(cal)
		# TODO END

		pred = torch.argmax(logits, 1)  # Calculate the prediction result
		if y is None:
			return pred
		loss = self.loss(logits, y)
		correct_pred = (pred.int() == y.int())
		acc = torch.mean(correct_pred.float())  # Calculate the accuracy in this mini-batch

		return loss, acc