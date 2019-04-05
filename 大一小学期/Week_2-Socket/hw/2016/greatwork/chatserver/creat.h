#ifndef CREAT_H
#define CREAT_H

#include <QDialog>
#include <QtWidgets>
#include <QtNetwork>
namespace Ui {
class creat;
}

class creat : public QDialog
{
    Q_OBJECT

public:
    explicit creat(QString selc,bool op,QWidget *parent = 0);
    ~creat();

private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

signals:
    void ok(QString);
    void sto();
private:
    Ui::creat *ui;
    bool opened;
    QString now_ip;
};

#endif // CREAT_H
