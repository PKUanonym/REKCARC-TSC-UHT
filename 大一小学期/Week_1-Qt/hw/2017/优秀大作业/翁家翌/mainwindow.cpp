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
    select_x=select_y=0;level=1;stage=0;history_temp=-1;wrongstate=0;state=0;
    ui->setupUi(this);
    //set blue button
    ui->pushButton->installEventFilter(this);
    ui->pushButton_2->installEventFilter(this);
    ui->pushButton_3->installEventFilter(this);
    ui->pushButton->setFocusPolicy(Qt::NoFocus);
    ui->pushButton_2->setFocusPolicy(Qt::NoFocus);
    ui->pushButton_3->setFocusPolicy(Qt::NoFocus);
    //set timer
    Timer=new QTimer;
    Timerecord=new QTime(0,0,0,0);
    ui->timer->setDigitCount(8);
    ui->timer->setSegmentStyle(QLCDNumber::Flat);
    ui->timer->display(Timerecord->toString("hh:mm:ss"));
    connect(Timer,SIGNAL(timeout()),this,SLOT(timeupdate()));
    //set number button
    num=new QPushButton*[10];
    for(int i=1,cnt=1;i<=3;++i)
        for(int j=1;j<=3;++j,++cnt)
        {
            num[cnt]=new QPushButton;
            QIcon icon;
            icon.addFile(QStringLiteral(":/fig/%1").arg(QString::number(cnt)));
            num[cnt]->setIcon(icon);
            num[cnt]->setFlat(true);
            num[cnt]->setAccessibleName(QString::number(cnt));
            num[cnt]->setFocusPolicy(Qt::NoFocus);
            //num[cnt]->installEventFilter(this);
//            num[cnt]->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Expanding);
            //num[cnt]->setMinimumSize(40,40);
            ui->gridLayout_2->addWidget(num[cnt],i-1,j-1,1,1);
            connect(num[cnt],SIGNAL(clicked(bool)),this,SLOT(on_num_clicked()));
        }
    //set mark button and delete button
    QIcon icon,icon2;
    icon.addFile(QStringLiteral(":/fig/mark"));
    icon2.addFile(":fig/xxx");
    record_button=new QPushButton;
    record_button->setIcon(icon);
    record_button->setFlat(true);
    record_button->setFocusPolicy(Qt::NoFocus);
//    record_button->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Expanding);
    connect(record_button,SIGNAL(clicked(bool)),this,SLOT(on_mark_button_clicked()));
    ui->gridLayout_2->addWidget(record_button,3,1,1,1);
    delete_button=new QPushButton;
    delete_button->setIcon(icon2);
    delete_button->setFlat(true);
    delete_button->setFocusPolicy(Qt::NoFocus);
