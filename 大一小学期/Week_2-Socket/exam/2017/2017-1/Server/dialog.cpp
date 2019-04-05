#include "dialog.h"
#include "ui_dialog.h"
#include <QMouseEvent>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    socket=new QUdpSocket;
    socket->bind(QHostAddress::LocalHost,5000);
    pressed=0;
    connect(socket,SIGNAL(readyRead()),this,SLOT(recv()));
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::recv()
{
    QByteArray arr;
    arr.resize(socket->pendingDatagramSize());
    socket->readDatagram(arr.data(),arr.size());
    QDataStream in(arr);
    int a,bb,c;
    in>>a>>bb>>c;
    qDebug()<<a<<bb<<c;
    x.append(a);
    y.append(bb);
    b.append(c);
    update();
}

void Dialog::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    int len=b.size();
    for(int i=0;i<len;++i)
        if(b[i]==0)
            p.drawLine(x[i-1],y[i-1],x[i],y[i]);
}
