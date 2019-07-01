#include "tcpserver.h"
#include "mainwindow.h"
#include <QDebug>

TcpServer::TcpServer(QObject *parent):
    QTcpServer(parent)
{
    threadCnt = 0;
    pr = qobject_cast<MainWindow*>(parent);
}

void TcpServer::incomingConnection(qintptr handle)
{
    int n=threadCnt;
    threadCnt++;
    con[n] = new Connection(handle, n);
    thread[n] = new QThread(this);
    con[n]->moveToThread(thread[n]);
    connect(thread[n], SIGNAL(started()), con[n], SLOT(init()));
    connect(con[n], SIGNAL(endReceive(QString,int)), pr, SLOT(endReceive(QString,int)));
    connect(con[n], SIGNAL(refreshReceive(int,int)), pr, SLOT(refreshReceive(int,int)));
    connect(con[n], SIGNAL(startReceive(QString,int)), pr, SLOT(startReceive(QString,int)));
    connect(con[n], SIGNAL(endSend(QString,int)), pr, SLOT(endSend(QString,int)));
    connect(con[n], SIGNAL(refreshSend(int,int)), pr, SLOT(refreshSend(int,int)));
    connect(con[n], SIGNAL(startSend(QString,int)), pr, SLOT(startSend(QString,int)));
    qDebug() << "new thread : " << n;
    thread[n]->start();/*
    if (threadCnt == 2)
    {
        con[0]->two = con[1]->two = 1;
        for (int i=0; i<threadCnt; i++)
            connect(con[i], SIGNAL(endReceive(QString,int)), con[i^1], SLOT(send(QString)));
    }*/

}