//    delete_button->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Expanding);
    connect(delete_button,SIGNAL(clicked(bool)),this,SLOT(on_del_button_clicked()));
    ui->gridLayout_2->addWidget(delete_button,3,0,1,1);
    //set tablewidget
    ui->tableWidget->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableWidget->setFocusPolicy(Qt::NoFocus);
    ui->tableWidget->setColumnCount(15);
    ui->tableWidget->setRowCount(15);
    ui->tableWidget->resize(404,404);
    ui->tableWidget->verticalHeader()->setVisible(false);
    ui->tableWidget->horizontalHeader()->setVisible(false);
    ui->tableWidget->setShowGrid(true);
    ui->tableWidget->installEventFilter(this);
    for(int i=0;i<15;++i)
    {
        ui->tableWidget->setRowHeight(i,44);
        ui->tableWidget->setColumnWidth(i,44);
    }
    //set bold line qwq
    ui->tableWidget->setRowHeight(0,1);ui->tableWidget->setColumnWidth(0,1);
    ui->tableWidget->setRowHeight(4,1);ui->tableWidget->setColumnWidth(4,1);
    ui->tableWidget->setRowHeight(5,1);ui->tableWidget->setColumnWidth(5,1);
    ui->tableWidget->setRowHeight(9,1);ui->tableWidget->setColumnWidth(9,1);
    ui->tableWidget->setRowHeight(10,1);ui->tableWidget->setColumnWidth(10,1);
    ui->tableWidget->setRowHeight(14,1);ui->tableWidget->setColumnWidth(14,1);
    //set 81 button
    button=new QPushButton**[9];
    for(int i=0;i<9;++i)
    {
        button[i]=new QPushButton*[9];
        for(int j=0;j<9;++j)
        {
            button[i][j]=new QPushButton;
            //button[i][j]->setMinimumSize(20,20);
            button[i][j]->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Expanding);
            button[i][j]->setFont(gamefont);
            button[i][j]->installEventFilter(this);
            ui->tableWidget->setBackgroundRole(QPalette::ColorRole());
            ui->tableWidget->setCellWidget(i<3?i+1:i<6?i+3:i+5,j<3?j+1:j<6?j+3:j+5,button[i][j]);
            button[i][j]->setAccessibleName(QString::number(i*9+j));
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
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
        {
            if(prob.m[i][j])
                m.m[i][j]=1<<prob.m[i][j];
            else
                m.m[i][j]=0;
        }
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
        {
            mark.m[i][j]=0;
            if(level==0)
                prob.m[i][j]=m.m[i][j]=0;
        }
    if(clear)
    {
        //clear all history record
        history_temp=0;
        history.clear();history.append(m);
        hx.clear();hx.append(select_x);
        hy.clear();hy.append(select_y);
        hmark.clear();hmark.append(mark);
    }
    refreshsxy(1);
}

void MainWindow::showsol(int origin)
{
    if(origin)//no custom node
    {
        double c0=clock();
        sol.solve(prob,1);
        c0=(clock()-c0)/CLOCKS_PER_SEC*1000;
        ui->statusBar->showMessage(QStringLiteral("Solved. Using %1 ms").arg(c0));
    }
    else //custom mode
    if(wrongstate)
    {
        ui->statusBar->showMessage("No solution!");
        return;
    }
    else
    {
        Mat tmp;
        for(int i=0;i<9;++i)
            for(int j=0;j<9;++j)
                if(sol.calc(m.m[i][j])==1)
                    tmp.m[i][j]=sol.idx[m.m[i][j]];
                else
                    tmp.m[i][j]=0;
        int ans=sol.solve(tmp,2);
        double c0=clock();
        sol.solve(tmp,1);
        c0=(clock()-c0)/CLOCKS_PER_SEC*1000;
        if(ans==0)
        {
            //qDebug()<<"No solution";
            ui->statusBar->showMessage(QStringLiteral("No solution! Using %1 ms").arg(c0));
            return;
        }
        else if(ans==2)
            ui->statusBar->showMessage(QStringLiteral("Multiple solution. Using %1 ms").arg(c0));
        else
            ui->statusBar->showMessage(QStringLiteral("Solved. Using %1 ms").arg(c0));
    }
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
        {
            if(prob.m[i][j]==0)
                button[i][j]->setStyleSheet("color:green");
            button[i][j]->setText(QString::number(sol.a.m[i][j]));
            button[i][j]->setFlat(true);
            button[i][j]->setFont(gamefont);
            button[i][j]->setFocusPolicy(Qt::NoFocus);
        }
}

