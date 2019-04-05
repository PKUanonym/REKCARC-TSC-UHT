#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFont>
#include <QString>
#include <QDebug>
#include <QMessageBox>
#include <QPalette>
#include <QKeyEvent>
#include <QPainter>
#include <QGroupBox>
#include <QTextCodec>
#include <QPainter>
#include <QDir>

static QFont gamefont("Ubuntu",16);//,QFont::Bold);
static QFont smallfont("Ubuntu",10);

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    select_x=select_y=0;level=1;history_temp=-1;wrongstate=0;state=0;
    ui->setupUi(this);
    //set tablewidget
    ui->tableWidget->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableWidget->setFocusPolicy(Qt::NoFocus);
    ui->tableWidget->setColumnCount(3);
    ui->tableWidget->setRowCount(3);
    ui->tableWidget->resize(401,401);
    ui->tableWidget->verticalHeader()->setVisible(false);
    ui->tableWidget->horizontalHeader()->setVisible(false);
    ui->tableWidget->setShowGrid(true);
    ui->tableWidget->installEventFilter(this);
    for(int i=0;i<3;++i)
    {
        ui->tableWidget->setRowHeight(i,133);
        ui->tableWidget->setColumnWidth(i,133);
    }
    //set 81 button
    button=new QPushButton**[3];
    for(int i=0;i<3;++i)
    {
        button[i]=new QPushButton*[3];
        for(int j=0;j<3;++j)
        {
            button[i][j]=new QPushButton;
            //button[i][j]->setMinimumSize(20,20);
            button[i][j]->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Expanding);
            button[i][j]->setFont(gamefont);
            button[i][j]->installEventFilter(this);
            ui->tableWidget->setBackgroundRole(QPalette::ColorRole());
            ui->tableWidget->setCellWidget(i,j,button[i][j]);
            button[i][j]->setAccessibleName(QString::number(i*3+j));
            connect(button[i][j],SIGNAL(clicked()),this,SLOT(on_button_clicked()));
            //QPalette pal=button[i][j]->palette();
            //if((i/3*3+j/3)&1)button[i][j]->setStyleSheet("color:black;background-color:lightgray");
            //else
            button[i][j]->setStyleSheet("color:black;background:white;");
            button[i][j]->setText(QString(" "));
            button[i][j]->setFlat(true);
            button[i][j]->setAutoFillBackground(true);
            button[i][j]->setDisabled(true);
            button[i][j]->setFocusPolicy(Qt::NoFocus);
        }
    }
    //set media player
//    QDir dir;
    player=new QMediaPlayer;
    player->setMedia(QUrl("qrc:/fig/LuvLetter.wav"));//dir.currentPath()+"/../sudoku/LuvLetter.wav"));
    showinfo();
}

void MainWindow::loadprob(int clear)
{
    m=prob;
    for(int i=0;i<3;++i)
        for(int j=0;j<3;++j)
            if(level==0)
                prob.m[i][j]=m.m[i][j]=0;
    if(clear)
    {
        //clear all history record
        history_temp=0;
        history.clear();history.append(m);
        hx.clear();hx.append(select_x);
        hy.clear();hy.append(select_y);
    }
    refreshsxy(1);
}

void MainWindow::newgame()
{
    //init game
    if(level==0)prob.init(".........");
    else sol.generate(10),prob=sol.a;
    prob.print();
    loadprob(1);state=1;
}

void MainWindow::pause()
{
    if(state!=1||level==0)return;
    QIcon icon;
    icon.addFile(":/fig/play");
    ui->actionPause->setIcon(icon);
    state=2;
    for(int i=0;i<3;++i)
        for(int j=0;j<3;++j)
        {
            button[i][j]->setText(" ");
            button[i][j]->setDisabled(true);
            button[i][j]->setFlat(true);
            button[i][j]->setStyleSheet("background-color:white");
            button[i][j]->setAutoFillBackground(true);
            button[i][j]->setAutoDefault(false);
            button[i][j]->setDefault(false);
        }
}

void MainWindow::continuegame()
{
    if(state!=2||level==0)return;
    QIcon icon;
    icon.addFile(":fig/pause");
    ui->actionPause->setIcon(icon);
    state=1;
    refreshsxy(0);
}

