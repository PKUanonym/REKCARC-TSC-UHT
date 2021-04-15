#ifndef CREATECONNECTDIALOG_H
#define CREATECONNECTDIALOG_H

#include <QDialog>
#include <QtNetwork>
#include <QLabel>
#include <QMovie>

namespace Ui {
class CreateConnectDialog;
}

class CreateConnectDialog : public QDialog
{
    Q_OBJECT

public:
    explicit CreateConnectDialog(QWidget *parent = nullptr);
    ~CreateConnectDialog();

    QHostAddress getAddress();
    quint16 getPort();
    QTcpSocket * getReadWriteSocket();

public slots:

    void acceptConnection();

private:
    Ui::CreateConnectDialog *ui;

    QTcpServer * listenSocket = nullptr;
    QTcpSocket * readWriteSocket = nullptr;


    void accept();

    void ignore();
};

#endif // CREATECONNECTDIALOG_H
