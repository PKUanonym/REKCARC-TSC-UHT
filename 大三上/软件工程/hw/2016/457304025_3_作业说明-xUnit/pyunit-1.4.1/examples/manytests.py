#!/usr/bin/env python
#
# Large numbers of unit tests
# 
# $Id: manytests.py,v 1.2 2001/08/06 09:10:00 purcell Exp $

import unittest

class ProlificTestCase(unittest.TestCase):
    """A toy test case class with very many test methods"""

    for i in range(10000):
        exec("def test%i(self): pass" % i)
    del(i)

def suite():
    return unittest.makeSuite(ProlificTestCase)


if __name__ == '__main__':
    # When this module is executed from the command-line, run all its tests
    unittest.TextTestRunner().run(suite())
