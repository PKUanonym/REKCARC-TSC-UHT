#include "mainwindow.h"
#include "ui_mainwindow.h"

const int dx[4] = {1, 1, -1, -1};
const int dy[4] = {1, -1, 1, -1};

using std::string;
using std::abs;

int MainWindow::poschange(int pos)
{
    return (51 - pos);
}

void MainWindow::ChangeKing(int tar)
{
    if (tar == 0) return;
    tar = poschange(tar);
    if (ActiveInfo[tar] == 1)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* ocicon1);
        ActiveMap[tar]->show();
        ActiveInfo[tar] = 2;
        return;
    }
    if (ActiveInfo[tar] == 2)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* ocicon);
        ActiveMap[tar]->show();
        ActiveInfo[tar] = 1;
        return;
    }
    if (ActiveInfo[tar] == 3)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* acicon1);
        ActiveMap[tar]->show();
        ActiveInfo[tar] = 4;
        return;
    }
    if (ActiveInfo[tar] == 4)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* acicon);
        ActiveMap[tar]->show();
        ActiveInfo[tar] = 3;
        return;
    }
}

void MainWindow::movechess(int fromid, int toid)
{
    if (ActiveInfo[fromid] == 0)
    {
        return;
    }
    if (ActiveInfo[toid] != 0)
    {
        dark(fromid);
        return;
    }

    QString fr = QString::number(fromid);
    QString ta = QString::number(toid);
    if (fromid < 10) fr = "0" + fr;
    if (toid < 10) ta = "0" + ta;
    sendMessage("M" + fr + ta);
    //qDebug() << ("send M" + fr + ta);

    QIcon * temp;
    if (ActiveInfo[fromid] == 1) temp = ocicon;
    if (ActiveInfo[fromid] == 2) temp = ocicon1;
    if (ActiveInfo[fromid] == 3) temp = acicon;
    if (ActiveInfo[fromid] == 4) temp = acicon1;
    //qDebug() << ActiveInfo[fromid];
    //qDebug() << ActiveInfo[toid];
    ActiveMap[fromid]->setIconSize(QSize(30,30));
    ActiveMap[fromid]->setIcon(* empt);
    ActiveMap[fromid]->show();
    ActiveMap[toid]->setIconSize(QSize(30,30));
    ActiveMap[toid]->setIcon(* temp);
    ActiveMap[toid]->show();
    ActiveInfo[toid] = ActiveInfo[fromid];
    ActiveInfo[fromid] = 0;

    //if (testmood) return;
    int dx = xMap[toid] - xMap[fromid];
    int dy = yMap[toid] - yMap[fromid];
    if ((abs(dx)) != (abs(dy))) return;
    dx = dx / (abs(dx));
    dy = dy / (abs(dy));

    //qDebug() << "leep" << dx << " " << dy;

    int tx = xMap[fromid];
    int ty = yMap[fromid];
    while (1)
    {
        tx += dx;
        ty += dy;
        if ((tx == xMap[toid]) || (ty == yMap[toid])) break;
        if (ActiveInfo[intMap[tx][ty]] != 0)
        {
            delsum++;
            dfsmax--;
            ActiveInfo[intMap[tx][ty]] = 5;
            delque[delsum] = intMap[tx][ty];
            //qDebug() << "del " << tx << " " << ty;
            break;
        }
    }
    lastmove = toid;

    if (whotern)
    {
        for (int i = 1; i <= 50; i++) flag[i] = 0;
        flag[toid] = dfsmax;
    }

    if ((!testmood) && (dfsmax == 0) && (whotern))
    {
        waittime(500);
        endround();
    }
}

void MainWindow::updatepoint()
{
    ui->echess->setText(QString::number(eremain));
    ui->ochess->setText(QString::number(mremain));

    int temp = (eremain + 1) / 2;
    QPixmap t1("C:/Coding/chess/pic/point/0" + QString::number(temp) + ".png");
    ui->chesse->setPixmap(t1);
    ui->chesse->setScaledContents(true);

    temp = (mremain + 1) / 2;
    QPixmap t2("C:/Coding/chess/pic/point/0" + QString::number(temp) + ".png");
    ui->chesso->setPixmap(t2);
    ui->chesso->setScaledContents(true);
}

