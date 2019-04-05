#include <iostream>
#include <cmath>
using namespace std;
double E;
double value[100]={0};
double function(double x){
	return 0.5*(1-exp(-x/E))/(1-exp(-1/E))+0.5*x;
}
int main(){
	E=0.01;
	for(int i=0;i<100;i++){
		value[i]=function(i*0.01);
		cout<<value[i]<<" ";
	}
	cout<<endl;
	return 0;
}