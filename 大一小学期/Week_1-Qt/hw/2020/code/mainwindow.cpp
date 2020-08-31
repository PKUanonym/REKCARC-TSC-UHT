#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QString>
#include <QtDebug>
#include <QStyle>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QTime>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QByteArray>
#include <QFile>
#include <QIODevice>
#include <QFileDialog>

void paintWidget::init() {

    head = tail = &map[0][0];
    bonus = 0;
    dx = 1;
    dy = 0;
    score = 0;
    roadLen = 0;
    snake.clear();
    border.clear();
    food.clear();
    gamestart = false;

    int snakelen = 2;
    int snakex = 5;
    int snakey = 5;
    for(int i = 0; i < xlen; i++) {
        for(int j = 0; j < ylen; j++) {
            map[i][j].x = i;
            map[i][j].y = j;
            if(i == 0 | j == 0 | i == (xlen-1) | j == (ylen-1)) {
                map[i][j].type = border_lable;
                border.append(&map[i][j]);
               }
            else
                map[i][j].type = empty_lable;
        }
    }
    for(int i = 0; i < snakelen; i++) {
        snake.append(&map[i+snakex][snakey]);
        map[i+snakex][snakey].type = snake_label;
    }
}

paintWidget::paintWidget(QMainWindow* parent)
    : QWidget(parent){
    score = 0;
    roadLen = 0;
    this->setGeometry(10, 85, 600, 600);
    init();
    timer=new QTimer;
    QObject::connect(timer,SIGNAL(timeout()),this,SLOT(snakeMoveSlot()));
    this->setFocusPolicy(Qt::StrongFocus);
}

void paintWidget::paintEvent(QPaintEvent*)
{
    paint = new QPainter;
    paint->begin(this);
    paint->setBrush(QBrush(Qt::black, Qt::SolidPattern));
    for(int i = 0; i < border.length(); i++)
        paint->drawRect(border[i]->x*xysize, border[i]->y*xysize, xysize, xysize);
    paint->setBrush(QBrush(Qt::green, Qt::SolidPattern));
    for(int i = 0; i < snake.length(); i++)
        paint->drawRect(snake[i]->x*xysize, snake[i]->y*xysize, xysize, xysize);
    paint->setBrush((QBrush(Qt::red, Qt::SolidPattern)));
    for(int i = 0; i < food.length(); i++)
        paint->drawEllipse(food[i]->x*xysize, food[i]->y*xysize, xysize, xysize);
    paint->end();
}

void paintWidget::getHeadTail() {
    head = snake.at(snake.length() - 1);
    tail = snake.at(0);
}

void paintWidget::mousePressEvent(QMouseEvent *event) {
    switch (event->button()) {
        case Qt::LeftButton:
            if(!gamestart) {
                QPoint mouse = event->pos();
                int temp_x = (mouse.x()) / 15;
                int temp_y = (mouse.y()) / 15;
                map[temp_x][temp_y].type = border_lable;
                border.append(&map[temp_x][temp_y]);
            }
            update();
    }
}


void MainWindow::keyPressEvent(QKeyEvent *event) {
    switch (event->key()) {
    case Qt::Key_Space:
        if(gamewidget->gamestart)
            pauseGameSlot();
        else
            continueGameSlot();
        break;
    default:
        break;
    }
}

void paintWidget::keyPressEvent(QKeyEvent *event) {
    switch(event->key()) {
        // 同方向或者反方向不做任何操作

        case Qt::Key_Left:
            if(dx == 0){
                dx = -1;
                dy = 0;
                moveSnake();
            }
            break;
        case Qt::Key_Right:
            if(dx == 0){
                dx = 1;
                dy = 0;
                moveSnake();
            }
            break;
        case Qt::Key_Up:
            if(dy == 0){
                dx = 0;
                dy = -1;
                moveSnake();
                }
            break;
        case Qt::Key_Down:
            if(dy == 0){
                dx = 0;
                dy = 1;
                moveSnake();
                }
            break;
        case::Qt::Key_Space:
            if(gamestart) {
                pauseGameSlot();
                update();
            }
            else {
                continueGameSlot();
                update();
            }
            break;
        default:
            break;
        }
}

void paintWidget::drawSnake(int x, int y) {
    paint->begin(this);
    paint->setBrush(QBrush(Qt::green, Qt::SolidPattern));
    paint->drawRect(x*xysize, y*xysize, xysize, xysize);
    paint->end();
}

