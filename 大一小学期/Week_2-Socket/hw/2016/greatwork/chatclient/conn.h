#ifndef CONN_H
#define CONN_H

#include <QDialog>
#include <QtWidgets>
namespace Ui {
class conn;
}

class conn : public QDialog
{
    Q_OBJECT

public:
    explicit conn(QWidget *parent = 0);
    ~conn();
public slots:
    void add(QString);
private slots:
    void on_pushButton_del_clicked();

    void on_pushButton_ok_clicked();
signals:
    void setip(QString);
private:
    Ui::conn *ui;
    QSignalMapper* mapper;
};

#endif // CONN_H
