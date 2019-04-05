#include "keyboardfilter.h"
#include<QKeyEvent>

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
                    o->setProperty("value", 0);
                    return true;
                }
    return false;
}
