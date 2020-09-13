#ifndef SNAKENODE_H
#define SNAKENODE_H

#include <QWidget>
#include <QFrame>
#include <QPoint>
#include <QColor>

class SnakeNode:public QWidget
{
    Q_OBJECT
public:
    SnakeNode(QWidget *parent = 0);
    SnakeNode(QWidget *parent,int pos);
    SnakeNode(QWidget *parent,int x,int y);
    SnakeNode(QWidget *parent,QPoint pos);
    ~SnakeNode();

    void setPos(int x,int y);
    void setPos(int pos);
    void setPos(QPoint pos);
    void setColor(QColor color);
    int intPos();
    QPoint getPos();
    SnakeNode *next;

private:
    void SnakeNode_Init(QWidget *parent);
    QPoint pos;
    QFrame* item;

};

#endif // SNAKENODE_H
