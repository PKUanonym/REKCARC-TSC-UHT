#include "PyObject.h"
#include <iostream>

class Test {
public:
    int data;
};

int main() {
    PyObject p;
    Test t;
    t.data = 5;
    p = t;
    std::cout << ((Test) p).data << std::endl;
}
