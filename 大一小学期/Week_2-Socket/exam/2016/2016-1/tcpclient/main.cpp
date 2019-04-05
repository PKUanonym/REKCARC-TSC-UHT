#include <QCoreApplication>
#include <QtNetwork>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    QTcpSocket s;
    s.connectToHost(QHostAddress::LocalHost,6565);
    int a,b,r;
    while(~scanf("%d%*c%d%*c%d",&a,&b,&r))
    {
        QByteArray arr;
        QDataStream out(&arr,QIODevice::WriteOnly);
        out<<a<<b<<r;
        qDebug()<<arr;
        s.write(arr);
        s.waitForReadyRead(1000);//scanf会阻塞线程
    }
    return app.exec();
}

