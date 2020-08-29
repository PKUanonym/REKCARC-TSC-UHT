#!/usr/bin/env python3

import os, subprocess
from setuptools import setup

subprocess.check_call('python3 ./source/gen.py --root . --output source'.split())

setup(
    name='thu-cst-cracker',
    description='frontend generator',
    install_requires=['sphinx-markdown-tables'],
)
