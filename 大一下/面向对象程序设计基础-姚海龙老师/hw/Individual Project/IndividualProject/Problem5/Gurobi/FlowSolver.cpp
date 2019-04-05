#include <typeinfo>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <cassert>
#include <limits>
#include <cmath>
#include "FlowSolver.h"
#include "LPProblem.h"
#include "SteinerRoutingProblem.h"
#include "MultiSteinerRoutingProblem.h"
#include "ControlFlowRoutingProblem.h"
#include "TwoTermRoutingProblem.h"
#include "TwoTermFlowRoutingProblem.h"
#include "ComplexTwoTermFlowRoutingProblem.h"
#include "glpk.h"
#include "gurobi_c++.h"

using namespace std;

//#define INFO

void FlowSolver::gurobiSolve(LPProblem *problem, vector<float> &vars)
{
    try {
        GRBEnv env = GRBEnv();
        GRBModel model = GRBModel(env);
        const type_info &ti = typeid(*problem);

        vector<float> lb, ub;
        vector<LPProblem::BoundType> bounds;
        problem->getColBounds(lb, ub, bounds);

#ifdef INFO
        printf("========== Gurobi Col Bounds %d ==========\n", (int)bounds.size());
#endif
        vector<float> coeffs;
        problem->getObjCoeff(coeffs);
        vector<LPProblem::VarType> varTypes;
        problem->getVarTypes(varTypes);
        int varNum = coeffs.size();
        // Create variables
        vector<GRBVar> variables;
        for (int i = 0; i < (int)lb.size(); ++ i)
        {
            assert(i < bounds.size() && i < ub.size() && i < varTypes.size());
            double lowerbound = lb[i];
            double upperbound = ub[i];
            double objCoeff = coeffs[i];
            char type = GRB_BINARY;
            pair<int,int> source, target;
            int clusterIndex = -1;
            if (ti == typeid(TwoTermRoutingProblem))
            {
                TwoTermRoutingProblem* tmp = dynamic_cast<TwoTermRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(i, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is TwoTermRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
            else if (ti == typeid(TwoTermFlowRoutingProblem))
            {
                TwoTermFlowRoutingProblem* tmp = dynamic_cast<TwoTermFlowRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(i, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is TwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
            else if (ti == typeid(ComplexTwoTermFlowRoutingProblem))
            {
                ComplexTwoTermFlowRoutingProblem* tmp = dynamic_cast<ComplexTwoTermFlowRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(i, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is ComplexTwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }

#ifdef INFO
            if (source.first < 0)
                printf(" x%d", i+1);
            else
                printf(" x%dc%d(%d,%d)->(%d,%d)", i+1, clusterIndex, source.first, source.second, target.first, target.second);
#endif
            switch(bounds[i])
            {
            case LPProblem::FreeBound:
                lowerbound = std::numeric_limits<double>::lowest();
                upperbound = std::numeric_limits<double>::max();
#ifdef INFO
                printf(" free ");
#endif
                break;
            case LPProblem::LowerBound:
                upperbound = std::numeric_limits<double>::max();
#ifdef INFO
                printf(" lower ");
#endif
                break;
            case LPProblem::UpperBound: 
                lowerbound = std::numeric_limits<double>::lowest();
#ifdef INFO
                printf(" upper ");
#endif
                break;
            case LPProblem::DoubleBound: 
#ifdef INFO
                printf(" double ");
#endif
                break;
            case LPProblem::FixedVariable:
                assert(fabs(lowerbound-upperbound) < 0.001);
#ifdef INFO
                printf(" fixed ");
#endif
                break;
            default:
                throw bounds[i];
            }
            switch(varTypes[i])
            {
            case LPProblem::CV:
                type = GRB_CONTINUOUS;
#ifdef INFO
                printf(" var type: continuous variable");
#endif
                break;
            case LPProblem::IV:
                type = GRB_INTEGER;
#ifdef INFO
                printf(" var type: integer variable");
#endif
                break;
            case LPProblem::BV: 
                type = GRB_BINARY;
#ifdef INFO
                printf(" var type: binary variable");
#endif
                break;
            default:
                throw varTypes[i];
            }
#ifdef INFO
            printf(" Bounds [%f,%f]\n", lb[i], ub[i]);
#endif
            GRBVar x = model.addVar(lowerbound, upperbound, objCoeff, type);
            variables.push_back(x);
        }
        // Integrate new variables
        model.update();

        int sense = 0;
        if (problem->getObjDir() == LPProblem::Minimize)
        {
            sense = GRB_MINIMIZE;
        }
        else
        {
            sense = GRB_MAXIMIZE;
        }
        // Set objective
        GRBLinExpr lexpr;
        for (int i = 0; i < (int)coeffs.size(); ++ i)
        {
            double objCoeff = coeffs[i];
            lexpr += GRBLinExpr(variables[i], objCoeff);
        }

        model.setObjective(lexpr, sense);

        vector<GRBLinExpr> rhsExprs;
        vector<char> rhsSenses;
        problem->getRowBounds(lb, ub, bounds);
#ifdef INFO
        printf("========== Gurobi Row Bounds %d ==========\n", (int)lb.size());
#endif
        for (int i = 0; i < (int)lb.size(); ++ i)
        {
            assert(i < ub.size() && i < bounds.size());
            switch(bounds[i])
            {
            case LPProblem::FreeBound:
#ifdef INFO
                printf("Row %d free ", i+1);
                cout << "Error: " << __FILE__ << ":" << __LINE__ << endl;
                exit(-1);
#endif
                break;
            case LPProblem::LowerBound:
                {
                    GRBLinExpr expr(lb[i]);
                    rhsExprs.push_back(expr);
                    rhsSenses.push_back(GRB_GREATER_EQUAL);
                }
#ifdef INFO
                printf("Row %d lower ", i+1);
#endif
                break;
            case LPProblem::UpperBound: 
                {
                    GRBLinExpr expr(ub[i]);
                    rhsExprs.push_back(expr);
                    rhsSenses.push_back(GRB_LESS_EQUAL);
                }
#ifdef INFO
                printf("Row %d upper ", i+1);
#endif
                break;
            case LPProblem::DoubleBound: 
#ifdef INFO
                printf("Row %d double ", i+1);
                cout << "NOT Supported: " << __FILE__ << ":" << __LINE__ << endl;
                exit(-1);
#endif
                break;
            case LPProblem::FixedVariable:
                {
                    GRBLinExpr expr(lb[i]);
                    rhsExprs.push_back(expr);
                    rhsSenses.push_back(GRB_EQUAL);
                }
#ifdef INFO
                printf("Row %d fixed ", i+1);
#endif
                break;
            default:
                throw bounds[i];
            }
#ifdef INFO
            printf(" bounds: (%g,%g)\n", lb[i], ub[i]);
#endif
        }

        vector<pair<int,int> > conIndex;
        problem->getCoeffs(conIndex, coeffs);
        int size = conIndex.size();
        int consIndex = -1;
        GRBLinExpr initialExpr;
        GRBLinExpr lhsexpr;
        for (int i = 0; i < size; ++i)
        {
            int tmpId = conIndex[i].first;
            if (consIndex < 0 || consIndex != tmpId || i == size-1)
            {
                if (consIndex >= 0 || i == size-1)
                {
                    switch(bounds[consIndex-1])
                    {
                    case LPProblem::FreeBound:
#ifdef INFO
                        printf(" free ");
#endif
                        break;
                    case LPProblem::LowerBound:
#ifdef INFO
                        printf(" lower ");
#endif
                        break;
                    case LPProblem::UpperBound:
#ifdef INFO
                        printf(" up ");
#endif
                        break;
                    case LPProblem::DoubleBound:
#ifdef INFO
                        printf(" double ");
#endif
                        break;
                    case LPProblem::FixedVariable:
#ifdef INFO
                        printf(" fixed ");
#endif
                        break;
                    }
#ifdef INFO
                    printf(" bounds: (%g,%g)\n", lb[consIndex-1], ub[consIndex-1]);
#endif
                    if (i == size-1)
                    {
                        lhsexpr += GRBLinExpr(variables[conIndex[i].second-1], coeffs[i]);
                        pair<int,int> source, target;
                        int clusterIndex = -1;
                        if (ti == typeid(TwoTermRoutingProblem))
                        {
                            TwoTermRoutingProblem* tmp = dynamic_cast<TwoTermRoutingProblem*>(problem);
                            assert(tmp != NULL);
                            tmp->getSourceTarget(conIndex[i].second-1, source, target);
#ifdef INFO
                            cout << "$$$$$$$$$$$ The problem is TwoTermRoutingProblem $$$$$$$$$$$" << endl;
#endif
                        }
                        else if (ti == typeid(TwoTermFlowRoutingProblem))
                        {
                            TwoTermFlowRoutingProblem* tmp = dynamic_cast<TwoTermFlowRoutingProblem*>(problem);
                            assert(tmp != NULL);
                            tmp->getSourceTarget(conIndex[i].second-1, source, target);
#ifdef INFO
                            cout << "$$$$$$$$$$$ The problem is TwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
                        }
                        else if (ti == typeid(ComplexTwoTermFlowRoutingProblem))
                        {
                            ComplexTwoTermFlowRoutingProblem* tmp = dynamic_cast<ComplexTwoTermFlowRoutingProblem*>(problem);
                            assert(tmp != NULL);
                            tmp->getSourceTarget(conIndex[i].second-1, source, target);
#ifdef INFO
                            cout << "$$$$$$$$$$$ The problem is ComplexTwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
                        }
#ifdef INFO
                        if (source.first < 0)
                            printf(" %+g(x%d)", coeffs[i], conIndex[i].second);
                        else
                            printf(" %+gc%d(%d,%d)->(%d,%d)", coeffs[i], clusterIndex, source.first, source.second, target.first, target.second);
#endif
                    }

                    // Add constraint:
                    model.addConstr(lhsexpr, rhsSenses[consIndex-1], rhsExprs[consIndex-1]);
                    //GRBLinExpr temp(variables[1], 1.0);
                    //GRBLinExpr temp2(1.0);
                    //model.addConstr(temp, GRB_EQUAL, temp2);
                    //model.update();
                    //char file[100];
                    //sprintf(file, "guro%d.lp", i);
                    //model.write(file);
                    //exit(0);
#ifdef INFO
                    printf("Gurobi added one constraint: %d terms\n", (int)lhsexpr.size());
#endif
                    lhsexpr = initialExpr;
                }
                if (i == size-1)
                    break;

                consIndex = tmpId;
#ifdef INFO
                printf("Constraint %d: ", consIndex);
#endif
            }

            lhsexpr += GRBLinExpr(variables[conIndex[i].second-1], coeffs[i]);

            pair<int,int> source, target;
            int clusterIndex = -1;
            if (ti == typeid(TwoTermRoutingProblem))
            {
                TwoTermRoutingProblem* tmp = dynamic_cast<TwoTermRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(conIndex[i].second-1, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is TwoTermRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
            else if (ti == typeid(TwoTermFlowRoutingProblem))
            {
                TwoTermFlowRoutingProblem* tmp = dynamic_cast<TwoTermFlowRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(conIndex[i].second-1, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is TwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
            else if (ti == typeid(ComplexTwoTermFlowRoutingProblem))
            {
                ComplexTwoTermFlowRoutingProblem* tmp = dynamic_cast<ComplexTwoTermFlowRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(conIndex[i].second-1, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is ComplexTwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
#ifdef INFO
            if (source.first < 0)
                printf(" %+g(x%d)", coeffs[i], conIndex[i].second);
            else
                printf(" %+gc%d(%d,%d)->(%d,%d)", coeffs[i], clusterIndex, source.first, source.second, target.first, target.second);
#endif
        }

        model.update();
        //model.write("gurobi.lp");
        // Optimize model
        model.optimize();

        vars.push_back(0);
        for (int i = 0; i < (int)variables.size(); i++)
        {
            float value = variables[i].get(GRB_DoubleAttr_X);
            vars.push_back(value);

            pair<int,int> source, target;
            //((SteinerRoutingProblem*)problem)->getSourceTarget(i-1, source, target);
            if (ti == typeid(TwoTermRoutingProblem))
            {
                TwoTermRoutingProblem* tmp = dynamic_cast<TwoTermRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(i, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is TwoTermRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
            else if (ti == typeid(TwoTermFlowRoutingProblem))
            {
                TwoTermFlowRoutingProblem* tmp = dynamic_cast<TwoTermFlowRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(i, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is TwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
            else if (ti == typeid(ComplexTwoTermFlowRoutingProblem))
            {
                ComplexTwoTermFlowRoutingProblem* tmp = dynamic_cast<ComplexTwoTermFlowRoutingProblem*>(problem);
                assert(tmp != NULL);
                tmp->getSourceTarget(i, source, target);
#ifdef INFO
                cout << "$$$$$$$$$$$ The problem is ComplexTwoTermFlowRoutingProblem $$$$$$$$$$$" << endl;
#endif
            }
#ifdef INFO
            printf("x[%d] = %g (%d,%d)->(%d,%d)\n", i, value, source.first, source.second, target.first, target.second);
#endif
        }
        cout << "Obj: " << model.get(GRB_DoubleAttr_ObjVal) << endl;
    } catch(GRBException e) {
        cout << "Error code = " << e.getErrorCode() << endl;
        cout << e.getMessage() << endl;
    } catch(...) {
        cout << "Exception during optimization" << endl;
    }
}

void FlowSolver::testGLPK()
{
    glp_prob *lp;
    int ia[1+1000], ja[1+1000];
    double ar[1+1000], z, x1, x2, x3;
    lp = glp_create_prob();
    glp_set_prob_name(lp, "sample");
    glp_set_obj_dir(lp, GLP_MAX);
    glp_add_rows(lp, 3);
    glp_set_row_name(lp, 1, "p");
    glp_set_row_bnds(lp, 1, GLP_UP, 0.0, 100.0);
    glp_set_row_name(lp, 2, "q");
    glp_set_row_bnds(lp, 2, GLP_UP, 0.0, 600.0);
    glp_set_row_name(lp, 3, "r");
    glp_set_row_bnds(lp, 3, GLP_UP, 0.0, 300.0);
    glp_add_cols(lp, 3);
    glp_set_col_name(lp, 1, "x1");
    glp_set_col_bnds(lp, 1, GLP_LO, 0.0, 0.0);
    glp_set_obj_coef(lp, 1, 10.0);
    glp_set_col_name(lp, 2, "x2");
    glp_set_col_bnds(lp, 2, GLP_LO, 0.0, 0.0);
    glp_set_obj_coef(lp, 2, 6.0);
    glp_set_col_name(lp, 3, "x3");
    glp_set_col_bnds(lp, 3, GLP_LO, 0.0, 0.0);
    glp_set_obj_coef(lp, 3, 4.0);
    ia[1] = 1, ja[1] = 1, ar[1] =  1.0; /* a[1,1] =  1 */
    ia[2] = 1, ja[2] = 2, ar[2] =  1.0; /* a[1,2] =  1 */
    ia[3] = 1, ja[3] = 3, ar[3] =  1.0; /* a[1,3] =  1 */
    ia[4] = 2, ja[4] = 1, ar[4] = 10.0; /* a[2,1] = 10 */
    ia[5] = 3, ja[5] = 1, ar[5] =  2.0; /* a[3,1] =  2 */
    ia[6] = 2, ja[6] = 2, ar[6] =  4.0; /* a[2,2] =  4 */
    ia[7] = 3, ja[7] = 2, ar[7] =  2.0; /* a[3,2] =  2 */
    ia[8] = 3, ja[8] = 3, ar[8] =  6.0; /* a[3,3] =  6 */
    glp_load_matrix(lp, 8, ia, ja, ar);
    glp_simplex(lp, NULL);
    z = glp_get_obj_val(lp);
    x1 = glp_get_col_prim(lp, 1);
    x2 = glp_get_col_prim(lp, 2);
    x3 = glp_get_col_prim(lp, 3);
#ifdef INFO
    printf("\nz = %g; x1 = %g; x2 = %g; x3 = %g\n", z, x1, x2, x3);
#endif
    glp_delete_prob(lp);
}

