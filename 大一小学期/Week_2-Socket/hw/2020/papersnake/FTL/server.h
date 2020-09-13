#ifndef SERVER_H
#define SERVER_H
#include <QWidget>
#include <QObject>
#include <QRemoteObjectHost>
#include <QLabel>
#include "ui_mainwindow.h"
#include "commoninterface.h"
#include "ftl.h"
#include "basewidget.h"

class server: public QObject
{
    Ui::MainWindow *parent;
    Q_OBJECT
private slots:
    void pong(QString msg);
public:
    server(Ui::MainWindow *_parent);
    CommonInterface * m_pInterface = nullptr;
    QRemoteObjectHost * m_pHost = nullptr;
    int id;
    BaseWidget *basewidget;
    GameStatus* gamestatus;
};

#endif // SERVER_H
