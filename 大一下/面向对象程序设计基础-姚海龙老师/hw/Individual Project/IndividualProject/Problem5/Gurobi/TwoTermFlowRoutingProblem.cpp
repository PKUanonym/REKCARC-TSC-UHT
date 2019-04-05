#include <cassert>
#include <cstdio>
#include <iostream>
#include "TwoTermFlowRoutingProblem.h"
#include "FlowSolver.h"
#include "HYFunc.h"

//#define INFO

using namespace std;
using namespace HY;
    
    //LPProblem *problem = new MultiSteinerRoutingProblem();
    //FlowSolver::solve(problem);
    //LPProblem *problem = new TwoTermFlowRoutingProblem();
    //FlowSolver::solve(problem, false);

TwoTermFlowRoutingProblem::TwoTermFlowRoutingProblem(int w, int h, const MPOINTVEC &obstacles, MPOINTVEC &conPnts, MPOINTVEC &bryPnts):LPProblem(),width_(w), height_(h)
{
    bryPnts_ = bryPnts;
    vector<bool> tmp(height_, false);
    terminalMap_.assign(width_, tmp);
    for (int i = 0; i < SIZE(conPnts); ++ i)
    {
        terminalMap_[conPnts[i].first][conPnts[i].second] = true;
    }
    for (int x = 0; x < SIZE(terminalMap_); ++x)
    {
        for (int y = 0; y < SIZE(terminalMap_[x]); ++y)
        {
            if (terminalMap_[x][y])
                terminals_.push_back(make_pair(x,y));
        }
    }
    sinkMap_.assign(width_, tmp);
    for (int i = 0; i < SIZE(bryPnts_); ++ i)
    {
        sinkMap_[bryPnts_[i].first][bryPnts_[i].second] = true;
    }
    
    obsMap_.assign(width_, tmp);
    for (int j = 0; j < SIZE(obstacles); ++ j)
    {
        if (!terminalMap_[obstacles[j].first][obstacles[j].second])
            obsMap_[obstacles[j].first][obstacles[j].second] = true;
    }

    buildProblem();
}

bool TwoTermFlowRoutingProblem::getSourceTarget(int eid, pair<int,int> &source, pair<int,int> &target)
{
    //////////////////////////////////////////////////////////////////////
    //Edge variables are numbered in the following way: (1) each edge
    //has two variables (2i)/(2i+1) denoting the two different directions,
    //(2) in the grid matrix, vertical edges are numbered first, then
    //horizontal edges are numbered, (3) both vertical and horizontal
    //edges are numbered from bottom row to top row (with increasing y-coordinates),
    //and in each row, edges are numbered from left col to right col (with
    //increasing x-coordinates). 
    int edgeVarNum = (((width_-2)*(height_-1) + (width_-1)*(height_-2)))*2;
    //printf("eid: %d\n", eid);
    if (eid >= edgeVarNum)
    {
        source.first = source.second = target.first = target.second = -1;
        return false;
    }
    int x = 0, y = 0;
    if (eid >= (width_-2)*(height_-1)*2)
    {
        //horizontal edge
        eid -= ((width_-2)*(height_-1)*2);
        x = eid % ((width_-1)*2);
        if (x % 2)
            x /= 2;
        else
            x = x/2+1;
        y = (eid / ((width_-1)*2))+1;
        source.first = x;
        source.second = y;
        if (eid % 2)
        {
            target.first = x+1;
            target.second = y;
        }
        else
        {
            target.first = x-1;
            target.second = y;
        }
        //printf("source: (%d,%d)\n", x, y);
        //printf("target: (%d,%d)\n", target.first, target.second);
    }
    else
    {
        //vertical edge
        x = eid % ((width_-2)*2);
        x = x/2+1;
        y = eid / ((width_-2)*2);
        if ((eid - y*(width_-2)*2) % 2 == 0)
            ++ y;
        source.first = x;
        source.second = y;
        if (eid % 2)
        {
            target.first = x;
            target.second = y+1;
        }
        else
        {
            target.first = x;
            target.second = y-1;
        }
        //printf("source: (%d,%d)\n", x, y);
        //printf("target: (%d,%d)\n", target.first, target.second);
    }

    return true;
}

