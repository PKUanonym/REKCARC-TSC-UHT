#include<bits/stdc++.h>
using namespace std;
int main(){
    ios::sync_with_stdio(false);
    cin.tie(0);
    int n,m;
    cin>>n>>m;
    vector<vector<pair<int,long long>>> g(n+1);
    for(int i=0;i<m;i++){
        int u,v,w;
        cin>>u>>v>>w;
        g[u].push_back({v,w});
        g[v].push_back({u,w});
    }
    vector<bool> vis(n+1,false);
    priority_queue<pair<long long,int>,vector<pair<long long,int>>,greater<pair<long long,int>>> pq;
    long long ans=0;
    int cnt=0;
    pq.push({0,1});
    while(!pq.empty()){
        auto [w,u]=pq.top();
        pq.pop();
        if(vis[u])continue;
        vis[u]=true;
        ans+=w;
        cnt++;
        if (cnt == n) break;
        for(auto [v,w]:g[u]){
            if(!vis[v]){
                pq.push({w,v});
            }
        }
    }cout<<ans<<'\n';
    return 0;
}