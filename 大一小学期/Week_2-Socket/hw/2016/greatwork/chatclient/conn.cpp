#include "conn.h"
#include "ui_conn.h"

conn::conn(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::conn),
    mapper(new QSignalMapper(this))
{
    ui->setupUi(this);
    connect(ui->pushButton_0,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_0,"0");
    connect(ui->pushButton_1,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_1,"1");
    connect(ui->pushButton_2,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_2,"2");
    connect(ui->pushButton_3,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_3,"3");
    connect(ui->pushButton_4,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_4,"4");
    connect(ui->pushButton_5,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_5,"5");
    connect(ui->pushButton_6,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_6,"6");
    connect(ui->pushButton_7,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_7,"7");
    connect(ui->pushButton_8,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_8,"8");
    connect(ui->pushButton_9,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_9,"9");
    connect(ui->pushButton_dot,SIGNAL(clicked(bool)),mapper,SLOT(map()));
    mapper->setMapping(ui->pushButton_dot,".");
    connect(mapper,SIGNAL(mapped(QString)),this,SLOT(add(QString)));
}

conn::~conn()
{
    delete ui;
}

void conn::add(QString x)
{
    ui->lineEdit->setText(ui->lineEdit->text()+x);
}


void conn::on_pushButton_del_clicked()
{
    ui->lineEdit->setText(ui->lineEdit->text().left(ui->lineEdit->text().length()-1));
}

void conn::on_pushButton_ok_clicked()
{
    emit setip(ui->lineEdit->text());
    close();
}
