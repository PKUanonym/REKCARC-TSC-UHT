#ifndef CLIENT_H
#define CLIENT_H
#include <QWidget>
#include <QTimer>
#include <QRemoteObjectNode>
#include "ui_mainwindow.h"
#include "rep_commoninterface_replica.h"
#include "ftl.h"
#include "basewidget.h"

class client: public QObject
{
    Ui::MainWindow *parent;
    Q_OBJECT
private slots:
    void onReceivePing(QString msg);
public:
    client(Ui::MainWindow *_parent);
    QRemoteObjectNode * m_pRemoteNode1 = nullptr;
    CommonInterfaceReplica * m_pInterface1 = nullptr;
    QRemoteObjectNode * m_pRemoteNode2 = nullptr;
    CommonInterfaceReplica * m_pInterface2 = nullptr;
    QRemoteObjectNode * m_pRemoteNode3 = nullptr;
    CommonInterfaceReplica * m_pInterface3 = nullptr;
    BaseWidget *basewidget;
    GameStatus *gamestatus;
};

#endif // CLIENT_H
