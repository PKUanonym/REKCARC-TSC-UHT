#include<iostream>
#include<fstream>
#include<stdlib.h>
#define N 10
using namespace std;
float ic[N][N];
int main ()
{
	float avr,s;
	char ch;
	char cipher[1000],ka[100];
	int pnt,head,n,d,a2z[26],k,b[100];
	n=0;
	string filename;
	cout<<"请输入文件名：";
	cin>>filename; 
	double sum;
	ifstream fin(filename.c_str());
	while(fin>>ch)
	{
		cipher[n]=ch;
		n++;
	} //读取密文字符串 n为字符串的长度
	cout<<"重合指数计算:"<<endl; 
	for (d=1;d<N+1;d++)
		for (head=0;head<d;head++)
		{
			for (k=0;k<26;k++) a2z[k]=0;
				pnt=head;
			while (pnt<n)
			{
				a2z[cipher[pnt]-65]+=1;
				pnt+=d;
			}
			sum=0;
			for (k=0;k<26;k++) 
				sum+=a2z[k]*(a2z[k]-1);
			ic[d][head]=1.0*sum*d*d/n/n;
		}
		for (d=1;d<N+1;d++)
		{
			cout<<"d="<<d<<":"; 
			s=0;
			for (head=0;head<d;head++) 
				s+=ic[d][head];
			avr=s/d;
			cout<<"avr="<<avr<<" "<<endl;
			for (head=0;head<d;head++)
			{
				cout<<ic[d][head]<<" ";
			}
			cout<<endl;
		}
	fin.close();
	
	system("pause");
	return 0;
}
