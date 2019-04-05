#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDrag>
#include <QTextEdit>
#include <QDragEnterEvent>
#include <QMimeData>
#include <QList>
#include <QDebug>
#include <QDir>
#include <QFileDialog>
#include <QDomDocument>
#include <QTranslator>
//#include <windows.h>
#include "calendar.h"
#include "login.h"
#include "resign.h"
#include "addschbatch.h"
#include "dateinfo.h"
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    QTranslator *abc;
    QVector<QString> m_user,m_pwd;
signals:
    void changed(QDate,dateinfo);
    //void SwitchLanguageIntoSimplifiedEnglish();
    //void SwitchLanguageIntoSimplifiedChinese();
public slots:
    void on_actionAdd_schedule_triggered();
    void batchadd(QDate,schedule,int,int,int);
    void set_low();
    void set_high();
    void set_no();
    void choose_file_1();//read
    void choose_file_2();//write
    void new_u(QString usr,QString pwd);
    void chk_u(QString usr,QString pwd);
protected:
    bool eventFilter(QObject *obj, QEvent *event);
    void mousePressEvent(QMouseEvent *event);
private slots:
    void on_actionEnglish_triggered();
    void changeEvent(QEvent* e);
    void on_actionChinese_triggered();

    void on_actionResign_triggered();

    void on_actionLogin_triggered();

    void on_actionYes_triggered();

    void on_actionNo_triggered();

private:
    void in_port(QString urls);
    void ex_port(QString urls);
    Ui::MainWindow *ui;
    int window_long,flag;
};

#endif // MAINWINDOW_H
