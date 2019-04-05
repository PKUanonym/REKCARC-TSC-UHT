#include "func.h"
#include "ui_func.h"
#include <QDebug>
#include <QTime>
void sleep(unsigned int msec)
{
    QTime dieTime = QTime::currentTime().addMSecs(msec);
    while( QTime::currentTime() < dieTime )
        QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
}
func::func(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::func)
{
    ui->setupUi(this);
}

func::~func()
{
    delete ui;
}
void func::copyFile(const QString &fromFIleName, const QString &toFileName)
{
    qDebug()<<fromFIleName;
    qDebug()<<toFileName;
   char* byteTemp = new char[4096];//字节数组
   int fileSize = 0;
   int totalCopySize = 0;
   QFile tofile;
   //ui->progressBar_copy->setValue(0);
   tofile.setFileName(toFileName);
   if(!tofile.open(QIODevice::WriteOnly|QIODevice::Text))
       qDebug("0000000");
   QDataStream out(&tofile);
   out.setVersion(QDataStream::Qt_5_4);

   QFile fromfile;
   fromfile.setFileName(fromFIleName);
   if(!fromfile.open(QIODevice::ReadOnly)){
       qDebug() << "open fromfile failed！！！";
       return;
   }
   fileSize = fromfile.size();
   QDataStream in(&fromfile);

   in.setVersion(QDataStream::Qt_5_4);
   //ui->progressBar_copy->setRange(0, fileSize);
   CRoundProcesseBar pb;
   pb.setValue(0);
   pb.show();
   pb.setRange(0,100);
   int f;
   f=0;
   while(!in.atEnd())
   {
       int readSize = 0;
       //读入字节数组,返回读取的字节数量，如果小于4096，则到了文件尾
       readSize = in.readRawData(byteTemp, 4096);
       out.writeRawData(byteTemp, readSize);
       totalCopySize += readSize;
       if((totalCopySize-f)>=fileSize/100)
       {
           qDebug()<<QString::number(totalCopySize);
           qDebug()<<QString::number(fileSize);
           pb.setScanValue(QString::number((long long)totalCopySize*100/fileSize));
           f = totalCopySize;
           sleep(5);
       }
   }
   pb.setScanValue(QString::number(100));
   qDebug("MoveSuccess");
   tofile.close();
   if(totalCopySize == fileSize)
       tofile.setPermissions(QFileDevice::ReadUser|QFileDevice::WriteUser|QFileDevice::ExeUser);
   qDebug("110");
   QMessageBox message(QMessageBox::NoIcon, tr("Success"), tr("Copy completed!"));
   message.exec();
   return;
}
