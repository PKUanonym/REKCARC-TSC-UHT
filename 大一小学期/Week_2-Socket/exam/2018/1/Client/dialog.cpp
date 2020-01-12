#include "dialog.h"
#include "ui_dialog.h"
#include <QMouseEvent>
#include <QButtonGroup>
#include <QMessageBox>
Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    BG.addButton(ui->radioButton);
    BG.addButton(ui->radioButton_2);
    socket = new QUdpSocket;
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::send(QString s1, QString s2, bool s3, int s4)
{
    QByteArray arr;
    QDataStream out(&arr,QIODevice::WriteOnly);
    out<<s1<<s2<<s3<<s4;
    //qDebug()<<arr;
    qDebug() << s1 << " " << s2 << " " << s3 << " " << s4;
    socket->writeDatagram(arr,QHostAddress::LocalHost,5000);
}


void Dialog::on_pushButton_clicked()
{
    QString name = ui->lineEdit->text();
    QString num = ui->lineEdit_2->text();
    if (num.length()!=10)
    {
        QMessageBox::warning(this, "no", "no");
        return;
    }
    for (int i=0; i<10; i++)
        if (num[i]<'0' || num[i]>'9')
        {
                QMessageBox::warning(this, "no", "no");
                return;
        }
    bool nan = (BG.checkedButton() == ui->radioButton);
    int fen = ui->spinBox->value();
    send(name, num, nan, fen);
}
