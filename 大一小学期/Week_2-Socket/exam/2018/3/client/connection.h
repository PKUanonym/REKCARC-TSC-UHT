#ifndef CONNECTION_H
#define CONNECTION_H

#include <QObject>
#include <QtNetwork>
#include <QByteArray>
#include <QDataStream>
#include <QMutex>
class Connection : public QThread
{
    Q_OBJECT
public:
    explicit Connection(int ID, int t, QString path, QObject *parent = nullptr);
    int ty;


signals:
    void startSend(QString name, int id);
    void refreshSend(int rate, int id);
    void endSend(QString name, int id);

    void startReceive(QString name, int id);
    void refreshReceive(int rate, int id);
    void endReceive(QString name, int id);
    void getName(int id);
public slots:
    void init();
    void recv();
    void send();
    void logout();
    void setName(QString name);
private:
    QTcpSocket *socket;
    int id;
    QMutex* mutex;
    QString savePath;
    QMutex* fileNameMutex;

};

#endif // CONNECTION_H
