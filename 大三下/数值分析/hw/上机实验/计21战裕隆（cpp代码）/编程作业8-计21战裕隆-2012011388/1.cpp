#include<iostream>
#include<cmath>
#include<memory.h>

using namespace std;

double a[6][6];
double v[10000][6]={0.0},u[10000][6]={0.0};
double u_max[10000]={0.0};
int cishu=1;
int n;
int biaoji;

void mifa()
{
	for(int i=1;i<=n;i++)
	{
		v[0][i]=1.0;
		u[0][i]=1.0;
	}//³õÖµ 
	biaoji=0;
	while(biaoji==0)
	{
		for(int i=1;i<=n;i++)
		{
			for(int k=1;k<=n;k++)
			{
				v[cishu][i]=v[cishu][i]+a[i][k]*u[cishu-1][k];
			}
		}
		u_max[cishu]=v[cishu][1];
		for(int i=1;i<=n;i++)
		{
			if(v[cishu][i]>u_max[cishu])
			{
				u_max[cishu]=v[cishu][i];
			}
		}
		for(int i=1;i<=n;i++)
		{
			u[cishu][i]=v[cishu][i]/u_max[cishu];
		}
		if(abs(u_max[cishu]-u_max[cishu-1])<1e-5)
		{
			biaoji=1;
			break;
		}
		else
		{
			cishu++;
			continue;
		}
	}
}

int main()
{
	cin>>n;
	for(int i=1;i<=n;i++)
	{
		for(int j=1;j<=n;j++)
		{
			cin>>a[i][j];
		}
	}
	mifa();
	cout<<u_max[cishu]<<endl;
	for(int i=1;i<=n;i++)
	{
		cout<<u[cishu][i]<<" ";
	}
	cout<<endl;
	cout<<cishu<<endl;
	system("pause");
	return 0;
}
