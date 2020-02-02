#!/usr/bin/env python3

import os, argparse
from os.path import sep

EXCLUDE = ['.git', '.gitignore', 'LICENSE', 'Makefile', 'make.bat', 'setup.py', 'source', 'thu_cst_cracker.egg-info']
README_MD = ['README.md', 'readme.md']
EXT = '.md'
PREFIX = 'https://github.com/PKUanonym/REKCARC-TSC-UHT/blob/master/'
rst = '''Welcome to THU-CST-Cracker!
===========================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   TOC

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
'''

def name_filter(s):
    return s.replace('_', '\\_')

def url_filter(s, p):
    c = 'tree' if os.path.isdir(s) else 'blob'
    return PREFIX.replace('blob', c) + s.replace(p, sep.join(p.split(sep)[-2:])).replace('(', '%28').replace(')', '%29').replace(' ', '%20').replace(EXT, '%2e%6d%64')

def get_all(d):
    _all = [os.path.join(d, i) for i in os.listdir(d)]
    files = [i for i in _all if os.path.isfile(i)]
    dirs = [i for i in _all if os.path.isdir(i)]
    files.sort()
    dirs.sort()
    return files, dirs

def get_course(root, cur, depth=0, threshold=30):
    files, dirs = get_all(cur)
    file_num = 0
    md_dir, md_file = '', ''
    for i in dirs:
        d_md, d_num = get_course(root, i, depth + 1)
        if depth >= 2 and d_num > threshold:
            files.append(i)
            print(depth, d_num, i)
        else:
            md_dir += f'{"    " * depth}- [{name_filter(i.split(sep)[-1])}]({url_filter(i, root)})\n'
            md_dir += d_md
            file_num += d_num
    files.sort()
    for i in files:
        file_num += 1
        if i.split(sep)[-1] in README_MD and depth == 0:
            md_file = open(i).read().replace('#', '\t') + '\n\n' + md_file
        else:
            md_file += f'{"    " * depth}- [{name_filter(i.split(sep)[-1])}]({url_filter(i, root)})\n'
    md = md_file + md_dir
    return md, file_num

def get_semester(cur):
    md = ''
    files, dirs = get_all(cur)
    for i in files:
        if i.endswith(EXT):
            md += f'{open(i).read()}\n\n'
    for i in files:
        if not i.endswith(EXT):
            md += f'[{name_filter(i.split(sep)[-1])}]({url_filter(i, cur)})\n\n'
    for i in dirs:
        d_md, d_num = get_course(i, i)
        md += f'## [{name_filter(i.split(sep)[-1])}]({url_filter(i, cur)})\n\n{d_md}\n\n'
    return md

def gen_md(d, n, m):
    if 'README' not in n:
        m = f'# {n.replace(EXT, "").split(sep)[-1]}\n\n{m}'
    if not n.endswith(EXT):
        n += EXT
    print(d, n)
    open(os.path.join(d, n), 'w').write(m)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=str, default='REKCARC-TSC-UHT')
    parser.add_argument("--output", type=str, default='.')
    args = parser.parse_args()
    files, dirs = get_all(args.root)
    files = [i for i in files if i.split(sep)[-1] not in EXCLUDE]
    dirs = [i for i in dirs if i.split(sep)[-1] not in EXCLUDE]
    print(files)
    print(dirs)
    if not os.path.exists(args.output):
        os.makedirs(args.output)
    for i in files:
        gen_md(args.output, i.replace(args.root, '.'), open(i).read())
    for i in dirs:
        gen_md(args.output, i.replace(args.root, '.'), get_semester(i))
    _all = [i.replace(EXT, '').split(sep)[-1] for i in files + dirs]
    rst = rst.replace('TOC', '\n   '.join(_all))
    rst = rst.replace('二', '无').replace('三', '二').replace('无', '三')
    open(os.path.join(args.output, 'index.rst'), 'w').write(rst)
