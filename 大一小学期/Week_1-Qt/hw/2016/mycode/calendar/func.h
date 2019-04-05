#ifndef FUNC_H
#define FUNC_H

#include <QWidget>
#include <QFile>
#include <QDebug>
#include <QDataStream>
#include <QIODevice>
#include <QMessageBox>
#include "croundprocessebar.h"
namespace Ui {
class func;
}

class func : public QWidget
{
    Q_OBJECT

public:
    explicit func(QWidget *parent = 0);
    ~func();
public slots:
    void copyFile(const QString&, const QString&);
private:
    Ui::func *ui;

};

#endif // FUNC_H
