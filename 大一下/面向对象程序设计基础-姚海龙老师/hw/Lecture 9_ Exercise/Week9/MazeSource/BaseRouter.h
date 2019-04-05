//////////////////////////////////////////////////////////////////////////
// Description: this is the base implementation of a simple maze router
// Author: YHL
// Date: 20120323
// Note: Do NOT modify this file
//////////////////////////////////////////////////////////////////////////
#ifndef BASE_ROUTER_H_
#define BASE_ROUTER_H_

#include <vector>
#include <list>

using namespace std;

class Point;

typedef list <int> IntList;
typedef vector <Point> PointVector;

class Point {
    int m_x, m_y;    
public:
    Point() {}
    Point(int x, int y):m_x(x), m_y(y) {}
    int &x() { return m_x; }
    int &y() { return m_y; }
    int x() const { return m_x; }
    int y() const { return m_y; }
    void setX(int x) { m_x = x; }
    void setY(int y) { m_y = y; }
};

class BaseRouter
{
private:
	BaseRouter(const BaseRouter & r);
	BaseRouter & operator =(const BaseRouter & rhs);
protected:
	enum { OBS = -1 };
	int m_row;
	int m_col;
	int m_sourceIndex;
	int m_targetIndex;
    vector <int> m_grids;
	vector <int> m_path;
public:
    BaseRouter(int r, int c, const Point &source, const Point &target, const PointVector &obs);
	~BaseRouter(void);
	bool route(void);
	bool mazeSearch();
	void mazeBacktrace();
	void compXYIndex(int index, int & x, int & y);
	int compIndex(int x, int y);
};

#endif
