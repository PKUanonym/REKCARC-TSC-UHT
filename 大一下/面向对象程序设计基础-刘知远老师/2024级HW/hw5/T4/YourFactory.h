#pragma once

#include "AbstractFactory.h"

class HumanFactory: public AbstractFactory
{
public:

    Footman* createFootman(std::string name){
        Footman* man = new HumanFootman(name);
        return man;
    }
    Commander* createCommander(std::string name){
        Commander* man = new HumanCommander(name);
        return man;
    }
    Belong* createBelong(Footman* f, Commander* c){
        Belong* man = new HumanBelong(f, c);
        return man;
    }
    Casern* createCasern(){
        Casern* c = new HumanCasern();
        return c;
    }
};

class OrcFactory : public AbstractFactory {
public: 
    Footman* createFootman(std::string name){
        Footman* man = new OrcFootman(name);
        return man;
    }
    Commander* createCommander(std::string name){
        Commander* man = new OrcCommander(name);
        return man;
    }
    Belong* createBelong(Footman* f, Commander* c){
        Belong* man = new OrcBelong(f, c);
        return man;
    }
    Casern* createCasern(){
        OrcCasern* oc = new OrcCasern();
        return oc;
    }
};