void TwoTermFlowRoutingProblem::addConsForInternalNodes(int &conId, int &varId)
{
    int edgeVarNum = (((width_-2)*(height_-1) + (width_-1)*(height_-2)))*2;
    for (int x = 1; x < width_-1; ++x)
    {
        for (int y = 1; y < height_-1; ++y)
        {
#ifdef INFO
            printf("Internal node: (%d,%d)\n", x, y);
#endif
            int inVar1 = (y-1)*(width_-2)*2+x*2-1, inVar2 = y*(width_-2)*2+x*2-2;
            int outVar1 = (y-1)*(width_-2)*2+x*2-2, outVar2 = y*(width_-2)*2+x*2-1;
            int inVar3 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2-1, inVar4 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2;
            int outVar3 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2-2, outVar4 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2+1;
#ifdef INFO
            printf("In edges: %d,%d,%d,%d\n", inVar1, inVar2, inVar3, inVar4);
            printf("Out edges: %d,%d,%d,%d\n", outVar1, outVar2, outVar3, outVar4);
#endif
            ++ inVar1;
            ++ inVar2;
            ++ inVar3;
            ++ inVar4;
            ++ outVar1;
            ++ outVar2;
            ++ outVar3;
            ++ outVar4;
            assert(outVar1 <= edgeVarNum);
            assert(outVar2 <= edgeVarNum);
            assert(outVar3 <= edgeVarNum);
            assert(outVar4 <= edgeVarNum);
            assert(inVar1 <= edgeVarNum);
            assert(inVar2 <= edgeVarNum);
            assert(inVar3 <= edgeVarNum);
            assert(inVar4 <= edgeVarNum);
            if ( terminalMap_[x][y] )
            {
#ifdef INFO
                printf("Terminal: %d,%d\n", x, y);
#endif
                //sum outflow - varId >= 0;
                conIndex_.push_back(make_pair(conId, outVar1));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, outVar2));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, outVar3));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, outVar4));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, varId++));
                conCoeffs_.push_back(-1.0);
                rlb_.push_back(0);
                rub_.push_back(0);
                rbounds_.push_back(LowerBound);
#ifdef INFO
                printf("Add constraint %d: x%d + x%d + x%d + x%d - x%d >= 0\n", conId, outVar1, outVar2, outVar3, outVar4, varId-1);
#endif
                conId ++;

                conIndex_.push_back(make_pair(conId, inVar1));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, inVar2));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, inVar3));
                conCoeffs_.push_back(1.0);
                conIndex_.push_back(make_pair(conId, inVar4));
                conCoeffs_.push_back(1.0);
                rlb_.push_back(0);
                rub_.push_back(0);
                rbounds_.push_back(FixedVariable);
#ifdef INFO
                printf("Add constraint %d: x%d + x%d + x%d + x%d == 0\n", conId, inVar1, inVar2, inVar3, inVar4);
#endif
            }
            else
            {
                if ( obsMap_[x][y] )
                {
#ifdef INFO
                    printf("obstacle: %d,%d\n", x, y);
#endif
                    //outflow - inflow = 0;
                    conIndex_.push_back(make_pair(conId, outVar1));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, outVar1);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, outVar2));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, outVar2);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, outVar3));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, outVar3);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, outVar4));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, outVar4);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, inVar1));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, inVar1);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, inVar2));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, inVar2);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, inVar3));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, inVar3);
#endif
                    conId ++;
                    conIndex_.push_back(make_pair(conId, inVar4));
                    conCoeffs_.push_back(1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d == 0\n", conId, inVar4);
#endif
                }
                else
                {
#ifdef INFO
                    printf("Non-terminal: %d,%d\n", x, y);
#endif
                    //outflow - inflow = 0;
                    conIndex_.push_back(make_pair(conId, outVar1));
                    conCoeffs_.push_back(1.0);
                    conIndex_.push_back(make_pair(conId, outVar2));
                    conCoeffs_.push_back(1.0);
                    conIndex_.push_back(make_pair(conId, outVar3));
                    conCoeffs_.push_back(1.0);
                    conIndex_.push_back(make_pair(conId, outVar4));
                    conCoeffs_.push_back(1.0);
                    conIndex_.push_back(make_pair(conId, inVar1));
                    conCoeffs_.push_back(-1.0);
                    conIndex_.push_back(make_pair(conId, inVar2));
                    conCoeffs_.push_back(-1.0);
                    conIndex_.push_back(make_pair(conId, inVar3));
                    conCoeffs_.push_back(-1.0);
                    conIndex_.push_back(make_pair(conId, inVar4));
                    conCoeffs_.push_back(-1.0);
                    rlb_.push_back(0);
                    rub_.push_back(0);
                    rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                    printf("Add constraint %d: x%d + x%d + x%d + x%d - x%d - x%d - x%d - x%d == 0\n", conId, outVar1, outVar2, outVar3, outVar4, inVar1, inVar2, inVar3, inVar4);
#endif
                }
            }
            conId ++;
        }
    }
}

