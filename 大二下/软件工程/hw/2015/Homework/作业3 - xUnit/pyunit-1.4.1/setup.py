
# see http://software-carpentry.codesourcery.com/entries/build/Distutils/Distutils.html for more information about this file

from distutils.core import setup

setup (
    name = "PyUnit",
    version = "1.4.1",
    description = "PyUnit - a unit testing framework for Python",
    author = "Steve Purcell",
    author_email = "stephen_purcell@yahoo.com",
    url = "http://pyunit.sourceforge.net/",
       
    py_modules = ['unittest', 'unittestgui']
    )
      
      
