#include "mainwindow.h"
#include "inputdialog.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->setWindowIcon(QIcon(":img/mainwindow.png"));
    this->setWindowTitle("数字微流控生物芯片模拟界面");
    btn[0]=ui->newBtn;
    btn[1]=ui->resetBtn;
    btn[2]=ui->startBtn;
    btn[3]=ui->pauseBtn;
    btn[4]=ui->nextBtn;
    btn[5]=ui->prevBtn;
    cbtn=ui->cBtn;
    lab=ui->runLab;
    connect(btn[3], SIGNAL(clicked()),this,SLOT(switchState()));
    connect(btn[2], SIGNAL(clicked()),this,SLOT(switchState()));
    connect(&tMove, SIGNAL(timeout()),this,SLOT(wash()));
    connect(&tWash, SIGNAL(timeout()),this,SLOT(washFinish()));
    switchState();
    for (int i = 1; i < 6; ++i)
        btn[i]->setEnabled(false);
    cbtn->setEnabled(false);
    this->resize(1000,650);
    memset(info, 0, sizeof(info));
    memset(nClean, 0, sizeof(nClean));
    memset(cleaning, 0, sizeof(cleaning));
    memset(reachable, 0, sizeof(reachable));
    //for debug
    info[3][3]=3;
    isClean = true;
    nClean[2][2]=true;
    MyPoint p1(1,1,0);
    list.append(p1);
    p1.x = 1; p1.y = 2;
    p1.sizeX = 3; p1.sizeY = 2;
    list.append(p1);
    reachable[4][1]=true;
    reachable[4][2]=true;
    reachable[4][3]=true;
    reachable[4][4]=true;
    reachable[4][5]=true;
    reachable[4][6]=true;
    reachable[3][6]=true;
    reachable[3][5]=true;
    reachable[1][6]=true;
    reachable[1][5]=true;
    reachable[2][6]=true;
    //debug complete
    p = new Picture(info, nClean, reachable, cleanable, this);
    connect(p,SIGNAL(changePoint(int,int)),this,SLOT(change(int,int)));
    p->setList(&list);
    p->move(350,25);
    p->resize(600,600);
    tMove.setInterval(750);
    tWash.setInterval(750);
    for (int i = 0; i < 7; ++i) {
        a[i] = new QMediaPlayer(this);
        a[i]->setVolume(50);
    }
    a[0]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/1.mp3"));
    a[1]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/2.mp3"));
    a[2]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/3.mp3"));
    a[3]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/4.mp3"));
    a[4]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/5.mp3"));
    a[5]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/6.mp3"));
    a[6]->setMedia(QUrl::fromLocalFile("C:/Qt/Chip/7.mp3"));
    for (int i = 0; i < 7; ++i) {
        a[i]->play();
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

int MainWindow::search(int x, int y)
{
    for (int i = 0; i < hList[time].size(); ++i)
        if ((hList[time][i].x <= x) && (x < hList[time][i].x + hList[time][i].sizeX) && (hList[time][i].y <= y) && (y < hList[time][i].y + hList[time][i].sizeY))
            return i;
    return -1;
}

bool MainWindow::newInit()
{
    if (!file.open(QFile::ReadOnly|QFile::Text)) {
        QMessageBox::warning(this,tr("error"),QString("读取错误：%1").arg(file.errorString()));
        return false;
    }
    for (int i = 0; i < 200; ++i) {
        hActs[i].clear();
        hList[i].clear();
    }
    ID = 0; endTime = 0;
    qDebug() << file.fileName();
    QTextStream * in = new QTextStream(&file);
    for (int i0 = 1; !in->atEnd(); ++i0) {
        QString line = in->readLine();
        QStringList lList = line.split(' ');
        QStringList ll = lList[1].split(',');
        ll[ll.size()-1].remove(ll[ll.size()-1].size()-1,1);
        int n = ll.size(), t = ll[0].toInt(), x1 = ll[1].toInt(), y1 = ll[2].toInt();
        Action it(t, x1, y1, i0);
        if (lList[0] == "Input") {
            bool flag = false;
            for (int j = 0; j < 4; ++j) {
                if (x1 == posX[j] && y1 == posY[j]) {
                    flag = true; break;
                }
            }
            if (flag) {
                hActs[t].append(it);
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1行Input操作附近无输入端口").arg(i0));
                return false;
            }
        }
        else if (lList[0] == "Move") {
            it.a = Move;
            it.nx = ll[3].toInt();
            it.ny = ll[4].toInt();
            hActs[t].append(it);
        }
        else if (lList[0] == "Split") {
            it.a = Split1;
            it.x = ll[3].toInt();
            it.y = ll[4].toInt();
            it.nx = ll[5].toInt();
            it.ny = ll[6].toInt();
            if (it.x > it.nx || it.y > it.ny) {
                int tmp = it.x; it.x = it.nx; it.nx = tmp;
                tmp = it.y; it.y = it.ny; it.ny = tmp;
            }
            hActs[t].append(it);
            it.a = Split2;
            hActs[t+1].append(it);
        }
        else if (lList[0] == "Mix") {
            int x2, y2;
            it.a = Move;
            for (int i = 3; i < n; i = i + 2) {
                x2 = ll[i].toInt();
                y2 = ll[i+1].toInt();
                it.t = t;
                it.x = x1; it.y = y1;
                it.nx = x2; it.ny = y2;
                hActs[t].append(it);
                ++t;
                x1 = x2; y1 = y2;
            }
        }
        else if (lList[0] == "Merge") {
            it.a = Merge1;
            it.nx = ll[3].toInt();
            it.ny = ll[4].toInt();
            if (it.x > it.nx || it.y > it.ny) {
                int tmp = it.x; it.x = it.nx; it.nx = tmp;
                tmp = it.y; it.y = it.ny; it.ny = tmp;
            }
            hActs[t].append(it);
            it.a = Merge2;
            hActs[t+1].append(it);

        }
        else if (lList[0] == "Output") {
            if (x1 == posX[4] && y1 == posY[4]) {
                it.a = OutPut;
                hActs[t].append(it);
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1行Output操作附近无输出端口").arg(i0));
                return false;
            }
        }
        else {
            QMessageBox::warning(this,tr("error"),QString("第%1行输入未识别").arg(i0));
            return false;
        }
        if (t > endTime) {
            endTime = t;
        }
    }
    return true;
}

bool MainWindow::runByStep()
{
    hList[time].clear();
    QList<int> (*nIDs)[20] = IDs[time];
    for (int i = 1; i <= x; ++i) {
        for (int j = 1; j <= y; ++j) {
            nIDs[i][j].clear();
        }
    }
    if (time > 0) {
        hList[time].append(hList[time-1]);
        for (int i = 1; i <= x; ++i) {
            for (int j = 1; j <= y; ++j) {
                nIDs[i][j].append(IDs[time-1][i][j]);
            }
        }
    }
    for (int i = 0; i < 20; ++i)
        for (int j = 0; j < 20; ++j)
            cleaning[i][j] = true;
    for (int i = 0; i < hList[time].size(); ++i) {
        for (int dx = -1; dx <= hList[time][i].sizeX; ++dx) {
            for (int dy = -1; dy <= hList[time][i].sizeY; ++dy) {
                cleaning[hList[time][i].x+dx][hList[time][i].y+dy] = false;
            }
        }
    }
    int removingList[100][2], sizeL = 0;
    for (int i = 0; i < 7; ++i)
        a[i]->stop();
    //负责input、move/mix的添加、split和merge1的添加和删除（因为它们不改变约束）、merge2的添加
    //负责记录output、move/mix的删除（移动视为删除再创造）、merge2的删除（merge2视为删除中间态创造新状态）
    for (const Action &act : hActs[time]) {
        int t = act.t, x = act.x, y = act.y, nx = act.nx, ny = act.ny;
        switch (act.a) {
        case Input:{
            if (cleaning[x][y]) {
                hList[time].append(MyPoint(x,y,ID));
                nIDs[x][y].append(ID++);
                if (nIDs[x][y].size() > 1 && cleanable && isClean)
                    QMessageBox::warning(this,tr("warning"),QString("第%1->%2秒位于(%3,%4)的液滴被污染")
                                        .arg(t).arg(t+1).arg(x).arg(y));
                for (int dx = -1; dx <= 1; ++dx) {
                    for (int dy = -1; dy <= 1; ++dy) {
                        cleaning[x+dx][y+dy] = false;
                    }
                }
                a[5]->play();
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1秒Input操作(%2,%3)出现错误：不满足约束（文件第%4行）")
                                     .arg(t).arg(x).arg(y).arg(act.line));
                return false;
            }
            break;
        }
        case OutPut:{
            int index = search(x, y);
            if (index != -1) {
                removingList[sizeL][0] = x;
                removingList[sizeL++][1] = y;
                a[6]->play();
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1秒Output操作(%2,%3)出现错误：不存在液滴（文件第%4行）")
                                     .arg(t).arg(x).arg(y).arg(act.line));
                return false;
            }
            break;
        }
        case Move:{
            int index = search(x, y);
            if (index != -1) {
                for(int i=nx-1;i<=nx+1;++i){
                    for(int j=ny-1;j<=ny+1;++j){
                        if (((i!=x)||(j!=y))&&(search(i,j)!=-1)){
                            QMessageBox::warning(this,tr("error"),QString("第%1秒Move/Mix操作(%2,%3)->(%4,%5)出现错误：不满足约束（文件第%6行）")
                                                 .arg(t).arg(x).arg(y).arg(nx).arg(ny).arg(act.line));
                            return false;
                        }
                        cleaning[i][j] = false;
                    }
                }
                hList[time].append(MyPoint(nx, ny, hList[time][index].ID));
                if (!nIDs[nx][ny].contains(hList[time][index].ID))
                    nIDs[nx][ny].append(hList[time][index].ID);
                if (nIDs[nx][ny].size() > 1 && cleanable && isClean)
                    QMessageBox::warning(this,tr("warning"),QString("第%1->%2秒位于(%3,%4)的液滴被污染")
                                        .arg(t).arg(t+1).arg(nx).arg(ny));
                removingList[sizeL][0] = x;
                removingList[sizeL++][1] = y;
                a[0]->stop();
                a[0]->play();
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1秒Move/Mix操作(%2,%3)->(%4,%5)出现错误：不存在液滴（文件第%6行）")
                                     .arg(t).arg(x).arg(y).arg(nx).arg(ny).arg(act.line));
                return false;
            }
            break;
        }
        case Merge1:{
            int index1 = search(x, y), index2 = search(nx, ny);
            if (index1 != -1 && index2 != -1) {
                int sizeX = nx - x + 1, sizeY = ny - y + 1;
                hList[time].removeAt(index1);
                hList[time].removeAt(search(nx, ny));
                hList[time].append(MyPoint(x,y,ID,sizeX,sizeY));
                nIDs[(x+nx)/2][(y+ny)/2].append(ID++);
                if (nIDs[(x+nx)/2][(y+ny)/2].size() > 1 && cleanable && isClean)
                    QMessageBox::warning(this,tr("warning"),QString("第%1->%2秒位于(%3,%4)的液滴被污染")
                                        .arg(t).arg(t+1).arg((x+nx)/2).arg((y+ny)/2));
                a[1]->play();
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1秒Merge操作(%2,%3)+(%4,%5)出现错误：不存在液滴（文件第%6行）")
                                     .arg(t).arg(x).arg(y).arg(nx).arg(ny).arg(act.line));
                return false;
            }
            break;
        }
        case Merge2:{
            int index = search(x,y);
            hList[time].append(MyPoint((x+nx)/2,(y+ny)/2,hList[time][index].ID));
            removingList[sizeL][0] = x;
            removingList[sizeL++][1] = y;
            a[2]->play();
            break;
        }
        case Split1:{
            int centerX = (x+nx)/2, centerY = (y+ny)/2, index = search(centerX, centerY);
            if (index != -1) {
                //(x,y)是否满足约束
                for(int i=x-1;i<=x+1;++i){
                    for(int j=y-1;j<=y+1;++j){
                        if ((i!=centerX)&&(j!=centerY)&&(search(i,j)!=-1)){
                            QMessageBox::warning(this,tr("error"),QString("第%1秒Split操作(%2,%3)->(%4,%5),(%6,%7)出现错误：不满足约束（文件第%8行）")
                                                 .arg(t).arg(centerX).arg(centerY).arg(x).arg(y).arg(nx).arg(ny).arg(act.line));
                            return false;
                        }
                    }
                }
                //(nx,ny)是否满足约束
                for(int i=nx-1;i<=nx+1;++i){
                    for(int j=ny-1;j<=ny+1;++j){
                        if ((i!=centerX)&&(j!=centerY)&&(search(i,j)!=-1)){
                            QMessageBox::warning(this,tr("error"),QString("第%1秒Split操作(%2,%3)->(%4,%5),(%6,%7)出现错误：不满足约束（文件第%8行）")
                                                 .arg(t).arg(centerX).arg(centerY).arg(x).arg(y).arg(nx).arg(ny).arg(act.line));
                            return false;
                        }
                    }
                }
                hList[time][index].x = x;
                hList[time][index].y = y;
                hList[time][index].sizeX = nx - x + 1;
                hList[time][index].sizeY = ny - y + 1;
                for (int i = x - 1; i <= nx + 1; ++i)
                    for (int j = y - 1; j <= ny + 1; ++j)
                        cleaning[i][j] = false;
                a[3]->play();
            }
            else {
                QMessageBox::warning(this,tr("error"),QString("第%1秒Split操作(%2,%3)出现错误：不存在液滴（文件第%4行）")
                                     .arg(t).arg(centerX).arg(centerY).arg(act.line));
                return false;
            }
            break;
        }
        case Split2:{
            hList[time].removeAt(search(x, y));
            nIDs[x][y].append(ID);
            hList[time].append(MyPoint(x, y, ID++));
            if (nIDs[x][y].size() > 1 && cleanable && isClean)
                QMessageBox::warning(this,tr("warning"),QString("第%1->%2秒位于(%3,%4)的液滴被污染")
                                    .arg(t).arg(t+1).arg(x).arg(y));
            nIDs[nx][ny].append(ID);
            hList[time].append(MyPoint(nx, ny, ID++));
            if (nIDs[nx][ny].size() > 1 && cleanable && isClean)
                QMessageBox::warning(this,tr("warning"),QString("第%1->%2秒位于(%3,%4)的液滴被污染")
                                    .arg(t).arg(t+1).arg(nx).arg(ny));
            a[4]->play();
            break;
        }
        }
    }
    for (int i = 0; i < sizeL; ++i) {
        hList[time].removeAt(search(removingList[i][0], removingList[i][1]));
    }
    setTime(time+1);
    tMove.start();
    return true;
}

