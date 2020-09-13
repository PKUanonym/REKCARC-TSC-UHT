#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QPoint>
#include <QMouseEvent>
#include <QKeyEvent>
#include <QDebug>
#include <QFrame>
#include <QFileDialog>
#include <QSlider>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QJsonValue>
#include <QMessageBox>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

private:
    QFrame* selectedSquare;
    bool pressed;
    QPoint squarePos;
    QList<QFrame*> square;
    QList<bool> status;
    int selected = -1;
    void changeStyle(int index){
        if(status[index]){
            square[index]->setStyleSheet("background-color: lightgreen; border: 2px solid red; ");
            square[index]->raise();
        }
        else{
            square[index]->setStyleSheet("background-color: lightblue; border: 2px solid black ");
        }
    }

    bool detectClick(int x, int y, QFrame* frame){
        int dx = x - frame->x();
        int dy = y - frame->y();

        if(dx >= 0 && dx <= 60 && dy >= 0 && dy <= 60){
            return true;
        }
        else return false;
    }

    void createSquare(int x, int y){
        int lefttopx = x - 30;
        int lefttopy = y - 30;
        QFrame* new_square = new QLabel(this);
        new_square->setGeometry(lefttopx, lefttopy, 60, 60);
        new_square->setStyleSheet("background-color: lightblue; border: 2px solid black");
        square.push_front(new_square);
        status.push_front(false);
        new_square->show();
    }

    void clearStatus(){
        for(auto st: status){
            st = false;
        }
        for(auto sq: square){
            sq->setStyleSheet("background-color: lightblue; border: 2px solid black");
        }
    }

protected:
    void mouseDoubleClickEvent(QMouseEvent* event) override{
        QPointF point = event->localPos();
        int x = point.toPoint().x();
        int y = point.toPoint().y();
        createSquare(x, y);
    }

    void mouseReleaseEvent(QMouseEvent* event) override{
        Q_UNUSED(event);
        pressed = false;
        m_draging = false;
        QWidget::mouseReleaseEvent(event);
    }

    void mouseMoveEvent(QMouseEvent* event) override {
        if(pressed){
            if(event->buttons() & Qt::LeftButton)
               {
                   //offset 偏移位置
                   QPoint offset = event->globalPos() - m_startPostion;
                   selectedSquare->move(offset + squarePos);
               }

        }
    }

    void mousePressEvent(QMouseEvent* event) override{
        m_draging = true;
        if(event->buttons() & Qt::LeftButton)//只响应鼠标左键
        {
           m_startPostion = event->globalPos();
           m_framPostion = frameGeometry().topLeft();
        }

        if(event->button() == Qt::LeftButton){
            QPointF point = event->localPos();
            int x = point.toPoint().x();
            int y = point.toPoint().y();
            int index = 0;
            for(auto sq: square){
                if(detectClick(x, y, sq)){
                    selectedSquare = sq;
                    pressed = true;
                    squarePos = selectedSquare->pos();
                    clearStatus();
                    status[index] = true;
                    changeStyle(index);
                    QFrame* now = square[index];
                    square.removeOne(now);
                    square.push_front(now);
                    break;
                }
                index += 1;
            }
        }

        else if(event->button() == Qt::RightButton){
            clearStatus();
        }
    }

    void keyPressEvent(QKeyEvent* event) override{
        int index = -1;
        for(auto st: status){
            index += 1;
            if(st) break;
        }
        if(index == -1) return;
        QFrame* selected = square[index];
        int x = selected->x();
        int y = selected->y();
        switch (event->key()) {
        case Qt::Key_A:
        case Qt::Key_Left:
            selected->move(x-30, y);
            break;
        case Qt::Key_D:
        case Qt::Key_Right:
            selected->move(x+30, y);
            break;
        case Qt::Key_W:
        case Qt::Key_Up:
            selected->move(x, y-30);
            break;
        case Qt::Key_S:
        case Qt::Key_Down:
            selected->move(x, y+30);
            break;
        }
    }

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_actionopen_triggered();

    void on_actionsave_triggered();

    void on_actionclean_triggered();

    void on_actionquit_triggered();

private:
    Ui::MainWindow *ui;
    bool m_draging;//是否拖动
    QPoint m_startPostion;//拖动前鼠标位置
    QPoint m_framPostion;//窗体的原始位置
};
#endif // MAINWINDOW_H
