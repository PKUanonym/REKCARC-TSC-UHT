#ifndef LOGIN_H
#define LOGIN_H

#include <QDialog>

namespace Ui {
class Login;
}

class Login : public QDialog
{
    Q_OBJECT

public:
    explicit Login(QWidget *parent = 0);
    ~Login();
    Ui::Login *ui;
signals:
    void loi(QString,QString);
private slots:
    void on_buttonBox_accepted();

};

#endif // LOGIN_H
