#include "calendar.h"
#include <QtWidgets>
#include <QInputDialog>
#include <QTextCharFormat>
#include <QDebug>
#include <QtGlobal>
#include "draglabel.h"


calendar::calendar(QWidget *parent):QCalendarWidget(parent)
{
    drop_open = 1;
    m_outlinePen.setColor(Qt::red);
    m_transparentBrush.setColor(Qt::blue);
    setAcceptDrops(true);
    QObject::connect(this,SIGNAL(activated(const QDate &)),this,SLOT(addNote(const QDate &)));
    dir = "A:\\mycode\\file\\";
}

calendar::~calendar()
{

}
void calendar::fixon()
{
    /*XRectangle w;
    w.x = 0;
    w.y = 0;
    w.height = height();
    w.width = width();
    XShapeCombineRectangles(QX11Info::display(),winId(),ShapeInput,0,0,w,0,ShapeSet,YXBanded);*/
}
void calendar::fixoff()
{
  /*  XRectangle w;
    w.x = 0;
    w.y = 0;
    w.height = height();
    w.width = width();
    XShapeCombineRectangles(QX11Info::display(),winId(),ShapeInput,0,0,w,1,ShapeSet,YXBanded);*/
}
void calendar::acdropt()
{
    qDebug("setACD true");
    setAcceptDrops(true);
}
void calendar::acdropf()
{
    qDebug("setACD false");
    setAcceptDrops(false);
}
void calendar::get_day_edit_changed(QDate date,dateinfo info)
{
    qDebug("00159");
    qDebug("R%d",info.get_back_ground().red());
    info.sort();
    if(dates.contains(date))
    {
        int index = dates.indexOf(date);
        todolist.replace(index, info);
    }
    else
    {
        dates.append(date);
        todolist.append(info);
    }
    repaint();
}
void calendar::addNote( const QDate &date )
{
    qDebug()<<"come in addNote"<<endl;
    dateinfo w;
    int ind;
    if(dates.contains(date))
    {
        ind = dates.indexOf(date);
        w = todolist[ind];
    }
    //qDebug()<<"AAA"<<endl;
    celledit dlg(date,w,this);
    connect(&dlg,SIGNAL(changed(QDate,dateinfo)),this,SLOT(get_day_edit_changed(QDate,dateinfo)));
    dlg.exec();
    //qDebug()<<"bbb"<<endl;
}

void calendar::setColor(QColor& color)
{
   m_outlinePen.setColor(color);
}

QColor calendar::getColor()
{
   return (m_outlinePen.color());
}

void calendar::paintCell(QPainter *painter, const QRect &rect, const QDate &date)const
{
   //qDebug()<<"come in paintCell"<<endl;
   QCalendarWidget::paintCell(painter, rect, date);
   Q_ASSERT(dates.size()==todolist.size());
   for (int i = 0; i < dates.size(); i++)
   {
       if (date == dates.at(i))
       {
           colortmp = todolist[i].get_back_ground();
           m_transparentBrush.setColor(colortmp);
           colortmp = todolist[i].get_text_color();
           m_outlinePen.setColor(colortmp);
           stringtmp="";
           if(!todolist[i].file_url.isEmpty())
           {
               stringtmp += "*";
               stringtmp += todolist[i].file_url;
               stringtmp += "\n";
           }
           for(int j = 1;j < todolist[i].get_sch_list().size();++j)
           {
               stringtmp += todolist[i].get_sch_list()[j].start_time().toString();
               stringtmp += "-";
               stringtmp += todolist[i].get_sch_list()[j].end_time().toString();
               stringtmp += " ";
               stringtmp += todolist[i].get_sch_list()[j].describe();
               stringtmp += "\n";
           }
           m_transparentBrush.setStyle(Qt::SolidPattern);
           m_outlinePen.setStyle(Qt::SolidLine);
           painter->setPen(m_outlinePen);
           painter->setBrush(m_transparentBrush);
           painter->drawRect(rect.adjusted(0, 0, -1, -1));
           painter->drawText(rect,stringtmp);
       }
   }

}
void calendar::dragEnterEvent(QDragEnterEvent *event)
{
    if(!drop_open)return;
    //如果为文件，则支持拖放
    if (event->mimeData()->hasFormat("text/uri-list"))
        event->acceptProposedAction();
}

//当用户放下这个文件后，就会触发dropEvent事件
void calendar::dropEvent(QDropEvent *event)
{
    if(!drop_open)return;
    if(selectedDate().isNull())
    {
        QMessageBox::about(NULL, tr("Error"), tr("<font color='red'>No date has been selected!</font>"));
        return;
    }
    qDebug("drop");
    QList<QUrl> urls = event->mimeData()->urls();
    if(urls.isEmpty())
        return;
    foreach(QUrl url, urls) {
        file_name = url.path().mid(1,url.path().count()-1);
        qDebug()<<file_name;
        func w;
        QString tmp;
        tmp = dir + url.fileName();
        qDebug()<<"tmp="<<tmp;
        w.copyFile(file_name,tmp);
        bool flag = 0;
        for (int i = 0; i < dates.size(); i++)
        {
            if (selectedDate() == dates.at(i))
            {
                todolist[i].file_url = url.fileName();
                qDebug("Signed");
                flag = 1;
            }
        }
        if(!flag)
        {
            dates.append(selectedDate());
            dateinfo y;
            y.file_url = url.fileName();
            todolist.append(y);
        }
    }
}


void calendar::mousePressEvent(QMouseEvent *event)
{
    if(!drop_open)return;
    qDebug()<<event->pos();
    QMimeData *QD = new QMimeData;
    QList<QUrl> urls;
    urls.append(QUrl::fromLocalFile(file_name));
    QD->setUrls(urls);
    //QApplication::clipboard()->setMimeData(QD);
    QDrag *drag = new QDrag(this);
    drag->setMimeData(QD);
    drag->start();
    qDebug()<<file_name<<urls;
}
