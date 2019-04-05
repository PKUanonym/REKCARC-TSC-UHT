#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    player = new QMediaPlayer;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::initialize()
{
    initializeDialog = new QDialog;
    QLabel *label_0 = new QLabel;
    QPushButton *button_1 = new QPushButton;
    QPushButton *button_2 = new QPushButton;
    QVBoxLayout *layout = new QVBoxLayout;
    QHBoxLayout *layout_1 = new QHBoxLayout;
    label_0->setText(tr("请选择游戏开始方式"));
    button_1->setText(tr("创建房间"));
    button_2->setText(tr("进入房间"));
    layout_1->addWidget(button_1);
    layout_1->addWidget(button_2);
    layout->addWidget(label_0);
    layout->addLayout(layout_1);
    initializeDialog->setLayout(layout);
    connect(button_1,SIGNAL(clicked(bool)),this,SLOT(initServer()));
    connect(button_2,SIGNAL(clicked(bool)),this,SLOT(connectHost()));
    initializeDialog->show();
    initializeDialog->exec();
}

void MainWindow::initServer()
{
    initializeDialog->close();
    waitingDialog = new QDialog;
    QLabel *label_1 = new QLabel;
    QLabel *label_2 = new QLabel;
    QPushButton *button = new QPushButton;
    edit = new QLineEdit;
    QVBoxLayout *layout = new QVBoxLayout;
    QHBoxLayout *layout_1 = new QHBoxLayout;
    QString ipAddress;
        QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
        for (int i = 0; i < ipAddressesList.size(); ++i) {
            qDebug()<<ipAddressesList.at(i).toString();
             if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
                 ipAddressesList.at(i).toIPv4Address()) {
                 ipAddress = ipAddressesList.at(i).toString();
                 break;
           }
        }
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();
    address = ipAddress;
    QString sentence_1;
    sentence_1.clear();
    sentence_1.append(tr("你的IP地址是:"));
    sentence_1.append(address);
    label_1->setText(sentence_1);
    label_2->setText(tr("设置端口号:"));
    button->setText(tr("确定"));
    layout_1->addWidget(label_2);
    layout_1->addWidget(edit);
    layout->addWidget(label_1);
    layout->addLayout(layout_1);
    layout->addWidget(button);
    waitingDialog->setLayout(layout);
    connect(button,SIGNAL(clicked(bool)),this,SLOT(initServer_2()));
    this->listenSocket =new QTcpServer;
    waitingDialog->show();
    waitingDialog->exec();
}

void MainWindow::initServer_2()
{
    waitingDialog->close();
    newWaitingDialog = new QDialog;
    QLabel *label_1 = new QLabel;
    QLabel *label_2 = new QLabel;
    QLabel *label_3 = new QLabel;
    QString sentence_1;
    QString sentence_2;
    sentence_1.append("你的IP地址是:");
    sentence_1.append(address);
    label_2->setText(sentence_1);
    sentence_2.append("你的端口号是:");
    sentence_2.append(edit->text());
    label_3->setText(sentence_2);
    label_1->setText(tr("等待连接..."));
    QVBoxLayout *layout_1 = new QVBoxLayout;
    layout_1->addWidget(label_2);
    layout_1->addWidget(label_3);
    layout_1->addWidget(label_1);
    newWaitingDialog->setLayout(layout_1);
    QString port = edit->text();
    int portInt = port.toInt();
    this->listenSocket->listen(QHostAddress::Any,portInt);
    QObject::connect(this->listenSocket,SIGNAL(newConnection()),this,SLOT(acceptConnection()));
    newWaitingDialog->show();
    newWaitingDialog->exec();
}

