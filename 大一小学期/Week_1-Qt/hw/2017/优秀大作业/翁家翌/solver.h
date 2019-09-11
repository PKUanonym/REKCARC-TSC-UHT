#ifndef SOLVER_H
#define SOLVER_H

#include <QObject>
#include "config.h"

class Solver : public QObject
{
    Q_OBJECT
public:
    explicit Solver(QObject *parent = 0);
public:
    Mat a,showtime;int idx[1024];
private:
    int s0[9],s1[9],s2[9],ans,tot,limit,cnt;
    Trip swp,p[100],q[100];Mat tmp_m,zero;
    void dfs(int t);
    int only1sol(int m,int symm);
    int generate(int symm);
public slots:
    int calc(int x);
    int solve(Mat _,int lim=2);
    int generate_range(int l,int r,int symm=0);
signals:

};

#endif // SOLVER_H