void MainWindow::deletechess(int tar)
{
    ActiveMap[tar]->setIconSize(QSize(30,30));
    ActiveMap[tar]->setIcon(* empt);
    ActiveMap[tar]->show();
    //if (ActiveInfo[tar] >= 3) eremain--;
    //if ((ActiveInfo[tar] == 1) || (ActiveInfo[tar] == 2)) mremain--;
    if (whotern) mremain--; else eremain--;
    ActiveInfo[tar] = 0;
    deleteGIF(tar);
    updatepoint();
}

void MainWindow::dfsbr(int pos, int eat)
{
    int x = xMap[pos];
    int y = yMap[pos];
    int tnow;
    int tnxt;
    for (int i = 0; i < 4; i++)
    {
        int tx = x + dx[i];
        int ty = y + dy[i];
        int tar = intMap[tx][ty];
        if (tar == -1) continue;
        if ((ActiveInfo[tar] == 3) || (ActiveInfo[tar] == 4))
        {
            int nxtx = tx + dx[i];
            int nxty = ty + dy[i];
            int nxttar = intMap[nxtx][nxty];
            if (ActiveInfo[nxttar] == 0)
            {
                tnow = ActiveInfo[pos];
                tnxt = ActiveInfo[tar];
                ActiveInfo[pos] = 0;
                ActiveInfo[tar] = 5;
                ActiveInfo[nxttar] = tnow;
                if (eat + 1 > dfsans) dfsans = eat + 1;
                if (eat + 1 > dfsmax) dfsmax = eat + 1;

                dfsbr(nxttar, eat + 1);

                ActiveInfo[pos] = tnow;
                ActiveInfo[tar] = tnxt;
                ActiveInfo[nxttar] = 0;
            }
            else
                continue;
            if (!god) continue;
            for (int k = 2; ; k++)
            {
                nxtx = tx + k * dx[i];
                nxty = ty + k * dy[i];
                nxttar = intMap[nxtx][nxty];
                if (nxttar == -1) break;
                if (ActiveInfo[nxttar] != 0) break;
                if (ActiveInfo[nxttar] == 0)
                {
                    tnow = ActiveInfo[pos];
                    tnxt = ActiveInfo[tar];
                    ActiveInfo[pos] = 0;
                    ActiveInfo[tar] = 5;
                    ActiveInfo[nxttar] = tnow;
                    if (eat + 1 > dfsans) dfsans = eat + 1;
                    if (eat + 1 > dfsmax)
                    {
                        dfsmax = eat + 1;
                        //qDebug() << dfsmax << " " << x << "," << y << "," << pos << ";" << tx << "," << ty << "," << tar << ";" << nxtx << "," << nxty << "," << nxttar;
                    }

                    dfsbr(nxttar, eat + 1);

                    ActiveInfo[pos] = tnow;
                    ActiveInfo[tar] = tnxt;
                    ActiveInfo[nxttar] = 0;
                }
            }
        }
        if (ActiveInfo[tar] >= 3) continue;
        if (!god) continue;
        for (int j = 2; ; j++)
        {
            int tx = x + j * dx[i];
            int ty = y + j * dy[i];
            int tar = intMap[tx][ty];
            if (tar == -1) break;
            if ((ActiveInfo[tar] == 1) || (ActiveInfo[tar] == 2)) break;
            if ((ActiveInfo[tar] == 3) || (ActiveInfo[tar] == 4))
            {
                for (int k = 1; ; k++)
                {
                    int nxtx = tx + k * dx[i];
                    int nxty = ty + k * dy[i];
                    int nxttar = intMap[nxtx][nxty];
                    if (nxttar == -1) break;
                    if (ActiveInfo[nxttar] != 0) break;
                    if (ActiveInfo[nxttar] == 0)
                    {
                        tnow = ActiveInfo[pos];
                        tnxt = ActiveInfo[tar];
                        ActiveInfo[pos] = 0;
                        ActiveInfo[tar] = 5;
                        ActiveInfo[nxttar] = tnow;
                        if (eat + 1 > dfsans) dfsans = eat + 1;
                        if (eat + 1 > dfsmax)
                        {
                            dfsmax = eat + 1;
                            //qDebug() << dfsmax << " " << x << "," << y << "," << pos << ";" << tx << "," << ty << "," << tar << ";" << nxtx << "," << nxty << "," << nxttar;
                        }

                        dfsbr(nxttar, eat + 1);

                        ActiveInfo[pos] = tnow;
                        ActiveInfo[tar] = tnxt;
                        ActiveInfo[nxttar] = 0;
                    }
                }
                break;
            }
        }
    }
}

