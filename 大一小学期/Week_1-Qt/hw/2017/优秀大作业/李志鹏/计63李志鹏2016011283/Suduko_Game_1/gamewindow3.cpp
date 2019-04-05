#include "gamewindow3.h"
#include "ui_gamewindow3.h"
#include <QPushButton>
#include <QSignalMapper>
#include <QDebug>
#include <QMessageBox>
#include <QtMultimedia/QSound>

GameWindow3::GameWindow3(int x, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::GameWindow3)
{
    ui->setupUi(this);
    isStart=true;
    temp=true;
    diy=false;
    keyboard=true;
    sound=true;
    for(int i=0; i<81; i++)
        flag[i]=false;
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            mark[i][j]=0;
    setFixedSize(1500, 720);
    setWindowTitle("Sudoku Game");
    sudo=new sudoku(x);
    sudo->produce(x);
    ui->pushButton_7->hide();
    ui->pushButton_9->hide();
    ui->pushButton_10->hide();
    ui->checkBox->setCheckState(Qt::CheckState::Checked);
    ui->checkBox_2->setCheckState(Qt::CheckState::Checked);



    labels=new QLabel**[9];
    for(int i=0; i<9; i++)
        labels[i]=new QLabel*[9];
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            labels[i][j]=new QLabel(this);
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            labels[i][j]->setStyleSheet(QString("background-color: rgb(255, 171, 69);"));
            labels[i][j]->setGeometry(50+j*70, 30+i*70, 60, 60);
            labels[i][j]->hide();
        }



    game=new QPushButton**[9];
    for(int i=0; i<9; i++)
        game[i]=new QPushButton*[9];
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            game[i][j]=new QPushButton(this);
            game[i][j]->setGeometry(50+j*70, 30+i*70, 60, 60);
        }
    options=new QPushButton*[9];
    for(int i=0; i<9; i++)
    {
        options[i]=new QPushButton(this);
        options[i]->setText(QString::number(i+1));
        options[i]->setGeometry(710, 50+i*60, 50, 50);
    }
    load(sudo->num);
    resetColor();



    copy=new sudoku;
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            copy->num[i][j].val=sudo->num[i][j].val;
            copy->num[i][j].isCert=sudo->num[i][j].isCert;
        }
    copy->cert=sudo->cert;
    copy->solve();



    timer = new QTimer(this);
    connect(timer,SIGNAL(timeout()),this,SLOT(timerUpdate()));
    ui->lcdNumber->setDigitCount(10);
    timer->start(1000);
    time=new QTime(0, 0, 0);
    ui->lcdNumber->display(time->toString("hh:mm:ss"));



    QSignalMapper *mapper=new QSignalMapper(this);
    for(int i=0; i<9; i++)
    {
        connect(options[i], SIGNAL(clicked(bool)), mapper, SLOT(map()));
        mapper->setMapping(options[i], i);
    }
    connect(mapper, SIGNAL(mapped(int)), this, SLOT(alter_t(int)));

    QSignalMapper *mappert=new QSignalMapper(this);
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            connect(game[i][j], SIGNAL(clicked(bool)), mappert, SLOT(map()));
            mappert->setMapping(game[i][j], i*9+j);
        }
    connect(mappert, SIGNAL(mapped(int)), this, SLOT(alter(int)));
}

