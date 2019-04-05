#include "graph.h"

int total_node, total_edge;
int last[50];
Point node[50];
Edge edge[210];

/**
 * [Graph::Add_Point description]
 * @Author   n+e
 * @DateTime 2017-03-21
 * @param    a          add the new point to the list
 */
void Graph::Add_Point(const Point&a)
{
	std::cout << "Point " << total_node + 1 << ": (" << a.x << ", " << a.y << ")" << std::endl;
	node[total_node] = a;
	last[total_node] = 0;
	total_node++;
}
/**
 * [Graph::Add_Edge description]
 * @Author   n+e
 * @DateTime 2017-03-21
 * @param    x,y        create an edge between x and y
 */
void Graph::Add_Edge(int x, int y, ld w)
{
	ld v;
	if (CAS2)
		v = (node[x] - node[y]).len();
	else
		v = w;
	edge[total_edge] = (Edge) {x, y, v};
	flag[total_edge] = 0;
	total_edge++;
}
/**
 * [Graph::Generate_Graph description]
 * @Author   n+e
 * @DateTime 2017-03-21
 * @create all these edges and sort
 */
void Graph::Generate_Graph()
{
	if (CAS2)
		for (int i = 0; i < total_node; ++i)
			for (int j = i + 1; j < total_node; j++)
				Add_Edge(i, j);
	std::sort(edge, edge + total_edge);
	//return;
	for (int i = 0; i < total_edge; ++i)
		std::cout << "NO " << i << "\t", edge[i].print();
}
/**
 * [Graph::print description]
 * @Author   n+e
 * @DateTime 2017-03-21
 * @param    value      print the kth minimum spanning tree
 */
void Graph::Print(int value)
{
	if (!CAS)
		std::cout << "The No." << value << " minimum spanning tree:" << std::endl;
	else
		std::cout << "No." << value << "\t";
	std::cout << "Check...";
	if (Check_Legal() != 1)
	{
		std::cout << "Illegal! " << Check_Legal() << std::endl;
		return;
	}
	else std::cout << "OK!   ";
	if (!CAS)
		std::cout << std::endl;
	sum = 0;
	for (int i = 0; i < total_edge; ++i)
		if (flag[i] > 0)
		{
			if (!CAS)
				edge[i].print();
			sum += edge[i].v;
		}
	std::cout << "Total: " << sum << std::endl;
	if (!CAS)
		std::cout << "-----------------------------------------" << std::endl;
}
/**
 * [Graph::Check_Legal description]
 * @Author   n+e
 * @DateTime 2017-03-24
 * @return   whether this graph is a tree
 */
#define cmin(a, b) (a > b ? a = b : a)
#define cmax(a, b) (a < b ? a = b : a)
int Graph::Check_Legal()
{
	using namespace ufs;
	int _min = 100, _max = 0;
	init_ufs();
	for (int i = 0; i < total_edge; ++i)
	{
		if (flag[i] == 1)
		{
			if (!not_link(edge[i].x, edge[i].y))
				return -1;
			link(edge[i].x, edge[i].y);
		}
		if (flag[i] == -1)
			return -2;
		cmin(_min, edge[i].x), cmax(_max, edge[i].x);
		cmin(_min, edge[i].y), cmax(_max, edge[i].y);
	}
	for (int i = _min; i < _max; ++i)
		if (not_link(_max, i))
			return 0;
	return 1;
}

Graph kong;