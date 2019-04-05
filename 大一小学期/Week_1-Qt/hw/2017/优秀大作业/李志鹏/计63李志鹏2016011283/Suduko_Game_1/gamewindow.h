#ifndef GAMEWINDOW_H
#define GAMEWINDOW_H

#include <QDialog>
#include "gamewindow3.h"

namespace Ui {
class GameWindow;
}

class GameWindow : public QDialog
{
    Q_OBJECT

public:
    explicit GameWindow(QWidget *parent = 0);
    ~GameWindow();

private:
    GameWindow3 *temp;

private slots:

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

    void on_pushButton_4_clicked();

    void on_pushButton_5_clicked();

private:
    Ui::GameWindow *ui;
};

#endif // GAMEWINDOW_H
