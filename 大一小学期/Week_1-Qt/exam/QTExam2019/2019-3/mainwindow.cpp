#include "mainwindow.h"
#include "ui_mainwindow.h"

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

void MainWindow::on_actionNew_triggered()
{
    ui->textEdit->clear();
    return;
}

void MainWindow::on_actionOpen_triggered()
{
    QString path = QFileDialog::getOpenFileName(this,
        tr("Open File"), "./", tr("All Files (*)"));
    if (path != "")
    {
        fileName = path;
        ui->textEdit->clear();
        QFile file(fileName);
        if (!file.open(QIODevice::ReadOnly))
        {
            qDebug() << "Failed to open selected file!";
            return;
        }
        QTextStream in(&file);
        in.setCodec("UTF-8");
        QString text = in.readAll();
        qDebug() << text;
        ui->textEdit->append(text);
        file.close();
    }
    return;
}

void MainWindow::on_actionSave_triggered()
{
    if (fileName == "")
    {
        QString path = QFileDialog::getSaveFileName(this,
            tr("Save File"), "./", tr("All Files (*)"));
        if (path == "")
            return;
        fileName = path;
    }
    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly))
    {
        qDebug() << "Failed to write selected file!";
        return;
    }
    QTextStream out(&file);
    out.setCodec("UTF-8");
    QString text = ui->textEdit->toPlainText();
    qDebug() << text;
    out << text;
    file.close();
}

void MainWindow::on_actionExit_triggered()
{
    return qApp->exit();
}
