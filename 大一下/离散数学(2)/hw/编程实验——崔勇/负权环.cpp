#include<bits/stdc++.h>
using namespace std;
const long long INF=1e15;
struct Edge{
    int u,v,w;
};
int main(){
    int T;
    cin>>T;
    while(T--){
        int n,m;
        cin>>n>>m;
        vector<Edge>edges;
        for(int i=0;i<m;i++){
            int u,v,w;
            cin>>u>>v>>w;
            edges.push_back({u,v,w});
        }
        vector<long long>dist(n+1,INF);
        dist[1]=0;
        bool has_negative=false;
        for(int i=1;i<=n;i++){
            bool updated=false;
            for(auto &e:edges){
                if(dist[e.u]!=INF&&dist[e.u]+e.w<dist[e.v]){
                    dist[e.v]=dist[e.u]+e.w;
                    updated=true;
                    if(i==n) has_negative=true;
                }
            }
            if(!updated) break;
        }
        cout<<(has_negative?1:0)<<'\n';
    }
    return 0;
}