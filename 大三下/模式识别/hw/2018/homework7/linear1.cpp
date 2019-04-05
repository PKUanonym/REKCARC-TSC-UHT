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
void Map(Point p,double *x)
{
	double a[]={1,6,9},y[4]={1,p.x,p.y,p.z};
	x[0]=1;
	for(int i=1;i<=3;++i)
	{
		x[i]=0;
		for(int j=0;j<3;++j)
			x[i]=x[i]*y[i]+a[j];
	}
}
void Learning()
{
	double lambda=1e-8,val[4],x[4];
	for(int i=0;i<3;++i)
		for(int j=0;j<=3;++j)
			w[i][j]=-i;
	for(int T=1;T<=3000;++T)
		for(int i=1;i<=n;++i)
		{
			Map(P[i],x);
			for(int j=0;j<3;++j)
				val[j]=f(w[j],x);
			for(int j=0;j<3;++j)
				if(val[j]>=val[P[i].id]&&j!=P[i].id)
					for(int k=0;k<=3;++k)
						w[P[i].id][k]+=lambda*x[k],w[j][k]-=lambda*x[k];
		}
}
void Classify()
{
	int cnt1=0,cnt2=0,cnt3=0,m;
	double val[3],y[5];
	fstream in;
	in.open("A2.txt",ios::in);
	in>>m;
	Point p;
	for(int i=1;i<=m;++i)
	{
		in>>p.x>>p.y>>p.z;
		Map(p,y);
		for(int j=0;j<3;++j)
		{
			val[j]=0;
			for(int k=0;k<=3;++k)
				val[j]+=w[j][k]*y[k];
		}
		if(val[0]>=val[1]&&val[0]>=val[2])
			++cnt1;
	}
	in.close();
	in.open("B2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		in>>p.x>>p.y>>p.z;
		Map(p,y);
		for(int j=0;j<3;++j)
		{
			val[j]=0;
			for(int k=0;k<=3;++k)
				val[j]+=w[j][k]*y[k];
		}
		if(val[1]>=val[0]&&val[1]>=val[2])
			++cnt2;
	}
	in.close();
	in.open("C2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		in>>p.x>>p.y>>p.z;
		Map(p,y);
		for(int j=0;j<3;++j)
		{
			val[j]=0;
			for(int k=0;k<=3;++k)
				val[j]+=w[j][k]*y[k];
		}
		if(val[2]>=val[1]&&val[2]>=val[0])
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
	Learning();
	Classify();
	return 0;
}
