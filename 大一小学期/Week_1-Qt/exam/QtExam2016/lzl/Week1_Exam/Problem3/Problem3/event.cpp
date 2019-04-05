#include "event.h"
#include <QMessageBox>
#include <QInputDialog>
#include <QDebug>
#include <QSignalMapper>
#include <QColorDialog>
#include <algorithm>

QVector <day_data> daydata;
event_data weekdata[8];
QVector <month_data> monthdata;
int askMonthIndex(int year, int month);
int askDayIndex(QDate date);

/******************************************************************************************/

Event::Event(QWidget *parent) : QDialog(parent)
{
    QHBoxLayout* outerLayout = new QHBoxLayout(this);
    outerLayout->setSpacing(0);

    QVBoxLayout* leftmostLayout = new QVBoxLayout();
    leftmostLayout->setSpacing(0);
    QLabel* none = new QLabel("");
    none->setFixedHeight(40);
    none->setFixedWidth(140);
    none->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    leftmostLayout->addWidget(none);
    for (int i = 0; i < 5; ++i)
    {
        delete_event[i] = new QPushButton(tr("Delete"));
        delete_event[i]->setFixedHeight(40);
        delete_event[i]->setFixedWidth(140);
        delete_event[i]->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        delete_event[i]->setEnabled(false);
        leftmostLayout->addWidget(delete_event[i]);
    }
    outerLayout->addLayout(leftmostLayout);

    QVBoxLayout* leftLayout = new QVBoxLayout();
    leftLayout->setSpacing(0);

    QLabel* Time = new QLabel(tr("Time"));
    Time->setFixedHeight(40);
    Time->setFixedWidth(140);
    Time->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    leftLayout->addWidget(Time);

    for (int i = 0; i < 5; ++i)
    {
        moment[i] = new QLabel("");
        moment[i]->setFixedHeight(40);
        moment[i]->setFixedWidth(140);
        moment[i]->setStyleSheet("border-color: rgb(0, 0, 0);"
                                 "background: rgb(255, 255, 255);"
                                 "border-style: solid; border-width: 1px;");
        moment[i]->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        leftLayout->addWidget(moment[i]);
    }
    outerLayout->addLayout(leftLayout);

    QVBoxLayout* midLayout = new QVBoxLayout();
    midLayout->setSpacing(0);

    QLabel* Second = new QLabel(tr("Event"));
    Second->setFixedHeight(40);
    Second->setFixedWidth(140);
    midLayout->addWidget(Second);

    for (int i = 0; i < 5; ++i)
    {
        note[i] = new QLabel("");
        note[i]->setFixedHeight(40);
        note[i]->setStyleSheet("background: rgb(255, 255, 255); "
                               "border-style: solid; border-width: 1px;"
                               "border-color: rgb(0, 0, 0);");
        note[i]->setFixedWidth(140);
        note[i]->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        midLayout->addWidget(note[i]);
    }
    outerLayout->addLayout(midLayout);
    outerLayout->addSpacerItem(new QSpacerItem(20,20));
    QVBoxLayout* rightLayout = new QVBoxLayout();
    //rightLayout->addSpacerItem(new QSpacerItem(80,140));
    QPushButton* tmp1 = new QPushButton(tr("Add.."));
    add_event = tmp1;
    QPushButton* tmp3 = new QPushButton(tr("Delete All"));
    delete_all = tmp3;
    QPushButton* tmp4 = new QPushButton(tr("Set Color"));
    set_color = tmp4;
    rightLayout->addWidget(add_event);
    rightLayout->addWidget(delete_all);
    rightLayout->addWidget(set_color);
    outerLayout->addLayout(rightLayout);
    connect(add_event,SIGNAL(clicked()),this,SLOT(check()));
    connect(delete_all,SIGNAL(clicked()),this,SLOT(deleteAll()));
    QSignalMapper *sigMap = new QSignalMapper(this);
    for (int i = 0; i < 5; ++i)
    {
        connect(delete_event[i], SIGNAL(clicked()), sigMap, SLOT(map()));
        sigMap->setMapping(delete_event[i], i);
    }
    connect(sigMap, SIGNAL(mapped(int)), this, SLOT(deleteEvent(int)));
}

Event::~Event()
{

}

/******************************************************************************************/

day_event::day_event(QDate date, QCalendarWidget *parent) : Event(parent)
{
    cur = date; maintain(); father = parent;
    connect(set_color,SIGNAL(clicked()),this,SLOT(setColor()));
}

day_event::~day_event()
{

}

