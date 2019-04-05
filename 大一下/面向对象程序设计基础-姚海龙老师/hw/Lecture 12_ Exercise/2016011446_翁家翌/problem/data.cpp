#include "data.h"

std::string Data::deal(std::string ths)
{
    std::string res;
    for(int i = 0; i < ths.length(); ++i)
        if(std::isupper(ths[i]))
            res += ths[i] - 'A' + 'a';
        else if(!std::isspace(ths[i]))
            res += ths[i];
    return res;
}
