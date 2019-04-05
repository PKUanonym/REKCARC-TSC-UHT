#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QPushButton>
#include <QMainWindow>
#include <QTimer>
#include <QTime>
#include <QFrame>
#include <QGridLayout>
#include <QTableWidget>
#include <QVector>
#include <QMediaPlayer>
#include "solver.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
private:
    qint32 select_x,select_y;
    Mat m,prob;
    Solver sol;
    qint32 level,//0:custom, 1:random
           state,//0:empty, 1:start, 2:pause, 3:end
           history_temp,wrongstate;
    QVector<Mat> history;
    QVector<qint32>hx,hy;
    QMediaPlayer* player;
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
private:
    Ui::MainWindow *ui;
    QPushButton ***button;
protected:
    void keyPressEvent(QKeyEvent *);
    void newgame();
    void pause();
    void continuegame();
    void refreshsxy(int add);
    void loadprob(int clear);
    void showinfo();
    void redo();
    void undo();
    void finish();
    void addnumber(int);
    int checkavailable();
    void deletegrid();
private slots:
    void on_button_clicked();
    void on_actionInfo_triggered();
    void on_actionReset_triggered();
    void on_actionPause_triggered();
    void on_actionUndo_triggered();
    void on_actionRedo_triggered();
    void on_actionMusic_triggered();
    void on_actionRandom_5_triggered();
    void on_actionCustom_triggered();
    void on_actionNew_Game_triggered();
};

#endif // MAINWINDOW_H
