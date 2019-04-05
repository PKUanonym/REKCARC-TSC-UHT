#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTextBrowser>
#include <QtNetwork>
#include "sender.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    QTextBrowser*text;
    QUdpSocket*socket;
    QString path;
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    Ui::MainWindow *ui;
public slots:
    void sendFile();
private slots:
    void on_pushButton_clicked();
};

#endif // MAINWINDOW_H
