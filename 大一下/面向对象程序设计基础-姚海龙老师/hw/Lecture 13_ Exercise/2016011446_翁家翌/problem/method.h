#ifndef __METHOD_H__
#define __METHOD_H__

#include <string>
#include <memory>
#include <cctype>
#include "conf.h"
#include "raw_data.h"
#include "pattern.h"

class Method
{
    std::vector<int>tot_count;
protected:
	//preprocessing of algorithm
    virtual void algo_pre(const std::string &) = 0;

    //find substring
    virtual int algo(const std::string &, const std::string &) = 0;
public:
	//extract (raw data,pattern data) to (raw[i],pattern[j]) for calculate
    void compute(RawData &raw, PatternData &pattern);
};

typedef std::shared_ptr<Method> MethodPtr;
MethodPtr get_kmp_algo();
MethodPtr get_karp_rabin_algo();

#endif