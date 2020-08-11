#include "promotedialog.h"
#include "ui_promotedialog.h"

PromoteDialog::PromoteDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::PromoteDialog)
{
    ui->setupUi(this);
    setWindowFlags(Qt::Dialog|Qt::WindowStaysOnTopHint|Qt::WindowTitleHint| Qt::CustomizeWindowHint);
}

PromoteDialog::~PromoteDialog()
{
    delete ui;
}

Piece PromoteDialog::getName()
{
    return Piece(ui->comboBox->currentIndex() + 1);
}
