#include "weapon.h"

Weapon::Weapon(string name): name(name) {
	cout << "Using "  << name << " weapon."<< endl;
}

string Weapon::get_name() {
	return name;
}
