#ifndef __MYTRIE_H__
#define __MYTRIE_H__

#include <bits/stdc++.h>
#include "BaseTrie.h"

class MyTrie: public BaseTrie
{
    std::string temp_str;
    std::vector<std::string>str_list;
    std::vector<int>val_list;
public:
    void searchString(std::string &str, int &value);
    void clearResult();
    void printMatches();
    void searchSubStr(const char *s);
};

#endif