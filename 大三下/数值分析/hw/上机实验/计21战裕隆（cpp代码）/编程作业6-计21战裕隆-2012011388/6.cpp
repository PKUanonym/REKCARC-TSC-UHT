#include<iostream>
#include<cstdlib>
#include<cmath>
#include<memory>
#include<iomanip>

using namespace std;

int n;
double use[17][17];
double ni[17][17];
double ni_temp[17][40];
double b[17];
double temp[17][17];
double x1[15],x[15];
double temp_1[15];
double cancha[15],wucha[15];

int main()
{
	cin>>n;
	for(int i=0;i<15;i++)
	{
		for(int j=0;j<15;j++)
		{
			use[i][j]=1.0/(i+j+1);
		}
	}
	for(int i=0;i<15;i++)
 	{
  		for(int j=0;j<15;j++)
  		{
   		ni_temp[i][j]=use[i][j];
  		}
 	}
 	for(int i=0;i<15;i++)
 	{
  		for(int j=15;j<30;j++)
  		{
   		if(i==(j-15))
   		{
    			ni_temp[i][j]=1;
   		}
   		else
   		{
    			ni_temp[i][j]=0;
   		}
  		}
 	} 
 	for(int i=0;i<15;i++)
 	{
  		if(ni_temp[i][i]==0)
  		{
   		for(int k=i;k<15;k++)
   		{
    			if(ni_temp[k][k]!=0)
    			{
     				for(int j=0;j<30;j++)
     				{
      				double temp1;
				      temp1=ni_temp[i][j];
				      ni_temp[i][j]=ni_temp[k][j];
				      ni_temp[k][j]=temp1;
    				}
     			break;
    			}
   		}
  		}
  		for(int j=30-1;j>=i;j--)
  		{
   		ni_temp[i][j]/=ni_temp[i][i];
  		}
  		for(int k=0;k<15;k++)
  		{
   		if(k!=i)
		   {
		    	double temp2=ni_temp[k][i];
		    	for(int j=0;j<30;j++)
		    	{
		     		ni_temp[k][j]-=temp2*ni_temp[i][j];
		    	}
		   }
		}
 	} 
 	for(int i=0;i<15;i++)
 	{
  		for(int j=15;j<30;j++)
  		{
   		ni[i][j-15]=ni_temp[i][j];
  		}
 	}//求出逆矩阵 
	double sum3=0.0,sum4=0.0;
	double sum33=0.0,sum44=0.0;
	for(int i=0;i<3;i++)
	{
		sum3=sum3+use[i][0];
	}
	for(int i=0;i<4;i++)
	{
		sum4=sum4+use[i][0];
	}
	/*for(int i=0;i<3;i++)
	{
		for(int j=0;j<3;j++)
		{
			cout<<ni[i][j]<<" ";
		}
		cout<<endl;
	}*/
	double he[5]={0.0};
	for(int i=0;i<3;i++)
	{
		for(int j=0;j<3;j++)
		{
			if(ni[i][j]>0)
				he[i]=he[i]+ni[i][j];
			else
				he[i]=he[i]-ni[i][j];
		}
	}
	sum33=he[0];
	for(int i=0;i<3;i++)
	{
		if(he[i]>sum33)
		{
			sum33=he[i];
		}
	}
	for(int i=0;i<=4;i++)
	{
		he[i]=0.0;
	}
	for(int i=0;i<4;i++)
	{
		for(int j=0;j<4;j++)
		{
			if(ni[i][j]>0)
				he[i]=he[i]+ni[i][j];
			else
				he[i]=he[i]-ni[i][j];
		}
	}
	sum44=he[0];
	for(int i=0;i<4;i++)
	{
		if(he[i]>sum44)
		{
			sum44=he[i];
		}
	}
	cout<<"H3的范数 "<<sum3<<endl;
	cout<<"H4的范数 "<<sum4<<endl;//完成第一个任务，求取H3，H4的无穷范数。
	double cond1,cond2;
	cond1=sum3*sum33;
	cond2=sum4*sum44;
	cout<<"H3的条件数 "<<cond1<<endl;
	cout<<"H4的条件数 "<<cond2<<endl;
	for(int i=0;i<15;i++)
	{
		b[i]=0.0;
	} 
	for(int i=0;i<10;i++)
	{
		for(int k=0;k<10;k++)
		{
			b[i]=b[i]+use[i][k];
		}
	}
	for(int i=0;i<10;i++)
	{
		b[i]=b[i]+0.0000001;
	}
	for(int i=0;i<n;i++)
	{
		for(int k=0;k<n;k++)
		{
			temp[i][k]=use[i][k];
		}
	}
	for(int i=0;i<n;i++)
	{
		for(int k=0;k<i;k++)
		{
			temp[i][i]=temp[i][i]-temp[i][k]*temp[i][k];
		}
		temp[i][i]=sqrt(temp[i][i]);
		for(int j=i+1;j<n;j++)
		{
			for(int k=0;k<i;k++)
			{
				temp[j][i]=temp[j][i]-temp[i][k]*temp[j][k];
			}
			temp[j][i]=temp[j][i]/temp[i][i];
		}
	}//分解
	/*for(int i=0;i<n;i++)
	{
		for(int k=0;k<n;k++)
		{
			cout<<temp[i][k]<<" ";
		}
		cout<<endl;
	}*/
	for(int i=0;i<n;i++)
	{
		x1[i]=b[i];
		for(int j=0;j<i;j++)
		{
			x1[i]=x1[i]-(temp[i][j]*x1[j]);
		}
		x1[i]=x1[i]/temp[i][i];
	}
	/*for(int i=0;i<n;i++)
	{
		cout<<x1[i]<<endl;
	} */
	for(int i=9;i>=0;i--)
	{
		x[i]=x1[i];
		for(int j=9;j>i;j--)
		{
			x[i]=x[i]-(temp[j][i]*x[j]);
		}
		x[i]=x[i]/temp[i][i];
	}
	/*for(int i=0;i<n;i++)
	{
		cout<<x[i]<<endl;
	}*/
	for(int i=0;i<n;i++)
	{
		wucha[i]=x[i]-1.0;
	}//误差计算完毕
	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			temp_1[i]=temp_1[i]+use[i][j]*x[j];
		}
		cancha[i]=b[i]-temp_1[i];
	}
	double wucha_max=abs(wucha[0]),cancha_max=abs(cancha[0]);
	for(int i=1;i<n;i++)
	{
		if(abs(wucha[i])>wucha_max)
		{
			wucha_max=abs(wucha[i]);
		}
		if(abs(cancha[i])>cancha_max)
		{
			cancha_max=abs(cancha[i]);
		}
	}
	cout<<"残差："<<cancha_max<<endl;
	cout<<"误差："<<wucha_max<<endl;
	system("pause");
	return 0;
}
