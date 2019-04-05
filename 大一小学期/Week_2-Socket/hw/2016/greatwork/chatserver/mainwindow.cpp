#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    memset(board,0,sizeof(board));
    lock = -1;
    opened = 0;
    tips = 0;
}

MainWindow::~MainWindow()
{
    delete ui;
}
void MainWindow::restart()
{
    memset(board,0,sizeof(board));
    lock = 0;
    update();
    QMessageBox::StandardButton rb = \
    QMessageBox::question(NULL, "question server", "You go first?", QMessageBox::Yes | QMessageBox::No, QMessageBox::Yes);
    if(rb != QMessageBox::Yes)
    {
        lock = 1;
        send(3,0,0);
    }
}
void MainWindow::initServer(QString m_ip)
{
    if(opened)return;
    opened = 1;
    now_ip = m_ip;
    this->listenSocket =new QTcpServer;
    this->listenSocket->listen(QHostAddress(m_ip),8888);
    QObject::connect(this->listenSocket,SIGNAL(newConnection()),this,SLOT(acceptConnection()));
    qDebug()<<"sever start";
    QMessageBox::about(NULL, "Sever Opend.", "Sever Opened.");
}

void MainWindow::stopServer()
{
    if(!opened)return;
    opened = 0;
    qDebug()<<"sever closed";
    memset(board,0,sizeof(board));
    update();
    QMessageBox::about(NULL, "Sever Closed.", "Sever Closed.");
    this->listenSocket->close();
}

void MainWindow::acceptConnection()
{
    QMessageBox::about(NULL, "Connected.", "Connected.");
    this->readWriteSocket =this->listenSocket->nextPendingConnection();
    QObject::connect(this->readWriteSocket,SIGNAL(readyRead()),this,SLOT(recvMessage()));
    restart();
}
void MainWindow::recvMessage()
{
    QString info;
    info += this->readWriteSocket->readAll();
    int x,y;
    x = info.toInt() / 20;
    y = info.toInt() % 20;
    qDebug("recv %d %d",x,y);
    board[x][y] = 2;
    lock = 0;
    update();
    if(checkwin())
    {
        tips = 0;
        update();
        QMessageBox::about(NULL, "You lose.", "You lose.");
        send(2,0,0);
        restart();
    }
}
void MainWindow::paintEvent(QPaintEvent *event)
{
    qDebug()<<"server "<<lock;
    cleartips();
    if(tips)
        checktips();
    int w, h, c;
    w = ui->centralWidget->width();
    h = ui->centralWidget->height();
    qDebug()<<"paint"<<w<<"  "<<h;
    h -= 30;
    if(w<h)
        h = w;
    else
        w = h;
    c = w / 16;
    w = h = c * 14;
    QPainter p(this);
    QPen m_pen;
    QBrush m_brush,black_brush,white_brush,bomb_brush;
    QPixmap pix;
    pix.load(":/fig/board.png");
    pix = pix.scaled(w,h,Qt::KeepAspectRatio);
    p.drawPixmap(c/2 ,30 + c/2 ,w+c ,h+c ,pix);
    m_pen.setStyle(Qt::SolidLine);
    m_pen.setWidth(w/130);
    m_pen.setColor(Qt::black);
    p.setPen(m_pen);
    int i,j;
    for(i = 0;i <= 14 ;++i)
    {
        p.drawLine(c ,30 + c + i * c ,c + w ,30 + c + i * c);
        p.drawLine(c + i * c ,30+ c ,c + i * c ,30 + c + w);
    }
    p.setPen(Qt::NoPen);
    for(i = 0; i <= 14; ++i)
        for(j = 0; j <= 14; ++j)
        {
            if(board[i][j] == 0)
                continue;
            if(board[i][j] == 1)
                pix.load(":/fig/black.png");
            if(board[i][j] == 2)
                pix.load(":/fig/white.png");
            if(board[i][j] == 3)
                pix.load(":/fig/bomb.png");
            pix = pix.scaled(c,c,Qt::KeepAspectRatio);
            p.drawPixmap(c + i * c - c * 0.5 ,30 + c + j * c - c * 0.5 ,c ,c ,pix);
        }
}
void MainWindow::mouseReleaseEvent(QMouseEvent *event)
{
    if(!opened)
    {
        QMessageBox::about(NULL, "No connection.", "No connection.");
        return;
    }
    if(lock != 0)
    {
        if(lock == 1)
            QMessageBox::about(NULL, "Wait.", "Wait for opponent's action.");
        else
            QMessageBox::about(NULL, "No connection.", "No connection.");
        return;
    }
    int x,y,i,j;
    int w, h, c;
    w = ui->centralWidget->width();
    h = ui->centralWidget->height() - 30;
    if(w<h)
        h = w;
    else
        w = h;
    c = w / 16;
    int mindis=1e9,px,py;
    x = event->pos().x();
    y = event->pos().y() - 30;
    for(i = 0; i <= 14; ++i)
        for(j = 0; j <= 14; ++j)
        {
            if((c + i * c - x) * (c + i * c - x) + (c + j * c - y) * (c + j * c - y) < mindis)
            {
                px = i;
                py = j;
                mindis = (c + i * c - x) * (c + i * c - x) + (c + j * c - y) * (c + j * c - y);
            }
        }
    qDebug()<<px<<" "<<py;
    if(mindis > c * c * 0.2)
        return;
    if(board[px][py] == 1 || board[px][py] == 2)
        return;
    board[px][py] = 1;
    lock = 1;
    update();
    if(checkwin())
    {
        tips = 0;
        update();
        QMessageBox::about(NULL, "You win.", "You win.");
        send(1,0,0);
        restart();
    }
    else
        send(0,px,py);
}

