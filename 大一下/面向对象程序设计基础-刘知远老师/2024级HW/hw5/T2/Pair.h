#pragma once
#include <string>
using namespace std;

class Pair{
    string key;
    int val;
public:
    static int n_create;
    static int n_free;
    Pair();
    void reset(string k, int v);
    bool hasKey(string k);
    int & getVal();
    ~Pair();
};