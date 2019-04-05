#include "circulargauge.h"
#include "ui_circulargauge.h"
#include<QPainter>
#include<QtCore/qmath.h>

CircularGauge::CircularGauge(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::CircularGauge)
{
    ui->setupUi(this);
    setValue(0);
}

CircularGauge::~CircularGauge()
{
    delete ui;
}

void CircularGauge::paintEvent(QPaintEvent *ev)
{
    QPainter p(this);

    int extent;
    if (width()>height())
        extent = height()-20;
    else
        extent = width()-20;

    p.translate((width()-extent)/2, (height()-extent)/2);
    m_center.setX((width()-extent)/2+extent/2);
    m_center.setY((height()-extent)/2+extent/2);

    p.setPen(Qt::white);
    p.setBrush(Qt::black);

    p.drawEllipse(0, 0, extent, extent);

    p.translate(extent/2, extent/2);
    for(int angle=0; angle<=315; angle+=45)
    {
        p.save();
        p.rotate(angle+135);
        p.drawLine(extent*0.4, 0, extent*0.48, 0);
        p.restore();
    }

    p.rotate(m_value+135);
    QPolygon polygon;
    polygon << QPoint(-extent*0.05, extent*0.05)
            << QPoint(-extent*0.05, -extent*0.05)
            << QPoint(extent*0.46, 0);
    p.setPen(Qt::NoPen);
    p.setBrush(QColor(255,0,0,120));
    p.drawPolygon(polygon);
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
        setValue(value()+10);
        break;
    case Qt::Key_PageDown:
        setValue(value()-10);
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
    //qDebug("deltaX: %d, deltaY: %d\n", deltaX, deltaY);
    qreal temp = qAcos(deltaX/(qreal)(qSqrt(deltaX*deltaX+deltaY*deltaY)));

    if (deltaY >= 0)
        setValue(180+45+(temp*180/3.14159));
    else
        setValue(180+45-(temp*180/3.14159));
}
