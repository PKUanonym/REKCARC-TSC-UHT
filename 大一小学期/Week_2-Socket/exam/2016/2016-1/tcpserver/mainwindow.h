#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtNetwork>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    QTcpServer sv;
    QTcpSocket* s;
    int a,b,r;
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
public slots:
    void acceptConnection();
    void drawcir();
    void paintEvent(QPaintEvent *);
private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
