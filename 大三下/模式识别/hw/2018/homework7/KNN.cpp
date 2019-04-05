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
	Point() {}
	Point(double x,double y,double z):x(x),y(y),z(z){}
	friend Point operator - (const Point &a,const Point &b)
	{
		return Point(a.x-b.x,a.y-b.y,a.z-b.z);
	}
	int id;
}P[maxn];
typedef Point Vector;
double Dot(Vector a,Vector b)
{
	return a.x*b.x+a.y*b.y+a.z*b.z;
}
double Dis(Point a,Point b)
{
	return Dot(b-a,b-a);
}
int n;
void Prepare()
{
	int m;
	fstream in;
	in.open("A1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		double x,y,z;
		in>>x>>y>>z;
		P[++n]=Point(x,y,z);
		P[n].id=0;
	}
	in.close();
	in.open("B1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		double x,y,z;
		in>>x>>y>>z;
		P[++n]=Point(x,y,z);
		P[n].id=1;
	}
	in.close();
	in.open("C1.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		double x,y,z;
		in>>x>>y>>z;
		P[++n]=Point(x,y,z);
		P[n].id=2;
	}
	in.close();
}
int classify(Point q)
{
	pair<double,int> dis[15];
	int k=5,m=0;
	for(int i=1;i<=n;++i)
	{
		double val=Dis(P[i],q);
		if(m<k)
			dis[++m]=make_pair(val,P[i].id);
		else if(val<dis[k].first)
		{
			int j=k;
			while(dis[j-1].first>val)
				dis[j]=dis[j-1],--j;
			dis[j]=make_pair(val,P[i].id);
		}
	}
	int cnt[5]={0};
	for(int i=1;i<=k;++i)
		++cnt[dis[i].second];
	return max_element(cnt,cnt+3)-cnt;
}
void work()
{
	int cnt1=0,cnt2=0,cnt3=0,m;
	fstream in;
	in.open("A2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		double x,y,z;
		in>>x>>y>>z;
		int type=classify(Point(x,y,z));
		if(type==0)
			++cnt1;
	}
	in.close();
	in.open("B2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		double x,y,z;
		in>>x>>y>>z;
		int type=classify(Point(x,y,z));
		if(type==1)
			++cnt2;
	}
	in.close();
	in.open("C2.txt",ios::in);
	in>>m;
	for(int i=1;i<=m;++i)
	{
		double x,y,z;
		in>>x>>y>>z;
		int type=classify(Point(x,y,z));
		if(type==2)
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
	work();
	return 0;
}
