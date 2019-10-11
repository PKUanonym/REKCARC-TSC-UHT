#include "resultdialog.h"
#include "ui_resultdialog.h"

ResultDialog::ResultDialog(QString res, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ResultDialog)
{
    ui->setupUi(this);
    ui->label->setText(res);
}

ResultDialog::~ResultDialog()
{
    delete ui;
}
