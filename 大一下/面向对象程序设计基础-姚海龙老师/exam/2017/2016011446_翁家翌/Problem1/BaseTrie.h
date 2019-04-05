#ifndef BASETRIE_H_INCLUDED
#define BASETRIE_H_INCLUDED

#include <vector>
#include <string>
#include <cstdlib>
#include <iostream>

struct TrieNode
{
    const static int CHILDNUM = 26;
    TrieNode(): value_(-1)
    {
        for (int i = 0; i < CHILDNUM; ++i)
        {
            next_[i] = NULL;
        }
    }
    int value_;
    TrieNode *next_[CHILDNUM];
};

class BaseTrie
{
protected:
    void destruct(TrieNode *p);
    TrieNode *pRoot_;
    void traverse(TrieNode *p, std::string str);
public:
    BaseTrie(): pRoot_(NULL) {}
    void insert(const char *s, int value);
    int search(const char *s);
    void searchSubStr(const char *s);
    virtual void searchString(std::string &str, int &value) = 0;
    ~BaseTrie()
    {
        destruct(pRoot_);
        delete pRoot_;
        std::cout<<"Destruction done."<<std::endl;
    }
};

#endif // BASETRIE_H_INCLUDED
