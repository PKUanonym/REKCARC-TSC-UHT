#include "dialog.h"
#include "ui_dialog.h"
#include <QDebug>
#include <QFile>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    sv=new QTcpServer;
    sv->listen(QHostAddress::LocalHost,8888);
    connect(sv,SIGNAL(newConnection()),this,SLOT(acceptConnection()));
}

void Dialog::acceptConnection()
{
    sk=sv->nextPendingConnection();
    connect(sk,SIGNAL(readyRead()),this,SLOT(recvMessage()));
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::recvMessage()
{
    QString input=sk->readAll();
    if(input[0]!='G'||input[1]!='E'||input[2]!='T')
        return;
    QString path="../";
    for(int i=5;input[i]!=' ';++i)
        path.append(input[i]);
    QFile file(path);
    qDebug()<<file.open(QIODevice::ReadOnly);
    QString text = file.readAll();
    QByteArray array;
    array.append(tr("HTTP/1.1 200 OK\nContent-Type: text/html;charset=utf-8\nContent-Length: %1\n\n%2").arg(text.size()).arg(text));
    sk->write(array);
}
