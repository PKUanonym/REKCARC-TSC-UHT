#include <iostream>
using namespace std;
double spl2(double x[],double y[] ,int n,double ddy1,double ddyn,double t[],int m,double z[]
)        
{
        int i,j;
        double h0,h1,alpha,beta,*s,*dy;
        s= new double[n];
        dy = new double[n];
        dy[0]=-0.5;
        h0=x[1]-x[0];
        s[0]=3.0*(y[1]-y[0])/(2.0*h0)-ddy1*h0/4.0;
        for (j=1;j<=n-2;j++)
        {
                h1=x[j+1]-x[j];
                alpha=h0/(h0+h1);
                beta=(1.0-alpha)*(y[j]-y[j-1])/h0;
                beta=3.0*(beta+alpha*(y[j+1]-y[j])/h1);
                dy[j]=-alpha/(2.0+(1.0-alpha)*dy[j-1]);
                s[j]=(beta-(1.0-alpha)*s[j-1]);
                s[j]=s[j]/(2.0+(1.0-alpha)*dy[j-1]);
                h0=h1;
        }
		/*
		for(j=1;j<=n-2;j++){
			cout<<s[j]<<" ";
		}
		*/
		cout<<endl;
        dy[n-1]=(3.0*(y[n-1]-y[n-2])/h1+ddyn*h1/2.0-s[n-2])/(2.0+dy[n-2]);
        for (j=n-2;j>=0;j--)        dy[j]=dy[j]*dy[j+1]+s[j];
        for (j=0;j<=n-2;j++)        s[j]=x[j+1]-x[j];
        for (j=0;j<=m-1;j++)
        {
                if (t[j]>=x[n-1]) i=n-2;
                else
                {
                        i=0;
                        while (t[j]>x[i+1]) i=i+1;
                }
                h1=(x[i+1]-t[j])/s[i];
				cout<<dy[j]<<" ";
                h0=h1*h1;
                z[j]=(3.0*h0-2.0*h0*h1)*y[i];
                z[j]=z[j]+s[i]*(h0-h0*h1)*dy[i];
                h1=(t[j]-x[i])/s[i];
                h0=h1*h1;
                z[j]=z[j]+(3.0*h0-2.0*h0*h1)*y[i+1];
                z[j]=z[j]-s[i]*(h0-h0*h1)*dy[i+1];
        }
        delete[] s;
        delete[] dy;
        return 0.0;
}
int main(){
	int N=19;
	double xx[19]={0.52,3.1,8,17.95,28.65,39.62,50.65,78,104.6,156.6,208.6,260.7,312.5,364.4,416.3,468,494,507,520};
double ff[19]={5.288,9.4,13.84,20.2,24.9,28.44,31.1,35,36.9,36.6,34.6,31,26.34,20.9,14.8,7.8,3.7,1.5,0.2};
	double xxxx[6]={2,30,133,390,470,515};
	double yyyy[6]={0};
	double y0=1.86548;
	double yn=-0.046115;
	spl2(xx,ff,N,y0,yn,xxxx,6,yyyy);
	for(int i=0;i<6;i++){
		cout<<yyyy[i]<<" ";
	}
	return 0;
}