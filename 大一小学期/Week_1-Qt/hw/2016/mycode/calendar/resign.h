#ifndef RESIGN_H
#define RESIGN_H

#include <QDialog>

namespace Ui {
class resign;
}

class resign : public QDialog
{
    Q_OBJECT

public:
    explicit resign(QWidget *parent = 0);
    ~resign();
signals:
    void res(QString,QString);
private slots:
    void on_buttonBox_accepted();

private:
    Ui::resign *ui;
};

#endif // RESIGN_H
