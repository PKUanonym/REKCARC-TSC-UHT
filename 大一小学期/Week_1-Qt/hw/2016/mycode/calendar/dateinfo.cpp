#include "dateinfo.h"

dateinfo::dateinfo():QDate()
{
    back_ground = QColor(255,255,255,100);
    text_color = QColor(0,0,0,100);
    schedule s;
    sch_list.push_back(s);
}

dateinfo::~dateinfo()
{

}
void dateinfo::clear_sch()
{
    sch_list.clear();
}
QVector<schedule> dateinfo::get_sch_list()
{
    return sch_list;
}

QColor dateinfo::get_text_color()const
{
    return text_color;
}

QColor dateinfo::get_back_ground()const
{
    return back_ground;
}

void dateinfo::add_sch(schedule sch)
{
    sch_list.push_back(sch);
}

void dateinfo::del_sch(schedule sch)
{
    for(QVector<schedule>::iterator i = sch_list.begin();i != sch_list.end();++i)
        if(sch==*i)
        {
            sch_list.erase(i);
            return;
        }
}

void dateinfo::change_text_color(QColor new_color)
{
    text_color = new_color;
}

void dateinfo::change_back_ground(QColor new_color)
{
    back_ground = new_color;
}
bool cmp(schedule c1,schedule c2)
{
    return c1.start_time()<c2.start_time();
}
void dateinfo::sort()
{
    std::sort(sch_list.begin(),sch_list.end(),cmp);
}
void dateinfo::del_all()
{
    sch_list.clear();
    schedule w;
    sch_list.push_back(w);
}
