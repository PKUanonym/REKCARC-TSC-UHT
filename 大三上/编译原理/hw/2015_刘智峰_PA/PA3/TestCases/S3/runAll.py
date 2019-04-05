#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import sys

def read_txt_file(filename):
	with open(filename,'r') as f:
		txt = f.read().strip()
	# Python should be able to do it automatically, but just in case...
	txt = txt.replace('\r','')
	return txt

if __name__ == '__main__':
	decaf_jar = os.path.join('..','..','result','decaf.jar')
	names = sys.argv[1:]
	if len(names) == 0:
		names = sorted(os.listdir('.'))
		names.remove('blackjack.decaf')
	for name in names:
		bname,ext = os.path.splitext(name)
		if ext != '.decaf':
			continue
		# Run the test case, redirecting stdout/stderr to output/bname.tac
		cmd = ['java', '-jar', decaf_jar, '-l', '2', name]
		code = subprocess.call(cmd,
				stdout = open(os.path.join('output',bname+'.tac'), 'w'),
				stderr = subprocess.STDOUT)
		fw = open(os.path.join('output',bname+'.result'), 'w')
		if code == 0: # Run the TAC simulator
			subprocess.call(
					['java', '-jar', 'tac.jar', os.path.join('output',bname+'.tac')],
					stdout = fw,
					stderr = subprocess.STDOUT)

		# Check the result
		try:
			reference = read_txt_file(os.path.join('result',bname+'.result'))
			our_result = read_txt_file(os.path.join('output',bname+'.result'))
		except IOError:
			info = 'What the hell??'
		else:
			if reference == our_result:
				info = 'OK :)'
			else:
				info = 'ERROR!'
		print ('{0:<20}{1}'.format(name,info))
	if os.name == 'nt':
		print ('Press Enter to continue...')
		try:
			raw_input() # Python 2
		except:
			input() # Python 3