void MainWindow::setTime(int t)
{
    time = t;
    QString s = QString("运行时间：%1秒").arg(time);
    lab->setText(s);
    memset(reachable,0,sizeof(reachable));
    if (t <= 0) {
        list.clear();
        p->setList(&list);
        memset(info,0,sizeof(info));
    }
    else {
        p->setList(&hList[t-1]);
        for (int i = 1; i <= x; ++i) {
            for (int j = 1; j <= y; ++j) {
                info[i][j] = IDs[t-1][i][j].size();
            }
        }
    }
    p->repaint();
}

void MainWindow::change(int x, int y)
{
    qDebug() << x << y;
    if (!tMove.isActive() && !tWash.isActive()) {
        QList<MyPoint> &ll = hList[time - 1];
        int index = -1;
        for (int i = 0; i < ll.size(); ++i)
            if ((ll[i].x == x) && (ll[i].y == y) && (ll[i].sizeX == 1) && (ll[i].sizeY == 1)) {
                index = i; break;
            }
        if (index >= 0) {
            ll.removeAt(index);
        }
        else {
            IDs[time - 1][x][y].append(ID);
            ll.append(MyPoint(x, y, ID++));
        }
        repaint();
    }

}

void MainWindow::wash()
{
    tMove.stop();
    tWash.start();
    if (isClean) {
        //bfs，设置reachable，改变IDs，再改变info
        memset(reachable,0,sizeof(reachable));
        for (int i = 0; i < 20; ++i)
            for (int j = 0; j < 20; ++j)
                cleaning[i][j] = true;
        for (const MyPoint &p : hList[time-1]) {
            int x = p.x, y = p.y, sX = p.sizeX, sY = p.sizeY;
            for (int i = x - 1; i <= x + sX; ++i) {
                for (int j = y - 1; j <= y + sY; ++j) {
                    cleaning[i][j] = false;
                }
            }
        }
        for (int i = 0; i < 20; ++i)
            for (int j = 0; j < 20; ++j)
                if (nClean[i][j])
                    cleaning[i][j] = false;
        int q[1000][2], st = 0, ed = 0, cBegin[2] = {posX[5], posY[5]}, cEnd[2] = {posX[6], posY[6]},
                dx[4] = {0,0,1,-1}, dy[4] = {1,-1,0,0};
        if (!cleaning[cBegin[0]][cBegin[1]])
            return;
        q[ed][0] = cBegin[0]; q[ed++][1] = cBegin[1]; reachable[cBegin[0]][cBegin[1]] = true;
        while (st < ed) {
            int now[2] = {q[st][0], q[st++][1]}, next[2];
            for (int i = 0; i < 4; ++i) {
                next[0] = now[0] + dx[i]; next[1] = now[1] + dy[i];
                if (next[0] > 0 && next[0] <= this->x && next[1] > 0 && next[1] <= this->y && cleaning[next[0]][next[1]] && !reachable[next[0]][next[1]]) {
                    q[ed][0] = next[0]; q[ed++][1] = next[1]; reachable[next[0]][next[1]] = true;
                }
            }
        }
        if (reachable[cEnd[0]][cEnd[1]]) {
            for (int i = 1; i <= x; ++i) {
                for (int j = 1; j <= y; ++j) {
                    if (reachable[i][j]) {
                        IDs[time-1][i][j].clear();
                        info[i][j] = 0;
                    }
                }
            }
        }
        else {
            memset(reachable,0,sizeof(reachable));
        }
        p->repaint();
    }
}
void MainWindow::washFinish()
{
    tWash.stop();
    memset(reachable,0,sizeof(reachable));
    p->repaint();
    if (isRunning) {
        if (time <= endTime)
            runByStep();
        else {
            switchState();
        }
    }
}


