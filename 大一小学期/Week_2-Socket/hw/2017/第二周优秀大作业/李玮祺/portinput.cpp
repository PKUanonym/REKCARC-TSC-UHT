#include "portinput.h"
#include "ui_portinput.h"

PortInput::PortInput(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::PortInput)
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
    ui->port2->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->lineEdit_4->setStyleSheet("background-color: rgba(0,0,0,0)");
    ui->lineEdit_4->setAlignment(Qt::AlignCenter);
    Port = 0;
    statue = false;
}

PortInput::~PortInput()
{
    delete ui;
}

void PortInput::on_connect_clicked()
{
    QString temp = (ui->lineEdit_4->text());
    bool t;
    Port = temp.toInt(&t, 10);
    statue = true;
    close();
}

void PortInput::on_cancel_clicked()
{
    Port = 0;
    statue = false;
    close();
}

int PortInput::getPort()
{
    return Port;
}

bool PortInput::getStatue()
{
    return statue;
}

