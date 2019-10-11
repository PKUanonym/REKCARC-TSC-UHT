#include "inputdialog.h"
#include "ui_inputdialog.h"

InputDialog::InputDialog(QWidget *parent, const QString &title) :
    QDialog(parent),
    ui(new Ui::InputDialog)
{
    ui->setupUi(this);

    Qt::WindowFlags flags = Qt::Dialog;
    flags |= Qt::WindowCloseButtonHint;
    setWindowFlags(flags);
    //去掉右上角的?

    this->setWindowTitle(title);
}

InputDialog::~InputDialog()
{
    delete ui;
}

void InputDialog::accept() {
    x = ui->x->value(); y = ui->y->value();
    posX[0] = ui->inX_1->value(); posY[0] = ui->inY_1->value();
    posX[1] = ui->inX_2->value(); posY[1] = ui->inY_2->value();
    posX[2] = ui->inX_3->value(); posY[2] = ui->inY_3->value();
    posX[3] = ui->inX_4->value(); posY[3] = ui->inY_4->value();
    posX[4] = ui->outX->value(); posY[4] = ui->outY->value();
    posX[5] = ui->cinX->value(); posY[5] = ui->cinY->value();
    posX[6] = ui->coutX->value(); posY[6] = ui->coutY->value();
    isClean = ui->cBtn->isChecked();
    if ((x <= 3) && (y <= 3)) {
        QMessageBox::warning(this,tr("warning1"),tr("行数和列数不能同时小于等于3"));
    }
    else {
        bool flag = true;
        for (int i = 0; i < 5; ++i) {
            QString now = (i < 4) ? QString("输入%1").arg(i+1) : ((i == 4) ? tr("输出") : QString("清洗"));
            if (i == 5)
                now.append(QString("入口"));
            else if (i == 6)
                now.append(QString("出口"));
            //输入为空
            if (posX[i]==0 && posY[i]==0 && i != 4) {
                continue;
            }
            if (posX[i]>x || posX[i]<1 || posY[i]>y || posY[i]<1){
                QMessageBox::warning(this,tr("warning2"),QString("%1超出范围").arg(now));
                flag = false;
                break;
            }
            if (posX[i]==1 || posX[i]==x || posY[i]==1 || posY[i]==y) {
                for (int j = 0; j < i; ++j) {
                    if (posX[i]==posX[j] && posY[i]==posY[j]) {
                        QString next = QString("输入%1").arg(j);
                        QMessageBox::warning(this,tr("warning4"),QString("%1与%2重合").arg(now).arg(next));
                        flag = false;
                        break;
                    }
                }
                if (flag == false)
                    break;
                if (isClean && flag) {
                    if (posX[i]==posX[5] && posY[i]==posY[5]) {
                        QMessageBox::warning(this,tr("warning5"),QString("%1与清洗入口重合").arg(now));
                        flag = false;
                        break;
                    }
                    else if (posX[i]==posX[6] && posY[i]==posY[6]) {
                        QMessageBox::warning(this,tr("warning5"),QString("%1与清洗出口重合").arg(now));
                        flag = false;
                        break;
                    }
                }
            }
            else {
                QMessageBox::warning(this,tr("warning3"),QString("%1未处于边界上").arg(now));
                flag = false;
                break;
            }
        }
        if (flag) {
            QDialog::accept();
        }
    }
}

void InputDialog::on_pushButton_clicked()
{
    QString fileName = QFileDialog::getOpenFileName(
                this, tr("选择输入文件"),
                "./", tr("text (*.txt);;All files (*.*)"));

    if(fileName.isNull()) {
        return;//点的是取消
    }
    else {
        file.setFileName(fileName);
        if (!file.open(QFile::ReadOnly|QFile::Text)) {
            QMessageBox::warning(this,tr("错误"),QString("读取错误：%1").arg(file.errorString()));
        }
        else {
            //in = new QTextStream(&file);
            ui->lineEdit->setText(fileName);
            //qDebug() << in->readAll();
        }
    }
}

void InputDialog::on_cBtn_stateChanged(int)
{
    isClean = ui->cBtn->isChecked();
    ui->cinX->setEnabled(isClean);
    ui->cinY->setEnabled(isClean);
    ui->coutX->setEnabled(isClean);
    ui->coutY->setEnabled(isClean);
}
