#-------------------------------------------------
#
# Project created by QtCreator 2015-08-29T12:57:50
#
#-------------------------------------------------

QT       += core gui
QT += network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = chatserver
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    creat.cpp

HEADERS  += mainwindow.h \
    creat.h

FORMS    += mainwindow.ui \
    creat.ui

RESOURCES += \
    res.qrc
