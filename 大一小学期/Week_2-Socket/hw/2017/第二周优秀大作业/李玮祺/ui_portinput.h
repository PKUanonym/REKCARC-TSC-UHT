/********************************************************************************
** Form generated from reading UI file 'portinput.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_PORTINPUT_H
#define UI_PORTINPUT_H

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

class Ui_PortInput
{
public:
    QPushButton *cancel;
    QLineEdit *lineEdit_4;
    QLabel *labelF;
    QLabel *bg;
    QPushButton *connect;
    QLabel *labelT;
    QLabel *port2;

    void setupUi(QDialog *PortInput)
    {
        if (PortInput->objectName().isEmpty())
            PortInput->setObjectName(QStringLiteral("PortInput"));
        PortInput->resize(300, 210);
        cancel = new QPushButton(PortInput);
        cancel->setObjectName(QStringLiteral("cancel"));
        cancel->setGeometry(QRect(170, 130, 80, 30));
        QFont font;
        font.setPointSize(14);
        cancel->setFont(font);
        lineEdit_4 = new QLineEdit(PortInput);
        lineEdit_4->setObjectName(QStringLiteral("lineEdit_4"));
        lineEdit_4->setGeometry(QRect(110, 50, 160, 20));
        lineEdit_4->setFont(font);
        labelF = new QLabel(PortInput);
        labelF->setObjectName(QStringLiteral("labelF"));
        labelF->setGeometry(QRect(170, 130, 80, 30));
        bg = new QLabel(PortInput);
        bg->setObjectName(QStringLiteral("bg"));
        bg->setGeometry(QRect(0, 0, 300, 210));
        connect = new QPushButton(PortInput);
        connect->setObjectName(QStringLiteral("connect"));
        connect->setGeometry(QRect(50, 130, 80, 30));
        connect->setFont(font);
        labelT = new QLabel(PortInput);
        labelT->setObjectName(QStringLiteral("labelT"));
        labelT->setGeometry(QRect(50, 130, 80, 30));
        port2 = new QLabel(PortInput);
        port2->setObjectName(QStringLiteral("port2"));
        port2->setGeometry(QRect(20, 50, 80, 20));
        port2->setFont(font);
        bg->raise();
        labelT->raise();
        labelF->raise();
        lineEdit_4->raise();
        port2->raise();
        cancel->raise();
        connect->raise();

        retranslateUi(PortInput);

        QMetaObject::connectSlotsByName(PortInput);
    } // setupUi

    void retranslateUi(QDialog *PortInput)
    {
        PortInput->setWindowTitle(QApplication::translate("PortInput", "Dialog", 0));
        cancel->setText(QString());
        lineEdit_4->setText(QString());
        labelF->setText(QString());
        bg->setText(QString());
        connect->setText(QString());
        labelT->setText(QString());
        port2->setText(QApplication::translate("PortInput", "\350\274\270\345\205\245\347\253\257\345\217\243", 0));
    } // retranslateUi

};

namespace Ui {
    class PortInput: public Ui_PortInput {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_PORTINPUT_H
