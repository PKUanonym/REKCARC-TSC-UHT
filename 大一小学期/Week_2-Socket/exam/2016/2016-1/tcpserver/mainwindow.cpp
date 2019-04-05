#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QPainter>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    sv.listen(QHostAddress::LocalHost,6565);
    connect(&sv,SIGNAL(newConnection()),this,SLOT(acceptConnection()));
}

void MainWindow::acceptConnection()
{
    qDebug()<<"connect";
    s=sv.nextPendingConnection();
    connect(s,SIGNAL(readyRead()),this,SLOT(drawcir()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::drawcir()
{
    qDebug()<<"draw";
    QByteArray arr=s->readAll();
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
