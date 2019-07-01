#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include <QFile>
#include <QDebug>
#include <QMessageBox>

#include "dialog.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    txt = "";
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionFind_triggered()
{
    Dialog dia(this);
    if (dia.exec() == QDialog::Accepted)
    {
        QString st = dia.text();
        QString txt = ui->textEdit->toPlainText();
        int cnt=0;
        for (int i=0; i+st.length()<=txt.length(); i++)
        {
            bool ok=1;
            for (int j=0; j<st.length(); j++)
                if (txt[i+j]!=st[j])
                {
                    ok = 0;
                    break;
                }
            if (ok)
                cnt++;
        }
        QMessageBox::warning(this, "warning", QString::number(cnt));
    }
}

void MainWindow::on_actionExit_triggered()
{
    qApp->exit();
}

void MainWindow::on_actionOpen_triggered()
{
        QFileDialog dia(this);
        if (dia.exec() == QDialog::Accepted)
        {
            QString path = dia.selectedFiles()[0];
            QFile file(path);
            if (!file.open(QIODevice::ReadOnly))
                        return;
            qDebug() << path;
            QTextStream in(&file);
            path = path.right(5);
            in.setCodec("ANSI");
            txt = in.readAll();
            ui->textEdit->append(txt);
            ui->textEdit->show();
        }
}
