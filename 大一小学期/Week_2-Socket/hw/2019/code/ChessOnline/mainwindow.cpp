#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "createconnectdialog.h"
#include "connectdialog.h"
#include "promotedialog.h"

#include <math.h>
#include <QDebug>
#include <QMessageBox>
#include <QPushButton>
#include <QFileDialog>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    board(new QLabel(this)),
    sqr(new QLabel(this)),
    musicPlayer(new QMediaPlayer(this))
{
    ui->setupUi(this);
    QPixmap b(":/pic/Resourse/Board.jpg");
    b = b.scaled(400, 400,  Qt::KeepAspectRatio, Qt::SmoothTransformation);
    qDebug() << b.width() << b.height();
    board->setPixmap(b);
    board->resize(b.width(), b.height());
    board->move(10,10);
    resize(b.width() + 150, b.height() + 20);
    board->show();

    QPushButton * pb1 = new QPushButton(this);
    QPushButton * pb2 = new QPushButton(this);
    QPushButton * pb3 = new QPushButton(this);
    QPushButton * pb4 = new QPushButton(this);
    QPushButton * pb5 = new QPushButton(this);

    pb1->setText("建立连接");
    pb2->setText("连接");
    pb3->setText("认输");
    pb4->setText("保存残局");
    pb5->setText("载入残局");

    pb1->move(b.width() + 20, 75);
    pb2->move(b.width() + 20, 135);
    pb3->move(b.width() + 20, 195);
    pb4->move(b.width() + 20, 255);
    pb5->move(b.width() + 20, 315);

    connect(pb1, SIGNAL(clicked()), this, SLOT(createConnection()));
    connect(pb2, SIGNAL(clicked()), this, SLOT(connecting()));
    connect(pb3, SIGNAL(clicked()), this, SLOT(throwUp()));
    connect(pb4, SIGNAL(clicked()), this, SLOT(save()));
    connect(pb5, SIGNAL(clicked()), this, SLOT(load()));

    for (int i = 0; i < 6; ++i) {
        pic[i] = new QPixmap(QString(":/pic/Resourse/W%1.png").arg(i));
        pic[i + 6] = new QPixmap(QString(":/pic/Resourse/B%1.png").arg(i));
    }

    pieceStr[king] = "king";
    pieceStr[queen] = "queen";
    pieceStr[rook] = "rook";
    pieceStr[bishop] = "bishop";
    pieceStr[knight] = "knight";
    pieceStr[pawn] = "pawn";
    memset(pieces, 0, sizeof(pieces));
    this->show();
    //initGame();
}

MainWindow::~MainWindow()
{
    if (thread != nullptr && thread->isRunning())
        thread->terminate();
    delete ui;
}