void MainWindow::beginround()
{
    if ((lastmove != -1) && (xMap[lastmove] == 10))
    {
        if (ActiveInfo[lastmove] == 3)
        {
            ActiveMap[lastmove]->setIconSize(QSize(30,30));
            ActiveMap[lastmove]->setIcon(* acicon1);
            ActiveMap[lastmove]->show();
            ActiveInfo[lastmove] = 4;
        }
    }
    whotern = true;
    QPixmap shima("C:/Coding/chess/pic/shima.png");
    ui->who->setPixmap(shima);
    ui->who->setScaledContents(true);
    for (int i = 1; i <= delsum; i++)
    {
        deletechess(delque[i]);
        ActiveInfo[delque[i]] = 0;
        waittime(100);
    }
    lastmove = -1;
    delsum = 0;
    dfsmax = 0;
    if (eremain == 0)
    {
        //edBGM(2);
        //endingGIF(2);
    }
    if (mremain == 0)
    {
        //edBGM(4);
        //endingGIF(4);
    }
    for (int i = 1; i <= 50; i++)
    {
        dfsans = 0;
        if (ActiveInfo[i] == 2) god = true; else god = false;
        if ((ActiveInfo[i] == 1) || (ActiveInfo[i] == 2))
        {
            //qDebug() << i;
            dfsbr(i, 0);
        }
        flag[i] = dfsans;
    }
    qDebug() << "dfsmax : " << dfsmax;

    if (dfsmax == 0)
    {
        bool flagif = true;
        for (int i = 1; i <= 50; i++)
        {
            if ((ActiveInfo[i] == 1))
            {
                int x = xMap[i];
                int y = yMap[i];
                for (int j = 0; j < 4; j++)
                {
                    int tx = x + dx[j];
                    int ty = y + dy[j];
                    int tar = intMap[tx][ty];
                    if (tar == -1) continue;
                    if (tx > x) continue;
                    if (ActiveInfo[tar] == 0) flagif = false;
                }
            }
            if ((ActiveInfo[i] == 2))
            {
                int x = xMap[i];
                int y = yMap[i];
                for (int j = 0; j < 4; j++)
                {
                    for (int k = 1; ; k++)
                    {
                        int tx = x + k * dx[j];
                        int ty = y + k * dy[j];
                        int tar = intMap[tx][ty];
                        if (tar == -1) break;
                        if (ActiveInfo[tar] != 0) break;
                        if (ActiveInfo[tar] == 0)
                        {
                            flagif = false;
                            break;
                        }
                    }
                }
            }
        }
        if (flagif)
        {
            sendMessage("X");
            edBGM(4);
            endingGIF(4);
        }
    }

    if (ifequal != 0)
    {
        equanum--;
        if (ifequal == 1)
        {
            ui->qh2->setText("剩余 " + QString::number(equanum) + " 步");
        }
        else
        {
            ui->qh1->setText("剩余 " + QString::number(equanum) + " 步");
        }
        if (equanum == 0)
        {
            if (ifequal == 1)
            {
                if (eremain < (mremain - 5))
                {
                    edBGM(1);
                    endingGIF(1);
                }
                else
                {
                    edBGM(5);
                    endingGIF(5);
                }
            }
            else
            {
                if (mremain < (eremain - 5))
                {
                    edBGM(5);
                    endingGIF(5);
                }
                else
                {
                    edBGM(1);
                    endingGIF(1);
                }
            }
        }
    }
}

