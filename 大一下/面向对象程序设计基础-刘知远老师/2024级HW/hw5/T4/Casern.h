#pragma once
#include "Footman.h"
#include "Commander.h"
#include "Belong.h"
#include <vector>


class Casern {
    
public:
    std::vector<Footman*> footmans_;
    std::vector<Commander*> commanders_;
    std::vector<Belong*> belongs_;
    virtual std::string getKind() = 0;
	//TODO
    virtual void addFootman(Footman* f) = 0;
    virtual void addCommander(Commander* ) = 0;
    virtual void addBelong(Belong* ) = 0;
    virtual Footman* getFootmanbyIndex(int idx)const=0;
    virtual Commander* getCommanderbyIndex(int idx)const=0;
    virtual Belong* getBelongbyIndex(int idx)const=0;
};