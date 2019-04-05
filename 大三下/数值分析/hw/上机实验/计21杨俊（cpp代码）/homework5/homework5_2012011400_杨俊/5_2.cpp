#include <iostream>
#include <cmath>
using namespace std;
#define NUMBER 100
int flag=0;
double cf1(double kx){
	return pow((kx+1)/2,1/3);
}
double cf2(double kx){
	return 2*pow(kx,3)-1;
}
double compute(double x){
	for(int i=0;i<10;i++){
		printf("%d %.10f\n",i,x);
		if(flag==0)
			x=cf1(x);
		else if(flag==1){
			x=cf2(x);
		}
	}
	return x;
}
double cfnewton(double kx){
	return kx-(pow(kx,3)-kx-1)/(3*pow(kx,2)-1);
}
double newton(double kx,double E){
	double x[NUMBER]={0};
	x[0]=kx;
	x[1]=cfnewton(x[0]);
	int temp=1;
	while(x[temp]-x[temp-1]>E||x[temp-1]-x[temp]>E){
		printf("%d %.10f\n",temp,x[temp]);
		x[temp+1]=cfnewton(x[temp]);
		temp++;
	}
	cout<<temp<<endl;
	return x[temp];
}
int main(){
	flag=0;
	cout<<"5_2"<<endl;
	cout<<"a method one"<<endl;
	printf("%f\n",compute(0));
	flag=1;
	cout<<"a method two"<<endl;
	printf("%f\n",compute(0));
	cout<<"answer"<<endl;
	cout<<"b newton method one"<<endl;
	printf("%.10f\n",newton(1.5,0.000001));
	cout<<"b newton method two"<<endl;
	printf("%.10f\n",newton(0,0.000001));
	return 0;
}
