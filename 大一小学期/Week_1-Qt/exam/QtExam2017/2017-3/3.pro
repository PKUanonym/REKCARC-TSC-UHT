#-------------------------------------------------
#
# Project created by QtCreator 2017-08-30T09:15:32
#
#-------------------------------------------------

QT       += core gui
QT       += multimedia
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = 3
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    config.cpp \
    solver.cpp

HEADERS  += mainwindow.h \
    config.h \
    solver.h

FORMS    += mainwindow.ui

RESOURCES += \
    res.qrc
