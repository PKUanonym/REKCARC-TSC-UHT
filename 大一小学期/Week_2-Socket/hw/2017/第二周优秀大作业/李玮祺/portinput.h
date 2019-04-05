#ifndef PORTINPUT_H
#define PORTINPUT_H

#include <QDialog>

namespace Ui {
class PortInput;
}

class PortInput : public QDialog
{
    Q_OBJECT

public:
    explicit PortInput(QWidget *parent = 0);
    ~PortInput();
    int getPort();
    bool getStatue();

private slots:
    void on_connect_clicked();
    void on_cancel_clicked();

private:
    Ui::PortInput *ui;
    int Port;
    bool statue;
};

#endif // PORTINPUT_H
