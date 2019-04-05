#include <iostream>
#include <cmath>
using namespace std;
#define NUMBER 100
double cf(double kx){
	return 2*pow(kx,3)-pow(kx,2)+3*kx-1;
}
double cf1(double kx){
	return 6*pow(kx,2)-2*kx+3;
}
double cfnewton(double kx){
	return kx-cf(kx)/cf1(kx);
}
double newton(double kx,double E){
	double x[NUMBER]={0};
	cout<<"newton"<<endl;
	x[0]=kx;
	x[1]=cfnewton(x[1]);
	cout<<"the value is "<<x[0]<<endl;
	int ptr=1;
	while(x[ptr]-x[ptr-1]>E||x[ptr-1]-x[ptr]>E){
		printf("%d times %.10f \n",ptr,x[ptr-1]);
		x[ptr+1]=cfnewton(x[ptr]);
		ptr++;
	}
	//printf("%.10f %.10f\n",x[ptr-1],x[ptr]);
	cout<<ptr<<endl;
	return x[ptr];
}
double divide(double a,double b,double E){
	int sum=0;
	cout<<"sub devide"<<endl;
	cout<<"the value is:"<<a<<" "<<b<<endl;
	while(a-b>E||b-a>E){
		printf("%d times %.10f %.10f\n",sum,a,b);
		if(cf((a+b)/2)==0) return (a+b)/2;
		if(cf((a+b)/2)*cf(b)<0){
			a=(a+b)/2;
		}
		else b=(a+b)/2;
		sum++;
	}
	//printf("%.10f %.10f\n",a,b);
	cout<<sum<<endl;
	return (a+b)/2;
}
int main(){
	printf("%.10f\n",newton(3,0.000001));
	printf("%.10f\n",divide(-3,3,0.000001));
	return 0;
}