void GameWindow3::alter(int x)
{
    if(ui->checkBox->isChecked())
        sound=true;
    else if(!ui->checkBox->isChecked())
        sound=false;
    if(ui->checkBox_2->isChecked())
        keyboard=true;
    else if(!ui->checkBox_2->isChecked())
        keyboard=false;
    if(sound)
        QSound::play("C:\\Users\\19081\\Documents\\Qt Creator\\Suduko_Game_1\\sound1.wav");
    for(int i=0; i<81; i++)
        flag[i]=false;
    flag[x]=true;
    int tempj=x%9;
    int tempi=(x-tempj)/9;
    resetColor();


    int tt=0;
    for(int k=0; k<9; k++)
        if(sudo->num[tempi][tempj].posb[k]!=0)
            tt++;
    if(tt==1||tt==0)
    {
        if(sudo->num[tempi][tempj].val!=0)
            for(int i=0; i<9; i++)
                for(int j=0; j<9; j++)
                    if(sudo->num[i][j].val==sudo->num[tempi][tempj].val)
                    {
                        game[i][j]->setStyleSheet("background-color: rgb(255, 255, 255); border: 1px solid white; border-radius: 10px; font-size: 40px");
                    }
        game[tempi][tempj]->setStyleSheet("background-color: rgb(255, 255, 255); border: 1px solid white; border-radius: 10px; font-size: 40px");
    }
    else
        game[tempi][tempj]->setStyleSheet("background-color: rgb(255, 255, 255); border: 1px solid white; border-radius: 10px;");
}

void GameWindow3::alter_t(int x)
{
    if(!diy)
    {
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(flag[i*9+j])
                {
                    if(sudo->num[i][j].isCert)
                        QMessageBox::critical(NULL, "Error Informaiton", "This number CANNOT be changed!");
                    else if(sudo->num[i][j].pos()==1)
                    {
                        bool tt=0;
                        for(int k=0; k<9; k++)
                            if(sudo->num[i][j].posb[k]==x+1)
                            {
                                tt=1;
                                int ttt[9]={};
                                for(int h=0; h<9; h++)
                                    ttt[h]=sudo->num[i][j].posb[h];
                                sudo->num[i][j].posb[k]=0;
                                game[i][j]->setText(sudo->num[i][j].getStr());
                                operation tempOpe(ttt, sudo->num[i][j].posb, i, j);
                                ope.push(tempOpe);
                                if(sudo->num[i][j].pos()==0)
                                    for(int h=0; h<9; h++)
                                        if(sudo->num[i][j].posb[h])
                                            sudo->num[i][j].val=sudo->num[i][j].posb[h];

                            }
                        if(!tt)
                        {
                            int ttt[9]={};
                            for(int h=0; h<9; h++)
                                ttt[h]=sudo->num[i][j].posb[h];
                            for(int h=0; h<9; h++)
                                if(sudo->num[i][j].posb[h]==0)
                                {
                                    sudo->num[i][j].posb[h]=x+1;
                                    break;
                                }
                            game[i][j]->setText(sudo->num[i][j].getStr());
                            operation tempOpe(ttt, sudo->num[i][j].posb, i, j);
                            ope.push(tempOpe);
                        }
                    }
                    else if(sudo->num[i][j].pos()==0&&sudo->num[i][j].val==x+1)
                        ;
                    else if(sudo->num[i][j].pos()==-1)
                    {
                        game[i][j]->setText(QString::number(x+1));
                        operation tempOpe(sudo->num[i][j].val, x+1, i, j);
                        ope.push(tempOpe);
                        sudo->num[i][j].val=x+1;
                        sudo->num[i][j].posb[0]=x+1;
                    }
                    else
                    {
                        int ttt[9]={};
                        sudo->num[i][j].val=0;
                        for(int h=0; h<9; h++)
                            ttt[h]=sudo->num[i][j].posb[h];
                        for(int h=0; h<9; h++)
                            if(sudo->num[i][j].posb[h]==0)
                            {
                                sudo->num[i][j].posb[h]=x+1;
                                break;
                            }
                        game[i][j]->setText(sudo->  num[i][j].getStr());
                        operation tempOpe(ttt, sudo->num[i][j].posb, i, j);
                        ope.push(tempOpe);
                    }
                    flag[i*9+j]=false;
                    resetColor();
                }
        bool ttbool=1;
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(sudo->num[i][j].val==0)
                {
                    ttbool=0;
                    break;
                }
        if(ttbool)
            if(sudo->sValid())
            {
                on_pushButton_2_clicked();
                QMessageBox::information(NULL, "Victory Information", "Congratulations!");
                for(int i=0; i<81; i++)
                    flag[i]=false;
                return ;
            }
    }
    else
    {
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(flag[i*9+j])
                {
                    operation tempOpe(sudo->num[i][j].val, x+1, i, j);
                    ope.push(tempOpe);
                    sudo->num[i][j].val=x+1;
                    sudo->num[i][j].isCert=true;
                    game[i][j]->setText(QString::number(x+1));
                    resetColor();
                }
    }
    for(int i=0; i<81; i++)
        flag[i]=false;
}

