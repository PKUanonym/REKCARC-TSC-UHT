#include <bits/stdc++.h>
using namespace std;

const int N = 2005;
const int INF_EDGE = 0x3f3f3f3f;     
const long long INF_DIST = (long long)4e18; 

int g[N][N];
long long dista[N];
bool vis[N];

void Dijkstra(int s, int n) {
    for (int i = 1; i <= n; i++) {
        dista[i] = INF_DIST;
        vis[i] = false;
    }
    dista[s] = 0;

    for (int i = 1; i <= n; i++) {
        int u = -1;
        for (int j = 1; j <= n; j++) {
            if (!vis[j] && (u == -1 || dista[j] < dista[u])) {
                u = j;
            }
        }

        if (u == -1 || dista[u] == INF_DIST) break;

        vis[u] = true;

        for (int v = 1; v <= n; v++) {
            if (!vis[v] && g[u][v] != INF_EDGE) {
                dista[v] = min(dista[v], dista[u] + (long long)g[u][v]);
            }
        }
    }
}

int main() {
    int n, m;
    cin >> n >> m;

    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            g[i][j] = INF_EDGE;
        }
        g[i][i] = 0;
    }

    for (int i = 1; i <= m; i++) {
        int a, b, c;
        cin >> a >> b >> c;
        g[a][b] = min(g[a][b], c); 
    }

    Dijkstra(1, n);

    for (int i = 1; i <= n; i++) {
        if (dista[i] == INF_DIST) cout << -1 << " ";
        else cout << dista[i] << " ";
    }
    cout << '\n';

    return 0;
}