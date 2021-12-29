#!/usr/bin/env jpython
"""Example of using PyUnit with JPython"""

import sys, os
## Patch paths to pyunit and standard C-python modules; adapt to your machine!
sys.path.insert(0, os.path.dirname(os.getcwd())) # i.e. '..'
sys.path.insert(0,'/usr/lib/python1.5')
import unittest
import java.util.StringTokenizer
StringTokenizer = java.util.StringTokenizer

class StringTokenizerTestCase(unittest.TestCase):

    def _getTokens(self, tokenizer):
        tokens = []
        while tokenizer.hasMoreTokens():
            tokens.append(tokenizer.nextToken())
        return tokens

    def testDefaultTokenizing(self):
        "Default tokenizing with whitespace delimiters"
        tokenizer = StringTokenizer("mary had\t a\n little   lamb")
        assert self._getTokens(tokenizer) == ['mary','had','a','little','lamb']

    def testNullDelimiters(self):
        "Tokenizing a string containing nulls"
        tokenizer = StringTokenizer("a\000b\000c","\000")
        assert self._getTokens(tokenizer) == ['a','b','c']

def suite():
    return unittest.makeSuite(StringTokenizerTestCase)

if __name__ == '__main__':
    unittest.main(defaultTest='suite')
