#include "picture.h"
#include "ui_picture.h"

Picture::Picture(int info[][20], bool nClean[][20], bool cleaning[][20], bool cleanable, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Picture)
{
    ui->setupUi(this);
    this->info = info;
    this->nClean = nClean;
    this->cleaning = cleaning;
    this->cleanable = cleanable;
    size = (x > y) ? (600/(x+2)) : (600/(y+2));
    offset[0] = (600 - (x + 2) * size) / 2;
    offset[1] = (600 - (y + 2) * size) / 2;
}

void Picture::setClean(bool isClean)
{
    this->isClean = isClean;
}

void Picture::setList(QList<MyPoint> *info)
{
    this->list = info;
}

void Picture::set(int x, int y, int posX[], int posY[], bool isClean, bool cleanable)
{
    this->x = x; this->y = y; this->isClean = isClean; this->cleanable = cleanable;
    for (int i = 0; i < 7; ++i) {
        this->posX[i] = posX[i];
        this->posY[i] = posY[i];
    }
    size = (x > y) ? (600/(x+2)) : (600/(y+2));
    offset[0] = (600 - (x + 2) * size) / 2;
    offset[1] = (600 - (y + 2) * size) / 2;
}

void Picture::paintEvent(QPaintEvent *)
{
    QPainter pt(this);
    QColor color;
    pt.setPen(QPen(QColor(0, 0, 0), 2));
    int a = 0, b = 0;
    //网格
    for (int i = 1; i <= x; ++i) {
        for (int j = 1; j <= y; ++j) {
            getPos(i,j,a,b);
            if (isClean && nClean[i][j])
                color.setNamedColor("#BFBFBF");
            else
                color.setNamedColor("#FFFFFF");
            pt.setBrush(color);
            pt.drawRect(a,b,size,size);
            pt.setBrush(Qt::NoBrush);
            pt.drawText(QPoint(a,b+size),QString("%1").arg(info[i][j]));
            if (cleanable && isClean && cleaning[i][j]) {
                color.setNamedColor("#5CACEE");//clean, blue
                pt.setPen(QPen(color, 2));
                pt.setBrush(color);
                pt.drawRect(a,b,size,size);
                pt.setPen(QPen(QColor(0, 0, 0), 2));
            }
        }
    }
    QFont font;
    font.setPointSize(size/4);
    pt.setFont(font);
    //输入输出
    for (int i = 0; i < 5; ++i) {
        if (posX[i] == 0 || posY[i] == 0)
            continue;
        int a = 0, b = 0;
        if (posX[i] == 1) {
            getPos(0,posY[i],a,b);
        }
        else if (posX[i] == x) {
            getPos(x+1,posY[i],a,b);
        }
        else if (posY[i] == 1) {
            getPos(posX[i],0,a,b);
        }
        else if (posY[i] == y) {
            getPos(posX[i],y+1,a,b);
        }
        else {
            qDebug() << "error out of edge, index:" << i << posX[i] << posY[i];
        }
        if (i == 4) {
            color.setNamedColor("#9F79EE");//in, purple
        }
        else {
            color.setNamedColor("#FFA500");//out, orange
        }
        pt.setBrush(color);
        pt.drawRect(a,b,size,size);
        pt.drawText(QPoint(a,b+size*3/4),(i!=4) ? QString("IN%1").arg(i+1) : QString("OUT"));
    }
    //清洗输入输出
    if (cleanable) {
        color.setNamedColor("#5CACEE");//clean, blue
        font.setPointSize(size/8);
        pt.setBrush(color);
        pt.setFont(font);
        int i = 5;
        if (posX[i] == 1) {
            getPos(0,posY[i],a,b);
        }
        else if (posX[i] == x) {
            getPos(x+1,posY[i],a,b);
        }
        else if (posY[i] == 1) {
            getPos(posX[i],0,a,b);
        }
        else if (posY[i] == y) {
            getPos(posX[i],y+1,a,b);
        }
        //pt.setPen(QPen(color, 2));
        pt.drawRect(a,b,size,size);
        pt.setPen(QPen(QColor(0, 0, 0), 2));
        pt.drawText(QPoint(a,b+size*3/8),"Clean");
        pt.drawText(QPoint(a,b+size*7/8),"Intput");
        i = 6;
        if (posX[i] == 1) {
            getPos(0,posY[i],a,b);
        }
        else if (posX[i] == x) {
            getPos(x+1,posY[i],a,b);
        }
        else if (posY[i] == 1) {
            getPos(posX[i],0,a,b);
        }
        else if (posY[i] == y) {
            getPos(posX[i],y+1,a,b);
        }
        //pt.setPen(QPen(color, 2));
        pt.drawRect(a,b,size,size);
        pt.setPen(QPen(QColor(0, 0, 0), 2));
        pt.drawText(QPoint(a,b+size*3/8),"Clean");
        pt.drawText(QPoint(a,b+size*7/8),"Output");
    }
    //椭圆滴液
    color.setRgb(0xC1,0xFF,0xC1,127);
    pt.setBrush(color);
    if (list != nullptr) {
        for (MyPoint point : *list) {
            getPos(point.x,point.y,a,b);
            pt.drawEllipse(a, b, point.sizeX * size, point.sizeY * size);
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
    getIndex(pos.x(), pos.y(), i, j);
    if (i >= 0) {
        if (event->button() == Qt::LeftButton) {
            qDebug() << "Left" << pos.x() << pos.y() << i << j;
            emit changePoint(i, j);
        }
        else if (event->button() == Qt::RightButton) {
            qDebug() << "Right" << pos.x() << pos.y() << i << j;
            nClean[i][j] = !nClean[i][j];
            repaint();
        }
    }
}

Picture::~Picture()
{
    delete ui;
}
