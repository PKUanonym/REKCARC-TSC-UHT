#-------------------------------------------------
#
# Project created by QtCreator 2017-08-28T09:38:22
#
#-------------------------------------------------

QT       += core gui
QT       += multimedia

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Suduko_Game_1
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += main.cpp\
        mainwindow.cpp \
    gamewindow.cpp \
    sudoku.cpp \
    gamewindow3.cpp \
    grid.cpp

HEADERS  += mainwindow.h \
    gamewindow.h \
    sudoku.h \
    gamewindow3.h \
    grid.h \
    operation.h

FORMS    += mainwindow.ui \
    gamewindow.ui \
    gamewindow3.ui

RESOURCES += \
    resource.qrc
