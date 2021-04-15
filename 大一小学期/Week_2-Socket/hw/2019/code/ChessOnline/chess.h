#ifndef CHESS_H
#define CHESS_H

#include <QLabel>

extern QPixmap * pic[12];
extern QString pieceStr[6];

enum Piece {king = 0, queen, rook, bishop, knight, pawn};

int findName(QString name);

class Chess : public QLabel
{
    Q_OBJECT
    Piece _name;
    bool _isBlack;

public:
    explicit Chess(QWidget *parent = nullptr, Piece name = king, bool isBlack = false);
    ~Chess();
    Piece name();
    void setName(Piece name);
    bool isBlack();
    void setIsBlack(bool isBlack);

signals:
    void beChied();

public:
    void hide();
};

#endif // CHESS_H
