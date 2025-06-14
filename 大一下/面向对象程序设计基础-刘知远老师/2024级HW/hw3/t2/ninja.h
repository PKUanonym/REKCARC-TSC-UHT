#pragma once
#include "dragon.h"
#include "weapon.h"

using namespace std;
class Ninja{
public:
    Dragon *d = nullptr;
    Weapon *w = nullptr;
    Ninja(){}
    Ninja(string dd, string ww){        
        d = new Dragon(dd);
        w = new Weapon(ww);
        cout<<"Ninja is coming!\n";}
    virtual void describe(){
        cout<<"Ninja is with "<<d->get_name()<<" and "<<w->get_name()<<".\n";
    }
    virtual ~Ninja(){
        delete d, w;
    }
};