#include "OptRouter.h"

//trace back from target grid to source grid
void OptRouter::mazeBacktrace()
{
	std::list<int> que;
	que.push_back(m_targetIndex);
	dir_cost[m_targetIndex][0] =
	    dir_cost[m_targetIndex][1] =
	        dir_cost[m_targetIndex][2] =
	            dir_cost[m_targetIndex][3] = 0;
	while (que.size())
	{
		int index = que.front();
		int curCost = m_grids[index];
		que.pop_front();
		int x, y, dir;
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
					for (int k = 0; k < 4; ++k)
					{
						if (dir_cost[newIndex][k] > dir_cost[index][i] + (k != i))
						{
							dir_cost[newIndex][k] = dir_cost[index][i] + (k != i);
							que.push_back(newIndex);
						}
					}
				}
			}
		}
	}
	int x, y;
	compXYIndex(m_sourceIndex, x, y);
	printf("Distance = %d\n", m_grids[m_targetIndex]);
	auto find_min_dir = [&](int index)-> int
	{
		int t = 0;
		for (int k = 1; k < 4; ++k)
			if (dir_cost[index][k] < dir_cost[index][t])
				t = k;
		return t;
	};
	printf("Minimum turns = %d\n", dir_cost[m_sourceIndex][find_min_dir(m_sourceIndex)]);
	while (compIndex(x, y) != m_targetIndex)
	{
		printf("[%d,%d]->", x, y);
		int dir = find_min_dir(compIndex(x, y));
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
