#ifndef SNAKELIST_H
#define SNAKELIST_H

#include <QWidget>
#include <QList>
#include <QMap>
#include "snakenode.h"

class SnakeList: public QWidget
{
    Q_OBJECT
public:
    SnakeList(QWidget *parent = 0);
    ~SnakeList();

    void AddHead(QWidget *parent);
    void AddTail(QWidget *parent);
    void DelTail();

    void eat(int dir,QWidget *parent);
    void move(int dir,QWidget *parent);
    int Check(QMap<int,SnakeNode*>& barrier);
    int Check(QMap<int,SnakeNode*>& barrier,QPoint p);

    QList<SnakeNode*> body;
};

#endif // SNAKELIST_H