void MainWindow::newgame()
{
    //init game
    //level=1;stage=1;
    if(level==1){
        if(stage==1)      prob.init("369.5247885.6749317143.826568392715459741682..21835697138769.4224.5837199.52413.6");
        else if(stage==2) prob.init("...2..5.32.37569..59..317.21349278569.56.34.16821453977.956..34..13726.93.8..9...");
        else if(stage==3) prob.init("1597.3..8786245.93.4219..6549.3..651537...942621..9.8787..3621.26.8145799..5.7836");
        else if(stage==4) prob.init("286.15.4...467325.37.2.8.6.7.91246..6..387..5..85967.1.9.4.1.72.678529...4.73.816");
        else              sol.generate_range(20,36,1),prob=sol.a;
    }else if(level==2){
        if(stage==1)      prob.init("7...8...94.1..625...6.3..14.6..59.....9...1.....74..2.85..9.6...923..8.76...1...2");
        else if(stage==2) prob.init("4....1.5.9.18.7.6.5.82.41...5..9.......7.5.......1..2...75.29.6.8.1.62.5.6.3....7");
        else if(stage==3) prob.init("......1.....63.95.63..41.2...32.9...72.....91...8.37...4.12..89.95.64.....1......");
        else if(stage==4) prob.init("......87.2....7.51.583..9.2..15..7.9...9.8...9.3..25..6.7..341.12.7....8.34......");
        else              sol.generate_range(42,48,1),prob=sol.a;
    }else if(level==3){
        if(stage==1)      prob.init("6...3495...3.28...2......6.1.98..7.............2..94.1.2......4...27.5...3749...6");
        else if(stage==2) prob.init(".31.97.6....6......2.....18.....5.29..2.7.5..95.1.....17.....3......9....9.86.24.");
        else if(stage==3) prob.init("..7..13.9..6..8...4.3.7..1.1...2..3...........4..3...6.5..1.6.8...4..5..2.95..4..");
        else if(stage==4) prob.init("..1....986...28.....8.76..1....9..25...4.7...59..6....7..24.9.....71...243....1..");
        else              sol.generate_range(53,57,1),prob=sol.a;
    }else if(level==4){
        if(stage==1)      prob.init("8..........36......7..9.2...5...7.......457.....1...3...1....68..85...1..9....4..");
        else if(stage==2) prob.init("16....7..7...3.......4...2.....173..9.......8..452.....1...6.......5...9..9....35");
        else if(stage==3) prob.init(".3...58..6...9...........73...5..43...1...5...48..9...19...........3...5..57...1.");
        else if(stage==4) prob.init("..2..7..4.....9.8..54.........47.8...6.....7...1.36.........16..3.9.....4..3..7..");
        else              sol.generate_range(58,81,1),prob=sol.a;
    }
    else                  prob.init(".................................................................................");
    sol.solve(prob,1);
    prob.print();
    loadprob(1);state=1;
    timerstart();
}

QString MainWindow::chg012s(int x)//change binary number into string
{
    QString s;int cnt=0;
    if(sol.calc(x)==1)
        s.append(sol.idx[x]+'0'),cnt=1;
    else
        for(int i=1;i<=9;++i)
//        {
//            if(x&(1<<i))
//                s.append('0'+i);
//            else
//                s.append(' ');
//            if(i==3||i==6)
//                s.append('\n');
//            else if(i!=9)
//                s.append(' ');
//        }
            if(x&(1<<i))
            {
                if(cnt%2==1)s.append(QString(' '));
                if(cnt==2)
                    s.append(QString('\n'));
                s.append(QString::number(i));
                cnt++;
            }
    if(cnt==0)s.append(' ');
    return s;
}

void MainWindow::pause()
{
    if(state!=1||level==0)return;
    QIcon icon;
    icon.addFile(":/fig/play");
    ui->actionPause->setIcon(icon);
    state=2;
    Timer->stop();
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
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
    Timer->start(1000);
    refreshsxy(0);
}

void MainWindow::showtip()
{
    if(level==0)return;
    int minn=1000;
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
            if(prob.m[i][j]==0&&(1<<sol.a.m[i][j])!=m.m[i][j]&&sol.showtime.m[i][j]<minn)
            {
                minn=sol.showtime.m[i][j];
                select_x=i;
                select_y=j;
            }
    if(minn==1000)return;
    minn=m.m[select_x][select_y];
    m.m[select_x][select_y]=1<<sol.a.m[select_x][select_y];
    refreshsxy(0);
    m.m[select_x][select_y]=minn;
}

int MainWindow::checkavailable(int i,int j)
{
    for(int k=0;k<9;++k)
        if((i!=k&&m.m[k][j]==m.m[i][j])||(j!=k&&m.m[i][k]==m.m[i][j]))
            return 0;
    for(int dx=i/3*3,dy=j/3*3,x=0;x<3;++x)
        for(int y=0;y<3;++y)
            if((i!=x+dx||j!=y+dy)&&m.m[i][j]==m.m[x+dx][y+dy])
                return 0;
    return 1;
}

