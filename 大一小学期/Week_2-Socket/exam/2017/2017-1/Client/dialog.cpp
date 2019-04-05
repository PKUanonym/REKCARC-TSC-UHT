#include "dialog.h"
#include "ui_dialog.h"
#include <QMouseEvent>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    socket=new QUdpSocket;
    pressed=0;
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::send(int x,int y,int b)
{
    QByteArray arr;
    QDataStream out(&arr,QIODevice::WriteOnly);
    out<<x<<y<<b;
    qDebug()<<arr;
    socket->writeDatagram(arr,QHostAddress::LocalHost,5000);
    //s.waitForReadyRead(1000);
}

void Dialog::mousePressEvent(QMouseEvent *e)
{
    b.append(1);
    x.append(e->pos().x());
    y.append(e->pos().y());
    pressed=1;
    send(e->pos().x(),e->pos().y(),1);
}

void Dialog::mouseMoveEvent(QMouseEvent *e)
{
    if(pressed==0)
        return;
    b.append(0);
    x.append(e->pos().x());
    y.append(e->pos().y());
    update();
    send(e->pos().x(),e->pos().y(),0);
}

void Dialog::mouseReleaseEvent(QMouseEvent *e)
{
    pressed=0;
    b.append(0);
    x.append(e->pos().x());
    y.append(e->pos().y());
    update();
    send(e->pos().x(),e->pos().y(),0);
}

void Dialog::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    int len=b.size();
    for(int i=0;i<len;++i)
        if(b[i]==0)
            p.drawLine(x[i-1],y[i-1],x[i],y[i]);
}
