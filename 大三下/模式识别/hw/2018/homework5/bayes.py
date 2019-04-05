import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d
def f(a,b,n):
    return ((b-a)**(1-n)-(b+6)**(1-n)-(6-a)**(1-n)+12**(1-n))/n/(n-1)
def g(x,y,xl1,xu1,xl2,xu2,n):
    xl1=min(x,xl1)
    xu1=max(x,xu1)
    xl2=min(y,xl2)
    xu2=max(y,xu2)
    return f(xl1,xu1,n)*f(xl2,xu2,n)
fp=open("input.txt","r")
xl1,xu1,xl2,xu2=6,-6,6,-6
K=200
T=K*1j

for n in range(1,11):
    x1,x2=[float(x) for x in fp.readline().split(' ')]
    print(x1,x2)
    xl1=min(xl1,x1)
    xu1=max(xu1,x1)
    xl2=min(xl2,x2)
    xu2=max(xu2,x2)
    if n>=2:
        x, y = np.mgrid[-6:6:T, -6:6:T]
        z = np.zeros([K,K])
        s=0
        for i in range(K):
            for j in range(K):
                z[i][j]=g(x[i][j],y[i][j],xl1,xu1,xl2,xu2,n)
                s+=z[i][j]*(12.0/K)**2
        for i in range(K):
            for j in range(K):
                z[i][j]/=s
        print(s)
        s=0
        for i in range(K):
            for j in range(K):
                s+=z[i][j]*(12.0/K)**2
        ax = plt.subplot(111, projection='3d')
        ax.plot_surface(x, y, z, rstride=2, cstride=1, cmap=plt.cm.coolwarm, alpha=0.8)
        ax.set_xlabel('x')
        ax.set_ylabel('y')
        ax.set_zlabel('z')
        plt.savefig(str(n)+".png")

