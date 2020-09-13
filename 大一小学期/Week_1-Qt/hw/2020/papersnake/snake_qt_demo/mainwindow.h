#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QRandomGenerator>
#include <QMessageBox>
#include <QTimer>
#include <QMap>
#include <QKeyEvent>
#include <QCloseEvent>
#include <QFileDialog>
#include <QtDebug>
#include <QToolBar>
#include <QPushButton>
#include <QPen>
#include <QPainter>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "snakelist.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    void init();
    QPoint randomPos();
    void keyPressEvent(QKeyEvent* key);
    void mouseMoveEvent(QMouseEvent *event);
    void mousePressEvent(QMouseEvent *event);
    void closeEvent(QCloseEvent * event);

protected:
    int dir=1,predir=1;
    int mousePress=0;
    SnakeNode *food=NULL;
    QPixmap* pix=NULL;
    QMap<int,SnakeNode*> barrier;
    SnakeNode *mouseBarrier=NULL;
    bool isChangable=true;
    int ms = 300;
    int time = 0;
    int score = 0;
    bool foodMove = false;
    Ui::MainWindow *ui=NULL;
    SnakeList *snake=NULL;
    QTimer* timer=NULL;
    bool readyToStart=false;

private slots:
    void timeout();
    void on_actionPlay_triggered();

    void on_pushButtonPlay_clicked();

    void on_actionStop_triggered();

    void on_actionContinue_triggered();

    void on_actionRestart_triggered();

    void on_actionSave_triggered();

    void on_actionLoad_triggered();

    void on_actionQuit_triggered();

    void on_pushButtonLine_clicked();

    void on_pushButtonStop_clicked();

    void on_pushButtonContinue_clicked();

    void on_pushButtonRestart_clicked();

    void on_pushButtonSave_clicked();

    void on_pushButtonLoad_clicked();

    void on_pushButtonQuit_clicked();

    void on_horizontalSlider_valueChanged(int value);

    void on_checkBox_stateChanged(int arg1);

    void on_actionHelp_triggered();

    void on_actionAbout_triggered();

private:


};

#endif // MAINWINDOW_H
