#include <iostream>
#include "Rect.h"

namespace RECTPACKING {
using namespace std;

ostream & operator << (ostream &out, Rect &r)
{
  out << "[" << r.lb.x << "," << r.lb.y << "]-[" << r.lb.x+r.width << "," << r.lb.y+r.height << "]" << endl;

  return out;
}

}