void MainWindow::endround()
{
    if ((lastmove != -1) && (xMap[lastmove] == 1))
    {
        if (ActiveInfo[lastmove] == 1)
        {
            ActiveMap[lastmove]->setIconSize(QSize(30,30));
            ActiveMap[lastmove]->setIcon(* ocicon1);
            ActiveMap[lastmove]->show();
            ActiveInfo[lastmove] = 2;
        }
    }
    whotern =false;
    QPixmap north("C:/Coding/chess/pic/north.png");
    ui->who->setPixmap(north);
    ui->who->setScaledContents(true);
    qDebug() << "delsum : " << delsum;
    for (int i = 1; i <= delsum; i++)
    {
        qDebug() << delque[i];
        deletechess(delque[i]);
        ActiveInfo[delque[i]] = 0;
        waittime(100);
    }
    lastmove = -1;
    delsum = 0;
    if (eremain == 0)
    {
        //edBGM(2);
        //endingGIF(2);
    }
    if (mremain == 0)
    {
        //edBGM(4);
        //endingGIF(4);
    }

    if (ifequal != 0)
    {
        equanum--;
        if (ifequal == 1)
        {
            ui->qh2->setText("剩余 " + QString::number(equanum) + " 步");
        }
        else
        {
            ui->qh1->setText("剩余 " + QString::number(equanum) + " 步");
        }
        if (equanum == 0)
        {
            if (ifequal == 1)
            {
                if (eremain < (mremain - 5))
                {
                    edBGM(1);
                    endingGIF(1);
                }
                else
                {
                    edBGM(5);
                    endingGIF(5);
                }
            }
            else
            {
                if (mremain < (eremain - 5))
                {
                    edBGM(5);
                    endingGIF(5);
                }
                else
                {
                    edBGM(1);
                    endingGIF(1);
                }
            }
        }
    }

    sendMessage("E");
}

