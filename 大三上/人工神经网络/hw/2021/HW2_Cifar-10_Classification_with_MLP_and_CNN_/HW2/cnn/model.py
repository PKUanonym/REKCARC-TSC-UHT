# -*- coding: utf-8 -*-

import torch
from torch import nn
from torch.nn import init
from torch.nn.parameter import Parameter
class BatchNorm2d(nn.Module):
	def __init__(self, num_features, momentum=1e-2, eps=1e-5):
		super(BatchNorm2d, self).__init__()
		
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
		# input: [batch_size, num_feature_map, height, width]
		if self.training is False:
			BN = (input - self.running_mean)/torch.sqrt(self.running_var + self.eps)
			return self.weight * BN + self.bias
		input_mean = input.mean([0, 2, 3])
		input_var = input.var([0, 2, 3],unbiased=False)
		self.running_mean = (1-self.momentum)*input_mean + \
                    self.momentum * self.running_mean
		self.running_var = (1-self.momentum)*input_var + \
                    self.momentum * self.running_var
		BN = (input - input_mean[None, :, None, None])/torch.sqrt(input_var[None, :, None, None] + self.eps)
		res = self.weight * BN + self.bias
		return res

class Dropout(nn.Module):
	def __init__(self, p=0.5):
		super(Dropout, self).__init__()
		self.p = p

	def forward(self, input):
		# input: [batch_size, num_feature_map, height, width]
		if self.training is False:
			return input
		return input * torch.bernoulli((1-self.p)*torch.ones_like(input,device=input.device))

class Model(nn.Module):
	def __init__(self, drop_rate=0.5):
		super(Model, self).__init__()
		# TODO START
		self.conv1 = nn.Conv2d(3, 8, 3, padding = 1)
		self.bn1 = nn.BatchNorm2d(8)
		self.relu1 = nn.ReLU()
		self.dropout1 = Dropout(drop_rate)
		self.maxpool1 = nn.MaxPool2d(2, 2)
		self.conv2 = nn.Conv2d(8, 16, 3, padding = 1)
		self.bn2 = nn.BatchNorm2d(16)
		self.relu2 = nn.ReLU()
		self.dropout2 = Dropout(drop_rate)
		self.maxpool2 = nn.MaxPool2d(2, 2)
		self.linear = nn.Linear(1024, 10)
		# TODO END
		self.loss = nn.CrossEntropyLoss()

	def forward(self, x, y=None):	
		# TODO START
		# the 10-class prediction output is named as "logits"
		cal = self.maxpool1(self.dropout1(self.relu1(self.bn1(self.conv1(x)))))
		cal = self.maxpool2(self.dropout2(self.relu2(self.bn2(self.conv2(cal)))))
		cal = cal.view(cal.size(0), -1)
		logits = self.linear(cal)
		# TODO END

		pred = torch.argmax(logits, 1)  # Calculate the prediction result
		if y is None:
			return pred
		loss = self.loss(logits, y)
		correct_pred = (pred.int() == y.int())
		acc = torch.mean(correct_pred.float())  # Calculate the accuracy in this mini-batch

		return loss, acc
