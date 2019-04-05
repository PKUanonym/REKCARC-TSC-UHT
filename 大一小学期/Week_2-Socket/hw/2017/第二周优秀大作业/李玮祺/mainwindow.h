#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "connect_setting.h"
#include "ui_connect_setting.h"

#include "portinput.h"
#include "ui_portinput.h"

using std::string;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void exitButtonclicked();
    void startButtonclicked();
    void on_quitButton_clicked();
    void ButtonPressed(int tar);
    void on_equa_clicked();
    void on_escape_clicked();
    void on_sebut_clicked();
    void on_bgmbut_clicked();
    void on_link_clicked();
    void closeDialog();
    void acceptConnection();
    void clientEnable();
    void recvMessage();
    void connectfail();

    void nekoclicked();

    void on_testdel_clicked();
    void on_testmov_clicked();
    void on_severon_clicked();
    void on_changeGod_clicked();
    void on_teststart_clicked();
    void on_testend_clicked();

private:
    Ui::MainWindow *ui;
    QMovie * movie;
    QIcon * taricon;
    QIcon * empt;
    QIcon * ocicon;
    QIcon * acicon;
    QIcon * ocicon1;
    QIcon * acicon1;
    QLabel * label;
    QIcon * ocicon2;
    QIcon * ocicon3;

    QPushButton * tempButton;
    QPushButton * ButtonMap[11][11];
    QPushButton * ActiveMap[51];
    int intMap[12][12];
    int choseMap[12][12];
    int xMap[51];
    int yMap[51];
    int ActiveInfo[51];
    string dfsdir[1000];
    int flag[51];
    bool god;
    int dfseat[1000];
    int dfsmax;
    int dfsans;
    int delque[51];
    int delsum;
    int lastmove;
    QSignalMapper * m;
    QMediaPlayer * playerse;
    QMediaPlayer * bgmplayer;
    QMediaPlaylist * playlist;

    int ifequal;
    int equanum;

    bool sestatue, bgmstatue;
    bool statuelink;
    QString loaddir;
    int loadport;

    Connect_setting * dlg;
    PortInput * dlg1;
    QString local;
    int port;

    bool statenow;
    bool ifhost;
    bool severonoff;
    bool ifdialog;
    QTcpSocket * readWriteSocket;
    QTcpSocket * clientSocket;
    QTcpSocket * severSocket;
    QTcpServer * listenSocket;
    QTcpServer * clientlistenSocket;
    QTcpServer * severlistenSocket;

    int active1;
    int active2;

    void shine(int tar);
    void dark(int tar);

    bool jsbool;
    int mremain;
    int eremain;
    bool testmood;
    bool whotern;

    void ChangeKing(int tar);
    void dfsbr(int pos, int eat);
    void dfslo(int pos, int eat, string dir);
    void beginround();
    void endround();
    int poschange(int pos);
    void movechess(int fromid, int toid);
    void deletechess(int tar);
    void showtar(int tar);
    void hidetar();
    void updatepoint();

    void initnet();
    void netclient();
    void initServer();
    void sendMessage(QString info);
    void serverclient();

    void waittime(unsigned int msec);

    void beginfightse();
    void deleteGIF(int tar);
    void loginse();
    void opGIF();
    void sebutton();
    void ding();
    void sechess();
    void FirstBGM();
    void FightBGM();
    void edBGM(int num);
    void beginfightgif();
    void luGIF();
    void endingGIF(int result);
    void connectMap();
    void init();
};

#endif // MAINWINDOW_H
