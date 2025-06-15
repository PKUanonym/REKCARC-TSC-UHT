#pragma once
#include <string>

class Commander {
    std::string commanderId;
public:
    Commander(std::string _commanderId) {
        commanderId = _commanderId;
    };
    virtual std::string getCommanderId() {return commanderId;}
};