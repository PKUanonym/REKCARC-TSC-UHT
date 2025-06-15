#pragma once
#include "Part.h"

class Bob: public Robot{
public:
    int part_needed;
    std::vector<Part> parts;
    Bob(int p): part_needed(p){}
    bool is_full(){
        return parts.size() == part_needed;
    }
    void add_part(Part&& p){
        parts.push_back(p);
    }
    int run(){
        int sum = 0;
        for(const Part& p: parts){
            sum += p.value * p.value;
        }
        return sum;
    }
    friend std::ostream& operator<<(std::ostream& out, const Bob& bob){
        out<<"Build robot Bob";
        return out;
    }
};