#!/usr/bin/env python
#
# Example of assembling all available unit tests into one suite. This usually
# varies greatly from one project to the next, so the code shown below will not
# be incorporated into the 'unittest' module. Instead, modify it for your own
# purposes.
# 
# $Id: alltests.py,v 1.3 2001/03/12 11:52:56 purcell Exp $

import unittest

def suite():
    modules_to_test = ('listtests', 'widgettests') # and so on
    alltests = unittest.TestSuite()
    for module in map(__import__, modules_to_test):
        alltests.addTest(unittest.findTestCases(module))
    return alltests

if __name__ == '__main__':
    unittest.main(defaultTest='suite')
