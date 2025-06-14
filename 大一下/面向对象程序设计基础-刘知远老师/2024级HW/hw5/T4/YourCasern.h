#pragma once

#include "Footman.h"
#include "Commander.h"
#include "Belong.h"
#include "Casern.h"

class HumanFootman :  public Footman {
public:
    HumanFootman(std::string _footmanId): Footman(_footmanId){
    };
    virtual std::string getFootmanId() {return Footman::getFootmanId();}
};

class OrcFootman :  public Footman {
public:
    OrcFootman(std::string _footmanId): Footman(_footmanId){
    };
    virtual std::string getFootmanId() {return Footman::getFootmanId();}
};

class HumanCommander :  public Commander {
public:
    HumanCommander(std::string _commanderId): Commander(_commanderId){};
    virtual std::string getCommanderId() {return Commander::getCommanderId();}
};

class OrcCommander :  public Commander {
public:
    OrcCommander(std::string _commanderId): Commander(_commanderId){};
    virtual std::string getCommanderId() {return Commander::getCommanderId();}
};

class HumanBelong :  public Belong {
public:
    HumanBelong(Footman* f, Commander* c): Belong(f, c){}
};

class OrcBelong :  public Belong {
public:
    OrcBelong(Footman* f, Commander* c): Belong(f, c){}
};

class HumanCasern : public Casern {
public:
    std::string getKind(){
        std::string s("HumanCasern");
        return s;
    }
    void addFootman(Footman* f)override{
        footmans_.push_back(f);
    }
    void addCommander(Commander* c)override{
        commanders_.push_back(c);
    }
    void addBelong(Belong* b)override{
        belongs_.push_back(b);
    }
    Footman* getFootmanbyIndex(int idx)const{
        if(idx < footmans_.size())return footmans_[idx];
        return nullptr;
    }
    Commander* getCommanderbyIndex(int idx)const{
        if(idx < commanders_.size())return commanders_[idx];
        return nullptr;
    }
    Belong* getBelongbyIndex(int idx)const{
        if(idx < belongs_.size())return belongs_[idx];
        return nullptr;
    }
};

class OrcCasern : public Casern {
public:
	std::string getKind(){
        std::string s("OrcCasern");
        return s;
    }
    void addFootman(Footman* f)override{
        footmans_.push_back(f);
    }
    void addCommander(Commander* c)override{
        commanders_.push_back(c);
    }
    void addBelong(Belong* b)override{
        belongs_.push_back(b);
    }
    Footman* getFootmanbyIndex(int idx)const{
        if(idx < footmans_.size())return footmans_[idx];
        return nullptr;
    }
    Commander* getCommanderbyIndex(int idx)const{
        if(idx < commanders_.size())return commanders_[idx];
        return nullptr;
    }
    Belong* getBelongbyIndex(int idx)const{
        if(idx < belongs_.size())return belongs_[idx];
        return nullptr;
    }
};
