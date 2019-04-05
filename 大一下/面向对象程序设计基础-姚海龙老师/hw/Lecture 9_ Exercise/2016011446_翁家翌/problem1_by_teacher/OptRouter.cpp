#include "OptRouter.h"

//trace back from target grid to source grid
void OptRouter::mazeBacktrace()
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

//maze routing
bool OptRouter::route(void)
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
