#include "member.h"

#include <iostream>

/**
 * [Member::Member() description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * initialize the name and age of this member
 */
Member::Member(const std::string __name, const int __age)
	: name(__name), age(__age)
{
}

/**
 * [Member::printInfo description]
 * @Author   n+e
 * @DateTime 2017-04-11
 * print the name and age of this member
 */
void Member::printInfo()const
{
	std::cout << "name: " << name << "\t age: " << age << std::endl;
}
