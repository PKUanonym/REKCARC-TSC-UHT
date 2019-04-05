#include "thread.h"

void Thread::sort(int x,int y)
{
    if(y-x<=1)return;
    int*b=new int[y-x];
    int m=x+y>>1;
    if(cas)
    {
        sort(x,m);
        sort(m,y);
    }
    for(int p=x,q=m,i=0;p<m||q<y;)
        if(q>=y||(p<m&&a[p]<=a[q]))
            b[i++]=a[p++];
        else
            b[i++]=a[q++];
    for(int i=x,j=0;i<y;++i,++j)
        a[i]=b[j];
    delete[]b;
}

