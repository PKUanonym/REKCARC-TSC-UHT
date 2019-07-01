#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QPainter>
#include <QtNetwork>
#include <QVector>
#include <QMap>
namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    QUdpSocket *socket;
public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
    void paintEvent(QPaintEvent *);
public slots:
    void recv();
private:
    Ui::Dialog *ui;
    QMap<QString,int> mp;
};

#endif // DIALOG_H
