import datetime
import random
import numpy as np
from math import *
def Gauss(x,mu,inv):
    return exp(-np.dot(np.dot((x-mu),inv),(x-mu).reshape((3,1)))/2)
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
mean=[np.array([1,1,1]),np.array([3,3,3]),np.array([7,8,9])]
S=[np.diag([1,1,1]),np.diag([2,3,4]),np.diag([6,6,9])]
prob=[1/3,1/3,1/3]
inv=[np.linalg.inv(s) for s in S]
norm=[sqrt(np.linalg.det(s)*(2*pi)**3) for s in S]
for T in range(30):
    tmp=[[Gauss(p,mean[i],inv[i])/norm[i]*prob[i] for i in range(3)]for p in P]#tmp[i][j]=P(xi|wj)*P(wj)
    p=[[tmp[i][j]/sum(tmp[i]) for i in range(n)]for j in range(3)]#p[i][j]=P(wi|xj)
    for i in range(3):
        fenmu=sum(p[i])
        lastmean=mean[i]
        lastprob=prob[i]
        mean[i]=sum([p[i][j]*P[j] for j in range(n)])/fenmu
        prob[i]=fenmu/n
        S[i]=sum([p[i][j]*np.dot((P[j]-mean[i]).reshape((3,1)),(P[j]-mean[i]).reshape((1,3))) for j in range(n)])/fenmu
    inv=[np.linalg.inv(s) for s in S]
    norm=[sqrt(np.linalg.det(s)*(2*pi)**3) for s in S]
print('A,B,C类的先验概率=')
print(prob)
print('A类的mean=')
print(mean[0])
print('B类的mean=')
print(mean[1])
print('C类的mean=')
print(mean[2])
print('A类的协方差矩阵=')
print(S[0])
print('B类的协方差矩阵=')
print(S[1])
print('C类的协方差矩阵=')
print(S[2])
#print(S)
cnt1,cnt2,cnt3=0,0,0
fp=open('A2.txt','r')
for i in range(int(fp.readline())):
    line=fp.readline()
    a=list(map(float,line.split()))
    a=np.array([a[0],a[1],a[2]])
    val=[Gauss(a,mean[i],inv[i])/norm[i] for i in range(3)]
    if val.index(max(val))==0:
        cnt1+=1
fp.close()
print('A类分类正确概率为%f'%(cnt1/100))
fp=open('B2.txt','r')
for i in range(int(fp.readline())):
    line=fp.readline()
    a=list(map(float,line.split()))
    a=np.array([a[0],a[1],a[2]])
    val=[Gauss(a,mean[i],inv[i])/norm[i] for i in range(3)]
    if val.index(max(val))==1:
        cnt2+=1
fp.close()
print('B类分类正确概率为%f'%(cnt2/100))
fp=open('C2.txt','r')
for i in range(int(fp.readline())):
    line=fp.readline()
    a=list(map(float,line.split()))
    a=np.array([a[0],a[1],a[2]])
    val=[Gauss(a,mean[i],inv[i])/norm[i] for i in range(3)]
    if val.index(max(val))==2:
        cnt3+=1
fp.close()
print('C类分类正确概率为%f'%(cnt3/100))
print('总的分类正确概率为%f\n'%((cnt1+cnt2+cnt3)/300))
print(datetime.datetime.now()-be)