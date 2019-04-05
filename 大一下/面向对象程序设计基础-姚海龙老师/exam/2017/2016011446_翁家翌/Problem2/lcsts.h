#ifndef __LCSTS_H__
#define __LCSTS_H__

#include <cstdio>
#include "lcst.h"
#include <ctime>

class LCSTS: public LCST<char>
{
public:
    enum pred {pred1, pred2};
    double lcs(char *X, char *Y, pred p)
    {
        int len_x = strlen(X), len_y = strlen(Y);
        char *newx = new char[len_x + 1];
        char *newy = new char[len_y + 1];
        for(int i = 0; i < len_x; ++i)
            if(p == pred1)
            {
                if(X[i] == 'T'||X[i]=='A')
                    newx[i] = '0';
                else if(X[i] == 'C'||X[i]=='G')
                    newx[i] == '1';
            }
            else
            {
                newx[i] = X[i];
            }
        for(int i = 0; i < len_y; ++i)
            if(p == pred1)
            {
                if(Y[i] == 'T'||Y[i]=='A')
                    newy[i] = '0';
                else if(Y[i] == 'C'||Y[i]=='G')
                    newy[i] == '1';
            }
            else
            {
                newy[i] = Y[i];
            }
        double c0=clock();
        LCST<char>::lcs(newx, newy, len_x, len_y, X, Y);
        return (clock()-c0)/CLOCKS_PER_SEC;
    }
};

#endif