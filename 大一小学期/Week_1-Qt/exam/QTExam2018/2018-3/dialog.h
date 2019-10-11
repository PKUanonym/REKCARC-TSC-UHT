#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QSignalMapper>
#include <QMediaPlayer>
namespace Ui {
class Dialog;
}

class Dialog : public QDialog
{
    Q_OBJECT

public:
    explicit Dialog(QWidget *parent = 0);
    ~Dialog();
protected:
    void keyPressEvent(QKeyEvent *e);
    void keyReleaseEvent(QKeyEvent *e);

private slots:
    void on_pushButton_8_clicked();
    void tt(int x);

private:
    Ui::Dialog *ui;
    QSignalMapper* mapper;
    QMediaPlayer* player;

};

#endif // DIALOG_H
