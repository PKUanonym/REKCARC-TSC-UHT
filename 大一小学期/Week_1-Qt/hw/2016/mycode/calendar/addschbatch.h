#ifndef ADDSCHBATCH_H
#define ADDSCHBATCH_H

#include <QDialog>
#include <QTranslator>
#include "schedule.h"
namespace Ui {
class addschbatch;
}

class addschbatch : public QDialog
{
    Q_OBJECT

public:
    explicit addschbatch(QWidget *parent = 0);
    ~addschbatch();
signals:
    void batchadd(QDate,schedule,int,int,int);
public slots:
    void acc();
    void changeEvent(QEvent* e);
private:
    Ui::addschbatch *ui;
};

#endif // ADDSCHBATCH_H
