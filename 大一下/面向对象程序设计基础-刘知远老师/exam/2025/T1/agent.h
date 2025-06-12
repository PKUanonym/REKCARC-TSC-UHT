#ifndef AGENT_H
#define AGENT_H

#include <string>
#include <iostream>

class Agent {
    int agent_id;
protected:
    std::string& codes;
public:
    Agent(int id, std::string& codes): agent_id(id), codes(codes) {}
    int get_agent_id() { return agent_id; }
    virtual ~Agent() = default;

    virtual void action() = 0;
    virtual void report() = 0;

    static Agent* create_agent(int agent_type, int id, std::string& codes);
};

#endif
