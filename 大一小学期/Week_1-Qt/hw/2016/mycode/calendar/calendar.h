#ifndef CALENDAR_H
#define CALENDAR_H

#include<QCalendarWidget>
#include <QPainter>
#include <QColor>
#include <QDate>
#include <QPen>
#include <QBrush>
#include <QVector>
#include <QObject>
#include <QDir>
//#include <X11/extensions/shape.h>
#include "dateinfo.h"
#include "celledit.h"
#include "func.h"
QT_BEGIN_NAMESPACE
class QDragEnterEvent;
class QDropEvent;
QT_END_NAMESPACE
class calendar: public QCalendarWidget
{
    Q_OBJECT
public:
    calendar(QWidget *parent = 0);
    ~calendar();

    void setColor(QColor& color);
    QColor getColor();
    void paintCell(QPainter * painter, const QRect & rect, const QDate & date)const;

public slots:
    void addNote( const QDate & );
    void get_day_edit_changed(QDate,dateinfo);
    void acdropt();
    void acdropf();
    void fixon();
    void fixoff();
public:
    mutable QDate m_currentDate;
    mutable QPen m_outlinePen;
    mutable QBrush m_transparentBrush;
    mutable QColor colortmp;
    mutable QString stringtmp;
    mutable QVector<QDate> dates;
    mutable QVector<dateinfo> todolist;
    QString file_name,dir;
protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dropEvent(QDropEvent *event);
    void mousePressEvent(QMouseEvent *event);

private:
    bool drop_open;
};

#endif // CALENDAR_H