void MainWindow::initGame()
{
    int w = 50;
    int h = 50;
    qDebug() << w << h;
    Piece kinds[8] = {rook, knight, bishop, queen, king, bishop, knight, rook};
    for(int i = 0; i < 32; i++) {
        Piece kind;
        if (((i / 8) & 1) == 0) {
            kind = kinds[i % 8];
        }
        else {
            kind = pawn;
        }
        bool isBlack = (i >= 16);
        if (pieces[i] == nullptr)
            pieces[i] = new Chess(this, kind, isBlack);
        else {
            pieces[i]->setName(kind);
            pieces[i]->setIsBlack(isBlack);
        }
        moveTo(i % 8 + 1,isBlack ? (10 - i / 8) : (i / 8 + 1), i);
        pieces[i]->resize(w, h);
        pieces[i]->show();
    }
    connect(youAreWhite ? pieces[4] : pieces[20], SIGNAL(beChied()), this, SLOT(youLose()));
    connect(youAreWhite ? pieces[20] : pieces[4], SIGNAL(beChied()), this, SLOT(youWin()));

    sqr->setPixmap(QPixmap(":/pic/Resourse/Choose.png").scaled(w, h, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    sqr->resize(w, h);
    sqr->hide();
    if (whoseTurn[0] == nullptr)
        whoseTurn[0] = new QLabel(this);
    if (whoseTurn[1] == nullptr)
        whoseTurn[1] = new QLabel(this);
    whoseTurn[0]->setPixmap((youAreWhite ? pic[0] : pic[6])->scaled(41, 41, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    whoseTurn[1]->setPixmap((youAreWhite ? pic[6] : pic[0])->scaled(41, 41, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    whoseTurn[0]->move(board->width() + 22, board->height() - 45);
    whoseTurn[1]->move(board->width() + 22, 15);
    whoseTurn[0]->resize(w, h);
    whoseTurn[1]->resize(w, h);
    whoseTurn[isYourTurn?0:1]->show();
    whoseTurn[isYourTurn?1:0]->hide();
    if (thread == nullptr)
        thread = new TimeThread(this);
    else
        thread->resetTime();
    if (time == nullptr)
        time = new QLCDNumber(this);
    time->resize(100, 100);
    time->setFrameStyle(QFrame::NoFrame);
    time->move(board->width() + 20, isYourTurn?(board->height() - 70): -10);
    time->show();
    thread->start();
    connect(thread, SIGNAL(timeChanged(int)), time, SLOT(display(int)));
    connect(thread, &TimeThread::timeOut,this, [this]{(this->isYourTurn)?(this->youLose()):(this->youWin());});

    hasInited = true;
}

int MainWindow::getNum(int x, int y)
{
    for(int i = 0; i < 32; i++){
        if(pieces[i]->isVisible()){
            if(getXIndex(pieces[i]->pos()) == x && getYIndex(pieces[i]->pos()) == y){
                return i;
            }
        }
    }
    return -1;
}

int MainWindow::getNum(QPoint p)
{
    return getNum(getXIndex(p), getYIndex(p));
}

int MainWindow::getXIndex(QPoint p)
{
    return 1 + (p.x() - board->x()) / 50;
}

int MainWindow::getYIndex(QPoint p)
{
    return 8 - (p.y() - board->y()) / 50;
}

QPoint MainWindow::getPos(int x, int y)
{
    QPoint p;
    p.setX((x - 1) * 50 + board->x());
    p.setY((8 - y) * 50 + board->y());
    return p;
}

QPoint MainWindow::getPos(QString pos) {
    return getPos(pos[0].toLatin1() - 'a' + 1, pos[1].toLatin1() - '0');
}

void MainWindow::highlight(int num)
{
    if(num == -1){
        sqr->hide();
        highlightNow = -2;
        return;
    }
    sqr->show();
    //sqr->move(-sqr->pos());
    sqr->move(pieces[num]->pos());
    highlightNow = num;
}

void MainWindow::moveTo(int x, int y)
{
    moveTo(x, y, highlightNow);
}

void MainWindow::moveTo(int x, int y, int num)
{
    pieces[num]->move(getPos(x, y));
}

//-1: can't go
//-2: can go(not chi)
//-3: chi
//-4: switch the kind and rook
//>=0: rehighlight
int MainWindow::checkAbleGo(int num, int x, int y, bool checkPromotion, bool checkSwitch)
{
    if (checkPromotion)
        promotion = false;
    if (checkSwitch) {
        switchKing = false;
        switchDX = 0;
        switchIndex = -1;
    }
    bool isChi = false;
    int n = getNum(x, y);
    if((isEnemy(n) ^ isEnemy(num)) && pieces[n]->isVisible()){
        isChi = true;//两个子不同阵营
    }
    else if(n > -1 && pieces[n]->isVisible() && (n != num)){
        return n;//走到友军身上了
    }
    int x0 = getXIndex(pieces[num]->pos());
    int y0 = getYIndex(pieces[num]->pos());
    if(x == x0 && y == y0){
        return -1;
    }

    switch (pieces[num]->name()) {
    case rook:{//车
        if(x0 == x){//同一排
            for(int i = 0; i < 32; i++){//如果中间有东西挡着，则不能走
                if(getXIndex(pieces[i]->pos()) == x && pieces[i]->isVisible()){
                    int yi = getYIndex(pieces[i]->pos());
                    if((yi < y0 && yi > y) || (yi > y0 && yi < y)){
                        return -1;
                    }
                }
            }
        }
        else if(y0 == y){
            for(int i = 0; i < 32; i++){
                if(getYIndex(pieces[i]->pos()) == y && pieces[i]->isVisible()){
                    int xi = getXIndex(pieces[i]->pos());
                    if((xi < x0 && xi > x) || (xi > x0 && xi < x)){
                        return -1;
                    }
                }
            }
        }
        else{
            return -1;
        }
        break;
    }
    case knight:{//马
        if(x - x0 == 2 || x - x0 == -2){
            if(y - y0 == 1 || y - y0 == -1){}//走的合法，x方向走2，y方向走1
            else {return -1;}
        }
        else if(y - y0 == 2 || y - y0 == -2){
            if(x - x0 == 1 || x - x0 == -1){}//走的合法，x方向走1，y方向走2
            else{return -1;}
        }
        else{
            return -1;
        }
        break;
    }
    case bishop:{//象
        //(x0,y0)原位置，(x1,y1)检测位置，(x,y)目标位置
        if (x - x0 == y - y0 || x - x0 == y0 - y) {
            int step = abs(x - x0);
            for(int i = 0; i < 32; i++){
                int x1 = getXIndex(pieces[i]->pos()), y1 = getYIndex(pieces[i]->pos());
                int step1 = abs(x1 - x0), step2 = abs(y1 - y0);
                if (step1 == step2 && step1 < step && step > 0 && pieces[i]->isVisible()) {//如果num也能走到pieces[i]上，且移动距离更短
                    if ((x1 - x0) * (x - x0) > 0 && (y1 - y0) * (y - y0) > 0) {//朝同一个方向移动，即在路径上，被pieces[i]阻挡
                        return -1;
                    }
                }
            }
        }
        else {
            return -1;
        }
        break;
    }
    case queen:{//后
        //后=车+象
        if(x0 == x){//同一排
            for(int i = 0; i < 32; i++){//如果中间有东西挡着，则不能走
                if(getXIndex(pieces[i]->pos()) == x && pieces[i]->isVisible()){
                    int yi = getYIndex(pieces[i]->pos());
                    if((yi < y0 && yi > y) || (yi > y0 && yi < y)){
                        return -1;
                    }
                }
            }
        }
        else if(y0 == y){
            for(int i = 0; i < 32; i++){
                if(getYIndex(pieces[i]->pos()) == y && pieces[i]->isVisible()){
                    int xi = getXIndex(pieces[i]->pos());
                    if((xi < x0 && xi > x) || (xi > x0 && xi < x)){
                        return -1;
                    }
                }
            }
        }
        //(x0,y0)原位置，(x1,y1)检测位置，(x,y)目标位置
        else if (x - x0 == y - y0 || x - x0 == y0 - y) {
            int step = abs(x - x0);
            for(int i = 0; i < 32; i++){
                int x1 = getXIndex(pieces[i]->pos()), y1 = getYIndex(pieces[i]->pos());
                int step1 = abs(x1 - x0), step2 = abs(y1 - y0);
                if (step1 == step2 && step1 < step && step > 0 && pieces[i]->isVisible()) {//如果num也能走到pieces[i]上，且移动距离更短
                    if ((x1 - x0) * (x - x0) > 0 && (y1 - y0) * (y - y0) > 0) {//朝同一个方向移动，即在路径上，被pieces[i]阻挡
                        return -1;
                    }
                }
            }
        }
        else {
            return -1;
        }
        break;
    }
    case king:{//王
        if (abs(x - x0) > 1 || abs(y - y0) > 1) {
            //王车移位
            if (checkSwitch) {
                assert(!isEnemy(num));
                if (!isBeJianged()) {//没被将军，且目的地没有子
                    qDebug() << "没被将军";
                    if (abs(x - x0) == 2 && y == y0) {//王横着走两步
                        qDebug() << "横着两步" << x0 << y0 << pieces[num]->isBlack();
                        if ((x0 == 5) && ((y0 == 8 && pieces[num]->isBlack()) || (y0 == 1 && !pieces[num]->isBlack()))) {
                            //王在e8（黑）或e1（白）
                            switchDX = x - x0;
                            int x1 = (switchDX > 0) ? 8 : 1, y1 = y0;//想要交换的车的位置
                            int num2 = getNum(x1, y1);
                            qDebug() << "王在e8/e1" << pieces[num]->isBlack() << x0 << y0;
                            qDebug() << "想要交换的车在" << x1 << y1 << "下标为" << num2;
                            if (num2 > -1 && pieces[num2]->name() == rook && (isEnemy(num) ^ !isEnemy(num2))) {//该位置是同一阵营的车
                                switchIndex = num2;
                                for (int xi = min(x1, x0) + 1; xi < max(x1, x0); ++xi) {
                                    qDebug() << "正在检查是否有阻拦：" << xi << y0;
                                    if (getNum(xi, y0) != -1) {
                                        qDebug() << "交换失败，有阻拦" << xi << y0;
                                        goto switchFailed;
                                    }
                                }
                                qDebug() << "无阻拦";
                                moveTo ((x0 + x) / 2, y0, num);
                                if (!isBeJianged()) {
                                    qDebug() << "第一步没被将";
                                    moveTo(x, y0, num);
                                    if (!isBeJianged()) {
                                        qDebug() << "第二步没被将";
                                        switchKing = true;
                                        moveTo(x0, y0, num);
                                        return -4;
                                    }
                                    else {
                                        qDebug() << "第二步被将";
                                        goto switchFailed;
                                    }
                                }
                                else {
                                    qDebug() << "第一步被将";
                                    moveTo(x0, y0, num);
                                    goto switchFailed;
                                }
                            }
                            else {
                                qDebug() << "不是同一阵营的车";
                            }
                        }
                        else{
                            qDebug() << "王不在e1/e8";
                        }
                    }
                    else {
                        qDebug() << "王不是横着走两步";
                    }
                }
                else {
                    qDebug() << "被将军";
                }
switchFailed:
                switchDX = 0;
                switchIndex = -1;
                moveTo(x0, y0, num);
                return -1;
            }
            else {//不检查王车移位
                return -1;
            }
        }
        break;
    }
    case pawn:{//兵
        int dx;
        bool isMinus = pieces[num]->isBlack(), noMove = isMinus ? (y0 == 7) : (y0 == 2);
        if (isChi)
            dx = 1;
        else
            dx = 0;
        if (abs(x - x0) == dx && (isMinus ^ (y > y0))) {
            if (noMove && abs(y - y0) == 2) {}
            else if (abs(y - y0) == 1) {}
            else {return -1;}
        }
        else {
            return -1;
        }

        if (checkPromotion && (y == 1 || y == 8)) {
            promotion = true;
        }
        break;
    }
    }
    if(isChi){
        return -3;
    }
    return -2;
}

bool MainWindow::tryToGo(int x, int y, bool checkPromotion, bool checkSwitch)
{
    int res = checkAbleGo(highlightNow, x, y, checkPromotion, checkSwitch);
    if ((res >= 0) && !isEnemy(res)) {
        highlight(res);
        return false;
    }
    else if(res == -1){
        highlight(-1);
        return false;
    }
    else if(res == -2){
        moveTo(x, y);
        return true;
    }
    else if (res == -3){
        int n = getNum(x, y);
        pieces[n]->hide();
        moveTo(x, y);
        return true;
    }
    else if (res == -4){
        moveTo(x, y);
        moveTo(x - switchDX / 2, y, switchIndex);
        return true;
    }
    return false;
}

bool MainWindow::tryToGo(QPoint p, bool checkPromotion, bool checkSwitch)
{
    return tryToGo(getXIndex(p), getYIndex(p), checkPromotion, checkSwitch);
}

bool MainWindow::isJiang() {
    return youAreWhite ? isBlackBeJianged() : isWhiteBeJianged();
}
bool MainWindow::isBeJianged() {
    return youAreWhite ? isWhiteBeJianged() : isBlackBeJianged();
}
bool MainWindow::isBlackBeJianged()
{
    if(pieces[20]->isVisible()){
        for(int i = 0; i < 16; i++){
            if(pieces[i]->isVisible() && checkAbleGo(i, getXIndex(pieces[20]->pos()), getYIndex(pieces[20]->pos())) == -3){
                return true;
            }
        }
    }
    return false;
}
bool MainWindow::isWhiteBeJianged()
{
    if(pieces[4]->isVisible()){
        for(int i = 16; i < 32; i++){
            if(pieces[i]->isVisible() && checkAbleGo(i, getXIndex(pieces[4]->pos()), getYIndex(pieces[4]->pos())) == -3){
                return true;
            }
        }
    }
    return false;
}
bool MainWindow::isEnemy(int n)
{
    return youAreWhite ? (n > 15) : ((n < 16) && (n >= 0));
}

void MainWindow::mousePressEvent(QMouseEvent *e)
{
    qDebug() << e->pos().x() << e->pos().y();
    if(e->button() == Qt::LeftButton){
        if(e->pos().x() > board->width() || !hasInited){
            return QMainWindow::mousePressEvent(e);
        }
        else if(isYourTurn && sqr->isVisible() && !isEnemy(highlightNow)){
            if(tryToGo(e->pos(), true, true)){
                if (switchKing) {
                    qDebug() << "switchKing dx index" << switchDX << switchIndex;
                    sendMessage(55, switchDX, switchIndex);
                }
                else {
                    Piece newName = pawn;
                    if (promotion) {
                        PromoteDialog d(this);
                        if (d.exec() == QDialog::Accepted) {
                            newName = d.getName();
                            qDebug() << newName;
                        }
                    }
                    sendMessage(highlightNow, getXIndex(e->pos()), getYIndex(e->pos()));
                    if (promotion) {
                        pieces[highlightNow]->setName(newName);
                        sendMessage(50, highlightNow, newName);
                    }
                }
                highlight(-1);
                //youAreWhite = !youAreWhite;//TODO:for debug
                isYourTurn = false;
                whoseTurn[0]->hide();
                whoseTurn[1]->show();
                time->move(board->width() + 20, isYourTurn?(board->height() - 70): -10);
                thread->resetTime();
                if(isJiang()){
//                    musicPlayer->setMedia(QUrl("qrc:/audio/Resourse/Jiang.mp3"));
//                    musicPlayer->play();//TODO
                }
                qDebug() << isJiang() << isBeJianged();
            }
        }
        else {
            int n = getNum(e->pos());
            qDebug() << n;
            if (n >= 0 && !isEnemy(n)) {
                if (n != highlightNow)
                    highlight(n);
                else
                    highlight(-1);
            }
        }
    }
}

void MainWindow::createConnection()
{
    CreateConnectDialog d(this);
    if(d.exec() == CreateConnectDialog::Accepted){
        readWriteSocket = d.getReadWriteSocket();
        QObject::connect(readWriteSocket,SIGNAL(readyRead()),this,SLOT(recvMessage()));
        
        youAreWhite = true;
        isYourTurn = true;
        
        initGame();
    }
}

void MainWindow::connecting()
{
    ConnectDialog d(this);
    if(d.exec() == ConnectDialog::Accepted){
        readWriteSocket = d.getReadWriteSocket();
        QObject::connect(readWriteSocket,SIGNAL(readyRead()),this,SLOT(recvMessage()));
        
        youAreWhite = false;
        isYourTurn = false;
        
        initGame();
    }
}

void MainWindow::throwUp()
{
    if(readWriteSocket != nullptr){
        sendMessage(50,50,50);
        youLose();
    }
}

void MainWindow::save()
{
    if(hasInited){
        QString folderName = QFileDialog::getExistingDirectory();
        if(folderName == nullptr){
            return;
        }//设置保存文件夹
        int n = 0;
        QFile f;
        do{
            f.setFileName(folderName + "/save_" + QString::number(n) + ".txt");
            n++;
        }while(f.exists());//设置保存文件名
        f.open(QIODevice::WriteOnly);
        QTextStream ts(&f);
        qDebug() << f.fileName();
        bool whiteFirst = !(youAreWhite ^ isYourTurn);
        int PiecesInfo[2][6][16], size[2][6];//[white-0/black-1][Piece][Index]
        memset(size,0,sizeof(size));
        for (int i = 0; i < 32; ++i) {
            if (pieces[i]->isVisible()) {
                int i0 = pieces[i]->isBlack() ? 1 : 0, i1 = pieces[i]->name();
                PiecesInfo[i0][i1][size[i0][i1]++] = i;
            }
        }//扫描一遍
        for (int ii0 = 0; ii0 < 2; ++ii0) {
            int i0 = whiteFirst ? ii0 : (1 - ii0);
            ts << ((i0 == 0) ? "white\n" : "black\n");
            for (int i1 = 0; i1 < 6; ++i1) {
                if (size[i0][i1] > 0) {
                    ts << pieceStr[i1] << " " << size[i0][i1];
                    for (int i2 = 0; i2 < size[i0][i1]; ++i2) {
                        QPoint pos = pieces[PiecesInfo[i0][i1][i2]]->pos();
                        ts << " " << char(getXIndex(pos) + 'a' - 1) << getYIndex(pos);
                    }
                    ts << "\n";
                }
            }
        }//写入文件
        f.close();
    }
}

void MainWindow::load()
{
    if(hasInited){
        QString fileName = QFileDialog::getOpenFileName();
        if(fileName == nullptr){
            return;
        }
        QFile f(fileName);
        f.open(QIODevice::ReadOnly);
        QTextStream ts(&f);

        bool whiteFirst = (ts.readLine() == "white");

        int detIndex = whiteFirst ? 0 : 16;
        int pawnNum = 8;
        for (int i = 0; i < 32; ++i) {
            if (i != 4 && i != 20) {
                pieces[i]->hide();
            }
        }
        while (!ts.atEnd()) {
            QStringList list = ts.readLine().split(" ");
            if (list.size() <= 1) {
                detIndex = 16 - detIndex;
                pawnNum = 8;
                continue;
            }
            int n = list[1].toInt(), name = findName(list[0]);
            if (name > -1) {
                Piece pName = Piece(name);
                int maxSize = 0, indexBase[2];
                switch (pName) {
                case king:
                    maxSize = 1;
                    indexBase[0] = 4;
                    break;
                case queen:
                    maxSize = 1;
                    indexBase[0] = 3;
                    break;
                case bishop:
                    maxSize = 2;
                    indexBase[0] = 2; indexBase[1] = 5;
                    break;
                case knight:
                    maxSize = 2;
                    indexBase[0] = 1; indexBase[1] = 6;
                    break;
                case rook:
                    maxSize = 2;
                    indexBase[0] = 0; indexBase[1] = 7;
                    break;
                case pawn:
                    maxSize = 0;
                    break;
                }
                for (int i = 0; i < n; ++i) {
                    QPoint pos = getPos(list[i + 2]);
                    if (i < maxSize) {
                        int index = indexBase[i] + detIndex;
                        pieces[index]->move(pos);
                        pieces[index]->show();
                    }
                    else {
                        int index = (pawnNum++) + detIndex;
                        pieces[index]->move(pos);
                        pieces[index]->show();
                    }
                }
            }
        }

        f.close();

        isYourTurn = !(whiteFirst ^ youAreWhite);
        whoseTurn[isYourTurn?1:0]->hide();
        whoseTurn[isYourTurn?0:1]->show();
        time->move(board->width() + 20, isYourTurn?(board->height() - 70): -10);
        highlight(-1);
        thread->resetTime();
        if (!thread->isRunning())
            thread->start();
    }
}

void MainWindow::recvMessage(){
    qDebug() << "recv";
    QByteArray info = readWriteSocket->readAll();
    qDebug() << int(info[0]) << int(info[1]) << int(info[2]);
    //QMessageBox::information(this,"recv",QString("recv %1 %2 %3").arg(int(info[0])).arg(int(info[1])).arg(int(info[2])));
    if(info[0] - 10 == 50){
        if (info[1] - 10 == 50 && info[2] - 10 == 50)
            return youWin();
        int num = info[1] - 10, newName = info[2] - 10;
        return pieces[num]->setName(Piece(newName));
    }
    int num, x, y;
    if (info[0] - 10 == 55) {
        int dx = info[1] - 10, index = info[2] - 10;
        num = youAreWhite ? 20 : 4;
        int x0 = getXIndex(pieces[num]->pos()), y0 = getYIndex(pieces[num]->pos());
        moveTo(x0 + dx / 2, y0, index);
        x = x0 + dx;
        y = y0;
    }
    else {
        num = info[0] - 10;
        x = info[1] - 10;
        y = info[2] - 10;
    }
    int num2 = getNum(x, y);
    if(num2 > -1){
        pieces[num2]->hide();
    }
    moveTo(x, y, num);
    isYourTurn = true;
    whoseTurn[1]->hide();
    whoseTurn[0]->show();
    time->move(board->width() + 20, isYourTurn?(board->height() - 70): -10);
    thread->resetTime();
    if(isBeJianged()){
//        musicPlayer->setMedia(QUrl("qrc:/audio/Resourse/Jiang.mp3"));
//        musicPlayer->play();//TODO:media
    }
}

void MainWindow::sendMessage(int num, int x, int y)
{
    qDebug() << "send";
    QByteArray * array = new QByteArray;
    array->clear();
    array->append(char(num + 10)).append(char(x + 10)).append(char(y + 10));
    qDebug() << int((*array)[0]) << int((*array)[1]) << int((*array)[2]);
    readWriteSocket->write(array->data());
    readWriteSocket->waitForBytesWritten();
    //QMessageBox::information(this,"send",QString("send %1 %2 %3").arg(int((*array)[0])).arg(int((*array)[1])).arg(int((*array)[2])));
}

void MainWindow::youWin()
{
    qDebug() << "Win";
    QMessageBox* b = new QMessageBox(QMessageBox::NoIcon, "Win", "You Win!", QMessageBox::Ok, this);
    b->show();
    isYourTurn = false;
    thread->terminate();
}

void MainWindow::youLose()
{
    qDebug() << "Lose";
    QMessageBox* b = new QMessageBox(QMessageBox::NoIcon, "Lose", "You Lose!", QMessageBox::Ok, this);
    b->show();
    isYourTurn = false;
    thread->terminate();
}
