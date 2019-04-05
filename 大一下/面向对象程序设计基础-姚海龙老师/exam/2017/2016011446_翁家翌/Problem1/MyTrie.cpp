#include "MyTrie.h"

void MyTrie::searchString(std::string &str, int &value)
{
    str_list.push_back(str);
    val_list.push_back(value);
}

void MyTrie::clearResult()
{
    str_list.clear();
    val_list.clear();
    temp_str.clear();
}

void MyTrie::printMatches()
{
    std::cout << "Search " << temp_str << " ... " << std::endl;
    std::cout << "Find " << str_list.size() << " string." << std::endl;
    std::vector<std::string>::iterator i;
    std::vector<int>::iterator j;
    for(i=str_list.begin(),j=val_list.begin();i!=str_list.end();++i,++j)
        std::cout << "ID: " << *j << " String:" << *i << std::endl;
    std::cout << std::endl;
}

void MyTrie::searchSubStr(const char *s)
{
    temp_str = std::string(s);
    BaseTrie::searchSubStr(s);
}