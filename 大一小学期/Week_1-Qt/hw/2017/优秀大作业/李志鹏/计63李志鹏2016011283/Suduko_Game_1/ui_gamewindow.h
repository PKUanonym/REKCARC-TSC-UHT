/********************************************************************************
** Form generated from reading UI file 'gamewindow.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GAMEWINDOW_H
#define UI_GAMEWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QDialog>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_GameWindow
{
public:
    QLabel *label;
    QPushButton *pushButton_2;
    QPushButton *pushButton_3;
    QPushButton *pushButton_4;
    QPushButton *pushButton_5;

    void setupUi(QDialog *GameWindow)
    {
        if (GameWindow->objectName().isEmpty())
            GameWindow->setObjectName(QStringLiteral("GameWindow"));
        GameWindow->resize(750, 300);
        GameWindow->setStyleSheet(QStringLiteral("background-color: rgb(0, 0, 0);"));
        label = new QLabel(GameWindow);
        label->setObjectName(QStringLiteral("label"));
        label->setGeometry(QRect(200, 40, 400, 41));
        QFont font;
        font.setFamily(QStringLiteral("Calisto MT"));
        font.setPointSize(12);
        label->setFont(font);
        label->setStyleSheet(QStringLiteral("color: rgb(255, 255, 255);"));
        pushButton_2 = new QPushButton(GameWindow);
        pushButton_2->setObjectName(QStringLiteral("pushButton_2"));
        pushButton_2->setGeometry(QRect(30, 140, 150, 75));
        QFont font1;
        font1.setFamily(QStringLiteral("Calisto MT"));
        font1.setPointSize(20);
        pushButton_2->setFont(font1);
        pushButton_2->setStyleSheet(QLatin1String("color: rgb(255, 255, 255);\n"
"background-color: rgb(0, 0, 0);"));
        pushButton_3 = new QPushButton(GameWindow);
        pushButton_3->setObjectName(QStringLiteral("pushButton_3"));
        pushButton_3->setGeometry(QRect(210, 140, 150, 75));
        pushButton_3->setFont(font1);
        pushButton_3->setStyleSheet(QLatin1String("color: rgb(255, 255, 255);\n"
"background-color: rgb(0, 0, 0);"));
        pushButton_4 = new QPushButton(GameWindow);
        pushButton_4->setObjectName(QStringLiteral("pushButton_4"));
        pushButton_4->setGeometry(QRect(390, 140, 150, 75));
        pushButton_4->setFont(font1);
        pushButton_4->setStyleSheet(QLatin1String("color: rgb(255, 255, 255);\n"
"background-color: rgb(0, 0, 0);"));
        pushButton_5 = new QPushButton(GameWindow);
        pushButton_5->setObjectName(QStringLiteral("pushButton_5"));
        pushButton_5->setGeometry(QRect(570, 140, 150, 75));
        pushButton_5->setFont(font1);
        pushButton_5->setStyleSheet(QLatin1String("color: rgb(255, 255, 255);\n"
"background-color: rgb(0, 0, 0);"));

        retranslateUi(GameWindow);

        QMetaObject::connectSlotsByName(GameWindow);
    } // setupUi

    void retranslateUi(QDialog *GameWindow)
    {
        GameWindow->setWindowTitle(QApplication::translate("GameWindow", "Dialog", 0));
        label->setText(QApplication::translate("GameWindow", "Please Choose the Degree of Difficulty", 0));
        pushButton_2->setText(QApplication::translate("GameWindow", "Easy", 0));
        pushButton_3->setText(QApplication::translate("GameWindow", "Meidum", 0));
        pushButton_4->setText(QApplication::translate("GameWindow", "Difficult", 0));
        pushButton_5->setText(QApplication::translate("GameWindow", "Crazy", 0));
    } // retranslateUi

};

namespace Ui {
    class GameWindow: public Ui_GameWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GAMEWINDOW_H
