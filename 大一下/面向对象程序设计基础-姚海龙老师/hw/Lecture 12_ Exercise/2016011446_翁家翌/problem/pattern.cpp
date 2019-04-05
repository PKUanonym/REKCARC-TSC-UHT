#include <fstream>
#include "pattern.h"

void PatternData::read()
{
    std::string separator, now, tmp;
    std::ifstream input;
    input.open(PATTERNDATA_FILENAME.c_str());
    //the first line is defined as separator
    std::getline(input, separator);
    while(std::getline(input, tmp))
        if(tmp == separator)
        {
            if(!now.empty())
                _list.push_back(now);
            now.clear();
        }
        else
            now += deal(tmp);
    if(!now.empty())
        _list.push_back(now);
    input.close();
}
