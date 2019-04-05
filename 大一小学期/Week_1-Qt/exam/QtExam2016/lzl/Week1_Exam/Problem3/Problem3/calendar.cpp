#include "calendar.h"
#include "event.h"
#include <QtWidgets>
#include <QInputDialog>
#include <QTextCharFormat>
#include <QDebug>
#include <QtGlobal>
#include <windows.h>

calendar::calendar(QWidget *parent) : QCalendarWidget(parent)
{
    m_outlinePen.setColor(Qt::blue);
    m_transparentBrush.setColor(Qt::white);
    setAcceptDrops(false);

    window_long = 0;
}

calendar::~calendar()
{

}


void calendar::addNote( const QDate &date )
{
    day_event cur(date, this);
    cur.exec();
}

void calendar::setColor(QColor& color)
{
   m_outlinePen.setColor(color);
}

QColor calendar::getColor()
{
   return (m_outlinePen.color());
}

void calendar::paintCell(QPainter *painter, const QRect &rect, const QDate &date) const
{
   //qDebug()<<"come in paintCell"<<endl;
   QCalendarWidget::paintCell(painter, rect, date);
   Q_ASSERT(dates.size()==todolist.size());
   for (int i = 0; i < dates.size(); i++)
   {
       if (date == dates.at(i))
       {
           painter->setPen(m_outlinePen);
           painter->setBrush(m_transparentBrush);
           painter->drawRect(rect.adjusted(0, 0, -1, -1));
           painter->drawText(rect,todolist.at(i));
       }
   }

}

void calendar::dragEnterEvent(QDragEnterEvent *event)
{
    if (event->mimeData()->hasFormat("text/uri-list"))
        event->acceptProposedAction();
}

void calendar::dropEvent(QDropEvent *event)
{
    QList<QUrl> urls = event->mimeData()->urls();
    if(urls.isEmpty())
        return;

    foreach(QUrl url, urls) {
        QString file_name = url.toLocalFile();
        QDate date = selectedDate();
        if (dates.contains(date))
        {
            int index = dates.indexOf(date);
            todolist[index] += "\n" + file_name;
        }
        else
        {
            todolist.append(file_name);
            dates.append(date);
        }
    }
}

void calendar::mousePressEvent(QMouseEvent *event)
{
    QDate date = selectedDate();
    if (!dates.contains(date)) return;
    int index = dates.indexOf(date);
    QMimeData *QD = new QMimeData;
    QList<QUrl> urls;
    urls.append(QUrl::fromLocalFile(todolist[index]));
    QD->setUrls(urls);
    QDrag *drag = new QDrag(this);
    drag->setMimeData(QD);
    drag->start();
}

void calendar::unlockAndStayTop()
{
    setWindowOpacity(1);
    setWindowFlags(0);
    show();
    raise();

    if (window_long == 0)
    {
        window_long = GetWindowLong((HWND)this->winId(), GWL_EXSTYLE);
    }
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long);
}
void calendar::lockAndStayBottom()
{
    setWindowOpacity(0.1);
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnBottomHint);
    show();
    lower();
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long | WS_EX_TRANSPARENT | WS_EX_LAYERED);
}


