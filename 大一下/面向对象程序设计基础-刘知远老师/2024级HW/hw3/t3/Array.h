#pragma once
#include <string>
#include "Node.h"
using namespace std;

class Array{
public:
    int len;
    Node *nodes = nullptr;
    Array(int len){
        this->len = len;
        nodes = new Node[len];
    }
    Array(Array&& a){
        this->len = a.len;
        nodes = a.nodes;
        a.nodes = nullptr;
    }
    Array(const Array& a){
        this->len = a.len;
        nodes = new Node[len];
        for(int i = 0; i< len; ++i){
            Node *now = nodes + i;
            *now = a.get_node(i);
        }
    }
    Array& operator=(Array&& a){
        this->len = a.len;
        this->nodes = a.nodes;
        a.nodes = nullptr;
        return *this;
    }
    Array& operator=(const Array& a){
        this->len = a.len;
        for(int i = 0; i< len; ++i){
            Node *now = nodes + i;
            *now = a.get_node(i);
        }
        return *this;
    }
    Node& operator[](int index){
        return *(nodes + index);
    }
    Node& get_node(int index)const{
        return *(nodes + index);
    }
    ~Array(){
        delete[] nodes;
    }

};