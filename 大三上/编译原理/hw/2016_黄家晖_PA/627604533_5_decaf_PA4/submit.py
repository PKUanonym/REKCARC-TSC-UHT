#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: ts=4 sw=4 expandtab:

"""
完成作业以后，运行本文件，它会将你的代码、实验报告一起打包为 submit.zip。
"""

from __future__ import print_function # Requires Python 2.7+

import locale
import os
import re
import sys
import zipfile


# Python3's input == Python2's raw_input
try:
    input_compat = raw_input
except NameError:
    input_compat = input


def S(s):
    # F*** systems that still refuse to use UTF-8 by default in the 21st century
    if 'decode' in dir(s):
        return s.decode('utf-8').encode(locale.getpreferredencoding()) # Python 2 is naughty
    else:
        return s # Python 3 is good
    # FIXME: Can anybody please tell me whether there is a simpler way to make Chinese
    # characters display correctly in both Python 2 and 3, and in all three major OSes
    # (Win/Lin/Mac)?


def main():

    # Preparations
    locale.setlocale(locale.LC_ALL, '')

    # Check whether decaf.jar exists
    decaf_jar = os.path.join('result', 'decaf.jar')
    if not os.path.exists(decaf_jar):
        print(S('未找到 decaf.jar 文件。请重新编译。'), file=sys.stderr)
        return 1
    print(S('已找到 {}'.format(decaf_jar)))

    # Check whether report exists
    for report_file in ['report.txt', 'report.doc', 'report.docx', 'report.pdf', 'report.odf']:
        if os.path.exists(report_file):
            break
    else:
        print(S('未找到实验报告。请确认它的文件名正确 (report.txt/doc/docx/pdf/odf)。'), file=sys.stderr)
        return 1
    print(S('已找到实验报告 {}'.format(report_file)))

    # Ask for E-mail
    email = input_compat(S('请输入您的 Email: '))
    while not re.match(r'[^@]+@\w+\.[\w.]+', email):
        email = input_compat(S('Email 格式不正确，请重新输入: '))

    # Creating submit.zip
    submit_zip = zipfile.ZipFile('submit.zip', 'w')
    submit_zip.write(decaf_jar, 'decaf.jar', zipfile.ZIP_STORED)
    submit_zip.write(report_file, report_file, zipfile.ZIP_DEFLATED)
    submit_zip.writestr('email.txt', email.encode('utf-8'), zipfile.ZIP_STORED)

    startdir = "src" 
    for dirpath, dirnames, filenames in os.walk(startdir): 
        for filename in filenames: 
            submit_zip.write(os.path.join(dirpath,filename)) 
    submit_zip.close() 

    # Finished
    print(S('完成。请将 submit.zip 文件上传到网络学堂。'))
    return 0


if __name__ == '__main__':
    retcode = main()
    if os.name == 'nt':
        input_compat('Press Enter to continue...')
    sys.exit(retcode)