void MainWindow::acceptConnection()
{
    newWaitingDialog->close();
    this->readWriteSocket = this->listenSocket->nextPendingConnection();
    QObject::connect(this->readWriteSocket,SIGNAL(readyRead()),this,SLOT(recvMessage()));
    selfColor = 1;
    counter = 0;
    myTurn = false;
    isFirstStage = true;
    isCounting = false;
    finished = false;
    mapper = new QSignalMapper;
    for(int i = 0; i < 10;i++)
    {
        for(int j = 0; j < 10;j++)
        {
            board[i][j] = new Cell(this);
            chess[i][j] = new Cell(this);
        }
    }
    int board_size = 60;
    int chess_size = 50;
    for(int i = 0; i < 10; i++)
    {
        for(int j = 0; j < 10 ; j++)
        {
            board[i][j]->setType(0);
            board[i][j]->setColor((i+j)%2 + 1);
            board[i][j]->setGeometry(board_size*(j+1),board_size*(i+1),board_size,board_size);
        }
    }
    for(int i = 0; i < 10; i++)
    {
        for(int j = 0; j < 10 ; j++)
        {
            chess[i][j]->setType(1);
            if(i < 4)
            {
                if((i+j)%2 == 0)
                {
                    chess[i][j]->setColor(0);
                }
                else
                    chess[i][j]->setColor(2);
            }
            if(i >=4 && i<= 5)
            {
                chess[i][j]->setColor(0);
            }
            if(i > 5)
            {
                if((i+j)%2 == 0)
                {
                    chess[i][j]->setColor(0);
                }
                else
                    chess[i][j]->setColor(1);
            }
            chess[i][j]->setGeometry(board_size*(j+1)+(board_size-chess_size)/2,board_size*(i+1)+(board_size-chess_size)/2,chess_size,chess_size);
        }
    }
    for(int i = 0;i < 10;i++)
    {
        for(int j  =0;j < 10 ;j++)
        {
            connect(chess[i][j],SIGNAL(clicked(bool)),mapper,SLOT(map()));
            int m = i*10 + j;
            mapper->setMapping(chess[i][j],m);
        }
    }
         this->setAutoFillBackground(true);
         QPalette palette;
         QPixmap pixmap(":/new/prefix1/pics/background.png");
         palette.setBrush(QPalette::Window, QBrush(pixmap));
         this->setPalette(palette);
    QAction *give_up = new QAction(tr("认输"),this);
    QAction *sue_for_draw = new QAction(tr("求和"),this);
    QAction *custom = new QAction(tr("自定义棋盘"),this);
    QAction *open_sound = new QAction(tr("开"),this);
    QAction *close_sound = new QAction(tr("关"),this);
    QMenu *menu_0 = new QMenu(tr("操作"),this);
    QMenu *menu_1 = new QMenu(tr("音效"),this);
    QMenuBar *menu_bar = new QMenuBar(this);
    menu_0->addAction(give_up);
    menu_0->addAction(sue_for_draw);
    menu_0->addAction(custom);
    menu_1->addAction(open_sound);
    menu_1->addAction(close_sound);
    menu_bar->addMenu(menu_0);
    menu_bar->addMenu(menu_1);
    this->resize(700,700);
    connect(give_up,SIGNAL(triggered(bool)),this,SLOT(giveUp()));
    connect(sue_for_draw,SIGNAL(triggered(bool)),this,SLOT(sueForDraw()));
    connect(custom,SIGNAL(triggered(bool)),this,SLOT(customBoard()));
    connect(open_sound,SIGNAL(triggered(bool)),this,SLOT(openSound()));
    connect(close_sound,SIGNAL(triggered(bool)),this,SLOT(closeSound()));
    connect(mapper,SIGNAL(mapped(int)),this,SLOT(chessClicked(int)));
    this->show();
    player->setMedia(QUrl("qrc:/new/prefix1/sounds/jumpMove.mp3"));
    player->play();
}

void MainWindow::connectHost()
{
    initializeDialog->close();
    connectingDialog = new QDialog;
    QLabel *label_1 = new QLabel;
    QLabel *label_2 = new QLabel;
    line_1 = new QLineEdit;
    line_2 = new QLineEdit;
    QPushButton *button = new QPushButton;
    QHBoxLayout *layout_1 = new QHBoxLayout;
    QHBoxLayout *layout_2 = new QHBoxLayout;
    QVBoxLayout *layout = new QVBoxLayout;
    label_1->setText(tr("对方的IP地址:"));
    label_2->setText(tr("对方的端口号:"));
    button->setText(tr("确认连接"));
    layout_1->addWidget(label_1);
    layout_1->addWidget(line_1);
    layout_2->addWidget(label_2);
    layout_2->addWidget(line_2);
    layout->addLayout(layout_1);
    layout->addLayout(layout_2);
    layout->addWidget(button);
    connectingDialog->setLayout(layout);
    this->readWriteSocket = new QTcpSocket;
    connect(button,SIGNAL(clicked(bool)),this,SLOT(connectHost_2()));
    connectingDialog->show();
    connectingDialog->exec();
}

void MainWindow::connectHost_2()
{
    QString address = line_1->text();
    QString portString = line_2->text();
    int port = portString.toInt();
    this->readWriteSocket->connectToHost(QHostAddress(address),port);
    connect(readWriteSocket,SIGNAL(connected()),this,SLOT(connected()));
    if(!readWriteSocket->waitForConnected())
        connectFail();
}

