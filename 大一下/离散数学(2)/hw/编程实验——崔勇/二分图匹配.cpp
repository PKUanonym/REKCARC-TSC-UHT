#include<bits/stdc++.h>
using namespace std;
const int N=510;
vector<vector<int>> L(N);
int match[N];
bool vis[N];
bool dfs(int u) {
    for (auto v : L[u]) {
        if (vis[v])continue;
        vis[v]=true;
        if (match[v]==0||dfs(match[v])) {
            match[v]=u;
            return true;
        }
    }
    return false;
}
int main() {
    int nl,nr,m;
    cin>>nl>>nr>>m;
    for (int i=0;i<m;i++) {
        int u,v;
        cin>>u>>v;
        L[u].push_back(v);
    }
    int ans=0;
    for (int i=1;i<=nl;i++) {
        memset(vis,false,sizeof vis);
        if (dfs(i)) ans++;
    }
    cout<<ans<<endl;
    vector<int> matched(nl+1,0);
    for (int i=1;i<=nr;i++) {
        int v=match[i];
        matched[v]=i;
    }
    for (int i=1;i<=nl;i++) {
        cout<<matched[i]<<" ";
    }
    return 0;

}