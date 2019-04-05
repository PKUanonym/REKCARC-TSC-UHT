#include <iostream>
#include <fstream>
using namespace std;
#define N 100
double E=0;
int n=100;
double h=0;
double A[N][N]={0};
double b[N]={0};
double answer[N]={0};
int num=0;
int number=100;
ofstream fout("output.txt");
void jacobi(double solve[]){
	num++;
	for(int i=0;i<N;i++){
		answer[i]=b[i];
		for(int j=0;j<N;j++){
			if(i==j) continue;
			answer[i]=answer[i]-A[i][j]*solve[j];
		}
		answer[i]=answer[i]/A[i][i];
	}
	if(num==number){
		double fa=0.0;
		for(int i=0;i<N;i++){
			fa=fa+answer[i];
			cout<<answer[i]<<" ";
			fout<<answer[i]<<" ";
		}
	}
	else jacobi(answer);
	/*
	int flag=0;
	for(int i=0;i<N;i++){
		if(answer[i]-solve[i]>0.000000005||solve[i]-answer[i]>0.000000005){
			flag=1;
			jacobi(answer);
			break;
		}
	}
	if(flag==0){
		for(int i=0;i<N;i++){
			cout<<answer[i]<<" ";
		}
	}
	*/
}
void gauss(double solve[]){
	num++;
	for(int i=0;i<N;i++){
		answer[i]=b[i];
		for(int j=0;j<i;j++){
			answer[i]-=A[i][j]*answer[j];
		}
		for(int j=i+1;j<N;j++){
			answer[i]-=A[i][j]*solve[j];
		}
		answer[i]/=A[i][i];
	}
	if(num==number){
		for(int i=0;i<N;i++){
			cout<<answer[i]<<" ";
			fout<<answer[i]<<" ";
		}
	}
	else gauss(answer);
	/*
	for(int i=0;i<N;i++){
		answer[i]=b[i];
		for(int j=0;j<i-1;j++){
			answer[i]-=A[i][j]*solve[j];
		}
		for(int j=i+1;j<N;j++){
			answer[i]-=A[i][j]*solve[j];
		}
		answer[i]/=A[i][i];
	}*/
	/*
	int flag=0;
	for(int i=0;i<N;i++){
		if(answer[i]-solve[i]>0.000000005||solve[i]-answer[i]>0.000000005){
			flag=1;
			gauss(answer);
			break;
		}
	}
	if(flag==0){
		for(int i=0;i<N;i++){
			cout<<answer[i]<<" ";
		}
	}
	*/
}
void SOR(double solve[]){
	num++;
	for(int i=0;i<N;i++){
		answer[i]=b[i];
		for(int j=0;j<i;j++){
			answer[i]-=A[i][j]*answer[j];
		}
		for(int j=0;j<N;j++){
			answer[i]-=A[i][j]*solve[j];
		}
		answer[i]/=A[i][i];
		answer[i]=solve[i]+1.3*answer[i];
	}
	if(num==number){
		for(int i=0;i<N;i++){
			cout<<answer[i]<<" ";
			fout<<answer[i]<<" ";
		}
	}
	else gauss(answer);
	/*
	int flag=0;
	for(int i=0;i<N;i++){
		if(answer[i]-solve[i]>0.000000005||solve[i]-answer[i]>0.000000005){
			flag=1;
			gauss(answer);
			break;
		}
	}
	if(flag==0){
		for(int i=0;i<N;i++){
			cout<<answer[i]<<" ";
		}
	}
	*/
}
int main(){
	E=0.001;
	h=1.0/n;
	A[N-1][N-1]=-(2*E+h);
	for(int i=0;i<N-1;i++){
		A[i][i]=-(2*E+h);
		A[i][i+1]=E+h;
		A[i+1][i]=E;
	}
	for(int i=0;i<N;i++){
		b[i]=0.5*h*h;
	}/*
	cout<<endl;
	
	for(int i=0;i<N;i++){
		for(int j=0;j<N;j++){
			cout<<A[i][j]<<" ";
		}
		cout<<endl;
	}
	*/
	double solve[N]={0};
	for(int i=0;i<N;i++){
		solve[i]=0;
	}
	jacobi(solve);
	cout<<endl<<endl;
	fout<<endl<<endl;
	num=0;
	gauss(solve);
	num=0;
	fout<<endl<<endl;
	cout<<endl<<endl;
	SOR(solve);
	/*
	cout<<A[0][0]<<" "<<A[1][0]<<" "<<A[0][1]<<endl;
	for(int i=0;i<N;i++){
		cout<<b[i]<<" ";
	}
	*/
	return 0;
}
