#include "Pair.h"
#include <string>
#include <iostream>
using namespace std;

int Pair::n_create = 0;
int Pair::n_free = 0;

Pair::Pair():val(0){
    ++Pair::n_create;
}

void Pair::reset(string k, int v){
    key = k;
    val = v;
}

bool Pair::hasKey(string k){
    return key == k;
}

int & Pair::getVal(){
    return val;
}

Pair::~Pair(){
    --Pair::n_free;
}