int MainWindow::checkavailable()
{
    int wrong_cnt=0,num_cnt[9]={0};
    for(int i=0;i<3;++i)
        for(int j=0;j<3;++j)
        {
            num_cnt[m.m[i][j]]++;
            if(m.m[i][j]&&num_cnt[m.m[i][j]]>1)
                wrong_cnt++;
        }
    return wrong_cnt==0;
}

void MainWindow::refreshsxy(int add)
{
    if(add&&m!=history[history.length()-1])
    {
        history_temp=history.length();
        history.append(m);
        hx.append(select_x);
        hy.append(select_y);
    }
    //set normal grid
    for(int i=0;i<3;++i)
        for(int j=0;j<3;++j)
            if(m.m[i][j])
            {
                button[i][j]->setText(tr("%1").arg(m.m[i][j]));
                button[i][j]->setStyleSheet("color:black;background-color:white");
                button[i][j]->setFlat(true);
                button[i][j]->setFont(gamefont);
                //button[i][j]->setAutoDefault(false);
                //button[i][j]->setDefault(false);
            }
            else
            {
                button[i][j]->setStyleSheet("color:green;background-color:white");
                button[i][j]->setFont(gamefont);
                button[i][j]->setText(QString(" "));
                button[i][j]->setAutoFillBackground(true);
                button[i][j]->setFlat(true);
                //button[i][j]->setAutoDefault(false);
                //button[i][j]->setDefault(false);
            }
    //set highlight grid
    button[select_x][select_y]->setStyleSheet("color:blue;background-color:white");
    button[select_x][select_y]->setFocusPolicy(Qt::NoFocus);
    //set wrong grid
    if(checkavailable())wrongstate=0;
    else wrongstate=1;
    button[select_x][select_y]->setFlat(true);
    button[select_x][select_y]->setAutoFillBackground(false);
    for(int i=0;i<3;++i)
        for(int j=0;j<3;++j)
        {
            button[i][j]->setFocusPolicy(Qt::NoFocus);
            button[i][j]->setDisabled(false);
            button[i][j]->setAutoDefault(false);
            button[i][j]->setDefault(false);
            button[i][j]->setAutoExclusive(false);
        }
    button[select_x][select_y]->setAutoDefault(true);
    button[select_x][select_y]->setDefault(true);
    QString px("ABC"),py("123");
    ui->statusBar->showMessage("("+px[select_x]+","+py[select_y]+")");
    //update();
    Mat tmp;
    tmp.init("12345678.");
    if(!(m!=tmp))
        finish();
}

void MainWindow::addnumber(int num)
{
    if(level==0)//custom mode
    {
        int tmp1=prob.m[select_x][select_y],tmp2=m.m[select_x][select_y];
        prob.m[select_x][select_y]=num;
        m.m[select_x][select_y]=num;
        refreshsxy(0);
//        qDebug()<<wrongstate;
        if(wrongstate)
        {
            prob.m[select_x][select_y]=tmp1;
            m.m[select_x][select_y]=tmp2;
        }
        refreshsxy(1);
    }
}

void MainWindow::deletegrid()
{
    if(level==0){//custom mode
        prob.m[select_x][select_y]=0;
        m.m[select_x][select_y]=0;
    }
}

