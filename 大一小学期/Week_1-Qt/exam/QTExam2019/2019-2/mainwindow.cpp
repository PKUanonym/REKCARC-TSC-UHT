#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    mapper = new QSignalMapper(this);
    int c = 1;
    for (auto obj: ui->frame->children())
    {
        QPushButton *p = static_cast<QPushButton *>(obj);
        connect(p, SIGNAL(clicked()), mapper, SLOT(map()));
        mapper->setMapping(p, c++);
    }
    connect(mapper, SIGNAL(mapped(int)), this, SLOT(display(int)));
    timer = new QTimer;
    connect(timer, SIGNAL(timeout()), this, SLOT(next()));
    timer->start(2000);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::display(int p)
{
    now = p;
    timer->stop();
    timer->start(2000);
    QString imageFile = QString("C:/WorkSpace/QTE/2/%1.jpg").arg(p);
    QImage *image = new QImage;
    image->load(imageFile);
    ui->pic->setPixmap(QPixmap::fromImage(*image));
    QString soundFile = QString("C:/WorkSpace/QTE/2/%1.wav").arg(p);
    QMediaPlayer *player = new QMediaPlayer;
    player->setMedia(QUrl::fromLocalFile(soundFile));
    player->setVolume(10);
    player->play();
    return;
}


void MainWindow::next()
{
    now = now % 4;
    now ++;
    return display(now);
}
