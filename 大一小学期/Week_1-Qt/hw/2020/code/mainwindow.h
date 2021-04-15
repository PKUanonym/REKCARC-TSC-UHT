#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>
#include <QLabel>
#include <QPainter>

#define xlen 40
#define ylen 40
#define xysize 15

struct Node {
    int x;
    int y;
    int type;
};

enum Label {
    empty_lable,
    border_lable,
    snake_label,
    food_label
};

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class paintWidget : public QWidget
{
    Q_OBJECT;

public:
    friend class MainWindow;
    paintWidget(QMainWindow* parent = 0);
    Node map[xlen+10][ylen+10]; // game map
    bool gamestart;
    QTimer *timer;

private:
    void paintEvent(QPaintEvent*);
    QPainter* paint;
    QList<Node*> snake; //snake body
    QList<Node*> border;
    QList<Node*> food;

    int dx, dy;
    int moveSpeed;
    int level;
    int bonus;
    int score;
    int roadLen;

    Node* head;
    Node* tail;

signals:
    void restared();
    void paused();
    void moved();

public slots:
    void startGameSlot();
    void continueGameSlot();
    void restartGameSlot();
    void pauseGameSlot();
    void snakeMoveSlot();
    void saveGameSlot();
    void loadGameSlot();

public:
    void gameOver();
    void init();
    void drawSnake(int x, int y);
    void drawBorder(int x, int y);
    void drawFood(int x, int y);
    void moveSnake();
    void getHeadTail();
    void createFood();
    void keyPressEvent(QKeyEvent *event);
    void mousePressEvent(QMouseEvent* event);
    bool notinSnake(int x, int y);
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    paintWidget* gamewidget;
    void keyPressEvent(QKeyEvent *event);
    QTimer* time;
    QString viewText;

private:
    Ui::MainWindow *ui;
    QLabel* mlabel;



public slots:
    void startGameSlot();
    void continueGameSlot();
    void restartGameSlot();
    void pauseGameSlot();
    void quitGameSlot();
    void snakeMoveSlot();
//    void saveGameSlot();
//    void loadGameSlot();
};
#endif // MAINWINDOW_H
