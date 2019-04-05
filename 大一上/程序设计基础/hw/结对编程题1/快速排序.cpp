/* 
Created in 2016/12/12
Student's number : 2016011446 && 2016011440
Student's name : Weng Jiayi && Sun Zhaole
*/
#include<bits/stdc++.h>
double a[100],b[100];
int n;
void print(double*a)
{
	for(int i=0;i<n;i++)printf("%.0lf ",a[i]);puts("");
}
template<class T>void sort3(T*a)
{
	if(a[0]>a[1])std::swap(a[0],a[1]);
	if(a[1]>a[2])std::swap(a[1],a[2]);
	if(a[0]>a[1])std::swap(a[0],a[1]);
}
int smallsort(double *a,int i,int j,int k)
{
	int b[3]={i,j,k};double d=a[k];
	sort3(b);
	double c[3]={a[i],a[j],a[k]};
	sort3(c);
	a[b[0]]=c[0],a[b[1]]=c[1],a[b[2]]=c[2];
	return c[0]==d?b[0]:c[1]==d?b[1]:b[2];
} 
void qs(double *a,int l,int r){
	if(r-l+1<=1)return;
	if(r-l+1==2)
	{
		if(a[l]>a[r])
		std::swap(a[l],a[r]);
		return;
	}
	int i=l,j=r,d=rand()%(r-l+1)+l;double m=a[d];
	//printf("l=%d r=%d d=%d a[d]=%.0lf\n",l,r,d,m);print();
	a[d]=1<<20;
	for(;i<j;a[d]=m,d=smallsort(a,i,j,d),a[d]=1<<20)//,print(),printf("d=%d\n",d))
	{
		for(i=l;a[i]<m||i==d;i++);//printf("i=%d\n",i);
		if(i>=r)i=r;
		for(j=r;a[j]>m;j--)//,printf("j=%d d=%d  ",j,d),print())
		if(j<d)a[d]=a[j],a[d=j]=1<<20;
	}
	a[d]=m;//print();
	qs(a,l,d-1),qs(a,d+1,r);
}
int main()
{
	printf("Please input n: ");
	srand(time(0));scanf("%d",&n);
	printf("Please input the array: ");
	for(int i=0;i<n;i++)
	{
		scanf("%lf",a+i);
//		a[i]=rand()%100;
	} 
	for(int i=0;i<n;i++)a[i]+=(0.01*rand()/RAND_MAX);
//	for(int i=0;i<n;i++)b[i]=a[i];
	qs(a,0,n-1);
//	std::sort(b,b+n);
//	for(int i=0;i<n-1;i++)if(a[i]!=b[i])return !puts("WA");
//	puts("OK");
	print(a);
}
