#include "widget.h"
#include "ui_widget.h"

#include <QPainter>
#include <QTimer>
#include <QDebug>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    tm2 = new QTimer(this);
    m_value = 0;
    connect(tm2, SIGNAL(timeout()), this, SLOT(showTime()));
    on = 0;
    //tm2->start(1000);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::setValue(int v)
{
        m_value = v;
        ui->lcdNumber->display(m_value);
        update();
}

void Widget::showTime()
{
    setValue(m_value+1);
}

void Widget::paintEvent(QPaintEvent *event)
{
    QPainter p(this);
    QPen pen(Qt::SolidLine);
    QBrush brush(Qt::SolidPattern);
    int extent;
    if (width()>height())
        extent = height()-20;
    else
        extent = width()-20;

    p.translate((width()-extent)/2, (height()-extent)/2);
    m_center.setX((width()-extent)/2+extent/2);
    m_center.setY((height()-extent)/2+extent/2);

    p.setPen(Qt::black);
    p.setBrush(Qt::black);
    pen.setColor(Qt::black);

    //p.drawEllipse(0, 0, extent, extent);

    p.translate(extent/2, extent/2);
    p.rotate(-90);
    for(int angle=6; angle<=360; angle+=6)
    {
        p.save();
        p.rotate(angle);
        if (angle%30==0)
        {
            pen.setWidth(5);
            p.setPen(pen);
            p.drawLine(extent*0.4, 0, extent*0.48, 0);
            p.drawText(extent*0.35,5,QString::number(angle/6));
        }
        else
        {
            pen.setWidth(3);
            p.setPen(pen);
            p.drawLine(extent*0.45, 0, extent*0.48, 0);
        }
        p.restore();
    }
    p.setBrush(Qt::black);
    p.setPen(Qt::black);
    p.drawEllipse(-5,-5,10,10);
    p.rotate(m_value*6);
    p.setBrush(Qt::red);
    p.setPen(Qt::red);
    QPolygon polygon;
    polygon << QPoint(-0, extent*0.05)
            << QPoint(extent*(-0.1), 0)
            << QPoint(-0, -extent*0.05)
            << QPoint(extent*0.46, 0);
    p.setPen(Qt::NoPen);
    p.setBrush(QColor(255,0,0,120));
    p.drawPolygon(polygon);
    //ui->label->setText(QString::number(m_value));
}


void Widget::on_pushButton_clicked()
{
    //setValue(0);
    on =1 ;
    ui->pushButton_3->setDisabled(true);
    tm2->start(1000);
}

void Widget::on_pushButton_2_clicked()
{
    qDebug() << on;
    if (on>0)
    {
        on =-1 ;
        ui->pushButton_3->setEnabled(true);

        tm2->stop();
    }
    else if (on==-1)
    {
        on = 1;
        ui->pushButton_3->setDisabled(true);
        tm2->start(1000);
    }
}

void Widget::on_pushButton_3_clicked()
{
    if (on>0) return;
    on = 0;
    tm2->stop();
    ui->pushButton_3->setEnabled(true);
    setValue(0);
}
