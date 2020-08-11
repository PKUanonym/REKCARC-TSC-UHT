#ifndef PROMOTEDIALOG_H
#define PROMOTEDIALOG_H
#include "chess.h"

#include <QDialog>

namespace Ui {
class PromoteDialog;
}

class PromoteDialog : public QDialog
{
    Q_OBJECT

public:
    explicit PromoteDialog(QWidget *parent = nullptr);
    ~PromoteDialog();
    Piece getName();

private:
    Ui::PromoteDialog *ui;
};

#endif // PROMOTEDIALOG_H
