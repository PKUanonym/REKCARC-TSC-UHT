#ifndef CONNECTDIALOG_H
#define CONNECTDIALOG_H

#include <QDialog>
#include <QtNetwork>
#include <QLabel>
#include <QMovie>

namespace Ui {
class ConnectDialog;
}

class ConnectDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ConnectDialog(QWidget *parent = nullptr);
    ~ConnectDialog();


    QHostAddress getAddress();
    quint16 getPort();
    QTcpSocket * getReadWriteSocket();

public slots:

    void acceptConnection();

private:
    Ui::ConnectDialog *ui;
    //QLabel* loading;
    bool hasConnected = false;

    QTcpSocket * readWriteSocket = nullptr;

    bool ipOk();

    void accept();
};

#endif // CONNECTDIALOG_H
