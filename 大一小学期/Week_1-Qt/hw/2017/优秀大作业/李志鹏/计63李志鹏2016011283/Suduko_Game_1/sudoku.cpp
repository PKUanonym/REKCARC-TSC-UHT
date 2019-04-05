#include "sudoku.h"
#include <fstream>
#include <iostream>
#include <ctime>
#include <QDebug>

sudoku::sudoku()
{
    num=new grid*[9];
    for(int i=0; i<9; i++)
        num[i]=new grid[9];
}

sudoku::sudoku(int d)
{
    dif=d;
    num=new grid*[9];
    for(int i=0; i<9; i++)
        num[i]=new grid[9];
}

sudoku::~sudoku()
{

}

int sudoku::solve()
{
    int tempc=0;
    do
    {
        tempc=cert;
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(!num[i][j].isCert)
                {
                    for(int k=1; k<10; k++)
                    {
                        if(rowValid(k, i, num)&&colValid(k, j, num)&&valid(k, i, j, num))
                        {
                            num[i][j].isCert=true;
                            num[i][j].val=k;
                            cert++;
                            uncert--;
                            if(solve()==0)
                            {
                                num[i][j].isCert=false;
                                num[i][j].val=0;
                                cert--;
                                uncert++;
                                continue;
                            }
                        }
                    }
                    if(!num[i][j].isCert)
                        return 0;
                }
    }while(tempc<cert);
}

bool sudoku::rowValid(int index, int row, grid** a)
{
    for(int i=0; i<9; i++)
        if(a[row][i].val==index)
        {
            return false;
        }
    return true;
}

bool sudoku::colValid(int index, int col, grid** a)
{
    for(int i=0; i<9; i++)
        if(a[i][col].val==index)
        {
            return false;
        }
    return true;
}

bool sudoku::valid(int index, int row, int col, grid** a)
{
    int tempr=row-row%3;
    int tempc=col-col%3;
    for(int i=tempr; i<tempr+3; i++)
        for(int j=tempc; j<tempc+3; j++)
            if(a[i][j].val==index)
            {
                return false;
            }
    return true;
}


void sudoku::produce(int dif)
{
    product=new sudoku;
    srand(time(NULL));
    do
    {
        for(int i=0; i<9; i++)
        {
            for(int j=0; j<9; j++)
                product->num[i][j].val=0;
            int tt=rand()%9;
            product->num[i][tt]=i+1;
        }
    }while(!product->solve());
    int _temp=0;
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(product->num[i][j].val!=0)
            {
                product->num[i][j].isCert=1;
                _temp++;
            }
    product->cert=_temp;
    product->uncert=_SIZE-_temp;
    int t=0;
    if(dif==4)
        t=81-(24+rand()%9);
    else if(dif==3)
        t=81-(30+rand()%9);
    else if(dif==2)
        t=81-(36+rand()%9);
    else if(dif==1)
        t=81-(42+rand()%9);
    for(int i=0; i<t;)
    {
        int tempx=rand()%81;
        int tempy=tempx%9;
        tempx/=9;
        if(product->num[tempx][tempy].val!=0)
        {
            product->num[tempx][tempy].val=0;
            i++;
        }
    }
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            num[i][j].val=product->num[i][j].val;
            if(product->num[i][j].val!=0)
            {
                product->num[i][j].isCert=true;
                num[i][j].isCert=product->num[i][j].isCert;
                num[i][j].posb[0]=num[i][j].val;
            }
        }
}

bool sudoku::sValid()
{
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            for(int h=0; h<9; h++)
                if(num[i][h].val==num[i][j].val&&h!=j)
                {
                    return false;
                }
            for(int h=0; h<9; h++)
                if(num[h][j].val==num[i][j].val&&h!=i)
                {
                    return false;
                }
            int tempr=i-i%3;
            int tempc=j-j%3;
            for(int h=tempr; h<tempr+3; h++)
                for(int p=tempc; p<tempc+3; p++)
                    if(num[h][p].val==num[i][j].val&&(i!=h||j!=p))
                    {
                        return false;
                    }

        }
    return 1;
}

bool sudoku::sxValid(int i, int j)
{
    for(int h=0; h<9; h++)
        if(num[i][h].val==num[i][j].val&&h!=j)
        {

            return false;
        }
    for(int h=0; h<9; h++)
        if(num[h][j].val==num[i][j].val&&h!=i)
        {

            return false;
        }
    int tempr=i-i%3;
    int tempc=j-j%3;
    for(int h=tempr; h<tempr+3; h++)
        for(int p=tempc; p<tempc+3; p++)
            if(num[h][p].val==num[i][j].val&&(i!=h||j!=p))
            {

                return false;
            }
    return true;
}
