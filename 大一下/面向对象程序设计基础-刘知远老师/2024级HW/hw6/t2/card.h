#pragma once
#include <ostream>
#include <string>

struct Card {
	std::string name;
	int number;
	Card(const std::string &_name, int _number) : name(_name), number(_number) {}
	friend std::ostream &operator<<(std::ostream &os, const Card &c) {
		os << '(' << c.name << ' ' << c.number << ')';
		return os;
	}
};