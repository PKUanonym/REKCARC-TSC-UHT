#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QCheckBox>
#include "calendar.h"
#include "mybuttongroup.h"

class calendar;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    void setEnglish();
    void unlockAndStayTop();
    void lockAndStayBottom();
    //void showbutton();
    calendar* cale;
    QMainWindow* mainwindow;


    ~MainWindow();

private slots:
    void on_pushButton_clicked();

    void on_pushButton_1_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

    void on_pushButton_4_clicked();

    void on_pushButton_5_clicked();

    void on_pushButton_6_clicked();

    void on_pushButton_7_clicked();

    void on_checkBox_8_toggled(bool checked);

    void save_event();

    void load_event();

    void on_radioButton_8_toggled(bool checked);
    void update();

private:
    Ui::MainWindow *ui;
    int window_long;
    QCheckBox* checkBox_8;

};

#endif // MAINWINDOW_H
