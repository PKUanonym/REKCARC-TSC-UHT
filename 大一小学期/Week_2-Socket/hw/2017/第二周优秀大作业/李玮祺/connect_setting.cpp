#include "connect_setting.h"
#include "ui_connect_setting.h"

Connect_setting::Connect_setting(QWidget *parent, QString localip, int localport) :
    QDialog(parent),
    ui(new Ui::Connect_setting)
{
    ui->setupUi(this);
    QPixmap tel("C:/Coding/chess/pic/ok.png");
    QPixmap ter("C:/Coding/chess/pic/fal.png");
    QPixmap bgg("C:/Coding/chess/pic/596.png");
    ui->labelT->setPixmap(tel);
    ui->labelF->setPixmap(ter);
    ui->bg->setPixmap(bgg);
    ui->labelT->setScaledContents(true);
    ui->labelF->setScaledContents(true);
    ui->bg->setScaledContents(true);

    ui->connect->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->cancel->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->labelT->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->labelF->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->port1->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->port2->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->ip1->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->ip2->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->lineEdit->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->lineEdit_2->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->lineEdit_3->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->lineEdit_4->setStyleSheet("background-color: rgba(0,0,0,0)");

    /*QPixmap myPix("C:/Coding/chess/pic/ui1.png");
    ui->label1->setPixmap(myPix);
    ui->label1->setScaledContents(true);
    ui->label1->show();*/

    IP = "";
    Port = 0;
    statue = false;
    ui->lineEdit->setText(localip);
    ui->lineEdit_2->setText(QString::number(localport));
    ui->lineEdit->setAlignment(Qt::AlignCenter);
    ui->lineEdit_2->setAlignment(Qt::AlignCenter);
    ui->lineEdit_3->setAlignment(Qt::AlignCenter);
    ui->lineEdit_4->setAlignment(Qt::AlignCenter);
}

void Connect_setting::on_connect_clicked()
{
    IP = ui->lineEdit_3->text();
    QString temp = (ui->lineEdit_4->text());
    bool t;
    Port = temp.toInt(&t, 10);
    statue = true;
    close();
}

void Connect_setting::on_cancel_clicked()
{
    IP = "";
    Port = 0;
    statue = false;
    close();
}

QString Connect_setting::getIp()
{
    return IP;
}

int Connect_setting::getPort()
{
    return Port;
}

bool Connect_setting::getStatue()
{
    return statue;
}

Connect_setting::~Connect_setting()
{
    delete ui;
}


