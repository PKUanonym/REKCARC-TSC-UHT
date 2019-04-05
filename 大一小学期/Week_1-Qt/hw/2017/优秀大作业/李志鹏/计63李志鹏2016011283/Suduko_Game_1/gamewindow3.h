#ifndef GAMEWINDOW3_H
#define GAMEWINDOW3_H

#include <QDialog>
#include <QLCDNumber>
#include <QTimer>
#include <QTime>
#include <QStack>
#include <QLabel>
#include <QKeyEvent>
#include "grid.h"
#include "sudoku.h"
#include "operation.h"

namespace Ui {
class GameWindow3;
}

class GameWindow3 : public QDialog
{
    Q_OBJECT

private:
    bool isStart;

    bool flag[81];

    sudoku *sudo;

    sudoku *copy;

    QStack<operation> ope;

    QStack<operation> resumeOpe;

    bool temp;

    bool mark[9][9];

    bool keyboard;

    bool sound;

public:
    QPushButton ***game;

    QLabel ***labels;

    QPushButton **options;

    QTimer *timer;

    QTime *time;

    bool diy;

private slots:
    void timerUpdate();

    void on_pushButton_2_clicked();

    void alter(int);

    void alter_t(int);

    void on_pushButton_6_clicked();

    void on_pushButton_clicked();

    void replay();

    void on_pushButton_3_clicked();

    void on_pushButton_4_clicked();

    void on_pushButton_5_clicked();

    void on_pushButton_8_clicked();

    void on_pushButton_9_clicked();

    void on_pushButton_10_clicked();

    void deleteAll();

    void on_pushButton_11_clicked();

public:
    explicit GameWindow3(int x, QWidget *parent = 0);
    ~GameWindow3();

    void on_pushButton_7_clicked();

    void keyPressEvent(QKeyEvent *e);

private:
    Ui::GameWindow3 *ui;

public:
    void load(grid **);

private:
    void resetColor();
};

#endif // GAMEWINDOW3_H
