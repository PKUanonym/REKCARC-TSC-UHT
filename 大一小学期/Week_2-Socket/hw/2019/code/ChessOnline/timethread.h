#ifndef TIMETHREAD_H
#define TIMETHREAD_H

#include <QThread>

class TimeThread : public QThread
{
    Q_OBJECT
private:
    int time;
protected:
    void run();

signals:
    void timeChanged(int);
    void timeOut();

public slots:
    void resetTime();
public:
    TimeThread(QObject *parent=0);
    ~TimeThread();
};

#endif // TIMETHREAD_H
