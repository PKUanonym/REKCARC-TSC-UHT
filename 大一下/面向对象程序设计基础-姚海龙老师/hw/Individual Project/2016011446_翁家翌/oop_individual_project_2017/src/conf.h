#ifndef __CONF_H__
#define __CONF_H__

#include <ctime>
#include <cmath>
#include <cstdio>
#include <string>
#include <vector>
#include <cstring>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <algorithm>

typedef double ld;

struct Simple_Point
{
    ld x, y;
    Simple_Point(ld _x = 0.0, ld _y = 0.0): x(_x), y(_y) {}
    bool operator<(const Simple_Point &ths)const
    {
        return x < ths.x || x == ths.x && y < ths.y;
    }
    Simple_Point operator-(const Simple_Point &ths)const
    {
        return Simple_Point(x - ths.x, y - ths.y);
    }
    ld operator&(const Simple_Point &ths)const
    {
        return x * ths.y - y * ths.x;
    }
    ld operator|(const Simple_Point &ths)const
    {
        return x * ths.x + y * ths.y;
    }
    friend ld Check(const Simple_Point &a, const Simple_Point &b, const Simple_Point &c)
    {
        return (b - a) & (c - a);
    }
    friend ld Get_distance(const Simple_Point &ths_a, const Simple_Point &ths_b)
    {
        return sqrt((ths_a.x - ths_b.x) * (ths_a.x - ths_b.x) + (ths_a.y - ths_b.y) * (ths_a.y - ths_b.y));
    }
    friend bool Cross(const Simple_Point &a, const Simple_Point &b, const Simple_Point &c, const Simple_Point &d)
    {
        return Check(a, c, d) * Check(b, c, d) < 0 && Check(c, a, b) * Check(d, a, b) < 0;
    }
};

class Edge
{
public:
    int x, y;
    ld v;
    Edge(int _x, int _y, const std::vector<Simple_Point> &raw_data): x(std::min(_x, _y)), y(std::max(_x, _y))
    {
        v = Get_distance(raw_data[x], raw_data[y]);
    }
    bool operator<(const Edge &ths)const
    {
        return v < ths.v;
    }
    bool operator==(const Edge &ths)const
    {
        return x == ths.x && y == ths.y;
    }
};

//macro for recording time
#define TIME_BEGIN(message) std::cerr<<std::left<<std::setw(97)<<message<<" ... "; ld c0=clock();
#define TIME_END std::cerr<<"done!\tUse"<<std::right<<std::setw(10)<<std::fixed<<std::setprecision(3)<<(clock()-c0)/CLOCKS_PER_SEC*1000<<" ms"<<std::endl;

#endif

//
//struct/class: Aaaa_Aaaa
//function: Aaaa_aaaa
//constant/macro: AAAA_AAAA
//variable: aaaa_aaaa
//