#ifndef SENDER_H
#define SENDER_H

#include <QThread>
#include <QString>
#include <QtNetwork>

class Sender : public QThread
{
    QString addr,filename;
    int port;
public:
    Sender(QString _,int __,QString ___):addr(_),port(__),filename(___){}
    void run();
};

#endif // SENDER_H
