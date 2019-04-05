#include "creat.h"
#include "ui_creat.h"

creat::creat(QString selc,bool op,QWidget *parent) :
    QDialog(parent),
    ui(new Ui::creat)
{
    now_ip = selc;
    opened = op;
    ui->setupUi(this);
    QHostInfo info = QHostInfo::fromName(QHostInfo::localHostName());
    qDebug()<<info.addresses().size();
    bool v4flag = false,v6flag = false;
    for(int i = 0;i < info.addresses().size();++i)
    {
        qDebug()<<info.addresses().at(i).toString();
        ui->comboBox->addItem(info.addresses().at(i).toString());
        if(info.addresses().at(i)==QHostAddress::LocalHost)
            v4flag = true;
        if(info.addresses().at(i)==QHostAddress::LocalHostIPv6)
            v6flag = true;
    }
    QHostAddress tmp;
    tmp = QHostAddress::LocalHost;
    if(!v4flag)
        ui->comboBox->addItem(tmp.toString());
    tmp = QHostAddress::LocalHostIPv6;
    if(!v6flag)
        ui->comboBox->addItem(tmp.toString());
    if(opened)
        ui->comboBox->setEnabled(false);
    for(int i = 0;i < ui->comboBox->count();++i)
        if(ui->comboBox->itemText(i) == selc)
            ui->comboBox->setCurrentIndex(i);
}

creat::~creat()
{
    delete ui;
}

void creat::on_pushButton_clicked()
{
    ui->comboBox->setDisabled(true);
    emit ok(ui->comboBox->currentText());
    close();
}

void creat::on_pushButton_2_clicked()
{
    ui->comboBox->setDisabled(false);
    emit sto();
    close();
}
