import matplotlib.pyplot as plt

blks = [1] + list(range(10, 90 + 10, 10)) + list(range(100, 2000 + 100, 100))
static = '''0.274s | 0.287s | 0.284s | 0.286s | 0.285s | 0.286s | 0.288s | 0.286s | 0.283s | 0.287s |
0.286s | 0.285s | 0.287s | 0.283s | 0.286s | 0.290s | 0.281s | 0.290s | 0.294s | 0.286s | 
0.281s | 0.290s | 0.287s | 0.294s | 0.300s | 0.301s | 0.304s | 0.308s | 0.304s | 0.285s |'''
dynamic = '''0.174s | 0.161s | 0.160s | 0.160s | 0.160s | 0.160s | 0.161s | 0.162s | 0.161s | 0.161s |
0.161s | 0.161s | 0.172s | 0.164s | 0.180s | 0.194s | 0.190s | 0.168s | 0.175s | 0.182s | 
0.183s | 0.198s | 0.212s | 0.220s | 0.227s | 0.236s | 0.249s | 0.261s | 0.273s | 0.283s | '''
guided = '''0.238s | 0.223s | 0.232s | 0.234s | 0.228s | 0.232s | 0.231s | 0.227s | 0.231s | 0.232s |
0.228s | 0.223s | 0.230s | 0.226s | 0.233s | 0.228s | 0.224s | 0.235s | 0.233s | 0.234s | 
0.227s | 0.230s | 0.238s | 0.239s | 0.242s | 0.249s | 0.254s | 0.265s | 0.271s | 0.284s |'''
pthread = '''0.175s | 0.161s | 0.159s | 0.159s | 0.165s | 0.165s | 0.168s | 0.163s | 0.163s | 0.165s | 
0.167s | 0.168s | 0.173s | 0.177s | 0.182s | 0.192s | 0.195s | 0.185s | 0.169s | 0.180s | 
0.189s | 0.193s | 0.215s | 0.223s | 0.232s | 0.245s | 0.253s | 0.265s | 0.276s | 0.284s |'''

static = list(map(float, static.split('s |')[:-1]))
dynamic = list(map(float, dynamic.split('s |')[:-1]))
guided = list(map(float, guided.split('s |')[:-1]))
pthread = list(map(float, pthread.split('s |')[:-1]))

plt.xlabel('blk')
plt.ylabel('time')
# plt.plot(blks, static, label='static', color='red',  marker='x')
plt.plot(blks, dynamic, label='dynamic', color='blue',  marker='x')
# plt.plot(blks, guided, label='guided', color='green',  marker='x')
plt.plot(blks, pthread, label='pthread', color='red',  marker='x')

# for a, b in zip(blks, static):
#     plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(blks, dynamic):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
# for a, b in zip(blks, guided):
#     plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(blks, pthread):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')

plt.legend()
plt.show()
