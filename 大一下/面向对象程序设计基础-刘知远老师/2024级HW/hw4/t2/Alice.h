#pragma once
#include "Part.h"

class Alice: public Robot{
public:
    int part_needed;
    std::vector<Part> parts;
    Alice(int p): part_needed(p){}
    bool is_full(){
        return parts.size() == part_needed;
    }
    void add_part(Part&& p){
        parts.push_back(p);
    }
    int run(){
        int sum = 0;
        for(const Part& p: parts){
            sum += p.value;
        }
        return sum;
    }
    friend std::ostream& operator<<(std::ostream& out, const Alice& alice){
        out<<"Build robot Alice";
        return out;
    }
};