#include "chess.h"
QPixmap * pic[12];
QString pieceStr[6];
Chess::Chess(QWidget *parent, Piece name, bool isBlack):
    QLabel(parent), _isBlack(isBlack)
{
    setName(name);
}

Chess::~Chess()
{

}

Piece Chess::name()
{
    return _name;
}

void Chess::setName(Piece name)
{
    _name = name;
    this->setPixmap(pic[_isBlack ? (_name+6) : _name]->scaled(50, 50, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    this->repaint();
}

bool Chess::isBlack()
{
    return _isBlack;
}

void Chess::setIsBlack(bool isBlack)
{
    _isBlack = isBlack;
    this->setPixmap(pic[_isBlack ? (_name+6) : _name]->scaled(50, 50, Qt::KeepAspectRatio, Qt::SmoothTransformation));
}

void Chess::hide()
{
    emit beChied();
    return QLabel::hide();
}

int findName(QString name)
{
    for (int i = 0; i < 6; ++i) {
        if (name == pieceStr[i])
            return i;
    }
    return -1;
}
