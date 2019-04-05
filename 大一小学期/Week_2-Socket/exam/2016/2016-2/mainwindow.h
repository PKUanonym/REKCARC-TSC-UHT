#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "thread.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    Ui::MainWindow *ui;
    int *a,n,cnt;
    Thread*t1,*t2,*t3,*t4,*t5,*t6,*t7;
    void start();
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_pushButton_clicked();
    void end();
    void end2();
    void end3();
};

#endif // MAINWINDOW_H
