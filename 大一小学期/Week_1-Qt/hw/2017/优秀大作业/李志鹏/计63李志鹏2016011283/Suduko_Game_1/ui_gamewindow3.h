/********************************************************************************
** Form generated from reading UI file 'gamewindow3.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GAMEWINDOW3_H
#define UI_GAMEWINDOW3_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QDialog>
#include <QtWidgets/QFrame>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLCDNumber>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_GameWindow3
{
public:
    QFrame *line;
    QFrame *line_2;
    QFrame *line_3;
    QFrame *line_4;
    QLCDNumber *lcdNumber;
    QPushButton *pushButton;
    QPushButton *pushButton_2;
    QPushButton *pushButton_3;
    QPushButton *pushButton_4;
    QPushButton *pushButton_5;
    QPushButton *pushButton_6;
    QPushButton *pushButton_7;
    QPushButton *pushButton_8;
    QPushButton *pushButton_9;
    QPushButton *pushButton_10;
    QPushButton *pushButton_11;
    QCheckBox *checkBox;
    QCheckBox *checkBox_2;

    void setupUi(QDialog *GameWindow3)
    {
        if (GameWindow3->objectName().isEmpty())
            GameWindow3->setObjectName(QStringLiteral("GameWindow3"));
        GameWindow3->resize(1500, 720);
        GameWindow3->setStyleSheet(QStringLiteral("background-color: rgb(182, 236, 228);"));
        line = new QFrame(GameWindow3);
        line->setObjectName(QStringLiteral("line"));
        line->setGeometry(QRect(245, 30, 20, 620));
        line->setFrameShadow(QFrame::Plain);
        line->setLineWidth(3);
        line->setFrameShape(QFrame::VLine);
        line_2 = new QFrame(GameWindow3);
        line_2->setObjectName(QStringLiteral("line_2"));
        line_2->setGeometry(QRect(455, 30, 20, 620));
        line_2->setFrameShadow(QFrame::Plain);
        line_2->setLineWidth(3);
        line_2->setFrameShape(QFrame::VLine);
        line_3 = new QFrame(GameWindow3);
        line_3->setObjectName(QStringLiteral("line_3"));
        line_3->setGeometry(QRect(50, 227, 620, 15));
        line_3->setFrameShadow(QFrame::Plain);
        line_3->setLineWidth(3);
        line_3->setFrameShape(QFrame::HLine);
        line_4 = new QFrame(GameWindow3);
        line_4->setObjectName(QStringLiteral("line_4"));
        line_4->setGeometry(QRect(50, 437, 620, 15));
        line_4->setFrameShadow(QFrame::Plain);
        line_4->setLineWidth(3);
        line_4->setFrameShape(QFrame::HLine);
        lcdNumber = new QLCDNumber(GameWindow3);
        lcdNumber->setObjectName(QStringLiteral("lcdNumber"));
        lcdNumber->setGeometry(QRect(990, 40, 250, 75));
        QFont font;
        font.setFamily(QStringLiteral("Calisto MT"));
        lcdNumber->setFont(font);
        pushButton = new QPushButton(GameWindow3);
        pushButton->setObjectName(QStringLiteral("pushButton"));
        pushButton->setGeometry(QRect(900, 380, 131, 131));
        QFont font1;
        font1.setFamily(QStringLiteral("Calisto MT"));
        font1.setPointSize(12);
        pushButton->setFont(font1);
        pushButton->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/Replay.PNG);"));
        pushButton_2 = new QPushButton(GameWindow3);
        pushButton_2->setObjectName(QStringLiteral("pushButton_2"));
        pushButton_2->setGeometry(QRect(1300, 210, 131, 131));
        pushButton_2->setFont(font1);
        pushButton_2->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/pause.PNG);"));
        pushButton_3 = new QPushButton(GameWindow3);
        pushButton_3->setObjectName(QStringLiteral("pushButton_3"));
        pushButton_3->setGeometry(QRect(1100, 210, 131, 131));
        QFont font2;
        font2.setFamily(QStringLiteral("Calisto MT"));
        font2.setPointSize(20);
        pushButton_3->setFont(font2);
        pushButton_3->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/tip.PNG);"));
        pushButton_4 = new QPushButton(GameWindow3);
        pushButton_4->setObjectName(QStringLiteral("pushButton_4"));
        pushButton_4->setGeometry(QRect(1100, 380, 131, 131));
        pushButton_4->setFont(font1);
        pushButton_4->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/recall.PNG);"));
        pushButton_5 = new QPushButton(GameWindow3);
        pushButton_5->setObjectName(QStringLiteral("pushButton_5"));
        pushButton_5->setGeometry(QRect(1300, 380, 131, 131));
        pushButton_5->setFont(font1);
        pushButton_5->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/Resume.PNG);"));
        pushButton_6 = new QPushButton(GameWindow3);
        pushButton_6->setObjectName(QStringLiteral("pushButton_6"));
        pushButton_6->setGeometry(QRect(900, 210, 131, 131));
        pushButton_6->setFont(font1);
        pushButton_6->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/delete.PNG);"));
        pushButton_7 = new QPushButton(GameWindow3);
        pushButton_7->setObjectName(QStringLiteral("pushButton_7"));
        pushButton_7->setGeometry(QRect(980, 570, 200, 50));
        QFont font3;
        font3.setFamily(QStringLiteral("Calisto MT"));
        font3.setPointSize(11);
        pushButton_7->setFont(font3);
        pushButton_7->setStyleSheet(QStringLiteral("background-color: rgb(255, 171, 69);"));
        pushButton_8 = new QPushButton(GameWindow3);
        pushButton_8->setObjectName(QStringLiteral("pushButton_8"));
        pushButton_8->setGeometry(QRect(1300, 550, 131, 131));
        pushButton_8->setFont(font1);
        pushButton_8->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/Quit.PNG);"));
        pushButton_9 = new QPushButton(GameWindow3);
        pushButton_9->setObjectName(QStringLiteral("pushButton_9"));
        pushButton_9->setGeometry(QRect(980, 650, 200, 50));
        pushButton_9->setFont(font1);
        pushButton_9->setStyleSheet(QStringLiteral("background-color: rgb(255, 171, 69);"));
        pushButton_10 = new QPushButton(GameWindow3);
        pushButton_10->setObjectName(QStringLiteral("pushButton_10"));
        pushButton_10->setGeometry(QRect(1100, 210, 131, 131));
        pushButton_10->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/deleteALL.PNG);"));
        pushButton_11 = new QPushButton(GameWindow3);
        pushButton_11->setObjectName(QStringLiteral("pushButton_11"));
        pushButton_11->setGeometry(QRect(1100, 550, 131, 131));
        pushButton_11->setStyleSheet(QStringLiteral("background-image: url(:/new/prefix1/mark1.PNG);"));
        checkBox = new QCheckBox(GameWindow3);
        checkBox->setObjectName(QStringLiteral("checkBox"));
        checkBox->setGeometry(QRect(1300, 20, 151, 71));
        checkBox->setFont(font1);
        checkBox_2 = new QCheckBox(GameWindow3);
        checkBox_2->setObjectName(QStringLiteral("checkBox_2"));
        checkBox_2->setGeometry(QRect(1300, 110, 141, 41));
        checkBox_2->setFont(font1);

        retranslateUi(GameWindow3);

        QMetaObject::connectSlotsByName(GameWindow3);
    } // setupUi

    void retranslateUi(QDialog *GameWindow3)
    {
        GameWindow3->setWindowTitle(QApplication::translate("GameWindow3", "Dialog", 0));
        pushButton->setText(QString());
        pushButton_2->setText(QString());
        pushButton_3->setText(QString());
        pushButton_4->setText(QString());
        pushButton_5->setText(QString());
        pushButton_6->setText(QString());
        pushButton_7->setText(QApplication::translate("GameWindow3", "I Want to Set a Sudoku ", 0));
        pushButton_8->setText(QString());
        pushButton_9->setText(QApplication::translate("GameWindow3", "Finish", 0));
        pushButton_10->setText(QString());
        pushButton_11->setText(QString());
        checkBox->setText(QApplication::translate("GameWindow3", "Sound", 0));
        checkBox_2->setText(QApplication::translate("GameWindow3", "KeyBoard", 0));
    } // retranslateUi

};

namespace Ui {
    class GameWindow3: public Ui_GameWindow3 {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GAMEWINDOW3_H
