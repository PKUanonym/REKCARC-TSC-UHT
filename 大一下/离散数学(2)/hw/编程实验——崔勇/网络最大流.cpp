#include<bits/stdc++.h>
using namespace std;
struct Edge {
    int to;
    long long cap;
    int rev;
};
const long long INF=LLONG_MAX;
class FordFulkerson {
    public:
    int n;
    vector<vector<Edge>>g;
    vector<int>vis;
    FordFulkerson(int n) {
        this->n = n;
        g.resize(n+1);
        vis.resize(n+1);
    }
    void addEdge(int u,int v,long long c) {
        Edge forward = {v,c,(int)g[v].size()};
        Edge backward = {u,0,(int)g[u].size()};
        g[u].push_back(forward);
        g[v].push_back(backward);
    }
    long long dfs(int u,int t,long long f) {
        if (u==t)return f;
        vis[u]=1;
        for (int i=0;i<(int)g[u].size();i++) {
            Edge &e=g[u][i];
            if (!vis[e.to]&&e.cap>0) {
                long long pushed=dfs(e.to,t,min(f,e.cap));
                if (pushed>0) {
                    e.cap-=pushed;
                    g[e.to][e.rev].cap+=pushed;
                    return pushed;
                }
            }
        }
        return 0;
    }
    long long maxFlow(int s,int t) {
        long long flow=0;
        while (true) {
            fill(vis.begin(),vis.end(),0);
            long long pushed=dfs(s,t,INF);
            if (pushed==0)break;
            flow+=pushed;
        }
        return flow;

    }


};
int main () {
    int n,m,s,t;
    cin>>n>>m>>s>>t;
    FordFulkerson solver(n);
    for (int i=0;i<m;i++) {
        int u,v;
        long long c;
        cin>>u>>v>>c;
        solver.addEdge(u,v,c);
    }
    cout<<solver.maxFlow(s,t);
    return 0;
}