void paintWidget::drawFood(int x, int y) {
    paint->begin(this);
    paint->setBrush(QBrush(Qt::red, Qt::SolidPattern));
    paint->drawRect(x*xysize, y*xysize, xysize, xysize);
    paint->end();
}

void paintWidget::drawBorder(int x, int y) {
    paint->begin(this);
    paint->setBrush(QBrush(Qt::black, Qt::SolidPattern));
    paint->drawRect(x*xysize, y*xysize, xysize, xysize);
    paint->end();
}

bool paintWidget::notinSnake(int x, int y) {
    for(int i = 0; i < snake.length(); i++) {
        if(snake.at(i)->x == x && snake.at(i)->y == y)
            return false;
    }
    return true;
}

void paintWidget::createFood() {

    int foodx;
    int foody;
    srand((unsigned)time(0));
    do {
        foodx = rand()%xlen;
        foody = rand()%ylen;
    }while(((foodx == 0)||(foody == 0)||(foodx==xlen-1)||(foody==ylen-1)) || !notinSnake(foodx, foody));
    map[foodx][foody].type = food_label;
    food.append(&map[foodx][foody]);
}

void paintWidget::moveSnake() {

    roadLen++;
    getHeadTail();
    Node temp = map[(head->x)+dx][(head->y)+dy];
    if(bonus == 0) {
        snake.removeFirst();
        tail->type = empty_lable;
    }
    else
        bonus--;
    if(temp.type == border_lable || temp.type == snake_label)
        gameOver();
    else {
        snake.append(&map[(head->x)+dx][(head->y)+dy]);
        if(temp.type == food_label) {
            map[(head->x)+dx][(head->y)+dy].type = empty_lable;
            score++;
            food.removeFirst();
            bonus += 3;
            createFood();
        }
        else {
            map[(head->x)+dx][(head->y)+dy].type = snake_label;
        }
    }
    update();
}

