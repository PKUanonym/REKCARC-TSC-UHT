#ifndef CONFIG
#define CONFIG

#include <QObject>
#include <QDebug>
#include <QString>
#include <ctime>

extern const int loc[9][2];

struct Mat{
    int m[3][3];
    Mat(){
        for(int i=0;i<3;++i)
            for(int j=0;j<3;++j)
                m[i][j]=0;
    }
    int cnt0(){
        int cnt=0;
        for(int i=0;i<3;++i)
            for(int j=0;j<3;++j)
                if(m[i][j]==0)
                    cnt++;
        return cnt;
    }
    bool operator!=(const Mat&a)const{
        for(int i=0;i<3;++i)
            for(int j=0;j<3;++j)
                if(m[i][j]!=a.m[i][j])
                    return 1;
        return 0;
    }
    int init(const QString&a)
    {
        int cnt=0,len=a.length();
        for(int i=0;i<len;++i)
            if(a[i]=='.'||a[i]=='_')
                m[cnt/3][cnt%3]=0,cnt++;
            else if(a[i]>='1'&&a[i]<='9')
                m[cnt/3][cnt%3]=a[i].digitValue(),cnt++;
        return cnt==9;
    }
    void print(){
        QString s;
        for(int i=0;i<3;++i)
            for(int j=0;j<3;++j)
                if(m[i][j]==0)s+='.';
                else s+=m[i][j]+'0';
        qDebug()<<s;
    }
};

//struct Trip{int x,y,v;};

#endif // CONFIG
