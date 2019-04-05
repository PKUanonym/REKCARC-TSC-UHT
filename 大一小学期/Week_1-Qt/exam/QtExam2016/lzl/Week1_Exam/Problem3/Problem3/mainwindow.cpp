#include "mainwindow.h"
#include "calendar.h"
#include "ui_mainwindow.h"
#include "event.h"
#include <QWidget>
#include <QDebug>
#include <QFileDialog>
#include <QFile>
#include <QMouseEvent>
#include <QTimer>

extern QVector <day_data> daydata;
extern event_data weekdata[8];
extern QVector <month_data> monthdata;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    cale = ui->calendarWidget;
    connect(ui->actionSave,SIGNAL(triggered()),this,SLOT(save_event()));
    connect(ui->actionLoad,SIGNAL(triggered()),this,SLOT(load_event()));
    QObject::connect(cale,SIGNAL(activated(const QDate &)),cale,SLOT(addNote(const QDate &)));
    window_long = 0;
    ui->pushButton->setParent(cale);
    ui->pushButton->setParent(cale);
    ui->pushButton_1->setParent(cale);
    ui->pushButton_2->setParent(cale);
    ui->pushButton_3->setParent(cale);
    ui->pushButton_4->setParent(cale);
    ui->pushButton_5->setParent(cale);
    ui->pushButton_6->setParent(cale);
    ui->pushButton_7->setParent(cale);
    ui->radioButton_8->setParent(cale);
    mainwindow = new QMainWindow(0);
    ui->checkBox_8->setParent(mainwindow);
    mainwindow->setCentralWidget(ui->checkBox_8);
    mainwindow->setGeometry(50,50,350,70);
    ui->dateTimeEdit->setDateTime(QDateTime::currentDateTime());
    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), ui->dateTimeEdit, SLOT(update()));
    timer->start(1000);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::update()
{
    QTimer::singleShot(1000, this, SLOT(procceed()));
    ui->dateTimeEdit->setDateTime(QDateTime::currentDateTime());
}

void MainWindow::on_pushButton_1_clicked()
{
    week_event cur(1, this);
    cur.exec();
}

void MainWindow::on_pushButton_2_clicked()
{
    week_event cur(2, this);
    cur.exec();
}

void MainWindow::on_pushButton_3_clicked()
{
    week_event cur(3, this);
    cur.exec();
}

void MainWindow::on_pushButton_4_clicked()
{
    week_event cur(4, this);
    cur.exec();
}

void MainWindow::on_pushButton_5_clicked()
{
    week_event cur(5, this);
    cur.exec();
}

void MainWindow::on_pushButton_6_clicked()
{
    week_event cur(6, this);
    cur.exec();
}

void MainWindow::on_pushButton_7_clicked()
{
    week_event cur(7, this);
    cur.exec();
}

void MainWindow::on_pushButton_clicked()
{
    month_event cur(this->cale->selectedDate(),this);
    cur.exec();
}


void MainWindow::on_checkBox_8_toggled(bool checked)
{
    if (!checked)
    {
        /*
        this->setWindowFlags(0);
        this->raise();
        this->setWindowOpacity(1);
        this->unlockAndStayTop();
        cale->unlockAndStayTop();
        ui->pushButton->unlockAndStayTop();
        ui->pushButton_1->unlockAndStayTop();
        ui->pushButton_2->unlockAndStayTop();
        ui->pushButton_3->unlockAndStayTop();
        ui->pushButton_4->unlockAndStayTop();
        ui->pushButton_5->unlockAndStayTop();
        ui->pushButton_6->unlockAndStayTop();
        ui->pushButton_7->unlockAndStayTop();
        ui->radioButton_8->unlockAndStayTop();
        this->show();
        */
        mainwindow->show();
        this->unlockAndStayTop();
        mainwindow->raise();
        mainwindow->show();
    }
    else
    {
        /*this->setWindowFlags(Qt::FramelessWindowHint);
        this->setWindowOpacity(0.5);
        ui->pushButton->lockAndStayBottom();
        ui->pushButton_1->lockAndStayBottom();
        ui->pushButton_2->lockAndStayBottom();
        ui->pushButton_3->lockAndStayBottom();
        ui->pushButton_4->lockAndStayBottom();
        ui->pushButton_5->lockAndStayBottom();
        ui->pushButton_6->lockAndStayBottom();
        ui->pushButton_7->lockAndStayBottom();
        ui->radioButton_8->lockAndStayBottom();
        cale->lockAndStayBottom();
        this->lockAndStayBottom();
        this->lower();
        this->show();
        */
        this->lockAndStayBottom();
    }
}

