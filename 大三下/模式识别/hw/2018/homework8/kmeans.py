import random
import numpy as np
from math import *
import datetime
def dis(a,b):
    return np.linalg.norm(a-b)
be=datetime.datetime.now()
P=[]
fp=open('A1.txt','r')
for i in range(int(fp.readline())):
    line=fp.readline()
    a=list(map(float,line.split()))
    P.append(np.array([a[0],a[1],a[2]]))
fp.close()
fp=open('B1.txt','r')
for i in range(int(fp.readline())):
    line=fp.readline()
    a=list(map(float,line.split()))
    P.append(np.array([a[0],a[1],a[2]]))
fp.close()
fp=open('C1.txt','r')
for i in range(int(fp.readline())):
    line=fp.readline()
    a=list(map(float,line.split()))
    P.append(np.array([a[0],a[1],a[2]]))
fp.close()
n=len(P)
o=random.sample(P,3)
belong=[0 for i in range(n)]
mark=True
while mark:
    mark=False
    newo=[np.array([0.0,0,0]) for i in range(3)]
    for i in range(n):
        L=[dis(P[i],b) for b in o]
        if L.index(min(L))!=belong[i]:
            mark=True
            belong[i]=L.index(min(L))
        newo[belong[i]]+=P[i]
    for i in range(3):
        c=belong.count(i)
        o[i]=newo[i]/c
if list(o[0])>list(o[1]):
    o[0],o[1]=o[1],o[0]
if list(o[1])>list(o[2]):
    o[1],o[2]=o[2],o[1]
if list(o[0])>list(o[2]):
    o[0],o[2]=o[2],o[0]
print('第一簇的中心点')
print(o[0])
print('第二簇的中心点')
print(o[1])
print('第三簇的中心点')
print(o[2])
print('程序用时')
print(datetime.datetime.now()-be)