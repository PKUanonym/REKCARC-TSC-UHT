#include <iostream>
#include <climits>
#include "Layout.h"

namespace RECTPACKING {
using namespace std;

float Layout::compArea()
{
    int lX = INT_MAX, rX = INT_MIN, bY = INT_MAX, tY = INT_MIN;
    for (int i = 0; i < (int)m_rects.size(); ++ i)
    {
        Rect r = m_rects[i];
        if (lX > r.left())
            lX = r.left();
        if (rX < r.right())
            rX = r.right();
        if (bY > r.bottom())
            bY = r.bottom();
        if (tY < r.top())
            tY = r.top();
    }
    return ((float)(rX-lX) * (float)(tY-bY));
}

void Layout::compConstraints(vector<pair<int, int> > &horCons, vector<pair<int, int> > &verCons)
{
  //enumerate each pair of rectangles, can be improved by sweep-line algorithm
  //for each pair of rectangles, there can only be one relationship, either horizontal or vertical
  for (int i = 0; i < (int)m_rects.size(); ++ i)
  {
    int ix1 = m_rects[i].lb.x;
    int ix2 = ix1 + m_rects[i].width;
    int iy1 = m_rects[i].lb.y;
    int iy2 = iy1 + m_rects[i].height;
    for (int j = i+1; j < (int)m_rects.size(); ++ j)
    {
      int jx1 = m_rects[j].lb.x;
      int jx2 = jx1 + m_rects[j].width;
      int jy1 = m_rects[j].lb.y;
      int jy2 = jy1 + m_rects[j].height;

      if ((ix2 <= jx1) && !(iy2 < jy1 || jy2 < iy1))
        horCons.push_back(make_pair(i, j));
      else if ((jx2 <= ix1) && !(iy2 < jy1 || jy2 < iy1))
        horCons.push_back(make_pair(j, i));
      else //NOTE: only consider constraints in one direction to avoid loops in SP
      {
          if ((iy2 <= jy1) && !(ix2 < jx1 || jx2 < ix1))
            verCons.push_back(make_pair(i, j));
          else if ((jy2 <= iy1) && !(ix2 < jx1 || jx2 < ix1))
            verCons.push_back(make_pair(j, i));
      }
    }
  }
}

ostream & operator << (ostream &out, Layout &l)
{
  out << "============= Layout information =============" << endl;
  out << "------------- Rectangles -------------" << endl;
  for (int i = 0; i < (int)l.m_rects.size(); ++ i)
  {
    out << l.m_rects[i];
  }
  out << "------------- Packing code -------------" << endl;
  out << *(l.m_pStrategy->getPackingCommand());

  return out;
}

}
