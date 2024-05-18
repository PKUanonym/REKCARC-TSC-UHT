import subprocess
import os
import random

try:
    from tqdm import trange as range
except ImportError:
    pass


def fib(n):
    if n < 2:
        return n
    pre, cur = 1, 1
    for _ in range(2, n):
        t = cur
        cur += pre
        pre = t
    return cur

# 系统调用as和ld命令来编译与链接汇编代码
os.system("as -g fib.s -o fib.o && ld fib.o -o fib")

for i in range(100):
    # 随机化测试
    n = random.randint(1, 36)
    golden = fib(n)

    # 创建子进程去执行./fib，并从子进程的标准输出中读取结果
    p = subprocess.Popen("./fib", stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    ans = int(p.communicate(input=(str(n) + "\n").encode())[0].decode().strip())

    # 检查答案是否正确，若非输出错误信息
    assert ans == golden, f"Wrong Answer: n = {n}, ans = {ans}, golden = {golden}"

print("Congratz! You've passed the test!")

os.system("rm ./fib.o ./fib")