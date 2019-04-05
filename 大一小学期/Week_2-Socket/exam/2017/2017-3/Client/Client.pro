#-------------------------------------------------
#
# Project created by QtCreator 2017-09-11T10:29:59
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Client
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    sender.cpp

HEADERS  += mainwindow.h \
    sender.h

FORMS    += mainwindow.ui
