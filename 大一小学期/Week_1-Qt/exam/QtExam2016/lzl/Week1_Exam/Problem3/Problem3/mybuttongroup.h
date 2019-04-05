#ifndef MYBUTTONGROUP
#define MYBUTTONGROUP

#include <QPushButton>
#include <QCheckBox>
#include <QRadioButton>
#include "windows.h"

class my_button : public QPushButton
{
    Q_OBJECT
public:
    my_button(QWidget *parent) : QPushButton(parent) {window_long = 0;}
    ~my_button() {}
    void unlockAndStayTop();
    void lockAndStayBottom();
    int window_long;
};

class my_checkbox : public QCheckBox
{
    Q_OBJECT
public:
    my_checkbox(QWidget *parent) : QCheckBox(parent) {window_long = 0;}
    ~my_checkbox() {}
    void unlockAndStayTop();
    void lockAndStayBottom();
    int window_long;
};

class my_radio : public QRadioButton
{
    Q_OBJECT
public:
    my_radio(QWidget *parent) : QRadioButton(parent) {window_long = 0;}
    ~my_radio() {}
    void unlockAndStayTop();
    void lockAndStayBottom();
    int window_long;
};

#endif // MYBUTTONGROUP

