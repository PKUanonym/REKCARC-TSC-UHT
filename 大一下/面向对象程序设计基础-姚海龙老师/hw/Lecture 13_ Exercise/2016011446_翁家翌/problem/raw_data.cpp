#include <fstream>
#include "raw_data.h"

void RawData::read()
{
    std::ifstream raw;
    raw.open(RAWDATA_FILENAME.c_str());
    std::string filename;
    while(raw >> filename)
    {
        if(filename == "-*-end-*-")
            break;
        std::ifstream input;
        input.open(filename.c_str());
        if(!input.is_open())
            continue;
        std::string tmp, raw_data;
        while(std::getline(input, tmp))
            raw_data += deal(tmp);
        input.close();
        _list.push_back(raw_data);
        name.push_back(filename);
    }
    raw.close();
}