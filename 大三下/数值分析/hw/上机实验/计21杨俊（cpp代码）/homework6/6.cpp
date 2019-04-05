#include <iostream>
using namespace std;
#define N 4

double inverse(double **a,const int n){
	double max1=-9999;
	for(int i=0;i<n;i++){
		double value=0;
		for(int j=0;j<n;j++){
			if(a[i][j]>0) max1+=a[i][j];
			else max1-=a[i][j];
		}
		if(max1<value) max1=value;
	}
	double b[N][N]={0};
	for(int i=0;i<n;i++){
		b[i][i]=1;
	}
	double m;
	for(int k=0;k<n;k++){
		for(int i=0;i<n;i++){
			if(i==k) continue;
			m=a[i][k]/a[k][k];
			for(int j=0;j<n;j++){
				a[i][j]=a[i][j]-a[k][j]*m;
				b[i][j]=b[i][j]-b[k][j]*m;
			}
		}

	}
	double max=-9999;
	for(int i=0;i<n;i++){
		double value=0;
		for(int j=0;j<n;j++){
			if(b[i][j]>0){
				value+=b[i][j];
			}
			else value+=-b[i][j];
		}
		if(value>max) max=value;
	}
	return max+max1;
}
//double LU(double a[N][N],double b[],double c[N],int n){
	
//}
int main(){
	double **a;
	a = new double *[N];
	for(int i=0; i<N; i++)
		a[i] = new double[N];
	
	double aa1[4][4]={{1,1.0/2,1.0/3,1/4.0},{1.0/2,1.0/3,1.0/4,1/5.0},{1.0/3,1.0/4,1.0/5,1/6.0},{1.0/4,1.0/5,1/6.0,1/7.0}};
	for(int i=0;i<N;i++){
		for(int j=0;j<N;j++){
			a[i][j]=aa1[i][j];
		}
	}
	cout<<inverse(a,N);
	return 0;
}
