#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtNetwork/QTcpServer>
#include <QtNetwork/QTcpSocket>
#include <QtNetwork/QHostAddress>
#include <QtWidgets>
#include "creat.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

protected:
    void paintEvent(QPaintEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
public slots:
    void initServer(QString m_ip);
    void stopServer();
    void acceptConnection();
    void recvMessage();

private slots:
    void on_actionCreat_triggered();

    void on_actionOn_triggered();

    void on_actionOff_triggered();

private:
    void checktips();
    void cleartips();
    void restart();
    bool checkwin();
    int check();
    void send(int a,int x,int y);
    int lock,opened;//0=server 1=clilent
    Ui::MainWindow *ui;
    QTcpServer  *listenSocket;
    QTcpSocket  *readWriteSocket;
    QString now_ip;
    bool tips;
    int board[16][16];//0=empty,1=black,2=white,3=bomb
    int s[16];
};

#endif // MAINWINDOW_H
