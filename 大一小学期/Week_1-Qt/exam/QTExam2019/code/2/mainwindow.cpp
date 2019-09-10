#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(&t, SIGNAL(timeout()),this,SLOT(changeID()));
    t.setInterval(2000);
    jpg[0]=QString(":/biscuit.jpg");
    jpg[1]=QString(":/steak.jpg");
    jpg[2]=QString(":/noodle.jpg");
    jpg[3]=QString(":/cola.jpg");
    //jpg[0] = QString("qrc:/biscuit.jpg");
   // jpg[1] = QString("qrc:/steak.jpg");
    //jpg[2] = QString("qrc:/noodle.jpg");
   // jpg[3] = QString("qrc:/cola.jpg");
    for (int i = 0; i < 4; ++i) {
        img[i].load(jpg[i]);
    }
    for (int i = 0; i < n; ++i) {
        plays[0][i].setMedia(QUrl("qrc:/biscuit.wav"));
        plays[1][i].setMedia(QUrl("qrc:/steak.wav"));
        plays[2][i].setMedia(QUrl("qrc:/noodle.wav"));
        plays[3][i].setMedia(QUrl("qrc:/cola.wav"));
        //plays[0][i].play();
        //plays[1][i].play();
        //plays[2][i].play();
        //plays[3][i].play();
    }
    ui->label->setPixmap(jpg[ID]);
    t.start();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::play()
{
    plays[ID][pos[ID]].play();
    ++pos[ID];
    if (pos[ID] >= n)
        pos[ID] = 0;
}

//void MainWindow::paintEvent(QPaintEvent *event)
//{
//    QPainter p(this);
//    QPixmap pic;
//    p.translate(0,0);
//    pic.load(jpg[ID]);
//    p.drawPixmap(0,0,100,100,pic);
//}

void MainWindow::changeID(int id) {
    if (id == -1) {
        ID = ID + 1;
        if (ID >= 4)
            ID = 0;
    }
    else {
        ID = id;
        t.stop();
        t.start();
    }
    play();
    ui->label->setPixmap(jpg[ID]);
}

void MainWindow::on_b1_clicked()
{
    changeID(0);
}

void MainWindow::on_b2_clicked()
{
    changeID(1);
}

void MainWindow::on_b3_clicked()
{
    changeID(2);
}

void MainWindow::on_b4_clicked()
{
    changeID(3);
}