void MainWindow::refreshsxy(int add)
{
    if(add&&(m!=history[history.length()-1]||mark!=hmark[hmark.length()-1]))
    {
        history_temp=history.length();
        history.append(m);
        hx.append(select_x);
        hy.append(select_y);
        hmark.append(mark);
    }
    //set normal grid
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
            if(prob.m[i][j])
            {
                button[i][j]->setText(chg012s(m.m[i][j]));
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
                if(m.m[i][j])
                {
                    if(sol.calc(m.m[i][j])>1)
                    {
                        button[i][j]->setStyleSheet("color:gray;background-color:white");
                        button[i][j]->setFont(smallfont);
                    }
                    button[i][j]->setText(chg012s(m.m[i][j]));
                }
                else
                {
                    button[i][j]->setText(QString(" "));
                    button[i][j]->setAutoFillBackground(true);
                }
                button[i][j]->setFlat(true);
                //button[i][j]->setAutoDefault(false);
                //button[i][j]->setDefault(false);
            }
    //set highlight grid
    button[select_x][select_y]->setStyleSheet("color:blue;background-color:white");
    button[select_x][select_y]->setFocusPolicy(Qt::NoFocus);
    if(m.m[select_x][select_y]==0)
        for(int i=0;i<9;++i)
        {
            button[i][select_y]->setFlat(false);
            button[select_x][i]->setFlat(false);
        }
    else if(sol.calc(m.m[select_x][select_y])==1)
    {
        for(int i=0;i<9;++i)
            for(int j=0;j<9;++j)
                if(m.m[i][j]==m.m[select_x][select_y])
                    button[i][j]->setFlat(false);
    }
    //set wrong grid
    int wrong_cnt=0,acc_cnt=0;
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
            if(prob.m[i][j]==0&&sol.calc(m.m[i][j])==1)
            {
                acc_cnt++;
                if(checkavailable(i,j)==0)
                {
                    button[i][j]->setStyleSheet("color:red;background-color:white");
                    wrong_cnt++;
                }
            }
            else if(prob.m[i][j]&&checkavailable(i,j)==0)
                wrong_cnt++;
    if(wrong_cnt)wrongstate=1;
    else wrongstate=0;
    button[select_x][select_y]->setFlat(true);
    button[select_x][select_y]->setAutoFillBackground(false);
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
        {
            button[i][j]->setFocusPolicy(Qt::NoFocus);
            button[i][j]->setDisabled(false);
            button[i][j]->setAutoDefault(false);
            button[i][j]->setDefault(false);
            button[i][j]->setAutoExclusive(false);
        }
    button[select_x][select_y]->setAutoDefault(true);
    button[select_x][select_y]->setDefault(true);
    QIcon Ic0,Ic1;
    for(int i=0;i<9;++i)
        for(int j=0;j<9;++j)
            if(mark.m[i][j])
            {
                Ic1.addFile(QStringLiteral(":/fig/mark"));
                button[i][j]->setIcon(Ic1);
            }
            else
                button[i][j]->setIcon(Ic0);
    QString px("ABCDEFGHI"),py("123456789");
    ui->statusBar->showMessage("("+px[select_x]+","+py[select_y]+")");
    //update();
    if(wrong_cnt==0&&acc_cnt==prob.cnt0()&&level)
        finish();
}