void MainWindow::connected()
{
    connectingDialog->close();
    selfColor = 2;
    counter = 0;
    myTurn = true;
    isFirstStage = true;
    isCounting = false;
    finished = false;
    mapper = new QSignalMapper;
    for(int i = 0; i < 10;i++)
    {
        for(int j = 0; j < 10;j++)
        {
            board[i][j] = new Cell(this);
            chess[i][j] = new Cell(this);
        }
    }
    int board_size = 60;
    int chess_size = 50;
    for(int i = 0; i < 10; i++)
    {
        for(int j = 0; j < 10 ; j++)
        {
            board[i][j]->setType(0);
            board[i][j]->setColor((i+j)%2 + 1);
            board[i][j]->setGeometry(board_size*(j+1),board_size*(i+1),board_size,board_size);
        }
    }
    for(int i = 0; i < 10; i++)
    {
        for(int j = 0; j < 10 ; j++)
        {
            chess[i][j]->setType(1);
            if(i < 4)
            {
                chess[i][j]->setColor((i+j)%2);
            }
            if(i >=4 && i<= 5)
            {
                chess[i][j]->setColor(0);
            }
            if(i > 5)
            {
                if((i+j)%2 == 0)
                {
                    chess[i][j]->setColor(0);
                }
                else
                    chess[i][j]->setColor(2);
            }
            chess[i][j]->setGeometry(board_size*(j+1)+(board_size-chess_size)/2,board_size*(i+1)+(board_size-chess_size)/2,chess_size,chess_size);
        }
    }
    for(int i = 0;i < 10;i++)
    {
        for(int j  =0;j < 10 ;j++)
        {
            connect(chess[i][j],SIGNAL(clicked(bool)),mapper,SLOT(map()));
            int m = i*10 + j;
            mapper->setMapping(chess[i][j],m);
        }
    }
    connect(mapper,SIGNAL(mapped(int)),this,SLOT(chessClicked(int)));
    this->setAutoFillBackground(true);
    QPalette palette;
    QPixmap pixmap(":/new/prefix1/pics/background.png");
    palette.setBrush(QPalette::Window, QBrush(pixmap));
    this->setPalette(palette);
    QAction *give_up = new QAction(tr("认输"),this);
    QAction *sue_for_draw = new QAction(tr("求和"),this);
    QAction *custom = new QAction(tr("自定义棋盘"),this);
    QAction *open_sound = new QAction(tr("开"),this);
    QAction *close_sound = new QAction(tr("关"),this);
    QMenu *menu_0 = new QMenu(tr("操作"),this);
    QMenu *menu_1 = new QMenu(tr("音效"),this);
    QMenuBar *menu_bar = new QMenuBar(this);
    menu_0->addAction(give_up);
    menu_0->addAction(sue_for_draw);
    menu_0->addAction(custom);
    menu_1->addAction(open_sound);
    menu_1->addAction(close_sound);
    menu_bar->addMenu(menu_0);
    menu_bar->addMenu(menu_1);
    this->resize(700,700);
    connect(give_up,SIGNAL(triggered(bool)),this,SLOT(giveUp()));
    connect(sue_for_draw,SIGNAL(triggered(bool)),this,SLOT(sueForDraw()));
    connect(custom,SIGNAL(triggered(bool)),this,SLOT(customBoard()));
    connect(open_sound,SIGNAL(triggered(bool)),this,SLOT(openSound()));
    connect(close_sound,SIGNAL(triggered(bool)),this,SLOT(closeSound()));
    QObject::connect(this->readWriteSocket,SIGNAL(readyRead()),this,SLOT(recvMessage()));
    this->show();
    player->setMedia(QUrl("qrc:/new/prefix1/sounds/jumpMove.mp3"));
    player->play();
    showMovable();
}

void MainWindow::connectFail()
{
    QMessageBox::about(NULL,tr("错误"),tr("请填入正确的IP地址和端口号！"));
}

void MainWindow::recvMessage()//m03,3334,346634:move 0,3 to 3,4 eat 3,3 3,4 path 3,4 6,6 3,4; x:enemy give up ; h:enemy ask for draw f:enemy fail d:direct move d1234 movefrom 1,2 to 3,4 y:accept sue_for_draw n:turn down sue_for_draw p:draw c12034802348...:custom
{
    QString info;
    info += this->readWriteSocket->readAll();
    if(info[0] == 'm')
    {
        QStringList list_0 = info.split(",");
        QString string_1 = list_0[0];
        QString string_2 = list_0[1];
        QString string_3 = list_0[2];
        int fromRow = 9 - (string_1[1].toLatin1() - '0');
        int fromCol = 9 - (string_1[2].toLatin1() - '0');
        vector<int> path_0;
        vector<int> eatChess_0;
        for(int i = 0;i < string_2.length();i = i+2)
        {
            int row = 9 - (string_2[i].toLatin1() - '0');
            int col = 9 - (string_2[i+1].toLatin1() - '0');
            int index = row*10+col;
            eatChess_0.push_back(index);
        }
        for(int i = 0;i < string_3.length();i = i+2)
        {
            int row = 9 - (string_3[i].toLatin1() - '0');
            int col = 9 - (string_3[i+1].toLatin1() - '0');
            int index = row*10+col;
            path_0.push_back(index);
        }
        moveEnemy_Jump(fromRow,fromCol,eatChess_0,path_0);
    }
    if(info[0] == 'x')
    {
        enemyGiveUp();
    }
    if(info[0] == 'h')
    {
        enemySueForDraw();
    }
    if(info[0] == 'd')
    {
        int fromRow = 9 - (info[1].toLatin1() - '0');
        int fromCol = 9 - (info[2].toLatin1() - '0');
        int toRow = 9 - (info[3].toLatin1() - '0');
        int toCol = 9 - (info[4].toLatin1() - '0');
        moveEnemy_Direct(fromRow,fromCol,toRow,toCol);
    }
    if(info[0] == 'y')
    {
        sueDialog->close();
        QMessageBox::about(NULL,tr("求和"),tr("对方接受了你的求和。"));
        draw();
    }
    if(info[0] == 'n')
    {
        sueDialog->close();
        QMessageBox::about(NULL,tr("求和"),tr("对方拒绝了你的求和。"));
    }
    if(info[0] == 'p')
    {
        draw();
    }
    if(info[0] == 'f')
    {
        succeed();
    }
    if(info[0] == 'c')
    {
        if(info.length() == 101)
        {
            if(selfColor == 1)
            {
            for(int i = 0; i < 100;i++)
            {
                chess[i/10][i%10]->setColor(info[100-i].toLatin1() - '0');
            }
            }
            else{
                for(int i = 0; i < 100;i++)
                {
                    chess[i/10][i%10]->setColor(info[i+1].toLatin1() - '0');
                }
            }
            if(selfColor == 1)
            {
                myTurn = false;
                showMovable();
            }
            else
            {
                myTurn = true;
                showMovable();
            }
            isFirstStage = true;
            isCounting = false;
            finished = false;
            nowChess = -1;
        }
    }
}

