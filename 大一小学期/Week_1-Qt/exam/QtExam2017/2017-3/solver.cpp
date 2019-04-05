#include "solver.h"
#include <QDebug>

Solver::Solver(QObject *parent) : QObject(parent)
{
    srand(time(0));
}

#define ins(x0,y0,dir) {\
    s.pos=np=(x0)<<2|(y0),s.a[op]=s.a[np],s.a[np]=0,tmp=dfs(x+1,dir);\
    if(flag)return tmp;if(nxt>tmp)nxt=tmp;s.a[np]=s.a[op],s.a[op]=0;\
}

int Solver::dfs(register int x,register int las){
    register int hv=s.H();
    if(x+hv>bound)return x+hv;
    if(hv==0)return flag=1,x;
    register int op=s.pos,zx=op>>2,zy=op&3,nxt=127,tmp,np;
    if(zy>0&&las!=3)ins(zx,zy-1,2);
    if(zx<2&&las!=0)ins(zx+1,zy,1);
    if(zx>0&&las!=1)ins(zx-1,zy,0);
    if(zy<2&&las!=2)ins(zx,zy+1,3);
    return s.pos=op,nxt;
}

void Solver::generate(int cnt)
{
    a.init("12345678.");
    int x=2,y=2;
    for(;cnt--;)
    {
        int dir=rand()%4;
        if(dir==0&&x>0)
        {
            a.m[x][y]=a.m[x-1][y];
            a.m[x-1][y]=0;
            x--;
        }
        else if(dir==1&&x<2)
        {
            a.m[x][y]=a.m[x+1][y];
            a.m[x+1][y]=0;
            x++;
        }
        else if(dir==2&&y>0)
        {
            a.m[x][y]=a.m[x][y-1];
            a.m[x][y-1]=0;
            y--;
        }
        else if(dir==3&&y<2)
        {
            a.m[x][y]=a.m[x][y+1];
            a.m[x][y+1]=0;
            y++;
        }
        //a.print();
    }
}

int Solver::solve(Mat _){
    a=_;
    for(int i=0;i<3;i++)
    for(int j=0;j<3;j++)
    s.a[i<<2|j]=a.m[i][j],s.a[i<<2|j]==0?s.pos=i<<2|j:1;
    for(bound=s.H();!flag;bound=dfs(0,-1));
    for(int i=0;i<3;++i)
        for(int j=0;j<3;++j)
            a.m[i][j]=s.a[i<<2|j];
    return bound;
}
