#include "dialog.h"
#include "ui_dialog.h"
#include <QFileDialog>
#include <QMessageBox>
#include <QInputDialog>
#include <QDebug>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    ui->pushButton_3->setDisabled(true);
    timer=new QTimer;
    connect(timer,SIGNAL(timeout()),this,SLOT(repeat()));
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::on_pushButton_clicked()
{
    qDebug()<<"b1";
    QFileDialog*fileDialog=new QFileDialog(this);
    fileDialog->setWindowTitle(tr("Open Image"));
    fileDialog->setDirectory("../2015-1");
//    fileDialog->setFilter(QDir("../2015-1","*.jpg").filter());
    if(fileDialog->exec() == QDialog::Accepted) {
        QString path = fileDialog->selectedFiles()[0];
        qDebug()<<path;
        setimg(path);
        int flag=0;
        if(img.isEmpty()==0)
        for(int i=0;!flag&&i<img.size();++i)
            if(img[i]==path)
                flag=1;
        if(!flag)
            img.append(path);
        if(img.size()>1&&interval>0)
            ui->pushButton_3->setDisabled(false);
        return;
    }
    QMessageBox::information(NULL, tr("Path"), tr("You didn't select any files."));
}

void Dialog::setimg(QString path)
{
    qDebug()<<"add "<<path;
    QPixmap*pix=new QPixmap(path);
    ui->label->setPixmap(*pix);
}

void Dialog::on_pushButton_3_clicked()
{
    qDebug()<<"b3";
    temp=0;
    timer->stop();
    timer->start(interval);
    setimg(img[temp]);
}

void Dialog::repeat()
{
    temp=(temp+1)%img.size();
    setimg(img[temp]);
}

void Dialog::on_pushButton_2_clicked()
{
    qDebug()<<"b2";
    bool isOK;
    QString text = QInputDialog::getText(NULL, "Input Dialog", "Please input interval", QLineEdit::Normal, "", &isOK);
    if(!isOK||text.toInt()<=0)return;
    interval=text.toInt();
    if(img.size()>1&&interval>0)
        ui->pushButton_3->setDisabled(false);
    qDebug()<<interval;
}
