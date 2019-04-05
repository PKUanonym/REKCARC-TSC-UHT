#include "celledit.h"
#include "ui_celledit.h"
celledit::celledit(QDate nowd,dateinfo c,QWidget *parent) :
    now_date(nowd),
    QDialog(parent),
    ui(new Ui::celledit)
{
    info = c;
    ui->setupUi(this);
    for(int i = 0;i < info.get_sch_list().size();++i)
        ui->selc->addItem(info.get_sch_list()[i].describe());
    connect(this,SIGNAL(accepted()),this,SLOT(merge()));
    connect(ui->selc,SIGNAL(currentIndexChanged(int)),this,SLOT(selc_ch(int)));
    connect(this,SIGNAL(st_changed(QTime)),ui->st,SLOT(setTime(QTime)));
    connect(this,SIGNAL(et_changed(QTime)),ui->et,SLOT(setTime(QTime)));
    connect(this,SIGNAL(des_changed(QString)),ui->des,SLOT(setText(QString)));
    connect(ui->st,SIGNAL(editingFinished()),this,SLOT(ss()));
    connect(ui->et,SIGNAL(editingFinished()),this,SLOT(ss()));
    connect(ui->des,SIGNAL(editingFinished()),this,SLOT(ss()));
    connect(ui->ch_color,SIGNAL(clicked()),this,SLOT(cbkcolor()));
    connect(ui->ch_color2,SIGNAL(clicked()),this,SLOT(ctcolor()));
    connect(ui->da,SIGNAL(clicked()),this,SLOT(del_all()));
}

celledit::~celledit()
{
    delete ui;
}
void celledit::ss()
{
    qDebug("ss");
    schedule w;
    w.set_describe(ui->des->text());
    w.set_start_time(ui->st->time());
    w.set_end_time(ui->et->time());
    if(w.describe()=="")
    {
        if(ui->selc->currentText() != "")
        {
            info.del_sch(tmp);
            qDebug("Del");
        }
    }
    else
    if(ui->selc->currentText() == ""&&!(tmp == w))
    {
        info.add_sch(w);
        tmp = w;
        qDebug("Add");
    }
    else
    {
        info.del_sch(tmp);
        info.add_sch(w);
        qDebug("Change");
        tmp = w;
    }
    info.sort();
    disconnect(ui->selc,SIGNAL(currentIndexChanged(int)),this,SLOT(selc_ch(int)));
    ui->selc->clear();
    for(int i = 0;i < info.get_sch_list().count();++i)
        ui->selc->addItem(info.get_sch_list()[i].describe());
    ui->selc->update();
    qDebug("count = %d\n",info.get_sch_list().count());
    connect(ui->selc,SIGNAL(currentIndexChanged(int)),this,SLOT(selc_ch(int)));
}
void celledit::del_all()
{
    info.del_all();
    disconnect(ui->selc,SIGNAL(currentIndexChanged(int)),this,SLOT(selc_ch(int)));
    ui->selc->clear();
    for(int i = 0;i < info.get_sch_list().count();++i)
        ui->selc->addItem(info.get_sch_list()[i].describe());
    ui->selc->update();
    qDebug("count = %d\n",info.get_sch_list().count());
    connect(ui->selc,SIGNAL(currentIndexChanged(int)),this,SLOT(selc_ch(int)));
}
void celledit::selc_ch(int w)
{
    if(tmp == info.get_sch_list()[w])
        return;
    tmp = info.get_sch_list()[w];
    emit des_changed(info.get_sch_list()[w].describe());
    emit st_changed(info.get_sch_list()[w].start_time());
    emit et_changed(info.get_sch_list()[w].end_time());
}

void celledit::merge()
{
    int x=info.get_sch_list().count();
    qDebug("%d\n",x);
    emit changed(now_date,info);
}
void celledit::cbkcolor()
{
    QColor color = QColorDialog::getColor(info.get_back_ground(), this);
    //QString msg = QString("r:%1,g:%2,b:%3").arg(QString::number(color.red()),QString::number(color.green()),QString::number(color.blue()));
    //QMessageBox::information(NULL,"Selected color",msg);
    //color = QColor(msg);
    info.change_back_ground(color);
}
void celledit::ctcolor()
{
    QColor color = QColorDialog::getColor(info.get_text_color(), this);
    //QString msg = QString("r:%1,g:%2,b:%3").arg(QString::number(color.red()),QString::number(color.green()),QString::number(color.blue()));
    //QMessageBox::information(NULL,"Selected color",msg);
    //color = QColor(msg);
    info.change_text_color(color);
}
void celledit::changeEvent(QEvent *e)
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
