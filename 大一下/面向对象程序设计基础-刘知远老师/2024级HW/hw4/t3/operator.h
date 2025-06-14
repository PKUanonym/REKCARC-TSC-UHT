#include <iostream>
using std::string;
using std::cin;
using std::cout;
using std::endl;

#define fori0n(i, n) for (long long i = 0; i < (n); ++i)
#define forimn(i, m, n) for (long long i = (m); i < (n); ++i)
#define forinm(i, n, m) for (long long i = (n); i > (m); --i)
#define assertxy(x, y) if (!(x)) {exit(y);}

void increment(int &x)
{
    x++;
}

void decrement(int &x)
{
    x--;
}

void doublew(int &x)
{
    x *= 2;
}

void neg(int &x)
{
    x *= -1;
}

void halve(int &x)
{
    x /= 2;
}

void guard(int &x)
{
    // x;
}
