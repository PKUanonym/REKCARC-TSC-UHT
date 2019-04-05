/********************************************************************************
** Form generated from reading UI file 'connect_setting.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_CONNECT_SETTING_H
#define UI_CONNECT_SETTING_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QDialog>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_Connect_setting
{
public:
    QLabel *ip1;
    QLabel *port1;
    QLineEdit *lineEdit;
    QLineEdit *lineEdit_2;
    QPushButton *connect;
    QPushButton *cancel;
    QLabel *ip2;
    QLabel *port2;
    QLineEdit *lineEdit_3;
    QLineEdit *lineEdit_4;
    QLabel *bg;
    QLabel *labelT;
    QLabel *labelF;

    void setupUi(QDialog *Connect_setting)
    {
        if (Connect_setting->objectName().isEmpty())
            Connect_setting->setObjectName(QStringLiteral("Connect_setting"));
        Connect_setting->resize(300, 210);
        ip1 = new QLabel(Connect_setting);
        ip1->setObjectName(QStringLiteral("ip1"));
        ip1->setGeometry(QRect(20, 20, 80, 20));
        QFont font;
        font.setPointSize(14);
        ip1->setFont(font);
        port1 = new QLabel(Connect_setting);
        port1->setObjectName(QStringLiteral("port1"));
        port1->setGeometry(QRect(20, 50, 80, 20));
        port1->setFont(font);
        lineEdit = new QLineEdit(Connect_setting);
        lineEdit->setObjectName(QStringLiteral("lineEdit"));
        lineEdit->setGeometry(QRect(110, 20, 160, 20));
        lineEdit->setFont(font);
        lineEdit->setReadOnly(true);
        lineEdit_2 = new QLineEdit(Connect_setting);
        lineEdit_2->setObjectName(QStringLiteral("lineEdit_2"));
        lineEdit_2->setGeometry(QRect(110, 50, 160, 20));
        lineEdit_2->setFont(font);
        lineEdit_2->setReadOnly(true);
        connect = new QPushButton(Connect_setting);
        connect->setObjectName(QStringLiteral("connect"));
        connect->setGeometry(QRect(50, 160, 80, 30));
        connect->setFont(font);
        cancel = new QPushButton(Connect_setting);
        cancel->setObjectName(QStringLiteral("cancel"));
        cancel->setGeometry(QRect(170, 160, 80, 30));
        cancel->setFont(font);
        ip2 = new QLabel(Connect_setting);
        ip2->setObjectName(QStringLiteral("ip2"));
        ip2->setGeometry(QRect(20, 90, 80, 20));
        ip2->setFont(font);
        port2 = new QLabel(Connect_setting);
        port2->setObjectName(QStringLiteral("port2"));
        port2->setGeometry(QRect(20, 120, 80, 20));
        port2->setFont(font);
        lineEdit_3 = new QLineEdit(Connect_setting);
        lineEdit_3->setObjectName(QStringLiteral("lineEdit_3"));
        lineEdit_3->setGeometry(QRect(110, 90, 160, 20));
        lineEdit_3->setFont(font);
        lineEdit_4 = new QLineEdit(Connect_setting);
        lineEdit_4->setObjectName(QStringLiteral("lineEdit_4"));
        lineEdit_4->setGeometry(QRect(110, 120, 160, 20));
        lineEdit_4->setFont(font);
        bg = new QLabel(Connect_setting);
        bg->setObjectName(QStringLiteral("bg"));
        bg->setGeometry(QRect(0, 0, 300, 210));
        labelT = new QLabel(Connect_setting);
        labelT->setObjectName(QStringLiteral("labelT"));
        labelT->setGeometry(QRect(50, 160, 80, 30));
        labelF = new QLabel(Connect_setting);
        labelF->setObjectName(QStringLiteral("labelF"));
        labelF->setGeometry(QRect(170, 160, 80, 30));
        bg->raise();
        ip1->raise();
        port1->raise();
        lineEdit->raise();
        lineEdit_2->raise();
        ip2->raise();
        port2->raise();
        lineEdit_3->raise();
        lineEdit_4->raise();
        labelT->raise();
        labelF->raise();
        connect->raise();
        cancel->raise();

        retranslateUi(Connect_setting);

        QMetaObject::connectSlotsByName(Connect_setting);
    } // setupUi

    void retranslateUi(QDialog *Connect_setting)
    {
        Connect_setting->setWindowTitle(QApplication::translate("Connect_setting", "Dialog", 0));
        ip1->setText(QApplication::translate("Connect_setting", "\346\234\254\345\234\260IP", 0));
        port1->setText(QApplication::translate("Connect_setting", "\346\234\254\345\234\260\347\253\257\345\217\243", 0));
        lineEdit->setText(QString());
        lineEdit_2->setText(QString());
        connect->setText(QString());
        cancel->setText(QString());
        ip2->setText(QApplication::translate("Connect_setting", "\350\274\270\345\205\245IP", 0));
        port2->setText(QApplication::translate("Connect_setting", "\350\274\270\345\205\245\347\253\257\345\217\243", 0));
        lineEdit_3->setText(QApplication::translate("Connect_setting", "127.0.0.1", 0));
        lineEdit_4->setText(QString());
        bg->setText(QString());
        labelT->setText(QString());
        labelF->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class Connect_setting: public Ui_Connect_setting {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_CONNECT_SETTING_H
