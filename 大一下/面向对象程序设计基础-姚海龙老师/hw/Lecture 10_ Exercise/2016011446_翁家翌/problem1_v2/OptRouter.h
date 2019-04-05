//////////////////////////////////////////////////////////////////////////
// Description: this is the base implementation of a simple maze router
// Author: YHL
// Date: 20120323
// Note: Modify this file and add OptRouter.cpp file for the
//       implementation of the additional functionalities
//////////////////////////////////////////////////////////////////////////
#ifndef OPT_ROUTER_H_
#define OPT_ROUTER_H_

#include <cstdio>
#include "BaseRouter.h"

const static int X[4] = {1, -1, 0, 0};
const static int Y[4] = {0, 0, 1, -1};

class OptRouter: public BaseRouter
{
	std::vector<std::vector<int> >dir_cost;
public:
	OptRouter(int r, int c, const Point &source, const Point &target, const PointVector &obs)
		: BaseRouter(r, c, source, target, obs)
	{
		int num = this->m_row * this->m_col;
		dir_cost.assign(num, std::vector<int>(4, num));
	}
	~OptRouter() {}
	bool route();
	void mazeBacktrace();
};

#endif
