#include <QString>
#include <QPushButton>

#ifndef CELL_H
#define CELL_H


class Cell : public QPushButton
{
public:
    explicit Cell(QWidget *parent = 0);
    Cell();
    void setType(int);
    void setColor(int);
    int getType(){return type;}
    int getColor(){return color;}
    void fresh();

private:
    int type;//0:chessboard;1:chessman
    int color;//0:invisible;1:black;2:white;  1:blue;2:red;
};

#endif // CELL_H
