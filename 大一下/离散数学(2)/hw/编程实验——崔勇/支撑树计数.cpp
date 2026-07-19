#include<bits/stdc++.h>
using namespace std;
const long long MOD=998244353;
long long qpow(long long a,long long e){
    long long r=1;
    a%=MOD;
    while(e){
        if(e&1)r=r*a%MOD;
        a=a*a%MOD;
        e>>=1;
    }
    return r;
}
long long det_mod(vector<vector<long long>>& a) {
    int n=a.size();
    long long res=1;
    for(int i=0;i<n;i++){
        int pivot=i;
        while(pivot < n && a[pivot][i]==0)pivot++;
        if(pivot==n)return 0;
        if(pivot!=i){
            swap(a[i],a[pivot]);
            res=(MOD-res)%MOD;
        }
        long long inv=qpow(a[i][i],MOD-2);
        for(int j=i+1;j<n;j++){
            if(a[j][i]==0)continue; 
            long long factor=a[j][i]*inv%MOD;
            for(int k=i;k<n;k++){
                a[j][k]=(a[j][k]-factor*a[i][k]%MOD+MOD)%MOD;
                if(a[j][k]<0)a[j][k]+=MOD;
            }
        }
        res=res*a[i][i]%MOD;
    }
    return res;
}
int main(){
    ios::sync_with_stdio(false);
    cin.tie(0);
    int n,m;
    cin>>n>>m;
    vector<vector<long long>> L(n,vector<long long>(n,0));
    for(int i=0;i<m;i++){
        int u,v;
        cin>>u>>v;
        u--;v--;
        L[u][u]++;
        L[v][v]++;
        L[u][v]--;
        L[v][u]--;
    }
    if(n==1){cout<<1<<'\n';return 0;}
    vector<vector<long long>> subL(n-1,vector<long long>(n-1));
    for(int i=0;i<n-1;i++){
        for(int j=0;j<n-1;j++){
            subL[i][j]=L[i][j];
        }
    }
    cout<<det_mod(subL)<<'\n';
    return 0;

}