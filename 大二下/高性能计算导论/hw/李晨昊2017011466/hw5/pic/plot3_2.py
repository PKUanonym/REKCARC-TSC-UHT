import matplotlib.pyplot as plt
import numpy as np

# data = ''' 0.02905s | 0.10707s | 0.27759s | 0.62348s | 1.14682s |
#  0.02637s | 0.05793s | 0.12984s | 0.33981s | 0.54269s |
#  0.01441s | 0.03087s | 0.08311s | 0.18087s | 0.29576s |
#  0.01119s | 0.02185s | 0.05794s | 0.12896s | 0.21299s |
#  0.01019s | 0.02480s | 0.04664s | 0.09645s | 0.15156s |
#  0.00961s | 0.01864s | 0.05524s | 0.07933s | 0.16566s |
#  0.00954s | 0.02151s | 0.05835s | 0.09079s | 0.11473s |
#  0.00915s | 0.01995s | 0.04034s | 0.08840s | 0.12367s |
#  0.00854s | 0.01309s | 0.03502s | 0.07951s | 0.10757s |
#  0.00843s | 0.01373s | 0.03304s | 0.07125s | 0.10845s |
#  0.00791s | 0.01489s | 0.03750s | 0.05872s | 0.10018s |
#  0.00915s | 0.01260s | 0.02596s | 0.05035s | 0.07533s |
#  0.00831s | 0.01325s | 0.03003s | 0.04433s | 0.07256s |'''
data = '''0.02956s | 0.11585s | 0.30878s | 0.66505s | 1.14823s | 
0.01412s | 0.02988s | 0.07663s | 0.13395s | 0.23511s | 
0.00409s | 0.01290s | 0.02252s | 0.03510s | 0.04931s | 
0.00259s | 0.00696s | 0.01416s | 0.01626s | 0.03212s | 
0.00191s | 0.00444s | 0.00784s | 0.01264s | 0.01446s | 
0.00139s | 0.00346s | 0.00547s | 0.00776s | 0.01606s | 
0.00123s | 0.00261s | 0.00444s | 0.00669s | 0.00908s | 
0.00123s | 0.00253s | 0.00384s | 0.00541s | 0.00710s | 
0.00098s | 0.00229s | 0.00341s | 0.00468s | 0.00553s | 
0.00098s | 0.00218s | 0.00338s | 0.00467s | 0.00602s | 
0.00099s | 0.00194s | 0.00284s | 0.00405s | 0.00563s | 
0.00093s | 0.00173s | 0.00288s | 0.00388s | 0.00510s | 
0.00104s | 0.00172s | 0.00258s | 0.00380s | 0.00516s | '''

data = list(map(float, data.split('s |')[:-1]))

th = (1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24)
n2e4 = data[0] / np.array(data[0::5])
n4e4 = data[1] / np.array(data[1::5])
n6e4 = data[2] / np.array(data[2::5])
n8e4 = data[3] / np.array(data[3::5])
n1e5 = data[4] / np.array(data[4::5])

plt.xlabel('thread')
plt.ylabel('accelerate factor')

plt.plot(th, n2e4, label='n=2e4', color='red',  marker='x')
plt.plot(th, n4e4, label='n=4e4', color='blue',  marker='x')
plt.plot(th, n6e4, label='n=6e4', color='green',  marker='x')
plt.plot(th, n8e4, label='n=8e4', color='yellow',  marker='x')
plt.plot(th, n1e5, label='n=1e5', color='cyan',  marker='x')
plt.plot(th, th, label='y=x', color='purple',  marker='x')

for a, b in zip(th, n2e4):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(th, n4e4):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(th, n6e4):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(th, n8e4):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(th, n1e5):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(th, th):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')

plt.legend()
plt.show()
