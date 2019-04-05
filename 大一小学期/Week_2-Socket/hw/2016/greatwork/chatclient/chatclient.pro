#-------------------------------------------------
#
# Project created by QtCreator 2015-08-29T13:48:44
#
#-------------------------------------------------

QT       += core gui widgets
QT       += network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
XDG_CURRENT_DESKTOP=GNOME
TARGET = chatclient
TEMPLATE = app


SOURCES += main.cpp\
        clientwindow.cpp \
    conn.cpp

HEADERS  += clientwindow.h \
    conn.h

FORMS    += clientwindow.ui \
    conn.ui

RESOURCES += \
    res.qrc
