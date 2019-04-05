#include "BaseRouter.h"
#include "OptRouter.h"

int main()
{
    int row = 10;
    int col = 10;
    Point source(1,1);
    Point target(4,4);
    
    PointVector obsVec;
    Point obs(1,4);
    obsVec.push_back(obs);
    obs.setX(4);
    obs.setY(1);
    obsVec.push_back(obs);
    obs.setX(1);
    obs.setY(3);
    obsVec.push_back(obs);
    obs.setX(3);
    obs.setY(4);
    obsVec.push_back(obs);
    
    BaseRouter router(row, col, source, target, obsVec);
    router.route();
    
    OptRouter opeRouter(row, col, source, target, obsVec);
    opeRouter.route();
    
    return 0;
}
