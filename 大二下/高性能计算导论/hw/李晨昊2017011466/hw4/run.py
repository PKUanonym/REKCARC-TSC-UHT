from __future__ import print_function
import os
import subprocess
import re
import sys

min_seqs = []


for p in (1, 2, 4, 8, 16, 24):
    for n in (30, 34, 38, 42, 46):
        min_par = 1e9
        min_seq = 1e9
        for r in range(3):
            o = subprocess.check_output(['./fib_omp_task', str(n), str(p-1)])
            o = o.split()
            min_par = min(min_par, float(o[1][10:]))
            min_seq = min(min_seq, float(o[3][10:]))
        print(min_par, end=' ')
        if p == 1:
            min_seqs.append(min_seq)
    print()

print(min_seqs)
