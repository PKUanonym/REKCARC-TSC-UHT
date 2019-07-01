#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QPainter>
#include <QtNetwork>
#include <QVector>
#include <QButtonGroup>
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

    void send(QString s1, QString s2, bool s3, int s4);

private slots:
    void on_pushButton_clicked();

private:
    Ui::Dialog *ui;
    QButtonGroup BG;
};

#endif // DIALOG_H
