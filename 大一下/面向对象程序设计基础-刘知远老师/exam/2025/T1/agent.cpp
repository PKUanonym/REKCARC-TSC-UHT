#include "agent.h"
#include "coder.h"
#include "tester.h"
#include <iostream>

Agent* Agent::create_agent(int agent_type, int id, std::string& codes){
    Agent* agent;
    if(agent_type == 0){ // 0为程序员，1为测试员
        agent = new Coder(id, codes);
    } else {
        char marker;
        int flag;
        std::cin>>marker>>flag;
        agent = new Tester(id, codes, marker, flag);
    }
    return agent;
}