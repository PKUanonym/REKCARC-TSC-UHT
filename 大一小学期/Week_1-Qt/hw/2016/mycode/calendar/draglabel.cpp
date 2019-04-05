#include "draglabel.h"

DragLabel::DragLabel(const QString &text, QWidget *parent)
    : QLabel(text, parent)
{
    qDebug("23333");
    setWindowFlags(Qt::FramelessWindowHint);
    setWindowOpacity(0.1);
}
