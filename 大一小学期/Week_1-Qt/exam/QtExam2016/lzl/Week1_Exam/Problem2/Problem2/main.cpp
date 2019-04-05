#include "mainwindow.h"
#include "mydialog.h"
#include <QApplication>
#include <QDialog>
#include <QVector>
#include <QPoint>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    mydialog d;
    QSize s(500, 500);
    d.setFixedSize(s);
    d.show();


    return a.exec();
}
