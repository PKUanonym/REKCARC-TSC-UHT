#include <iostream>
#include <string>
#include <sstream>
using namespace std;

string sha1pad(const string &str)//sha1填充
{
    string astr=str;
    astr+=(char)(0x80);
    while ((astr.size()<<3) % 512 != 448)
    {
        astr+=(char)0;
    }
    for (int i=56;i>=0;i-=8)
    {
        astr+=(char)((str.size()<<3)>>i);
    }
    return astr;
}

unsigned ROTL(const unsigned &word,const int &num)//word循环左移num位
{
    return (word<<num)|(word>>(32-num));
}

unsigned sha1f(const unsigned &B,const unsigned &C,const unsigned &D,const unsigned &t)
{
    switch(t/20)
    {
    case 0:
        return (B&C)|((~B)&D);
    case 2:
        return (B&C)|(B&D)|(C&D);
    case 1:
    case 3:
        return B^C^D;
    default:
        return 0;
    }
}

string sha1(const string &str)
{
    string strs=str;
    const unsigned K[4]={0x5a827999,0x6ed9eba1,0x8f1bbcdc,0xca62c1d6};
    unsigned H[5]={0x67452301,0xefcdab89,0x98badcfe,0x10325476,0xc3d2e1f0};
    unsigned W[80]={0};
    for (int i=0;i<strs.size();i+=64)
    {
        for (int j=0;j<16;j++)
        {
            W[j]=((unsigned)strs[i+4*j]&0xff)<<24|
                 ((unsigned)strs[i+4*j+1]&0xff)<<16|
                 ((unsigned)strs[i+4*j+2]&0xff)<<8|
                 ((unsigned)strs[i+4*j+3]&0xff);
        }
        for (int t=16;t<80;t++)
        {
            W[t]=ROTL(W[t-3]^W[t-8]^W[t-14]^W[t-16],1);
        }
        unsigned A=H[0];
        unsigned B=H[1];
        unsigned C=H[2];
        unsigned D=H[3];
        unsigned E=H[4];
        for (int t=0;t<80;t++)
        {
            unsigned temp=ROTL(A,5)+sha1f(B,C,D,t)+E+W[t]+K[t/20];
            E=D;
            D=C;
            C=ROTL(B,30);
            B=A;
            A=temp;
        }
        H[0]+=A;
        H[1]+=B;
        H[2]+=C;
        H[3]+=D;
        H[4]+=E;
    }
    stringstream ss;
    ss<<hex<<H[0]<<H[1]<<H[2]<<H[3]<<H[4];
    ss>>strs;
    return strs;
}

int main()
{
    string str;
    cout<<"input a string:"<<endl;
    //cin>>str;
    //str="";
    for (int i=0;i<1000000;i++)
    {
        str+='a';
    }
        
    string astr=sha1pad(str);
    cout<<"SHA-1:"<<sha1(astr)<<endl;
    return 0;
}