void MainWindow::dfslo(int pos, int eat, std::string dir)
{
    int x = xMap[pos];
    int y = yMap[pos];
    int tnow;
    int tnxt;
    for (int i = 0; i < 4; i++)
    {
        int tx = x + dx[i];
        int ty = y + dy[i];
        int tar = intMap[tx][ty];
        if (tar == -1) continue;
        if ((ActiveInfo[tar] == 3) || (ActiveInfo[tar] == 4))
        {
            int nxtx = tx + dx[i];
            int nxty = ty + dy[i];
            int nxttar = intMap[nxtx][nxty];
            //qDebug() << "nxtx " << nxtx;
            //qDebug() << "nxty " << nxty;
            //qDebug() << "nxttar " << nxttar;
            //qDebug() << "";
            if (ActiveInfo[nxttar] == 0)
            {
                tnow = ActiveInfo[pos];
                tnxt = ActiveInfo[tar];
                ActiveInfo[pos] = 0;
                ActiveInfo[tar] = 5;
                ActiveInfo[nxttar] = tnow;
                string t = "";
                t += ((nxttar / 10) + '0');
                t += ((nxttar % 10) + '0');
                dfsans++;
                //qDebug() << "t: " << QString::fromStdString(t);
                dfsdir[dfsans] = dir + t;
                dfseat[dfsans] = eat + 1;

                dfslo(nxttar, eat + 1, dir + t);

                ActiveInfo[pos] = tnow;
                ActiveInfo[tar] = tnxt;
                ActiveInfo[nxttar] = 0;
            }
            else
                continue;
            if (!god) continue;
            for (int k = 2; ; k++)
            {
                nxtx = tx + k * dx[i];
                nxty = ty + k * dy[i];
                nxttar = intMap[nxtx][nxty];
                if (nxttar == -1) break;
                if (ActiveInfo[nxttar] != 0) break;
                if (ActiveInfo[nxttar] == 0)
                {
                    tnow = ActiveInfo[pos];
                    tnxt = ActiveInfo[tar];
                    ActiveInfo[pos] = 0;
                    ActiveInfo[tar] = 5;
                    ActiveInfo[nxttar] = tnow;
                    string t = "";
                    t += ((nxttar / 10) + '0');
                    t += ((nxttar % 10) + '0');
                    dfsans++;
                    //qDebug() << "t: " << QString::fromStdString(t);
                    dfsdir[dfsans] = dir + t;
                    dfseat[dfsans] = eat + 1;

                    dfslo(nxttar, eat + 1, dir + t);

                    ActiveInfo[pos] = tnow;
                    ActiveInfo[tar] = tnxt;
                    ActiveInfo[nxttar] = 0;
                }
            }
        }
        if (ActiveInfo[tar] >= 3) continue;
        if (!god) continue;
        for (int j = 2; ; j++)
        {
            int tx = x + j * dx[i];
            int ty = y + j * dy[i];
            int tar = intMap[tx][ty];
            if (tar == -1) break;
            if ((ActiveInfo[tar] == 1) || (ActiveInfo[tar] == 2)) break;
            if ((ActiveInfo[tar] == 3) || (ActiveInfo[tar] == 4))
            {
                for (int k = 1; ; k++)
                {
                    int nxtx = tx + k * dx[i];
                    int nxty = ty + k * dy[i];
                    int nxttar = intMap[nxtx][nxty];
                    if (nxttar == -1) break;
                    if (ActiveInfo[nxttar] != 0) break;
                    if (ActiveInfo[nxttar] == 0)
                    {
                        tnow = ActiveInfo[pos];
                        tnxt = ActiveInfo[tar];
                        ActiveInfo[pos] = 0;
                        ActiveInfo[tar] = 5;
                        ActiveInfo[nxttar] = tnow;
                        string t = "";
                        t += ((nxttar / 10) + '0');
                        t += ((nxttar % 10) + '0');
                        dfsans++;
                        //qDebug() << "t: " << QString::fromStdString(t);
                        dfsdir[dfsans] = dir + t;
                        dfseat[dfsans] = eat + 1;

                        dfslo(nxttar, eat + 1, dir + t);

                        ActiveInfo[pos] = tnow;
                        ActiveInfo[tar] = tnxt;
                        ActiveInfo[nxttar] = 0;
                    }
                }
                break;
            }
        }
    }
}

