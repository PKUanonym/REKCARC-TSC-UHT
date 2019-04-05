#include "dialog.h"
#include "ui_dialog.h"
#include <QDebug>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    ui->pushButton_2->setDisabled(true);
    ui->progressBar->setRange(0,1500);
    stat=0;sec=0;tot=0;
    ui->progressBar->setValue(sec);
    ui->label->setText(tr("You have finished %1 tomatoes.").arg(tot));
    startTimer(1000);
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::timerEvent(QTimerEvent *)
{
    if(stat==0)
    {
        qDebug()<<"stop";
        return;
    }
    sec++;
    qDebug()<<sec;
    if(sec>=1500)tot+=sec/1500,sec%=1500;
    setclock();
}

void Dialog::setclock()
{
    if(stat==0)return;
    ui->progressBar->setValue(sec);
    ui->label->setText(tr("You have finished %1 tomatoes.").arg(tot));
}

void Dialog::on_pushButton_clicked()
{
    stat=1;
    ui->pushButton->setDisabled(true);
    ui->pushButton_2->setDisabled(false);
}

void Dialog::on_pushButton_2_clicked()
{
    stat=0;
    ui->pushButton->setDisabled(false);
    ui->pushButton_2->setDisabled(true);
}

void Dialog::on_pushButton_3_clicked()
{
    sec=ui->lineEdit->text().toInt();
    ui->lineEdit->setText("");
}
