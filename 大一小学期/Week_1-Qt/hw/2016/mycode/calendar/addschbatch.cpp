#include "addschbatch.h"
#include "ui_addschbatch.h"

addschbatch::addschbatch(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::addschbatch)
{
    ui->setupUi(this);
    connect(ui->buttonBox,SIGNAL(accepted()),this,SLOT(acc()));
    ui->fd->setCalendarPopup(1);
}

addschbatch::~addschbatch()
{
    delete ui;
}

void addschbatch::acc()
{
    schedule tmp;
    tmp.set_start_time(ui->st->time());
    tmp.set_end_time(ui->et->time());
    tmp.set_describe(ui->des->text());
    if(ui->cycsel->currentText()==tr("Day(s)"))
        emit batchadd(ui->fd->date(),tmp,ui->cycnum->value(),0,ui->tim->value());
    if(ui->cycsel->currentText()==tr("Month(s)"))
        emit batchadd(ui->fd->date(),tmp,ui->cycnum->value(),1,ui->tim->value());
    if(ui->cycsel->currentText()==tr("Year(s)"))
        emit batchadd(ui->fd->date(),tmp,ui->cycnum->value(),2,ui->tim->value());
}
void addschbatch::changeEvent(QEvent *e)
{
    QWidget::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}
