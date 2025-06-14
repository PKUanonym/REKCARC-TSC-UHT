#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include <sstream>
#include <cassert>
#include <regex>


int main(){
    
    std::string text_("dsafsgfasd*dsadaAAAAff*d*ads\ndsad");
    char delimiter = '*';
    std::vector<std::string> ss;
    std::stringstream s(text_);
    std::string substr;
    while(std::getline(s, substr, delimiter)){
        ss.push_back(substr);
    }
    for(auto s: ss)std::cout<<s<<std::endl;
    return 0;
}