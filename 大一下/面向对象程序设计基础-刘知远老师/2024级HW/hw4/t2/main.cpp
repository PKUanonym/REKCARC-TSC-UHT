#include <iostream>

#include "Alice.h"
#include "Bob.h"
#include "Part.h"

int main() {

    Alice* alice[100];
    Bob* bob[100];

    int ma = 0;
    std::cin >> ma;
    for (int i = 0; i < ma; ++i) {
        int k = 0;
        std::cin >> k;
        alice[i] = new Alice(k);
    }

    int mb = 0;
    std::cin >> mb;
    for (int i = 0; i < mb; ++i) {
        int k = 0;
        std::cin >> k;
        bob[i] = new Bob(k);
    }

    int m = 0;
    std::cin >> m;
    int a_i = 0;
    int b_i = 0;
    for (int i = 0; i < m; ++i) {
        int p = 0, id = 0;
        std::cin >> p >> id;
        if (p == 0) {
            alice[a_i]->add_part(Part(id));
            if (alice[a_i]->is_full()) {
                std::cout << *(alice[a_i]) << " run: " << alice[a_i]->run() << std::endl;
                a_i++;
            }
        }
        else {
            bob[b_i]->add_part(Part(id));
            if (bob[b_i]->is_full()) {
                std::cout << *(bob[b_i]) << " run: " << bob[b_i]->run() << std::endl;
                b_i++;
            }
        }
    }

    for (int i = 0; i < ma; ++i) {
        delete alice[i];
    }
    for (int i = 0; i < mb; ++i) {
        delete bob[i];
    }

    return 0;
}