void MainWindow::enemyGiveUp()
{
    QMessageBox::about(NULL,tr("胜利"),tr("对方认输"));
    finished = true;
}

void MainWindow::enemySueForDraw()
{
    QMessageBox whetherAccept(QMessageBox::NoIcon,tr("求和"),tr("你接受对方的求和吗？"),QMessageBox::Yes | QMessageBox::No,NULL);
    if(whetherAccept.exec() == QMessageBox::Yes)
    {
        QString ss;
        ss.clear();
        ss.append("y");
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(ss);
        readWriteSocket->write(array->data());
        draw();
    }
    else{
        QString ss;
        ss.clear();
        ss.append("n");
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(ss);
        readWriteSocket->write(array->data());
        isCounting = true;
    }
}

void MainWindow::giveUp()
{
    QMessageBox whetherGiveUp(QMessageBox::NoIcon,tr("认输"),tr("你想要认输吗？"),QMessageBox::Yes | QMessageBox::No,NULL);
    if(whetherGiveUp.exec() == QMessageBox::Yes)
    {
        QString ss;
        ss.clear();
        ss.append("x");
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(ss);
        readWriteSocket->write(array->data());
        fail();
    }
}

void MainWindow::sueForDraw()
{
    QMessageBox whetherSue(QMessageBox::NoIcon,tr("求和"),tr("你想要求和吗？"),QMessageBox::Yes | QMessageBox::No,NULL);
    if(whetherSue.exec() == QMessageBox::Yes)
    {
        QString ss;
        ss.clear();
        ss.append("h");
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(ss);
        readWriteSocket->write(array->data());
        sueDialog = new QDialog;
        QLabel *label = new QLabel;
        QVBoxLayout *layout_1 = new QVBoxLayout;
        label->setText(tr("等待对方做出决定..."));
        layout_1->addWidget(label);
        sueDialog->setLayout(layout_1);
        sueDialog->show();
        sueDialog->exec();
    }
}

void MainWindow::customBoard()
{
    QString path = QFileDialog::getOpenFileName(this, tr("Open File"), ".", tr("*.txt"));
    if(path.length() == 0)
    {
        QMessageBox::about(NULL,tr("提示"),tr("你没有选择任何文本文件(*.txt)"));
    }
    else{
        QFile *file = new QFile(path);
        file->open(QIODevice::ReadOnly);
        QTextStream floStream(file);
        QString line;
        line.clear();
        floStream.setCodec( QTextCodec::codecForName("UTF-8"));
        while ( floStream.atEnd() == 0 )
        {
            line.append(floStream.readLine());
        }
        file->close();
        if(line.length() == 100)
        {
            if(selfColor == 2)
            {
                for(int i = 0; i < 100;i++)
                {
                    chess[i/10][i%10]->setColor(line[i].toLatin1() - '0');
                }
            }
            else
            {
                for(int i = 0; i < 100;i++)
                {
                    chess[i/10][i%10]->setColor(line[99-i].toLatin1() - '0');
                }
            }
            for(int i = 0;i < 10;i++)
            {
                for(int j = 0;j < 10;j++)
                {
                    board[i][j]->fresh();
                }
            }
            if(selfColor == 1)
            {
                myTurn = false;
                showMovable();
            }
            else
            {
                myTurn = true;
                showMovable();
            }
            isFirstStage = true;
            isCounting = false;
            finished = false;
            nowChess = -1;
            QString ss;
            ss.clear();
            ss.append("c");
            ss += line;
            QByteArray *array =new QByteArray;
            array->clear();
            array->append(ss);
            readWriteSocket->write(array->data());
        }
    }
}

void MainWindow::openSound()
{
    player->setVolume(100);
}

void MainWindow::closeSound()
{
    player->setVolume(0);
}

