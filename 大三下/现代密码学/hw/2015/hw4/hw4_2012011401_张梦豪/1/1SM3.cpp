#include <iostream>
#include <string>
#include <sstream>
using namespace std;

string sm3pad(const string &str)//Ìî³ä
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

unsigned ROTL(const unsigned &word,const int &num)//wordÑ­»·×óÒÆnumÎ»
{
    return (word<<num)|(word>>(32-num));
}

unsigned T(const unsigned &j)
{
    if (j<=15)
        return 0x79cc4519;
    else
        return 0x7a879d8a;
}

unsigned FF(const unsigned &X,const unsigned &Y,const unsigned &Z,const unsigned &j )
{
    if (j<=15)
        return (X^Y^Z);
    else
        return (X&Y)|(X&Z)|(Y&Z);
}

unsigned GG(const unsigned &X,const unsigned &Y,const unsigned &Z,const unsigned &j )
{
    if (j<=15)
        return (X^Y^Z);
    else
        return (X&Y)|((~X)&Z);
}

unsigned P0(const unsigned &X)
{
    return X^ROTL(X,9)^ROTL(X,17);
}

unsigned P1(const unsigned &X)
{
    return X^ROTL(X,15)^ROTL(X,23);
}

string sm3(const string &str)
{
    string strs=str;
    unsigned V[8]={0x7380166f,0x4914b2b9,0x172442d7,0xda8a0600,0xa96f30bc,0x163138aa,0xe38dee4d,0xb0fb0e4e};
    unsigned W[68]={0};
    unsigned W1[64]={0};
    for (int i=0;i<strs.size();i+=64)
    {
        for (int j=0;j<16;j++)
        {
            W[j]=((unsigned)strs[i+4*j]&0xff)<<24|
                 ((unsigned)strs[i+4*j+1]&0xff)<<16|
                 ((unsigned)strs[i+4*j+2]&0xff)<<8|
                 ((unsigned)strs[i+4*j+3]&0xff);
        }
        for (int t=16;t<68;t++)
        {
            W[t]=P1(W[t-16]^W[t-9]^ROTL(W[t-3],15))^ROTL(W[t-13],7)^W[t-6];
        }
        for (int t=0;t<64;t++)
        {
            W1[t]=W[t]^W[t+4];
        }
        unsigned A=V[0];
        unsigned B=V[1];
        unsigned C=V[2];
        unsigned D=V[3];
        unsigned E=V[4];
        unsigned F=V[5];
        unsigned G=V[6];
        unsigned H=V[7];
        for (int j=0;j<64;j++)
        {
            unsigned ss1=ROTL(ROTL(A,12)+E+ROTL(T(j),j),7);
            unsigned ss2=ss1^ROTL(A,12);
            unsigned tt1=FF(A,B,C,j)+D+ss2+W1[j];
            unsigned tt2=GG(E,F,G,j)+H+ss1+W[j];
            D=C;
            C=ROTL(B,9);
            B=A;
            A=tt1;
            H=G;
            G=ROTL(F,19);
            F=E;
            E=P0(tt2);
        }
        V[0]=V[0]^A;
        V[1]=V[1]^B;
        V[2]=V[2]^C;
        V[3]=V[3]^D;
        V[4]=V[4]^E;
        V[5]=V[5]^F;
        V[6]=V[6]^G;
        V[7]=V[7]^H;
    }
    stringstream ss;
    ss<<hex<<V[0]<<V[1]<<V[2]<<V[3]<<V[4]<<V[5]<<V[6]<<V[7];
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
        
    string astr=sm3pad(str);
    cout<<"SM3:"<<sm3(astr)<<endl;
    return 0;
}
