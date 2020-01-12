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
    void on_actionFind_triggered();

    void on_actionExit_triggered();

    void on_actionOpen_triggered();

private:
    Ui::MainWindow *ui;
    QString txt;
};

#endif // MAINWINDOW_H
