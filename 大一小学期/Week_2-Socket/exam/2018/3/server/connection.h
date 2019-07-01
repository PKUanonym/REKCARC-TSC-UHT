#ifndef CONNECTION_H
#define CONNECTION_H

#include <QObject>
#include <QTcpSocket>
#include <QMutex>
#include <QThread>

class Connection : public QThread
{
    Q_OBJECT
public:
    explicit Connection(qintptr handle_, int ID, QObject *parent = nullptr);
    bool two;
    static int n;
signals:
    void startSend(QString name, int id);
    void refreshSend(int rate, int id);
    void endSend(QString name, int id);

    void startReceive(QString name, int id);
    void refreshReceive(int rate, int id);
    void endReceive(QString name, int id);

public slots:
    void init();
    void recv();
    void send(QString text);
    void logout();
private:
    qintptr handle;
    QTcpSocket *socket;
    QString myName;
    int id;
    QMutex *mutex;


};

#endif // CONNECTION_H
