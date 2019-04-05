#include <iostream>
using namespace std;
#define NUM 4
double G[NUM][NUM]={0.0};
void mul(double b[],double y){
	double a[NUM]={0};
	double max_ai=0;
	for(int i=0;i<NUM;i++){
		for(int j=0;j<NUM;j++){
			a[i]+=b[j]*G[i][j];
		}
		if(a[i]<max_ai){
			max_ai=a[i];
		}
	}
	double y1=a[0]/b[0];
	for(int i=0;i<NUM;i++){
		a[i]=a[i]/max_ai;
	}
	if(y-y1<0.00001&&y1-y<0.00001){
		cout<<y1<<endl;
		cout<<"the v[i] is: "<<endl;
		for(int i=0;i<NUM;i++){
			cout<<b[i]<<" ";
		}
		return;
	}
	delete b;
	mul(a,y1);
}
int main(){
	double a1[4][4]={{25,-41,10,-6},{-41,68,-17,10},{10,-17,5,3},{-6,10,-3,2}};
	double a2[3][3]={{5,-4,1},{-4,6,-4},{1,-4,7}};
	double a[NUM]={0};
	for(int i=0;i<NUM;i++){
		a[i]=1;
		for(int j=0;j<NUM;j++){
			G[i][j]=a1[i][j];
		}
	}
	mul(a,0);
	return 0;
}