#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QtNetwork>

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    Ui::Dialog *ui;
    QTcpServer *sv;
    QTcpSocket *sk;
public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();

private slots:
    void acceptConnection();
    void recvMessage();
};

#endif // DIALOG_H
