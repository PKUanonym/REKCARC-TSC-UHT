#include<iostream>
#include<cmath>
#include<cstdlib>

using namespace std;
double x0=0.0;

double hanshu1(double x)
{
	return pow((x+1.0)/2,1/3);
}

double hanshu2(double x)
{
	return 2*x*x*x-1.0;
}

double diedai1()
{
	double x=x0;
	for(int i=1;i<=10;i++)
	{
		x=hanshu1(x);
	}
	cout<<x<<endl;
}

double diedai2()
{
	double x=x0;
	for(int i=1;i<=10;i++)
	{
		double x1=hanshu2(x);
		x=x1;
	}
	cout<<x<<endl;
}

int main()
{
	diedai1();
	diedai2();
	system("pause");
	return 0;
} 
