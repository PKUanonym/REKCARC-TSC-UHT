#include "def.h"

int CAS, CAS2, CAS3;

bool eq(ld a, ld b) {return std::abs(a - b) < 1e-6;}

Point operator+(const Point&a, const Point&b) {return (Point) {a.x + b.x, a.y + b.y};}
Point operator-(const Point&a, const Point&b) {return (Point) {a.x - b.x, a.y - b.y};}
ld Point::len() {return sqrt(this->x * this->x + this->y * this->y);}

bool operator<(const Edge&a, const Edge&b) {return a.v < b.v;}
void Edge::print() {std::cout << "x = " << x + CAS2 << "\ty = " << y + CAS2 << "\tv = " << v << std::endl;}

namespace ufs
{
int father[50];
int get_father(int x) {return father[x] == x ? x : father[x] = get_father(father[x]);}
void init_ufs() {for (int i = 0; i <= 20; i++)father[i] = i;}
bool not_link(int x, int y) {return get_father(x) != get_father(y);}
void link(int x, int y) {father[get_father(x)] = get_father(y);}
}
