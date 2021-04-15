#ifndef COMMONINTERFACE_H
#define COMMONINTERFACE_H

#include "rep_commoninterface_source.h"

class CommonInterface : public CommonInterfaceSource
{
    Q_OBJECT
public:
    explicit CommonInterface(QObject * parent = nullptr);
    void sendPing(QString msg);
    void pong(QString msg);
signals:
    void ReceivePong(QString msg);

};

#endif // COMMONINTERFACE_H
