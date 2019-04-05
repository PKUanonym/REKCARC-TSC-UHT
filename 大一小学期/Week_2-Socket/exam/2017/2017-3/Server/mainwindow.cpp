#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    port=9111;
    text=new QTextBrowser;
    setCentralWidget(text);
    download=new Download(port,this);
    socket=new QUdpSocket;
    socket->bind(QHostAddress::LocalHost,9111);
    connect(socket,SIGNAL(readyRead()),this,SLOT(sendRequest()));
}

void MainWindow::sendRequest()
{
    qDebug()<<"connect";
    QByteArray arr;
    arr.resize(socket->pendingDatagramSize());
    socket->readDatagram(arr.data(),arr.size());
    QDataStream input(&arr,QIODevice::ReadOnly);
    QString filename;
    int port;
    input>>filename;
    text->append(filename);
    download->avaliable=false;
    download->filename=filename;
    download->port=++port;
    download->start();
}

MainWindow::~MainWindow()
{
    delete ui;
}
