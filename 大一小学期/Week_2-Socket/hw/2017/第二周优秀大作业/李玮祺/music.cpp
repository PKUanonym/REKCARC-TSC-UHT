#include "mainwindow.h"
#include "ui_mainwindow.h"

void MainWindow::loginse()
{
    playerse = new QMediaPlayer;
    playerse->setMedia(QUrl::fromLocalFile("../chess/se/beginse.mp3"));
    playerse->setVolume(50);
    playerse->play();
}

void MainWindow::FirstBGM()
{
    playlist = new QMediaPlaylist;
    playlist->addMedia(QUrl::fromLocalFile("../chess/bgm/firstbgm.mp3"));
    playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    bgmplayer = new QMediaPlayer;
    bgmplayer->setPlaylist(playlist);
    playlist->setCurrentIndex(0);
    bgmplayer->setVolume(50);
    bgmplayer->play();

    /*bgmplayer = new QMediaPlayer;
    bgmplayer->setMedia(QUrl::fromLocalFile("../chess/bgm/firstbgm.mp3"));
    bgmplayer->setVolume(50);
    bgmplayer->play();*/
}

void MainWindow::FightBGM()
{
    delete playlist;
    delete bgmplayer;
    playlist = new QMediaPlaylist;
    playlist->addMedia(QUrl::fromLocalFile("../chess/bgm/fightbgm.mp3"));
    playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    bgmplayer = new QMediaPlayer;
    bgmplayer->setPlaylist(playlist);
    playlist->setCurrentIndex(0);
    bgmplayer->setVolume(50);
    bgmplayer->play();
}

void MainWindow::edBGM(int num)
{
    delete playlist;
    delete bgmplayer;
    bgmplayer = new QMediaPlayer;
    if (num <= 3)
        bgmplayer->setMedia(QUrl::fromLocalFile("../chess/se/ed1.mp3"));
    else
        bgmplayer->setMedia(QUrl::fromLocalFile("../chess/se/ed2.mp3"));
    bgmplayer->setVolume(50);
    bgmplayer->play();
}

void MainWindow::sebutton()
{
    if (!sestatue) return;
    delete playerse;
    playerse = new QMediaPlayer;
    playerse->setMedia(QUrl::fromLocalFile("../chess/se/pushse.mp3"));
    playerse->setVolume(50);
    playerse->play();
}

void MainWindow::sechess()
{
    if (!sestatue) return;
    delete playerse;
    playerse = new QMediaPlayer;
    playerse->setMedia(QUrl::fromLocalFile("../chess/se/beep.mp3"));
    playerse->setVolume(50);
    playerse->play();
}

void MainWindow::ding()
{
    if (!sestatue) return;
    delete playerse;
    playerse = new QMediaPlayer;
    playerse->setMedia(QUrl::fromLocalFile("../chess/se/ding.mp3"));
    playerse->setVolume(50);
    playerse->play();
}

void MainWindow::beginfightse()
{
    if (!sestatue) return;
    delete playerse;
    playerse = new QMediaPlayer;
    playerse->setMedia(QUrl::fromLocalFile("../chess/se/beginfight.mp3"));
    playerse->setVolume(50);
    playerse->play();
}

void MainWindow::on_sebut_clicked()
{
    sebutton();
    if (sestatue)
    {
        //ui->sebut->setText("音效 : 關");
        playerse->setVolume(0);

        QPixmap t2("C:/Coding/chess/pic/no.png");
        ui->se->setPixmap(t2);
        ui->se->setScaledContents(true);
    }
    else
    {
        //ui->sebut->setText("音效 : 開");
        playerse->setVolume(50);

        QPixmap t2("C:/Coding/chess/pic/yes.png");
        ui->se->setPixmap(t2);
        ui->se->setScaledContents(true);
    }
    sestatue = !sestatue;
}

void MainWindow::on_bgmbut_clicked()
{
    sebutton();
    if (bgmstatue)
    {
        //ui->bgmbut->setText("背景音 : 關");
        bgmplayer->setVolume(0);

        QPixmap t2("C:/Coding/chess/pic/no.png");
        ui->bgm->setPixmap(t2);
        ui->bgm->setScaledContents(true);
    }
    else
    {
        //ui->bgmbut->setText("背景音 : 開");
        bgmplayer->setVolume(50);

        QPixmap t2("C:/Coding/chess/pic/yes.png");
        ui->bgm->setPixmap(t2);
        ui->bgm->setScaledContents(true);
    }
    bgmstatue = !bgmstatue;
}

