#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<algorithm>
#include<fstream>
#define maxn 10000
#define maxm 15
using namespace std;
struct Point
{
	double x,y,z,o[5];
}P[maxn];
double w[2][maxm][maxm];
double output[5][5];
int nH,nI,nO;
int n;
void Prepare()
{
	int m;
	fstream in;
	in.open("A1.txt",ios::in);
	in>>m;
	double t=sqrt(2.0/3);
	output[0][1]=t-0.5,output[0][2]=2-t-0.5;
	output[1][1]=0.5,output[1][2]=0.5;
	output[2][1]=2-t-0.5,output[2][2]=t-0.5;
	for(int i=1;i<=m;++i)
	{
		++n;
		in>>P[n].x>>P[n].y>>P[n].z;
		for(int j=1;j<=2;++j)
			P[n].o[j]=output[0][j];
	}
	in.close();
	in.open("B1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		++n;
		in>>P[n].x>>P[n].y>>P[n].z;
		for(int j=1;j<=2;++j)
			P[n].o[j]=output[1][j];
	}
	in.close();
	in.open("C1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		++n;
		in>>P[n].x>>P[n].y>>P[n].z;
		for(int j=1;j<=2;++j)
			P[n].o[j]=output[2][j];
	}
	in.close();
}
double dot(double *a,double *b,int n)
{
	double sum=0;
	for(int i=0;i<=n;++i)
		sum+=a[i]*b[i];
	return sum;
}
double sigmoid(double x)
{
	return 1/(1+exp(-x));
}
void emit(double *x,double *y,double *z,double net[2][maxm],double w[2][maxm][maxm],int nI,int nH,int nO)
{
	y[0]=1;
	for(int j=1;j<=nH;++j)
	{
		net[0][j]=dot(x,w[0][j],nI);
		y[j]=sigmoid(net[0][j]);
	}

	for(int k=1;k<=nO;++k)
	{
		net[1][k]=dot(y,w[1][k],nH);
		z[k]=sigmoid(net[1][k]);
	}
	
}
void Training()
{
	nH=10,nI=3,nO=2;
	for(int j=1;j<=nH;++j)
		for(int i=0;i<=nI;++i)
			w[0][j][i]=0.1*(rand()&1?1:-1);
	for(int j=1;j<=nO;++j)
		for(int i=0;i<=nH;++i)
			w[1][j][i]=0.1*(rand()&1?1:-1);
	double x[maxm],y[maxm],z[maxm],t[maxm],delta[maxm],net[2][maxm];
	double eta=1e-4;
	for(int T=1;T<=600;++T)
	{
		for(int id=1;id<=n;++id)
		{
			x[0]=1,x[1]=P[id].x,x[2]=P[id].y,x[3]=P[id].z;
			emit(x,y,z,net,w,nI,nH,nO);
			for(int k=1;k<=nO;++k)
			{
				t[k]=P[id].o[k];
				delta[k]=(t[k]-z[k])*z[k]*(1-z[k]);
			}
			
			for(int k=1;k<=nO;++k)
				for(int j=0;j<=nH;++j)
					w[1][k][j]+=eta*delta[k]*y[j];
			for(int j=1;j<=nH;++j)
			{
				double s=0;
				for(int k=1;k<=nO;++k)
					s+=w[1][k][j]*delta[k];
				for(int i=0;i<=nI;++i)
					w[0][j][i]+=eta*s*y[j]*(1-y[j])*x[i];
			}
		}
	}
}
void Classify()
{
	int cnt1=0,cnt2=0,cnt3=0,m;
	double x[maxm],y[maxm],z[maxm],net[2][maxm],val[3];
	fstream in;
	in.open("A2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		x[0]=1;
		in>>x[1]>>x[2]>>x[3];
		emit(x,y,z,net,w,nI,nH,nO);
		for(int i=0;i<3;++i)
		{
			val[i]=0;
			for(int j=1;j<=nO;++j)
				val[i]+=(z[j]-output[i][j])*(z[j]-output[i][j]);
		}
		if(val[0]<val[1]&&val[0]<val[2])
			++cnt1;
	}
	in.close();
	in.open("B2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		x[0]=1;
		in>>x[1]>>x[2]>>x[3];
		emit(x,y,z,net,w,nI,nH,nO);
		for(int i=0;i<3;++i)
		{
			val[i]=0;
			for(int j=1;j<=nO;++j)
				val[i]+=(z[j]-output[i][j])*(z[j]-output[i][j]);
		}
		if(val[1]<val[0]&&val[1]<val[2])
			++cnt2;
	}
	in.close();
	in.open("C2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		x[0]=1;
		in>>x[1]>>x[2]>>x[3];
		emit(x,y,z,net,w,nI,nH,nO);
		for(int i=0;i<3;++i)
		{
			val[i]=0;
			for(int j=1;j<=nO;++j)
				val[i]+=(z[j]-output[i][j])*(z[j]-output[i][j]);
		}
		if(val[2]<val[1]&&val[2]<val[0])
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
	Training();
	Classify();
	return 0;
}