void MainWindow::addnumber(int num)
{
    if(level)
    {
        if(prob.m[select_x][select_y]==0)
        {
            m.m[select_x][select_y]^=1<<num;
            if(sol.calc(m.m[select_x][select_y])>4)
                m.m[select_x][select_y]^=1<<num;
            else
            {
                button[select_x][select_y]->setText(chg012s(m.m[select_x][select_y]));
                refreshsxy(1);
            }
        }
    }
    else//custom mode
    {
        int tmp1=prob.m[select_x][select_y],tmp2=m.m[select_x][select_y];
        prob.m[select_x][select_y]=num;
        m.m[select_x][select_y]=1<<num;
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
    else if(prob.m[select_x][select_y]==0){
        m.m[select_x][select_y]=0;
//            button[select_x][select_y]->setText(QString(" "));
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
    if(e->key()==Qt::Key_M)
    //if(e->key()==Qt::Key_Space||e->key()==Qt::Key_Tab)
    {
        markgrid();
        return;
    }
    switch (e->key()){
    case Qt::Key_Delete:
        deletegrid();
        break;
    case Qt::Key_Up:
    case Qt::Key_I:
    case Qt::Key_W:
        select_x=(select_x+8)%9;
//        qDebug()<<"key up";
        break;
    case Qt::Key_Down:
    case Qt::Key_K:
    case Qt::Key_S:
        select_x=(select_x+1)%9;
//        qDebug()<<"key down";
        break;
    case Qt::Key_Left:
    case Qt::Key_J:
    case Qt::Key_A:
        select_y=(select_y+8)%9;
//        qDebug()<<"key left";
        break;
    case Qt::Key_Right:
    case Qt::Key_L:
    case Qt::Key_D:
        select_y=(select_y+1)%9;
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
    select_x=id/9;
    select_y=id%9;
    refreshsxy(0);
//    qDebug()<<id<<" "<<select_x<<" "<<select_y;
}

void MainWindow::on_num_clicked()
{
    if(state!=1)return;
    QPushButton*btn=qobject_cast<QPushButton*>(sender());
    addnumber(btn->accessibleName().toInt());
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::showinfo()
{
    QString mes;
    mes+="\nThank you for playing this game.\n";
    mes+="Hint:\n";
    mes+="    New Game (Alt+N): choose different more and level;\n";
    mes+="    Easy mode:   20~36 blank grid;\n";
    mes+="    Normal mode: 42~48 blank grid;\n";
    mes+="    Hard mode:   53~57 blank grid;\n";
    mes+="    Crazy mode:  58~81 blank grid, **please be patient**;\n";
    mes+="    Custom mode: you can input sudoku game by yourself;\n";
    mes+="\n";
    mes+="This program ensure problems with Easy/Normal/Hard/Crazy mode have only one solution.\n";
    mes+="\n";
    mes+="    Key W/A/S/D or I/J/K/L: Up/Left/Down/Right;\n";
    mes+="    Key 1-9: add a number to a certain grid;\n";
    mes+="    Key M: mark a flag on a certain grid;\n";
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

void MainWindow::paintEvent(QPaintEvent*)
{
//    QPixmap*pix=new QPixmap(":/fig/sudoku");
//    QPainter p(this);//mark.m[1][1]=1;
//    for(int i=0;i<9;++i)
//        for(int j=0;j<9;++j)
//        {
//            p.setPen(Qt::NoPen);
//            if(mark.m[i][j])
//                p.setBrush(Qt::red);
//            else
//                p.setBrush(Qt::NoBrush);
//            p.drawEllipse(38+i*44,2+j*44,40,40);
//        }
//    painter.drawPixmap(0,0,300,300,*pix);
}

void MainWindow::finish()
{
    state=3;
    if(level==0)return;
    Timer->stop();
    QString s=Timerecord->toString("hh:mm:ss");
    s="    You have solved this sudoku puzzle\nin "+s;
    QMessageBox::information(this,tr("Congratulations!"),s,tr("Meow~"));
}

void MainWindow::undo()
{
    if(history_temp<=0)
        return;
    m=history[--history_temp];
    select_x=hx[history_temp];
    select_y=hy[history_temp];
    mark=hmark[history_temp];
    if(level==0)
    {
        for(int i=0;i<9;++i)
            for(int j=0;j<9;++j)
                if(m.m[i][j])
                    prob.m[i][j]=sol.idx[m.m[i][j]];
                else
                    prob.m[i][j]=0;
    }
    refreshsxy(0);
}

void MainWindow::redo()
{
    if(history_temp>=history.length()-1)
        return;
    m=history[++history_temp];
    select_x=hx[history_temp];
    select_y=hy[history_temp];
    mark=hmark[history_temp];
    if(level==0)
    {
        for(int i=0;i<9;++i)
            for(int j=0;j<9;++j)
                if(m.m[i][j])
                    prob.m[i][j]=sol.idx[m.m[i][j]];
                else
                    prob.m[i][j]=0;
    }
    refreshsxy(0);
}

void MainWindow::timerstart()
{
    Timerecord->setHMS(0,0,0,0);
    ui->timer->display(Timerecord->toString("hh:mm:ss"));
    if(level==0)return;
    Timer->start(1000);
}

void MainWindow::timeupdate()
{
    if(level==0)return;
    *Timerecord=Timerecord->addSecs(1);
    ui->timer->display(Timerecord->toString("hh:mm:ss"));
}

void MainWindow::markgrid()
{
    mark.m[select_x][select_y]^=1;
    refreshsxy(1);
}

void MainWindow::on_pushButton_2_clicked()
{
    if(stage)stage=(stage+1)%5;
    newgame();
}

void MainWindow::on_actionReset_triggered()
{
    if(state!=1)return;
    loadprob(0);
}

void MainWindow::on_actionSolve_triggered()
{
    if(state!=1)return;
    showsol(0);
}

void MainWindow::on_pushButton_3_clicked()
{
    if(state!=1)return;
    if(level)
        showsol(1);
    else
        showsol(0);
}

void MainWindow::on_pushButton_clicked()
{
    if(state!=1)return;
    showtip();
}

void MainWindow::on_actionPause_triggered()
{
    if(state==1)
        pause();
    else if(state==2)
        continuegame();
}

void MainWindow::on_actionStart_triggered()
{
    continuegame();
}

void MainWindow::on_actionUndo_triggered(){if(state!=1)return;undo();}
void MainWindow::on_actionRedo_triggered(){if(state!=1)return;redo();}

void MainWindow::on_mark_button_clicked()
{
    if(state!=1)return;
    markgrid();
}

void MainWindow::on_del_button_clicked()
{
    //qDebug()<<"delete "<<state;
    if(state!=1)return;
    deletegrid();
    refreshsxy(1);
}

void MainWindow::on_actionLv_1_triggered(){level=1;stage=1;newgame();}
void MainWindow::on_actionLv_2_triggered(){level=1;stage=2;newgame();}
void MainWindow::on_actionLv_3_triggered(){level=1;stage=3;newgame();}
void MainWindow::on_actionLv_4_triggered(){level=1;stage=4;newgame();}
void MainWindow::on_actionLv_5_triggered(){level=2;stage=1;newgame();}
void MainWindow::on_actionLv_6_triggered(){level=2;stage=2;newgame();}
void MainWindow::on_actionLv_7_triggered(){level=2;stage=3;newgame();}
void MainWindow::on_actionLv_8_triggered(){level=2;stage=4;newgame();}
void MainWindow::on_actionLv_9_triggered(){level=3;stage=1;newgame();}
void MainWindow::on_actionLv_10_triggered(){level=3;stage=2;newgame();}
void MainWindow::on_actionLv_11_triggered(){level=3;stage=3;newgame();}
void MainWindow::on_actionLv_12_triggered(){level=3;stage=4;newgame();}
void MainWindow::on_actionLv_13_triggered(){level=4;stage=1;newgame();}
void MainWindow::on_actionLv_14_triggered(){level=4;stage=2;newgame();}
void MainWindow::on_actionLv_15_triggered(){level=4;stage=3;newgame();}
void MainWindow::on_actionLv_16_triggered(){level=4;stage=4;newgame();}
void MainWindow::on_actionRandom_triggered(){level=1;stage=0;newgame();}
void MainWindow::on_actionRandom_2_triggered(){level=2;stage=0;newgame();}
void MainWindow::on_actionRandom_3_triggered(){level=3;stage=0;newgame();}
void MainWindow::on_actionRandom_4_triggered(){level=4;stage=0;newgame();}
void MainWindow::on_actionInput_Sudoku_Game_triggered(){level=stage=0;newgame();}

void MainWindow::on_actionMusic_triggered()
{
    if(player->state()==QMediaPlayer::PlayingState)
    {//turn off
        QIcon icon;
        icon.addFile(":/fig/mute");
        ui->actionMusic->setIcon(icon);
        player->pause();
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
