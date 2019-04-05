#ifndef KEYBOARDFILTER_H
#define KEYBOARDFILTER_H

#include <QObject>
#include<QEvent>

class KeyboardFilter : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardFilter(QObject *parent = 0);

signals:

public slots:
private:
    bool eventFilter(QObject *o, QEvent *ev);
};

#endif // KEYBOARDFILTER_H
