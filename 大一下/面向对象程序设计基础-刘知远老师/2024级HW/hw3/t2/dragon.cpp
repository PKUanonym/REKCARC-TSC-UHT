#include "dragon.h"

Dragon::Dragon(string name): name(name) {
	cout << "Driving "  << name << " dragon."<< endl;
}

string Dragon::get_name() {
	return name;
}