void day_event::maintain()
{
    int j = askDayIndex(cur), cnt = 0, i = 0;
    if (j != -1)
        for (i = 0; i < daydata[j].cnt; ++cnt, ++i)
            moment[cnt]->setText(daydata[j].moment_data[i].toString()),
            note[cnt]->setText(daydata[j].memo_data[i]),
            delete_event[i]->setEnabled(true);
    for (;i < 5; ++i)
        delete_event[i]->setEnabled(false);
    j = cur.dayOfWeek();
    for (i = 0; i < weekdata[j].cnt; ++cnt, ++i)
        moment[cnt]->setText(weekdata[j].moment_data[i].toString()),
        note[cnt]->setText(weekdata[j].memo_data[i]);
    j = askMonthIndex(cur.year(), cur.month());
    if (j != -1)
        for (i = 0; i < monthdata[j].cnt; ++cnt, ++i)
            moment[cnt]->setText(monthdata[j].moment_data[i].toString()),
            note[cnt]->setText(monthdata[j].memo_data[i]);
    for (;cnt < 5; ++cnt)
        moment[cnt]->setText(QString()),
        note[cnt]->setText(QString());
}

void day_event::check()
{
    int tmp = 0, i = askDayIndex(cur), j = askMonthIndex(cur.year(), cur.month());
    if (i != -1) tmp = daydata[i].cnt;
    tmp += weekdata[cur.dayOfWeek()].cnt;
    if (j != -1) tmp += monthdata[j].cnt;
    if (tmp >= 5)
        QMessageBox::information(0,tr("Failed!"),tr("Too many events have been added!"),QMessageBox::Ok);
    else
    {
        QTime tmp_time = QTime::fromString(QInputDialog::getText(this, tr("Time"), tr("Input valid time:")));
        if (!tmp_time.isNull())
        {
            QString tmp_event = QInputDialog::getText(this, tr("Event"), tr("Input event description:"));
            if (!tmp_event.isEmpty())
            {
                if (i == -1)
                {
                    day_data data_tmp(cur);
                    data_tmp.add(tmp_time, tmp_event);
                    daydata.push_back(data_tmp);
                }
                else
                    daydata[i].add(tmp_time, tmp_event);
                maintain();
            }
            else
            {
                QMessageBox::information(this, tr("Failed!"),tr("You have added nothing. We won't take space for useless time."),QMessageBox::Ok);
            }
        }
        else
            QMessageBox::information(this, tr("Failed!"),tr("Haven't you been asked to input valid time? R U OK?"),QMessageBox::Ok);
    }
}

void day_event::deleteAll()
{
    int j = askDayIndex(cur);
    if (j != -1)
    {
        daydata.remove(j);
        maintain();
    }
    QMessageBox::information(this,tr("Success!"),tr("Delete All that can be deleted."),QMessageBox::Ok);
}

void day_event::deleteEvent(const int index)
{
    int j = askDayIndex(cur);
    daydata[j].memo_data.remove(index);
    daydata[j].moment_data.remove(index);
    daydata[j].cnt--;
    maintain();
    QMessageBox::information(this,tr("Success!"),tr("Finish Deleting."),QMessageBox::Ok);
}

void day_event::setColor()
{
    QColor brush = QColorDialog::getColor();
    if (brush.isValid())
        grid_color.setColor(brush);
    else
    {
        QMessageBox::information(this,tr("Failed!"),tr("Choose no color"),QMessageBox::Ok);
        return ;
    }
    int i = askDayIndex(cur);
    if (i == -1)
    {
        day_data tmp(cur);
        tmp.grid_color = brush;
        daydata.push_back(tmp);
    }
    else
        daydata[i].grid_color = brush;
    if (father != NULL)
    {
        QTextCharFormat cf = this->father->dateTextFormat(cur);
        cf.setBackground(grid_color);
        this->father->setDateTextFormat(cur, cf);
        QMessageBox::information(this,tr("Success!"),tr("Manage to set gird color"),QMessageBox::Ok);
    }
}

int askDayIndex(QDate date)
{
    for (int i = 0; i < daydata.size(); ++i)
        if (date == daydata[i].cur)
            return i;
    return -1;
}

/******************************************************************************************/

week_event::week_event(int index, QWidget *parent) : Event(parent)
{
    set_color->hide();
    weekindex = index;
    maintain();
}

void week_event::maintain()
{
    for (int i = 0; i < weekdata[weekindex].cnt; ++i)
        moment[i]->setText(weekdata[weekindex].moment_data[i].toString()),
        note[i]->setText(weekdata[weekindex].memo_data[i]),
        delete_event[i]->setEnabled(true);
    for (int i = weekdata[weekindex].cnt; i < 5; ++i)
        moment[i]->setText(QString()),
        note[i]->setText(QString()),
        delete_event[i]->setEnabled(false);
}

