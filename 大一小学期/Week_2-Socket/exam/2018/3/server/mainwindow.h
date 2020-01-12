#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "tcpserver.h"

namespace Ui {
class MainWindow;
}


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
public slots:
    void startSend(QString name, int id);
    void refreshSend(int rate, int id);
    void endSend(QString name, int id);

    void startReceive(QString name, int id);
    void refreshReceive(int rate, int id);
    void endReceive(QString name, int id);
private:
    Ui::MainWindow *ui;
    TcpServer *sv;
};

#endif // MAINWINDOW_H