void TwoTermFlowRoutingProblem::addConsForCrossing(int &conId)
{
    int edgeVarNum = (((width_-2)*(height_-1) + (width_-1)*(height_-2)))*2;
    for (int x = 1; x < width_-1; ++x)
    {
        for (int y = 1; y < height_-1; ++y)
        {
#ifdef INFO
            printf("Internal node: (%d,%d)\n", x, y);
#endif
            int inVar1 = (y-1)*(width_-2)*2+x*2-1, inVar2 = y*(width_-2)*2+x*2-2;
            int outVar1 = (y-1)*(width_-2)*2+x*2-2, outVar2 = y*(width_-2)*2+x*2-1;
            int inVar3 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2-1, inVar4 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2;
            int outVar3 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2-2, outVar4 = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2+1;
#ifdef INFO
            printf("In edges: %d,%d,%d,%d\n", inVar1, inVar2, inVar3, inVar4);
            printf("Out edges: %d,%d,%d,%d\n", outVar1, outVar2, outVar3, outVar4);
#endif
            ++ inVar1;
            ++ inVar2;
            ++ inVar3;
            ++ inVar4;
            ++ outVar1;
            ++ outVar2;
            ++ outVar3;
            ++ outVar4;
            //sum of all variables <= 2;
#ifdef INFO
            printf("Add constraint %d:", conId);
#endif
            conIndex_.push_back(make_pair(conId, inVar1));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, inVar2));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, inVar3));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, inVar4));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, outVar1));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, outVar2));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, outVar3));
            conCoeffs_.push_back(1.0);
            conIndex_.push_back(make_pair(conId, outVar4));
            conCoeffs_.push_back(1.0);
            rlb_.push_back(2);
            rub_.push_back(2);
            rbounds_.push_back(UpperBound);
#ifdef INFO
            printf(" x%d + x%d + x%d + x%d + x%d + x%d + x%d + x%d <= 2\n", inVar1, inVar2, inVar3, inVar4, outVar1, outVar2, outVar3, outVar4);
#endif
            ++ conId;
        }
    }
}

void TwoTermFlowRoutingProblem::addConsForSinkNodes(int &conId, int &varId)
{
    int edgeVarNum = (((width_-2)*(height_-1) + (width_-1)*(height_-2)))*2;
    for (int i = 0; i < (int)bryPnts_.size(); ++i)
    {
        int x = bryPnts_[i].first;
        int y = bryPnts_[i].second;
#ifdef INFO
        printf("Bry node: (%d,%d)\n", x, y);
#endif
        int inVar = 0;
        int outVar = 0;
        if (x == 0)
        {
            inVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x+1)*2-2;
            outVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x+1)*2-1;
        }
        else if (x == width_-1)
        {
            inVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x-1)*2+1;
            outVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x-1)*2;
        }
        else if (y == 0)
        {
            inVar = y*(width_-2)*2+x*2-2;
            outVar = y*(width_-2)*2+x*2-1;
        }
        else
        {
            assert(y == height_-1);
            inVar = (y-1)*(width_-2)*2+x*2-1;
            outVar = (y-1)*(width_-2)*2+x*2-2;
        }
#ifdef INFO
        printf("In edge: %d\n", inVar);
        printf("Out edge: %d\n", outVar);
#endif
        ++ inVar;
        ++ outVar;
        assert(inVar <= edgeVarNum);
        assert(outVar <= edgeVarNum);
        //inflow - outflow <= ivar;
        //ivar - inflow + outflow >= 0;
        conIndex_.push_back(make_pair(conId, varId));
        conCoeffs_.push_back(1.0);
        conIndex_.push_back(make_pair(conId, inVar));
        conCoeffs_.push_back(-1.0);
        conIndex_.push_back(make_pair(conId, outVar));
        conCoeffs_.push_back(1.0);
        rlb_.push_back(0);
        rub_.push_back(0);
        rbounds_.push_back(LPProblem::LowerBound);
#ifdef INFO
        printf("Add constraint %d: x%d - x%d + x%d >= 0\n", conId, varId, inVar, outVar);
#endif

        varId ++;
        conId ++;
    }
}

