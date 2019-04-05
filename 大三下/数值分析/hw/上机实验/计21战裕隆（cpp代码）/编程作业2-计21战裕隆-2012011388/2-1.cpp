#include<iostream>
#include<cmath>

using namespace std;
double x1[13],x2[23];

double hanshu(double x)
{
	return 1.0/(1+16*x*x); 
}

double chazhi1(double x)
{
	double sum=0.0;
	for(int k=0;k<=10;k++)
	{
		double cnt=1.0;
		for(int i=0;i<=10;i++)
		{
			if(k!=i)
			{
				cnt=cnt*(x-x1[i])/(x1[k]-x1[i]);
			} 
		}
		sum=sum+cnt*hanshu(x1[k]);
	}
	return sum;
}//l1

double chazhi2(double x)
{
	double sum=0.0;
	for(int k=0;k<=20;k++)
	{
		double cnt=1.0;
		for(int i=0;i<=20;i++)
		{
			if(k!=i)
			{
				cnt=cnt*(x-x2[i])/(x2[k]-x2[i]);
			}
		}
		sum=sum+cnt*hanshu(x2[k]);
	}
	return sum;
}//l2

int main()
{
	double a,b;
	a=-5.0;
	b=5.0;
	double h1=1.0,h2=0.5;
	for(int i=0;i<=10;i++)
	{
		x1[i]=a+i*h1;
	}
	for(int i=0;i<=20;i++)
	{
		x2[i]=a+i*h2;
	}
	cout<<chazhi1(4.8)<<endl;
	cout<<chazhi2(4.8)<<endl;
	system("pause");
	return 0;
}
