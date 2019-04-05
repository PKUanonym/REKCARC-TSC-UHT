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
    srand(time(0));
    for(int i = 1; i <= 30; i++)
    {
        std::string tmp;
        for(int j = 10; j--;)
            tmp += rand() % 26 + 'a';
        trie->insert(tmp.c_str(), i);
        std::cout << "Insert " << tmp << ", ID = " << i << std::endl;
    }
    trie->clearResult();
    //search other prefixes instead of "a" if needed
    trie->searchSubStr("a");
    //print all the matches to standard output by cout/printf
    //You may determine the output format
    trie->printMatches();

    trie->clearResult();
    trie->searchSubStr("b");
    trie->printMatches();

    //destruct the trie
    delete trie;

    return 0;
}
