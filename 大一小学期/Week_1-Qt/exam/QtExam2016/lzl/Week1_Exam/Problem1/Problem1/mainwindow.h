#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:

    void on_pushButton_2_clicked();

    void on_pushButton_clicked();

    void procceed();

    void on_pushButton_3_clicked();

private:
    Ui::MainWindow *ui;
    int rest, now;
    int cnt;

};

#endif // MAINWINDOW_H
