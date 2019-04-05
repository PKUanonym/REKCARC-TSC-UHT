#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import sys


def get_spim():
    '''Return (dir, exe)'''
    if os.name == 'nt': # Windows
        spim = 'spim.exe'
    elif sys.platform == 'darwin': # Mac OS (FIXME: NOT TESTED! PLEASE MAKE CHANGES TO THIS SCRIPT IF NECESSARY)
        spim = './spim.mac'
    elif sys.platform.startswith('linux'): # Linux (x86/amd64)
        spim = './spim.linux'
    else:
        print ("What the hell OS are you using?!!")
        sys.exit(1)
    return os.path.join('..', '..', 'tools', 'spim'), spim


def main():
    decaf_jar = os.path.join('..', '..', 'result', 'decaf.jar')
    asm_file = os.path.join('output', 'blackjack.s')
    spim_dir, spim_exe = get_spim()
    # Python interprets argv[0] differently on Windows and Unix if 'cwd=' is specified. Use absolute path.
    spim_exe = os.path.abspath(os.path.join(spim_dir, spim_exe))

    with open(asm_file, 'w') as fw:
        code = subprocess.call(['java', '-jar', decaf_jar, '-l', '4', 'blackjack.decaf'], stdout=fw)

    if code == 0:
        code = subprocess.call([spim_exe, os.path.relpath(asm_file, spim_dir)], cwd=spim_dir)

    sys.exit(code)

if __name__ == '__main__':
    main()

# vim: ts=4 sw=4 expandtab:
