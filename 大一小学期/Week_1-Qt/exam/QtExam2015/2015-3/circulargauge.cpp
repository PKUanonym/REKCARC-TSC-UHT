#include "circulargauge.h"
#include "ui_circulargauge.h"
#include <QPainter>
#include <QtCore/qmath.h>
#include <QTime>
#include <QDebug>

CircularGauge::CircularGauge(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::CircularGauge)
{
    ui->setupUi(this);
    startTimer(1000);
    setValue(QTime::currentTime().hour()*3600+QTime::currentTime().minute()*60+QTime::currentTime().second());
}

CircularGauge::~CircularGauge()
{
    delete ui;
}

void CircularGauge::timerEvent(QTimerEvent *event)
{
    setValue(value()+1);
}

void CircularGauge::paintEvent(QPaintEvent *ev)
{
    qDebug()<<m_value;
    QPainter p(this);

    int extent;
    if (width()>height())
        extent = height()-20;
    else
        extent = width()-20;

    p.translate((width()-extent)/2, (height()-extent)/2);
    m_center.setX((width()-extent)/2+extent/2);
    m_center.setY((height()-extent)/2+extent/2);

    p.setPen(Qt::black);
    p.setBrush(Qt::white);

    p.drawEllipse(0, 0, extent, extent);

    p.translate(extent/2, extent/2);
    p.setBrush(Qt::black);
    p.rotate(-90);
    for(int i=0;i<360;i+=6)
    {
        p.save();
        p.rotate(i);
        if(i%5==0)
            p.drawRect(QRect(extent*0.4,-2,extent*0.08,4));
        else
            p.drawRect(QRect(extent*0.44,-1,extent*0.04,2));
        p.restore();
    }
    qreal h=m_value/120.0,m=(m_value%3600)/10.0,s=(m_value%60)*6;
    //hour
    p.setPen(Qt::white);
    p.save();
    p.rotate(h);
    p.drawRect(QRect(-5,-2,extent*0.3,4));
    p.restore();
    //minute
    p.save();
    p.rotate(m);
    p.drawRect(QRect(-5,-2,extent*0.44,4));
    p.restore();
    //second
    p.save();
    p.rotate(s);
    p.drawRect(QRect(-5,-1,extent*0.44,2));
    p.restore();
}

void CircularGauge::keyPressEvent(QKeyEvent *ev)
{
    switch(ev->key())
    {
    case Qt::Key_Up:
    case Qt::Key_Right:
        setValue(value()+1);
        break;
    case Qt::Key_Down:
    case Qt::Key_Left:
        setValue(value()-1);
        break;
    case Qt::Key_PageUp:
        setValue(value()+5);
        break;
    case Qt::Key_PageDown:
        setValue(value()-5);
        break;
    default:
        QWidget::keyPressEvent(ev);
    }
}

void CircularGauge::mousePressEvent(QMouseEvent *ev)
{
    setValueFromPos(ev->pos());
}

void CircularGauge::mouseReleaseEvent(QMouseEvent *ev)
{
    setValueFromPos(ev->pos());
}

void CircularGauge::mouseMoveEvent(QMouseEvent *ev)
{
    setValueFromPos(ev->pos());
}

void CircularGauge::setValueFromPos(const QPoint &pnt)
{
    int deltaX = pnt.x()-m_center.x();
    int deltaY = pnt.y()-m_center.y();
    int v=value()/60*60;
    //qDebug("deltaX: %d, deltaY: %d\n", deltaX, deltaY);

    qreal temp = qAcos(deltaY/(qreal)(qSqrt(deltaX*deltaX+deltaY*deltaY)))*30/3.1415926;
    if(deltaX>=0)setValue(v+30-temp);
    else setValue(v+30+temp);
}
