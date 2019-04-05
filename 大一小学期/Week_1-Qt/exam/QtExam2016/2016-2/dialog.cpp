#include "dialog.h"
#include "ui_dialog.h"
#include <QPainter>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    n=0;shift=0;
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::up()
{
    int tmp=this->height();
    for(int i=0;i<n;++i)
        if(stat[i]&&py[i]<tmp)
            tmp=py[i];
    if(tmp<10)
        return;
    for(int i=0;i<n;++i)
        if(stat[i])
            py[i]--;
    update();
}

void Dialog::down()
{
    int tmp=0;
    for(int i=0;i<n;++i)
        if(stat[i]&&py[i]>tmp)
            tmp=py[i];
    if(tmp>this->height()-10)
        return;
    for(int i=0;i<n;++i)
        if(stat[i])
            py[i]++;
    update();
}

void Dialog::left()
{
    int tmp=this->width();
    for(int i=0;i<n;++i)
        if(stat[i]&&px[i]<tmp)
            tmp=px[i];
    if(tmp<10)
        return;
    for(int i=0;i<n;++i)
        if(stat[i])
            px[i]--;
    update();
}

void Dialog::right()
{
    int tmp=0;
    for(int i=0;i<n;++i)
        if(stat[i]&&px[i]>tmp)
            tmp=px[i];
    if(tmp>this->width()-10)
        return;
    for(int i=0;i<n;++i)
        if(stat[i])
            px[i]++;
    update();
}

void Dialog::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    for(int i=0;i<n;++i)
    {
        p.setPen(Qt::NoPen);
        if(stat[i])
            p.setBrush(Qt::red);
        else
            p.setBrush(Qt::blue);
        p.drawRect(px[i]-10,py[i]-10,20,20);
    }
}

void Dialog::mousePressEvent(QMouseEvent *e)
{
    int x=e->pos().x(),y=e->pos().y();
    if(e->button()==Qt::RightButton)
    {
        int sel=-1;
        for(int i=0;i<n;++i)
            if(qAbs(x-px[i])<=10&&qAbs(y-py[i])<=10)
            {
                stat[i]^=1;
                sel=i;
                break;
            }
        if(sel>=0&&shift==0&&stat[sel])
            for(int i=0;i<n;++i)
                if(i!=sel)
                    stat[i]=0;
    }
    else
    {
        int flag=1;
        for(int i=0;i<n;++i)
            if(qAbs(x-px[i])<=20&&qAbs(y-py[i])<=20)
                flag=0;
        if(flag&&x>=10&&y>=10&&x<=this->width()-10&&y<=this->height()-10)
        {
            n++;
            stat.append(0);
            px.append(x);
            py.append(y);
        }
    }
    update();
}

void Dialog::del()
{
    for(int i=0;i<n;++i)
        if(stat[i])
        {
            stat.remove(i);
            px.remove(i);
            py.remove(i);
            n--;i--;
        }
    update();
}

void Dialog::keyPressEvent(QKeyEvent *e)
{
    switch(e->key())
    {
    case Qt::Key_Up:
        up();
        break;
    case Qt::Key_Down:
        down();
        break;
    case Qt::Key_Left:
        left();
        break;
    case Qt::Key_Right:
        right();
        break;
    case Qt::Key_Backspace:
    case Qt::Key_Delete:
        del();
        break;
    case Qt::Key_Shift:
        shift=1;
        break;
    }
}

void Dialog::keyReleaseEvent(QKeyEvent *e)
{
    if(e->key()==Qt::Key_Shift)
        shift=0;
}