void MainWindow::moveEnemy_Jump(int fromRow,int fromCol,vector<int> eatChess,vector<int> path_0)
{
    if(chess[fromRow][fromCol]->getColor() == 3-selfColor || chess[fromRow][fromCol]->getColor() == 5-selfColor)
    {
        int color = chess[fromRow][fromCol]->getColor();
        vector<int> path;
        path.push_back(fromRow*10+fromCol);
        path.insert(path.end(),path_0.begin(),path_0.end());
        int size = path.size();
        for(int i = 0;i < size-1;i++)
        {
            chess[path[i]/10][path[i]%10]->setColor(0);
            chess[path[i+1]/10][path[i+1]%10]->setColor(color);
            QEventLoop eventLoop;
            QTimer::singleShot(200,&eventLoop,SLOT(quit()));
            eventLoop.exec();
        }
        if(path[size - 1] >= 90)
        {
            chess[path[size-1]/10][path[size-1]%10]->setColor(5 - selfColor);
        }
        int sizeOfEat = eatChess.size();
        for(int i = 0;i < sizeOfEat;i++)
        {
            chess[eatChess[i]/10][eatChess[i]%10]->setColor(0);
        }
        board[fromRow][fromCol]->setStyleSheet(board[fromRow][fromCol]->styleSheet().append("border:5px solid rgb(249,193,52);"));
        board[path[size-1]/10][path[size-1]%10]->setStyleSheet(board[path[size-1]/10][path[size-1]%10]->styleSheet().append("border:5px solid rgb(249,193,52);"));
        myTurn = true;
        showMovable();
        checkFail();
    }
}

void MainWindow::moveEnemy_Direct(int fromRow,int fromCol,int toRow,int toCol)
{
    if(chess[fromRow][fromCol]->getColor() == 3-selfColor || chess[fromRow][fromCol]->getColor()  == 5-selfColor)
    {
        int color = chess[fromRow][fromCol]->getColor();
        chess[fromRow][fromCol]->setColor(0);
        chess[toRow][toCol]->setColor(color);
        if(toRow >= 9)
        {
            chess[toRow][toCol]->setColor(5 - selfColor);
        }
        board[fromRow][fromCol]->setStyleSheet(board[fromRow][fromCol]->styleSheet().append("border:5px solid rgb(249,193,52);"));
        board[toRow][toCol]->setStyleSheet(board[toRow][toCol]->styleSheet().append("border:5px solid rgb(249,193,52);"));
        myTurn = true;
        showMovable();
        checkFail();
    }
}

void MainWindow::moveSelf_Jump(int fromRow,int fromCol,vector<int> eatChess,vector<int> path_0)
{
    if(chess[fromRow][fromCol]->getColor() == selfColor || chess[fromRow][fromCol]->getColor() == selfColor + 2)
    {
        int color = chess[fromRow][fromCol]->getColor();
        vector<int> path;
        path.push_back(fromRow*10+fromCol);
        path.insert(path.end(),path_0.begin(),path_0.end());
        int size = path.size();
        for(int i = 0;i < size-1;i++)
        {
            chess[path[i]/10][path[i]%10]->setColor(0);
            chess[path[i+1]/10][path[i+1]%10]->setColor(color);
            player->setMedia(QUrl("qrc:/new/prefix1/sounds/jumpMove.mp3"));
            player->play();
            QEventLoop eventLoop;
            QTimer::singleShot(200,&eventLoop,SLOT(quit()));
            eventLoop.exec();
        }
        int sizeOfEat = eatChess.size();
        for(int i = 0;i < sizeOfEat;i++)
        {
            chess[eatChess[i]/10][eatChess[i]%10]->setColor(0);
        }
        myTurn = false;
        if(path[size-1] < 10)
        {
            chess[path[size-1]/10][path[size-1]%10]->setColor(selfColor + 2);
            player->setMedia(QUrl("qrc:/new/prefix1/sounds/upgrade.mp3"));
            player->play();
        }

        QString writeString;
        writeString.clear();
        writeString.append('m');
        int mm = fromRow*10+fromCol;
        QString ss_3;
        if(mm < 10)
        {
            ss_3.append('0');
        }
        ss_3.append(QString::number(mm));
        writeString.append(ss_3);
        writeString.append(',');
        for(int i = 0;i < sizeOfEat;i++)
        {
            QString ss;
            if(eatChess[i] < 10)
            {
                ss.append('0');
            }
            ss.append(QString::number(eatChess[i]));
            writeString.append(ss);
        }
        writeString.append(',');
        for(int i = 0;i < size -1;i++)
        {
            QString ss;
            if(path_0[i] < 10)
            {
                ss.append('0');
            }
            ss.append(QString::number(path_0[i]));
            writeString.append(ss);
        }
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(writeString);
        readWriteSocket->write(array->data());
        if(isCounting)
        {
            counter++;
        }
        if(counter > 40)
        {
            QString ss;
            ss.clear();
            ss.append("p");
            QByteArray *array =new QByteArray;
            array->clear();
            array->append(ss);
            readWriteSocket->write(array->data());
            draw();
        }
        for(int i = 0;i < 10;i++)
        {
            for(int j = 0;j < 10;j++)
            {
                board[i][j]->fresh();
            }
        }
    }
}