void MainWindow::on_pauseBtn_clicked()
{
}

void MainWindow::switchState()
{
    btn[0]->setEnabled(isRunning);
    btn[1]->setEnabled(isRunning);
    btn[2]->setEnabled(isRunning);
    btn[4]->setEnabled(isRunning);
    btn[5]->setEnabled(isRunning);
    isRunning = !isRunning;
    btn[3]->setEnabled(isRunning);
}

void MainWindow::runableChange()
{
    runable = !runable;
    btn[2]->setEnabled(runable);
}

void MainWindow::on_newBtn_clicked()
{
    do {
        InputDialog dlg(this);
        if (dlg.exec() == QDialog::Accepted) {
            x=dlg.x; y=dlg.y;
            for (int i=0;i<7;++i){
                posX[i]=dlg.posX[i];
                posY[i]=dlg.posY[i];
            }
            cleanable = dlg.isClean;
            this->file.setFileName(dlg.file.fileName());
            cbtn->setEnabled(cleanable);
            cbtn->setChecked(false);
            btn[1]->setEnabled(true);
            btn[2]->setEnabled(true);
            btn[4]->setEnabled(true);
            btn[5]->setEnabled(true);
            memset(nClean, 0, sizeof(nClean));
            isClean = false;
            p->set(x, y, posX, posY, isClean, cleanable);
            setTime(0);
            on_cBtn_stateChanged(0);
        }
        }
    while (!newInit());
}

void MainWindow::on_resetBtn_clicked()
{
    memset(nClean, 0, sizeof(nClean));
    setTime(0);
}

void MainWindow::on_nextBtn_clicked()
{
    runByStep();
}

void MainWindow::on_prevBtn_clicked()
{
    if (time > 0) {
        setTime(time - 1);
    }
    else {
        QMessageBox::warning(this,tr("error"),QString("已经到达初始状态"));
    }
}

void MainWindow::on_cBtn_stateChanged(int)
{
    isClean = cbtn->isChecked();
    if (isClean == false)
        memset(nClean,0,sizeof(nClean));
    p->setClean(isClean);
    p->repaint();
}

void MainWindow::on_startBtn_clicked()
{
    runByStep();
}
