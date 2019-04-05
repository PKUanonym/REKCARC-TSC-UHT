#include<iostream>
#include<cmath>

using namespace std;
double jieguo[4];

void jisuan(double x[],double y[])
{
	int m=9,n=4;
	double temp[11][5];
	for(int i=1;i<=m;i++)
	{
		temp[i][1]=1;
		temp[i][2]=x[i];
		temp[i][3]=x[i]*x[i];
		temp[i][4]=x[i]*x[i]*x[i];
	}//用于构造G 
	double G[5][5],b[5];
	for(int i=1;i<=n;i++)
	{
		b[i]=0.0;
		for(int k=1;k<=n;k++)
		{
			G[i][k]=0.0;
		}
	}//数组初始化 
	for(int i=1;i<=n;i++)
	{
		for(int j=1;j<=n;j++)
		{
			for(int k=1;k<=m;k++)
			{
				G[i][j]=G[i][j]+temp[k][i]*temp[k][j];
			}
		}
	}
	for(int i=1;i<=n;i++)
	{
		for(int k=1;k<=m;k++)
		{
			b[i]=b[i]+temp[k][i]*y[k];
		}
	}//至此完成了G和b的构造，接下来gauss计算即可
	/*for(int i=1;i<=n;i++)
	{
		for(int k=1;k<=n;k++)
		{
			cout<<G[i][k]<<" ";
		}
		cout<<b[i]<<endl;
	}*/
	double G1[5][5][5],temp1[5][5];
	double b1[5][5];
	for(int i=1;i<=n;i++)
	{
		b1[1][i]=b[i];
		for(int k=1;k<=n;k++)
		{
			G1[1][i][k]=G[i][k];
		}
	}
	for(int k=1;k<=n-1;k++)
	{
		for(int i=k+1;i<=n;i++)
		{
			temp1[i][k]=G1[k][i][k]/G1[k][k][k];
		}
		for(int i=k+1;i<=n;i++)
		{
			b1[k+1][i]=b1[k][i]-temp1[i][k]*b1[k][k];
		}
		for(int i=k+1;i<=n;i++)
		{
			for(int j=k+1;j<=n;j++)
			{
				G1[k+1][i][j]=G1[k][i][j]-temp1[i][k]*G1[k][k][j];
			}
		}
	}//消元计算 
	jieguo[4]=b1[4][4]/G1[4][4][4];
	for(int i=n-1;i>=1;i--)
	{
		double sum=0.0;
		for(int j=i+1;j<=n;j++)
		{
			sum=sum+G1[i][i][j]*jieguo[j];
		}
		jieguo[i]=(b1[i][i]-sum)/G1[i][i][i];
	}
}

double guji(double t)
{
	double sum=0.0;
	double h[5];
	h[1]=1.0;
	h[2]=t;
	h[3]=t*t;
	h[4]=t*t*t;
	for(int i=4;i>=1;i--)
	{
		sum=sum+h[i]*jieguo[i];
	}
	return sum;
}

int main()
{
	double x[]={0.0,20.0,25.0,30.0,35.0,40.0,45.0,50.0,55.0,60.0};
	double y[]={0.0,805.0,985.0,1170.0,1365.0,1570.0,1790.0,2030.0,2300.0,2610.0};
	jisuan(x,y);
	/*for(int i=1;i<=4;i++)
	{
		cout<<jieguo[i]<<endl;
	}*/
	for(int i=4;i>=1;i--)
	{
		if(jieguo[i]>0&&i!=4)
		{
			cout<<"+";
		}
		if(i==1)
		{
			cout<<jieguo[i];
		}
		if(i!=1)
		{
			cout<<jieguo[i]<<"x^"<<(i-1);
		}
	}
	cout<<endl;
	for(int i=1;i<=9;i++)
	{
		cout<<x[i]<<": "<<guji(x[i])<<" 误差为 ："<<(y[i]-guji(x[i]))<<endl;
	}
	system("pause");
	return 0;
}
