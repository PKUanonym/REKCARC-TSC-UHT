#ifndef DOWNLOAD_H
#define DOWNLOAD_H

#include <QThread>
#include <QtNetwork>

class Download : public QThread
{
    Q_OBJECT
public:
    QString filename;
    int port;
    bool avaliable;
    Download(int _,QObject *parent=Q_NULLPTR):QThread(parent),port(_),avaliable(true){}
    void run();
signals:
    void refreshFileName(QString);
    void refreshProgressBar(int);
};

#endif // DOWNLOAD_H
