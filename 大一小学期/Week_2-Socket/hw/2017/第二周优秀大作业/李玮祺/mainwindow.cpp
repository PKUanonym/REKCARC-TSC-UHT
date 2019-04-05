#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "connect_setting.h"
#include "ui_connect_setting.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    init();
    initnet();
    //initServer();
    opGIF();
}

void MainWindow::startButtonclicked()
{
    delete movie;
    delete tempButton;
    delete label;

    QPixmap myPix("C:/Coding/chess/pic/ui1.png");
    ui->label1->setPixmap(myPix);
    ui->label1->setScaledContents(true);
    ui->label1->show();

    ui->quitButton->setVisible(true);
    ui->quitButton->setEnabled(true);
    ui->link->setVisible(true);
    ui->link->setEnabled(true);
    ui->escape->setVisible(true);
    ui->escape->setEnabled(true);
    ui->equa->setVisible(true);
    ui->equa->setEnabled(true);
    ui->bgmbut->setVisible(true);
    ui->bgmbut->setEnabled(true);
    ui->sebut->setVisible(true);
    ui->sebut->setEnabled(true);

    loginse();
    FirstBGM();
    luGIF();

    //ui->label->setAttribute(Qt::WA_TranslucentBackground);
    //ui->label->setStyleSheet("background:transparent");

    //ui->label->setStyleSheet("background-color: rgba(255, 255, 255, 50)");
    //ui->label->setWindowOpacity(0.8);
    //delete movie;
    //qDebug() << 1;
    //endingGIF(2);
}

void MainWindow::ButtonPressed(int tar)
{
    sechess();
    if (!whotern) return;
    if (active1 != 0)
    {
        active2 = tar;
        if (active1 == tar)
        {
            dark(tar);
            hidetar();
            active1 = active2 = 0;
            return;
        }
        if ((testmood) && (ActiveInfo[tar] >= 3))
        {
            dark(active1);
            hidetar();
            shine(tar);
            active1 = tar;
            return;
        }
        if ((ActiveInfo[tar] == 1) || (ActiveInfo[tar] == 2))
        {
            dark(active1);
            hidetar();
            shine(tar);
            showtar(tar);
            active1 = tar;
            return;
        }
        if ((!testmood) && (ActiveInfo[tar] >= 3))
        {
            hidetar();
            dark(active1);
            active1 = 0;
            return;
        }

        //qDebug() << "chosemap" << choseMap[xMap[active1]][yMap[tar]];
        if ((!testmood) && (choseMap[xMap[tar]][yMap[tar]] != 1))
        {
            hidetar();
        }
        else
        {
            hidetar();
            movechess(active1, tar);
        }
        dark(active1);
        active1 = 0;
    }
    else
    {
        if (ActiveInfo[tar] == 0) return;
        if ((!testmood) && (ActiveInfo[tar] >= 3)) return;
        active1 = tar;
        shine(tar);
        showtar(tar);
    }
}

void MainWindow::on_quitButton_clicked()
{
    sendMessage("R");
    sebutton();
    edBGM(5);
    endingGIF(5);
}

