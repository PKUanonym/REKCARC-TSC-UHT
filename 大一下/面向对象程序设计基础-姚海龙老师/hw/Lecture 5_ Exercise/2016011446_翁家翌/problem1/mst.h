#ifndef __MST_H__
#define __MST_H__

#include "graph.h"

class MST: public Graph
{
public:
	void computeMST();
};

class SOLVER
{
	std::priority_queue<MST>queue[2];
	std::list<Graph>hash[2];
	bool checkins(Graph&G, int k);
	void push(MST&G, int k, int cas = 0);
	void pop(int k);
	void Generate_New_Graph(MST G, int next_key);
public:
	SOLVER() {hash[0].push_back(kong); hash[1].push_back(kong);}
	int Iterate(MST&G);
	Graph* Extract_Ans(int k);
};

#endif //__MST_H__