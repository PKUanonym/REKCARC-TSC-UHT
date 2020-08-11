#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPixmap>
#include <QPainter>
#include <QPaintEvent>
#include <QMouseEvent>
#include <QLabel>
#include <QMediaPlayer>
#include <QImage>
#include <QTimer>

const int n = 10;
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
    int ID = 0;
    QImage img[4];
    QString jpg[4], wav[4];
    QTimer t;
    QMediaPlayer plays[4][n];
    int pos[4] = {0,0,0,0};
    void play();
private slots:
    void changeID(int id = -1);
    //void paintEvent(QPaintEvent *event);
    void on_b1_clicked();
    void on_b2_clicked();
    void on_b3_clicked();
    void on_b4_clicked();
};

#endif // MAINWINDOW_H
