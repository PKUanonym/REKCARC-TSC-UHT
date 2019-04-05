#include "event_data.h"
#include <QDialog>
#include <QMessageBox>

event_data::event_data()
{
    cnt = 0;
}

event_data::~event_data()
{

}

void event_data::output(QTextStream& s)
{
    for (int i = 0; i < cnt; ++i)
    {
        s << "Event " << i << ": \n";
        s << moment_data[i].toString() << "\n" << memo_data[i] << "\n";
    }
}

void event_data::add(QTime time, QString memo)
{
    memo_data.push_back(memo);
    moment_data.push_back(time);
    ++cnt;
}

day_data::day_data(QDate date, QColor color) : event_data()
{
    cur = date;
    grid_color = color;
}

day_data::~day_data()
{

}

void day_data::output(QTextStream& s)
{
    s << "Date: \n" << cur.toString() << "\n";
    s << "Grid color: \n" << grid_color.name() << "\n";
    event_data::output(s);
}

month_data::month_data(QDate date) : event_data()
{
    year = date.year(); month = date.month();
}

month_data::~month_data()
{

}

void month_data::output(QTextStream& s)
{
    s << "Year: \n" << year << "\n";
    s << "Month: \n" << month << "\n";
    event_data::output(s);
}
