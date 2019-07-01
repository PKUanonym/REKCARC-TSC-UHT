#include "connection.h"
#include <QDataStream>
#include <QMutexLocker>
#include <QDebug>
#include <QFile>
#include <QThread>
#include <fstream>
#include <vector>
using namespace std;
int Connection::n = 0;

Connection::Connection(qintptr handle_, int ID, QObject *parent) : QThread(parent)
{
    handle = handle_;
    two = 0;
    id = ID;
}

void Connection::init()
{
    socket = new QTcpSocket(this);
    mutex = new QMutex;
    socket->setSocketDescriptor(handle);
    connect(socket, SIGNAL(readyRead()), this, SLOT(recv()));
    connect(socket, SIGNAL(disconnected()), this, SLOT(logout()));
    qDebug() << "init " << id;
}

void Connection::recv()
{
    /*QByteArray arr = socket->readAll();
    QDataStream in(arr);
    QString st;
    in >> st;
    qDebug() << "receive " << st;*/
    QMutexLocker locker(mutex);
    QDataStream info(socket);
    qint64 size, cur = 0;
    QString name;
    int ty;
    info >> ty >> size;
    qDebug() << "receive " << currentThreadId();
    qDebug() << tr("get %1 %2").arg(name).arg(size);
    QString savePath = QString::number(n)+".txt";
    n++;
    emit startReceive(savePath, id);
    QFile file(savePath);
    if (!file.open(QFile::WriteOnly))
    {
        qDebug() << "can not open";
    }
    while (cur < size)
    {
        socket->waitForReadyRead(150);
        QByteArray arr = socket->readAll();
        cur += arr.size();
        file.write(arr);
        emit refreshReceive(100.*cur/size, id);
    }
    file.close();
    emit endReceive(savePath, id);

    std::ifstream IF(savePath.toStdString());
    std::vector<double> a;
    int x;
    while (!IF.eof())
    {
        IF >> x;
        a.push_back(x);
    }
    double ans = 0;
    if (ty == 0)
    {
        ans = a[0];
        for (int i=1; i<a.size(); i++)
            ans = min(ans, a[i]);
    }
    else if (ty == 1)
    {
        ans = a[1];
        for (int i=1; i<a.size(); i++)
            ans = max(ans, a[i]);
    }
    else if (ty == 2)
    {
        for (int i=0; i<a.size(); i++)
            ans += a[i];
        ans/=a.size();
    }
    else if (ty == 3)
    {
        std::sort(a.begin(), a.end());
        int n=a.size();
        if (n&1)
            ans = a[n/2];
        else
            ans = (a[n/2-1] + a[n/2])/2;
    }
    send(QString::number(ans));
}

void Connection::send(QString text)
{
    QByteArray arr;
    QDataStream out(&arr,QIODevice::WriteOnly);
    out<<text;
    qDebug()<<"send : " << text;
    socket->write(arr);
}

void Connection::logout()
{
    qDebug() << myName << " logout";
}

