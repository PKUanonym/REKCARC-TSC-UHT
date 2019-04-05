#ifndef __GRAPH_H__
#define __GRAPH_H__

#include "def.h"

extern int total_node, total_edge;
extern int last[MAX_POINT + 10];
extern Point node[MAX_POINT + 10];
extern Edge edge[MAX_POINT * MAX_POINT / 2 + 10];

struct Graph
{
	int flag[MAX_POINT * MAX_POINT / 2 + 10]; // 0: not use; 1: use; -1: can't use;
	ld sum; // sum of the tree edges
	Graph() {sum = 0; memset(flag, 0, sizeof flag);}
	bool operator<(const Graph&t)const {return sum < t.sum;}
	bool operator==(const Graph&t)const
	{
		for (int i = 0; i < total_edge; i++)
			if (flag[i] != t.flag[i])
				return 0;
		return 1;
	}
	void Add_Point(const Point&a);
	void Add_Edge(int x, int y, ld v = 0);
	void Generate_Graph();
	int Check_Legal();
	void Print(int value);
//	void print_flag() {for (int i = 0; i < total_edge; ++i)printf("%d ", flag[i]); puts("");}
};

extern Graph kong;

#endif //__GRAPH_H__