#include "desktop.h"

Desktop::Desktop(QObject *parent) : QObject(parent){}

float Desktop::getDesktop()
{
    QDesktopWidget dw;
    float ver=float(dw.screenGeometry().width())/float(1920);
    return ver;
}
