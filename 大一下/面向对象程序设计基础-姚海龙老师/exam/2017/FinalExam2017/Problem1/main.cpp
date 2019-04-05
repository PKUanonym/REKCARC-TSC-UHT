#include <iostream>
#include <string>
#include <vector>
#include <cstdio>
#include "MyTrie.h"

using namespace std;

int main()
{
    MyTrie *trie = new MyTrie();

    //add code here to randomly generate 30 character strings
    // and then insert the character strings into trie
    //......
    //search other prefixes instead of "a" if needed
    trie->searchSubStr("a");
    //print all the matches to standard output by cout/printf
    //You may determine the output format
    trie->printMatches();

    //destruct the trie
    delete trie;

    return 0;
}
