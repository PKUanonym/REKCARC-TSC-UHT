#include "download.h"

void Download::run()
{
    QTcpServer server;
    QHostAddress addr=QHostAddress::LocalHost;
    server.listen(addr,port);
    QUdpSocket request;
    QByteArray arr;
    QDataStream input(&arr,QIODevice::WriteOnly);
    input<<addr.toString()<<port<<filename;
    request.writeDatagram(arr,addr,4000);
    request.waitForBytesWritten(100);
    server.waitForNewConnection(100);//??

    QTcpSocket *socket=server.nextPendingConnection();
    socket->waitForReadyRead(100);//???
    QDataStream info(socket);
    qint64 size,cur=0;
    QString name;
    info>>size>>name;
    emit refreshFileName(name);
    QFile file(name);
    file.open(QFile::WriteOnly);
    while(cur<size)
    {
        socket->waitForReadyRead(100);//???
        QByteArray arr=socket->readAll();
        cur+=arr.size();
        file.write(arr);
        emit refreshProgressBar(100.*cur/size);
    }
    file.close();
    avaliable=true;
    socket->close();
}
