//////////////////////////////////////////////////////////////////////////
// Description: this is the base implementation of a simple maze router
// Author: n+e
// Date: 20170429
//////////////////////////////////////////////////////////////////////////
#ifndef BASE_ROUTER_H_
#define BASE_ROUTER_H_

#include <vector>
#include <list>

using namespace std;

class Point;

typedef list <int> IntList;
typedef vector <Point> PointVector;

struct Point {
	int x, y;
	Point(int x_ = 0, int y_ = 0): x(x_), y(y_) {}
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
	std::vector<std::vector<int> >dir_cost;
public:
	BaseRouter(int r, int c, const Point &source, const Point &target, const PointVector &obs);
	bool route(void);
	bool mazeSearch();
	void mazeBacktrace();
	void compXYIndex(int index, int & x, int & y);
	int compIndex(int x, int y);
};

#endif
