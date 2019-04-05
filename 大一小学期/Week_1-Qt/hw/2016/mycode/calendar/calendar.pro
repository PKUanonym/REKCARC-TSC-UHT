#-------------------------------------------------
#
# Project created by QtCreator 2016-08-24T13:39:00
#
#-------------------------------------------------

QT       += core gui
QT       += xml
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = calendar
TEMPLATE = app
CONFIG += x11 thread warn_off
TRANSLATIONS+= cn.ts en.ts
CONFIG += static
QMAKE_LFLAGS += -static

LIBS += -lQt5Widgets
LIBS += -lQt5Sql
LIBS += -lQt5Gui
LIBS += -lQt5Core
SOURCES += main.cpp\
        mainwindow.cpp \
    schedule.cpp \
    calendar.cpp \
    dateinfo.cpp \
    celledit.cpp \
    addschbatch.cpp \
    func.cpp \
    croundprocessebar.cpp \
    login.cpp \
    resign.cpp

HEADERS  += mainwindow.h \
    schedule.h \
    calendar.h \
    dateinfo.h \
    celledit.h \
    addschbatch.h \
    func.h \
    croundprocessebar.h \
    login.h \
    resign.h

FORMS    += mainwindow.ui \
    celledit.ui \
    addschbatch.ui \
    func.ui \
    login.ui \
    resign.ui
