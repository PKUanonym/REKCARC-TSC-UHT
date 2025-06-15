#pragma once
#include <cstdio>
#include <vector>

class Weapon {
public:
    std::vector<int> spells;
    const int penetration;

    Weapon(int _penetration): penetration(_penetration) {
        printf("Weapon with penetration %d created\n", penetration);
    }
    ~Weapon() {
        printf("Weapon destroyed\n");
    }
    // Disallow other constructors
    Weapon(const Weapon&) = delete;
    Weapon& operator=(const Weapon&) = delete;
    Weapon(Weapon&&) = delete;
    Weapon& operator=(Weapon&&) = delete;
};