void MainWindow::exitButtonclicked()
{
    sebutton();
    close();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_equa_clicked()
{
    sebutton();
    sendMessage("H");
}

void MainWindow::on_escape_clicked()
{
    sendMessage("R");
    sebutton();
    edBGM(5);
    endingGIF(5);
}


void MainWindow::on_link_clicked()
{
    sebutton();
    dlg = new Connect_setting(this, local, port);
    //dlg->setWindowOpacity(0.5);
    //dlg->setWindowFlags(Qt::FramelessWindowHint);
    dlg->setWindowTitle("連接");
    dlg->setFixedSize(dlg->width(), dlg->height());
    dlg->setStyleSheet("background-color: rgb(241,234,221)");
    //dlg.setWindowFlags(Qt::FramelessWindowHint);
    //dlg.setWindowModality(Qt::NonModal);
    ifdialog = true;
    dlg->exec();
    sebutton();
    //dlg.close();
    ifdialog = false;
    statuelink = dlg->getStatue();
    loaddir = dlg->getIp();
    loadport = dlg->getPort();

    if (statuelink)
        netclient();

    //qDebug() << statuelink;
    //qDebug() << loaddir;
    //qDebug() << loadport;
}

void MainWindow::waittime(unsigned int msec)
{
    QTime reachTime = QTime::currentTime().addMSecs(msec);
    while (QTime::currentTime() < reachTime)
        QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
}

void MainWindow::nekoclicked()
{
    close();
}

void MainWindow::on_testdel_clicked()
{
    if (!whotern) return;
    sebutton();
    hidetar();
    if (active1 == 0) return;
    ActiveMap[active1]->setIconSize(QSize(30,30));
    ActiveMap[active1]->setIcon(* empt);
    ActiveMap[active1]->show();
    if ((ActiveInfo[active1] == 3) || (ActiveInfo[active1] == 4)) eremain--;
    if ((ActiveInfo[active1] == 1) || (ActiveInfo[active1] == 2)) mremain--;
    ActiveInfo[active1] = 0;
    dark(active1);
    deleteGIF(active1);
    QString ta = QString::number(active1);
    if (active1 < 10) ta = "0" + ta;
    sendMessage("D" + ta);
    active1 = 0;

    updatepoint();
}

void MainWindow::on_testmov_clicked()
{
    if (!whotern) return;
    sebutton();
    if (testmood)
    {
        ui->testmov->setText("测试模式 : 關");
        ui->testdel->setEnabled(false);
        ui->testend->setEnabled(false);
        ui->teststart->setEnabled(false);
        ui->changeGod->setEnabled(false);
    }
    else
    {
        ui->testmov->setText("测试模式 : 開");
        ui->testdel->setEnabled(true);
        ui->testend->setEnabled(true);
        ui->teststart->setEnabled(true);
        ui->changeGod->setEnabled(true);
    }
    testmood = !testmood;
}

void MainWindow::on_severon_clicked()
{
    sebutton();
    if (!severonoff)
    {
        QPixmap t1("C:/Coding/chess/pic/yes.png");
        ui->sever->setPixmap(t1);
        ui->sever->setScaledContents(true);

        dlg1 = new PortInput(this);
        dlg1->setWindowTitle("端口");
        dlg1->setFixedSize(dlg1->width(), dlg1->height());
        dlg1->exec();
        sebutton();
        statuelink = dlg1->getStatue();
        loadport = dlg1->getPort();

        if ((statuelink) && (loadport != 0))
            port = loadport;
        qDebug() << "port " << port;


        initServer();
        //ui->severon->setText("服务器 : 開");
    }
    else
    {
        QPixmap t6("C:/Coding/chess/pic/no.png");
        ui->sever->setPixmap(t6);
        ui->sever->setScaledContents(true);

        delete severlistenSocket;
        //ui->severon->setText("服务器 : 關");
    }
    severonoff = !severonoff;
}

void MainWindow::on_changeGod_clicked()
{
    if (!whotern) return;
    sebutton();
    hidetar();
    if (active1 == 0) return;
    QString ta = QString::number(active1);
    if (active1 < 10) ta = "0" + ta;
    sendMessage("W" + ta);
    if (ActiveInfo[active1] == 1)
    {
        ActiveMap[active1]->setIconSize(QSize(30,30));
        ActiveMap[active1]->setIcon(* ocicon1);
        ActiveMap[active1]->show();
        ActiveInfo[active1] = 2;
        dark(active1);
        active1 = 0;
        return;
    }
    if (ActiveInfo[active1] == 2)
    {
        ActiveMap[active1]->setIconSize(QSize(30,30));
        ActiveMap[active1]->setIcon(* ocicon);
        ActiveMap[active1]->show();
        ActiveInfo[active1] = 1;
        dark(active1);
        active1 = 0;
        return;
    }
    if (ActiveInfo[active1] == 3)
    {
        ActiveMap[active1]->setIconSize(QSize(30,30));
        ActiveMap[active1]->setIcon(* acicon1);
        ActiveMap[active1]->show();
        ActiveInfo[active1] = 4;
        dark(active1);
        active1 = 0;
        return;
    }
    if (ActiveInfo[active1] == 4)
    {
        ActiveMap[active1]->setIconSize(QSize(30,30));
        ActiveMap[active1]->setIcon(* acicon);
        ActiveMap[active1]->show();
        ActiveInfo[active1] = 3;
        dark(active1);
        active1 = 0;
        return;
    }
}

void MainWindow::on_teststart_clicked()
{
    sebutton();
    beginround();
}

void MainWindow::on_testend_clicked()
{
    sebutton();
    endround();
}
