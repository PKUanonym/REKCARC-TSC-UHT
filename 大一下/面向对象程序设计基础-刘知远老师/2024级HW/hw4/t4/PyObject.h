#pragma once
#include <iostream>
using namespace std;
class PyObject;

class Base{//base类负责存储基本类型，同时担当一个指向不同种类派生类的基类指针的作用
public:
    int type;//0:int 1:char 2:double
    int a;
    char c;
    double d;
    virtual int get_type()const{return type;}
    virtual int is_owned()const{return -1;}
    virtual void change_owned(bool o){}
    virtual Base* clone(){
        Base* b = new Base();
        b->a = a;
        b->c = c;
        b->d = d;
        b->type = type;
        return b;
    }
    virtual ~Base(){}
};

template<typename T>
class Derived: public Base{
public:
    T* value;
    bool owned;
    Derived(T& v): value(&v), owned(false) {
        cout << "Borrowing" << endl;
    }
    Derived(T&& v): value(new T(std::move(v))), owned(true) {
        cout << "Owning" << endl;
    }
    
    int get_type()const{//-1 表示非基本类型
        return -1;
    }
    int is_owned()const{
        return owned;
    }
    Base* clone(){//易错点：对于Base指针克隆时，应当选择复制，而非直接复制指针，以避免对一块区域重复delete
        Base* t = new Derived<T>(*value);
        return t;
    }
    void change_owned(bool o){
        owned = o;
    }
    ~Derived(){
        if(owned && value)delete value;
    }
};


class PyObject{
public:
    Base* data;
    PyObject(){
        data = new Base();
    }

    template<typename T>
    PyObject& operator=(T&& value){
        cout<<"PyObject got a value"<<endl;
        if(data)delete data;
        data = new Derived<T>(std::forward<T>(value));
        return *this;
    }

    template<typename T>
    PyObject& operator=(T& value){
        cout<<"PyObject got a value"<<endl;
        if(data)delete data;
        data = new Derived<T>(value);
        return *this;
    }

    PyObject& operator=(PyObject& p){
        cout<<"PyObject got a value"<<endl;
        if(p.data->is_owned() == -1){//基本类型
            if(data)delete data;
            data = new Base(*p.data);

        }else if(p.data->is_owned() == 0){//没有对非基本类型的所有权
            if(data)delete data;
            data = p.data->clone();

        }else if(p.data->is_owned() == 1){//有对非基本类型的所有权
            if(data)delete data;
            data = p.data->clone();
            p.data->change_owned(false);
        }
        return *this;
    }

    PyObject& operator=(PyObject* p){
        cout<<"PyObject got a value"<<endl;
        if(data)delete data;
        data = p->data->clone();
        data->change_owned(false);
        //cout<<"Borrowing"<<endl;
        return *this;
    }

    PyObject& operator=(int value){
        if(data)delete data;
        data = new Base();
        data->type = 0;
        data->a = value;
        cout<<"PyObject got a value"<<endl;
        return *this;
    }
    PyObject& operator=(long long value){
        cout<<"PyObject got a value"<<endl;
        if(data)delete data;
        data = new Base();
        data->type = 0;
        data->a = value;
        
        return *this;
    }
    PyObject& operator=(char value){
        cout<<"PyObject got a value"<<endl;
        if(data)delete data;
        data = new Base();
        data->type = 1;
        data->c = value;
        return *this;
    }
    PyObject& operator=(double value){
        cout<<"PyObject got a value"<<endl;
        if(data)delete data;
        data = new Base();
        data->type = 2;
        data->d = value;
        return *this;
    }

    operator int(){
        if(data->get_type() == 0)return data->a;
        return 0;
    }
    operator char(){
        if(data->get_type() == 1)return data->c;
        return 0;
    }
    operator double(){
        if(data->get_type() == 2)return data->d;
        return 0.0;
    }

    template<typename T>// const T& 与 T& 不冲突
    operator const T&(){
        Derived<T>* ptr = dynamic_cast<Derived<T>*>(data);
        if(ptr && ptr->value){
            return *(ptr->value);
        }
        else{
            throw std::bad_cast();
        }
    }

    template<typename T>
    operator T&(){
        Derived<T>* ptr = dynamic_cast<Derived<T>*>(data);
        if(ptr && ptr->value){
            return *(ptr->value);
        }
        else{
            throw std::bad_cast();
        }
    }

    ~PyObject(){
        delete data;
    }
    
};


