#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    n=0;

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    path = QFileDialog::getOpenFileName(this);
    ui->textBrowser->append("file name : "+path);

}
void MainWindow::startSend(QString name, int id)
{
    //ui->pushButton->setDisabled(true);
    ui->textBrowser->append(tr("%2: start send %1").arg(name).arg(id));
}

void MainWindow::refreshSend(int rate, int id)
{
    ui->textBrowser->append(tr("%2: sending %1").arg(rate).arg(id));
}

void MainWindow::endSend(QString name, int id)
{
    //ui->pushButton->setEnabled(true);
    ui->textBrowser->append(tr("%2: end send %1").arg(name).arg(id));
}

void MainWindow::startReceive(QString name, int id)
{
    //ui->pushButton->setDisabled(true);
    ui->textBrowser->append(tr("%2: start receive %1").arg(name).arg(id));
}

void MainWindow::refreshReceive(int rate, int id)
{
    ui->textBrowser->append(tr("%2: receiving %1").arg(rate).arg(id));
}

void MainWindow::endReceive(QString name, int id)
{
    //ui->pushButton->setEnabled(true);
    ui->textBrowser->append(tr("%2: end receive %1").arg(name).arg(id));
}

void MainWindow::on_pushButton_2_clicked()
{
    ui->pushButton_2->setDisabled(true);
    solve(0);
}

void MainWindow::on_pushButton_3_clicked()
{
    ui->pushButton_3->setDisabled(true);
    solve(1);
}

void MainWindow::on_pushButton_4_clicked()
{
    ui->pushButton_4->setDisabled(true);
    solve(2);
}

void MainWindow::on_pushButton_5_clicked()
{
    ui->pushButton_5->setDisabled(true);
    solve(3);
}

void MainWindow::solve(int ty)
{
    ui->textEdit->clear();
    int i = n;
    th[i] = new QThread;
    con[i] = new Connection(n, ty, path);
    con[i]->moveToThread(th[i]);
    connect(th[i], SIGNAL(started()), con[i], SLOT(init()));
    connect(con[i], SIGNAL(startReceive(QString,int)), this, SLOT(startReceive(QString,int)));
    connect(con[i], SIGNAL(startSend(QString,int)), this, SLOT(startSend(QString,int)));
    connect(con[i], SIGNAL(refreshReceive(int,int)), this, SLOT(refreshReceive(int,int)));
    connect(con[i], SIGNAL(refreshSend(int,int)), this, SLOT(refreshSend(int,int)));
    //connect(con[i], SIGNAL(endReceive(QString,int)), this, SLOT(endReceive(QString,int)));
    connect(con[i], SIGNAL(endSend(QString,int)), this, SLOT(endSend(QString,int)));
    //connect(con[i], SIGNAL(endReceive(QString,int)), th[i], SLOT(deleteLater()));
    connect(con[i], &Connection::endReceive, this, [&](QString st, int id)
                                                    {
                                                        ui->textEdit->append(QString::number(id)+":"+st);
                                                        if (con[id]->ty == 0)
                                                            ui->pushButton_2->setEnabled(true);
                                                        else if (con[id]->ty == 1)
                                                            ui->pushButton_3->setEnabled(true);
                                                        else if (con[id]->ty == 2)
                                                            ui->pushButton_4->setEnabled(true);
                                                        else if (con[id]->ty == 3)
                                                            ui->pushButton_5->setEnabled(true);

                                                    });
    th[i]->start();
    n++;
}
