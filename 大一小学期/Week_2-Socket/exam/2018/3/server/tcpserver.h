#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>
#include <connection.h>
#include <QThread>


class MainWindow;

class TcpServer : public QTcpServer
{
public:
    TcpServer(QObject *parent = nullptr);
protected:
    void incomingConnection(qintptr handle);

private:
    QThread* thread[1000];
    int threadCnt;
    Connection *con[1000];
    MainWindow* pr;

};

#endif // TCPSERVER_H
