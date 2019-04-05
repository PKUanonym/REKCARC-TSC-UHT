#include <iostream>
#include <string>
#include <sstream>
using namespace std;

string sha256pad(const string &str)//sha256Ìî³ä
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

unsigned ROTR(const unsigned &word,const int &num)//wordÑ­»·ÓÒÒÆnumÎ»
{
    return (word>>num)|(word<<(32-num));
}

string sha256(const string &str)
{
    string strs=str;
    const unsigned K[64]={ 
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};
    unsigned H[8]={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19};
    unsigned W[64]={0};
    for (int i=0;i<strs.size();i+=64)
    {
        for (int j=0;j<16;j++)
        {
            W[j]=((unsigned)strs[i+4*j]&0xff)<<24|
                 ((unsigned)strs[i+4*j+1]&0xff)<<16|
                 ((unsigned)strs[i+4*j+2]&0xff)<<8|
                 ((unsigned)strs[i+4*j+3]&0xff);
        }
        for (int t=16;t<64;t++)
        {
            unsigned s0=ROTR(W[t-15],7)^ROTR(W[t-15],18)^(W[t-15]>>3);
            unsigned s1=ROTR(W[t-2],17)^ROTR(W[t-2],19)^(W[t-2]>>10);
            W[t]=W[t-16]+s0+W[t-7]+s1;
        }
        unsigned a=H[0];
        unsigned b=H[1];
        unsigned c=H[2];
        unsigned d=H[3];
        unsigned e=H[4];
        unsigned f=H[5];
        unsigned g=H[6];
        unsigned h=H[7];
        for (int t=0;t<64;t++)
        {
            unsigned s0=ROTR(a,2)^ROTR(a,13)^ROTR(a,22);
            unsigned maj=(a&b)^(a&c)^(b&c);
            unsigned t2=s0+maj;
            unsigned s1=ROTR(e,6)^ROTR(e,11)^ROTR(e,25);
            unsigned ch=(e&f)^((~e)&g);
            unsigned t1=h+s1+ch+K[t]+W[t];
            h=g;
            g=f;
            f=e;
            e=d+t1;
            d=c;
            c=b;
            b=a;
            a=t1+t2;
        }
        H[0]+=a;
        H[1]+=b;
        H[2]+=c;
        H[3]+=d;
        H[4]+=e;
        H[5]+=f;
        H[6]+=g;
        H[7]+=h;
    }
    stringstream ss;
    ss<<hex<<H[0]<<H[1]<<H[2]<<H[3]<<H[4]<<H[5]<<H[6]<<H[7];
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
    
    string astr=sha256pad(str);
    cout<<"SHA-256:"<<sha256(astr)<<endl;
    return 0;
}
