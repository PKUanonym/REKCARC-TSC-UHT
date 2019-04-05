#ifndef CALENDAR_H
#define CALENDAR_H

#include<QCalendarWidget>
#include <QPainter>
#include <QColor>
#include <QDate>
#include <QPen>
#include <QBrush>
#include <QVector>
#include <QSystemTrayIcon>
#include <QTextEdit>
#include <windows.h>

QT_BEGIN_NAMESPACE
class QDragEnterEvent;
class QDropEvent;
QT_END_NAMESPACE

class calendar: public QCalendarWidget
{
    Q_OBJECT
public:
    calendar(QWidget *parent = NULL);
    ~calendar();

    void setColor(QColor& color);

    QColor getColor();
protected:
    virtual void paintCell(QPainter * painter, const QRect & rect, const QDate & date) const;
    void dragEnterEvent(QDragEnterEvent *event);
    void dropEvent(QDropEvent *event);
    void mousePressEvent(QMouseEvent *event);

public slots:
    void addNote( const QDate & );
    void unlockAndStayTop();
    void lockAndStayBottom();

private:
    QDate m_currentDate;
    QPen m_outlinePen;
    QBrush m_transparentBrush;

    int window_long;
    //QSystemTrayIcon* system_tray;

    QVector<QDate> dates;
    QVector<QString> todolist;

    //QTextEdit *textEdit;
    //QString file_name;
};

#endif // CALENDAR_H

