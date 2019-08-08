from __future__ import print_function
import subprocess
import re

# for blk in [1] + range(10, 100, 10):
#     m = 1e9
#     for _ in range(5):
#         o = subprocess.check_output(['./4_2', '48000', '24', str(blk)])
#         m = min(m, float(o))
#     print('%.3f' % m, end='s | ')
# print()
# for i in range(2):
#     for j in range(1, 11):
#         blk = i * 1000 + j * 100
#         m = 1e9
#         for _ in range(5):
#             o = subprocess.check_output(['./4_2', '48000', '24', str(blk)])
#             m = min(m, float(o))
#         print('%.3f' % m, end='s | ')
#     print()

# for blk in range(100, 4000 + 100, 100):
#     m = 1e9
#     for _ in range(5):
#        o = subprocess.check_output(
#            ['./4_1', '96000', '24'], env={'OMP_SCHEDULE': 'static,%d' % blk})
#        m = min(m, float(o))
#        pass
#     print('%.5f' % m, end='s | ')
#     print()
t1s = []
t2s = []


# for i in (1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24):
#     t1s.append('')
#     t2s.append('')
#     for n in (3600, 7200, 14400, 28800):
#         t1 = 1e9
#         t2 = 1e9
#         for _ in range(5):
#             o = subprocess.check_output(
#                 ['srun', '-n', str(i), './1_1', str(n)])
#             t1 = min(t1, float(re.findall(
#                 r'prod\(\+MPI_Scatter\): ([^s]+)s', o)[0]))
#             t2 = min(t1, float(re.findall(
#                 r'prod\(-MPI_Scatter\): ([^s]+)s', o)[0]))
#         t1s[-1] += '%.5fs | ' % t1
#         t2s[-1] += '%.5fs | ' % t2

# for i in  (1, 4, 9, 16):
#     t1s.append('')
#     t2s.append('')
#     for n in (3600, 7200, 14400, 28800):
#         t1 = 1e9
#         t2 = 1e9
#         for _ in range(5):
#             o = subprocess.check_output(
#                 ['srun', '-n', str(i), './1_2', str(n)])
#             t1 = min(t1, float(re.findall(
#                 r'prod\(\+MPI_Scatter\): ([^s]+)s', o)[0]))
#             t2 = min(t1, float(re.findall(
#                 r'prod\(-MPI_Scatter\): ([^s]+)s', o)[0]))
#         t1s[-1] += '%.5fs | ' % t1
#         t2s[-1] += '%.5fs | ' % t2

# for t1 in t1s:
#     print(t1)
# print()

# for t2 in t2s:
#     print(t2)
# print()

# for algo in range(0, 6):
#     for n in range(20000, 100000+20000, 20000):
#         m = 1e9
#         for _ in range(0, 5):
#             o = subprocess.check_output(['./3', str(algo), str(n)])
#             m = min(m, float(o))
#         print('%.5f' % m, end='s | ')
#     print()

# for th in [1] + list(range(2, 24 + 2, 2)):
#     for n in range(20000, 100000+20000, 20000):
#         m = 1e9
#         for _ in range(0, 5):
#             o = subprocess.check_output(['./3', '1', str(n), str(th)])
#             m = min(m, float(o))
#         print('%.5f' % m, end='s | ')
#     print()

print()
for th in [1] + list(range(2, 24 + 2, 2)):
    for n in range(20000, 100000+20000, 20000):
        m = 1e9
        for _ in range(0, 5):
            o = subprocess.check_output(['./3', '2', str(n), str(th)])
            m = min(m, float(o))
        print('%.5f' % m, end='s | ')
    print()
