#include <QApplication>
#include "circulargauge.h"
#include"keyboardfilter.h"
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    CircularGauge w;
    KeyboardFilter filter;
    w.installEventFilter(&filter);

    w.show();

    return a.exec();
}
