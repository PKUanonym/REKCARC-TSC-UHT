#pragma once
#include "weapon.hpp"
using namespace std;

class WeaponSlot {
public:
    Weapon* w;
    WeaponSlot(){
        w = nullptr;
    }
    void create_weapon(int p){
        w = new Weapon(p);
    }
    void add_spell(int a){
        w->spells.push_back(a);
    }
    int calc_damage_typeA(int d){
        int low_d = 0;
        if(d > w->penetration)low_d = d - w->penetration;
        int at = 0;
        for(int i : w->spells){
            if(i > low_d)at += i - low_d;
        }
        return at;
    }
    int calc_damage_typeB(){
        int d = 0;
        int at = 0;
        for(int i : w->spells){
            int low_d = 0;
            if(d > w->penetration)low_d = d - w->penetration;
            if(i > low_d)at += i - low_d;
            d++;
        }
        return at;
    }
    int calc_damage_typeC(){
        int d = 0;
        int at = 0;
        for(int i : w->spells){
            int low_d = 0;
            if(d > w->penetration)low_d = d - w->penetration;
            if(i > low_d){
                if((i - low_d) % 2 == 0){
                    at += (i - low_d) / 2;
                }else{
                    at += i - low_d;
                    d++;
                }
            }
        }
        return at;
    }   
    WeaponSlot& operator=(WeaponSlot&& ws){
        w = ws.w;
        ws.w = nullptr;
        return *this;
    }
    WeaponSlot& operator=(const WeaponSlot& ws){
        w = new Weapon(ws.w->penetration);
        for(int i = 0; i< ws.w->spells.size(); ++i){
            if(ws.w->spells[i] % 2 == 0)
                w->spells.push_back(ws.w->spells[i]);
        }
        return *this;
    }
    ~WeaponSlot(){
        if(w!=nullptr)delete w;
    }
};
