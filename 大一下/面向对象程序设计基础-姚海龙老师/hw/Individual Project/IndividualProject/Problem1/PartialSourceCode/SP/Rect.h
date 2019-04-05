#ifndef __SP_RECT_H__
#define __SP_RECT_H__
#include <ostream>
#include "Point.h"

namespace RECTPACKING {

struct Rect
{
    int left() { return lb.x; }
    int right() { return lb.x+width; }
    int bottom() { return lb.y; }
    int top() { return lb.y+height; }
    int width;
    int height;
    Point lb;
};

std::ostream & operator << (std::ostream &out, Rect &r);

}

#endif	//__SP_RECT_H__
