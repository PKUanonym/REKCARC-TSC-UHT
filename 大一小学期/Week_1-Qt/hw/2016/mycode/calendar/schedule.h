#ifndef SCHEDULE_H
#define SCHEDULE_H

#include <QObject>
#include <QString>
#include <QTime>
class schedule
{
public:
    schedule();
    ~schedule();
    QString describe();
    QTime start_time();
    QTime end_time();
    void set_describe(QString new_describe);
    void set_start_time(QTime new_time);
    void set_end_time(QTime new_time);
    bool operator < (const schedule &c2) const;
    bool operator == (const schedule &c2) const;
private:
    QString Describe;
    QTime Start_time,End_time;
};

#endif // SCHEDULE_H
