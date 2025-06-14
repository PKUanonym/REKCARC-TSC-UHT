#include <iostream>
#include "functions.h"
using namespace std;

int main(){
    int a, b;
    cin>>a>>b;
    cout<<custom_sum(a, b);
    #ifdef DEBUG
        ;
    #elif defined(MINUS)
        cout<<'\n'<<custom_minus(a, b);
    #elif defined(PRODUCT)
        cout<<'\n'<<custom_product(a, b);
    #elif defined(DIVIDE)
        cout<<'\n'<<custom_divide(a, b);
    #else
        ;
    #endif
    return 0;
}