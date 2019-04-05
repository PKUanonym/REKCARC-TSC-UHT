#include "clientwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    clientWindow w;
    //w.connectHost();
    w.show();

    return a.exec();
}
