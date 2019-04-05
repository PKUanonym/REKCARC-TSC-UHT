#ifndef __MST_H__
#define __MST_H__

#include "conf.h"
#include "union_find_set.h"

class MST
{
    UFS ufs;
    std::vector<Edge>edge, mst;
public:
    //set the precision in output mst total weight
    static int MST_PRECISION;

    //Using Kruskal algorithm to calculate minimum spanning tree.
    MST(const std::vector<Edge> &_edge);

    //Saving minimum spanning tree's infomation into file $(filename).
    std::vector<Edge> Save(const std::string &filename);
};

class Prim
{
    std::vector<ld>dist;
    std::vector<int>left, right;
public:
    //Using Prim algorithm to calculate minimum spanning tree.
    Prim(std::vector<Simple_Point>data);
};

#endif
