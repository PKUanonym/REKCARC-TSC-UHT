#include<iostream>
#include<cmath>
#include<math.h>

using namespace std;
int n=100;
double h=1.0/n;
double lamuda=0.1;
double a=0.5;
double A[105][105];
double b[105];
double x[100005][105];//解
int countd;


void goujian()
{
	for(int i=1;i<=100;i++)
	{
		b[i]=a*h*h;
	}
	for(int i=1;i<=100;i++)
	{
		A[i][i]=-(2*lamuda+h);
	}
	for(int i=2;i<=100;i++)
	{
		A[i][i-1]=lamuda;
	}
	for(int i=2;i<=100;i++)
	{
		A[i-1][i]=lamuda+h;
	}
}

void jagoubi()
{
	for(int i=0;i<=countd;i++)
	{
		for(int k=0;k<=n;k++)
		{
			x[i][k]=0.0;
		}
	}
	for(int k=0;k<countd;k++)
	{
		for(int i=1;i<=n;i++)
		{
			double sum1=0.0;
			for(int j=1;j<=n;j++)
			{
				if(i!=j)
				{
					sum1=sum1+A[i][j]*x[k][j];
				}
			}
			x[k+1][i]=(b[i]-sum1)/A[i][i];
		}
	}
	cout<<"雅阁比开始了！"<<endl;
	for(int i=1;i<=100;i++)
	{
		cout.precision(4);
		cout<<x[countd][i]<<endl;
	}
	cout<<endl;
}

void gauss()
{
	for(int i=0;i<=countd;i++)
	{
		for(int k=0;k<=n;k++)
		{
			x[i][k]=0.0;
		}
	}
	for(int k=0;k<countd;k++)
	{
		for(int i=1;i<=n;i++)
		{
			double sum1=0.0,sum2=0.0;
			for(int j=1;j<=i-1;j++)
			{
				sum1=sum1+A[i][j]*x[k+1][j];
			}
			for(int j=i+1;j<=n;j++)
			{
				sum2=sum2+A[i][j]*x[k][j];
			}
			x[k+1][i]=(b[i]-sum1-sum2)/A[i][i];
		}
	}
	cout<<"高斯开始了！"<<endl;
	for(int i=1;i<=100;i++)
	{
		cout.precision(4);
		cout<<x[countd][i]<<endl;
	}
	cout<<endl;
}

void sor()
{
	double w=0.5;
	for(int i=0;i<=countd;i++)
	{
		for(int k=0;k<=n;k++)
		{
			x[i][k]=0.0;
		}
	}
	for(int k=0;k<countd;k++)
	{
		for(int i=1;i<=n;i++)
		{
			double sum1=0.0,sum2=0.0;
			for(int j=1;j<=i-1;j++)
			{
				sum1=sum1+A[i][j]*x[k+1][j];
			}
			for(int j=i;j<=n;j++)
			{
				sum2=sum2+A[i][j]*x[k][j];
			}
			x[k+1][i]=x[k][i]+w*(b[i]-sum1-sum2)/A[i][i];
		}
	}
	cout<<"SOR开始了！"<<endl;
	for(int i=1;i<=100;i++)
	{
		cout.precision(4);
		cout<<x[countd][i]<<endl;
	}
	cout<<endl;
}

int main()
{
	countd=100000;
	goujian();
	jagoubi();
	gauss();
	sor();
	system("pause");
	return 0;
}
