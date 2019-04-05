#include "karp_rabin.h"

MethodPtr get_karp_rabin_algo()
{
    return std::make_shared<KarpRabin>();
}

long long KarpRabin::gethash(int l, int len)
{
    return (hash[l + len] - hash[l] * power[len] % P + P) % P;
}
void KarpRabin::algo_pre(const std::string &str)
{
    hash.assign(str.length() + 1, 0);
    for(int i = 0; i < str.length(); ++i)
        hash[i + 1] = (hash[i] * seed + str[i]) % P;
    power.assign(str.length() + 1, 1);
    for(int i = 1; i <= str.length(); ++i)
        power[i] = power[i - 1] * seed % P;
}
int KarpRabin::algo(const std::string &find, const std::string &str)
{
    long long hash_find = 0;
    int cnt = 0;
    for(int i = 0; i < find.length(); ++i)
        hash_find = (hash_find * seed + find[i]) % P;
    for(int l = 0; l + find.length() <= str.length(); ++l)
        if(gethash(l, find.length()) == hash_find)
            ++cnt;
    return cnt;
}
