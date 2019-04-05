#ifndef EVENT_DATA
#define EVENT_DATA

#include <QDateTime>
#include <QBrush>
#include <QVector>
#include <QString>
#include <QTextStream>

class event_data
{
public:
    event_data();
    ~event_data();
    int cnt;
    QVector <QString> memo_data;
    QVector <QTime> moment_data;
    void add(QTime time, QString memo);
    void output(QTextStream& s);

private:

};

class day_data : public event_data
{
public:
    day_data(QDate date = QDate(), QColor color = Qt::white);
    ~day_data();
    QDate cur;
    QColor grid_color;
    void output(QTextStream& s);

};

class month_data : public event_data
{
public:
    month_data(QDate date = QDate());
    ~month_data();
    int year, month;
    void output(QTextStream& s);

};

#endif // EVENT_DATA

