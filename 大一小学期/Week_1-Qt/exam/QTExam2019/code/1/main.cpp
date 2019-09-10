#include "widget.h"
#include "picture.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Picture p;
    p.show();

    return a.exec();
}
