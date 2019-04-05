#include<iostream>
#include<cmath>

using namespace std;

double jingdu=1e-6;
double hanshu(double x)
{
	return x*x*x-x-1;
}

double daoshu(double x)
{
	return 3*x*x-1;	
}
double x0=1.5;

double newton()
{
	double x1=x0,x2;
	bool panduan;
	int times=0;
	panduan=(hanshu(x1)>jingdu);
	while(panduan)
	{
		cout<<times<<" : "<<x1<<" "<<x2<<endl;
		x2=x1-hanshu(x1)/daoshu(x1);
		times++;
		panduan=(abs(hanshu(x2))>jingdu);
		panduan=panduan && (abs(x2-x1)>jingdu);
		x1=x2;
	}
	cout<<times<<endl;
	return x2;
}

int main()
{
	double jieguo=newton();
	cout<<jieguo<<endl;
	system("pause");
	return 0;
}
