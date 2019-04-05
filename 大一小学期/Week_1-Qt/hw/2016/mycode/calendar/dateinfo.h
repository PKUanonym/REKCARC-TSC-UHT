#ifndef DATE_H
#define DATE_H

#include <QObject>
#include <QDate>
#include <QVector>
#include <QColor>
#include <algorithm>
#include "schedule.h"

class dateinfo : public QDate
{
public:
    dateinfo();
    ~dateinfo();
    QVector<schedule> get_sch_list();
    QColor get_text_color()const;
    QColor get_back_ground()const;
    void clear_sch();
    void add_sch(schedule sch);
    void del_sch(schedule sch);
    void change_text_color(QColor new_color);
    void change_back_ground(QColor new_color);
    void sort();
    void del_all();
    QString file_url;
private:
    QVector<schedule> sch_list;
    QColor text_color,back_ground;
};

#endif // DATE_H
