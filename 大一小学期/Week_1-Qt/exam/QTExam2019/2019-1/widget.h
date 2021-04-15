#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QString>
#include <QImage>
#include <QSignalMapper>
#include <QDebug>
#include <QMessageBox>
#include "qlabelex.h"

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = nullptr);
    ~Widget();

private slots:
    void on_reset_clicked();
    void click(int);

private:
    Ui::Widget *ui;
    QImage *bimg, *wimg;
    bool m[8][8];
    QSignalMapper *mapper;
    void display();
};

#endif // WIDGET_H
