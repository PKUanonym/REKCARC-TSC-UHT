#include<iostream>
#include<cmath>
#include<cstdlib>
using namespace std;
double x1=-3.0,x2=3.0;
double jingdu=1e-6;

double hanshu(double x)
{
	return 2*x*x*x-x*x+3*x-1;
}

double erfen()
{
	int times=0;
	double x3=(x1+x2)/2.0;
	double y1,y2,y3;
	while(abs(hanshu(x3))>jingdu)
	{
		times++;
		y1=hanshu(x1);
		y2=hanshu(x2);
		x3=(x1+x2)/2.0;
		y3=hanshu(x3);
		cout<<times<<": "<<x1<<" "<<x2<<endl;
		if(y1*y3<0)
		{
			x1=x1;
			x2=x3;
			continue;
		}
		else if(y2*y3<0)
		{
			x1=x3;
			x2=x2;
			continue;
		}
	}
	cout<<x3<<" "<<times<<endl; 
}

int main()
{
	erfen();
	system("pause");
	return 0;
}