void GameWindow3::timerUpdate()
{
    *time=time->addSecs(1);
    QString strTime = time->toString("hh:mm:ss");
    ui->lcdNumber->display(strTime);
}

GameWindow3::~GameWindow3()
{
    delete ui;
}

void GameWindow3::on_pushButton_2_clicked()
{
    if(isStart)
    {
        ui->pushButton_2->setStyleSheet("background-image: url(:/new/prefix1/continue.PNG)");
        timer->stop();
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                game[i][j]->hide();
    }
    else
    {
        ui->pushButton_2->setStyleSheet("background-image: url(:/new/prefix1/pause.PNG)");
        timer->start(1000);
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                game[i][j]->show();
    }
    isStart=!isStart;
}

void GameWindow3::load(grid **x)
{
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(x[i][j].val!=0)
                game[i][j]->setText(QString::number(x[i][j].val));
}

void GameWindow3::resetColor()
{
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            if(sudo->num[i][j].isCert)
                game[i][j]->setStyleSheet("background-color: rgb(234, 232, 237); border: 1px solid rgb(234, 232, 237); border-radius: 10px; font-size: 40px");
            else if(sudo->num[i][j].pos()==0||sudo->num[i][j].pos()==-1)
                game[i][j]->setStyleSheet("background-color: rgb(243, 241, 251); border: 1px solid rgb(243, 241, 251); border-radius: 10px; font-size: 40px");
            else
                game[i][j]->setStyleSheet("background-color: rgb(243, 241, 251); border: 1px solid rgb(243, 241, 251); border-radius: 10px; font-size: 15px");
        }
    for(int i=0; i<9; i++)
        options[i]->setStyleSheet("background-color: rgb(100, 195, 197); border: 1px solid rgb(100, 195, 197); border-radius: 10px; font-size: 40px");
}

void GameWindow3::on_pushButton_6_clicked()
{
    if(sound)
        QApplication::beep();
    if(!diy)
    {
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(flag[i*9+j])
                {
                    if(sudo->num[i][j].isCert)
                        QMessageBox::critical(NULL, "Error Informaiton", "This number CANNOT be deleted!");
                    else if(sudo->num[i][j].pos()==1)
                    {
                        game[i][j]->setText(QString());
                        int ttt[9]={};
                        operation tempOpe(sudo->num[i][j].posb,ttt, i, j);
                        ope.push(tempOpe);
                        for(int k=0; k<9; k++)
                            sudo->num[i][j].posb[k]=0;
                        sudo->num[i][j].val=0;
                    }
                    else if(sudo->num[i][j].pos()==-1)
                        QMessageBox::information(NULL, "Error Information", "There is no number to be deleted!");
                    else
                    {
                        game[i][j]->setText(QString());
                        operation tempOpe(sudo->num[i][j].val, 0, i, j);
                        ope.push(tempOpe);
                        sudo->num[i][j].val=0;
                        for(int k=0; k<9; k++)
                            sudo->num[i][j].posb[k]=0;
                        sudo->num[i][j].val=0;
                    }
                    flag[i*9+j]=false;
                    resetColor();
                }
    }
    else
    {
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(flag[i*9+j])
                {
                    if(sudo->num[i][j].isCert)
                    {
                        operation tempOpe(sudo->num[i][j].val, 0, i, j);
                        ope.push(tempOpe);
                        game[i][j]->setText(QString());
                        sudo->num[i][j].val=0;
                        sudo->num[i][j].isCert=false;
                    }
                    else
                        QMessageBox::information(NULL, "Error Information", "There is no number to be deleted!");
                    resetColor();
                }
    }
}