void MainWindow::moveSelf_Direct(int fromRow,int fromCol,int toRow,int toCol)
{
    if(chess[fromRow][fromCol]->getColor() == selfColor || chess[fromRow][fromCol]->getColor()  == selfColor+2)
    {
        int color = chess[fromRow][fromCol]->getColor();
        chess[fromRow][fromCol]->setColor(0);
        chess[toRow][toCol]->setColor(color);
        player->setMedia(QUrl("qrc:/new/prefix1/sounds/directMove.mp3"));
        player->play();
        myTurn = false;
        if(toRow < 1)
        {
            chess[toRow][toCol]->setColor(2+selfColor);
            player->setMedia(QUrl("qrc:/new/prefix1/sounds/upgrade.mp3"));
            player->play();
        }
        QString writeQString;
        writeQString.clear();
        writeQString.append('d');
        writeQString.append(QString::number(fromRow));
        writeQString.append(QString::number(fromCol));
        writeQString.append(QString::number(toRow));
        writeQString.append(QString::number(toCol));
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(writeQString);
        readWriteSocket->write(array->data());
        if(isCounting)
        {
            counter++;
        }
        if(counter > 40)
        {
            QString ss;
            ss.clear();
            ss.append("p");
            QByteArray *array =new QByteArray;
            array->clear();
            array->append(ss);
            readWriteSocket->write(array->data());
            draw();
        }
        for(int i = 0;i < 10;i++)
        {
            for(int j = 0;j < 10;j++)
            {
                board[i][j]->fresh();
            }
        }
    }
}

void MainWindow::checkFail()
{
    bool survive = false;
    for(int i = 0;i < 10;i++)
    {
        for(int j = 0;j < 10;j++)
        {
            if(chess[i][j]->getColor() == selfColor || chess[i][j]->getColor() == selfColor + 2)
            {
                vector<int> vec_1,vec_2;
                vec_1.clear();
                vec_2.clear();
                vec_1 = getDirectMove(i ,j);
                vec_2 = getJumpMove(i, j);
                int size_1 = vec_1.size();
                int size_2 = vec_2.size();
                size_2 += size_1;
                if(size_2 != 0)
                {
                    survive = true;
                    break;
                }
            }
        }
        if(survive)
            break;
    }
    if(!survive)
    {
        QString ss;
        ss.clear();
        ss.append("f");
        QByteArray *array =new QByteArray;
        array->clear();
        array->append(ss);
        readWriteSocket->write(array->data());
        fail();
    }
}

vector<int> MainWindow::getDirectMove(int i,int j)
{
    vector<int> board_2;
    board_2.clear();
    if(chess[i][j]->getColor() == selfColor)
    {
        int v[2] = {-1,-1};
        int h[2] = {-1,1};
        for(int m = 0; m < 2;m++)
        {
            if(i+v[m] >= 0 && i+v[m] <= 9 && j+h[m] >= 0 && j+h[m] <=9)
                if(chess[i+v[m]][j+h[m]]->getColor() == 0)
                {
                    int posi = (i+v[m])*10 + j+h[m];
                    board_2.push_back(posi);
                }
        }
    }
    if(chess[i][j]->getColor() == selfColor + 2)
    {
        int v[4] = {-1,-1,1,1};
        int h[4] = {-1,1,-1,1};
        for(int m = 0;m < 4;m++)
        {
            for(int n = 1; n < 10;n++)
            {
                if(i + v[m]*n < 0 || i+v[m]*n > 9 ||j+h[m]*n <0 ||j+h[m]*n>9)
                    break;
                if(chess[i + v[m]*n][j+h[m]*n]->getColor() == 0)
                {
                    int posi = (i+v[m]*n)*10 + j+h[m]*n;
                    board_2.push_back(posi);
                }
                else
                    break;
            }
        }
    }
    return board_2;
}

vector<int> MainWindow::getJumpMove(int i, int j)
{
    vector<int> vec;
    vec.clear();
    for(int m = 0;m < 10;m++)
    {
        for(int n = 0;n < 10; n++)
        {
            moveState[m][n].eatChess.clear();
            moveState[m][n].path.clear();
        }
    }
    bool isCommon;
    if(chess[i][j]->getColor() == selfColor)
    {
        isCommon = true;
    }
    if(chess[i][j]->getColor() == selfColor +2)
    {
        isCommon = false;
    }
    dfs(i,j,isCommon);
    int max = 0;
    for(int m = 0;m < 10;m++)
    {
        for(int n = 0;n < 10; n++)
        {
            if(moveState[m][n].eatChess.size() > max)
                max = moveState[m][n].eatChess.size();
        }
    }
    for(int m = 0;m < 10;m++)
    {
        for(int n = 0;n < 10; n++)
        {
            if(moveState[m][n].eatChess.size() == max && max > 0)
                vec.push_back(m*10+n);
        }
    }
    return vec;
}

