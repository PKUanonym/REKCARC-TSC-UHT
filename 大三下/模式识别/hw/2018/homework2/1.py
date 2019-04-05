from math import *
def S13(x1,x2):
    return x1**2/2
def S23(x1,x2):
    return (x2**2-x1**2)/2
x1=(-2+4*sqrt(2))/14
x2=(16-4*sqrt(2))/14
print(S13(x1,x2)+S23(x1,x2))