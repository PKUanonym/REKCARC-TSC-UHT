#include "picture.h"
#include "ui_picture.h"

Picture::Picture(int _x, int _y, QWidget *parent) :
    QWidget(parent),x(_x),y(_y),
    ui(new Ui::Picture)
{
    ui->setupUi(this);
    this->setFixedSize(600,800);
    size = ((width()/(x+2)) < (height()/(y+2))) ? (width()/(x+2)) : (height()/(y+2));
    offset[0] = (width() - (x + 2) * size) / 2;
    offset[1] = offset[0];//(height() - (y + 2) * size) / 2;
    memset(info,0,sizeof(info));
}
void Picture::set(int x, int y)
{
    this->x = x; this->y = y;
    size = ((width()/(x+2)) < (height()/(y+2))) ? (width()/(x+2)) : (height()/(y+2));
    offset[0] = (width() - (x + 2) * size) / 2;
    offset[1] = offset[0];//(height() - (y + 2) * size) / 2;
}

void Picture::paintEvent(QPaintEvent *)
{
    size = ((width()/(x+2)) < (height()/(y+2))) ? (width()/(x+2)) : (height()/(y+2));
    offset[0] = (width() - (x + 2) * size) / 2;
    offset[1] = offset[0];//(height() - (y + 2) * size) / 2;
    qDebug()<<offset[0]<<offset[1]<<size<<width()<<height()<<x<<y;
    QPainter pt(this);
    QColor color;
    color.setNamedColor("#FFC125");
    pt.setBrush(color);
    pt.drawRect(0,0,width(),height());
    //pt.setPen(Qt::NoPen);
    int a = 0, b = 0;
    //网格
    for (int i = 1; i <= x; ++i) {
        for (int j = 1; j <= y; ++j) {
            getPos(i,j,a,b);
            pt.setBrush(Qt::NoBrush);
            pt.setPen(Qt::black);
            pt.drawRect(a,b,size,size);
            if (info[i][j]==0)
            pt.setBrush(Qt::black);
            else {
                pt.setBrush(Qt::white);
            }
            pt.setPen(Qt::NoPen);
            pt.drawEllipse(a+5,b+5,size-10,size-10);
            //pt.setBrush(Qt::NoBrush);
            //pt.drawText(QPoint(a,b+size),QString("%1").arg(info[i][j]));
        }
    }
}

void Picture::getIndex(int x, int y, int &i, int &j)
{
    i = (x - offset[0]) / size;
    j = (y - offset[1]) / size;
    if (i <= 0 || i > this->x || j <= 0 || j > this->y) {
        i = -1;
        j = -1;
    }
}

void Picture::getPos(int i, int j, int &x, int &y)
{
    x = size * i + offset[0];
    y = size * j + offset[1];
}

void Picture::mousePressEvent(QMouseEvent *event)
{
    QPoint pos = event->pos();
    int i, j;
    //emit changePoint(i, j);
    getIndex(pos.x(), pos.y(), i, j);
    qDebug()<<pos.x()<<pos.y();
    if (i >= 0) {
        if (event->button() == Qt::LeftButton) {
            if (info[i][j] == 1)
                QMessageBox::warning(this,tr("error"),QString("它是白子"));
            else {
                for (int tt = 1; tt <= x; ++tt) {
                    if (tt != j)
                        info[i][tt] = 1 - info[i][tt];
                    info[tt][j] = 1 - info[tt][j];
                }
            }
        }
        repaint();
    }
}

Picture::~Picture()
{
    delete ui;
}

void Picture::on_pushButton_clicked()
{
    memset(info,0,sizeof(info));
    repaint();
}
