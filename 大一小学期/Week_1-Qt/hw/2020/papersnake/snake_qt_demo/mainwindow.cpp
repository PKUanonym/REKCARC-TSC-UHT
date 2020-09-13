#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    init();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::init(){
    setMouseTracking(true);
    ui->centralwidget->setMouseTracking(true);
    ui->Frame->setMouseTracking(true);
    ui->label->setMouseTracking(true);
    ui->groupBox->setMouseTracking(true);
    this->setWindowTitle(tr("贪吃蛇"));
    QToolBar *toolBar = new QToolBar(this);
    toolBar->setMovable(false);
    addToolBar(toolBar);
    toolBar->addAction(ui->actionPlay);
    toolBar->addAction(ui->actionStop);
    toolBar->addAction(ui->actionContinue);
    toolBar->addAction(ui->actionRestart);
    toolBar->addAction(ui->actionSave);
    toolBar->addAction(ui->actionLoad);
    toolBar->addAction(ui->actionQuit);

    ui->pushButtonLine->setEnabled(true);
    ui->pushButtonStop->setEnabled(false);
    ui->pushButtonContinue->setEnabled(false);
    ui->pushButtonRestart->setEnabled(false);
    ui->pushButtonSave->setEnabled(false);
    ui->pushButtonLoad->setEnabled(true);
    ui->pushButtonQuit->setEnabled(true);
    ui->pushButtonPlay->setEnabled(true);
    ui->actionStop->setEnabled(false);
    ui->actionContinue->setEnabled(false);
    ui->actionRestart->setEnabled(false);
    ui->actionSave->setEnabled(false);
    ui->actionLoad->setEnabled(true);
    ui->actionQuit->setEnabled(true);
    ui->actionPlay->setEnabled(true);

    pix = new QPixmap(400,400);
    int width=400,height=400,step=10;
    pix->fill(Qt::white);
    QPainter *painter = new QPainter;
    QPen pen(Qt::DotLine);
    for (int i=step;i<width;i=i+step)
    {
        painter->begin(pix);
        painter->setPen(pen);
        painter->drawLine(QPoint(i,0),QPoint(i,height));
        painter->end();
    }
    for (int j=step;j<height;j=j+step)
    {
        painter->begin(pix);
        painter->setPen(pen);
        painter->drawLine(QPoint(0,j),QPoint(width,j));
        painter->end();
    }
    ui->label->setPixmap(*pix);
    ui->Frame->setStyleSheet(QString::fromUtf8("border:2px solid lightpink"));

    snake = new SnakeList(ui->label);
    food = new SnakeNode(ui->label,randomPos());

    resize(800,520);
}

void MainWindow::timeout()
{
    {
        int flag = 0;
        predir = dir;
        snake -> move(dir,ui->label);
        if(snake->body.first()->getPos() == food ->getPos()){
            delete food;
            food = new SnakeNode(ui->label,randomPos());
            snake -> eat(dir,ui->label);
            ui->lcdNumberScore->display(++score);
        }
        QPoint pos;
        pos = snake->body.first()->getPos();
        if(pos.x()<0||pos.x()>=400||pos.y()<0||pos.y()>=400){
            QMessageBox::critical(this,"Game over!","Run into the wall!");
            flag=1;
        }
        int c = snake->Check(barrier);
        if(c==1){
            QMessageBox::critical(this,"Game over!","Eat yourself!");
            flag = 1;
        }
        else if(c==2){
            QMessageBox::critical(this,"Game over!","Crashed!");
            flag = 1;
        }
        if(flag){
            timer->stop();
            ui->pushButtonLine->setEnabled(true);
            ui->pushButtonStop->setEnabled(false);
            ui->pushButtonContinue->setEnabled(false);
            ui->pushButtonRestart->setEnabled(true);
            ui->pushButtonSave->setEnabled(false);
            ui->pushButtonLoad->setEnabled(false);
            ui->pushButtonQuit->setEnabled(true);
            ui->pushButtonPlay->setEnabled(false);
            ui->actionStop->setEnabled(false);
            ui->actionContinue->setEnabled(false);
            ui->actionRestart->setEnabled(true);
            ui->actionSave->setEnabled(false);
            ui->actionLoad->setEnabled(false);
            ui->actionQuit->setEnabled(true);
            ui->actionPlay->setEnabled(false);
        }
    }
    ui->lcdNumberTime->display(++time);

    if(foodMove){
        int x = food->getPos().x();
        int y = food->getPos().y();
        switch(QRandomGenerator::global()->bounded(4)){
        case 0:
            x -= 10;
            break;
        case 1:
            x += 10;
            break;
        case 2:
            y -= 10;
            break;
        case 3:
            y += 10;
            break;
        }

        if(snake->Check(barrier,QPoint(x,y))==0)
            food->setPos(x,y);
    }
}

