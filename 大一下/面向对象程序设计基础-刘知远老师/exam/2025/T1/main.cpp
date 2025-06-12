#include <iostream>
#include <string>
#include <vector>
#include "agent.h"
#include "coder.h"
#include "tester.h"


int main() {
    std::string codes;
    std::vector<Agent*> agents;
    int n, m;
    std::cin >> n >> m;
    for (int i = 0; i < n; i++) {
        int agent_type;
        std::cin >> agent_type;
        Agent* agent = Agent::create_agent(agent_type, i, codes);
        agents.push_back(agent);
    }
    for (int i = 0; i < m; i++) {
        int agent_id; int cmd_id;
        std::cin >> agent_id >> cmd_id;
        if (cmd_id == 0) {
            agents[agent_id]->action();
        } else {
            agents[agent_id]->report();
        }
    }
    for (Agent* agent: agents)
        delete agent;
    return 0;
}
