#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "picture.h"
#include <QMainWindow>
#include <QPushButton>
#include <QLabel>
#include <QRadioButton>
#include <QDebug>
#include <QCheckBox>
#include <QTimer>
#include <QMediaPlayer>
#include "mydef.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    Ui::MainWindow *ui;
    QList<MyPoint> list;
    QList<MyPoint> hList[200];
    QList<Action> hActs[200];
    QPushButton * btn[6];//new, reset, start, pause, next, prev
    QCheckBox * cbtn;//isClean
    QLabel * lab;
    int time = 0, x, y, posX[7], posY[7], info[20][20], ID, endTime = 0;
    QList<int> IDs[200][20][20];
    bool runable = true, isRunning = true, cleanable = true, isClean = true, nClean[20][20], cleaning[20][20], reachable[20][20];
    int search(int x, int y);
    bool newInit();
    bool runByStep();
    bool clean();
    bool run();
    QFile file;
    Picture * p;
    void setTime(int t);
    QTimer tMove, tWash;
    QMediaPlayer* a[7];
signals:
    void stateChange();
private slots:
    void change(int, int);
    void wash();
    void washFinish();
    void on_pauseBtn_clicked();
    void switchState();
    void runableChange();
    void on_newBtn_clicked();
    void on_resetBtn_clicked();
    void on_nextBtn_clicked();
    void on_prevBtn_clicked();
    void on_cBtn_stateChanged(int arg1);
    void on_startBtn_clicked();
};

#endif // MAINWINDOW_H
