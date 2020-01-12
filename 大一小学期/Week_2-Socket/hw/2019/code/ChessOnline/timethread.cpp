#include "timethread.h"

void TimeThread::run()
{
    while(1){
        emit timeChanged(time);
        time--;
        sleep(1);
        if(time == 0){
            emit timeOut();
        }
    }
}

void TimeThread::resetTime()
{
    time = 60;
    emit timeChanged(time);
    time--;
}

TimeThread::TimeThread(QObject *parent):
    QThread(parent)
{
    time = 60;
}

TimeThread::~TimeThread()
{

}
