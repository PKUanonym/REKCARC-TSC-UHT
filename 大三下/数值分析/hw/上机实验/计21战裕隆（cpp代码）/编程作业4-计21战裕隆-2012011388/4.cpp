#include<iostream>
#include<cmath>

using namespace std;

long double fuzhu_1(double x,int t)
{
	if(t==1)
	return 1.0/x;
	else
	return 1.0/(1+x*x);
}

long double fuzhu(double a,double b,int n,int t)
{
	double h=(b-a)/n;
	double sum=0.0;
	for(int i=0;i<=n-1;i++)
	{
		sum=sum+fuzhu_1(a+i*h+h/2,t);
	}
	sum=sum*(h/2);
	return sum;
}
long double simpson(double a,double b,int n,int t)
{
	double h=(b-a)/double(n);
	double sum;
	sum=fuzhu_1(a,t)+fuzhu_1(b,t)+4*fuzhu_1(a+h/2,t);//注意下标不同，不要搞错了 
	for(int i=1;i<=n-1;i++)
	{
		sum=sum+4*fuzhu_1(a+i*h+h/2,t)+2*fuzhu_1(a+i*h,t);
	}
	sum=sum*(h/6);
	return sum;
}//求取ln2,pai 

long double romberg(double a,double b,int t)
{
	double temp1[5000];
	double temp2[5000];
	double h=b-a;
	int i=2;
	temp1[0]=(fuzhu_1(a,t)+fuzhu_1(b,t))*h/2;
	temp2[0]=(temp1[0]/2)+fuzhu(a,b,1,t);
	temp2[1]=pow(4.0,1)/(pow(4.0,1)-1)*temp2[0]-1.0/(pow(4.0,1)-1)*temp1[0];
	while(abs(temp2[i-1]-temp1[i-2])>pow(10.0,-9))
	{
		//cout<<i<<" "<<temp2[i-1]<<" "<<temp1[i-2]<<endl;
		for(int j=0;j<i;j++)
		{
			temp1[j]=temp2[j];
		}    
		temp2[0]=temp1[0]/2+fuzhu(a,b,int(pow(2.0,i-1)),t);
		for(int j=1;j<=i+1;j++)
		{
			temp2[j]=pow(4.0,j)/(pow(4.0,j)-1)*temp2[j-1]-1.0/(pow(4.0,j)-1)*temp1[j-1];
		}
		i++;
	}
	//cout<<"fuck"<<endl;
	return temp2[i-1];
}

long double gauss(double a,double b,int n,int t)
{
	double h=(b-a)/double(n);
	double sum=0.0;
	for(int i=0;i<=n-1;i++)
	{
		sum=sum+fuzhu_1(a+i*h+h/2-h/2/pow(3.0,0.5),t)+fuzhu_1(a+i*h+h/2+h/2/pow(3.0,0.5),t);
	}
	sum=sum*h/2;
	return sum;
}

int main()
{
	double ln2=0.6931471806,pi=3.1415926535;
	cout<<"simpson:"<<endl;
	cout<<"ln2: "<<simpson(1,2,36,1)<<" 误差为："<<abs(simpson(1,2,36,1)-ln2)<<endl;
	cout<<"pi: "<<4*simpson(0,1,36,2)<<" 误差为："<<abs(4*simpson(0,1,36,2)-pi)<<endl;
	cout<<"romberg:"<<endl;
	cout<<"ln2: "<<romberg(1,2,1)<<" 误差为 "<<abs(romberg(1,2,1)-ln2)<<endl; 
	cout<<"pi: "<<4*romberg(0,1,2)<<" 误差为："<<abs(4*romberg(0,1,2)-pi)<<endl;
	cout<<"gauss:"<<endl;
	cout<<"ln2: "<<gauss(1,2,33,1)<<" 误差为 "<<abs(gauss(1,2,33,1)-ln2)<<endl; 
	cout<<"pi: "<<4*gauss(0,1,33,2)<<" 误差为："<<abs(4*gauss(0,1,33,2)-pi)<<endl;
	system("pause");
	return 0;
}
