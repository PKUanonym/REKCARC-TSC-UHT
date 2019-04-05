#ifndef __KMP_H__
#define __KMP_H__

#include "method.h"

class KMP: public Method
{
    std::vector<int>fail;
protected:
	//Preprocessing of KMP algorithm.
    void algo_pre(const std::string &str);
    //Find substr with KMP algorithm.
    int algo(const std::string &find, const std::string &str);
};

#endif