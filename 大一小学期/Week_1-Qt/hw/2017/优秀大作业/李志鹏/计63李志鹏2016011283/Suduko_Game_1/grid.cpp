#include "grid.h"
#include <QDebug>

grid::grid()
    :isCert(false), val(0)
{
    posb=new int[10];
    for(int i=0; i<10; i++)
        posb[i]=0;
}

grid::grid(int x)
    :isCert(true), val(x)
{
    posb=new int[10];
    for(int i=0; i<10; i++)
        posb[i]=0;
}

grid::~grid()
{

}

grid::grid(int *t)
    :isCert(false), val(0)
{
    posb=new int[10];
    for(int i=0; i<10; i++)
        posb[i]=t[i];
}

int grid::pos()
{
    int temp=0;
    for(int i=0; i<9; i++)
        if(posb[i]!=0)
            temp++;
    if(temp==0)
        return -1;
    else if(temp==1)
        return 0;
    else
        return 1;
}

QString grid::getStr()
{
    int tt=0;
    for(int i=0; i<9; i++)
        if(posb[i]!=0)
            tt++;
    if(tt==1)
    {
        for(int i=0; i<9; i++)
            if(posb[i]!=0)
                return str=QString::number(posb[i]);
    }
    str='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==1)
        {
            str='1';
            break;
        }
    str+='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==2)
        {
            str+=QString::number(2);
            break;
        }
    str+='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==3)
        {
            str+=QString::number(3);
            break;
        }
    str+='\n';
    for(int i=0; i<9; i++)
        if(posb[i]==4)
        {
            str+=QString::number(4);
            break;
        }
    str+='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==5)
        {
            str+=QString::number(5);
            break;
        }
    str+='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==6)
        {
            str+=QString::number(6);
            break;
        }
    str+='\n';
    for(int i=0; i<9; i++)
        if(posb[i]==7)
        {
            str+=QString::number(7);
            break;
        }
    str+='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==8)
        {
            str+=QString::number(8);
            break;
        }
    str+='  ';
    for(int i=0; i<9; i++)
        if(posb[i]==9)
        {
            str+=QString::number(9);
            break;
        }
    return str;
}
