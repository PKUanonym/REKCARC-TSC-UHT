#ifndef PICTURE_H
#define PICTURE_H

#include <QWidget>
#include <QList>
#include <QPainter>
#include <QColor>
#include <math.h>
#include <QDebug>
#include <QPen>
#include "mydef.h"

namespace Ui {
class Picture;
}

class Picture : public QWidget
{
    Q_OBJECT

public:
    explicit Picture(int info[][20], bool nClean[][20], bool cleaning[][20], bool cleanable, QWidget *parent = nullptr);
    void setClean(bool isClean);
    void setList(QList<MyPoint> * info);
    void set(int x, int y, int posX[], int posY[], bool isClean, bool cleanable);
    ~Picture();
signals:
    void changePoint(int x, int y);

private:
    int x = 4, y = 6, posX[7] = {2, 4, 0, 0, 4, 1, 4}, posY[7] = {6, 6, 0, 0, 5, 6, 1}, size, offset[2], (*info)[20];
    //info: int[x+1][y+1]; int[i][j] = (i,j)的污染次数
    //nClean: bool[x+1][y+1]; bool[i][j] = true: (i,j)不可被清洁; false: (i,j)可被清洁. (鼠标设置)
    bool cleanable = true, isClean = true, (*nClean)[20] = nullptr, (*cleaning)[20] = nullptr;
    Ui::Picture *ui;
    QList<MyPoint> *list = nullptr;
    void paintEvent(QPaintEvent *event);
    void getIndex(int x, int y, int &i, int &j);
    void getPos(int i, int j, int &x, int &y);
    void mousePressEvent(QMouseEvent *event);
};

#endif // PICTURE_H