void TwoTermFlowRoutingProblem::addConsForNonSinkNodes(int &conId)
{
    int edgeVarNum = (((width_-2)*(height_-1) + (width_-1)*(height_-2)))*2;
    for (int x = 1; x < width_-1; ++x)
    {
        for (int j = 0; j <= 1; ++j)
        {
            int y = j*(height_-1);
            if ( !sinkMap_[x][y] )
            {
#ifdef INFO
                printf("Non-sink Bry node: (%d,%d)\n", x, y);
#endif
                int inVar = 0;
                int outVar = 0;
                if (y == 0)
                {
                    inVar = y*(width_-2)*2+x*2-2;
                    outVar = y*(width_-2)*2+x*2-1;
                }
                else
                {
                    assert(y == height_-1);
                    inVar = (y-1)*(width_-2)*2+x*2-1;
                    outVar = (y-1)*(width_-2)*2+x*2-2;
                }
#ifdef INFO
                printf("In edge: %d\n", inVar);
                printf("Out edge: %d\n", outVar);
#endif
                ++ inVar;
                ++ outVar;
                assert(inVar <= edgeVarNum);
                assert(outVar <= edgeVarNum);
                //inflow = 0 && outflow = 0
                conIndex_.push_back(make_pair(conId, inVar));
                conCoeffs_.push_back(1.0);
                rlb_.push_back(0);
                rub_.push_back(0);
                rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                printf("Add constraint %d: x%d == 0\n", conId, inVar);
#endif
                ++ conId;
                conIndex_.push_back(make_pair(conId, outVar));
                conCoeffs_.push_back(1.0);
                rlb_.push_back(0);
                rub_.push_back(0);
                rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                printf("Add constraint %d: x%d == 0\n", conId, outVar);
#endif
                ++ conId;
            }
        }
    }
    for (int y = 1; y < height_-1; ++y)
    {
        for (int j = 0; j <= 1; ++j)
        {
            int x = j*(width_-1);
            if ( !sinkMap_[x][y] )
            {
#ifdef INFO
                printf("Non-sink Bry node: (%d,%d)\n", x, y);
#endif
                int inVar = 0;
                int outVar = 0;
                if (x == 0)
                {
                    inVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x+1)*2-2;
                    outVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x+1)*2-1;
                }
                else
                {
                    assert (x == width_-1);
                    inVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x-1)*2+1;
                    outVar = (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x-1)*2;
                }
#ifdef INFO
                printf("In edge: %d\n", inVar);
                printf("Out edge: %d\n", outVar);
#endif
                ++ inVar;
                ++ outVar;
                assert(inVar <= edgeVarNum);
                assert(outVar <= edgeVarNum);
                //inflow = 0 && outflow = 0
                conIndex_.push_back(make_pair(conId, inVar));
                conCoeffs_.push_back(1.0);
                rlb_.push_back(0);
                rub_.push_back(0);
                rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                printf("Add constraint %d: x%d == 0\n", conId, inVar);
#endif
                ++ conId;

                conIndex_.push_back(make_pair(conId, outVar));
                conCoeffs_.push_back(1.0);
                rlb_.push_back(0);
                rub_.push_back(0);
                rbounds_.push_back(LPProblem::FixedVariable);
#ifdef INFO
                printf("Add constraint %d: x%d == 0\n", conId, outVar);
#endif
                ++ conId;
            }
        }
    }
}

