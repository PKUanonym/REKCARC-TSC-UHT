#include <iostream>
#include <fstream>
#include <string.h>
#include <math.h>
using namespace std;

int gcd(int a, int b)
{
	int k = 0;
	do
	{
		k = a%b;
		a = b;
		b = k;
	}while(k!=0);
	return a;
}

int Ni(int a, int b) /*ab*/
{
	int i = 0;
	while(a*(++i)%b!=1);
	return i;
}

int wmwgj()
{
	char c[1000];
	int length, i=0, j=0,ka=3, kb=7,tmp;
	char a[1000];
	ifstream fin("3cin.txt");
	char ch;
	length=0;
	while (fin>>ch)
	{
		c[length]=ch;
		length++;
	}
	fin.close();
	for(j=0;j<length;j++)
	{
		a[j]=c[j];
	}
	float v[26]={0}; 
	double A[26]={0.082,0.015,0.028,0.043,0.127,              //Ó¢ÎÄ×ÖÄ¸ÆµÂÊ±íA    
              0.022,0.02,0.061,0.07,0.002,0.008,    
              0.04,0.024,0.067,0.075,0.019,0.001,    
              0.06,0.063,0.091,0.028,0.01,0.023,0.001,0.02,0.001}; 
              
	double chonghezhishu=1;
	char ans[1000];
	int ak,bk;
	
	cout<<"start:"<<endl; 
	for(ka=1;ka<26;ka++)
	{
		if(gcd(ka,26)==1)
			for(kb=1;kb<26;kb++)
			{
		 		for(i=0; i<length; i++)
		 		{
				 	c[i]=a[i];
		 			if(c[i]>64&&c[i]<91)
		 			{
					 	tmp = Ni(ka,26)*((c[i]-65)-kb);
		 				if(tmp<0)
							c[i]= tmp%26+26+97;
						else
							c[i]= tmp%26+97;}
				}
				//printf("%s(%d,%d)\n",c,ka,kb);
				//fout<<c<<"("<<ka<<","<<kb<<")"<<endl;
				for (i=0; i<length; i++)
				{
					v[c[i]-'a']+=1;   
				}
				for (i=0;i<26;i++)
				{
					v[i]=v[i]/length;
				}
				double temp=0;
				for (i=0;i<26;i++)
				{
					temp+=A[i]*v[i];
				}
				//cout<<temp<<endl;
				if(fabs(temp-0.065)  < chonghezhishu)    
	            {    
					//cout<<c<<"("<<ka<<","<<kb<<")"<<temp<<endl;
					//fout<<c<<"("<<ka<<","<<kb<<")"<<endl;
	            	chonghezhishu=fabs(temp-0.065);
					for(i=0;i<length;i++)
					{
						ans[i]=c[i];
						ak=ka;
						bk=kb;
					}   
	            }	
			}
	}	
	ofstream fout("3cout.txt");
	printf("%s(%d,%d)\n ",ans,ak,bk);
	fout<<ans<<"("<<ak<<","<<bk<<")"<<endl;
	fout.close();		       
}

int main()
{
	wmwgj();
	return 0;
}
