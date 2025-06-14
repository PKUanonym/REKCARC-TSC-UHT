#pragma once
#include "dragon.h"
#include "weapon.h"
#include "ninja.h"

using namespace std;
class FireNinja: public Ninja{
    
public:
    FireNinja(string dd, string ww){
        d = new Dragon(dd);
        w = new Weapon(ww);
        cout<<"Fire ninja is coming!\n";
    }
    void describe(){
        cout<<"Fire ninja is with "<<d->get_name()<<" and "<<w->get_name()<<".\n";
    }
    void fire_power(){
        cout<<"I will burn the night!\n";
    }
};