#include <iostream>
using namespace std;
#define NUMBER 9
#define dex 4
double G[dex][dex]={0};
double b[dex]={0};
//double f[NUMBER]={4,4.5,6,8,8.5};
//double x[3][NUMBER]={{1,1,1,1,1},{1,2,3,4,5},{0,0,0,0,0}};
double f[NUMBER]={805,985,1170,1365,1570,1790,2030,2300,2610};
double x[dex+1][NUMBER]={{1,1,1,1,1,1,1,1,1},{20,25,30,35,40,45,50,55,60},{0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0}};
double mul_sum(double a[],double bb[]){
	double sum=0;
	for(int i=0;i<NUMBER;i++){
		sum=sum+a[i]*bb[i];
	}
	return sum;
}
void previous(){
	for(int i=0;i<NUMBER;i++){
		x[2][i]=x[1][i]*x[1][i];
		for(int j=3;j<=dex;j++){
			x[j][i]=x[j-1][i]*x[1][i];
		}
	}
}
double cf(double kx){
	return b[0]+b[1]*kx+b[2]*kx*kx+b[3]*kx*kx*kx;
}
void solve(){
	double m;
	for(int k=0;k<dex;k++){
		for(int i=0;i<dex;i++){
			if(k==i) continue;
			m=G[i][k]/G[k][k];
			for(int j=0;j<dex;j++){
				G[i][j]=G[i][j]-G[k][j]*m;
			}
			b[i]=b[i]-m*b[k];
		}
	}
	b[dex-1]=b[dex-1]/G[dex-1][dex-1];
	for(int i=dex-2;i>=0;i--){
		for(int j=i+1;j<dex;j++){
			b[i]=b[i]-G[i][j]*b[j];
		}
		b[i]=b[i]/G[i][i];
	}
}
int main(){
	previous();
	for(int i=0;i<dex+1;i++){
		for(int j=0;j<NUMBER;j++){
			cout<<x[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<endl;
	for(int i=0;i<dex;i++){
		for(int j=0;j<=i;j++){
			G[j][i]=G[i][j]=mul_sum(x[i],x[j]);
		}
		b[i]=mul_sum(x[i],f);
	}
	cout<<"G: "<<endl;
	for(int i=0;i<dex;i++){
		for(int j=0;j<dex;j++){
			cout<<G[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<"B: "<<endl;
	for(int i=0;i<dex;i++){
		cout<<b[i]<<" ";
	}
	solve();
	cout<<"f(x)="<<b[0]<<"+"<<b[1]<<"x^1+"<<b[2]<<"x^2+"<<b[3]<<"x^3"<<endl;
	for(int i=0;i<NUMBER;i++){
		cout<<cf(x[1][i])<<" "<<f[i]<<" "<<cf(x[1][i])-f[i]<<endl;
	}
	return 0;
}
