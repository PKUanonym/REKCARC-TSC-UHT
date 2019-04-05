#ifndef CLIENTWINDOW_H
#define CLIENTWINDOW_H

#include <QMainWindow>
#include <QtNetwork>
#include "conn.h"
namespace Ui {
class clientWindow;
}

class clientWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit clientWindow(QWidget *parent = 0);
    ~clientWindow();

    void connectHost();

public slots:
    void recvMessage();
    void setip(QString);
protected:
    void paintEvent(QPaintEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
private slots:
    void on_actionConnect_triggered();

    void on_actionOn_triggered();

    void on_actionOff_triggered();

private:
    int check();
    void checktips();
    void cleartips();
    void restart();
    void send(int x,int y);
    int lock;//0=server 1=clilent
    bool tips;
    Ui::clientWindow *ui;
    QTcpSocket *readWriteSocket;
    int board[16][16];//0=empty,1=black,2=white,3=bomb
    int s[16];
    bool checkwin();
};

#endif // CLIENTWINDOW_H
