#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}



void MainWindow::on_actionopen_triggered()
{
    QString path = QFileDialog::getOpenFileName(this, "Open", ".", "JSON(*.json)");
        if (!path.isEmpty()) {
            QFile file(path);
            if (file.open(QIODevice::ReadOnly)) {
                QByteArray allData = file.readAll();
                file.close();
                QJsonParseError json_error;
                QJsonDocument jsonDoc(QJsonDocument::fromJson(allData, &json_error));
                if (json_error.error != QJsonParseError::NoError) {
                    QMessageBox::warning(this, "Error", "Json Error!");
                    return;
                }
                QJsonObject job = jsonDoc.object();
                QJsonArray status_array = job["status"].toArray();
                QJsonArray x_array = job["x"].toArray();
                QJsonArray y_array = job["y"].toArray();
                on_actionclean_triggered();
                for(auto st: status_array){
                    status.push_back(st.toBool());
                    square.push_back(new QFrame(this));
                }
                int index = 0;
                for(auto x: x_array){
                    int y = y_array[index].toInt();
                    square[index]->setStyleSheet("background-color: blue; border: 5px solid black");
                    square[index]->setGeometry(0,0,60,60);
                    square[index]->move(x.toInt(), y);
                    square[index]->show();
                    index += 1;
                }
                for(int i = 0; i < status.length(); i++){
                    if(status[i]){
                        square[i]->setStyleSheet("background-color: green; border: 5px solid red;");
                    }
                }
            }
        }
}

void MainWindow::on_actionsave_triggered()
{
    QString path = QFileDialog::getSaveFileName(this, "Save", ".", "JSON(*.json)");
        if (!path.isEmpty()) {
            QFile file(path);
            if (file.open(QIODevice::WriteOnly)) {
                QJsonObject job;
                QJsonArray status_array, x_array, y_array;
                for(auto st: status){
                    status_array.append(st);
                }
                for(auto sq: square){
                    x_array.append(sq->x());
                    y_array.append(sq->y());
                }

                job.insert("status", status_array);
                job.insert("x", x_array);
                job.insert("y", y_array);

                QJsonDocument jd;
                jd.setObject(job);
                file.write(jd.toJson());
                file.close();
            }
        }
}



void MainWindow::on_actionclean_triggered()
{
    for(auto sq: square){
        delete sq;
    }
    square.clear();
    status.clear();
}



void MainWindow::on_actionquit_triggered()
{
    exit(1);
}
