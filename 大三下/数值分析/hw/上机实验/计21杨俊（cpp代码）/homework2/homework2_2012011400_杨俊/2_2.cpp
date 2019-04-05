#include <iostream>
#include <cmath>
using namespace  std;
#define N 19
double f1[N-1]={0};
double f2[N-2]={0};
void before(double x[],double f[]){
	for(int i=0;i<N-1;i++){
		f1[i]=(f[i+1]-f[i])/(x[i+1]-x[i]);
	}
	for(int i=0;i<N-2;i++){
		f2[i+1]=6*(f1[i+1]-f1[i])/(x[i+2]-x[i]);
	}
}
void cubicspline(double x[],double y[],int n,double ddy0,double ddyn,double point[],int m){
	before(x,y);
	double s[N]={0},a[N-1]={0},u[N]={0},t[N]={0};
	for(int i=0;i<n;i++){
		t[i]=2;
	}
	f2[0]=6.0*(f1[0]-ddy0)/(x[1]-x[0]);
	f2[N-1]=6.0*(ddyn-f1[n-2])/(x[n-1]-x[n-2]);

	for(int i=1;i<N-1;i++){
		a[i]=(x[i+1]-x[i])/(x[i+1]-x[i-1]);
		u[i]=1-a[i];
	}
	u[N-1]=1;
	a[0]=1;
	for(int i=0;i<N-1;i++){
		t[i+1]=t[i+1]-(u[i+1]*a[i])/t[i];
		f2[i+1]=f2[i+1]-(u[i+1]*f2[i])/t[i];
		u[i+1]=0;
	}
	s[N-1]=f2[N-1]/t[N-1];
	for(int i=N-2;i>=0;i--){
		s[i]=(f2[i]-s[i+1]*a[i])/t[i];
	}
	double ff1,ff2,ff3;
	int ptr;
	for(int i=0;i<m;i++){
		
		for(int j=0;j<N;j++){
			if(point[i]<x[j]){
				ptr=j;
				break;
			}
		}
		//cout<<endl;
		//cout<<ptr<<" "<<x[ptr-1]<<" "<<x[ptr]<<" ptr "<<point[i]<<endl;
		ff1=s[ptr-1]*pow((x[ptr]-point[i]),3)/(6*(x[ptr]-x[ptr-1]));
		ff1+=s[ptr]*pow((point[i]-x[ptr-1]),3)/(6*(x[ptr]-x[ptr-1]));
		ff1+=(y[ptr-1]-s[ptr-1]*(x[ptr]-x[ptr-1])*(x[ptr]-x[ptr-1])/6)*(x[ptr]-point[i])/(x[ptr]-x[ptr-1])+(y[ptr]-s[ptr]*(x[ptr]-x[ptr-1])*(x[ptr]-x[ptr-1])/6)*(point[i]-x[ptr-1])/(x[ptr]-x[ptr-1]);
		ff2=-s[ptr-1]*pow((x[ptr]-point[i]),2)/(2*(x[ptr]-x[ptr-1]))+s[ptr]*pow((point[i]-x[ptr-1]),2)/(2*(x[ptr]-x[ptr-1]))+(y[ptr]-y[ptr-1])/(x[ptr]-x[ptr-1])-(s[ptr]-s[ptr-1])*(x[ptr]-x[ptr-1])/6;
		ff3=s[ptr-1]*(x[ptr]-point[i])/(x[ptr]-x[ptr-1])+s[ptr]*(point[i]-x[ptr-1])/(x[ptr]-x[ptr-1]);
		cout<<"x="<<point[i]<<"f(x),f'(x)and f''(x) are:"<<ff1<<" "<<ff2<<" "<<ff3<<endl;
	}
}
int main(){

	/*
	double wy0=3;
	double wyn=-4.0;
	double wx[4]={27.7,28,29,30},wy[4]={4.1,4.3,4.1,3.0};
	double wxxx[4]={27.70000001,27.76,27.89,27.94};
	cubicspline(wx,wy,N,wy0,wyn,wxxx,4);
	for(int i=0;i<4;i++){
		cout<<cf(wxxx[i])<<" ";
	}
	*/
	double xx[N]={0.52,3.1,8,17.95,28.65,39.62,50.65,78,104.6,156.6,208.6,260.7,312.5,364.4,416.3,468,494,507,520};
	double ff[N]={5.288,9.4,13.84,20.2,24.9,28.44,31.1,35,36.9,36.6,34.6,31,26.34,20.9,14.8,7.8,3.7,1.5,0.2};
	double xxxx[6]={2,30,133,390,470,515};
	//double xxxx[4]={0.52,3.1,8,28.65};
	double y0=1.86548;
	double yn=-0.046115;
	cubicspline(xx,ff,N,y0,yn,xxxx,6);
	return 0;
}