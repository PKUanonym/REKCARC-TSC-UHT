#ifndef DESKTOP_H
#define DESKTOP_H
#include <QObject>
#include <QDesktopWidget>

class Desktop : public QObject
{
    Q_OBJECT
public:
    explicit Desktop(QObject *parent = 0);
    float getDesktop();

signals:

public slots:
};

#endif // DESKTOP_H
