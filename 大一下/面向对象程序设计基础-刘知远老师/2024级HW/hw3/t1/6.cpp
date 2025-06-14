#include <iostream>
using namespace std;

class Base {
public:
    virtual void print() {
        cout << "Base class" << endl;
    }
};

class Derived : public Base {
public:
    int a;
    void print() override {
        cout << "Derived class" << endl;
    }
};

int main() {
    Base* base = new Base();
    Derived* derived = new Derived();

    Base* bp = dynamic_cast<Base*>(derived);
    Derived* dp = static_cast<Derived*>(base);
// 当静态转型时，尽管dp是derived类型的指针，但它内核还是base类
// 当动态转型时，发现这是一个指向基类对象的指针，向上转型失败返回nullptr
    bp->print();
    dp->print();
    cout<<dp->a;
// dp中的a是一个随机数字
    delete base;
    delete derived;

    return 0;
}