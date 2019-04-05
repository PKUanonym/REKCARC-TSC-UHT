#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    int tot,stat,sec;

public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
public slots:
    void setclock();
    void timerEvent(QTimerEvent *);
private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

private:
    Ui::Dialog *ui;
};

#endif // DIALOG_H