void GameWindow3::on_pushButton_clicked()
{
    QMessageBox temp;
    temp.setIcon(QMessageBox::Warning);
    temp.setWindowTitle(tr("Replay Reminder"));
    temp.setText(tr("Do you want to replay?"));
    QPushButton *tempy=new QPushButton(this);
    QPushButton *tempn=new QPushButton(this);
    tempy=temp.addButton(tr("Yes"), QMessageBox::YesRole);
    tempn=temp.addButton(tr("No"), QMessageBox::NoRole);
    connect(tempy, SIGNAL(clicked()), this, SLOT(replay()));
    temp.show();
    temp.exec();
}

void GameWindow3::replay()
{
    resetColor();
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            flag[i*9+j]=false;
            if(!sudo->num[i][j].isCert)
            {
                sudo->num[i][j].val=0;
                for(int k=0; k<9; k++)
                    sudo->num[i][j].posb[k]=0;
                game[i][j]->setText(QString());
            }
        }
    while(!ope.empty())
        ope.pop();
    while(!resumeOpe.empty())
        resumeOpe.pop();
    time->setHMS(0, 0, 0);
}

void GameWindow3::on_pushButton_3_clicked()
{
    resetColor();
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            //if(copy->num[i][j].val!=sudo->num[i][j].val&&sudo->num[i][j].val!=0)
            if(sudo->num[i][j].val!=0&&!sudo->sxValid(i, j)&&!sudo->num[i][j].isCert)
            {
                int tt=0;
                for(int k=0; k<9; k++)
                    if(sudo->num[i][j].posb[k]!=0)
                        tt++;
                if(tt==0||tt==1)
                    game[i][j]->setStyleSheet("background-color: rgb(255, 0, 0); border: 1px solid rgb(255, 0, 0); border-radius: 10px; font-size: 40px");
                else
                    continue;
                return ;
            }
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(flag[i*9+j])
                if(copy->num[i][j].val!=sudo->num[i][j].val&&sudo->num[i][j].val==0)
                {
                    int tt=0;
                    for(int k=0; k<9; k++)
                        if(sudo->num[i][j].posb[k]!=0)
                            tt++;
                    if(tt==0)
                    {
                        operation tempOpe(sudo->num[i][j].val, copy->num[i][j].val, i, j);
                        ope.push(tempOpe);
                        sudo->num[i][j].val=copy->num[i][j].val;
                        sudo->num[i][j].posb[0]=copy->num[i][j].val;
                        game[i][j]->setText(QString::number(sudo->num[i][j].val));
                        game[i][j]->setStyleSheet("background-color: rgb(0, 255, 0); border: 1px solid rgb(0, 255, 0); border-radius: 10px; font-size: 40px");
                    }
                    else
                        continue;
                    return ;
                }
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(copy->num[i][j].val!=sudo->num[i][j].val&&sudo->num[i][j].val==0)
            {
                int tt=0;
                for(int k=0; k<9; k++)
                    if(sudo->num[i][j].posb[k]!=0)
                        tt++;
                if(tt==0)
                {
                    operation tempOpe(sudo->num[i][j].val, copy->num[i][j].val, i, j);
                    ope.push(tempOpe);
                    sudo->num[i][j].val=copy->num[i][j].val;
                    sudo->num[i][j].posb[0]=copy->num[i][j].val;
                    game[i][j]->setText(QString::number(sudo->num[i][j].val));
                    game[i][j]->setStyleSheet("background-color: rgb(0, 255, 0); border: 1px solid rgb(0, 255, 0); border-radius: 10px; font-size: 40px");
                }
                return ;
            }
    temp=1;
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(sudo->num[i][j].val!=copy->num[i][j].val)
            {
                temp=0;
                break;
            }
    if(temp)
    {
        on_pushButton_2_clicked();
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                game[i][j]->show();
        QMessageBox::information(NULL, "Victory Information", "Congratulations!");
    }
}

