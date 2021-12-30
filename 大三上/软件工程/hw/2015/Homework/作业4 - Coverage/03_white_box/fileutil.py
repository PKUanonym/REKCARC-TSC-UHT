#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @file: 03_coverage/code/python/fileutil.py

import os
import zipfile
import rarfile

# set the global parameters of external modules
rarfile.PATH_SEP = '/'


class Extractor(object):
    """Basic interface for archive file extractor."""

    def __init__(self, fobj):
        self.fobj = fobj

    # support with statement
    def __enter__(self):
        return self

    def __exit__(self, type, value, tb):
        if self.fobj:
            self.fobj.close()
            self.fobj = None

    # support iteration over the extractor
    def __iter__(self):
        return self.extract()

    # canonical path: replace '\\' to '/'
    def _canonical_path(self, p):
        return p.replace('\\', '/')

    # basic method to get next file from archive
    def extract(self):
        """Get iterable (fname, fobj) from the archive."""
        raise NotImplementedError()

    # basic method to get names of all files
    def filelist(self):
        """Get iterable fname from the archive."""
        raise NotImplementedError()

    def countfiles(self, maxcount=1048576):
        """Count all files in the archive.

        Args:
            maxcount (int): Maximum files to count.  If exceeds this limit,
                return ``maxcount + 1``.  Default is 1048576.

        Returns:
            The count of entities in this archive.
        """

        counter = 0
        for fname in self.filelist():
            counter += 1
            if counter > maxcount:
                break
        return counter

    def onedir(self):
        """Check whether this archive contains only one directory"""
        last_dname = None
        for fname in self.filelist():
            # get the first directory name
            slash_pos = fname.find('/')
            if slash_pos >= 0:
                dname = fname[: slash_pos]
            else:
                dname = fname
            # ignore some meta data directories
            if dname == '__MACOSX':
                # OS X will add a hidden directory named "__MACOSX" to archive
                # even the user just wants to compress a single directory.
                # So ignore this directory.
                continue
            # check whether one dir.
            if last_dname is None:
                last_dname = dname
            if last_dname != dname:
                return False
        return True

    @staticmethod
    def open(fpath):
        """Open an extractor for given `fpath`."""

        fext = os.path.splitext(fpath)[1].lower()
        if fext in ('.rar'):
            return RarExtractor(fpath)
        if fext in ('.zip'):
            return ZipExtractor(fpath)
        raise ValueError('Archive file "%s" not recognized.')


class ZipExtractor(Extractor):

    def __init__(self, fpath):
        super(ZipExtractor, self).__init__(zipfile.ZipFile(fpath, 'r'))

    def extract(self):
        for mi in self.fobj.infolist():
            # ignore directory entries
            if mi.filename[-1] == '/':
                continue
            f = self.fobj.open(mi)
            yield self._canonical_path(mi.filename), f

    def filelist(self):
        for mi in self.fobj.infolist():
            if mi.filename[-1] == '/':
                continue
            yield self._canonical_path(mi.filename)


class RarExtractor(Extractor):

    def __init__(self, fpath):
        super(RarExtractor, self).__init__(rarfile.RarFile(fpath, 'r'))

    def extract(self):
        for mi in self.fobj.infolist():
            if mi.isdir():
                continue
            f = self.fobj.open(mi)
            yield self._canonical_path(mi.filename), f

    def filelist(self):
        for mi in self.fobj.infolist():
            if mi.isdir():
                continue
            yield self._canonical_path(mi.filename)
