#ifndef __DEF_H__
#define __DEF_H__

#include <bits/stdc++.h>
typedef double ld;

const int MAX_POINT = 20;
const int MAXK = 20;

extern int CAS; //0: detail; 1: simple;
extern int CAS2; //0: oi method; 1: enter the point; 2: n=20;
extern int CAS3; //the top $(CAS3) MST

bool eq(ld a, ld b);

struct Point {
	ld x, y;
	ld len();
};
Point operator+(const Point&a, const Point&b);
Point operator-(const Point&a, const Point&b);

struct Edge {
	int x, y;
	double v;
	void print();
};
bool operator<(const Edge&a, const Edge&b);

namespace ufs
{
extern int father[MAX_POINT + 10];
int get_father(int x);
void init_ufs();
bool not_link(int x, int y);
void link(int x, int y);
}

#endif //__DEF_H__