void GameWindow3::on_pushButton_4_clicked()
{
    if(ope.empty())
    {
        QMessageBox::critical(NULL, "Invalid Operation!", "There is no operation to recall!");
        return ;
    }
    operation globalOpe=ope.pop();
    resumeOpe.push(globalOpe);
    if(globalOpe.newVal)
    {
        sudo->num[globalOpe.gridx][globalOpe.gridy].val=globalOpe.oldVal;
        for(int i=0; i<9; i++)
            sudo->num[globalOpe.gridx][globalOpe.gridy].posb[i]=0;
        if(globalOpe.oldVal!=0)
            game[globalOpe.gridx][globalOpe.gridy]->setText(QString::number(globalOpe.oldVal));
        else
            game[globalOpe.gridx][globalOpe.gridy]->setText(QString());
        if(diy)
            for(int i=0; i<9; i++)
                for(int j=0; j<9; j++)
                {
                    if(sudo->num[i][j].val)
                        sudo->num[i][j].isCert=true;
                    else
                        sudo->num[i][j].isCert=false;
                }
    }
    else
    {
        for(int i=0; i<9; i++)
            sudo->num[globalOpe.gridx][globalOpe.gridy].posb[i]=globalOpe.oldPosb[i];
        game[globalOpe.gridx][globalOpe.gridy]->setText(sudo->num[globalOpe.gridx][globalOpe.gridy].getStr());
    }
    resetColor();
}

void GameWindow3::on_pushButton_5_clicked()
{
    if(resumeOpe.empty())
    {
        QMessageBox::critical(NULL, "Invalid Operation", "There is no operation to resume!");
        return ;
    }
    operation globalOpe=resumeOpe.pop();
    ope.push(globalOpe);
    if(globalOpe.newVal)
    {
        sudo->num[globalOpe.gridx][globalOpe.gridy].val=globalOpe.newVal;
        sudo->num[globalOpe.gridx][globalOpe.gridy].posb[0]=globalOpe.newVal;
        if(globalOpe.newVal)
            game[globalOpe.gridx][globalOpe.gridy]->setText(QString::number(globalOpe.newVal));
        else
            game[globalOpe.gridx][globalOpe.gridy]->setText(QString());
        if(diy)
            for(int i=0; i<9; i++)
                for(int j=0; j<9; j++)
                {
                    if(sudo->num[i][j].val)
                        sudo->num[i][j].isCert=true;
                    else
                        sudo->num[i][j].isCert=false;
                }
    }
    else
    {
        for(int i=0; i<9; i++)
            sudo->num[globalOpe.gridx][globalOpe.gridy].posb[i]=globalOpe.newPosb[i];
        game[globalOpe.gridx][globalOpe.gridy]->setText(sudo->num[globalOpe.gridx][globalOpe.gridy].getStr());
    }
    resetColor();
}

void GameWindow3::on_pushButton_8_clicked()
{
    QMessageBox temp;
    temp.setIcon(QMessageBox::Warning);
    temp.setWindowTitle(tr("Quit Reminder"));
    temp.setText(tr("Do you want to quit?"));
    QPushButton *tempy=new QPushButton(this);
    QPushButton *tempn=new QPushButton(this);
    tempy=temp.addButton(tr("Yes"), QMessageBox::YesRole);
    tempn=temp.addButton(tr("No"), QMessageBox::NoRole);
    connect(tempy, SIGNAL(clicked()), this, SLOT(close()));
    temp.show();
    temp.exec();
}

