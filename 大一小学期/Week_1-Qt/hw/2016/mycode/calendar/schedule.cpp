#include "schedule.h"

schedule::schedule()
{
    Start_time = QTime();
    End_time = QTime();
    Describe = "";
}

schedule::~schedule()
{

}

QString schedule::describe()
{
    return Describe;
}

QTime schedule::start_time()
{
    return Start_time;
}

QTime schedule::end_time()
{
    return End_time;
}

void schedule::set_describe(QString new_describe)
{
    Describe = new_describe;
}

void schedule::set_start_time(QTime new_time)
{
    Start_time = new_time;
}

void schedule::set_end_time(QTime new_time)
{
    End_time = new_time;
}

bool schedule::operator < (const schedule &c2) const
{
    if(Start_time != c2.Start_time)
        return Start_time < c2.Start_time;
    if(End_time != c2.End_time)
        return End_time < c2.End_time;
    if(Describe == "")
        return 1;
    return 0;
}

bool schedule::operator == (const schedule &c2) const
{
    return /*Start_time==c2.Start_time&&End_time==c2.End_time&&*/Describe==c2.Describe;
}
