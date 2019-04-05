#include "tthread.h"

void TThread::run()
{
    for(int i=0;i<a1->length();++i)
        ans->append(a1->at(i));
    for(int i=0;i<a2->length();++i)
        ans->append(a2->at(i));
    for(int i=0;i<a3->length();++i)
        ans->append(a3->at(i));
    for(int i=0;i<a4->length();++i)
        ans->append(a4->at(i));
    for(int i=0;i<a5->length();++i)
        ans->append(a5->at(i));
}
