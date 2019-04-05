#include "method.h"

void Method::compute(RawData &raw, PatternData &pattern)
{
    tot_count.assign(pattern.size(), 0);
    for(int j = 0; j < raw.size(); ++j)
    {
        double c0 = clock();
        printf("Template is %s, length = %ld\n", raw.filename(j).c_str(), raw[j].length());
        algo_pre(raw[j]);
        int flag = 0;
        for(int i = 0; i < pattern.size(); ++i)
        {
            int cnt = algo(pattern[i], raw[j]);
            if(cnt > 0)
            {
                printf("Pattern %2d found in this template, count = %d\n", i + 1, cnt);
                flag = 1;
            }
            tot_count[i] += cnt;
        }
        if(!flag)
            printf("No patterns are found in this template.\n");
        printf("Use %lfms\n\n", (clock() - c0) / CLOCKS_PER_SEC * 1000);
    }
    for(int i = 0; i < pattern.size(); ++i)
    {
        printf("Pattern %2d (", i + 1);
        for(int j = 0; j < 6; j++)
            if(pattern[i].size() >= j + 1)
                putchar(pattern[i][j]);
            else putchar(' ');
        printf("...) occurs %d times.\n", tot_count[i]);
    }
}
