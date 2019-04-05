#include "cell.h"

Cell::Cell(QWidget *parent) :
    QPushButton(parent)
{

}

Cell::Cell()
{
    type = -1;
    color = -1;
}


void Cell::fresh()
{
    if(type >= 0 && type <= 1 &&  color >= 0 && color <= 4 )
    {
        QString ss;
        ss.clear();
        ss.append("border-style:flat;");
        if(type == 0)
        {
            if(color == 1)
            {
                ss.append("background-image:url(:/new/prefix1/pics/WhiteBoard_1.png);");
            }
            else
            {
                if(color == 2)
                    ss.append("background-image:url(:/new/prefix1/pics/BlackBoard_1.png);");
            }
        }
        else
        {
            if(color == 1)
            {
                ss.append("border-image:url(:/new/prefix1/pics/red_1.png);");
            }
            if(color == 2)
            {
                ss.append("border-image:url(:/new/prefix1/pics/green_1.png);");
            }
            if(color == 3)
            {
                ss.append("border-image:url(:/new/prefix1/pics/red_queen_2.png);");
            }
            if(color == 4)
            {
                ss.append("border-image:url(:/new/prefix1/pics/green_queen_2.png);");
            }
        }
        this->setStyleSheet(ss);
    }
}

void Cell::setType(int a)
{
    if(a == 0|| a == 1)
    {
        type = a;
        fresh();
    }
}

void Cell::setColor(int a)
{
    if(a == 0 || a == 1 || a == 2 || a== 3 || a == 4)
    {
        color = a;
        fresh();
    }
}