void TwoTermFlowRoutingProblem::buildProblem()
{
    dir_ = LPProblem::Minimize;

    //For a given internal node (x,y), compute the four incoming edges and four outgoing edges
#ifdef INFO
    printf("Internal edges\n");
    for (int x = 1; x < width_-1; ++x)
    {
        for (int y = 1; y < height_-1; ++y)
        {
            printf("node(%d,%d): vertical in (%d,%d), out(%d,%d)\n", x, y, 
                //incoming
                (y-1)*(width_-2)*2+x*2-1, y*(width_-2)*2+x*2-2,
                //outgoing
                (y-1)*(width_-2)*2+x*2-2, y*(width_-2)*2+x*2-1);
            printf("node(%d,%d): hor in (%d,%d), out(%d,%d)\n", x, y, 
                //incoming
                (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2-1, (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2,
                //outgoing
                (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2-2, (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+x*2+1);
        }
    }
    printf("Boundary edges\n");
    for (int x = 1; x < width_-1; ++x)
    {
        int y = 0;
        printf("node(%d,%d): vertical in (%d) out(%d)\n", x, y, y*(width_-2)*2+x*2-2, y*(width_-2)*2+x*2-1);
        y = height_-1;
        printf("node(%d,%d): vertical in (%d) out(%d)\n", x, y, (y-1)*(width_-2)*2+x*2-1, (y-1)*(width_-2)*2+x*2-2);
    }
    for (int y = 1; y < height_-1; ++y)
    {
        int x = 0;
        printf("node(%d,%d): hor in (%d) out(%d)\n", x, y, (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x+1)*2-2, (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x+1)*2-1);
        x = width_-1;
        printf("node(%d,%d): hor in (%d) out(%d)\n", x, y, (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x-1)*2+1, (width_-2)*(height_-1)*2+(y-1)*(width_-1)*2+(x-1)*2);
    }
#endif
    //Now add the constraints
    //For internal nodes
#ifdef INFO
    printf("===== Add constraints for internal nodes =====\n");
#endif
    int edgeVarNum = (((width_-2)*(height_-1) + (width_-1)*(height_-2)))*2;
    int conId = 1;
    int varId = edgeVarNum+1;

    addConsForInternalNodes(conId, varId);
    //For boundary points
    //Compupute the number of variables
    ////Enable sink points: not used....
    //printf("===== Add constraints for sink nodes =====\n");
    //addConsForSinkNodes(conId, varId);
    //Disable boundary points that are not sink points
#ifdef INFO
    printf("===== Add constraints for non-sink nodes =====\n");
#endif
    addConsForNonSinkNodes(conId);
    //Add constraints for all edge variables
#ifdef INFO
    printf("===== Add constraints for avoiding crossings =====\n");
#endif
    addConsForCrossing(conId);

    //Now set bounds for variables
    for (int i = 1; i <= edgeVarNum; ++i)
    {
        clb_.push_back(0);
        cub_.push_back(0);
        cbounds_.push_back(LPProblem::LowerBound);
        objCoeffs_.push_back(1.0);
        varTypes_.push_back(CV);
    }
    double beta = -10000.0*(width_+height_);
    for (int i = edgeVarNum+1; i <= varId-1; ++i)
    {
        clb_.push_back(0);
        cub_.push_back(1.0);
        cbounds_.push_back(LPProblem::DoubleBound);
        objCoeffs_.push_back(beta);
        varTypes_.push_back(CV);
    }
    /*
    //sink nodes
    for (int i = 1; i <= bryPnts_.size(); ++i)
    {
    clb_.push_back(0);
    cub_.push_back(0);
    cbounds_.push_back(LPProblem::LowerBound);
    objCoeffs_.push_back(1.0);
    varTypes_.push_back(CV);
    }
    */
    assert(edgeVarNum < varId-1);
    printf("Total %d constraints, %d variables\n", conId-1, varId-1);
}

LPProblem::ObjDir TwoTermFlowRoutingProblem::getObjDir()
{
    return dir_;
}

void TwoTermFlowRoutingProblem::getCoeffs(std::vector<std::pair<int,int> > &cIndex, std::vector<float> &coeffs)
{
    cIndex.clear();
    coeffs.clear();
    cIndex = conIndex_;
    coeffs = conCoeffs_;
}

void TwoTermFlowRoutingProblem::getRowBounds(std::vector<float> &lb, std::vector<float> &ub, std::vector<BoundType> &bounds)
{
    lb.clear();
    ub.clear();
    bounds.clear();
    lb = rlb_;
    ub = rub_;
    bounds = rbounds_;
}

void TwoTermFlowRoutingProblem::getColBounds(std::vector<float> &lb, std::vector<float> &ub, std::vector<BoundType> &bounds)
{
    lb.clear();
    ub.clear();
    bounds.clear();
    lb = clb_;
    ub = cub_;
    bounds = cbounds_;
}

void TwoTermFlowRoutingProblem::getObjCoeff(std::vector<float> &coeffs)
{
    coeffs.clear();
    coeffs = objCoeffs_;
}

void TwoTermFlowRoutingProblem::getVarTypes(std::vector<VarType> &varTypes)
{
    varTypes.clear();
    varTypes = varTypes_;
}

void TwoTermFlowRoutingProblem::solve(MPATHVEC &sPaths)
{
    vector<float> vars;
    //FlowSolver::solve(this, false, vars);
    FlowSolver::gurobiSolve(this, vars);

    for (int i = 1; i < SIZE(vars); ++i)
    {
        if (vars[i] > 0.5)
        {
            pair<int,int> source, target;
            if (this->getSourceTarget(i-1, source, target))
            {
                MPATH p;
                p.push_back(source);
                p.push_back(target);
                sPaths.push_back(p);
            }
        }
    }
}

