#-------------------------------------------------
#
# Project created by QtCreator 2017-09-05T19:37:20
#
#-------------------------------------------------

QT       += core gui network multimedia

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = chess
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
PRECOMPILED_HEADER = stable.h
# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG+=precompile_header C++11

SOURCES += \
        main.cpp \
        mainwindow.cpp \
    gifplayer.cpp \
    init.cpp \
    connect_setting.cpp \
    music.cpp \
    network.cpp \
    playchess.cpp \
    portinput.cpp

HEADERS += \
        mainwindow.h \
    stable.h \
    connect_setting.h \
    portinput.h

FORMS += \
        mainwindow.ui \
    connect_setting.ui \
    portinput.ui
