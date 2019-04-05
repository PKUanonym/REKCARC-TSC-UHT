#ifndef __KR_H__
#define __KR_H__

#include "method.h"

//constant of hash
const long long P = 998244353;
const int seed = 131;

class KarpRabin: public Method
{
    std::vector<long long> hash, power;
    //get hash of str[l+1,l+len]
    long long gethash(int l, int len);
protected:
	//Preprocessing of Karp-Rabin algorithm.
    void algo_pre(const std::string &str);
    //Find substr with Karp-Rabin algorithm.
    int algo(const std::string &find, const std::string &str);
};

#endif