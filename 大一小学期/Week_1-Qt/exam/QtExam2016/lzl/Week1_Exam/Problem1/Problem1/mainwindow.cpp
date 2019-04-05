#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QDebug>
#include <QTimer>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    cnt = 0;
    rest = 0;
    now = 0;
    QString Snum = QString::number(cnt);
    ui->label->setText("You have finished "+Snum+" tomatoes");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_2_clicked()
{
    QString s = ui->lineEdit->text();
    int num = s.toInt();
    if (num > 0)
    {
        rest = num;
        QMessageBox::information(this, "Success", "Set success!", QMessageBox::Ok);
        qDebug()<<num<<endl;
    }
}

void MainWindow::on_pushButton_clicked()
{
    if (rest > 0)
    {
        QTimer::singleShot(1000, this, SLOT(procceed()));
    }
}

void MainWindow::procceed()
{
    ++now;
    ui->progressBar->setValue(now*100/rest);
    ui->progressBar->show();
    if (now == rest)
    {
        now = 0;
        ++cnt;
        ui->label->setText("You have finished "+QString::number(cnt)+" tomatoes");
        ui->label->show();
    }
    else
    {
        on_pushButton_clicked();
    }
}

void MainWindow::on_pushButton_3_clicked()
{
    ui->progressBar->setValue(0);
    ui->progressBar->show();
    now = 0;
}
