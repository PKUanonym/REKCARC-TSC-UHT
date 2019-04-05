#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QPainter>
#include <QtNetwork>
#include <QVector>

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    QUdpSocket *socket;
    QVector<int> x,y,b;
    int pressed;
public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
    void mousePressEvent(QMouseEvent *);
    void mouseMoveEvent(QMouseEvent *);
    void mouseReleaseEvent(QMouseEvent *);
    void send(int,int,int);
    void paintEvent(QPaintEvent *);
private:
    Ui::Dialog *ui;
};

#endif // DIALOG_H
