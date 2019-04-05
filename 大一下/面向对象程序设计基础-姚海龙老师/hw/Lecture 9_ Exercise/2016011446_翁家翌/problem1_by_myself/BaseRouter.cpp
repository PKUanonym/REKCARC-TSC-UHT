//////////////////////////////////////////////////////////////////////////
// Description: this is the base implementation of a simple maze router
// Author: n+e
// Date: 20170429
//////////////////////////////////////////////////////////////////////////
#include <cstdio>
#include "BaseRouter.h"

const static int X[4] = {1, -1, 0, 0};
const static int Y[4] = {0, 0, 1, -1};

BaseRouter::BaseRouter(int r, int c, const Point &source, const Point &target, const PointVector &obs)
	: m_row(r), m_col(c)
{
	int num = this->m_row * this->m_col;
	m_grids.assign(num, num);
	direction.assign(num, OBS);
	dir_cost.assign(num, num);
	for (unsigned i = 0; i < obs.size(); ++ i)
	{
		int index = this->compIndex(obs[i].x(), obs[i].y());
		m_grids[index] = OBS;
	}
	m_sourceIndex = this->compIndex(source.x(), source.y());
	m_targetIndex = this->compIndex(target.x(), target.y());
}

BaseRouter::~BaseRouter(void)
{
}

//maze routing
bool BaseRouter::route(void)
{
	if (this->m_sourceIndex < 0 || this->m_targetIndex < 0 || this->m_row <= 0 || this->m_col <= 0)
		return false;

	this->m_path.clear();

	//initialize the cost of the source grid
	m_grids[this->m_sourceIndex] = 0;

	//maze expansion
	if (mazeSearch())
	{
		mazeBacktrace();
		return true;
	}
	else
		return false;
}

//maze expansion from source grid to target grid
bool BaseRouter::mazeSearch()
{
	bool found = false;
	IntList mf;
	mf.push_back(m_sourceIndex);
	while (mf.size())
	{
		int index = mf.front();
		int curCost = m_grids[index];
		mf.pop_front();
		int x, y;
		this->compXYIndex(index, x, y);
		printf("Searching grid [%d,%d] cost: %d\n", x, y, curCost);
		for (int i = 0; i < 4; ++ i)
		{
			int newX = x + X[i];
			int newY = y + Y[i];
			if (newY >= 0 && newY < this->m_row && newX < this->m_col && newX >= 0)
			{
				int newIndex = this->compIndex(newX, newY);
				if (m_grids[newIndex] > curCost + 1)
				{
					m_grids[newIndex] = curCost + 1;
					if (newIndex == m_targetIndex)
					{
						found = true;
						break;
					}
					mf.push_back(newIndex);
				}
			}
		}
		if (found)
			break;
	}

	return found;
}
//trace back from target grid to source grid
void BaseRouter::mazeBacktrace()
{
	std::list<int> que;
	que.push_back(m_targetIndex);
	dir_cost[m_targetIndex] = 0;
	direction[m_targetIndex] = OBS;
	while (que.size())
	{
		int index = que.front();
		int curCost = m_grids[index];
		que.pop_front();
		int x, y, dir = direction[index];
		compXYIndex(index, x, y);
		for (int i = 0; i < 4; ++i)
		{
			int newX = x - X[i];
			int newY = y - Y[i];
			if (newY >= 0 && newY < this->m_row && newX < this->m_col && newX >= 0)
			{
				int newIndex = this->compIndex(newX, newY);
				if (m_grids[newIndex] + 1 == curCost && m_grids[newIndex] != -1)
				{
					int Is_turn = (dir != OBS && dir != i);
					if (dir_cost[newIndex] > dir_cost[index] + Is_turn)
					{
						dir_cost[newIndex] = dir_cost[index] + Is_turn;
						direction[newIndex] = i;
						que.push_back(newIndex);
					}
				}
			}
		}
	}
	int x, y;
	compXYIndex(m_sourceIndex, x, y);
	printf("Distance = %d\n", m_grids[m_targetIndex]);
	printf("Minimum turns = %d\n", dir_cost[m_sourceIndex]);
	while (compIndex(x, y) != m_targetIndex)
	{
		printf("[%d,%d]->", x, y);
		int dir = direction[compIndex(x, y)];
		x += X[dir];
		y += Y[dir];
	}
	printf("[%d,%d]\n", x, y);
}

void BaseRouter::compXYIndex(int index, int & x, int & y)
{
	x = index % this->m_col;
	y = index / this->m_col;
}

int BaseRouter::compIndex(int x, int y)
{
	return this->m_col * y + x;
}
