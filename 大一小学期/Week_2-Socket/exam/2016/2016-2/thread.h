#ifndef THREAD_H
#define THREAD_H

#include <QThread>
#include <QDebug>

class Thread : public QThread
{
    int *a,l,r,cas;
    void sort(int x,int y);
public:
    Thread(int*_a,int _l,int _r,int c):a(_a),l(_l),r(_r),cas(c){qDebug()<<l<<r;}
    void run(){sort(l,r);}
};

#endif // THREAD_H
