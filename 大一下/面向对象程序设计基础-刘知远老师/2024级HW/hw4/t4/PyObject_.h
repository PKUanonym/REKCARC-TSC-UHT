#pragma once
#include <iostream>
#include <utility>
#include <type_traits>
using namespace std;
class Base
{
public:
    bool is_owning = false;
    virtual ~Base() = default;
};


template <typename T>
class Derived : public Base
{
public:
    T *data;
    Derived() : data(nullptr) {}
    Derived(T *d) : data(d) {}
    ~Derived() = default;
};


class PyObject
{
    int i;
    char c;
    double d;

public:
    Base *test;
    PyObject() : test(nullptr) {};
    PyObject(const PyObject &p)
    {
        if (p.test)
        {
            test = new Derived<PyObject>(new PyObject(p));
            test->is_owning = false;
        }
        else
        {
            test = nullptr;
        }
    }
    PyObject(PyObject &&p) noexcept
    {
        test = p.test;
        p.test = nullptr;
        test->is_owning = false; //????
    }
    PyObject &operator=(const PyObject *p) // 拷贝赋值运算符
    {
        if (this != p)
        {
            // if (test && test->is_owning)
            // delete test;
            test = p->test;
            if (test)
            {
                cout << "PyObject got a value" << endl;
                cout << "Borrowing" << endl;
            }
        }
        return *this;
    }
    template <typename T>
    PyObject &operator=(T &&t) noexcept
    {
        // if (test && test->is_owning)
        // delete test;
        cout << "PyObject got a value" << endl;
        test = new Derived<T>(new T(forward<T>(t)));
        test->is_owning = true;
        // typedef typename std::remove_cv<typename std::remove_reference<T>::type>::type RawT;
        cout << "Owning" << endl;
        return *this;
    }
    template <typename T>
    PyObject &operator=(T &t)
    {
        // if (test && test->is_owning)
        // delete test;
        this->test = new Derived<T>(new T(t));
        cout << "PyObject got a value" << endl;
        test->is_owning = false;
        cout << "Borrowing" << endl;
        return *this;
    }
    PyObject &operator=(char c)
    {
        this->c = c;
        return *this;
    }
    operator char() const { return c; }
    operator double() const { return d; }
    operator int() const { return i; }
    template <typename T>
    operator const T &() const
    {
        return *dynamic_cast<Derived<T> *>(test)->data;
    }
    ~PyObject()
    {
        if (test && test->is_owning)
        {
            delete test;
        }
    }
};