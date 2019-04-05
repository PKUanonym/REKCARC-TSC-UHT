from random import *
import numpy as np
from numpy.linalg import cholesky
import matplotlib.pyplot as plt

global threshold

def classify(x):
    return x[0][0]+x[0][1]<=threshold
x=[randint(0,1) for i in range(100)]
mu1=np.array([[1,1]])
mu2=np.array([[1.5,1.5]])
#mu2=np.array([[3,3]])
if mu2[0][0]<2:
    threshold=2.5
else:
    threshold=4
Sigma=np.array([[0.2,0],[0,0.2]])
R = cholesky(Sigma)
for T in range(10):
    sum=0
    for i in range(100):
        if x[i]:
            mu=mu1
        else:
            mu=mu2
        s=np.dot(np.random.randn(1,2), R) + mu
        if(classify(s)==x[i]):
            sum+=1
    print(sum/100.0)