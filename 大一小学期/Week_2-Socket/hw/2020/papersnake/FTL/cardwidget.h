#ifndef CARDWIDGET_H
#define CARDWIDGET_H

#include <QWidget>
#include <QLabel>
#include "desktop.h"

class cardWidget : public QWidget
{
    Q_OBJECT
public:
    QLabel *cardLabel;//牌面
    void setGeometryAndLabel();//设置坐标与大小
    void setAnimation();//创建动画
    void setNoAnimation();//创建无补间动画
    void writeCardWidget_X(int x)//写入坐标X
    {
        this->cardWidget_X=x;
    }
    void writeCardNum(int Num);//写入卡号
    int readCardNum();//读取卡号
    void writeCardID(int id)
    {
        this->cardID=id;
    }//写入卡的id
    int readCardID()
    {
        return this->cardID;
    }//读取卡的id
    explicit cardWidget(QWidget *parent = 0);
    bool isup=false;
    bool isdown=true;
private:
    void mousePressEvent(QMouseEvent *event);//单击事件
    void mouseDoubleClickEvent(QMouseEvent *event);
    int cardWidget_X;//x坐标
    int cardID;//卡牌的id
    int cardNum=0;//定义从A-----大王分别为1------------15
    float ver;
    Desktop *desktop;
signals:
    void mousePressSend(int ID);//发送信号单击信号
    void animationFinished(int ID);//发送动画结束信号
public slots:
    void getAnimationFinished();//接收动画结束信号
};

#endif // CARDWIDGET_H
