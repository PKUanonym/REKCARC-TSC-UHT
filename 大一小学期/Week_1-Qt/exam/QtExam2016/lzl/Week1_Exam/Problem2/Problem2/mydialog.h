#ifndef MYDIALOG
#define MYDIALOG

#include <QDialog>
#include <QPainter>
#include <QColor>
#include <QMouseEvent>
#include <QKeyEvent>
#include <QPaintEvent>

class mydialog : public QDialog
{
    Q_OBJECT
public:

    mydialog(QWidget* parent = NULL) : QDialog(parent) {}
    ~mydialog() {}
    void mousePressEvent(QMouseEvent *event);
    void keyPressEvent(QKeyEvent *event);
    void paintEvent(QPaintEvent *event);
    void keyReleaseEvent(QKeyEvent* event);
};


#endif // MYDIALOG

