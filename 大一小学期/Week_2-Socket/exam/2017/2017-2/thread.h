#ifndef THREAD_H
#define THREAD_H

#include <QThread>
#include <QVector>
#include <QString>

typedef QVector<QString> veclist;

class Thread : public QThread
{
    QString*a;
    int len;
    veclist*ans;
    QString*ans2;
    int cas;
public:
    Thread(QString*_,int _l,veclist*_ans):
        a(_),len(_l),ans(_ans),cas(0){}
    void run();
};

#endif // THREAD_H
