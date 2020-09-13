#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtGui>
#include <QMainWindow>
#include <QTextEdit>
#include <QRandomGenerator>
#include <QPainterPath>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <qmath.h>
#include "server.h"
#include "client.h"
#include "ftl.h"
#include "basewidget.h"
#include "desktop.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    Ui::MainWindow *ui;

private slots:
    void on_pushButton_clicked();
    void routine_run();

private:
    float ver;
    Desktop *desktop;//调整分辨率问题
    BaseWidget *baseWidget;
    bool m_draging;//是否拖动
    QPoint m_startPostion;//拖动前鼠标位置
    QPoint m_framPostion;//窗体的原始位置
    void paintEvent(QPaintEvent *event);
    void mousePressEvent(QMouseEvent *event);//按下
    void mouseMoveEvent(QMouseEvent *event);//移动
    void mouseReleaseEvent(QMouseEvent *event);//抬起
    void post(QString msg);
    server *s;
    client *c;
    QMediaPlaylist playlist;
    QMediaPlaylist playlist1;
    QMediaPlaylist playlist2;
    QMediaPlaylist playlist3;
    QMediaPlayer* player;
    GameStatus* gamestatus;
    QTimer* routine=NULL;
};
#endif // MAINWINDOW_H
