#include "BaseTrie.h"
#include <stack>
#include <cassert>
using namespace std;

void BaseTrie::insert(const char *s, int value)
{
    TrieNode *p = NULL;
    if (!(p = pRoot_))
        p = pRoot_ = new TrieNode();
    int i = 0, k = 0;
    while(s[i])
    {
        k = s[i++] - 'a';
        if (!p->next_[k])
            p->next_[k] = new TrieNode();
        p = p->next_[k];
    }
    p->value_ = value;
}

int BaseTrie::search(const char *s)
{
    TrieNode *p = NULL;
    if(!( p = pRoot_))
        return -1;
    int i = 0, k = 0;
    while(s[i])
    {
        k = s[i++] - 'a';
        if (p->next_[k] == NULL)
            return -1;
        p = p->next_[k];
    }
    return p->value_;
}

void BaseTrie::searchSubStr(const char *s)
{
    TrieNode *p = NULL;
    if(!( p = pRoot_))
        return;
    int i = 0, k = 0;
    while(s[i])
    {
        k = s[i++] - 'a';
        if (p->next_[k] == NULL)
            return;
        p = p->next_[k];
    }
    //enumerate all the children
    string str = s;
    traverse(p, str);
}

void BaseTrie::traverse(TrieNode *p, string str)
{
    if (p->value_ >= 0)
    {
        searchString(str, p->value_);
    }
    for (int i = 0; i < TrieNode::CHILDNUM; ++i)
    {
        if (p->next_[i])
        {
            char c = 'a' + i;
            traverse(p->next_[i], (str + c));
        }
    }
}

void BaseTrie::destruct(TrieNode *p)
{
    for(int i = 0; i < TrieNode::CHILDNUM; ++i)
    {
        if(p->next_[i])
            destruct(p->next_[i]);
        delete p->next_[i];
    }
}