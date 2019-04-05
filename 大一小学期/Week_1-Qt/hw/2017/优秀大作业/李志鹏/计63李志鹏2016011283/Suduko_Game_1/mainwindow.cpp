#include "mainwindow.h"
#include "gamewindow.h"
#include "ui_mainwindow.h"

int difficulty=1;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setFixedSize(1500, 720);
    setWindowTitle("Sudoku Game");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    this->hide();
    temp=new GameWindow();
    temp->show();
    temp->exec();
    this->show();
}

void MainWindow::on_pushButton_2_clicked()
{
    this->close();
}

void MainWindow::on_pushButton_3_clicked()
{
    diy=new GameWindow3(0);
    this->hide();
    diy->on_pushButton_7_clicked();
    diy->show();
    diy->exec();
    this->show();
}
