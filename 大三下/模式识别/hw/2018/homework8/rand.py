import numpy as np
import matplotlib.pyplot as plt
def get_data(name,mean,sigma,n):
    A=np.random.multivariate_normal(mean,sigma,n)
    fp=open(name,'w')
    fp.write('%d\n'%n)
    for x in A:
        fp.write('%f %f %f\n'%(x[0],x[1],x[2]))
    fp.close()
get_data('A1.txt',[1,1,1],[[1,0,0],[0,1,0],[0,0,1]],1000)
get_data('A2.txt',[1,1,1],[[1,0,0],[0,1,0],[0,0,1]],100)
get_data('B1.txt',[3,3,3],[[2,0,0],[0,3,0],[0,0,4]],600)
get_data('B2.txt',[3,3,3],[[2,0,0],[0,3,0],[0,0,4]],100)
get_data('C1.txt',[7,8,9],[[6,0,0],[0,6,0],[0,0,9]],1600)
get_data('C2.txt',[7,8,9],[[6,0,0],[0,6,0],[0,0,9]],100)
