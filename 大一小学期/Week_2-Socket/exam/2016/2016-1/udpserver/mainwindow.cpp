#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QPainter>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    s.bind(QHostAddress::LocalHost,6666);
    connect(&s,SIGNAL(readyRead()),this,SLOT(readData()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::readData()
{
    QByteArray arr;
    arr.resize(s.pendingDatagramSize());
    s.readDatagram(arr.data(),arr.size());
    QDataStream in(arr);
    in>>a>>b>>r;
    qDebug()<<a<<b<<r;
    update();
}

void MainWindow::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    p.setPen(Qt::red);
    p.setBrush(Qt::blue);
    p.drawEllipse(a-r,b-r,r+r,r+r);
}
