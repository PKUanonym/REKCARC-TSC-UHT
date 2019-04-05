#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QPushButton>

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    QPushButton**number;
    int sum,now,sig;
    void plus();
    void minus();
    void getans();

public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
    void keyPressEvent(QKeyEvent *);
private slots:
    void addnum(int);

    void on_pushButton_4_clicked();

    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

private:
    Ui::Dialog *ui;
};

#endif // DIALOG_H
