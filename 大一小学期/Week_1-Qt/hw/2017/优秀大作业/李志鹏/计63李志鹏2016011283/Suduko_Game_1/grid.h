#ifndef GRID_H
#define GRID_H
#include <QString>

class grid
{
public:
    bool isCert;
    int val;
    int *posb;
    QString str;
public:
    grid();
    grid(int);
    grid(int *);

    int pos();
    QString getStr();

    ~grid();
};

#endif // GRID_H
