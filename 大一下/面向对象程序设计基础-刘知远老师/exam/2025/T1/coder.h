#pragma once
#include "agent.h"
#include <iostream>
#include <string>

class Coder: public Agent{
public:
    int char_coded;

    Coder(int id, std::string& codes): Agent(id, codes), char_coded(0) {}

    void action() override{
        std::string temp;
        std::cin>>temp;
        char_coded += temp.size();
        codes += temp;
    }

    void report() override{
        std::cout<<"Coder "<<get_agent_id()<<": "<<char_coded<<" characters coded\n";
    }
};