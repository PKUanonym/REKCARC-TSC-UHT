#pragma once
#include "Pair.h"
#include <vector>
class Map{
    Pair * data;
    vector<string> keys;
    int sz;
    int max_size;
public:
    Map(int n): max_size(n), sz(0){
        data = new Pair[n];
    }
    int& operator[](string key){
        
        for(int i = 0; i< sz; ++i){
            if(keys[i] == key){
                return (data + i)->getVal();
            }
        }
        
        keys.push_back(key);
        (data + sz)->reset(key, 0);
        return (data + sz++)->getVal();
    }
    int operator[](string key)const{
        for(int i = 0; i< sz; ++i){
            if(keys[i] == key){
                return (data + i)->getVal();
            }
        }
        return 0;
    }
    int size()const{
        return sz;
    }
    ~Map(){
        delete[] data;
    }
    // TODO
};