bool MainWindow::checkwin()
{
    int i,j,k;
    for(int i = 0; i < 15; ++i)
        for(int j = 0; j < 15; ++j)
            if(board[i][j] == 1|| board[i][j]==2)
            {
                for(k = 1;k <= 4;++k)
                    if(j + k > 14||board[i][j] != board[i][j+k])
                        break;
                if(k == 5)
                    return 1;
                for(k = 1;k <= 4;++k)
                    if(i + k > 14||board[i][j] != board[i+k][j])
                        break;
                if(k == 5)
                    return 1;
                for(k = 1;k <= 4;++k)
                    if(i + k > 14||j + k >14||board[i][j] != board[i+k][j+k])
                        break;
                if(k == 5)
                    return 1;
                for(k = 1;k <= 4;++k)
                    if(i + k > 14||j - k < 0||board[i][j] != board[i+k][j-k])
                        break;
                if(k == 5)
                    return 1;
            }
    return 0;
}
void MainWindow::send(int a,int x,int y)
{
    QByteArray *array =new QByteArray;
    array->clear();
    array->append(QString::number(a*10000+x*20+y));
    this->readWriteSocket->write(array->data());
}

void MainWindow::on_actionCreat_triggered()
{
    creat w(now_ip,opened);
    connect(&w,SIGNAL(ok(QString)) ,this,SLOT(initServer(QString)));
    connect(&w,SIGNAL(sto()),this,SLOT(stopServer()));
    w.show();
    w.exec();
}

void MainWindow::on_actionOn_triggered()
{
    tips = 1;
    checktips();
    update();
}

void MainWindow::on_actionOff_triggered()
{
    tips = 0;
    cleartips();
    update();
}
bool inboard(int x,int y)
{
    return x>=0&&x<15&&y>=0&&y<15;
}
int MainWindow::check()
{
    int cnt;
    for(int i = 2; i <= 5; ++i)
    {
        int j;
        for(j = i; j <= i + 3; ++j)
            if(s[j]!=2)
                break;
        if(j == i+4)
            if(s[i-1] != 1 && s[i+4] != 1)
                return 2;
            else
                return 1;
    }
    for(int i = 1; i <= 5; ++i)
    {
        cnt = 0;
        for(int j = i; j <= i+4; ++j)
        {
            if(s[j] == 1)
                break;
            if(s[j] == 2)
                ++cnt;
        }
        if(cnt >= 4)
            return 1;
    }
    for(int i = 2; i <= 5; ++i)
    {
        cnt = 0;
        int j;
        for(j = i; j <= i+3; ++j)
        {
            if(s[j] == 1)
                break;
            if(s[j] == 2)
                ++cnt;
        }
        if(cnt >= 3 && j > i+3 && s[i-1]!=1 && s[i+4]!=1)
            return 1;
    }
    for(int i = 3; i <= 5; ++i)
    {
        cnt = 0;
        for(int j = i; j <= i+2; ++j)
        {
            if(s[j] == 2)
                ++cnt;
        }
        if(cnt >= 3 && s[i-1]!=1 && s[i+3]!=1 && (s[i-2] != 1 || s[i+4] != 1))
            return 1;
    }
    return 0;
}
void MainWindow::checktips()
{
    cleartips();
    int x,y,l,r,k,cnt;
    for(x = 0; x < 15; ++x)
        for(y = 0; y < 15; ++y)
            if(board[x][y] == 0)
            {
                cnt = 0;
                for(k = -5;k <= 5;++k)
                {
                    if(inboard(x+k,y))
                        s[k+5]=board[x+k][y];
                    else
                        s[k+5]=1;
                    if(s[k+5]==3)
                        s[k+5]=0;
                }
                s[5] = 2;
                cnt += check();
                for(k = -5;k <= 5;++k)
                {
                    if(inboard(x+k,y+k))
                        s[k+5]=board[x+k][y+k];
                    else
                        s[k+5]=1;
                    if(s[k+5]==3)
                        s[k+5]=0;
                }
                s[5] = 2;
                cnt += check();
                for(k = -5;k <= 5;++k)
                {
                    if(inboard(x+k,y-k))
                        s[k+5]=board[x+k][y-k];
                    else
                        s[k+5]=1;
                    if(s[k+5]==3)
                        s[k+5]=0;
                }
                s[5] = 2;
                cnt += check();
                for(k = -5;k <= 5;++k)
                {
                    if(inboard(x,y+k))
                        s[k+5]=board[x][y+k];
                    else
                        s[k+5]=1;
                    if(s[k+5]==3)
                        s[k+5]=0;
                }
                s[5] = 2;
                cnt += check();
                board[x][y] = 2;
                if(cnt>=2||checkwin())
                    board[x][y] = 3;
                else
                    board[x][y] = 0;
            }
}

void MainWindow::cleartips()
{
    for(int i = 0 ;i < 15 ;++i)
        for(int j = 0 ;j < 15 ;++j)
            if(board[i][j] == 3)
                board[i][j] = 0;
}
