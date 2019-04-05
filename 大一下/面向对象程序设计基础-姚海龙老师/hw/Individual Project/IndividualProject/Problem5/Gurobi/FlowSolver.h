#ifndef FLOW_SOLVER_H
#define FLOW_SOLVER_H
#include <vector>

class LPProblem;

class FlowSolver {
public:
    static void testGLPK();
    static void solve(LPProblem *problem, bool ILP, std::vector<float> &vars);
    static void gurobiSolve(LPProblem *problem, std::vector<float> &vars);
};

#endif

