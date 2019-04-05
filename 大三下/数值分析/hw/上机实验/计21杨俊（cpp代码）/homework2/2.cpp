#include <iostream>
using namespace std;
#define N 200
int number=0;
double xx[N]={0},yy[N]={0};

double f(double x){
	return 1/(1+16*x*x);
}
double lagrange(double x[],double y[],int n,double point){
	double answer=0,s=1.0;
	double l[N]={0};
	for(int i=0;i<=n;i++){
		for(int j=0;j<=n;j++){
			if(i==j) continue;
			s=s*(point-x[j])/(x[i]-x[j]);
		}
		l[i]=s*y[i];
		s=1.0;
	}
	for(int i=0;i<=n;i++){
		answer+=l[i];
	}
	return answer;
}
int main(){
	for(int j=10;j<20;j=j+2){
		for(int i=0;i<=j;i++){
			xx[i]=-5+i*10/j;
			yy[i]=f(xx[i]);
		}
		printf("%.15f",lagrange(xx,yy,j,4.8));
	}
	return 0;
}