#include "dialog.h"
#include "ui_dialog.h"

#include <QKeyEvent>
#include <QMediaPlayer>
Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    mapper = new QSignalMapper(this);
    player = new QMediaPlayer(this);
    int cnt=0;
    for (QObject* obj : ui->frame->children())
    {
        QPushButton* pb = static_cast<QPushButton*>(obj);
        connect(pb, SIGNAL(clicked()), mapper, SLOT(map()));
        mapper->setMapping(pb, ++cnt);
    }
    connect(mapper, SIGNAL(mapped(int)), this, SLOT(tt(int)));
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::keyPressEvent(QKeyEvent *e)
{
    if (e->key() == Qt::Key_1)
    {
        //ui->pushButton->setCheckable(true);
        ui->pushButton->setDown(true);
        //ui->pushButton->repaint();

    }
    if (e->key() == Qt::Key_2)
    {
        ui->pushButton_2->setDown(true);
        //ui->pushButton_2->repaint();
    }
    if (e->key() == Qt::Key_3)
    {
        ui->pushButton_3->setDown(true);
        //ui->pushButton_3->repaint();
    }
    if (e->key() == Qt::Key_4)
    {
        ui->pushButton_4->setDown(true);
        //ui->pushButton_4->repaint();
    }
    if (e->key() == Qt::Key_5)
    {
        ui->pushButton_5->setDown(true);

    }
    if (e->key() == Qt::Key_6)
    {
        ui->pushButton_6->setDown(true);
        //ui->pushButton->repaint();
    }
    if (e->key() == Qt::Key_7)
    {
        ui->pushButton_7->setDown(true);
        //ui->pushButton->repaint();
    }

}

void Dialog::keyReleaseEvent(QKeyEvent *e)
{

    if (e->key() == Qt::Key_1)
    {
        //ui->pushButton->setCheckable(true);
        ui->pushButton->setDown(false);
        emit ui->pushButton->clicked();
        //emit ui->pushButton->click();
    }
    if (e->key() == Qt::Key_2)
    {
        ui->pushButton_2->setDown(false);
        emit ui->pushButton_2->clicked();
    }
    if (e->key() == Qt::Key_3)
    {
        ui->pushButton_3->setDown(false);
        emit ui->pushButton_3->clicked();
    }
    if (e->key() == Qt::Key_4)
    {
        ui->pushButton_4->setDown(false);
        emit ui->pushButton_4->clicked();
    }
    if (e->key() == Qt::Key_5)
    {
        ui->pushButton_5->setDown(false);
        emit ui->pushButton_5->clicked();
    }
    if (e->key() == Qt::Key_6)
    {
        ui->pushButton_6->setDown(false);
        emit ui->pushButton_6->clicked();
    }
    if (e->key() == Qt::Key_7)
    {
        ui->pushButton_7->setDown(false);
        emit ui->pushButton_7->clicked();
    }
}

void Dialog::on_pushButton_8_clicked()
{
    close();
}

void Dialog::tt(int x)
{
    ui->textEdit->append(QString::number(x));
    QString st = QString("D:\\%1.mp3").arg(x);
    //QString st = QString("/haha/%1").arg(x);
    player->setMedia(QUrl::fromLocalFile(st));
    player->setVolume(10);
    player->play();

}
