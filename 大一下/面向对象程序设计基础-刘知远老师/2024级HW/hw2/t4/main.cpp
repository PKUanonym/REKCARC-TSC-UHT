#include <cstdio>
#include <vector>
#include "weapon_slot.hpp"

int main() {
    int n, m;
    scanf("%d%d", &n, &m);
    std::vector<WeaponSlot> slots(n);
    
    while (m--) {
        int op, i, j, a, d, p;
        scanf("%d", &op);
        if (op == 0) {
            scanf("%d%d", &i, &p);
            slots[i].create_weapon(p);
        } else if (op == 1) {
            scanf("%d%d", &i, &a);
            slots[i].add_spell(a);
        } else if (op == 2) {
            scanf("%d%d", &i, &j);
            slots[j] = std::move(slots[i]);
        } else if (op == 3) {
            scanf("%d%d", &i, &j);
            slots[j] = slots[i];
        } else if (op == 4) {
            scanf("%d%d", &i, &d);
            printf("%d\n", slots[i].calc_damage_typeA(d));
        } else if (op == 5) {
            scanf("%d", &i);
            printf("%d\n", slots[i].calc_damage_typeB());
        } else if (op == 6) {
            scanf("%d", &i);
            printf("%d\n", slots[i].calc_damage_typeC());
        }
    }
    return 0;
}