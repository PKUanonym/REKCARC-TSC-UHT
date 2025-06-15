#pragma once
#include <iostream>
#include <string>
using namespace std;

class Weapon {
	string name;
public:
	Weapon(string);
	string get_name();
};