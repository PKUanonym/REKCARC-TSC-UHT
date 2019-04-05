#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QString>
#include <QVector>
#include <QTimer>

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT
    QVector<QString>img;
    QTimer*timer;
    int interval,temp;
public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
private slots:
    void on_pushButton_clicked();
    void on_pushButton_3_clicked();
    void repeat();
    void on_pushButton_2_clicked();
private:
    Ui::Dialog *ui;
    void setimg(QString path);
};

#endif // DIALOG_H
