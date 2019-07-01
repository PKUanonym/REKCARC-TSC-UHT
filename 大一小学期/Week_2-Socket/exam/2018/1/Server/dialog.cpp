#include "dialog.h"
#include "ui_dialog.h"
#include <QMouseEvent>
#include <QMessageBox>
Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    socket=new QUdpSocket;
    socket->bind(QHostAddress::LocalHost,5000);
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
    QString s1;
    QString s2;
    bool s3;
    int s4;
    in >> s1 >> s2 >> s3 >> s4;
    //qDebug()<<arr;
    qDebug() << s1 << " " << s2 << " " << s3 << " " << s4;
    if (mp.contains(s2))
    {
        QMessageBox::warning(this, "exist", "exist");
        return;
    }
    mp[s2]=1;
    QFile file("log.txt");
    file.open(QIODevice::WriteOnly|QIODevice::Append);
    QTextStream inn(&file);
    inn << s1 << "," << s2 << "," << QString(s3?"male":"female") << "," << s4 <<"\r\n";
    ui->textEdit->append(s1+","+s2+","+QString(s3?"male":"female")+","+QString::number(s4));
    file.close();
    //int a,bb,c;
    //in>>a>>bb>>c;
    //qDebug()<<a<<bb<<c;
    //x.append(a);
    //y.append(bb);
    //b.append(c);
}

void Dialog::paintEvent(QPaintEvent *)
{
    QPainter p(this);

}
