#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    text=new QTextBrowser;
    setCentralWidget(text);
    socket=new QUdpSocket;
    socket->bind(QHostAddress::LocalHost,4000);
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
    text->append(addr+":"+QString::number(port)+" "+filename);
    Sender*sender=new Sender(addr,port,filename);
    sender->start();
    connect(sender,SIGNAL(finished()),sender,SLOT(deleteLater()));//???
}
