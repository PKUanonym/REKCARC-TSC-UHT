#include "createconnectdialog.h"
#include "ui_createconnectdialog.h"

CreateConnectDialog::CreateConnectDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::CreateConnectDialog)
{
    ui->setupUi(this);
    QMovie* m = new QMovie(":/pic/Resourse/Loading.gif");
    m->setScaledSize(ui->loading->size());
    ui->loading->setMovie(m);
    Qt::WindowFlags flags = Qt::Dialog;
    flags |= Qt::WindowCloseButtonHint;
    setWindowFlags(flags);

    //loading->resize(m.width(), p.height());
}

CreateConnectDialog::~CreateConnectDialog()
{
    delete ui;
    if(listenSocket){
        listenSocket->close();
    }
}

QHostAddress CreateConnectDialog::getAddress()
{
    return QHostAddress(ui->lineEdit->text());
}

quint16 CreateConnectDialog::getPort()
{
    return ui->lineEdit_2->text().toUShort();
}

QTcpSocket *CreateConnectDialog::getReadWriteSocket()
{
    return readWriteSocket;
}

void CreateConnectDialog::acceptConnection()
{
    readWriteSocket = listenSocket->nextPendingConnection();
    listenSocket->close();
    return QDialog::accept();
}

void CreateConnectDialog::accept()
{
    qDebug() << "accept";
    if(listenSocket == nullptr){
        listenSocket =new QTcpServer;
    }
    listenSocket->listen(QHostAddress::Any,getPort());
    ui->lineEdit->setVisible(false);
    ui->lineEdit_2->setVisible(false);
    ui->label->setVisible(false);
    ui->label_2->setVisible(false);
    ui->loading->show();
    ui->loading->movie()->start();
    QObject::connect(listenSocket,SIGNAL(newConnection()),this,SLOT(acceptConnection()));
}
