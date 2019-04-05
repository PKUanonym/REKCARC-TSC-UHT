#ifndef TTHREAD_H
#define TTHREAD_H

#include <QThread>
#include <QVector>
#include <QString>

typedef QVector<QString> veclist_;

class TThread : public QThread
{
    veclist_*a1,*a2,*a3,*a4,*a5,*ans;
public:
    TThread(veclist_*_a1,veclist_*_a2,veclist_*_a3,veclist_*_a4,veclist_*_a5,veclist_*_ans):
        a1(_a1),a2(_a2),a3(_a3),a4(_a4),a5(_a5),ans(_ans){}
    void run();
};

#endif // THREAD_H
