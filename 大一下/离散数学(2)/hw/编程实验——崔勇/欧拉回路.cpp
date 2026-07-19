#include<bits/stdc++.h>
using namespace std;
const int INF=100005;
struct E {
    int to,id;
};
int a[2*INF],b[2*INF],deg[INF],ptr[INF];
bool vis[INF],used[2*INF];
vector<E> g[INF];
vector<int>ans;
void dfs_connection(int u) {
    vis[u]=true;
    for (auto e:g[u]) {
        if (!vis[e.to]) {
            dfs_connection(e.to);
        }
    }
}
void dfs_euler(int u) {
    while (ptr[u]<(int)g[u].size()) {
        auto [v,id]=g[u][ptr[u]++];
        if (used[id]) continue;
        used[id]=true;
        dfs_euler(v);
        if (u==a[id]&&v==b[id])ans.push_back(id);
        else ans.push_back(-id);
    }
}
int main() {
    int n, m;
    cin >> n >> m;
    for (int i=1;i<=m;i++) {
        cin >> a[i] >> b[i];
        deg[a[i]]++;
        deg[b[i]]++;
        g[a[i]].push_back({b[i],i});
        g[b[i]].push_back({a[i],i});
    }
    for (int i=1;i<=n;i++) {
        if (deg[i]%2) {
            cout << "NO"<<endl;
            return 0;
        }
    }
    if (m==0) {
        cout<<"YES"<<endl;
        return 0;
    }
    int s=1;
    while (s<=n&&deg[s]==0) s++;

    dfs_connection(s);
    for (int i=1;i<=n;i++) {
        if (!vis[i]&&deg[i]>0) {
            cout<<"NO"<<endl;
            return 0;
        }
    }
    dfs_euler(s);
    if ((int)ans.size()!=m) {
        cout << "NO"<<endl;
        return 0;
    }
    reverse(ans.begin(),ans.end());
    cout<<"YES"<<endl;
    for (int i=0;i<m;i++) {
        cout<<ans[i]<<' ';
    }
    return 0;
}