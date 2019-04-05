#include "mainwindow.h"
#include <QApplication>
#include <QDialog>
#include <QTranslator>
#include <QMessageBox>
#include <QDesktopWidget>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QMessageBox customMsgBox;
    customMsgBox.setWindowTitle("Welcome/欢迎");
    QPushButton *lockButton = customMsgBox.addButton("中文",QMessageBox::ActionRole);
    QPushButton *English    = customMsgBox.addButton("English",QMessageBox::ActionRole);
    QPushButton *Japanese   = customMsgBox.addButton("日本語",QMessageBox::ActionRole);
    customMsgBox.setText("欢迎使用国际化万年历，宇宙中心五道口出品，请选择语言偏好:\n\n"
                         "Welcome to use our international calendar, published by the center of universe,"
                         "5th Avernue.\nNow please choose your preferred language:\n\n"
                         "宇宙の五道口センターによって生成され、国際的なカレンダーへようこそ。お使いの言語設定を選択してください");
    customMsgBox.exec();
    QTranslator translator;
    if(customMsgBox.clickedButton() == (QAbstractButton*) lockButton)
    {
        translator.load(":/qm/Chinese");
        a.installTranslator(&translator);
    }
    MainWindow w;
    if (customMsgBox.clickedButton() == (QAbstractButton*) Japanese)
    {
        QMessageBox::information(0, "バカ", "ありがとうございます！でも、この人はまだに日本語を勉強しています、だがらそんな難しい仕事、無理です。本当にすみませんでした", QMessageBox::Ok);
        return 0;
    }
    if (customMsgBox.clickedButton() == (QAbstractButton*) English)
    {
        w.setEnglish();
    }
    /*QDesktopWidget* desktopWidget = QApplication::desktop();
    QRect screenRect = desktopWidget->screenGeometry();
    w.resize(QSize(screenRect.width(), screenRect.height()));*/
    w.show();
    w.mainwindow->show();
    return a.exec();
}