void paintWidget::gameOver() {
    gamestart = false;
    timer->stop();
    QMessageBox::information(this, "Message:", "Game is over! Do you want to try is again?", QMessageBox::Ok);
    init();
    update();
    emit restared();
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    this->setFixedSize(620, 787);
    this->setWindowTitle("Snake");
    this->setWindowIcon(QIcon(":/image/logo"));

    mlabel = new QLabel(this);
    mlabel->setStyleSheet("font-size:20px;");
    mlabel->setGeometry(330, 50, 270, 30);

    ui->startTool->setIcon(QIcon(":/image/start"));
    ui->startTool->setStyleSheet("background-color:white");
    ui->startTool->setToolTip("start the game!");
    ui->continueTool->setIcon(QIcon(":/image/continue"));
    ui->continueTool->setStyleSheet("background-color:white");
    ui->continueTool->setToolTip("continue the game!");
    ui->saveTool->setIcon(QIcon(":/image/save"));
    ui->saveTool->setStyleSheet("background-color:white");
    ui->saveTool->setToolTip("save the game!");
    ui->loadTool->setIcon(QIcon(":/image/load"));
    ui->loadTool->setStyleSheet("background-color:white");
    ui->loadTool->setToolTip("load an existed game!");
    ui->pauseTool->setIcon(QIcon(":/image/pause"));
    ui->pauseTool->setStyleSheet("background-color:white");
    ui->pauseTool->setToolTip("pause the game!");
    ui->quitTool->setIcon(QIcon(":/image/quit"));
    ui->quitTool->setStyleSheet("background-color:white");
    ui->quitTool->setToolTip("quit the game!");
    ui->restartTool->setIcon(QIcon(":/image/restart"));
    ui->restartTool->setStyleSheet("background-color:white");
    ui->restartTool->setToolTip("restart the game!");
    gamewidget = new paintWidget(this);
    ui->pauseButton->setEnabled(false);
    ui->actioncontinueGame_2->setEnabled(false);
    ui->actionpauseGame_2->setEnabled(false);
    ui->continueButton->setEnabled(false);
    ui->saveButton->setEnabled(false);
    ui->actionsaveGame_2->setEnabled(false);
    ui->restartButton->setEnabled(false);
    ui->actionrestartGame_2->setEnabled(false);
    ui->pauseTool->setEnabled(false);
    ui->continueTool->setEnabled(false);
    ui->saveTool->setEnabled(false);
    ui->restartTool->setEnabled(false);
    ui->actionpauseGame->setEnabled(false);
    ui->actioncontinueGame->setEnabled(false);
    ui->actionsaveGame->setEnabled(false);
    ui->actionrestartGame->setEnabled(false);

    mlabel->setText("移动路程:" + QString::number(gamewidget->roadLen, 10) + "  得分:" + QString::number(gamewidget->score, 10));
    mlabel->show();


    QObject::connect(ui->startButton, SIGNAL(clicked()), this->gamewidget, SLOT(startGameSlot()));
    QObject::connect(ui->startButton, SIGNAL(clicked()), this, SLOT(startGameSlot()));
    QObject::connect(ui->continueButton, SIGNAL(clicked()), this->gamewidget, SLOT(continueGameSlot()));
    QObject::connect(ui->continueButton, SIGNAL(clicked()), this, SLOT(continueGameSlot()));
    QObject::connect(ui->pauseButton, SIGNAL(clicked()), this->gamewidget, SLOT(pauseGameSlot()));
    QObject::connect(ui->pauseButton, SIGNAL(clicked()), this, SLOT(pauseGameSlot()));
    QObject::connect(ui->restartButton, SIGNAL(clicked()), this->gamewidget, SLOT(restartGameSlot()));
    QObject::connect(ui->restartButton, SIGNAL(clicked()), this, SLOT(restartGameSlot()));
    QObject::connect(ui->quitButton, SIGNAL(clicked()), this, SLOT(quitGameSlot()));
    QObject::connect(gamewidget, SIGNAL(restared()), this, SLOT(restartGameSlot()));
//    QObject::connect(this->gamewidget->timer, SIGNAL(timeout()), this->gamewidget, SLOT(snakeMoveSlot()));
    QObject::connect(ui->actionstartGame, SIGNAL(triggered()), this, SLOT(startGameSlot()));
    QObject::connect(ui->actionstartGame, SIGNAL(triggered()), this->gamewidget, SLOT(startGameSlot()));
    QObject::connect(ui->startTool, SIGNAL(clicked()), this, SLOT(startGameSlot()));
    QObject::connect(ui->startTool, SIGNAL(clicked()), this->gamewidget, SLOT(startGameSlot()));
    QObject::connect(ui->actionpauseGame, SIGNAL(triggered()), this, SLOT(pauseGameSlot()));
    QObject::connect(ui->actionpauseGame, SIGNAL(triggered()), this->gamewidget, SLOT(pauseGameSlot()));
    QObject::connect(ui->pauseTool, SIGNAL(clicked()), this, SLOT(pauseGameSlot()));
    QObject::connect(ui->pauseTool, SIGNAL(clicked()), this->gamewidget, SLOT(pauseGameSlot()));
    QObject::connect(ui->actioncontinueGame, SIGNAL(triggered()), this, SLOT(continueGameSlot()));
    QObject::connect(ui->actioncontinueGame, SIGNAL(triggered()), this->gamewidget, SLOT(continueGameSlot()));
    QObject::connect(ui->continueTool, SIGNAL(clicked()), this, SLOT(continueGameSlot()));
    QObject::connect(ui->continueTool, SIGNAL(clicked()), this->gamewidget, SLOT(continueGameSlot()));
    QObject::connect(ui->actionrestartGame, SIGNAL(triggered()), this, SLOT(restartGameSlot()));
    QObject::connect(ui->actionrestartGame, SIGNAL(triggered()), this->gamewidget, SLOT(restartGameSlot()));
    QObject::connect(ui->restartTool, SIGNAL(clicked()), this, SLOT(restartGameSlot()));
    QObject::connect(ui->restartTool, SIGNAL(clicked()), this->gamewidget, SLOT(restartGameSlot()));
    QObject::connect(ui->quitTool, SIGNAL(clicked()), this, SLOT(quitGameSlot()));
    QObject::connect(ui->actionquitGame, SIGNAL(triggered()), this, SLOT(quitGameSlot()));
    QObject::connect(ui->saveButton, SIGNAL(clicked()), this->gamewidget, SLOT(saveGameSlot()));
    QObject::connect(ui->saveTool, SIGNAL(clicked()), this->gamewidget, SLOT(saveGameSlot()));
    QObject::connect(ui->actionsaveGame, SIGNAL(triggered()), this->gamewidget, SLOT(saveGameSlot()));
    QObject::connect(ui->loadButton, SIGNAL(clicked()), this->gamewidget, SLOT(loadGameSlot()));
    QObject::connect(ui->loadTool, SIGNAL(clicked()), this->gamewidget, SLOT(loadGameSlot()));
    QObject::connect(ui->actionloadGame, SIGNAL(triggered()), this->gamewidget, SLOT(loadGameSlot()));
    QObject::connect(gamewidget, SIGNAL(paused()), this, SLOT(pauseGameSlot()));
    QObject::connect(gamewidget, SIGNAL(moved()), this, SLOT(snakeMoveSlot()));
//    QObject::connect(time, SIGNAL(timeout()), this, SLOT(snakeMoveSlot()));
//    QObject::connect(ui->actionpauseGame, SIGNAL(triggered()), this, SLOT(startGameSlot()));
//    QObject::connect(ui->actioncontinueGame, SIGNAL(triggered()), this, SLOT(startGameSlot()));
//    QObject::connect(ui->actionrestartGame, SIGNAL(triggered()), this, SLOT(startGameSlot()));
//    QObject::connect(ui->actionsaveGame, SIGNAL(triggered()), this, SLOT(startGameSlot()));
//    QObject::connect(ui->actionloadGame, SIGNAL(triggered()), this, SLOT(startGameSlot()));
//    QObject::connect(ui->startButton, SIGNAL(clicked()), this->gamewidget, SLOT(startGameSlot()));
//    QObject::connect(ui->pauseButton, SIGNAL(clicked()), this, SLOT(pauseGameSlot()));
//    QObject::connect(ui->continueButton, SIGNAL(clicked()), this, SLOT(continueGameSlot()));
//    QObject::connect(ui->restartButton, SIGNAL(clicked()), this, SLOT(restartGameSlot()));
//    QObject::connect(ui->saveButton, SIGNAL(clicked()), this, SLOT(saveGameSlot()));
//    QObject::connect(ui->loadButton, SIGNAL(clicked()), this, SLOT(loadGameSlot()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void paintWidget::startGameSlot() {
    gamestart = true;
    createFood();
    timer->start(150);
}

