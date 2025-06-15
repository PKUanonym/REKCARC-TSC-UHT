#include "PyObject.h"
#include <iostream>

int main() {
    PyObject p;
    p = 1;
    p = 'c';
    char c = p;
    std::cout << c << std::endl;
    p = 1.0;
    int u = 2;
    p = u;
    p = 1ll;
}
