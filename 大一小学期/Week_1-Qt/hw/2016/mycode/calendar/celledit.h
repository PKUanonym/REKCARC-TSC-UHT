#ifndef CELLEDIT_H
#define CELLEDIT_H

#include <QDialog>
#include <QTime>
#include <QColorDialog>
#include <QMessageBox>
#include "dateinfo.h"
namespace Ui {
class celledit;
}

class celledit : public QDialog
{
    Q_OBJECT

public:
    explicit celledit(QDate nowd,dateinfo c,QWidget *parent = 0);
    ~celledit();
signals:
    void changed(QDate,dateinfo);
    void des_changed(QString);
    void st_changed(QTime);
    void et_changed(QTime);
public slots:
    void cbkcolor();
    void ctcolor();
    void merge();
    void selc_ch(int);
    void ss();
    void del_all();
    void changeEvent(QEvent* e);
private:
    QDate now_date;
    dateinfo info;
    schedule tmp;
    Ui::celledit *ui;
    std::map <QString,QColor> colormap;
};

#endif // CELLEDIT_H
