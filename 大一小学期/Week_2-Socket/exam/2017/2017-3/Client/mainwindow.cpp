#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    socket=new QUdpSocket;
    socket->bind(QHostAddress::LocalHost,9111);
    connect(socket,SIGNAL(readyRead()),this,SLOT(sendFile()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::sendFile()
{
    QByteArray arr;
    arr.resize(socket->pendingDatagramSize());
    socket->readDatagram(arr.data(),arr.size());
    QDataStream input(&arr,QIODevice::ReadOnly);
    QString addr,filename;
    int port;
    input>>addr>>port>>filename;
    ui->label->setText(addr+":"+QString::number(port)+" "+filename);
    Sender*sender=new Sender(addr,port,filename);
    connect(sender,SIGNAL(refreshProgressBar(int)),ui->progressBar,SLOT(setValue(int)));
    sender->start();
    connect(sender,SIGNAL(finished()),sender,SLOT(deleteLater()));//???
}

void MainWindow::on_pushButton_clicked()
{
    QFileDialog*fileDialog=new QFileDialog(this);
    fileDialog->setWindowTitle(tr("Open File"));
    fileDialog->setDirectory(".");
    if(fileDialog->exec() == QDialog::Accepted) {
        path = fileDialog->selectedFiles()[0];
    }
    else
        return;
    QByteArray arr;
    QDataStream input(&arr,QIODevice::WriteOnly);
    input<<path.split('/').back();
    qDebug()<<path;
    socket->writeDatagram(arr,QHostAddress::LocalHost,9111);
}
