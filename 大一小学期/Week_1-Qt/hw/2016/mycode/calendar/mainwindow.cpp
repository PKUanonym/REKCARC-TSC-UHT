#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    abc(new QTranslator)
{
    ui->setupUi(this);
    flag = 0;
    ui->calendarWidget->installEventFilter(this);
    abc->load("ch.qm");
    connect(this,SIGNAL(changed(QDate,dateinfo)),ui->calendarWidget,SLOT(get_day_edit_changed(QDate,dateinfo)));
    connect(ui->actionOn,SIGNAL(triggered()),ui->calendarWidget,SLOT(acdropt()));
    connect(ui->actionOff,SIGNAL(triggered()),ui->calendarWidget,SLOT(acdropf()));
    connect(ui->actionYes,SIGNAL(triggered()),ui->calendarWidget,SLOT(fixon()));
    connect(ui->actionNo,SIGNAL(triggered()),ui->calendarWidget,SLOT(fixoff()));
    connect(ui->actionno,SIGNAL(triggered()),this,SLOT(set_no()));
    connect(ui->actionlow,SIGNAL(triggered()),this,SLOT(set_low()));
    connect(ui->actionhigh,SIGNAL(triggered()),this,SLOT(set_high()));
    connect(ui->actionFetch_from_file,SIGNAL(triggered()),this,SLOT(choose_file_1()));
    connect(ui->actionPreservation_to_file,SIGNAL(triggered()),this,SLOT(choose_file_2()));
}

MainWindow::~MainWindow()
{
    delete ui;
}
void MainWindow::set_low()
{
    setWindowOpacity(0.75);
    if(flag)
    setAttribute(Qt::WA_TranslucentBackground, true);
}
void MainWindow::set_high()
{
    setWindowOpacity(0.5);
    if(flag)
    setAttribute(Qt::WA_TranslucentBackground, true);
}
void MainWindow::set_no()
{
    setWindowOpacity(1.0);
    setAttribute(Qt::WA_TranslucentBackground, false);
}

void MainWindow::on_actionAdd_schedule_triggered()
{
    addschbatch w;
    connect(&w,SIGNAL(batchadd(QDate,schedule,int,int,int)),this,SLOT(batchadd(QDate,schedule,int,int,int)));
    w.exec();
}
void MainWindow::batchadd(QDate nday,schedule w,int zq,int type,int tim)
{
    for(int i=0;i<=tim;++i)
    {
        QDate date;
        if(type==0)
            date = nday.addDays(zq*i);
        if(type==1)
            date = nday.addMonths(zq*i);
        if(type==2)
            date = nday.addYears(zq*i);
        if(ui->calendarWidget->dates.contains(date))
        {
            int index = ui->calendarWidget->dates.indexOf(date);
            dateinfo info = ui->calendarWidget->todolist.at(index);
            info.add_sch(w);
            ui->calendarWidget->todolist.replace(index, info);
        }
        else
        {
            dateinfo *info = (new dateinfo);
            info->add_sch(w);
            ui->calendarWidget->dates.append(date);
            ui->calendarWidget->todolist.append(*info);
        }
    }
}

