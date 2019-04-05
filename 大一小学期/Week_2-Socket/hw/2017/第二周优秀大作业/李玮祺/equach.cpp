#include "equach.h"
#include "ui_equach.h"

EquaCh::EquaCh(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::EquaCh)
{
    ui->setupUi(this);
}

EquaCh::~EquaCh()
{
    delete ui;
}
