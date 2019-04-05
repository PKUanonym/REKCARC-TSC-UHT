#include "mydialog.h"
#include <cstdlib>
#include <cmath>

QVector<QPoint> point;
QVector<int> Flag;
bool shift;

void mydialog::mousePressEvent(QMouseEvent* event)
{
    QPoint p = event->pos();
    int x = p.x(), y = p.y();
    if (event->button() == Qt::LeftButton)
    {
        if (x - 10 >= 0 && x + 10 <= 500 && y - 10 >= 0 && y + 10 <= 500)
        {
            bool flag = 1;
            for (int i = 0; i < point.size(); ++i)
            {
                if (abs(point[i].x() - x) < 20 && abs(point[i].y() - y) < 20)
                    flag = 0;
            }
            if (flag)
            {
                point.push_back(p);
                Flag.push_back(0);
                update();
            }
        }
    }
    if (event->button() == Qt::RightButton)
    {
        for (int i = 0; i < point.size(); ++i)
        {
            if (abs(point[i].x() - x) <= 10 && abs(point[i].y() - y) <= 10)
            {
                if (Flag[i])
                    Flag[i] = 0;
                else
                {
                    if (!shift)
                    for (int j = 0; j < point.size(); ++j)
                        Flag[j] = 0;
                    Flag[i] = 1;
                }
                break;
            }
        }
        update();
    }
}

void mydialog::keyReleaseEvent(QKeyEvent* event)
{
    if (event->key() == Qt::Key_Shift)
        shift = 0;
}

void mydialog::keyPressEvent(QKeyEvent *event)
{
    bool flag = 1;
    switch(event->key())
    {
    case Qt::Key_Shift:
        shift = 1;
        break;
    case Qt::Key_Up:
        for (int i = 0; i < point.size(); ++i)
            if (Flag[i] && point[i].y() <= 10)
            {
                flag = 0;
            }
        if (flag)
        {
            for (int i = 0; i < point.size(); ++i)
                if (Flag[i])
                {
                    point[i].setY(point[i].y() - 1);
                }
        }
        break;
    case Qt::Key_Down:
        for (int i = 0; i < point.size(); ++i)
            if (Flag[i] && point[i].y() >= 490)
            {
                flag = 0;
            }
        if (flag)
        {
            for (int i = 0; i < point.size(); ++i)
                if (Flag[i])
                {
                    point[i].setY(point[i].y() + 1);
                }
        }
        break;
    case Qt::Key_Left:
        for (int i = 0; i < point.size(); ++i)
            if (Flag[i] && point[i].x() <= 10)
            {
                flag = 0;
            }
        if (flag)
        {
            for (int i = 0; i < point.size(); ++i)
                if (Flag[i])
                {
                    point[i].setX(point[i].x() - 1);
                }
        }
        break;
    case Qt::Key_Right:
        for (int i = 0; i < point.size(); ++i)
            if (Flag[i] && point[i].x() >= 490)
            {
                flag = 0;
            }
        if (flag)
        {
            for (int i = 0; i < point.size(); ++i)
                if (Flag[i])
                {
                    point[i].setX(point[i].x() + 1);
                }
        }
        break;
    case Qt::Key_Delete:
        for (int i = 0; i < point.size(); ++i)
            if (Flag[i])
                point.remove(i), Flag.remove(i);
        break;
    case Qt::Key_Backspace:
        for (int i = 0; i < point.size(); ++i)
            if (Flag[i])
                point.remove(i), Flag.remove(i);
        break;
    }
    update();
}

void mydialog::paintEvent(QPaintEvent *event)
{
    QPainter p(this);
    p.setPen(Qt::NoPen);
    for (int i = 0; i < point.size(); ++i)
    {
        if (Flag[i])
            p.setBrush(Qt::red);
        else
            p.setBrush(Qt::blue);
        p.drawRect(point[i].x() - 10, point[i].y() - 10, 20, 20);
    }
}
