#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);
    ~Widget();
    //void paintEvent(QPaintEvent *event);
    void setValue(int v);

    int value() { return m_value; }
public slots:
    //void add();
    //bool eventFilter(QObject *watched, QEvent *event);
    //void setshiqu(QString st);
    void showTime();


private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

private:
    void paintEvent(QPaintEvent *ev);


    Ui::Widget *ui;
    int m_value;
    QPoint m_center;
    QTimer* tm2;
    int on;
};

#endif // WIDGET_H
