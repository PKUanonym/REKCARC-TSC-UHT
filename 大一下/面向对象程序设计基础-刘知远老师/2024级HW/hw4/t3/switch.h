#pragma once
#include <vector>
using namespace std;


template<typename T>
class Branch{
public:
    Branch(T flag, void(*op)(int&), int* target, bool shouldBreak){
        this->flag = flag;
        this->op = op;
        this->target = target;
        this->shouldBreak = shouldBreak;
    }
    void execute(){
        op(*target);
    }
    T flag;
    void (*op)(int&);
    int* target;
    bool shouldBreak;
};

template<typename T>
class MySwitch{
public:
    vector<Branch<T>> cases;
    void addCase(T flag, void(*op)(int&), int* target, bool shouldBreak){
        cases.push_back(Branch<T>(flag, op, target, shouldBreak));
    }
    void execute(T value){
        for(int i = 0; i< cases.size(); ++i){
            if(value == cases[i].flag){
                cases[i].execute();
                if(cases[i].shouldBreak)break;
            }
        }
    }
};