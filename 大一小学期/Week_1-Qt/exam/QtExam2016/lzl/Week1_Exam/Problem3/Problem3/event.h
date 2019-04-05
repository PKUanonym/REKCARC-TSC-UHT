#ifndef EVENT
#define EVENT

#include <QVector>
#include <QCalendarWidget>
#include <QLayout>
#include <QLabel>
#include <QDialog>
#include <QWidgetList>
#include <QPushButton>
#include <QLineEdit>
#include <QDateTime>
#include "event_data.h"

class Event : public QDialog
{
    Q_OBJECT
public:
    Event(QWidget *parent = NULL);
    ~Event();
    QPushButton *add_event, *delete_event[5], *delete_all, *set_color;
    QLabel* moment[5], *note[5];

public slots:
    virtual void maintain() = 0;
    virtual void check() = 0;
    virtual void deleteAll() = 0;
    virtual void deleteEvent(const int index) = 0;
};

/******************************************************************************************/

class day_event : public Event
{
    Q_OBJECT
public:
    day_event(QDate date, QCalendarWidget *parent = NULL);
    ~day_event();
    QDate cur;
    QBrush grid_color;
    QCalendarWidget *father;

public slots:
    void check();
    void deleteAll();
    void deleteEvent(const int index);
    void setColor();
    void maintain();
};

/******************************************************************************************/

class week_event : public Event
{
    Q_OBJECT
public:
    week_event(int index, QWidget *parent = NULL);
    ~week_event() {}
    int weekindex;

public slots:
    void maintain();
    void check();
    void deleteAll();
    void deleteEvent(const int index);
    int maxCntInMonth();
};

/******************************************************************************************/

class month_event : public Event
{
    Q_OBJECT
public:
    month_event(QDate date, QWidget *parent = NULL);
    ~month_event() {}
    QDate cur;

public slots:
    void maintain();
    void check();
    void deleteAll();
    void deleteEvent(const int index);
    int maxCntInWeek();
};
#endif // EVENT
