#include <iostream>
using namespace std;
int value(double E){
	int n=1;
	double LN2=0.693147180560;
	float sum=0.0;
	while(LN2-(double)sum>E||(double)sum-LN2>E){
		if(n%2==0)	sum=sum-float(1.0/n);
		else	sum=sum+float(1.0/n);
		n++;
		//printf("%.16f %.16f",sum,LN2);
	}
	return n;
}
int main(){
	cout<<"when the E is 0.000005:  n="<<value(0.000005)<<endl;
	cout<<"when the E is 0.0000005: n="<<value(0.0000005)<<endl;
	return 0;
}