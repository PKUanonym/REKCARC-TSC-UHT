#include "solver.h"
#define add(i,j,k,v) s0[i]^=v,s1[j]^=v,s2[k]^=v
Solver::Solver(QObject *parent) : QObject(parent)
{
    srand(time(0));limit=2;
    for(int i=0;i<1024;++i)idx[i]=0;
    for(int i=1;i<10;i++)idx[1<<i]=i;
}

int Solver::calc(int x){
    int f=0;
    while(x)f+=x&1,x>>=1;
    return f;
}

void Solver::dfs(int t){
    if(t==tot+1)
        ans++;
    else{
        int x=p[t].x,y=p[t].y,z=pos[x][y];
        for(int s3=s0[x]&s1[y]&s2[z],i;s3&&ans<limit;s3-=i)
            i=s3&-s3,add(x,y,z,i),a.m[x][y]=idx[i],dfs(t+1),add(x,y,z,i);
    }
}

int Solver::only1sol(int m,int symm)
{
    for(int i=1;i<=m;++i)
    {
        tmp_m.m[q[i].x][q[i].y]=0;
        if(symm)
            tmp_m.m[8-q[i].x][8-q[i].y]=0;
    }
    int res=solve(tmp_m)==1;
    for(int i=1;i<=81;++i)
        tmp_m.m[q[i].x][q[i].y]=q[i].v;
    return res;
}

int Solver::generate(int symm)
{
    solve(zero);
    cnt=0;
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
            q[++cnt]=(Trip){i,j,a.m[i][j]};
    if(symm)cnt=41;
    std::random_shuffle(q+1,q+1+cnt);
    tmp_m=a;int blank=0;
    for(int i=1,tmpa,tmpb;i<=cnt;++i)
    {
        tmpa=tmp_m.m[q[i].x][q[i].y];
        if(symm)tmpb=tmp_m.m[8-q[i].x][8-q[i].y];
        tmp_m.m[q[i].x][q[i].y]=0;
        if(symm)tmp_m.m[8-q[i].x][8-q[i].y]=0;
        if(solve(tmp_m)>1)
        {
            tmp_m.m[q[i].x][q[i].y]=tmpa;
            if(symm)tmp_m.m[8-q[i].x][8-q[i].y]=tmpb;
        }
        else blank++;
    }
    a=tmp_m;
    return blank;
}

int Solver::solve(Mat _,int lim){
    ans=tot=0;a=_;int flag=a.cnt0()==81;limit=lim;
    for(int i=1;i<10;i++)s0[i-1]=s1[i-1]=s2[i-1]=1022;
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++){
            if(a.m[i][j])add(i,j,pos[i][j],1<<a.m[i][j]);
            showtime.m[i][j]=0;
        }
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
            if(a.m[i][j]==0)p[++tot]=(Trip){i,j,calc(s0[i]&s1[j]&s2[pos[i][j]])};
    //if(flag)
    std::random_shuffle(p+1,p+1+tot);
    for(int i=1;i<=tot;i++){
        int x=p[i].v,k=i;
        for(int j=i+1;j<=tot;j++)if(p[j].v<x)x=p[j].v,k=j;
        swp=p[i],p[i]=p[k],p[k]=swp;showtime.m[p[i].x][p[i].y]=i;
        for(int j=i+1;j<=tot;j++)if(p[j].x==p[i].x||p[j].y==p[i].y||pos[p[j].x][p[j].y]==pos[p[i].x][p[i].y])p[j].v--;
    }
    if(limit==1&&0)
    {
        for(int i=1;i<=tot;++i)
            qDebug()<<i<<" "<<p[i].x<<" "<<p[i].y<<" "<<p[i].v;
    }
    if(flag)
        limit=30;
    dfs(1);
    if(flag)
        limit=2;
    return ans;
}

int Solver::generate_range(int l,int r,int symm)
{
    while(generate(symm),a.cnt0()<l);
    if(a.cnt0()>r)
    {
        tmp_m=a;solve(tmp_m,1);
        int target=rand()%(r-l+1)+l;
        for(int i=cnt;i>0&&tmp_m.cnt0()>target;--i)
        {
            tmp_m.m[q[i].x][q[i].y]=a.m[q[i].x][q[i].y];
            if(symm)
                tmp_m.m[8-q[i].x][8-q[i].y]=a.m[8-q[i].x][8-q[i].y];
        }
        a=tmp_m;
    }
    return a.cnt0();
}
