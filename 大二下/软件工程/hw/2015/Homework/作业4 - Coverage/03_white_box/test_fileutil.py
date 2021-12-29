#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @file: 03_coverage/code/python/test_fileutil.py

"""
This file is just for example and you can compose your own code as you wish.
"""

import unittest
from fileutil import Extractor


class ExtractorTestCase(unittest.TestCase):

    def test_no_file(self):
        ext = Extractor('data/single_file.zip')
        with self.assertRaises(NotImplementedError):
            ext.extract()
        with self.assertRaises(NotImplementedError):
            ext.filelist()

    def test_context_manager(self):
        ext = Extractor('data/single_file.zip')
        with ext.open('data/single_file.zip'):
            pass
        with Extractor(None):
            pass

    def test_iteration(self):
        iter(Extractor.open('data/dir_in_dir.zip'))
        iter(Extractor.open('data/dir_in_dir.rar'))

    def test_extract_zip_single_file(self):
        files = list(Extractor.open('data/dir_in_dir.zip').extract())
        files = list(Extractor.open('data/single_file.zip').extract())
        self.assertEqual(len(files), 1)
        self.assertEqual(files[0][0], 't1.txt')
        self.assertEqual(files[0][1].read().strip(), 'this is t1')

    def test_extract_rar_files(self):
        files = list(Extractor.open('data/dir_in_dir.rar').extract())
        files = list(Extractor.open('data/single_file.rar').extract())
        self.assertEqual(len(files), 1)
        self.assertEqual(files[0][0], 't1.txt')
        self.assertEqual(files[0][1].read().strip(), 'this is t1')

    def test_unrecognized_singal_file(self):
        with self.assertRaises(ValueError):
            Extractor.open('data/single_file2.zjq')

    def test_countfiles(self):
        Extractor.open('data/100_files.zip').countfiles(10)
        Extractor.open('data/100_files.zip').countfiles(200)
        Extractor.open('data/dir_in_dir.rar').countfiles(200)

    def test_onedir(self):
        Extractor.open('data/100_files.zip').onedir()
        Extractor.open('data/mac_one_dir.zip').onedir()

if __name__ == '__main__':
    unittest.main()
