#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSignalMapper>
#include <QTimer>
#include <QImage>
#include <QMediaPlayer>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void display(int p);
    void next();

private:
    Ui::MainWindow *ui;
    QSignalMapper *mapper;
    QTimer *timer;
    int now = 0;
};

#endif // MAINWINDOW_H
