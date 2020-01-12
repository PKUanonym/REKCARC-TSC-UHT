#include "connection.h"
#include <QMutexLocker>

Connection::Connection(int ID, int t, QString path, QObject *parent) : QThread(parent)
{
    id = ID;
    ty = t;
    savePath = path;
    //connect(this, SIGNAL(endReceive(QString,int)), this, SLOT(deleteLater()));
}


void Connection::recv()
{
    QByteArray arr = socket->readAll();
    QDataStream in(arr);
    QString st;
    in >> st;
    qDebug() << "receive " << st;
    emit endReceive(st, id);
}

void Connection::send()
{
    /*
    QByteArray arr;
    QDataStream out(&arr,QIODevice::WriteOnly);
    out << st;
    socket->write(arr);
    qDebug() << "send" << st;*/
    QMutexLocker locker(mutex);
    qDebug() << "sendFile: " << QThread::currentThreadId() <<" " << id;
    QFile file(savePath);
    file.open(QFile::ReadOnly);
    QByteArray arr;
    QDataStream out(&arr, QIODevice::WriteOnly);
    qint64 size = file.size();
    QString name = savePath.split('/').back();
    emit startSend(name, id);
    out << ty << size;
    socket->write(arr);
    socket->waitForBytesWritten();
    msleep(100);

    for (int cur = 0; cur < size;)
    {
        QByteArray block = file.read(40960); //4096
        cur += block.size();
        socket->write(block);
        emit refreshSend(100.*cur/size, id);
        if (!socket->waitForBytesWritten(100))
            break;
        msleep(100);
    }
    file.close();
    emit endSend(savePath, id);
}

void Connection::logout()
{
    qDebug() << "begin logout";
    socket->disconnectFromHost();
}

void Connection::setName(QString name)
{
    savePath = name;
    qDebug() << "set name: " << name;
    fileNameMutex->unlock();
    qDebug() << "unlock";
}

void Connection::init()
{
    qDebug() << "init: " << id;
    socket = new QTcpSocket;
    connect(socket, SIGNAL(readyRead()), this, SLOT(recv()));
    socket->connectToHost(QHostAddress::LocalHost, 2018);
    socket->waitForBytesWritten(100);
    mutex = new QMutex;
    fileNameMutex = new QMutex;
    qDebug() << "connected!";
    //send("hi");
    send();
}
