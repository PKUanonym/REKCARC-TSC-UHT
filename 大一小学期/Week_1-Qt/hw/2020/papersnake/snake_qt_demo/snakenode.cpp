#include "snakenode.h"

SnakeNode::SnakeNode(QWidget *parent) : QWidget(parent){}

SnakeNode::SnakeNode(QWidget *parent,int pos){
    SnakeNode_Init(parent);
    setPos(pos);
}

SnakeNode::SnakeNode(QWidget *parent,int x,int y){
    SnakeNode_Init(parent);
    setPos(x,y);
}

SnakeNode::SnakeNode(QWidget *parent,QPoint pos){
    SnakeNode_Init(parent);
    setPos(pos);
}

void SnakeNode::SnakeNode_Init(QWidget *parent){
    item = new QFrame(parent);
    item->setAutoFillBackground(true);
    QPalette pa=item->palette();
    QColor red(Qt::red);
    pa.setColor(QPalette::Background,red);
    item->setPalette(pa);
    item->resize(10,10);
    item->show();

    next=NULL;
}

SnakeNode::~SnakeNode()
{
    delete item;
}

void SnakeNode::setPos(int x,int y){
    pos.setX(x);
    pos.setY(y);
    item->move(pos);
}

void SnakeNode::setPos(QPoint _pos){
    pos=_pos;
    item->move(pos);
}

void SnakeNode::setPos(int _pos){
    pos.setX(_pos/100*10);
    pos.setY(_pos%100*10);
    item->move(pos);
}

QPoint SnakeNode::getPos(){
    return pos;
}

void SnakeNode::setColor(QColor color){
    QPalette pa=item->palette();
    pa.setColor(QPalette::Background,color);
    item->setPalette(pa);
}

int SnakeNode::intPos(){
    return pos.x()*10+pos.y()/10;
}
