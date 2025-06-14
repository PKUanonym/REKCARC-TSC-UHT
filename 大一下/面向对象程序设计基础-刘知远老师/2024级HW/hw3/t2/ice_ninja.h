#pragma once
#include "dragon.h"
#include "weapon.h"
#include "ninja.h"

using namespace std;
class IceNinja: public Ninja{
public:
    IceNinja(string dd, string ww){
        d = new Dragon(dd);
        w = new Weapon(ww);
        cout<<"Ice ninja is coming!\n";
    }
    void describe(){
        cout<<"Ice ninja is with "<<d->get_name()<<" and "<<w->get_name()<<".\n";
    }
    void ice_power(){
        cout<<"You will be the dust of frozen bones!\n";
    }

};