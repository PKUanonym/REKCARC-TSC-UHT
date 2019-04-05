#include <iostream>
#include <math.h>
#define N 3
void matrixx(double A[N][N],double x[N],double v[N])
{
    for(int i=0;i<N;i++)
          {
            v[i]=0;
            for(int j=0;j<N;j++)
                v[i]+=A[i][j]*x[j];
          }
    
}
double slove(double v[N])
{
    double max;
    for(int i=0;i<N-1;i++) max=v[i]>v[i+1]?v[i]:v[i+1];
    return max;
}

using namespace std;
int main()    
{
    //data input
double A[N][N]={5,-4,1,-4,6,-4,1,-4,7};
    double x[N]={1,1,1};
    double v[N]={0,0,0};
    double u[N]={0,0,0};
    double p[N]={0,0,0};
    double e=1e-10,delta=1;
    int k=0;
    while(delta>=e)
    {
                for(int q=0;q<N;q++) p[q]=v[q];
        matrixx(A,x,v);
        for(int i=0;i<N;i++) u[i]=v[i]/(slove(v));
        delta=fabs(slove(v)-slove(p));
        k++;
        for(int l=0;l<N;l++) x[l]=u[l];
    }
    cout << "迭代次数" << k << endl;
    cout << "矩阵的特征值" << slove(v) << endl;
    cout << "(" ;
    for(int i=0;i<N;i++) cout << u[i] << " " ;
    cout  << ")" << endl;
    system("pause");
    return 0;
} 
