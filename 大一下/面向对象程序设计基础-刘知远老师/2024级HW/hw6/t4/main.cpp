#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include <sstream>
#include <cassert>
#include"TextProcessor.h"
using namespace std;

int main()
{
    TextProcessor a("abcdefgh");
    cout<<a.getText()<<endl;
    a.setText("hgfedcba");
    cout<<a.getText()<<endl;
    TextProcessor b("Ab Cd Ef Gh");
    cout<<b.removeSpaces()<<endl;
    cout<<b.toLowerCase()<<endl;
    cout<<b.toUpperCase()<<endl;
    cout<<b.reverse()<<endl; 
    TextProcessor c("Ab Cd Ef Gh hgfedcba Ab Cd Ef Gh");
    cout<<c.countOccurrences("Ab")<<endl;  
    cout<<c.findPositions("Ab").size()<<endl<<c.findPositions("Ab")[1]<<endl;  
    cout<<c.replaceAll("Ab","Ba")<<endl; 
    cout<<b.getCharCount()<<endl;
    cout<<b.getCharCountNoSpaces()<<endl;
    cout<<b.getLineCount()<<endl;
    TextProcessor d("a bcdef gH hgfeD cba");
    cout<<d.isPalindrome()<<endl;
    cout<<a.isPalindrome()<<endl;
    TextProcessor e("-114.514");
    TextProcessor f("3.14159.26532");
    TextProcessor g("-.");
    cout<<e.isNumeric()<<endl;
    cout<<f.isNumeric()<<endl;
    cout<<d.containsOnly("abcdefgh")<<endl;
    cout<<b.containsOnly("abcdefgh")<<endl;
    cout<<a.centerAlign(15,'1')<<endl;
    cout<<a.leftAlign(12,'1')<<endl;
    cout<<a.rightAlign(12)<<endl;
    return 0;
}
/*
以下为输出参考
abcdefgh
hgfedcba
AbCdEfGh
ab cd ef gh
AB CD EF GH
hG fE dC bA
2
2
21
Ba Cd Ef Gh hgfedcba Ba Cd Ef Gh
11
8
1
1
0
1
0
0
0
111hgfedcba1111
hgfedcba1111
    hgfedcba
*/
