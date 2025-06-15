#pragma once
#include <string>

class Footman {
    std::string footmanId;
public:
    Footman(std::string _footmanId) {
        footmanId = _footmanId;
    };

    virtual std::string getFootmanId() {return footmanId;}
};