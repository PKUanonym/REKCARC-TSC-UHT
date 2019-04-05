#ifndef __RAW_DATA_H__
#define __RAW_DATA_H__

#include "data.h"
#include "conf.h"

class RawData: public Data
{
    std::vector<std::string> name;
public:
    std::string filename(int x) {return name[x];}
    void read();
};

#endif
