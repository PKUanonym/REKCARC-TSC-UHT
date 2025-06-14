#include <iostream>
#include <vector>
#include "PyObject.h"

class Simple {
public:
    int data;
};


class Test {
private:
    std::vector<int> data;
    int id;
    static int count;
public:
    Test() : id(count) {
        std::cout << "Test " << count << " created" << std::endl;
        count++;
    }

    Test(const Test &t) : id(count), data(t.data) {
        std::cout << "Test " << count << " created by reference" << std::endl;
        count++;
    }

    Test(Test &&t) noexcept: id(t.id), data(std::move(t.data)) {
        std::cout << "Test " << id << " moved by rvalue reference" << std::endl;
    }

    void func(int a) {
        std::cout << "Test " << id << " calling func with " << a << std::endl;
        data.push_back(a);
        std::cout << "data size: " << data.size() << std::endl;
    }

    static int getCount() {
        return count;
    }

    ~Test() {
        std::cout << "Test " << id << " destroyed" << std::endl;
        count--;
    }
};

int Test::count = 0;

// #define subtask4
int main() {
#ifdef subtask1
    PyObject p;
    p = 1;
    std::cout << (int) p << std::endl;
    p = 'c';
    std::cout << (char) p << std::endl;
    char c = p;
    std::cout << c << std::endl;
    p = 1.0;
    std::cout << (double) p << std::endl;
    int u = 2;
    p = u;
    std::cout << (int) p << std::endl;
#endif

#ifdef subtask2
    PyObject p;
    Simple t;
    t.data = 1;
    p = t;
    Simple t2 = p;
    std::cout << ((Simple) p).data << std::endl;
    std::cout << t2.data << std::endl;
#endif

#ifdef subtask3
    PyObject p;
    Simple t;
    t.data = 1;
    p = t;
    std::cout << ((Simple) p).data << std::endl;
    t.data = 2;
    std::cout << ((Simple) p).data << std::endl;
    t.data = 6;
    std::cout << ((Simple) p).data << std::endl;
    char c = 'c';
    p = c;
    std::cout << (char) p << std::endl;
    c = 'd';
    std::cout << (char) p << std::endl;
#endif

#ifdef subtask4
    PyObject p;
    p = std::move(*(new Test));
    ((Test &) p).func(1);
    Test t2 = p;
    ((Test &) p).func(10);
    Test &t3 = p;
    t3.func(100);
    t2.func(1000);
    char c = 'c';
    p = c;
    std::cout << Test::getCount() << std::endl;
    std::cout << (char) p << std::endl;
    p = t2;
    PyObject p1;
    PyObject p2;
    PyObject p3;
    p1 = &p;
    ((Test &) p1).func(1);
    ((Test &) p).func(10);
    p2 = p1;
    ((Test &) p2).func(100);
    p3 = p;
    p = 1;
    ((Test &) p3).func(1001);
    p3 = 1.0;
    std::cout << Test::getCount() << std::endl;
#endif
    return 0;
}