QPoint MainWindow::randomPos(){
    QPoint p;
    do{
        int x = QRandomGenerator::global()->bounded(40)*10;
        int y = QRandomGenerator::global()->bounded(40)*10;
        p = QPoint(x,y);
    }
    while(snake->Check(barrier,p)!=0);
    return p;
}


void MainWindow::keyPressEvent(QKeyEvent *key){
    int keyNum;
    switch(dir){
    case 1:
        keyNum = Qt::Key_Up;
        break;
    case 2:
        keyNum = Qt::Key_Down;
        break;
    case 3:
        keyNum = Qt::Key_Left;
        break;
    case 4:
        keyNum = Qt::Key_Right;
        break;
    }

    if(readyToStart&&key->key()==keyNum){
        timer->start(ms);
        readyToStart = false;
        return;
    }
    if(timer==NULL||!timer->isActive()) return;
    switch (key->key()) {
    case Qt::Key_Up:
        dir=1;
        if(2==predir){
            dir=predir;
            return ;
        }
        break;
    case Qt::Key_Down:
        dir=2;
        if(1==predir){
            dir=predir;
            return ;
        }
        break;
    case Qt::Key_Left:
        dir=3;
        if(4==predir){
            dir=predir;
            return ;
        }
        break;
    case Qt::Key_Right:
        dir=4;
        if(3==predir){
            dir=predir;
            return ;
        }
        break;
    }
    //snake->move(dir,this);
    //if(dir!=predir && timer->isActive())
    //    timeout();
}

void MainWindow::mouseMoveEvent(QMouseEvent *event){
    if(!isChangable) return;
    QPoint pos = ui->label->mapFromGlobal(event->globalPos());
    int x=pos.x(),y=pos.y();
    x = x/10*10;
    y = y/10*10;
    for(auto node:snake->body){
        if(QPoint(x,y)==node->getPos()) return;
    }
    if(QPoint(x,y)==food->getPos()) return;
    if(mouseBarrier!=NULL){
        delete mouseBarrier;
        mouseBarrier = NULL;
    }
    if(mousePress){
        int b = x*10 + y/10;
        if(mousePress==2&&barrier.find(b)!=barrier.end()){
            delete barrier[b];
            barrier.remove(b);
        }
        else if(mousePress==1&&barrier.find(b)==barrier.end()){
            SnakeNode* tmp = new SnakeNode(ui->label,x,y);
            barrier[b] = tmp;
            tmp->setColor(Qt::gray);
        }
    }
    else if(x>=0&&x<400&&y>=0&&y<400){
        mouseBarrier = new SnakeNode(ui->label,x,y);
        mouseBarrier->setColor(Qt::gray);
    }
}

void MainWindow::mousePressEvent(QMouseEvent *event){
    if(!isChangable) return;
    QPoint pos = ui->label->mapFromGlobal(event->globalPos());
    int x=pos.x(),y=pos.y();
    x = x/10*10;
    y = y/10*10;
    for(auto node:snake->body){
        if(QPoint(x,y)==node->getPos()) return;
    }
    if(QPoint(x,y)==food->getPos()) return;
    int b = x*10 + y/10;
    if(barrier.find(b)!=barrier.end()){
        delete barrier[b];
        barrier.remove(b);
        if(mouseBarrier!=NULL){delete mouseBarrier;mouseBarrier=NULL;}
    }
    else{
        SnakeNode* tmp = new SnakeNode(ui->label,x,y);
        barrier[b] = tmp;
        tmp->setColor(Qt::gray);
    }
}

void MainWindow::closeEvent(QCloseEvent * event) {
    int ret = QMessageBox::warning(0, tr("PathFinder"), tr("您确定要退出吗？"), QMessageBox::Yes | QMessageBox::No);
    if (ret == QMessageBox::Yes) {
        event->accept();
    } else {
        event->ignore();
    }
}

