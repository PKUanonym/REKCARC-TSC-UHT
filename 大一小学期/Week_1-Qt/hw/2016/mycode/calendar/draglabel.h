#ifndef DRAGLABEL_H
#define DRAGLABEL_H

#include <QLabel>

QT_BEGIN_NAMESPACE
class QDragEnterEvent;
class QDragMoveEvent;
class QFrame;
QT_END_NAMESPACE

class DragLabel : public QLabel
{
public:
    DragLabel(const QString &text, QWidget *parent);
};

#endif // DRAGLABEL_H