void week_event::check()
{
    int tmp = weekdata[weekindex].cnt + maxCntInMonth(),maxx = 0;
    for (int i = 0; i < daydata.size(); ++i)
        if (daydata[i].cur.dayOfWeek() == weekindex)
            maxx = maxx>daydata[i].cnt?maxx:daydata[i].cnt;
    tmp += maxx;
    if (tmp >= 5)
        QMessageBox::information(0,tr("Failed!"),tr("Too many events have been added!"),QMessageBox::Ok);
    else
    {
        QTime tmp_time = QTime::fromString(QInputDialog::getText(this, tr("Time"), tr("Input valid time:")));
        if (!tmp_time.isNull())
        {
            QString tmp_event = QInputDialog::getText(this, tr("Event"), tr("Input event description:"));
            if (!tmp_event.isEmpty())
            {
                weekdata[weekindex].add(tmp_time, tmp_event);
                maintain();
            }
            else
            {
                QMessageBox::information(this, tr("Failed!"),tr("You have added nothing. We won't take space for useless time."),QMessageBox::Ok);
            }
        }
        else
            QMessageBox::information(this, tr("Failed!"),tr("Haven't you been asked to input valid time? R U OK?"),QMessageBox::Ok);
    }
}

void week_event::deleteAll()
{
    weekdata[weekindex].cnt = 0;
    weekdata[weekindex].memo_data.clear();
    weekdata[weekindex].moment_data.clear();
    maintain();
}

void week_event::deleteEvent(const int index)
{
    weekdata[weekindex].memo_data.remove(index);
    weekdata[weekindex].moment_data.remove(index);
    weekdata[weekindex].cnt--;
    maintain();
}



int week_event::maxCntInMonth()
{
    if (monthdata.empty()) return 0;
    int maxx = monthdata[0].cnt;
    for (int i = 1; i < monthdata.size(); ++i) maxx = monthdata[i].cnt>maxx?monthdata[i].cnt:maxx;
    return maxx;
}

/******************************************************************************************/

month_event::month_event(QDate date, QWidget *parent) : Event(parent)
{
    set_color->hide();
    cur = date;
    maintain();
}

void month_event::maintain()
{
    int i = askMonthIndex(cur.year(), cur.month());
    if (i != -1)
    {
        for (int j = 0; j < monthdata[i].cnt; ++j)
            moment[j]->setText(monthdata[i].moment_data[j].toString()),
            note[j]->setText(monthdata[i].memo_data[j]),
            delete_event[j]->setEnabled(true);
        for (int j = monthdata[i].cnt; j < 5; ++j)
            moment[j]->setText(QString()),
            note[j]->setText(QString()),
            delete_event[j]->setEnabled(false);
    }
    else
        for (int j = 0; j < 5; ++j)
            moment[j]->setText(QString()),
            note[j]->setText(QString()),
            delete_event[j]->setEnabled(false);
}

void month_event::check()
{
    int tmp = 0, i = askMonthIndex(cur.year(), cur.month()), maxx = maxCntInWeek();
    if (i != -1)
        tmp = monthdata[i].cnt;
    for (int j = 0; j < daydata.size(); ++j)
        if (cur.year() == daydata[j].cur.year() && cur.month() == daydata[j].cur.month())
            maxx = std::max(daydata[j].cnt+weekdata[daydata[j].cur.dayOfWeek()].cnt, maxx);
    tmp += maxx;
    if (tmp >= 5)
        QMessageBox::information(0,tr("Failed!"),tr("Too many events have been added!"),QMessageBox::Ok);
    else
    {
        QTime tmp_time = QTime::fromString(QInputDialog::getText(this, tr("Time"), tr("Input valid time:")));
        if (!tmp_time.isNull())
        {
            QString tmp_event = QInputDialog::getText(this, tr("Event"), tr("Input event description:"));
            if (!tmp_event.isEmpty())
            {
                if (i == -1)
                {
                    month_data data_tmp(cur);
                    data_tmp.add(tmp_time, tmp_event);
                    monthdata.push_back(data_tmp);
                }
                else
                    monthdata[i].add(tmp_time, tmp_event);
                maintain();
            }
            else
            {
                QMessageBox::information(this, tr("Failed!"),tr("You have added nothing. We won't take space for useless time."),QMessageBox::Ok);
            }
        }
        else
            QMessageBox::information(this, tr("Failed!"),tr("Haven't you been asked to input valid time? R U OK?"),QMessageBox::Ok);
    }
}

int askMonthIndex(int year, int month)
{
    for (int i = 0; i < monthdata.size(); ++i)
        if (monthdata[i].year == year && month == monthdata[i].month)
            return i;
    return -1;
}

void month_event::deleteAll()
{
    int j = askMonthIndex(cur.year(), cur.month());
    if (j != -1)
    {
        monthdata.remove(j);
        maintain();
    }
    QMessageBox::information(this,tr("Success!"),tr("Delete All that can be deleted."),QMessageBox::Ok);
}

void month_event::deleteEvent(const int index)
{
    int j = askMonthIndex(cur.year(), cur.month());
    monthdata[j].memo_data.remove(index);
    monthdata[j].moment_data.remove(index);
    monthdata[j].cnt--;
    maintain();
    QMessageBox::information(this,tr("Success!"),tr("Finish Deleting."),QMessageBox::Ok);
}

int month_event::maxCntInWeek()
{
    int maxx = weekdata[1].cnt;
    for (int i = 2; i < 8; ++i) maxx = weekdata[i].cnt>maxx?weekdata[i].cnt:maxx;
    return maxx;
}
