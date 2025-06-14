#include "Test.h"
#include <iostream>
using namespace std;

Test f1(Test a){
    //先调用拷贝构造，利用实参构造a
    a.print("a");
    return a;//将a移动给return，return再将值移动给外面的值；然后再逐步销毁
}
Test& f2(Test& b){
    //这里由于只是传了引用，因此不执行任何操作
    b.print("b");
    return b;
}
void f3(Test& a, Test& b){
    //首先利用std::move将a转换为右值，再利用Test的右值构造函数构造c
    Test c = std::move(a);

    //这里都用了参数为左值的运算符重载，无任何提示
    a = std::move(b);
    b = std::move(c); 
}
//整个过程中由于只在f1中拷贝构造的a能存活，且出生顺序为a,b,a'.而在f3中我们利用中间变量c悄悄进行了一次ab的交换，所以实际上析构顺序表现为out文件里那样
//注意，题目中给定的Test.h中的参数为常值引用的运算符重载偷偷使用了一次new操作，因此不对，只能通过将已有的左值通过std::move转换成右值