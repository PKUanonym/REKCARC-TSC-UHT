#ifndef LBX_H
#define LBX_H

#include <QLabel>

class QLabelEx : public QLabel
{
    Q_OBJECT
public:
    explicit QLabelEx(QWidget *parent = nullptr);

protected:
    void mouseReleaseEvent(QMouseEvent *e);

signals:
    void clicked();

public slots:
};

#endif // LBX_H