void paintWidget::continueGameSlot() {
    gamestart = true;
    timer->start(150);
}

void paintWidget::pauseGameSlot() {
    gamestart = false;
    timer->stop();
}

void paintWidget::restartGameSlot() {
    gamestart = false;
    timer->stop();
    init();
    update();
}

void paintWidget::saveGameSlot() {
    QString path = QFileDialog::getSaveFileName(this, "Save", ".", "JSON(*.json)");
    if(!path.isEmpty()) {
        QFile file(path);
        if(file.open(QIODevice::WriteOnly)) {
            QJsonObject json;
            QJsonDocument document;
            QJsonArray jsonArr;
            for(int i = 0; i < xlen; i++) {
                for(int j = 0; j < ylen; j++) {
                    jsonArr.append(map[i][j].type);
                }
            }
            QJsonArray snakeArr;
            for(int i = 0; i < snake.length(); i++)
                snakeArr.append((xlen*(snake.at(i)->x))+(snake.at(i)->y));
            json.insert("map", jsonArr);
            json.insert("dx", dx);
            json.insert("dy", dy);
            json.insert("bonus", bonus);
            json.insert("snake", snakeArr);
            json.insert("score", score);
            json.insert("roadLen", roadLen);
            document.setObject(json);
            file.write(document.toJson());
            file.close();
        }
    }
    emit gameOver();
}

void paintWidget::loadGameSlot() {
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
            QJsonObject object = jsonDoc.object();
            dx = object["dx"].toInt();
            dy = object["dy"].toInt();
            bonus = object["bonus"].toInt();
            score = object["score"].toInt();
            roadLen = object["roadLen"].toInt();
            border.clear();
            snake.clear();
            food.clear();
            QJsonArray jsonArr = object["map"].toArray();
            QJsonArray snakeArr = object["snake"].toArray();
            for(int i = 0; i < 1600; i++) {
                int tx = i / xlen;
                int ty = i % ylen;
                map[tx][ty].type = jsonArr.at(i).toInt();
                if(map[tx][ty].type == 1) {
                    border.append(&map[tx][ty]);
                }
                else if(map[tx][ty].type == 3) {
                    food.append(&map[tx][ty]);
                }
            }
            int l = snakeArr.size();
            for(int i = 0; i < l; i++) {
                int tx = snakeArr.at(i).toInt() / xlen;
                int ty = snakeArr.at(i).toInt() % ylen;
                snake.append(&map[tx][ty]);
            }
        }
    }
    pauseGameSlot();
    emit paused();
}

