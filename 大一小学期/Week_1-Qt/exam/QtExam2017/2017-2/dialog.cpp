#include "dialog.h"
#include "ui_dialog.h"
#include <QSignalMapper>
#include <QKeyEvent>
#include <QDebug>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    QSignalMapper*m=new QSignalMapper(this);
    sum=now=0;sig=1;
    number=new QPushButton*[10];
    for(int i=0;i<10;++i)
    {
        number[i]=new QPushButton(tr("%1").arg(i));
        connect(number[i],SIGNAL(clicked(bool)),m,SLOT(map()));
        m->setMapping(number[i],i);
    }
    connect(m,SIGNAL(mapped(int)),this,SLOT(addnum(int)));
    for(int i=0;i<9;++i)
        ui->gridLayout->addWidget(number[i+1],i/3,i%3,1,1);
    ui->gridLayout->addWidget(number[0],3,1,1,1);
    ui->textEdit->setDisabled(true);
    getans();
}

void Dialog::addnum(int x)
{
    now=now*10+x;
    ui->textEdit->setText(tr("%1").arg(now));
}

void Dialog::keyPressEvent(QKeyEvent *e)
{
    if(e->key()>=Qt::Key_0&&e->key()<=Qt::Key_9)
    {
        now=now*10+e->key()-Qt::Key_0;
        qDebug()<<e->key()-Qt::Key_0<<" "<<now;
        ui->textEdit->setText(tr("%1").arg(now));
    }
    else if(e->key()==Qt::Key_Plus)
        plus();
    else if(e->key()==Qt::Key_Minus)
        minus();
    else if(e->key()==Qt::Key_Equal)
        getans();
    else if(e->key()==Qt::Key_Q)
        close();
}

void Dialog::plus()
{
    sum=sum+sig*now;
    now=0;sig=1;
}

void Dialog::minus()
{
    sum=sum+sig*now;
    now=0;sig=-1;
}

void Dialog::getans()
{
    plus();
    ui->textEdit->setText(tr("%1").arg(sum));
    sum=0;
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::on_pushButton_4_clicked()
{
    close();
}

void Dialog::on_pushButton_clicked()
{
    plus();
}

void Dialog::on_pushButton_2_clicked()
{
    minus();
}

void Dialog::on_pushButton_3_clicked()
{
    getans();
}
