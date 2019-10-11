import os

for n in (3600, 7200, 14400, 28800):
    # for i in (1, 2, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24):
    for i in (3, 4):
        cmd = 'srun -n %d ./3 %d' % (i, n)
        print cmd
        for _ in range(5):
            os.system(cmd)

# for n in (3600, 7200, 14400, 28800):
#     for i in (1, 4, 9, 16):
#         cmd = 'srun -n %d ./4 %d' % (i, n)
#         print cmd
#         for _ in range(5):
#             os.system(cmd)