void MainWindow::dfs(int i,int j,bool isCommon)
{
    if(isCommon)
    {
        int v[4] = {-1,-1,1,1};
        int h[4] = {-1,1,-1,1};
        for(int m = 0;m < 4 ;m++)
        {
            if(i+v[m]*2 >=0 && i+v[m]*2 <=9 && j+h[m]*2 >=0 && j+h[m]*2 <=9)
            {
                if(chess[i+v[m]][j+h[m]]->getColor() == 3-selfColor ||chess[i+v[m]][j+h[m]]->getColor() == 5-selfColor)
                    if(chess[i+v[m]*2][j+h[m]*2]->getColor() == 0)
                    {

                        if(std::find(moveState[i][j].eatChess.begin(),moveState[i][j].eatChess.end(),(i+v[m])*10+j+h[m]) == moveState[i][j].eatChess.end())
                        {
                            if(moveState[i][j].eatChess.size() + 1 > moveState[i+v[m]*2][j+h[m]*2].eatChess.size())
                            {
                                vector<int> eatChess_2;
                                vector<int> path_2;
                                eatChess_2 = moveState[i][j].eatChess;
                                path_2 = moveState[i][j].path;
                                eatChess_2.push_back((i+v[m])*10+j+h[m]);
                                path_2.push_back((i+v[m]*2)*10+j+h[m]*2);
                                moveState[i+v[m]*2][j+h[m]*2].eatChess = eatChess_2;
                                moveState[i+v[m]*2][j+h[m]*2].path = path_2;
                                dfs(i+v[m]*2,j+h[m]*2,true);
                            }
                        }

                    }
            }
        }
    }
    if(!isCommon)
    {
        int v[4] = {-1,-1,1,1};
        int h[4] = {-1,1,-1,1};
        for(int m = 0;m < 4;m++)
        {
            int firstCut = -1;
            int secondCut = -1;
            for(int n = 1; n < 9;n++)
            {
                if(i+v[m]*n >= 0 && i+v[m]*n < 10 && j+h[m]*n >=0 && j+h[m]*n < 10 )
                {
                    if(chess[i+v[m]*n][j+h[m]*n]->getColor() == 5 - selfColor ||chess[i+v[m]*n][j+h[m]*n]->getColor() == 3 - selfColor)
                    {
                        firstCut = n;
                        break;
                    }

                }
                else{
                    break;
                }
            }
            if(firstCut != -1)
            {
                for(int n = firstCut + 1;n < 9;n++)
                {
                    if(i+v[m]*n >= 0 && i+v[m]*n < 10 && j+h[m]*n >=0 && j+h[m]*n < 10)
                    {
                        if(chess[i+v[m]*n][j+h[m]*n]->getColor() != 0)
                        {
                            secondCut = n;
                            break;
                        }
                    }
                    else{
                        secondCut = n;
                        break;
                    }
                }
            }
            for(int n = firstCut + 1; n < secondCut;n++)
            {
                if(std::find(moveState[i][j].eatChess.begin(),moveState[i][j].eatChess.end(),(i+v[m]*firstCut)*10+j+h[m]*firstCut) == moveState[i][j].eatChess.end())
                {
                    if(moveState[i][j].eatChess.size() + 1 > moveState[i+v[m]*n][j+h[m]*n].eatChess.size())
                    {
                        vector<int> eatChess_2;
                        vector<int> path_2;
                        eatChess_2 = moveState[i][j].eatChess;
                        path_2 = moveState[i][j].path;
                        eatChess_2.push_back((i+v[m]*firstCut)*10+j+h[m]*firstCut);
                        path_2.push_back((i+v[m]*n)*10+j+h[m]*n);
                        moveState[i+v[m]*n][j+h[m]*n].eatChess = eatChess_2;
                        moveState[i+v[m]*n][j+h[m]*n].path = path_2;
                        dfs(i+v[m]*n,j+h[m]*n,false);
                    }
                }
            }
        }
    }
}

void MainWindow::fail()
{
    QMessageBox::about(NULL,tr("对战结果"),tr("你输了"));
    finished = true;
}

void MainWindow::succeed()
{
    QMessageBox::about(NULL,tr("比赛结果"),tr("你赢了"));
    finished = true;
    player->setMedia(QUrl("qrc:/new/prefix1/sounds/win.mp3"));
    player->play();
}

void MainWindow::draw()
{
    QMessageBox::about(NULL,tr("比赛结果"),tr("平局"));
    finished = true;
}

void MainWindow::showMovable()
{
    if(myTurn)
    {
        movable.clear();
        int max = 0;
        for(int i =0 ;i < 10;i++)
        {
            for(int j = 0;j < 10;j++)
            {
                if(chess[i][j]->getColor() == selfColor|| chess[i][j]->getColor() == selfColor +2)
                {
                    if(getJumpMove(i,j).size() > max)
                    {
                        max = getJumpMove(i,j).size();
                    }
                }
            }
        }
        if(max == 0)
        {
            onlyDirect  =true;
            for(int i =0 ;i < 10;i++)
            {
                for(int j = 0;j < 10;j++)
                {
                    if(chess[i][j]->getColor() == selfColor|| chess[i][j]->getColor() == selfColor +2)
                    {
                        vector<int> vec;
                        vec = getDirectMove(i , j);
                        if(vec.size() > 0)
                        {
                            board[i][j]->setStyleSheet(board[i][j]->styleSheet().append(QString("border:5px solid rgb(53,206,141);")));
                            movable.push_back(i*10+j);
                        }
                    }
                }
            }
        }
        else
        {
            onlyDirect = false;
            for(int i =0 ;i < 10;i++)
            {
                for(int j = 0;j < 10;j++)
                {
                    if(chess[i][j]->getColor() == selfColor|| chess[i][j]->getColor() == selfColor +2)
                    {
                        vector<int> vec;
                        vec = getJumpMove(i , j);
                        if(vec.size() == max)
                        {
                            board[i][j]->setStyleSheet(board[i][j]->styleSheet().append(QString("border:5px solid rgb(53,206,141);")));
                            movable.push_back(i*10+j);
                        }

                    }
                }
            }
        }
    }
}

