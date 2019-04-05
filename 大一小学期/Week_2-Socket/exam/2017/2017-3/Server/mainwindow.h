#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtNetwork>
#include "download.h"
#include <QLabel>
#include <QProgressBar>
#include <QTextBrowser>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    int port;
    QUdpSocket*socket;
    QTextBrowser *text;
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    Ui::MainWindow *ui;
    Download*download;
public slots:
    void sendRequest();
};

#endif // MAINWINDOW_H
