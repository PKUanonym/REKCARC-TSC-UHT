#include "cardsbasewidget.h"
#include <QDebug>
#include <QPropertyAnimation>

CardsBaseWidget::CardsBaseWidget(QWidget *parent) : QWidget(parent)
{
    desktop=new Desktop(this);
    ver=desktop->getDesktop();
    setGeometryAndLabels();
}
void CardsBaseWidget::setGeometryAndLabels()
{
    int x;
    if(cardSize<10)
    {
        x=250*ver+(10-cardSize)*40*ver;
    }else
    {
        x=250*ver+(20-cardSize)*20*ver;
    }
    int w=(cardSize-1)*40*ver+100*ver;
    this->setGeometry(x,520*ver,w,320*ver);
    for(int i=0;i<cardSize;i++)
    {
        cardwidget=new cardWidget(this);
        cardwidget->writeCardID(i);
        vector_card.append(cardwidget);
        vector_card.at(i)->setGeometryAndLabel();
    }
    for(int i=0;i<cardSize;i++)
    {
        connect(vector_card.at(i),SIGNAL(mousePressSend(int)),this,SLOT(getCardWidgetID(int)));
        connect(vector_card.at(i),SIGNAL(animationFinished(int)),this,SLOT(getCardAnimationFinshedID(int)));
    }
}
void CardsBaseWidget::getCardAnimationFinshedID(int id)
{
    if(id<cardSize-1)
    {
         int ID=id+1;
         vector_card.at(ID)->setAnimation();
         vector_card.at(ID)->show();
    }
    else
    {
        emit hideCardssssLabel();
    }
}
void CardsBaseWidget::getCardWidgetID(int id)
{
    if(vector_card.at(id)->isup==true)
    {
         vector_card.at(id)->setGeometry(id*40*ver,70*ver,100*ver,150*ver);
    }
    if(vector_card.at(id)->isup==false)
    {
          vector_card.at(id)->setGeometry(id*40*ver,120*ver,100*ver,150*ver);
    }
}
void CardsBaseWidget::openGame()
{
       vector_card.at(0)->setAnimation();
       vector_card.at(0)->setGeometryAndLabel();
       vector_card.at(0)->show();
}






















