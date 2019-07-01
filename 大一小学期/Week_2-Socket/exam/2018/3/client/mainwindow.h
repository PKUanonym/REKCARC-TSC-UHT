#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QThread>
#include "connection.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_pushButton_clicked();
    void startSend(QString name, int id);
    void refreshSend(int rate, int id);
    void endSend(QString name, int id);

    void startReceive(QString name, int id);
    void refreshReceive(int rate, int id);
    void endReceive(QString name, int id);
    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

    void on_pushButton_4_clicked();

    void on_pushButton_5_clicked();
    void solve(int ty);

signals:
    void send(QString path);
    void setName(QString path);

private:
    Ui::MainWindow *ui;
    QThread* th[1000];
    Connection* con[1000];
    QString path;
    int n;
};

#endif // MAINWINDOW_H
