#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QVector>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    QVector<int>c;
    FILE*fin=fopen("../data.txt","r");
    for(int x;fscanf(fin,"%d",&x)!=EOF;c.push_back(x));
    n=c.length();
    a=new int[n];
    for(int i=0;i<n;++i)
        a[i]=c[i];
    int m2=n>>1;
    int m1=m2>>1;
    int m3=m2+n>>1;
    t1=new Thread(a,0,m1,1);
    t2=new Thread(a,m1,m2,1);
    t3=new Thread(a,m2,m3,1);
    t4=new Thread(a,m3,n,1);
    t5=new Thread(a,0,m2,0);
    t6=new Thread(a,m2,n,0);
    t7=new Thread(a,0,n,0);
    connect(t1,SIGNAL(finished()),this,SLOT(end()));
    connect(t2,SIGNAL(finished()),this,SLOT(end()));
    connect(t3,SIGNAL(finished()),this,SLOT(end()));
    connect(t4,SIGNAL(finished()),this,SLOT(end()));
    connect(t5,SIGNAL(finished()),this,SLOT(end2()));
    connect(t6,SIGNAL(finished()),this,SLOT(end2()));
    connect(t7,SIGNAL(finished()),this,SLOT(end3()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    cnt=0;
    t1->start();
    t2->start();
    t3->start();
    t4->start();
}

void MainWindow::end()
{
    sender()->deleteLater();
    if(++cnt==4)
    {
        cnt=0;
        t5->start();
        t6->start();
    }
}

void MainWindow::end2()
{
    sender()->deleteLater();
    if(++cnt==2)
        t7->start();
}

void MainWindow::end3()
{
    sender()->deleteLater();
    //check
    for(int i=1;i<n;++i)
        if(a[i-1]>a[i])
            qDebug()<<"!!";
    //output
    FILE*fout=fopen("../output.txt","w");
    for(int i=0;i<n;++i)
        fprintf(fout,"%d\n",a[i]);
    close();
}