void MainWindow::on_actionPlay_triggered()
{
    if(timer!=NULL){
        QMessageBox::critical(this,"提示","游戏已经开始！");
        return;
    }

    ui->pushButtonLine->setEnabled(false);
    ui->pushButtonStop->setEnabled(true);
    ui->pushButtonContinue->setEnabled(false);
    ui->pushButtonRestart->setEnabled(false);
    ui->pushButtonSave->setEnabled(false);
    ui->pushButtonLoad->setEnabled(false);
    ui->pushButtonQuit->setEnabled(true);
    ui->pushButtonPlay->setEnabled(false);
    ui->actionStop->setEnabled(true);
    ui->actionContinue->setEnabled(false);
    ui->actionRestart->setEnabled(false);
    ui->actionSave->setEnabled(false);
    ui->actionLoad->setEnabled(false);
    ui->actionQuit->setEnabled(true);
    ui->actionPlay->setEnabled(false);

    isChangable = false;
    ui->lcdNumberTime->display(time);
    ui->lcdNumberScore->display(score);
    if(mouseBarrier!=NULL){delete mouseBarrier;mouseBarrier=NULL;}

    readyToStart = true;
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(timeout()));
}

void MainWindow::on_actionStop_triggered()
{
    readyToStart = false;
    ui->pushButtonLine->setEnabled(false);
    ui->pushButtonStop->setEnabled(false);
    ui->pushButtonContinue->setEnabled(true);
    ui->pushButtonRestart->setEnabled(true);
    ui->pushButtonSave->setEnabled(true);
    ui->pushButtonLoad->setEnabled(false);
    ui->pushButtonQuit->setEnabled(true);
    ui->pushButtonPlay->setEnabled(false);
    ui->actionStop->setEnabled(false);
    ui->actionContinue->setEnabled(true);
    ui->actionRestart->setEnabled(true);
    ui->actionSave->setEnabled(true);
    ui->actionLoad->setEnabled(false);
    ui->actionQuit->setEnabled(true);
    ui->actionPlay->setEnabled(false);
    timer->stop();
}

void MainWindow::on_actionContinue_triggered()
{
    ui->pushButtonLine->setEnabled(false);
    ui->pushButtonStop->setEnabled(true);
    ui->pushButtonContinue->setEnabled(false);
    ui->pushButtonRestart->setEnabled(false);
    ui->pushButtonSave->setEnabled(false);
    ui->pushButtonLoad->setEnabled(false);
    ui->pushButtonQuit->setEnabled(true);
    ui->pushButtonPlay->setEnabled(false);
    ui->actionStop->setEnabled(true);
    ui->actionContinue->setEnabled(false);
    ui->actionRestart->setEnabled(false);
    ui->actionSave->setEnabled(false);
    ui->actionLoad->setEnabled(false);
    ui->actionQuit->setEnabled(true);
    ui->actionPlay->setEnabled(false);
    readyToStart = true;
}

void MainWindow::on_actionRestart_triggered()
{
    if(timer==NULL){
        QMessageBox::critical(this,"提示","游戏还未开始！");
        return;
    }
    disconnect(timer, SIGNAL(timeout()), this, SLOT(timeout()));
    delete timer;
    delete snake;
    delete food;
    timer = NULL;
    dir = 1;
    time = 0;
    score = 0;
    ui->lcdNumberTime->display(time);
    ui->lcdNumberScore->display(score);
    snake = new SnakeList(ui->label);
    food = new SnakeNode(ui->label,randomPos());
    isChangable = true;
    for(auto node:barrier)
        delete node;
    barrier.clear();
    ui->pushButtonLine->setEnabled(true);
    ui->pushButtonStop->setEnabled(false);
    ui->pushButtonContinue->setEnabled(false);
    ui->pushButtonRestart->setEnabled(false);
    ui->pushButtonSave->setEnabled(false);
    ui->pushButtonLoad->setEnabled(true);
    ui->pushButtonQuit->setEnabled(true);
    ui->pushButtonPlay->setEnabled(true);
    ui->actionStop->setEnabled(false);
    ui->actionContinue->setEnabled(false);
    ui->actionRestart->setEnabled(false);
    ui->actionSave->setEnabled(false);
    ui->actionLoad->setEnabled(true);
    ui->actionQuit->setEnabled(true);
    ui->actionPlay->setEnabled(true);
}

void MainWindow::on_actionSave_triggered()
{
    QString path = QFileDialog::getSaveFileName(this, "Save", ".", "JSON(*.json)");
        if (!path.isEmpty()) {
            QFile file(path);
            if (file.open(QIODevice::WriteOnly)) {
                QJsonObject job;
                job.insert("dir", dir);
                job.insert("predir", predir);
                job.insert("mousePress", mousePress);
                job.insert("food", food->intPos());
                job.insert("isChangable", isChangable);
                job.insert("ms", ms);
                job.insert("time", time);
                job.insert("score", score);
                job.insert("foodmove", foodMove);

                //add snake&barrier
                QJsonArray jsonSnake,jsonBarrier;
                for(auto node:snake->body)
                    jsonSnake.append(node->intPos());
                job.insert("snakebody", jsonSnake);
                QJsonArray jarrSnake;
                for(auto iter:barrier)
                    jsonBarrier.append(iter->intPos());
                job.insert("barrier", jsonBarrier);
                QJsonDocument data;
                data.setObject(job);
                file.write(data.toJson());
                file.close();
            }
        }
}

