#include "mainwindow.h"
#include "ui_mainwindow.h"

void MainWindow::endingGIF(int result)
{
    jsbool = true;
    ui->label_2->setVisible(false);
    ui->label_2->setEnabled(false);
    //delete movie;

    label = new QLabel(this);
    label->setGeometry(0,0,1000,600);

    movie = new QMovie("C:/coding/chess/gif/" + QString::number(result) + "1.gif");
    movie->setScaledSize(QSize(1000,600));
    label->setMovie(movie);
    label->show();
    movie->start();

    QObject::connect(movie, &QMovie::frameChanged, [=](int frameNumber)
    {
        if (frameNumber == movie->frameCount() - 1)
        {
            movie->stop();
            delete movie;

            tempButton = new QPushButton(this);
            tempButton->setGeometry(890,490,100,100);
            tempButton->setStyleSheet("background-color: rgba(0,0,0,0)");
            tempButton->setCursor(QCursor(Qt::PointingHandCursor));
            tempButton->show();
            connect(tempButton,SIGNAL(clicked(bool)),this,SLOT(exitButtonclicked()));

            movie = new QMovie("C:/coding/chess/gif/" + QString::number(result) + "2.gif");
            movie->setScaledSize(QSize(1000,600));
            label->setMovie(movie);
            movie->start();
        }
    });
}

void MainWindow::opGIF()
{
    movie = new QMovie("C:/coding/chess/gif/start.gif");
    movie->setScaledSize(QSize(1000,600));
    label = new QLabel(this);
    label->setGeometry(0,0,1000,600);
    label->setMovie(movie);
    movie->start();

    QObject::connect(movie, &QMovie::frameChanged, [=](int frameNumber)
    {
        if (frameNumber == movie->frameCount() - 1)
        {
            movie->stop();
            tempButton = new QPushButton(this);
            tempButton->setGeometry(530,430,461,141);
            tempButton->setStyleSheet("background-color: rgba(0,0,0,0)");
            tempButton->setCursor(QCursor(Qt::PointingHandCursor));
            tempButton->show();
            connect(tempButton,SIGNAL(clicked(bool)),this,SLOT(startButtonclicked()));
        }
    });
}

void MainWindow::deleteGIF(int tar)
{
    for (int i = 248; i <= 275; i++)
    {
        QPixmap ttt("C:/Coding/chess/pic/boom/" + QString::number(i) + ".png");
        QIcon * tt = new QIcon(ttt);
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* tt);
        ActiveMap[tar]->show();
        waittime(10);
        delete tt;
    }
    ActiveMap[tar]->setIconSize(QSize(30,30));
    ActiveMap[tar]->setIcon(* empt);
    ActiveMap[tar]->show();
}

void MainWindow::beginfightgif()
{
    movie = new QMovie("C:/coding/chess/gif/fight.gif");
    movie->setScaledSize(QSize(1000,600));
    label = new QLabel(this);
    label->setGeometry(0,0,1000,600);
    label->setMovie(movie);
    label->show();
    movie->start();

    QObject::connect(movie, &QMovie::frameChanged, [=](int frameNumber)
    {
        if (frameNumber == movie->frameCount() - 1)
        {
            label->lower();
        }
    });
}

void MainWindow::luGIF()
{
    movie = new QMovie("C:/coding/chess/gif/lu.gif");
    movie->setScaledSize(QSize(156,152));
    ui->label_2->setMovie(movie);
    movie->start();    
}
