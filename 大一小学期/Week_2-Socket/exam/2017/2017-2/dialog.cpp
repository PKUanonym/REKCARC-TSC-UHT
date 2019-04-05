#include "dialog.h"
#include "ui_dialog.h"
#include <QVector>
#include <QString>
#include <cstdio>
#include <QDebug>
#include <QFile>

Dialog::Dialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Dialog)
{
    ui->setupUi(this);
    QVector<QString>num;
    FILE*fin=fopen("../carno.txt","r");
    char s[100];
    for(;~fscanf(fin,"%s",s);)
    {
        QString tmp;
        tmp.append("京");
        for(int i=0;s[i];++i)
            if(s[i]>='0'&&s[i]<='9'||s[i]>='A'&&s[i]<='Z')
                tmp.append(s[i]);
        num.append(tmp);
    }
    qDebug()<<num.size()<<num[9999];
    n=num.size();
    a=new QString[n];
    for(int i=0;i<n;++i)
        a[i]=num[i];
    int m1=n/5,m2=n/5*2,m3=n/5*3,m4=n/5*4;
    thread[0]=new Thread(&a[0],m1,ans[0]);
    thread[1]=new Thread(&a[m1],m2-m1,ans[1]);
    thread[2]=new Thread(&a[m2],m3-m2,ans[2]);
    thread[3]=new Thread(&a[m3],m4-m3,ans[3]);
    thread[4]=new Thread(&a[m4],n-m4,ans[4]);
    cnt=0;
    connect(thread[0],SIGNAL(finished()),this,SLOT(end()));
    connect(thread[1],SIGNAL(finished()),this,SLOT(end()));
    connect(thread[2],SIGNAL(finished()),this,SLOT(end()));
    connect(thread[3],SIGNAL(finished()),this,SLOT(end()));
    connect(thread[4],SIGNAL(finished()),this,SLOT(end()));
    for(int i=0;i<5;++i)
    {
        th[i]=new TThread(&ans[0][i],&ans[1][i],&ans[2][i],&ans[3][i],&ans[4][i],&final[i]);
        connect(th[i],SIGNAL(finished()),this,SLOT(end2()));
        thread[i]->start();
    }
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::end()
{
    sender()->deleteLater();
    if(++cnt==5)
    {
        cnt=0;
        for(int i=0;i<5;++i)
            th[i]->start();
    }
}

void Dialog::end2()
{
    sender()->deleteLater();
    if(++cnt==5)
    {
        int cntt=0;
        for(int i=0;i<5;++i)
        {
            qDebug()<<i<<final[i].size();
            cntt+=final[i].size();
            QFile fout(tr("../%1.txt").arg(i));
            fout.open(QIODevice::WriteOnly);
            for(int j=0;j<final[i].size();++j)
            {
                fout.write(final[i].at(j).toLocal8Bit());
                fout.write("\n");
            }
        }
        qDebug()<<cntt;
    }
    close();
}
