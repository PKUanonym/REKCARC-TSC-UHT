#pragma once
#include <string>

class AbstractFactory {
public: 
    virtual Casern* createCasern() = 0;
    virtual Footman* createFootman(std::string _footmanId) = 0;
    virtual Commander* createCommander(std::string _commanderId) = 0;
    virtual Belong* createBelong(Footman* _footman, Commander* _commander) = 0;
};