from random import *
def CalcProb(A,B,seq):
    m=5
    L=len(seq)
    pre=[[0 for j in range(m)]for i in range(L)]
    pre[0][0] = 1
    for i in range(1, L):
        for j in range(m):
            for k in range(m if i==L-1 else m-1):
                pre[i][j] += pre[i - 1][k] * A[k][j] * B[j][ord(seq[i]) - 65]
    return pre[L-1][m-1]

def Baum_Welch(seq):
    n,m=4,5
    A=[[0 for j in range(m)]for i in range(m)]
    B=[[0 for j in range(n)]for i in range(m)]
    A[m-1][m-1]=1
    for i in range(0,m-1):
        for j in range(1,m):
            A[i][j]=0.25
    for i in range(m):
        for j in range(n):
            B[i][j]=0.25
    L=len(seq)
    eps=1
    while eps>1e-5:
        eps=0
        pre=[[0 for j in range(m)]for i in range(L)]
        suf=[[0 for j in range(m)]for i in range(L)]

        pre[0][0]=1
        for i in range(1,L):
            for j in range(m):
                for k in range(m if i==L-1 else m-1):
                    pre[i][j]+=pre[i-1][k]*A[k][j]*B[j][ord(seq[i])-65]

        suf[L-1][m-1]=1
        for i in range(L-2,-1,-1):
            for j in range(m-1):
                for k in range(m):
                    suf[i][j]+=suf[i+1][k]*A[j][k]*B[k][ord(seq[i+1])-65]

        r=[[[0 for k in range(L)]for j in range(m)]for i in range(m)]
        for i in range(m):
            for j in range(m):
                for t in range(1,L):
                    r[i][j][t]=pre[t-1][i]*A[i][j]*B[j][ord(seq[t])-65]*suf[t][j]

        for i in range(1,m-1):
            for j in range(m):
                fenzi=0
                fenmu=0
                for t in range(1,L):
                    fenzi+=r[i][j][t]
                    for k in range(m):
                        fenmu+=r[i][k][t]
                t=A[i][j]
                if fenmu==0:
                    A[i][j]=0
                else:
                    A[i][j]=fenzi/fenmu
                eps=max(eps,abs(A[i][j]-t))

        for i in range(1,m-1):
            for j in range(n):
                fenzi=0
                fenmu=0
                for t in range(1,L):
                    for k in range(m):
                        fenmu+=r[k][i][t]
                        if ord(seq[t])-65==j:
                            fenzi+=r[k][i][t]
                t=B[i][j]
                if fenmu==0:
                    B[i][j]=0
                else:
                    B[i][j]=fenzi/fenmu
                eps=max(eps,abs(B[i][j]-t))
    print(CalcProb(A,B,seq))
    return (A,B)

def classify(A1,B1,A2,B2,seq):
    p1=CalcProb(A1,B1,seq)
    p2=CalcProb(A2,B2,seq)
    print(p1,p2)
    if p1>p2:
        print('模型一')
    else:
        print('模型二')
    print('P(w2|x)/P(w1|x)=',p2/p1)
para1=Baum_Welch('AABBCCDD')
para2=Baum_Welch('DDABCBA')

print('模型一：')
for x in para1[0]:
    print(x)
print()
for x in para1[1]:
    print(x)
print()

print('模型二：')
for x in para2[0]:
    print(x)
print()
for x in para2[1]:
    print(x)
print()

classify(para1[0],para1[1],para2[0],para2[1],'ABBBCDDD')
classify(para1[0],para1[1],para2[0],para2[1],'DADBCBAA')
classify(para1[0],para1[1],para2[0],para2[1],'CDCBABA')
classify(para1[0],para1[1],para2[0],para2[1],'ADBBBCD')
classify(para1[0],para1[1],para2[0],para2[1],'BADBDCBA')