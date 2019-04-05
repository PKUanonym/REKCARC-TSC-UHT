#-------------------------------------------------
#
# Project created by QtCreator 2016-08-25T16:54:32
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = lzl_calendar
TEMPLATE = app

TRANSLATIONS += tr_chinese.ts

SOURCES += main.cpp\
        mainwindow.cpp \
    calendar.cpp \
    event.cpp \
    event_data.cpp \
    mybuttongroup.cpp

HEADERS  += mainwindow.h \
    calendar.h \
    event.h \
    event_data.h \
    mybuttongroup.h

FORMS    += mainwindow.ui

RESOURCES += \
    resource.qrc
