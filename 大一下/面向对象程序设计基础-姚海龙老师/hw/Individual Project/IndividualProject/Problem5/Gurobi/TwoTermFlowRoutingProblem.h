#ifndef TWO_TERM_FLOW_ROUTING_PROBLEM_H
#define TWO_TERM_FLOW_ROUTING_PROBLEM_H
#include "LPProblem.h"
#include "HYTypedefs.h"

class TwoTermFlowRoutingProblem : public LPProblem {
public:
    TwoTermFlowRoutingProblem(int w, int h, const HY::MPOINTVEC &obstacles, HY::MPOINTVEC &conPnts, HY::MPOINTVEC &bryPnts);

    void getCoeffs(std::vector<std::pair<int,int> > &cIndex, std::vector<float> &coeffs);
    void getRowBounds(std::vector<float> &lb, std::vector<float> &ub, std::vector<BoundType> &bounds);
    void getColBounds(std::vector<float> &lb, std::vector<float> &ub, std::vector<BoundType> &bounds);
    void getObjCoeff(std::vector<float> &coeffs);
    void getVarTypes(std::vector<VarType> &varTypes);
    ObjDir getObjDir();
    bool getSourceTarget(int eid, std::pair<int,int> &source, std::pair<int,int> &target);
    void solve(HY::MPATHVEC &sPaths);

    ~TwoTermFlowRoutingProblem() {}
protected:
    void buildProblem();
    void addConsForInternalNodes(int &conId, int &varId);
    void addConsForNonSinkNodes(int &conId);
    void addConsForSinkNodes(int &conId, int &varId);
    void addConsForCrossing(int &conId);

    //The problem after translation
    std::vector<std::pair<int,int> > conIndex_;
    std::vector<float> conCoeffs_;
    std::vector<float> rlb_;
    std::vector<float> rub_;
    std::vector<BoundType> rbounds_;
    std::vector<float> clb_;
    std::vector<float> cub_;
    std::vector<BoundType> cbounds_;
    std::vector<float> objCoeffs_;
    std::vector<VarType> varTypes_;
    ObjDir dir_;

    //original problem
    std::vector<std::vector<bool> > obsMap_;
    std::vector<std::vector<bool> > terminalMap_;
    std::vector<std::vector<bool> > sinkMap_;
    int width_;
    int height_;
    std::vector<std::pair<int,int> > terminals_; //all terminals have to be connected
    std::vector<std::pair<int,int> > bryPnts_; //chose the best one to connect
};

#endif

