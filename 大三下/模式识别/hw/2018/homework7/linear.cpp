#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<algorithm>
#include<fstream>
#define maxn 10000
using namespace std;
struct Point
{
	double x,y,z;
	int id;
}P[maxn];
double w[5][5];
int n;
void Prepare()
{
	int m;
	fstream in;
	in.open("A1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		P[++n].id=0;
		in>>P[n].x>>P[n].y>>P[n].z;
	}
	in.close();
	in.open("B1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		P[++n].id=1;
		in>>P[n].x>>P[n].y>>P[n].z;
	}
	in.close();
	in.open("C1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		P[++n].id=2;
		in>>P[n].x>>P[n].y>>P[n].z;
	}
	in.close();
}
double f(double *w,double *x)
{
	return w[0]*x[0]+w[1]*x[1]+w[2]*x[2]+w[3]*x[3];
}

void Learning(int type,double *w)
{
	double lambda=1e-6,x[4];
	for(int i=0;i<=3;++i)
		w[i]=1;
	for(int T=1;T<=1000;++T)
		for(int i=1;i<=n;++i)
		{
			x[0]=1,x[1]=P[i].x,x[2]=P[i].y,x[3]=P[i].z;
			double val=f(w,x);
			if(P[i].id==type&&val<=0)
				for(int j=0;j<=3;++j)
					w[j]+=lambda*x[j];
			if(P[i].id!=type&&val>=0)
				for(int j=0;j<=3;++j)
					w[j]-=lambda*x[j];
		}
}
void Classify()
{
	int cnt1=0,cnt2=0,cnt3=0,m;
	double val[3],y[5];
	fstream in;
	in.open("A2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		y[0]=1;
		in>>y[1]>>y[2]>>y[3];
		for(int j=0;j<3;++j)
		{
			val[j]=0;
			for(int k=0;k<=3;++k)
				val[j]+=w[j][k]*y[k];
		}
		if(val[0]>val[1]&&val[0]>val[2])
			++cnt1;
	}
	in.close();
	in.open("B2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		y[0]=1;
		in>>y[1]>>y[2]>>y[3];
		for(int j=0;j<3;++j)
		{
			val[j]=0;
			for(int k=0;k<=3;++k)
				val[j]+=w[j][k]*y[k];
		}
		if(val[1]>val[0]&&val[1]>val[2])
			++cnt2;
	}
	in.close();
	in.open("C2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		y[0]=1;
		in>>y[1]>>y[2]>>y[3];
		for(int j=0;j<3;++j)
		{
			val[j]=0;
			for(int k=0;k<=3;++k)
				val[j]+=w[j][k]*y[k];
		}
		if(val[2]>val[1]&&val[2]>val[0])
			++cnt3;
	}
	in.close();
	printf("A类分类正确概率为%f\n",cnt1/100.0);
	printf("B类分类正确概率为%f\n",cnt2/100.0);
	printf("C类分类正确概率为%f\n",cnt3/100.0);
	printf("总的分类正确概率为%f\n",(cnt1+cnt2+cnt3)/300.0);
}
int main()
{
	Prepare();
	Learning(0,w[0]);
	Learning(1,w[1]);
	Learning(2,w[2]);
	Classify();
	return 0;
}
