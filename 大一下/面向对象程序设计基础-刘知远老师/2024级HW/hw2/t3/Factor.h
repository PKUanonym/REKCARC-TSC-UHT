#include <iostream>
using namespace std;

int gcd(int a, int b){
    int k = 1;
    int g = 1;
    while(k <= a & k <= b){
        if(a%k == 0 && b%k == 0)g = k;
        k++;
    }
    return g;
}

class Factor{
public:
    int n;
    int m;
    Factor(){
        n = 1;
        m = 0;
    }
    Factor(int a, int b){
        int g = gcd(a, b);
        m = a / g;
        n = b / g;
    }
    Factor add( const Factor& b){
        int m = this->m * b.n + this->n * b.m;
        int n = this->n * b.n;
        return Factor(m, n);
    }
    Factor multiply(const Factor& b){
        int m = this->m * b.m;
        int n = this->n * b.n;
        return Factor(m, n);
    }
    Factor divide(const Factor& b){
        int m = this->m * b.n;
        int n = this->n * b.m;
        return Factor(m, n);
    }
    int compare(const Factor& b){
        if(this->m == b.m && this->n == b.n)return 0;
        else if(this->m == 0 && b.m == 0)return 0;
        else if(this->m * b.n > this->n * b.m)return 1;
        return -1;
    }
    Factor operator+(const Factor& b){
        return add(b);
    }
    Factor operator*(const Factor& b){
        return multiply(b);
    }
    Factor operator/(const Factor& b){
        return divide(b);
    }
    bool operator<(const Factor& b){
        if(compare(b) == -1)return true;
        return false;
    }
    bool operator>(const Factor& b){
        if(compare(b) == 1)return true;
        return false;
    }
    bool operator==(const Factor& b){
        if(compare(b) == 0)return true;
        return false;
    }
    friend ostream& operator<<(ostream& out, const Factor& a){
        if(a.n==0)out<<"nan";
        else if(a.m==0)out<<"0/1";
        else out<<a.m<<'/'<<a.n;
        return out;
    }
    friend istream& operator>>(istream& in, Factor& a){
        int m, n;
        char k;
        in>>m>>k>>n;
        a = Factor(m, n);
        return in;
    }
};