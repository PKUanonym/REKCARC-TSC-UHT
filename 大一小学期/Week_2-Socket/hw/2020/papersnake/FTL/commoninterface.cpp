#include "commoninterface.h"
#include <QDebug>

CommonInterface::CommonInterface(QObject *parent):
    CommonInterfaceSource(parent)
{
}

void CommonInterface::pong(QString msg)
{
    emit ReceivePong(msg);
}

void CommonInterface::sendPing(QString msg)
{
    emit ping(msg);
}
