#pragma once
#include "event.h"
#include <vector>
#include <iostream>

// Strawberry类和Chocolate类

class Chocolate: public EventInterface{
public:
    /*
    1. 巧克力仅会邀请最后一只一起去逛动物园的草莓巧克力来参加，如果这只巧克力之前从未逛过动物园，则不会邀请任何草莓巧克力。
    2. 巧克力喜欢动物园，因为能看到熊猫，巧克力逛动物园时心情值增加5。
    3. 巧克力逛商场时心情值增加1
    4. 巧克力过生日时心情值增加1，如果这只巧克力邀请了其他草莓巧克力，则心情值再增加5。
    5. 巧克力被其他草莓巧克力邀请参加生日时心情值增加1
    */

    EventInterface* to_invite = nullptr;

    void zoo(EventInterface* other) override{
        this->increase_mood(5);
        to_invite = other;
    }
    
    void shop(EventInterface* other) override{
        this->increase_mood(1);
    }

    void birthday() override{
        this->increase_mood(1);

        if(to_invite){
            this->increase_mood(5);
            to_invite->increase_mood(1);
        }
    }
};

class Strawberry: public EventInterface{
public:
    /*
    1. 草莓会邀请所有曾一起逛商场的草莓巧克力来参加。
    2. 草莓逛动物园时心情值增加1。
    3. 草莓逛商场时心情值增加5。
    4. 草莓过生日时，假设邀请了k只草莓巧克力来参加，则心情值增加k。
    5. 草莓被其他草莓巧克力邀请参加生日时心情值增加1。
    6. 特别地：当和草莓一起逛动物园/商场的是巧克力时，心情值额外增加5
    */

    std::vector<EventInterface*> to_invite;

    void zoo(EventInterface* other) override{
        this->increase_mood(1);

        if(dynamic_cast<Chocolate*>(other) != nullptr){
            this->increase_mood(5);
        }
    }

    void shop(EventInterface* other) override{
        this->increase_mood(5);
        
        if(dynamic_cast<Chocolate*>(other) != nullptr){
            this->increase_mood(5);
        }
        
        bool invited = false;
        for(auto* e: to_invite){
            if(e==other){
                invited = true;
                break;
            }
        }
        if(!invited){
            to_invite.push_back(other);
        }
    }

    void birthday() override{
        this->increase_mood(to_invite.size());
        for(auto* e: to_invite){
            e->increase_mood(1);
        }
    }
};