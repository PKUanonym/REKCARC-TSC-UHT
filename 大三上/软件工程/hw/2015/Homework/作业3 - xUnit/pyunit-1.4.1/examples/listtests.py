#!/usr/bin/env python
#
# Unit tests for lists. This example shows how subclassing can be used in
# order to re-use test code wth different test objects. Comments in this
# module explain some points about typical usage. See the documentation for
# more information, including the documentation strings in the unittest module.
# 
# $Id: listtests.py,v 1.3 2001/03/12 11:52:56 purcell Exp $

import unittest
from UserList import UserList

class ListTestCase(unittest.TestCase):
    """A simple and incomplete test case for python's built-in lists"""
    def setUp(self):
        self.list = [] # All list test cases will start with an empty list

    def _appendItemsToList(self,items):
        """Do some further set-up. Used by some of the test functions."""
        for item in items: self.list.append(item)

    def testAppend(self):
        # See note in documentation concerning use of 'assert' vs. 'assert_'
        self.assert_(len(self.list) == 0)
        self.list.append('anItem')
        self.assertEquals(len(self.list), 1)
        self.assertEquals(self.list[0], 'anItem')

    def testCount(self):
	"Check count() within heterogeneous list"
        self._appendItemsToList(('a','b',1,2,'a','2'))
        self.assert_(self.list.count('a') == 2)
        # failUnless is synonymous with assert_
        self.failUnless(self.list.count('c') == 0)
        self.failUnless(self.list.count(2) == 1)
        self.failUnless(self.list.count(None) == 0)
        
    def testIndexing(self):
        # Normally when an exception is expected we would use
        # 'self.assertRaises', but this is not possible when testing behaviour
        # of operators such as []
        try:
            self.list[0]
        except IndexError: pass
        else: self.fail('expected IndexError when list empty')
        self.list.append('first')
        self.failUnless(self.list[0] == 'first')
        self.failUnless(self.list[-1] == 'first')

    def testSlicing(self):
        self.failUnless(len(self.list[:0]) == 0)
        self.failUnless(len(self.list[:1]) == 0)
        self.failUnless(len(self.list[1:]) == 0) # no IndexErrors expected
        self.failUnless(len(self.list[1:1]) == 0)
        self._appendItemsToList(('first','second','third'))
        self.failUnless(len(self.list[:1]) == 1)
        self.failUnless(type(self.list[:1]) == type(self.list))

class UserListTestCase(ListTestCase):
    """A ListTestCase subclass that tests UserLists"""
    def setUp(self):
        self.list = UserList()

def suite():
    """Returns a suite containing all the test cases in this module.
       It can be a good idea to put an identically named factory function
       like this in every test module. Such a naming convention allows
       automation of test discovery.
    """
    # Build a TestSuite containing all the possible test case instances
    # that can be made from the ListTestCase class using its 'test*'
    # functions.
    suite1 = unittest.makeSuite(ListTestCase)
    # Same with UserListTestCase, which subclasses ListTestCase; the 'test*'
    # methods in the base class will be found
    suite2 = unittest.makeSuite(UserListTestCase)
    # Make a composite test suite containing the two other suites
    return unittest.TestSuite((suite1, suite2))


if __name__ == '__main__':
    # When this module is executed from the command-line, run all its tests
    unittest.main()