void MainWindow::choose_file_1()
{
    QString file = QFileDialog::getOpenFileName();
    in_port(file);
}
void MainWindow::choose_file_2()
{
    QString file = QFileDialog::getOpenFileName();
    ex_port(file);
}
void MainWindow::in_port(QString urls)
{
    qDebug()<<urls;
    if(urls.isEmpty())return;
    QFile file(urls);
    if(!file.open(QFile::ReadOnly|QFile::Text))
    {
        QMessageBox::information(NULL, QString("Error"), QString("open error!"));
        return;
    }
    QDomDocument doc;
    QString error;
    int row = 0, column = 0;
    if(!doc.setContent(&file, false, &error, &row, &column))
    {
        QMessageBox::information(NULL, QString("Error"), QString("parse file failed at line row and column") + QString::number(row, 10) + QString(",") + QString::number(column, 10));
        return;
    }
    if(doc.isNull())
    {
        QMessageBox::information(NULL, QString("Error"), QString("document is null!"));
        return;
    }
    qDebug("ufo777");
    QDomElement root = doc.documentElement();
    QDomNodeList h,p,w = root.childNodes();
    QDomNode tmp;
    qDebug()<<w.count();
    QDate nday;
    QColor bco,tco;
    schedule s,k;
    dateinfo u;
    int br,bg,bb,tr,tg,tb;
    for(int i = 0;i < w.count();++i)
    {
        tmp = w.item(i);
        /*qDebug("c %d",tmp.firstChild().isText());
        h = tmp.childNodes();
        qDebug("son %d\n",h.count());*/
        if(i % 4 == 0)
        {
            u.clear_sch();
            u.change_back_ground(QColor(255,255,255));
            u.change_text_color(QColor(0,0,0));
            u.add_sch(k);
            nday = QDate::fromString(tmp.firstChild().toText().data(),"yyyy-MM-dd");
            if(ui->calendarWidget->dates.contains(nday))
            {
                int ind = ui->calendarWidget->dates.indexOf(nday);
                u = ui->calendarWidget->todolist[ind];
            }
        }
        if(i % 4 == 1)
        {
            p = tmp.childNodes();
            br = p.item(0).firstChild().toText().data().toInt();
            bg = p.item(1).firstChild().toText().data().toInt();
            bb = p.item(2).firstChild().toText().data().toInt();
            bco = QColor(br,bg,bb);
            u.change_back_ground(bco);
        }
        if(i % 4 == 2)
        {
            p = tmp.childNodes();
            tr = p.item(0).firstChild().toText().data().toInt();
            tg = p.item(1).firstChild().toText().data().toInt();
            tb = p.item(2).firstChild().toText().data().toInt();
            tco = QColor(tr,tg,tb);
            u.change_text_color(tco);
        }
        if(i % 4 == 3)
        {
            p = tmp.childNodes();
            for(int j = 0;j < p.count();++j)
            {
                h=p.item(j).childNodes();
                s.set_describe(h.item(0).firstChild().toText().data());
                s.set_start_time(QTime::fromString(h.item(1).firstChild().toText().data(),"hh:mm:ss"));
                s.set_end_time(QTime::fromString(h.item(2).firstChild().toText().data(),"hh:mm:ss"));
                u.del_sch(s);
                u.add_sch(s);qDebug("00000");
            }
            emit changed(nday,u);
            qDebug("%d,%d",nday.month(),nday.day());
            qDebug("%d %d %d\n",tr,tg,tb);
            qDebug("R%d\n",u.get_back_ground().red());
            qDebug("R%d\n",u.get_text_color().red());
        }
    }
    QString w1,w2;
    w1 = this->tr("Info");
    w2 = this->tr("Completed");
    QMessageBox::about(NULL, w1, w2);
}
void MainWindow::ex_port(QString urls)
{
    qDebug()<<urls;
    QDomDocument doc;
    QDomNode instruction = doc.createProcessingInstruction("xml","version=\"1.0\" encoding=\"UTF-8\"");
    doc.appendChild(instruction);
    QDomElement root = doc.createElement("dates");
    doc.appendChild(root);
    for(int i = 0;i < ui->calendarWidget->dates.count();++i)
    {
        QDomElement tmp0 = doc.createElement("date"),tmp1,tmp2;
        root.appendChild(tmp0);
        QDomText tmp = doc.createTextNode(ui->calendarWidget->dates.at(i).toString("yyyy-MM-dd"));
        tmp0.appendChild(tmp);
        tmp0 = doc.createElement("back_ground_color");
        root.appendChild(tmp0);
        tmp1 = doc.createElement("red");
        tmp0.appendChild(tmp1);
        tmp = doc.createTextNode(QString::number(ui->calendarWidget->todolist.at(i).get_back_ground().red()));
        tmp1.appendChild(tmp);
        tmp1 = doc.createElement("green");
        tmp0.appendChild(tmp1);
        tmp = doc.createTextNode(QString::number(ui->calendarWidget->todolist.at(i).get_back_ground().green()));
        tmp1.appendChild(tmp);
        tmp1 = doc.createElement("blue");
        tmp0.appendChild(tmp1);
        tmp = doc.createTextNode(QString::number(ui->calendarWidget->todolist.at(i).get_back_ground().blue()));
        tmp1.appendChild(tmp);
        tmp0 = doc.createElement("text_color");
        root.appendChild(tmp0);
        tmp1 = doc.createElement("red");
        tmp0.appendChild(tmp1);
        tmp = doc.createTextNode(QString::number(ui->calendarWidget->todolist.at(i).get_text_color().red()));
        tmp1.appendChild(tmp);
        tmp1 = doc.createElement("green");
        tmp0.appendChild(tmp1);
        tmp = doc.createTextNode(QString::number(ui->calendarWidget->todolist.at(i).get_text_color().green()));
        tmp1.appendChild(tmp);
        tmp1 = doc.createElement("blue");
        tmp0.appendChild(tmp1);
        tmp = doc.createTextNode(QString::number(ui->calendarWidget->todolist.at(i).get_text_color().blue()));
        tmp1.appendChild(tmp);

        tmp0 = doc.createElement("schedule_list");
        root.appendChild(tmp0);
        for(int j = 1;j < ui->calendarWidget->todolist[i].get_sch_list().count();++j)
        {
            tmp1 = doc.createElement("schedule");
            tmp0.appendChild(tmp1);
            tmp2 = doc.createElement("describe");
            tmp1.appendChild(tmp2);
            tmp = doc.createTextNode(ui->calendarWidget->todolist[i].get_sch_list()[j].describe());
            tmp2.appendChild(tmp);
            tmp2 = doc.createElement("start_time");
            tmp1.appendChild(tmp2);
            tmp = doc.createTextNode(ui->calendarWidget->todolist[i].get_sch_list()[j].start_time().toString());
            tmp2.appendChild(tmp);
            tmp2 = doc.createElement("end_time");
            tmp1.appendChild(tmp2);
            tmp = doc.createTextNode(ui->calendarWidget->todolist[i].get_sch_list()[j].end_time().toString());
            tmp2.appendChild(tmp);
        }
    }
    QFile file(urls);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate |QIODevice::Text))
         return ;
    QTextStream out(&file);
    out.setCodec("UTF-8");
    doc.save(out,4,QDomNode::EncodingFromTextStream);
    file.close();
}
bool MainWindow::eventFilter(QObject *obj, QEvent *event)
 {
     if (obj->objectName() == "calendarWidget" && event->type()==event->MouseButtonPress)
            {
                 func kk;
                 QString from_url;
                 QDate ww;
                 from_url = ui->calendarWidget->dir;
                 ww = ui->calendarWidget->selectedDate();
                 for(int i = 0;i < ui->calendarWidget->dates.size();++i)
                    if(ui->calendarWidget->dates[i] == ww)
                    {
                        if(ui->calendarWidget->todolist[i].file_url == "")
                        {
                            //la = 11;
                            return false;
                        }
                        from_url += ui->calendarWidget->todolist[i].file_url;
                    }
                 //la = 11;
                 if(from_url == ui->calendarWidget->dir)return false;
                 QMimeData *QD = new QMimeData;
                 QList<QUrl> urls;
                 urls.append(QUrl::fromLocalFile(from_url));
                 QD->setUrls(urls);
                 //QApplication::clipboard()->setMimeData(QD);
                 QDrag *drag = new QDrag(this);
                 drag->setMimeData(QD);
                 drag->start();
             return true;
     } else {
         // pass the event on to the parent class
         return QMainWindow::eventFilter(obj, event);
     }
 }

