#ifndef SOLVER_H
#define SOLVER_H

#include <QObject>
#include <QString>
#include "config.h"

class Solver : public QObject
{
    Q_OBJECT
    struct D{
        int pos,a[12];
        int H(){
            register int sum=0;
            for(register int i=0;i<3;i++)
                for(register int j=0;j<3;j++)
                    if(a[i<<2|j])
                        sum+=qAbs(i-loc[a[i<<2|j]][0])+qAbs(j-loc[a[i<<2|j]][1]);
            return sum;
        }
    }s;
    int dfs(int x,int las);
    int bound,flag;
public:
    Mat a;
    explicit Solver(QObject *parent = 0);
public slots:
    void generate(int cnt);
    int solve(Mat _);
signals:

};

#endif // SOLVER_H
