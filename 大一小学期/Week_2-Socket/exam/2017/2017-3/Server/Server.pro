#-------------------------------------------------
#
# Project created by QtCreator 2017-09-11T10:29:35
#
#-------------------------------------------------

QT       += core gui network
CONFIG += c++11

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Client
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    download.cpp

HEADERS  += mainwindow.h \
    download.h

FORMS    += mainwindow.ui
