# A phony test subject class for the 'widgettests' example module
#
# Very artificial, and not to be used as an example of good python style
#
# $Id: widget.py,v 1.2 2000/05/02 21:54:11 purcell Exp $

class Widget:
    def __init__(self, widgetname, size=(50,50)):
        self.name = widgetname
        self._size = size

    def size(self):
        return self._size

    def resize(self, width, height):
        if width < 1 or height < 1:
            raise ValueError, "illegal size"
        self.__size = (width, height) # Deliberate typo

    def dispose(self):
        pass