void MainWindow::on_actionEnglish_triggered()
{
    abc->load("en_US.qm");
    qApp->installTranslator(abc);
}

void MainWindow::on_actionChinese_triggered()
{
    abc->load("cn_ZH.qm");
    qApp->installTranslator(abc);
}

void MainWindow::changeEvent(QEvent *e)
{
    QWidget::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void MainWindow::on_actionResign_triggered()
{
    resign w;
    connect(&w,SIGNAL(res(QString,QString)),this,SLOT(new_u(QString,QString)));
    w.exec();
}

void MainWindow::on_actionLogin_triggered()
{
    Login w;
    connect(&w,SIGNAL(loi(QString,QString)),this,SLOT(chk_u(QString,QString)));
    w.exec();
}
void MainWindow::new_u(QString usr,QString pwd)
{
    m_user.append(usr);
    m_pwd.append(pwd);
}
void MainWindow::chk_u(QString usr,QString pwd)
{
    for(int i = 0;i < m_user.size();++i)
        if(m_user[i]==usr&&m_pwd[i]==pwd)
        {
            QMessageBox::about(NULL, tr("Success"), tr("Login in succeed!"));
            return;
        }
    QMessageBox::about(NULL, tr("Failed"), tr("Login in failed!"));
}

void MainWindow::on_actionYes_triggered()
{
    qDebug()<<"Yes";
    if(flag)return;
    flag = 1;
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnBottomHint);
    show();
    lower();
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long | WS_EX_TRANSPARENT | WS_EX_LAYERED);
    setAttribute(Qt::WA_TranslucentBackground, true);
}

void MainWindow::on_actionNo_triggered()
{
    qDebug()<<"No";
    if(!flag)return;
    flag = 0;
    setWindowFlags(Qt::Window | Qt::Tool);
    show();
    raise();
    if (window_long == 0) {
        window_long = GetWindowLong((HWND)this->winId(), GWL_EXSTYLE);
    }
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long);
    setAttribute(Qt::WA_TranslucentBackground, false);
}
void MainWindow::mousePressEvent(QMouseEvent *event)
{
    qDebug()<<event->pos();
    QMimeData *QD = new QMimeData;
    QList<QUrl> urls;
    QStringList s;
    QDate w;
    w = ui->calendarWidget->selectedDate();
    for(int i = 0; i < ui->calendarWidget->todolist.size(); ++i)
        if(ui->calendarWidget->dates[i] == w)
        {
            if(ui->calendarWidget->todolist[i].file_url.isEmpty())return;
            s.append(ui->calendarWidget->dir + ui->calendarWidget->todolist[i].file_url);
            urls.append(QUrl::fromStringList(s));
            QD->setUrls(urls);
            //QApplication::clipboard()->setMimeData(QD);
            QDrag *drag = new QDrag(this);
            drag->setMimeData(QD);
            drag->start();
            qDebug()<<"MOVE"<<urls;
        }
}
