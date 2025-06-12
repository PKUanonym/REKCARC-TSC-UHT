#include <cstdio>
#include <vector>

#include "event.h"
#include "strawchoco.h"

int main() {
    int n, m, l;
    std::vector<EventInterface*> strawchoco;
    scanf("%d%d%d", &n, &m, &l);
    for (int i = 0; i < n; ++i) strawchoco.push_back(new Chocolate());
    for (int i = 0; i < m; ++i) strawchoco.push_back(new Strawberry());

    int op, x, y;
    while (l--) {
        scanf("%d", &op);
        if (op == 0) {
            scanf("%d%d", &x, &y);
            strawchoco[x]->zoo(strawchoco[y]);
            strawchoco[y]->zoo(strawchoco[x]);
        } else if (op == 1) {
            scanf("%d%d", &x, &y);
            strawchoco[x]->shop(strawchoco[y]);
            strawchoco[y]->shop(strawchoco[x]);
        } else if (op == 2) {
            scanf("%d", &x);
            strawchoco[x]->birthday();
        }
    }
    for (int i = 0; i < n + m; ++i) {
        printf("%d\n", strawchoco[i]->get_mood());
        delete strawchoco[i]; // Clean up memory
    }

    return 0;
}