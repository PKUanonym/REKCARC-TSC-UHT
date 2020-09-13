#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    gamestatus = new GameStatus();
    s = new server(this->ui);
    c = new client(this->ui);
    desktop=new Desktop(this);
    baseWidget = new BaseWidget(this);
    ver=desktop->getDesktop();
    this->setMaximumSize(1310*ver,910*ver);
    this->setMinimumSize(1310*ver,910*ver);
    this->setWindowFlags(Qt::FramelessWindowHint|windowFlags());
    s->basewidget = baseWidget;
    c->basewidget = baseWidget;
//    this->setObjectName("mainWindow");
//    this->setStyleSheet("#mainWindow{border-image:url(:/background/resources/background"+QString::number(QRandomGenerator::global()->bounded(18))+".png);}");
    playlist.addMedia(QUrl("qrc:sound/resources/MusicEx_Welcome.mp3"));
    playlist.setPlaybackMode(QMediaPlaylist::Loop);
    playlist1.addMedia(QUrl("qrc:sound/resources/MusicEx_Normal.mp3"));
    playlist1.addMedia(QUrl("qrc:sound/resources/MusicEx_Normal2.mp3"));
    playlist1.addMedia(QUrl("qrc:sound/resources/MusicEx_Exciting.mp3"));
    playlist1.setPlaybackMode(QMediaPlaylist::Loop);
    playlist2.addMedia(QUrl("qrc:sound/resources/MusicEx_Win.mp3"));
    playlist3.addMedia(QUrl("qrc:sound/resources/MusicEx_Lose.mp3"));
    player = new QMediaPlayer;
    player->setPlaylist(&playlist);
    player->setVolume(30);
    player->play();
    baseWidget->gamestatus = gamestatus;
    s->gamestatus = gamestatus;
    c->gamestatus = gamestatus;
    gamestatus->id = s->id;
    routine = new QTimer(this);
    routine->start(500);
    connect(routine, SIGNAL(timeout()), this, SLOT(routine_run()));
}

MainWindow::~MainWindow()
{
    delete ui;
    delete s;
    delete c;
    delete gamestatus;
}

void MainWindow::post(QString msg){
    int max = 0;
    for(auto i:gamestatus->index[gamestatus->id]){
        if(max<i) max = i;
    }
    ++max;
    s->m_pInterface->ping(QString::number(max)+"*"+msg);
    c->m_pInterface1->pong(QString::number(max)+"*"+msg);
    c->m_pInterface2->pong(QString::number(max)+"*"+msg);
    c->m_pInterface3->pong(QString::number(max)+"*"+msg);
}

void MainWindow::routine_run()
{
    if(baseWidget->nongmin0NumCardList.size()) baseWidget->rightCardSizeLabel->setNum(gamestatus->player_cards[(gamestatus->id+2)%3]);
    if(baseWidget->nongmin1NumCardList.size()) baseWidget->leftCardSizeLabel->setNum(gamestatus->player_cards[(gamestatus->id+1)%3]);
    if(gamestatus->msg_to_send){
        qDebug()<<gamestatus->msg;
        post(gamestatus->msg);
        gamestatus->msg_to_send = false;
    }
    if(gamestatus->step==1){
        post(QString::number(s->id)+":StartGame");
        if(gamestatus->gamestatus[0]==1&&gamestatus->gamestatus[1]==1&&gamestatus->gamestatus[2]==1){
            gamestatus->step = 2;
            baseWidget->waiting->hide();
            if(gamestatus->id==0) baseWidget->getRandomCardNumList();
        }
    }
    else if(gamestatus->step==2){
        if(gamestatus->gamestatus[0]==2&&gamestatus->gamestatus[1]==2&&gamestatus->gamestatus[2]==2){
            if(gamestatus->id==0) post(QString::number(s->id)+":ChooseLord:"+QString::number(QRandomGenerator::global()->bounded(3)));
            gamestatus->step = 3;
        }
    }
    else if(gamestatus->step==3){
        if(gamestatus->gamestatus[0]==3&&gamestatus->gamestatus[1]==3&&gamestatus->gamestatus[2]==3){
            baseWidget->startGame();
            player->setPlaylist(&playlist1);
            player->setVolume(30);
            player->play();
            gamestatus->step = 0;
        }
    }
    else if(gamestatus->step==4){
        if(gamestatus->id==(gamestatus->lord+2)%3){
            if(gamestatus->gamestatus[s->id]==4)
                post(QString::number(s->id)+":BecomeLord:"+QString::number(s->id));
            else if(gamestatus->gamestatus[(s->id+2)%3]==4)
                post(QString::number(s->id)+":BecomeLord:"+QString::number((s->id+2)%3));
            else
                post(QString::number(s->id)+":BecomeLord:"+QString::number((s->id+1)%3));
        }
        else{
            post(QString::number(s->id)+":DecideLord:"+QString::number(gamestatus->gamestatus[s->id]));
        }
        gamestatus->step = 0;
    }
}

void MainWindow::paintEvent(QPaintEvent *event)
{
    const int x=5*ver;
    Q_UNUSED(event);
    QPainterPath yinying_path;
    yinying_path.setFillRule(Qt::WindingFill);
    yinying_path.addRect(x,x,this->width()-2*x,this->height()-2*x);
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing,true);
    QColor color(0,0,0,15);
    for(int i=0;i<x;i++)
    {
        QPainterPath path;
        path.setFillRule(Qt::WindingFill);
        path.addRect(x-i, x-i, this->width()-(x-i)*2, this->height()-(x-i)*2);
        color.setAlpha(150 - qSqrt(i)*50);
        painter.setPen(color);
        painter.drawPath(path);
    }
}



void MainWindow::on_pushButton_clicked()
{
//    QString msg = ui->textEdit->toPlainText();
//    if(!msg.isEmpty()){
//        s->m_pInterface->ping(QString::number(s->id)+":"+msg);
//        c->m_pInterface1->pong(QString::number(s->id)+":"+msg);
//        c->m_pInterface2->pong(QString::number(s->id)+":"+msg);
//        c->m_pInterface3->pong(QString::number(s->id)+":"+msg);
//    }
}

void MainWindow::mousePressEvent(QMouseEvent *event)
{
    m_draging = true;
    if(event->buttons() & Qt::LeftButton)//只响应鼠标左键
    {
        m_startPostion = event->globalPos();
        m_framPostion = frameGeometry().topLeft();
    }
    QWidget::mousePressEvent(event);//调用父类函数保持原按键行为
}

void MainWindow::mouseMoveEvent(QMouseEvent *event)
{
    if(event->buttons() & Qt::LeftButton)
    {
        //offset 偏移位置
        QPoint offset = event->globalPos() - m_startPostion;
        move(m_framPostion + offset);
    }
    QWidget::mouseMoveEvent(event);//调用父类函数保持原按键行为
}

void MainWindow::mouseReleaseEvent(QMouseEvent *event)
{
    m_draging = false;
    QWidget::mouseReleaseEvent(event);
}
