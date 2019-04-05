#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QVector>
#include <QString>
#include "thread.h"
#include "tthread.h"

namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT

public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();

private:
    Ui::Dialog *ui;
    Thread*thread[5];
    TThread *th[5];
    int cnt,n;
    QString*a;
    veclist ans[5][5];
    veclist final[5];
public slots:
    void end();
    void end2();
};

#endif // DIALOG_H
