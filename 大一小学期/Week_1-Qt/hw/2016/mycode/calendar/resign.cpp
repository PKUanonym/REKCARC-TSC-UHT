#include "resign.h"
#include "ui_resign.h"

resign::resign(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::resign)
{
    ui->setupUi(this);
}

resign::~resign()
{
    delete ui;
}

void resign::on_buttonBox_accepted()
{
    emit res(ui->lineEdit->text(),ui->lineEdit_2->text());
}
