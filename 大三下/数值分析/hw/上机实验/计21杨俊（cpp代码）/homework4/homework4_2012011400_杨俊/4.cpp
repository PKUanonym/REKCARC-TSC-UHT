#include <iostream>
#include <cmath>
using namespace std;
#define NUMBER 100
int flag=0;
double cf1(double kx){
	if(flag==0){
		if (kx!=0)
			return 1/kx;
		else return 0;
	}
	else if(flag==1) {
		return 4/(1+kx*kx);
	}
}
double simpson(double a,double b,int n){
	double sum=0,h=(b-a)/n;
	sum+=cf1(a)+cf1(b);
	for(int i=0;i<n;i++){
		sum+=cf1(a+(i+0.5)*h)*4;
	}
	for(int i=1;i<n;i++){
		sum+=cf1(a+i*h)*2;;
	}
	return sum*h/6;
}
double romberg(double a,double b,double E){
	double h[NUMBER]={0};
	double t[NUMBER][NUMBER]={0};
	h[0]=b-a;
	t[0][0]=h[0]*(cf1(a)+cf1(b))/2;
	h[1]=(b-a)/2;
	t[1][0]=t[0][0]/2+h[1]*(cf1(a+h[1]));
	int ptr=1;
	t[0][1]=4*t[1][0]/3-1*t[0][0]/3;
	while(t[0][ptr]-t[0][ptr-1]>E||t[0][ptr-1]-t[0][ptr]>E){
		ptr++;
		double temp1=ptr;
		double temp2=pow(2,temp1-1);
		double temp3=0;
		h[ptr]=h[ptr-1]/2;
		t[ptr][0]=t[ptr-1][0]/2;
		
		for(int i=0;i<temp2;i++){
			t[ptr][0]+=h[ptr]*cf1(a+(i+0.5)*h[ptr-1]);
		}
		for(int i=1;i<=ptr;i++){
			temp3=i;
			t[ptr-i][i]=pow(4,temp3)*t[ptr-i+1][i-1]/(pow(4,temp3)-1)-t[ptr-i][i-1]/(pow(4,temp3)-1);
		}
	}
	/*
	for(int i=0;i<5;i++){
		cout<<h[i]<<" ";
	}
	cout<<endl;
	for(int i=0;i<10;i++){
		for(int j=0;j<10;j++){
			printf("%.12f\n",t[i][j]);
		}
		cout<<endl;
	}
	*/
	return t[0][ptr];
}
double gauss(double a,double b,int n){
	double h=(b-a)/n;
	double sum=0;
	for(int i=0;i<n;i++){
		sum+=cf1(a+(i+0.5)*h-h/(2*sqrt(3)))+cf1(a+(i+0.5)*h+h/(2*sqrt(3)));
	}
	sum=sum*h/2;
	return sum;
}
int main(){
	flag=1;
	cout<<"the value of pi:"<<endl;
	printf("simpson: %.12f",simpson(0,1,6));
	printf("romberg: %.12f",romberg(0,1,0.000000005));
	printf("gauss: %.12f",gauss(0,1,64));
	flag=0;
	cout<<"the value of Ln2: "<<endl;
	printf("simpson: %.12f",simpson(1,2,25));
	printf("romberg: %.12f",romberg(1,2,0.000000005));
	printf("gauss: %.12f",gauss(1,2,32));
	return 0;
}
