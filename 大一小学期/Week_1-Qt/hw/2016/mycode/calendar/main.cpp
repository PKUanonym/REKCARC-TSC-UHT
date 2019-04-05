#include "mainwindow.h"
#include <QApplication>
#include <QString>
#include <QtWidgets>
#include "croundprocessebar.h"
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QString locale = "cn_ZH.qm";//QLocale::system().name();    // for example: zh_CN, en_US

    QTranslator *translator = new QTranslator(qApp);

    translator->load(locale);

    a.installTranslator( translator );
    MainWindow w;
    w.show();

    return a.exec();
}
