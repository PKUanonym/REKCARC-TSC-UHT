#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @file: 02_xunit/code/python/test_findobj.py

import findobj
import unittest


class FindObjectTestCase(unittest.TestCase):

    def runTest(self):
        self.test_find_module()
        self.test_find_module_object()
        self.test_find_module_module()
        self.test_find_module_module_object()
        self.test_find_module_module_object_object()
        self.test_find_empty_name()
        self.test_cannot_find_module()
        self.test_cannot_find_module_object()
        pass

    def test_find_module(self):
        findobj.find_object("os")
        pass

    def test_find_module_object(self):
        findobj.find_object("os.remove")
        pass

    def test_find_module_module(self):
        findobj.find_object("os.path")
        pass

    def test_find_module_module_object(self):
        findobj.find_object("os.path.split")
        pass

    def test_find_module_module_object_object(self):
        findobj.find_object("os.path.split.__name__")
        pass

    def test_find_empty_name(self):
        try:
            findobj.find_object("")
        except ImportError:
            pass
        else:
            self.fail("expected a ImportError")
        pass

    def test_cannot_find_module(self):
        try:
            findobj.find_object("not_exit_module")
        except ImportError:
            pass
        else:
            self.fail("expected a ImportError")
        pass

    def test_cannot_find_module_object(self):
        try:
            findobj.find_object("os.not_exit_object")
        except ImportError:
            pass
        else:
            self.fail("expected a ImportError")
        pass
        pass

fotc = FindObjectTestCase()
fotc.runTest()
