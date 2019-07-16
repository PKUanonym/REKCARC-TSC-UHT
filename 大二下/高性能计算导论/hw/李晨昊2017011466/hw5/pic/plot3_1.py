import matplotlib.pyplot as plt
import numpy as np

data = '''0.02705s | 0.10475s | 0.30914s | 0.65088s | 1.15128s |
0.01180s | 0.01668s | 0.02386s | 0.04726s | 0.06355s |
0.00185s | 0.00379s | 0.00592s | 0.00790s | 0.00996s |
0.00107s | 0.00222s | 0.00347s | 0.00468s | 0.00608s |
0.00017s | 0.00039s | 0.00065s | 0.00089s | 0.00111s |'''
# data = '''0.02705s | 0.10475s | 0.30914s | 0.65088s | 1.15128s |
# 0.01180s | 0.01668s | 0.02386s | 0.04726s | 0.06355s |
# 0.00218s | 0.00279s | 0.00348s | 0.00447s | 0.00714s |
# 0.00185s | 0.00379s | 0.00592s | 0.00790s | 0.00996s |
# 0.00107s | 0.00222s | 0.00347s | 0.00468s | 0.00608s |
# 0.00017s | 0.00039s | 0.00065s | 0.00089s | 0.00111s |'''


data = list(map(float, data.split('s |')[:-1]))

ns = (1e4, 4e4, 6e4, 8e4, 1e5)
count = data[0:5]
count_par = data[5:10]
# count_llx = data[10:15]
# qsort = data[15:20]
# std_sort = data[20:25]
# radix = data[25:30]
qsort = data[10:15]
std_sort = data[15:20]
radix = data[20:25]

plt.xlabel('n')
plt.ylabel('time')

plt.semilogy(ns, count, label='count', color='red',  marker='x')
plt.semilogy(ns, count_par, label='count_par', color='blue',  marker='x')
# plt.semilogy(ns, count_llx, label='count_llx', color='purple',  marker='x')
plt.semilogy(ns, qsort, label='qsort', color='green',  marker='x')
plt.semilogy(ns, std_sort, label='std_sort', color='yellow',  marker='x')
plt.semilogy(ns, radix, label='radix', color='cyan',  marker='x')

for a, b in zip(ns, count):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(ns, count_par):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
# for a, b in zip(ns, count_llx):
#     plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(ns, qsort):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(ns, std_sort):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')
for a, b in zip(ns, radix):
    plt.text(a, b, '%.3f' % b, ha='center', va='bottom')

plt.legend()
plt.show()
