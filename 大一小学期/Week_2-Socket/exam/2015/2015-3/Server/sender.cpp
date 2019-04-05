#include "sender.h"
#include <QFile>

void Sender::run()
{
    QFile file(filename);
    file.open(QFile::ReadOnly);
    QTcpSocket socket;
    socket.connectToHost(QHostAddress(addr),port);
    QByteArray arr;
    QDataStream output(&arr,QIODevice::WriteOnly);
    qint64 size=file.size();
    output<<size<<filename.split('/').back();
    socket.write(arr);
    socket.waitForBytesWritten();
    for(int cur=0;cur<size;)
    {
        QByteArray block=file.read(4096);
        cur+=block.size();
        socket.write(block);
        if(!socket.waitForBytesWritten(100))
            break;
        msleep(100);//....
    }
    file.close();
}