void MainWindow::startGameSlot() {
    ui->startButton->setEnabled(false);
    ui->pauseButton->setEnabled(true);
    ui->loadButton->setEnabled(false);
    ui->startTool->setEnabled(false);
    ui->pauseTool->setEnabled(true);
    ui->loadTool->setEnabled(false);
    ui->actionstartGame->setEnabled(false);
    ui->actionpauseGame->setEnabled(true);
    ui->actionloadGame->setEnabled(false);
    ui->actionstartGame_2->setEnabled(false);
    ui->actionpauseGame_2->setEnabled(true);
    ui->actionloadGame_2->setEnabled(false);
}

void MainWindow::pauseGameSlot()
{
    ui->startButton->setEnabled(false);
    ui->startTool->setEnabled(false);
    ui->restartButton->setEnabled(true);
    ui->pauseButton->setEnabled(false);
    ui->continueButton->setEnabled(true);
    ui->saveButton->setEnabled(true);
    ui->restartTool->setEnabled(true);
    ui->pauseTool->setEnabled(false);
    ui->continueTool->setEnabled(true);
    ui->saveTool->setEnabled(true);
    ui->actionstartGame->setEnabled(false);
    ui->actionrestartGame->setEnabled(true);
    ui->actionpauseGame->setEnabled(false);
    ui->actioncontinueGame->setEnabled(true);
    ui->actionsaveGame->setEnabled(true);
    ui->actionstartGame_2->setEnabled(false);
    ui->actionrestartGame_2->setEnabled(true);
    ui->actionpauseGame_2->setEnabled(false);
    ui->actioncontinueGame_2->setEnabled(true);
    ui->actionsaveGame_2->setEnabled(true);

}

void MainWindow::restartGameSlot() {
    ui->pauseButton->setEnabled(false);
    ui->actionpauseGame->setEnabled(false);
    ui->actionpauseGame_2->setEnabled(false);
    ui->continueButton->setEnabled(false);
    ui->actioncontinueGame->setEnabled(false);
    ui->actioncontinueGame_2->setEnabled(false);
    ui->actionsaveGame->setEnabled(false);
    ui->actionsaveGame_2->setEnabled(false);
    ui->saveButton->setEnabled(false);
    ui->startButton->setEnabled(true);
    ui->actionstartGame->setEnabled(true);
    ui->actionstartGame_2->setEnabled(true);
    ui->restartButton->setEnabled(false);
    ui->actionrestartGame->setEnabled(false);
    ui->actionrestartGame_2->setEnabled(false);
    ui->loadButton->setEnabled(true);
    ui->actionloadGame->setEnabled(true);
    ui->actionloadGame_2->setEnabled(true);
    ui->pauseTool->setEnabled(false);
    ui->continueTool->setEnabled(false);
    ui->saveTool->setEnabled(false);
    ui->startTool->setEnabled(true);
    ui->restartTool->setEnabled(false);
    ui->loadTool->setEnabled(true);
}

void MainWindow::continueGameSlot() {
    ui->restartButton->setEnabled(false);
    ui->actionrestartGame->setEnabled(false);
    ui->actionrestartGame_2->setEnabled(false);
    ui->pauseButton->setEnabled(true);
    ui->actionpauseGame->setEnabled(true);
    ui->actionpauseGame_2->setEnabled(true);
    ui->continueButton->setEnabled(false);
    ui->actioncontinueGame->setEnabled(false);
    ui->actioncontinueGame_2->setEnabled(false);
    ui->saveButton->setEnabled(false);
    ui->actionsaveGame->setEnabled(false);
    ui->actionsaveGame_2->setEnabled(false);
    ui->restartTool->setEnabled(false);
    ui->pauseTool->setEnabled(true);
    ui->continueTool->setEnabled(false);
    ui->saveTool->setEnabled(false);
}

void paintWidget::snakeMoveSlot() {
    moveSnake();
    emit moved();
}

void MainWindow::snakeMoveSlot() {
    mlabel->setText("移动路程:" + QString::number(gamewidget->roadLen, 10) + "  得分:" + QString::number(gamewidget->score, 10));
    mlabel->show();
}

void MainWindow::quitGameSlot() {
    QCoreApplication::exit();
    QWidget::close();
}