void MainWindow::chessClicked(int index)
{
    if(!finished)
    {
        if(myTurn)
        {
            if(isFirstStage)
            {
                if(std::find(movable.begin(),movable.end(),index) != movable.end())
                {
                    nowChess = index;
                    direct = getDirectMove(nowChess/10,nowChess%10);
                    jump = getJumpMove(nowChess/10,nowChess%10);
                    for(int i =0 ;i < 10;i++)
                    {
                        for(int j = 0;j < 10;j++)
                        {
                            if(std::find(movable.begin(),movable.end(),i*10+j) != movable.end())
                                board[i][j]->setStyleSheet(board[index/10][index%10]->styleSheet().append("border:5px solid rgb(53,206,141);"));
                        }
                    }
                    board[index/10][index%10]->setStyleSheet(board[index/10][index%10]->styleSheet().append("border:5px solid rgb(128,0,255);"));
                    if(onlyDirect)
                    {
                        int size_1 =direct.size();
                        for(int i = 0; i< size_1; i++)
                        {
                            board[direct[i]/10][direct[i]%10]->setStyleSheet(board[direct[i]/10][direct[i]%10]->styleSheet().append("border:5px solid rgb(121,207,239);"));
                        }
                    }
                    else
                    {
                        int size_2 = jump.size();
                        for(int i = 0; i < size_2; i++)
                        {
                            board[jump[i]/10][jump[i]%10]->setStyleSheet(board[jump[i]/10][jump[i]%10]->styleSheet().append("border:5px solid rgb(121,207,239);"));
                        }
                        for(int i  = 0; i < size_2;i++)
                        {
                            int size_3 = moveState[jump[i]/10][jump[i]%10].path.size();
                            for(int j = 0 ;j < size_3-1;j++)
                            {
                                board[moveState[jump[i]/10][jump[i]%10].path[j]/10][moveState[jump[i]/10][jump[i]%10].path[j]%10]->setStyleSheet(board[moveState[jump[i]/10][jump[i]%10].path[j]/10][moveState[jump[i]/10][jump[i]%10].path[j]%10]->styleSheet().append("border:5px solid rgb(244,0,118);"));
                            }
                        }
                    }
                        isFirstStage = false;
                        return;
                }
            }
            if(!isFirstStage)
            {
                if(std::find(movable.begin(),movable.end(),index) != movable.end())
                {
                    isFirstStage = true;
                    direct = getDirectMove(nowChess/10,nowChess%10);
                    jump = getJumpMove(nowChess/10,nowChess%10);
                    if(onlyDirect)
                    {
                        int size_1 =direct.size();
                        for(int i = 0; i< size_1; i++)
                        {
                            board[direct[i]/10][direct[i]%10]->fresh();
                        }
                    }
                    else
                    {
                        int size_2 = jump.size();
                        for(int i = 0; i < size_2; i++)
                        {
                            board[jump[i]/10][jump[i]%10]->fresh();
                        }
                        for(int i  = 0; i < size_2;i++)
                        {
                            int size_3 = moveState[jump[i]/10][jump[i]%10].path.size();
                            for(int j = 0 ;j < size_3-1;j++)
                            {
                                board[moveState[jump[i]/10][jump[i]%10].path[j]/10][moveState[jump[i]/10][jump[i]%10].path[j]%10]->fresh();
                            }
                        }
                    }
                     chessClicked(index);
                }
                direct = getDirectMove(nowChess/10,nowChess%10);
                jump = getJumpMove(nowChess/10,nowChess%10);
                if(onlyDirect)
                {
                    if(std::find(direct.begin(),direct.end(),index) != direct.end())
                    {
                        isFirstStage = true;
                        moveSelf_Direct(nowChess/10,nowChess%10,index/10,index%10);
                        for(int i =0 ;i < 10;i++)
                        {
                            for(int j = 0;j < 10;j++)
                            {
                                board[i][j]->fresh();
                            }
                        }
                        return;
                    }
                }
                if(std::find(jump.begin(),jump.end(),index) != jump.end())
                {
                    isFirstStage = true;
                    moveSelf_Jump(nowChess/10,nowChess%10,moveState[index/10][index%10].eatChess,moveState[index/10][index%10].path);
                    for(int i =0 ;i < 10;i++)
                    {
                        for(int j = 0;j < 10;j++)
                        {
                            board[i][j]->fresh();
                        }
                    }
                    return;
                }
            }
        }
    }
}
