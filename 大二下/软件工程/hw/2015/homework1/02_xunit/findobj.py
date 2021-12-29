#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @file: 02_xunit/code/python/findobj.py

import sys


def find_object(name):
    """Find object according to `name`.

    This method will try to import all the essential modules to find the
    requested object.

    Args:
        name (str): The name of the object, should contain full module
            names from the global scope.

    Returns:
        The object instance.

    Raises:
        ImportError: If object with `name` cannot be found.
        Exception: When importing external module, they may raise exceptions.

    Examples:
        >>> find_object('os')
        <module 'os' from '?'>

        >>> find_object('os.path')
        <module 'posixpath' from '?'>

        >>> find_object('os.remove')
        <function posix.remove>

        >>> find_object('os.path.split')
        <function posixpath.split>

        >>> find_object('os.path.split.__name__')
        'split'
    """

    # If name is empty, fail fast
    if not name:
        raise ImportError('Object name should not be empty.')

    # Try to import the closest module according to `name`.
    parts = name.split('.')

    # Try to treat some prefix of the name as module
    obj = None
    for i in xrange(len(parts), 0, -1):
        modname = '.'.join(parts[:i])
        try:
            obj = __import__(modname)
            obj = sys.modules[modname]
            parts = parts[i:]
            break
        except ImportError:
            # We can ignore the exception unless it is ImportError.
            # Otherwise there should be something wrong when importing
            # existing module.
            pass

    # If we failed to import the container module, then we raise an
    # ImportError
    if obj is None:
        raise ImportError("Couldn't find any module along `%s`." % name)

    # Try to get the object along attribute path
    for name in parts:
        if not hasattr(obj, name):
            raise ImportError(
                "Object '%s' does not have attribute '%s'." % (obj, name))
        obj = getattr(obj, name)

    # Now we've got the object
    return obj
