#include <iostream>
#include <string>
#include <fstream>
#include "dragon.h"
#include "weapon.h"
#include "ninja.h"
#include "fire_ninja.h"
#include "ice_ninja.h"
using namespace std;

int main() {
	int n, type1;
	string dragon1, weapon1;
	freopen("test.out", "w", stdout);
	std::cin >> n; 
	for (int i=0; i<n; i++) {
		std::cout << "##Round " << i+1 << ", Ninja is coming!" << endl;
		std::cin >> type1 >> dragon1 >> weapon1;
		switch (type1) {
			case 0: {
				Ninja ninja1 = Ninja(dragon1, weapon1);
				ninja1.describe();
				break;
			}
			case 1: {
				FireNinja ninja1 = FireNinja(dragon1, weapon1);
				ninja1.describe();
				ninja1.fire_power();
				break;
			}
			case 2: {
				IceNinja ninja1 = IceNinja(dragon1, weapon1);
				ninja1.describe();
				ninja1.ice_power();
				break;
			}
		}
		std::cin >> type1 >> dragon1 >> weapon1;
		switch (type1) {
			case 0: {
				Ninja ninja1 = Ninja(dragon1, weapon1);
				ninja1.describe();
				break;
			}
			case 1: {
				FireNinja ninja1 = FireNinja(dragon1, weapon1);
				ninja1.describe();
				ninja1.fire_power();
				break;
			}
			case 2: {
				IceNinja ninja1 = IceNinja(dragon1, weapon1);
				ninja1.describe();
				ninja1.ice_power();
				break;
			}
		}
	}
	return 0;
}