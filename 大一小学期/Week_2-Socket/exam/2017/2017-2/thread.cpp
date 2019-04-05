#include "thread.h"

void Thread::run()
{
    for(int i=0;i<len;++i)
    {
        int tmp=a[i].length();
        int w=a[i][tmp-1].digitValue();
        ans[w%5].append(a[i]);
    }
}
