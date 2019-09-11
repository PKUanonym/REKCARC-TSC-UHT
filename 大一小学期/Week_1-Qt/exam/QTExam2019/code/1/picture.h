#ifndef PICTURE_H
#define PICTURE_H

#include <QWidget>
#include <QMessageBox>
#include <QList>
#include <QPainter>
#include <QColor>
#include <math.h>
#include <QDebug>
#include <QPen>

namespace Ui {
class Picture;
}

class Picture : public QWidget
{
    Q_OBJECT

public:
    explicit Picture(int x = 8, int y = 8, QWidget *parent = nullptr);
    void set(int x, int y);
    ~Picture();
signals:
    void changePoint(int x, int y);

private slots:
    void on_pushButton_clicked();

private:
    int x, y, size, offset[2];
    int info[200][200];
    Ui::Picture *ui;
    void paintEvent(QPaintEvent *event);
    void getIndex(int x, int y, int &i, int &j);
    void getPos(int i, int j, int &x, int &y);
    void mousePressEvent(QMouseEvent *event);
};

#endif // PICTURE_H
