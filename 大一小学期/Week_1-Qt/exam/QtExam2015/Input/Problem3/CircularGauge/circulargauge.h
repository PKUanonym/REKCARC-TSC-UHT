#ifndef CIRCULARGAUGE_H
#define CIRCULARGAUGE_H

#include <QDialog>
#include<QKeyEvent>

namespace Ui {
    class CircularGauge;
}

class CircularGauge : public QDialog
{
    Q_OBJECT
    Q_PROPERTY(int value READ value WRITE setValue)

public:
    explicit CircularGauge(QWidget *parent = 0);
    ~CircularGauge();

    void setValue(int v)
    {
        m_value = v;
        update();
    }
    int value() { return m_value; }

private:
    void paintEvent(QPaintEvent *ev);
    void keyPressEvent(QKeyEvent *ev);
    void mousePressEvent(QMouseEvent *ev);
    void mouseReleaseEvent(QMouseEvent *ev);
    void mouseMoveEvent(QMouseEvent *ev);
    void setValueFromPos(const QPoint &pnt);

    Ui::CircularGauge *ui;
    int m_value;
    QPoint m_center;
};

#endif // CIRCULARGAUGE_H