void MainWindow::save_event()
{
    QString address = QFileDialog::getSaveFileName(this,tr("Save as"),"/",tr("FilterName(*.event)"));
    if (!address.isNull())
    {
        QFile file(address);
        if (file.exists()) file.remove();
        file.open( QIODevice::ReadWrite);
        {
            QTextStream s( &file );
            s << "Day Event:" << "\n";
            for (QVector<day_data>::Iterator it = daydata.begin(); it != daydata.end(); ++it)
                it -> output(s);
            s << "Week Event:" << "\n";
            s << "Monday:" << "\n";
            weekdata[1].output(s);
            s << "Tuesday:" << "\n";
            weekdata[2].output(s);
            s << "Wednesday:" << "\n";
            weekdata[3].output(s);
            s << "Thursday:" << "\n";
            weekdata[4].output(s);
            s << "Friday:" << "\n";
            weekdata[5].output(s);
            s << "Saturday:" << "\n";
            weekdata[6].output(s);
            s << "Sunday:" << "\n";
            weekdata[7].output(s);
            s << "Month Event:" << "\n";
            for (QVector<month_data>::Iterator it = monthdata.begin(); it != monthdata.end(); ++it)
                it->output(s);
            file.close();
        }
    }
}

void MainWindow::load_event()
{
    QString address = QFileDialog::getOpenFileName(this,tr("Load"),"/",tr("FilterName(*.event)"));
    if (!address.isNull())
    {
        QFile file(address);
        file.open( QIODevice::ReadWrite);
        {
            while (!daydata.empty())
            {
                QTextCharFormat cf = cale->dateTextFormat(daydata.last().cur);
                cf.setBackground(Qt::white);
                cale->setDateTextFormat(daydata.last().cur, cf);
                daydata.pop_back();
            }
            for (int i = 0; i < 8; ++i)
                weekdata[i] = event_data();
            monthdata.clear();
            QTextStream s( &file );
            s.readLine();
            QString input = s.readLine();
            while (input == "Date: ")
            {
                QString input2 = s.readLine(), event;
                QTime time;
                QDate date = QDate::fromString(input2);
                input2 = s.readLine();
                input2 = s.readLine();
                QColor color = QColor(input2);
                QTextCharFormat cf = cale->dateTextFormat(date);
                cf.setBackground(color);
                cale->setDateTextFormat(date, cf);
                day_data tmp(date, color);
                input2 = s.readLine();
                while (input2.left(5) == "Event")
                {
                    time = QTime::fromString(s.readLine());
                    event = s.readLine();
                    input2 = s.readLine();
                    tmp.add(time, event);
                }
                daydata.push_back(tmp);
                input = input2;
            }
            input = s.readLine();
            for (int i = 1; i < 8; ++i)
            {
                QString input2 = s.readLine();
                while (input2.left(5) == "Event")
                {
                    input2 = s.readLine();
                    QTime time = QTime::fromString(input2);
                    input2 = s.readLine();
                    weekdata[i].add(time, input2);
                    input2 = s.readLine();
                }
            }
            input = s.readLine();
            while (!input.isNull())
            {
                int year, month;
                QString input2 = s.readLine();
                year = input2.toInt();
                input2 = s.readLine();
                input2 = s.readLine();
                month = input2.toInt();
                QDate date = QDate(year, month, 1);
                month_data tmp(date);
                input2 = s.readLine();

                while (input2.left(5) == "Event")
                {
                    QTime time = QTime::fromString(s.readLine());
                    input2 = s.readLine();
                    tmp.add(time, input2);
                    input2 = s.readLine();
                }
                monthdata.push_back(tmp);
                input = input2;
            }
        }
        file.close();
    }
}

void MainWindow::on_radioButton_8_toggled(bool checked)
{
    if (!checked)
    {
        //setAcceptDrops(false);
        cale->setAcceptDrops(false);
    }
    else
    {
        //setAcceptDrops(true);
        cale->setAcceptDrops(true);
    }
}

void MainWindow::setEnglish()
{
    QLocale locale = QLocale(QLocale::English, QLocale::UnitedStates);
    cale->setLocale(locale);
}

void MainWindow::unlockAndStayTop()
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
void MainWindow::lockAndStayBottom()
{
    setWindowOpacity(0.5);
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnBottomHint);
    show();
    lower();
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long | WS_EX_TRANSPARENT | WS_EX_LAYERED);
}
