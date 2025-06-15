#pragma once
#include <vector>
#include <iostream>

class Part{
public:
    int value;
    Part(int id): value(id){}
};

class Robot{
public:
    virtual bool is_full() = 0;
    virtual void add_part(Part&& p) = 0;
    virtual int run() = 0;
};
