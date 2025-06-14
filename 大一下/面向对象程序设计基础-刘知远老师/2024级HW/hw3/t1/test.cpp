#include <iostream>
using namespace std;

class Base {
public:
    virtual void func1() {
        cout << "Base::func1()" << endl;
    }
    void func2() {
        cout << "Base::func2()" << endl;
    }
};

class Derived : public Base {
public:
    void func1() {
        cout << "Derived::func1()" << endl;
    }
    virtual void func2() {
        cout << "Derived::func2()" << endl;
    }
};

int main() {
    Base *basePtr = new Derived();
    basePtr->func1();
    basePtr->func2();
    delete basePtr;
    return 0;
}