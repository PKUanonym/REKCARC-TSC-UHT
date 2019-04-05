#include "keyboardfilter.h"
#include<QKeyEvent>
#include <QTime>

KeyboardFilter::KeyboardFilter(QObject *parent) :
    QObject(parent)
{
}

bool KeyboardFilter::eventFilter(QObject *o, QEvent *ev)
{
    if (ev->type() == QEvent::KeyPress)
        if (QKeyEvent *ke = static_cast<QKeyEvent*>(ev))
            if (ke->key() == Qt::Key_0)
                if (o->metaObject()->indexOfProperty("value") != -1 )
                {
                    o->setProperty("value",QTime::currentTime().hour()*3600+QTime::currentTime().minute()*60+QTime::currentTime().second());
                    return true;
                }
    return false;
}
