#include "connectdialog.h"
#include "ui_connectdialog.h"
#include <QMessageBox>
#include <regex>


ConnectDialog::ConnectDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ConnectDialog)
{
    ui->setupUi(this);
    QMovie* m = new QMovie(":/pic/Resourse/Loading.gif");
    m->setScaledSize(ui->loading->size());
    ui->loading->setMovie(m);
    Qt::WindowFlags flags = Qt::Dialog;
    flags |= Qt::WindowCloseButtonHint;
    setWindowFlags(flags);
}

ConnectDialog::~ConnectDialog()
{
    delete ui;
    if(!hasConnected){
        delete readWriteSocket;
    }
}

QHostAddress ConnectDialog::getAddress()
{
    return QHostAddress(ui->lineEdit->text());
}

quint16 ConnectDialog::getPort()
{
    return ui->lineEdit_2->text().toUShort();
}

QTcpSocket *ConnectDialog::getReadWriteSocket()
{
    return readWriteSocket;
}

bool ConnectDialog::ipOk()
{
    QString ip = ui->lineEdit->text();
    std::regex r("[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+");
    std::string s = ip.toStdString();
    if(std::regex_match(s, r)){
        return true;
    }
    else{
        return false;
    }
}


void ConnectDialog::acceptConnection(){
    hasConnected = true;
    return QDialog::accept();
}

void ConnectDialog::accept()
{
    //int a = 0;
    if(readWriteSocket == nullptr){
        if(!ipOk()){
            QMessageBox::warning(this, "error", "Your input is wrong!");
            return;
        }
        ui->lineEdit->setVisible(false);
        ui->lineEdit_2->setVisible(false);
        ui->label->setVisible(false);
        ui->label_2->setVisible(false);
        ui->loading->show();
        ui->loading->movie()->start();
        this->readWriteSocket = new QTcpSocket;
        QObject::connect(readWriteSocket,SIGNAL(connected()),this,SLOT(acceptConnection()));
        this->readWriteSocket->connectToHost(getAddress(),getPort());
    }
}