void GameWindow3::on_pushButton_7_clicked()
{
    diy=true;
    ui->pushButton->hide();
    ui->pushButton_2->hide();
    ui->pushButton_3->hide();
    ui->pushButton_7->hide();
    ui->pushButton_11->hide();
    ui->lcdNumber->hide();
    ui->pushButton_9->show();
    ui->pushButton_10->show();
    ui->pushButton_4->setGeometry(900, 370, 131, 131);
    ui->pushButton_5->setGeometry(1100, 370, 131, 131);
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            sudo->num[i][j].val=0;
            sudo->num[i][j].isCert=false;
            game[i][j]->setText(QString());
        }
    resetColor();
}

void GameWindow3::on_pushButton_9_clicked()
{
    int tt=0;
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(sudo->num[i][j].val)
                tt++;
    if(tt<17)
    {
        QMessageBox::critical(NULL, "Error Information", "No Answer!");
        return ;
    }
    if(!sudo->solve())
    {
        qDebug()<<"HEY";
        QMessageBox::critical(NULL, "Error Information", "No Answer!");
    }
    else
    {
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                game[i][j]->setText(QString::number(sudo->num[i][j].val));
        for(int i=0; i<9; i++)
            options[i]->hide();
    }
}

void GameWindow3::on_pushButton_10_clicked()
{
    QMessageBox temp;
    temp.setIcon(QMessageBox::Warning);
    temp.setWindowTitle(tr("Delete All Reminder"));
    temp.setText(tr("Do you want to delete all?"));
    QPushButton *tempy=new QPushButton(this);
    QPushButton *tempn=new QPushButton(this);
    tempy=temp.addButton(tr("Yes"), QMessageBox::YesRole);
    tempn=temp.addButton(tr("No"), QMessageBox::NoRole);
    connect(tempy, SIGNAL(clicked()), this, SLOT(deleteAll()));
    temp.show();
    temp.exec();
}

void GameWindow3::deleteAll()
{
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            sudo->num[i][j].val=0;
            sudo->num[i][j].isCert=false;
            game[i][j]->setText(QString());
        }
    resetColor();
}

void GameWindow3::on_pushButton_11_clicked()
{
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
            if(flag[i*9+j])
                mark[i][j]=!mark[i][j];
    for(int i=0; i<9; i++)
        for(int j=0; j<9; j++)
        {
            if(mark[i][j])
                labels[i][j]->show();
            else
                labels[i][j]->hide();
        }
}

void GameWindow3::keyPressEvent(QKeyEvent *e)
{
    if(keyboard)
    {
        if(e->modifiers()==Qt::ControlModifier)
        {
            if(e->key()==Qt::Key_Z)
                on_pushButton_4_clicked();
            else if(e->key()==Qt::Key_X)
                on_pushButton_5_clicked();
            else if(e->key()==Qt::Key_C)
                on_pushButton_2_clicked();
            return ;
        }
        for(int i=0; i<9; i++)
            for(int j=0; j<9; j++)
                if(flag[i*9+j])
                {
                    switch(e->key())
                    {
                    case Qt::Key_1:
                        alter_t(0);
                        //sudo->cert++;
                        break;
                    case Qt::Key_2:
                        alter_t(1);
                        break;
                    case Qt::Key_3:
                        alter_t(2);
                        break;
                    case Qt::Key_4:
                        alter_t(3);
                        break;
                    case Qt::Key_5:
                        alter_t(4);
                        break;
                    case Qt::Key_6:
                        alter_t(5);
                        break;
                    case Qt::Key_7:
                        alter_t(6);
                        break;
                    case Qt::Key_8:
                        alter_t(7);
                        break;
                    case Qt::Key_9:
                        alter_t(8);
                        break;
                    case Qt::Key_0:
                        on_pushButton_6_clicked();
                        break;
                    case Qt::Key_Delete:
                        on_pushButton_6_clicked();
                        break;
                    }
                    return ;
                }
    }
}
