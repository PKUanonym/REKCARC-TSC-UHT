#ifndef INPUTDIALOG_H
#define INPUTDIALOG_H

#include <QDialog>
#include <QMessageBox>
#include <QFileDialog>
#include <QTextStream>
#include <QDebug>

namespace Ui {
class InputDialog;
}

class InputDialog : public QDialog
{
    Q_OBJECT

public:
    explicit InputDialog(QWidget *parent = nullptr, const QString &title = "新建");
    int x, y, posX[7], posY[7];//0-3输入，4输出，5清洗输入，6清洗输出
    bool isClean;
    QFile file;
    void accept();
    ~InputDialog();

private slots:
    void on_pushButton_clicked();

    void on_cBtn_stateChanged(int arg1);

private:
    Ui::InputDialog *ui;
};

#endif // INPUTDIALOG_H
