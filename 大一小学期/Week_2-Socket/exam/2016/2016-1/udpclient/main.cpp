#include <QCoreApplication>
#include <QtNetwork/QUdpSocket>
#include <QDebug>
#include <QRect>
#include <QDataStream>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    QUdpSocket s;
    int a,b,r;
    while(~scanf("%d%*c%d%*c%d",&a,&b,&r))
    {
        QByteArray arr;
        QDataStream out(&arr,QIODevice::WriteOnly);
        out<<a<<b<<r;
        qDebug()<<arr;
        s.writeDatagram(arr,QHostAddress::LocalHost,6666);
        //s.waitForReadyRead(1000);
    }
    return app.exec();
}

