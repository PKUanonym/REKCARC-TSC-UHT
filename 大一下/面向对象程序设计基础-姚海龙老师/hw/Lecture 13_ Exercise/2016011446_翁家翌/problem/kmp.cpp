#include "kmp.h"

MethodPtr get_kmp_algo()
{
    return std::make_shared<KMP>();
}

void KMP::algo_pre(const std::string &str)
{
    fail.assign(str.length() + 1, 0);
    for(int i = 1, j = 0; i < str.length(); fail[i + 1] = str[i] == str[j] ? j + 1 : 0, ++i)
        for(j = fail[i]; j && str[i] != str[j]; j = fail[j]);
}
int KMP::algo(const std::string &find, const std::string &str)
{
    int cnt = 0;
    for(int i = 0, j = 0; i < str.length(); ++i)
    {
        for(; j > 0 && str[i] != find[j]; j = fail[j]);
        if(str[i] == find[j])j++;
        if(j == find.length())
        {
            cnt++;
            j = fail[j];
        }
    }
    return cnt;
}
