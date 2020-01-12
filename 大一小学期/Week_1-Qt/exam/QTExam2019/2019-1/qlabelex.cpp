#include "qlabelex.h"

QLabelEx::QLabelEx(QWidget *parent) : QLabel(parent)
{
}

void QLabelEx::mouseReleaseEvent(QMouseEvent *e)
{
    Q_UNUSED(e);
    emit clicked();
}
