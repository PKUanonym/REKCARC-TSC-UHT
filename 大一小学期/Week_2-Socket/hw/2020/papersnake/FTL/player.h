#ifndef PLAYER_H
#define PLAYER_H
#include <QString>

class player
{
private:
    QString path;
public:
    player();
    player(QString p);
    void setPath(QString p);
};

#endif // PLAYER_H
