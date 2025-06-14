#include <iostream>
using namespace std;

class Test{
public:
    Test(int i){
        cout<<"Test(int i)\n";
    }
    Test(const Test& t){
        cout<<"Test(const Test& t)\n";
    }
    Test(Test&& t){
        cout<<"Test(Test&& t)\n";
    }
    ~Test(){
        // cout<<"~Test()\n";
    }
};

Test F(Test&& a){
	Test b = a;    // (2)
	const Test& c = b; // (3)
    return c; // (4)
}
int main(){
    Test A = F(1); // (1)
    Test B = std::move(A);
    return 0;
}
