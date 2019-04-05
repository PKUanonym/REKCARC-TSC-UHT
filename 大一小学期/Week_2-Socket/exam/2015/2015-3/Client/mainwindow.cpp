#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    port=3489;
    for(int i=0;i<5;++i)
    {
        getBar(i)->setValue(0);
        download[i]=new Download(++port,this);
        connect(download[i],SIGNAL(refreshFileName(QString)),getLabel(i),SLOT(setText(QString)));
        connect(download[i],SIGNAL(refreshProgressBar(int)),getBar(i),SLOT(setValue(int)));
        connect(download[i],&QThread::finished,[this,i](){this->getLabel(i)->setText("Complete!");});
    }
    connect(ui->pushButton,SIGNAL(clicked(bool)),this,SLOT(sendRequest()));
}

void MainWindow::sendRequest()
{
    if(ui->lineEdit->text().isEmpty())
        return;
    bool flag=false;
    for(int i=0;i<5;++i)
        if(download[i]->avaliable)
        {
            flag=true;
            download[i]->avaliable=false;
            download[i]->filename=ui->lineEdit->text();
            download[i]->port=++port;
            download[i]->start();
            break;
        }
    if(flag==false)
        QMessageBox::warning(this,"提示","已达到最大并发数");
}

MainWindow::~MainWindow()
{
    delete ui;
}

QLabel* MainWindow::getLabel(int i)
{
    switch(i)
    {
    case 0:return ui->label;
    case 1:return ui->label_2;
    case 2:return ui->label_3;
    case 3:return ui->label_4;
    case 4:return ui->label_5;
    default:return Q_NULLPTR;
    }
}

QProgressBar* MainWindow::getBar(int i)
{
    switch(i)
    {
    case 0:return ui->progressBar;
    case 1:return ui->progressBar_2;
    case 2:return ui->progressBar_3;
    case 3:return ui->progressBar_4;
    case 4:return ui->progressBar_5;
    default:return Q_NULLPTR;
    }
}
