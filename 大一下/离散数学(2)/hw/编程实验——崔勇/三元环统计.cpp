#include<iostream>
#include<vector>
#include<map>
using namespace std;
int main(){
    int n,m;
    cin>>n>>m;
    vector<int>a(n+1);
    for(int i=1;i<=n;i++){
        cin>>a[i];
    }
    vector<pair<int,int>>edges(n+1);
    vector<int>deg(n+1,0);
    map <pair<int,int>,bool>mp;
    for(int i=1;i<=m;i++){
        int x,y;
        cin>>x>>y;
        if(x>y) swap(x,y);
        if(mp[{x,y}]) continue;
        edges.push_back({x,y});
        deg[x]++;
        deg[y]++;
        mp[{x,y}] = true;
    }
    vector<vector<int>>g(n+1);
    auto smaller=[&](int x,int y){
        if(deg[x]!=deg[y]) return deg[x]<deg[y];
        return x<y;
    };
    for(auto[u,v]:edges){
        if(smaller(u,v)){
            g[u].push_back(v);
        }
        else{
            g[v].push_back(u);
        }
    }
    long long ans=0;
    for(int i=1;i<=n;i++){
        for(int j:g[i]){
            for(int k:g[j]){
                int x=min(i,k);
                int y=max(i,k);
                if(mp[{x,y}]) ans+=1LL*a[i]*a[j]*a[k];
            }
        }
    }
    cout<<ans<<endl;
    return 0;

}