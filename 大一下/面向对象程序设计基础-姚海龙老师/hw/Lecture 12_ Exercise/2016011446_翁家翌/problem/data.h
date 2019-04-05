#ifndef __DATA_H__
#define __DATA_H__

#include <string>
#include <vector>

class Data
{
protected:
    //data container
    std::vector<std::string> _list;
    //remove space and lower the alpha in the string
    std::string deal(std::string ths);
public:
    int size() {return _list.size();}
    std::string operator[](int t) {return _list[t];}
    virtual void read() = 0;
};

#endif