#ifndef SUDOKU_H
#define SUDOKU_H

#include "grid.h"

#define _SIZE 81

class sudoku
{
public:
    grid **num;
    int dif;
    int cert;
    int uncert;
    sudoku *product;
public:
    sudoku();
    sudoku(int dif);

    int solve();
    bool rowValid(int , int, grid**);
    bool colValid(int, int, grid**);
    bool valid(int, int, int, grid**);
    void attempt(grid);
    bool sValid();
    bool sxValid(int, int);

    void produce(int dif);

    ~sudoku();
};

#endif // SUDOKU_H
