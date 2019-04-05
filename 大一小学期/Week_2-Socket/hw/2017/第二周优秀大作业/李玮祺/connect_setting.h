#ifndef CONNECT_SETTING_H
#define CONNECT_SETTING_H

#include <QDialog>
#include <QString>

namespace Ui {
class Connect_setting;
}

class Connect_setting : public QDialog
{
    Q_OBJECT

public:
    explicit Connect_setting(QWidget *parent = 0, QString localip = "", int localport = 0);
    ~Connect_setting();
    QString getIp();
    int getPort();
    bool getStatue();

private slots:
    void on_connect_clicked();
    void on_cancel_clicked();

private:
    Ui::Connect_setting *ui;
    QString IP;
    int Port;
    bool statue;
};

#endif // CONNECT_SETTING_H
