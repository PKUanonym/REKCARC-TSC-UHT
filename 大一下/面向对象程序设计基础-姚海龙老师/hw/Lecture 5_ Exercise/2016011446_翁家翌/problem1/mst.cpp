#include "mst.h"

/**
 * [MST::computeMST description]
 * @Author   n+e
 * @DateTime 2017-03-25
 * using kruskal to calculate
 */
void MST::computeMST()
{
	using namespace ufs;
	init_ufs();
	for (int i = 0, x, y; i < total_edge; ++i)
		if (not_link(edge[i].x, edge[i].y))
			link(edge[i].x, edge[i].y), flag[i] = 1;
}
/**
 * [SOLVER::checkins description]
 * @Author   n+e
 * @DateTime 2017-03-25
 * @param    v          sum of the new graph to add into the priority_queue
 * @return              whether the prioruty_queue has(0) or hasn't(1) this value
 */
bool SOLVER::checkins(Graph&G, int k)
{
	if (hash[k].empty())
		return 1;
//	std::list<Graph>::iterator i = std::find(hash[k].begin(), hash[k].end(), G);
	for (std::list<Graph>::iterator i = hash[k].begin(); i != hash[k].end(); ++i)
		if ((*i) == G)
			return 0;
	return 1;
}
/**
 * [SOLVER::pop description]
 * @Author   n+e
 * @DateTime 2017-03-25
 * delete the queue.top() and this graph in the list
 */
void SOLVER::pop(int k)
{
	for (std::list<Graph>::iterator i = hash[k].begin(); i != hash[k].end(); ++i)
		if ((*i) == queue[k].top())
		{
			hash[k].erase(i);
			break;
		}
	queue[k].pop();
}

/**
 * [SOLVER::push description]
 * @Author   n+e
 * @DateTime 2017-03-25
 * insert Graph G into the priority_queue and list
 */
void SOLVER::push(MST&G, int k, int cas)
{
	if (cas || checkins(G, k))
	{
		queue[k].push(G);
		hash[k].push_back(G);
		while (queue[k].size() > CAS3)
			pop(k);
	}
}
/**
 * [SOLVER::Generate_New_Graph description]
 * @Author   n+e
 * @DateTime 2017-03-25
 * @param    G          original graph
 * generate new graph after delete an edge of G
 */
void SOLVER::Generate_New_Graph(MST G, int next_key)
{
	using namespace ufs;
	push(G, next_key);
	for (int i = 0; i < total_edge; i++)
		if (G.flag[i] == 1)
		{
			//delete edge[i]
			G.flag[i] = -1;
			init_ufs();
			for (int j = 0; j < total_edge; j++)
				if (G.flag[j] == 1)
					link(edge[j].x, edge[j].y);
			//list all new trees
			for (int j = 0; j < total_edge; j++)
				if (G.flag[j] == 0 && edge[j].v >= edge[i].v
				        && not_link(edge[j].x, edge[j].y))
				{
					MST New_G = G;
					New_G.flag[j] = 1;
					New_G.flag[i] = 0;
					New_G.sum += edge[j].v - edge[i].v;
//					printf("new sum = %lf\n", New_G.sum);
					push(New_G, next_key);
				}
			G.flag[i] = 1;
		}
}
/**
 * [SOLVER::Iterate description]
 * @Author   n+e
 * @DateTime 2017-03-25
 * @param    G          MST
 * generate new graph to $(CAS3) until the algorithm can't generate
 */
int SOLVER::Iterate(MST & G)
{
	int iterator = 0, x = 30;
	push(G, iterator, 1);
	for (ld lasttop = -1, nowtop = G.sum; x--; iterator ^= 1)
	{
		push(G, iterator ^ 1, 1);
		while (queue[iterator].size() > 0)
		{
			Generate_New_Graph(queue[iterator].top(), iterator ^ 1);
			pop(iterator);
		}
		lasttop = nowtop;
		nowtop = queue[iterator ^ 1].top().sum;
	}
	return iterator;
	while (queue[iterator].size() > 0)
	{
		std::cout << queue[iterator].top().sum << std::endl;
		queue[iterator].pop();
	}
}
/**
 * [SOLVER::Extract_Ans description]
 * @Author   n+e
 * @DateTime 2017-03-28
 * @return   the list of answer
 */
Graph* SOLVER::Extract_Ans(int k)
{
	int tot = CAS3;
	Graph *Arr = new Graph[50];
	while (queue[k].size() > CAS3)
		pop(k);
	while (queue[k].size() > 0)
	{
		Arr[tot] = queue[k].top();
		pop(k);
		if (Arr[tot--].Check_Legal() != 1)
		{
			std::cout << "k is not illegal.";
			exit(0);
		}
	}
	if (tot > 0)
	{
		std::cout << "k is not illegal.";
		exit(0);
	}
	return Arr;
}
