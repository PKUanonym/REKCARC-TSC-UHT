#include "snakelist.h"

SnakeList::SnakeList(QWidget *parent) : QWidget(parent)
{
    body.push_front(new SnakeNode(parent,100,100));
    body.push_back(new SnakeNode(parent,100,110));
    body.last()->setColor(Qt::blue);
}

SnakeList::~SnakeList()
{
    for(auto node:body)
        delete node;
}

void SnakeList::AddHead(QWidget *parent){
    body.push_front( new SnakeNode(parent,body.first()->getPos()));
}

void SnakeList::AddTail(QWidget *parent){
    body.push_back(new SnakeNode(parent,body.back()->getPos()));
    body.back()->setColor(Qt::blue);
}


void SnakeList::DelTail(){
    delete body.takeLast();
}

void SnakeList::move(int dir, QWidget *parent){
    QPoint pos = body.first()->getPos();
    body.first()->setColor(Qt::blue);
    int x = pos.x();
    int y = pos.y();
    AddHead(parent);
    switch (dir) {
    case 1:
        y-=10;
        break;
    case 2:
        y+=10;
        break;
    case 3:
        x-=10;
        break;
    case 4:
        x+=10;
        break;
    }
    body.first()->setPos(x,y);
    body.first()->setColor(Qt::red);
    DelTail();
}

void SnakeList::eat(int dir, QWidget *parent){
    QPoint pos = body.first()->getPos();
    body.first()->setColor(Qt::blue);
    int x = pos.x();
    int y = pos.y();
    AddTail(parent);
    AddTail(parent);
    AddHead(parent);
    switch (dir) {
    case 1:
        y-=10;
        break;
    case 2:
        y+=10;
        break;
    case 3:
        x-=10;
        break;
    case 4:
        x+=10;
        break;
    }
    body.first()->setPos(x,y);
    body.first()->setColor(Qt::red);
}


int SnakeList::Check(QMap<int,SnakeNode*>& barrier){
    SnakeNode* head = body.first();
    for(auto node:body){
        if(node!=head&&node->getPos()==head->getPos())
            return 1;
    }
    int b = head->getPos().x()*10 + head->getPos().y()/10;
    if(barrier.find(b)!=barrier.end())
        return 2;
    return 0;
}

int SnakeList::Check(QMap<int,SnakeNode*>& barrier,QPoint p){
    if(p.x()>=400||p.x()<0||p.y()>=400||p.y()<0)
        return 3;
    for(auto node:body){
        if(node->getPos()==p)
            return 1;
    }
    int b = p.x()*10 + p.y()/10;
    if(barrier.find(b)!=barrier.end())
        return 2;
    return 0;
}