void MainWindow::keyPressEvent(QKeyEvent *e)
{//qDebug()<<"key pressed";
    if(state!=1)return;
    if(e->key()>=Qt::Key_1&&e->key()<=Qt::Key_9)
    {
        addnumber(e->key()-Qt::Key_1+1);
        return;
    }
    switch (e->key()){
    case Qt::Key_Delete:
        deletegrid();
        break;
    case Qt::Key_Up:
    case Qt::Key_I:
    case Qt::Key_W:
        if(level&&select_x>0&&m.m[select_x-1][select_y]==0)
        {
            m.m[select_x-1][select_y]=m.m[select_x][select_y];
            m.m[select_x][select_y]=0;
        }
        select_x=(select_x+2)%3;
//        qDebug()<<"key up";
        break;
    case Qt::Key_Down:
    case Qt::Key_K:
    case Qt::Key_S:
        if(level&&select_x<2&&m.m[select_x+1][select_y]==0)
        {
            m.m[select_x+1][select_y]=m.m[select_x][select_y];
            m.m[select_x][select_y]=0;
        }
        select_x=(select_x+1)%3;
//        qDebug()<<"key down";
        break;
    case Qt::Key_Left:
    case Qt::Key_J:
    case Qt::Key_A:
        if(level&&select_y>0&&m.m[select_x][select_y-1]==0)
        {
            m.m[select_x][select_y-1]=m.m[select_x][select_y];
            m.m[select_x][select_y]=0;
        }
        select_y=(select_y+2)%3;
//        qDebug()<<"key left";
        break;
    case Qt::Key_Right:
    case Qt::Key_L:
    case Qt::Key_D:
        if(level&&select_y<2&&m.m[select_x][select_y+1]==0)
        {
            m.m[select_x][select_y+1]=m.m[select_x][select_y];
            m.m[select_x][select_y]=0;
        }
        select_y=(select_y+1)%3;
//        qDebug()<<"key right";
        break;
    default:
        QWidget::keyPressEvent(e);
    }
    refreshsxy(0);
//    qDebug()<<select_x<<" "<<select_y;
}

void MainWindow::on_button_clicked()
{
    if(state!=1)return;
    QPushButton*btn=qobject_cast<QPushButton*>(sender());
    int id=btn->accessibleName().toInt();
    select_x=id/3;
    select_y=id%3;
    refreshsxy(0);
//    qDebug()<<id<<" "<<select_x<<" "<<select_y;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::showinfo()
{
    QString mes;
    mes+="\nThank you for playing this game.\n";
    mes+="This program ensure problems have only one solution.\n";
    mes+="    Key W/A/S/D or I/J/K/L: Up/Left/Down/Right;\n";
    mes+="    Key 1-9: add a number to a certain grid in custom mode;\n";
    mes+="    Key Delete: delete all numbers in a certain grid;\n";
    mes+="    Key Space: pause/start;\n";
    mes+="    Ctrl+Z: Undo;\n";
    mes+="    Ctrl+Y: Redo;\n";
    mes+="    Ctrl+M: Play/Stop music;\n";
    mes+="    Alt+I: Show this info;\n";
    mes+="\nHave fun!\n";
    QMessageBox::information(this,tr("Sudoku game"),mes);
}

void MainWindow::on_actionInfo_triggered()
{
    showinfo();
}

void MainWindow::finish()
{
    state=3;
    if(level==0)return;
    QMessageBox::information(this,tr("Success!"),"Success!",tr("Meow~"));
}

void MainWindow::undo()
{
    if(history_temp<=0)
        return;
    m=history[--history_temp];
    select_x=hx[history_temp];
    select_y=hy[history_temp];
    if(level==0)
        prob=m;
    refreshsxy(0);
}

void MainWindow::redo()
{
    if(history_temp>=history.length()-1)
        return;
    m=history[++history_temp];
    select_x=hx[history_temp];
    select_y=hy[history_temp];
    if(level==0)
        prob=m;
    refreshsxy(0);
}

void MainWindow::on_actionReset_triggered()
{
    if(state!=1)return;
    loadprob(0);
}

void MainWindow::on_actionPause_triggered()
{
    if(state==1)
        pause();
    else if(state==2)
        continuegame();
}

void MainWindow::on_actionUndo_triggered(){if(state!=1)return;undo();}
void MainWindow::on_actionRedo_triggered(){if(state!=1)return;redo();}

void MainWindow::on_actionMusic_triggered()
{
    if(player->state()==QMediaPlayer::PlayingState)
    {//turn off
        QIcon icon;
        icon.addFile(":/fig/mute");
        ui->actionMusic->setIcon(icon);
//        player->pause();
    }
    else
    {//turn on
        QIcon icon;
        icon.addFile(":/fig/music");
        ui->actionMusic->setIcon(icon);
        player->setVolume(30);
        player->play();
    }
}

void MainWindow::on_actionRandom_5_triggered()
{
    level=1;
    if(m.cnt0()==9)newgame();
    state=1;
}

void MainWindow::on_actionCustom_triggered()
{
    level=0;state=1;//newgame();
}

void MainWindow::on_actionNew_Game_triggered()
{
    level=1;newgame();
}
