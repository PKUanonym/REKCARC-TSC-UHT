#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: ts=4 sw=4 expandtab:

"""
此脚本自动测试当前目录下所有 *.decaf 程序，输出到 output 目录下，
并与 result 目录下的标准答案比较。

请注意我们在判分时会有更多的测试用例。
"""

import os
import subprocess
import sys

def read_txt_file(filename):
    with open(filename,'r') as f:
        txt = f.read().strip()
    # Python should be able to do it automatically, but just in case...
    txt = txt.replace('\r','')
    return txt

def main():
    decaf_jar = os.path.join('..', '..', 'result', 'decaf.jar')
    names = sys.argv[1:]
    if not names:
        names = sorted(os.listdir('.'))
    for name in names:
        bname,ext = os.path.splitext(name)
        if ext != '.decaf':
            continue
        # Run the test case, redirecting stdout/stderr to output/bname.result
        subprocess.call(['java', '-jar', decaf_jar, '-l', '0', name],
                stdout=open(os.path.join('output', bname + '.result'), 'w'),
                stderr=subprocess.STDOUT)
        # Check the result
        expected = read_txt_file(os.path.join('result',bname+'.result'))
        actual = read_txt_file(os.path.join('output',bname+'.result'))
        if expected == actual:
            info = 'OK :)'
        else:
            info = 'ERROR!'
        print('{0:<20}{1}'.format(name,info))
    if os.name == 'nt':
        print('Press Enter to continue...')
        try:
            raw_input() # Python 2
        except:
            input() # Python 3

if __name__ == '__main__':
    main()
