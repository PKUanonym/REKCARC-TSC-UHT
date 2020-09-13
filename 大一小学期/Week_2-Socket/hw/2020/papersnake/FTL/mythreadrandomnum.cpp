#include "mythreadrandomnum.h"
#include <QTime>
#include <random>

MyThreadRandomNum::MyThreadRandomNum()
{
    moveToThread(this);
}
void MyThreadRandomNum::run()
{
    int i,j;
    for(i=0;i<54;i++)//生成54个随机数
    {
        numbersList.append(QRandomGenerator::global()->bounded(54));
        bool flag=true;
        while(flag)
        {
            for(j=0;j<i;j++)
            {
                if(numbersList[i]==numbersList[j])
                {
                    break;
                }
            }
            if(j<i)
            {
                numbersList[i]=rand()%54;
            }
            if(j==i)
            {
                flag=!flag;
            }
        }
    }
    for(i=0;i<54;i++)
    {
        qDebug()<<numbersList[i];
    }
}
QList<int> MyThreadRandomNum::getRandomCardList()
{
    return numbersList;
}
