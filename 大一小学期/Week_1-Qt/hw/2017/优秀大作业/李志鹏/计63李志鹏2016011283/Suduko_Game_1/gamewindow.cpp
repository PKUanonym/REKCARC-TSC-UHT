#include "gamewindow.h"
#include "ui_gamewindow.h"

extern int difficulty;

GameWindow::GameWindow(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::GameWindow)
{
    ui->setupUi(this);
    setFixedSize(750, 300);
    setWindowTitle("Sudoku Game: Choose the Degree of Difficulty");
}

GameWindow::~GameWindow()
{
    delete ui;
}

void GameWindow::on_pushButton_2_clicked()
{
    this->hide();
    temp=new GameWindow3(1);
    temp->show();
    temp->exec();
}

void GameWindow::on_pushButton_3_clicked()
{
    this->hide();
    temp=new GameWindow3(2);
    temp->show();
    temp->exec();
}

void GameWindow::on_pushButton_4_clicked()
{
    this->hide();
    temp=new GameWindow3(3);
    temp->show();
    temp->exec();
}

void GameWindow::on_pushButton_5_clicked()
{
    this->hide();
    temp=new GameWindow3(4);
    temp->show();
    temp->exec();
}