void MainWindow::showtar(int tar)
{
    if (ActiveInfo[tar] > 2) return;
    if (ActiveInfo[tar] == 2) god = true; else god = false;
    int myx = xMap[tar];
    int myy = yMap[tar];
    for (int i = 1; i <= 10; i++)
        for (int j = 1; j <= 10; j++)
            choseMap[i][j] = 0;
    //qDebug() << "flag[" << tar << "] = " << flag[tar];
    //qDebug() << "dfsmax = " << dfsmax;
    if (flag[tar] < dfsmax) return;
    //qDebug() << "flag" << myx << " " << myy << " " << flag[tar];

    if (flag[tar] == 0)
    {
        for (int i = 0; i < 4; i++)
        {
            int x = myx + dx[i];
            int y = myy + dy[i];

            if ((x > myx) && (!god)) continue;
            int mytar = intMap[x][y];
            if (mytar == -1) continue;
            if (ActiveInfo[mytar] == 0)
            {
                //qDebug() << x << " " << y;
                choseMap[x][y] = 1;
            }
            else
                continue;
            if (!god) continue;
            for (int j = 2; ; j++)
            {
                x = myx + j * dx[i];
                y = myy + j * dy[i];
                mytar = intMap[x][y];
                if (mytar == -1) break;
                if (ActiveInfo[mytar] == 0)
                {
                    //qDebug() << x << " " << y;
                    choseMap[x][y] = 1;
                }
                else
                    break;
            }
        }
    }
    else
    {
        dfsans = 0;
        dfslo(tar, 0, "");
        //qDebug() << "dfsans" << dfsans;
        for (int i = 1; i <= dfsans; i++)
        {
            if (dfseat[i] != dfsmax) continue;
            int temp = 0;
            temp = 10 * (((int)dfsdir[i][0]) - 48) + (((int)dfsdir[i][1]) - 48);
            //qDebug() << "aa" << (((int)dfsdir[i][0]) - 48) << " " << (((int)dfsdir[i][1]) - 48);
            //qDebug() << "search" << temp;
            //qDebug() << "(x,y)" << xMap[temp] << " " << yMap[temp];
            choseMap[xMap[temp]][yMap[temp]] = 1;
        }
    }

    for (int i = 1; i <= 10; i++)
        for (int j = 1; j <= 10; j++)
            if (choseMap[i][j])
            {
                int mytar = intMap[i][j];
                ActiveMap[mytar]->setIconSize(QSize(35,50));
                ActiveMap[mytar]->setIcon(* taricon);
                ActiveMap[mytar]->show();
            }

    /*if (ActiveInfo[tar] == 1)
    {
        for (int i = 0; i < 4; i++)
        {
            int x = myx + dx[i];
            int y = myy + dy[i];
            if (x > myx) continue;
            int mytar = intMap[x][y];
            if (mytar == -1) continue;
            if (ActiveInfo[mytar] == 0)
            {
                ActiveMap[mytar]->setIconSize(QSize(30,30));
                ActiveMap[mytar]->setIcon(* taricon);
                ActiveMap[mytar]->show();
            }
        }
    }
    else
    {

    }*/
}

void MainWindow::hidetar()
{
    for (int i = 1; i <= 10; i++)
        for (int j = 1; j <= 10; j++)
            if (choseMap[i][j])
            {
                int mytar = intMap[i][j];
                ActiveMap[mytar]->setIconSize(QSize(30,30));
                ActiveMap[mytar]->setIcon(* empt);
                ActiveMap[mytar]->show();
                choseMap[i][j] = 0;
            }
    /*if (ActiveInfo[tar] > 2) return;
    int myx = xMap[tar];
    int myy = yMap[tar];
    if (ActiveInfo[tar] == 1)
    {
        for (int i = 0; i < 4; i++)
        {
            int x = myx + dx[i];
            int y = myy + dy[i];
            int mytar = intMap[x][y];
            if (mytar == -1) continue;
            if (ActiveInfo[mytar] == 0)
            {
                ActiveMap[mytar]->setIconSize(QSize(30,30));
                ActiveMap[mytar]->setIcon(* empt);
                ActiveMap[mytar]->show();
            }
        }
    }
    else
    {

    }*/
}

void MainWindow::shine(int tar)
{
    if (ActiveInfo[tar] == 1)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* ocicon2);
        ActiveMap[tar]->show();
        return;
    }
    if (ActiveInfo[tar] == 2)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* ocicon3);
        ActiveMap[tar]->show();
        return;
    }
    ActiveMap[tar]->setStyleSheet("border: 4px solid rgba(255,255,255,0.4); background-color: rgba(129,186,213,0.7)");
}

void MainWindow::dark(int tar)
{
    if (ActiveInfo[tar] == 1)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* ocicon);
        ActiveMap[tar]->show();
        return;
    }
    if (ActiveInfo[tar] == 2)
    {
        ActiveMap[tar]->setIconSize(QSize(30,30));
        ActiveMap[tar]->setIcon(* ocicon1);
        ActiveMap[tar]->show();
        return;
    }
    ActiveMap[tar]->setStyleSheet("background-color: rgba(129,186,213,0.7)");
}
