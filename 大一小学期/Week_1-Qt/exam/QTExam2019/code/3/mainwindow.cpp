#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "ui_dialog.h"

#include <QFileDialog>
#include <QMessageBox>
#include <QTextStream>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    file.setFileName("");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionNew_triggered()
{
    file.setFileName("");
    ui->textEdit->setText("");
}

void MainWindow::on_actionOpen_triggered()
{
    QString s = QFileDialog::getOpenFileName();
    file.setFileName(s);
    file.open(QIODevice::ReadOnly);
    QTextStream in(&file);
    in.setCodec("GB2312");
    //ui->textEdit->append(in.readAll());
    ui->textEdit->setText(in.readAll());
    ui->textEdit->moveCursor(QTextCursor::Start);
    file.close();
}

void MainWindow::on_actionSave_triggered()
{
    if (file.fileName() == "") {
        QString s = QFileDialog::getSaveFileName();
        if (s == "")
            return;
        file.setFileName(s);
    }
    file.open(QIODevice::WriteOnly);
    QTextStream textStream(&file);
    QString str = ui->textEdit->toPlainText();
    textStream << str;
    file.close();
}

void MainWindow::on_actionExit_triggered()
{
    close();
}
