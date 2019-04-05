#ifndef __VAL_H__
#define __VAL_H__

#include "conf.h"
#include "union_find_set.h"
#include "minimum_spanning_tree.h"

struct Point3
{
    ld x, y, z;
    Point3(ld _x = 0.0, ld _y = 0.0, ld _z = 0.0): x(_x), y(_y), z(_z) {}
    Point3(const Simple_Point &ths): x(ths.x), y(ths.y), z(ths.x * ths.x + ths.y * ths.y) {}
    bool operator<(const Point3 &ths)const
    {
        return x < ths.x || x == ths.x && y < ths.y;
    }
    Point3 operator-(const Point3 &ths)const
    {
        return Point3(x - ths.x, y - ths.y, z - ths.z);
    }
    ld operator|(const Point3 &ths)const
    {
        return x * ths.x + y * ths.y + z * ths.z;
    }
    Point3 operator&(const Point3 &ths)const
    {
        return Point3(y * ths.z - z * ths.y, z * ths.x - x * ths.z, x * ths.y - y * ths.x);
    }
    friend Point3 Check(const Point3 &a, const Point3 &b, const Point3 &c)
    {
        return (b - a) & (c - a);
    }
};

class My_Delaunay
{
    int total_edge;
    std::vector<int>last;
    std::vector<Simple_Point>points;
    std::vector<Point3>original_points;
    struct DCEL
    {
        int to, left, right;
        DCEL(int _to = 0, int _left = 0): to(_to), left(_left), right(0) {}
    };
    std::vector<DCEL>edge;

    //return if x is in circle made up of point a,b,c
    bool Is_in_circle(const Simple_Point &a, const Simple_Point &b, const Simple_Point &c, const Simple_Point &x);

    //link x and y and save into the DCEL
    void Add_edge(int x, int y);

    //remove edge[x] virtually
    void Delete_edge(int x);

    //Generating delaunay triangulation by divide and conquer algorithm.
    void Triangulation(int l, int r);
public:
    My_Delaunay(std::vector<Simple_Point>data);
};

#endif
