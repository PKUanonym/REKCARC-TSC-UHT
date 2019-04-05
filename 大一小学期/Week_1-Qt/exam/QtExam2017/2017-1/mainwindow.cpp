#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include <QDebug>
#include <QFile>
#include <QTextStream>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_action_Open_triggered()
{
    QFileDialog*fileDialog=new QFileDialog(this);
    fileDialog->setWindowTitle(tr("Open Text"));
    fileDialog->setDirectory("../Input/Problem1");
    if(fileDialog->exec() == QDialog::Accepted) {
        QString path = fileDialog->selectedFiles()[0];
        qDebug()<<path;
        QFile*file=new QFile(path);
        if(file->open(QFile::ReadOnly))
        {
            QTextStream in(file);
            in.setCodec("UTF-8");
            ui->textBrowser->setText(in.readAll());
        }
    }
}

void MainWindow::on_action_Exit_triggered()
{
    this->close();
}

void MainWindow::on_action_Close_triggered()
{
    ui->textBrowser->close();
}
