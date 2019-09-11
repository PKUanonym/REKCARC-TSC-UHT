#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QKeyEvent>
#include <QTcpServer>
#include <QTcpSocket>
#include <vector>
#include <QLCDNumber>
#include <QTextStream>
#include <QMediaPlayer>
#include <QUrl>
#include "chess.h"
#include "timethread.h"
using namespace std;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:

    void createConnection();
    void connecting();
    void throwUp();
    void save();
    void load();

    void recvMessage();
    void sendMessage(int num, int x, int y);
    void youWin();
    void youLose();

private:
    bool promotion = false;
    bool switchKing = false;
    int switchDX = 0, switchIndex = -1;
    void initGame();
    int getNum(int x, int y);
    int getNum(QPoint p);
    int getXIndex(QPoint p);
    int getYIndex(QPoint p);
    QPoint getPos(int x, int y);
    QPoint getPos(QString pos);
    void highlight(int num);
    void moveTo(int x, int y);
    void moveTo(int x, int y, int num);

    int checkAbleGo(int num, int x, int y, bool checkPromotion = false, bool checkSwitch = false);
    bool tryToGo(int x, int y, bool checkPromotion = false, bool checkSwitch = false);
    bool tryToGo(QPoint p, bool checkPromotion = false, bool checkSwitch = false);
    bool isJiang();
    bool isBeJianged();
    bool isWhiteBeJianged();
    bool isBlackBeJianged();
    bool isEnemy(int n);

    void mousePressEvent(QMouseEvent * e);

    bool hasInited = false;
    bool youAreWhite = true;
    bool isYourTurn = true;
    int highlightNow = -1;

    Ui::MainWindow *ui;

    QLabel * board;
    Chess* pieces[32];
    QLabel * sqr;
    QLabel * whoseTurn[2];
    QLCDNumber * time = nullptr;
    TimeThread * thread = nullptr;
    QMediaPlayer * musicPlayer;

    QTcpSocket * readWriteSocket = nullptr;


};

#endif // MAINWINDOW_H
