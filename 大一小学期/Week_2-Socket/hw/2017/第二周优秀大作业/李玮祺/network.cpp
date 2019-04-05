#include "mainwindow.h"
#include "ui_mainwindow.h"

#define random(x)(rand()%x)

#include <algorithm>
#include <ctime>

using namespace std;

void MainWindow::closeDialog()
{
    if (!ifdialog) return;
    ifdialog = false;
    dlg->close();
}

void MainWindow::initnet()
{
    QString localHostName = QHostInfo::localHostName();
    //qDebug() <<"localHostName: "<<localHostName;
    QHostInfo info = QHostInfo::fromName(localHostName);
    //qDebug() <<"IP Address: "<<info.addresses();
    foreach(QHostAddress address,info.addresses())
    {
         if(address.protocol() == QAbstractSocket::IPv4Protocol)
         {
             //qDebug() << address.toString();
             local = address.toString();
         }
    }
    port = 12450;

    /*QList<QHostAddress> list = QNetworkInterface::allAddresses();
    foreach (QHostAddress address, list)
    {
        if(address.protocol() == QAbstractSocket::IPv4Protocol)  //我们使用IPv4地址
            qDebug() << address.toString();
    }*/
}

void MainWindow::clientEnable()
{
    //qDebug() << "client";
    ifhost = false;
    statenow = true;
    serverclient();
}

void MainWindow::connectfail()
{
    if (jsbool) return;
    tempButton = new QPushButton(this);
    tempButton->setGeometry(0,0,1000,600);
    tempButton->setCursor(QCursor(Qt::PointingHandCursor));
    tempButton->setStyleSheet("border-image:url(C:/Coding/chess/pic/break.png)");
    tempButton->show();
    connect(tempButton,SIGNAL(clicked(bool)),this,SLOT(nekoclicked()));
    qDebug() << "neko";
    bgmplayer->setVolume(0);
    ding();
}

void MainWindow::netclient()
{
    clientSocket = new QTcpSocket;
    clientSocket->connectToHost(QHostAddress(loaddir),loadport);
    //QObject::connect(clientSocket,SIGNAL(disconnected()),this,SLOT(connectfail()));
    //QObject::connect(clientSocket,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(connectfail()));
    QObject::connect(clientSocket,SIGNAL(connected()),this,SLOT(clientEnable()));
}

void MainWindow::acceptConnection()
{
    ifhost = true;
    statenow = true;
    //qDebug() << "accept";
    severSocket = severlistenSocket->nextPendingConnection();
    serverclient();
}

void MainWindow::initServer()
{
    severlistenSocket =new QTcpServer;
    severlistenSocket->listen(QHostAddress::Any,port);
    QObject::connect(severlistenSocket,SIGNAL(newConnection()),this,SLOT(closeDialog()));
    QObject::connect(severlistenSocket,SIGNAL(newConnection()),this,SLOT(acceptConnection()));
}

void MainWindow::serverclient()
{
    qDebug() << "ifhost" << ifhost;
    srand(time(0));
    if (ifhost)
    {
        readWriteSocket = severSocket;
        listenSocket = severlistenSocket;
        int temp = random(2);
        if (temp)
        {
            whotern = true;
            sendMessage("F");
        }
        else
        {
            whotern = false;
            sendMessage("L");
        }
    }
    else
    {
        readWriteSocket = clientSocket;
        listenSocket = clientlistenSocket;
    }
    ui->severon->setEnabled(false);
    ding();
    QObject::connect(readWriteSocket,SIGNAL(disconnected()),this,SLOT(connectfail()));
    QObject::connect(readWriteSocket,SIGNAL(readyRead()),this,SLOT(recvMessage()));
    beginfightgif();
    beginfightse();
    waittime(1000);
    FightBGM();
    qDebug() << "connect";
    qDebug() << "who" << whotern;
    ui->link->setEnabled(false);
    if ((ifhost) && (whotern)) beginround();
    if (whotern)
    {
        QPixmap shima("C:/Coding/chess/pic/shima.png");
        ui->who->setPixmap(shima);
        ui->who->setScaledContents(true);
    }
    else
    {
        QPixmap north("C:/Coding/chess/pic/north.png");
        ui->who->setPixmap(north);
        ui->who->setScaledContents(true);
    }
}


void MainWindow::recvMessage()
{
    QString info;
    //info = "Receive : ";
    info = "";
    info += readWriteSocket->readAll();
    qDebug() << "recv: " << info;
    string message;
    message = info.toStdString();
    if (message[0] == 'M')
    {
        int xy1 = 0;
        int xy2 = 0;
        xy1 = ((int)message[1]) - 48;
        xy2 = ((int)message[3]) - 48;
        xy1 = xy1 * 10;
        xy2 = xy2 * 10;
        xy1 += ((int)message[2]) - 48;
        xy2 += ((int)message[4]) - 48;
        //qDebug() << xy1;
        //qDebug() << xy2;
        movechess(poschange(xy1), poschange(xy2));
    }
    if (message[0] == 'D')
    {
        int xy = 0;
        xy = ((int)message[1]) - 48;
        xy = ((int)message[2]) - 48 + xy * 10;
        xy = poschange(xy);
        qDebug() << xy;
        //deletechess(poschange(xy));
        ActiveMap[xy]->setIconSize(QSize(30,30));
        ActiveMap[xy]->setIcon(* empt);
        ActiveMap[xy]->show();
        if (ActiveInfo[xy] >= 3) eremain--;
        if ((ActiveInfo[xy] == 1) || (ActiveInfo[xy] == 2)) mremain--;
        ActiveInfo[xy] = 0;
        deleteGIF(xy);

        updatepoint();
    }
    if (message[0] == 'E')
    {
        beginround();
    }
    if (message[0] == 'H')
    {
        /*edBGM(3);
        endingGIF(3);*/
        int ret = QMessageBox::warning(this, tr("KanChess"), tr("是否接受和棋?"), QMessageBox::Yes | QMessageBox::No);
        if (ret == QMessageBox::Yes)
        {
            sendMessage("T");
            edBGM(3);
            endingGIF(3);
        }
        else
        {
            sendMessage("N");
            ifequal = 1;
            equanum = 40;
            ui->equa->setEnabled(false);
            ui->qh2->setText("剩余 40 步");
            ui->qh1->setText("求和");
        }
    }
    if (message[0] == 'T')
    {
        edBGM(3);
        endingGIF(3);
    }
    if (message[0] == 'N')
    {
        ifequal = -1;
        equanum = 40;
        ui->equa->setEnabled(false);
        ui->qh1->setText("剩余 40 步");
        ui->qh2->setText("求和");
    }
    if (message[0] == 'W')
    {
        int xy = 0;
        xy = ((int)message[1]) - 48;
        xy = ((int)message[2]) - 48 + xy * 10;
        qDebug() << xy;
        ChangeKing(xy);
    }
    if (message[0] == 'F')
    {
        whotern = false;
    }
    if (message[0] == 'L')
    {
        whotern = true;
        beginround();
    }
    if (message[0] == 'R')
    {
        edBGM(1);
        endingGIF(1);
    }
    if (message[0] == 'X')
    {
        edBGM(2);
        endingGIF(2);
    }
}

void MainWindow::sendMessage(QString info)
{
    qDebug() << "send: " << info;
    if (!statenow) return;
    QByteArray * array =new QByteArray;
    array->clear();
    //array->append(ui->inputEdit->toPlainText());
    //array->append("this is a message");
    array->append(info);
    //qDebug() << "send a message";
    readWriteSocket->write(array->data());
    readWriteSocket->flush();
    //waittime(1000);
}
