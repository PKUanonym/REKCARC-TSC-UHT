#ifndef USER_H
#define USER_H

#include <QObject>

class User : public QObject
{
    Q_OBJECT
public:
    explicit User(QObject *parent = 0);
    ~User();

signals:

public slots:
};

#endif // USER_H