void MainWindow::on_actionLoad_triggered()
{
    QString path = QFileDialog::getOpenFileName(this, "Open", ".", "JSON(*.json)");
        if (!path.isEmpty()) {
            QFile file(path);
            if (file.open(QIODevice::ReadOnly)) {
                QByteArray allData = file.readAll();
                file.close();
                QJsonParseError json_error;
                QJsonDocument jsonDoc(QJsonDocument::fromJson(allData, &json_error));
                if (json_error.error != QJsonParseError::NoError) {
                    QMessageBox::warning(this, "Error", "Json Error!");
                    return;
                }
                QJsonObject job = jsonDoc.object();
                dir = job["dir"].toInt();
                predir = job["predir"].toInt();
                mousePress = job["mousePress"].toInt();
                ui->Frame->setMouseTracking(bool(mousePress==0));
                switch (mousePress) {
                case 0:
                    ui->pushButtonLine->setText("单个设置");
                    break;
                case 1:
                    ui->pushButtonLine->setText("连续添加");
                    break;
                case 2:
                    ui->pushButtonLine->setText("连续删除");
                    break;
                }
                if(food!=NULL) delete food;
                food = new SnakeNode(ui->label,job["food"].toInt());
                isChangable = job["isChangable"].toBool();
                ms = job["ms"].toInt();
                time = job["time"].toInt();
                score = job["score"].toInt();
                foodMove = job["foodmove"].toBool();

                ui->lcdNumberTime->display(time);
                ui->lcdNumberScore->display(score);
                ui->horizontalSlider->setSliderPosition((500-ms)/10);
                ui->checkBox->setChecked(foodMove);

                QJsonArray jsonSnake = job["snakebody"].toArray(),jsonBarrier = job["barrier"].toArray();
                delete snake->body.first();
                delete snake->body.last();
                snake->body.clear();
                for(auto node:jsonSnake){
                    snake->body.push_back(new SnakeNode(ui->label,node.toInt()));
                    snake->body.back()->setColor(Qt::blue);
                }
                snake->body.first()->setColor(Qt::red);
                for(auto node:barrier)
                    delete node;
                barrier.clear();
                for(auto node:jsonBarrier){
                    SnakeNode* tmp = new SnakeNode(ui->label,node.toInt());
                    barrier[node.toInt()] = tmp;
                    tmp->setColor(Qt::gray);
                }
                file.close();
            }
        }
}

void MainWindow::on_actionQuit_triggered()
{
    exit(1);
}



void MainWindow::on_pushButtonLine_clicked()
{
    mousePress = (mousePress + 1) % 3;
    ui->Frame->setMouseTracking(bool(mousePress==0));
    switch (mousePress) {
    case 0:
        ui->pushButtonLine->setText("单个设置");
        break;
    case 1:
        ui->pushButtonLine->setText("连续添加");
        break;
    case 2:
        ui->pushButtonLine->setText("连续删除");
        break;
    }
}

void MainWindow::on_pushButtonPlay_clicked()
{
    on_actionPlay_triggered();
}

void MainWindow::on_pushButtonStop_clicked()
{
    on_actionStop_triggered();
}

void MainWindow::on_pushButtonContinue_clicked()
{
    on_actionContinue_triggered();
}

void MainWindow::on_pushButtonRestart_clicked()
{
    on_actionRestart_triggered();
}

void MainWindow::on_pushButtonSave_clicked()
{
    on_actionSave_triggered();
}

void MainWindow::on_pushButtonLoad_clicked()
{
    on_actionLoad_triggered();
}

void MainWindow::on_pushButtonQuit_clicked()
{
    on_actionQuit_triggered();
}


void MainWindow::on_horizontalSlider_valueChanged(int value)
{
    ms = 500 - value*10;
    if(timer!=NULL)
        timer->setInterval(ms);
}

void MainWindow::on_checkBox_stateChanged(int arg1)
{
    foodMove = arg1;
}

void MainWindow::on_actionHelp_triggered()
{
    QMessageBox::about(this,"帮助","按住方向键进行移动，注意不要碰到墙壁和障碍物。");
}

void MainWindow::on_actionAbout_triggered()
{
    QMessageBox::about(this,"关于","Made with love by Papersnake.");
}
