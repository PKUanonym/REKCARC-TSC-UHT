#include <iostream>
using namespace std;
#define NUM 10
double a[NUM][NUM]={};
double l[NUM][NUM]={0};
double u[NUM][NUM]={0};
double x[NUM]={0};
double y[NUM]={0};
double b[NUM]={};
double dx[NUM]={0};
double rx[NUM]={0};
int main(){
	for(int i=0;i<NUM;i++){
		l[i][i]=1;
	}
	for(int i=0;i<NUM;i++){
		l[i][i]=1;
		b[i]=0;
		for(int j=0;j<NUM;j++){
			a[i][j]=1.0/(i+j+1);
			b[i]+=a[i][j];
		}
	}
	b[0]=b[0]+0.0000001;
	for(int i=0;i<NUM;i++){
		u[0][i]=a[0][i];
	}
	for(int i=1;i<NUM;i++){
		l[i][0]=a[i][0]/u[0][0];
	}
	for(int r=1;r<NUM;r++){
		for(int i=r;i<NUM;i++){
			u[r][i]=a[r][i];
			for(int k=0;k<r;k++){
				u[r][i]=u[r][i]-l[r][k]*u[k][i];
			}
		}
		for(int i=r+1;i<NUM;i++){
			l[i][r]=a[i][r];
			for(int k=0;k<r;k++){
				l[i][r]=l[i][r]-l[i][k]*u[k][r];
			}
			l[i][r]=l[i][r]/u[r][r];
		}
		
	}
/*
	for(int i=0;i<NUM;i++){
		for(int j=0;j<NUM;j++){
			cout<<l[i][j]<<" ";
		}
		cout<<endl;
	}
	for(int i=0;i<NUM;i++){
		for(int j=0;j<NUM;j++){
			cout<<u[i][j]<<" ";
		}
		cout<<endl;
	}
	*/
	y[0]=b[0];
	for(int i=1;i<NUM;i++){
		y[i]=b[i];
		for(int j=0;j<i;j++){
			y[i]=y[i]-l[i][j]*y[j];
		}
	}
	x[NUM-1]=y[NUM-1]/u[NUM-1][NUM-1];
	for(int i=NUM-2;i>=0;i--){
		x[i]=y[i];
		for(int k=i+1;k<NUM;k++){
			x[i]=x[i]-u[i][k]*x[k];
		}
		x[i]=x[i]/u[i][i];
	}
	cout<<"solution: "<<endl;
	for(int i=0;i<NUM;i++){
		cout<<x[i]<<" ";
	}
	for(int i=0;i<NUM;i++){
		rx[i]=b[i];
		for(int j=0;j<NUM;j++){
			rx[i]=rx[i]-a[i][j]*x[j];
		}
	}
	cout<<endl;
	cout<<"rx: ";
	double  max1=0,max2=0;
	for(int i=0;i<NUM;i++){
		cout<<rx[i]<<" ";
		if(rx[i]<0&&(-rx[i]>max1)){
			max1=-rx[i];
		}
		else if(rx[i]>0&&rx[i]>max1){
			max1=rx[i];
		}
	}
	for(int i=0;i<NUM;i++){
		dx[i]=x[i]-1;
	}
	cout<<endl;
	cout<<"dx: ";
	for(int i=0;i<NUM;i++){
		cout<<dx[i]<<" ";
		if(dx[i]<0&&(-dx[i]>max2)){
			max2=-dx[i];
		}
		else if(dx[i]>0&&dx[i]>max2){
			max2=dx[i];
		}
	}
	cout<<endl;
	cout<<"cond: "<<max1<<" "<<max2<<endl;
	return 0;
}
