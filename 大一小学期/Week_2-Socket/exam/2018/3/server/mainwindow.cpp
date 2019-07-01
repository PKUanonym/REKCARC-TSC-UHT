#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    sv = new TcpServer(this);
    sv->listen(QHostAddress::LocalHost, 2018);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::startSend(QString name, int id)
{
    ui->textBrowser->append(tr("%2: start send %1").arg(name).arg(id));
}

void MainWindow::refreshSend(int rate, int id)
{
    ui->textBrowser->append(tr("%2: sending %1").arg(rate).arg(id));
}

void MainWindow::endSend(QString name, int id)
{
    ui->textBrowser->append(tr("%2: end send %1").arg(name).arg(id));
}

void MainWindow::startReceive(QString name, int id)
{
    ui->textBrowser->append(tr("%2: start receive %1").arg(name).arg(id));
}

void MainWindow::refreshReceive(int rate, int id)
{
    ui->textBrowser->append(tr("%2: receiving %1").arg(rate).arg(id));
}

void MainWindow::endReceive(QString name, int id)
{
    ui->textBrowser->append(tr("%2: end receive %1").arg(name).arg(id));
}
