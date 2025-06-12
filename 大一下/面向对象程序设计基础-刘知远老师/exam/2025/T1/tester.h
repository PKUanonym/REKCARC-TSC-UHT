#pragma once
#include "agent.h"
#include <iostream>
#include <string>

class Tester: public Agent{
public:
    char marker;
    int flag;
    int test_passed;

    Tester(int id, std::string& codes, char _marker, int _flag): Agent(id, codes), marker(_marker), flag(_flag), test_passed(0) {}

    void action() override{
        int temp = 0;
        for(char& c: codes){
            if(c==marker){
                ++temp;
            }
        }

        if(temp%2 == flag){
            ++test_passed;
        }
    }
    
    void report() override{
        std::cout<<"Tester "<<get_agent_id()<<": "<<test_passed<<" tests passed\n";
    }
};