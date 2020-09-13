#ifndef CARDSBASEWIDGET_H
#define CARDSBASEWIDGET_H

#include <QWidget>
#include "desktop.h"
#include "cardwidget.h"

class CardsBaseWidget : public QWidget
{
    Q_OBJECT
public:
    explicit CardsBaseWidget(QWidget *parent = 0);
    void writeCardsSize(int Size){
        cardSize=Size;
    }
    int readCardsSize(){
        return cardSize;
    }
    cardWidget *cardwidget;
    QVector<cardWidget*>vector_card;
    bool isShow = false;
    void setGeometryAndLabels();//设定坐标
private:
    float ver;
    Desktop *desktop;
    int cardSize=20;

signals:
    void hideCardssssLabel();//关闭信号
public slots:
    void getCardWidgetID(int id);//获取单击widgetID
    void getCardAnimationFinshedID(int id);//获取动画结束widgetID
    void openGame();//开始游戏

};

#endif // CARDSBASEWIDGET_H
