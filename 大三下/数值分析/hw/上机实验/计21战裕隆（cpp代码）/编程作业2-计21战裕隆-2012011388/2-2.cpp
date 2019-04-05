#include<iostream>
#include<cmath>

using namespace std;
double ydeyi=1.86548,yden=-0.046115;
double x[]={0.52,3.1,8.0,17.95,28.65,39.62,50.65,78.0,104.6,156.6,208.6,260.7,312.5,364.4,416.3,468.0,494.0,507.0,520.0};
double y[]={5.288,9.4,13.84,20.2,24.9,28.44,31.1,35.0,36.9,36.6,34.6,31.0,26.34,20.9,14.8,7.8,3.7,1.5,0.2};
double h[20],x1[20],x2[20],d[20];//x1____u,x2_______lamuda
double f[20];//一阶均差 
double jieguo[20];

double hanshu(int t,double xx)
{
	double sum1,sum2,sum3,sum4,sum;
	sum=0.0;
	sum1=jieguo[t]*(x[t+1]-xx)*(x[t+1]-xx)*(x[t+1]-xx)/6.0/h[t];
	sum2=jieguo[t+1]*(xx-x[t])*(xx-x[t])*(xx-x[t])/6.0/h[t];
	sum3=(y[t]-jieguo[t]*h[t]*h[t]/6.0)*(x[t+1]-xx)/h[t];
	sum4=(y[t+1]-jieguo[t+1]*h[t]*h[t]/6.0)*(xx-x[t])/h[t];
	sum=sum1+sum2+sum3+sum4;
	return sum;
}

double yicidao(int t,double xx)
{
	return (-jieguo[t]*(x[t+1]-xx)*(x[t+1]-xx)/2.0/h[t]+jieguo[t+1]*(xx-x[t])*(xx-x[t])/2.0/h[t]+(y[t+1]-y[t])/h[t]-(jieguo[t+1]-jieguo[t])/6.0/h[t]);
}

double ercidao(int t,double xx)
{
	return (jieguo[t]*(x[t+1]-xx)/h[t]+jieguo[t+1]*(xx-x[t])/h[t]);
}

int pinggu(double t)
{
	for(int i=0;i<=18;i++)
	{
		if((x[i]<=t) && (x[i+1]>=t))
		{
			return i;
		}
	}
}

int main()
{
	for(int i=0;i<=17;i++)
	{
		h[i]=x[i+1]-x[i];
	}
	for(int i=1;i<=17;i++)
	{
		x1[i]=h[i-1]/(h[i-1]+h[i]);
		x2[i]=h[i]/(h[i-1]+h[i]);
	}
	x2[0]=1.0;
	x1[18]=1.0;
	for(int i=0;i<=17;i++)
	{
		f[i]=(y[i+1]-y[i])/(x[i+1]-x[i]);
	}
	for(int i=1;i<=17;i++)
	{
		d[i]=6*(f[i]-f[i-1])/(h[i-1]+h[i]);
	}
	d[0]=6*(f[0]-ydeyi)/h[0];
	d[18]=6*(yden-f[17])/h[17];
	double G1[20][20][20],d1[20][20];
	for(int i=1;i<=19;i++)
	{
		for(int j=1;j<=19;j++)
		{
			for(int k=1;k<=19;k++)
			{
				G1[i][j][k]=0.0;
			}
		}
	}
	for(int i=1;i<=19;i++)
	{
		d1[1][i]=d[i+1];
		G1[1][i][i]=2.0;
	}
	for(int i=1;i<=18;i++)
	{
		G1[1][i+1][i]=x2[i-1];
		G1[1][i][i+1]=x1[i];
	}//构造结束，接下来高斯消元
	double temp1[20][20];
	for(int k=1;k<=18;k++)
	{
		for(int i=k+1;i<=19;i++)
		{
			temp1[i][k]=G1[k][i][k]/G1[k][k][k];
		}
		for(int i=k+1;i<=19;i++)
		{
			d1[k+1][i]=d1[k][i]-temp1[i][k]*d1[k][k];
		}
		for(int i=k+1;i<=19;i++)
		{
			for(int j=k+1;j<=19;j++)
			{
				G1[k+1][i][j]=G1[k][i][j]-temp1[i][k]*G1[k][k][j];
			}
		}
	} 
	jieguo[19]=d1[19][19]/G1[19][19][19];
	for(int i=18;i>=1;i--)
	{
		double sum=0.0;
		for(int j=i+1;j<=19;j++)
		{
			sum=sum+G1[i][i][j]*jieguo[j];
		}
		jieguo[i]=(d1[i][i]-sum)/G1[i][i][i];
	}
	for(int i=0;i<=18;i++)
	{
		jieguo[i]=jieguo[i+1];
	}
	for(int i=0;i<=18;i++)
	{
		cout<<jieguo[i]<<endl;
	}
	double c[]={2,30,133,390,470,515};
	int temp;
	for(int i=0;i<=5;i++)
	{
		temp=pinggu(c[i]);
		cout<<temp<<endl;
		cout<<c[i]<<": 函数值： "<<hanshu(temp,c[i])<<" 一次导："<<yicidao(temp,c[i])<<" 二次导："<<ercidao(temp,c[i])<<endl;
	}
	system("pause");
	return 0;
}
