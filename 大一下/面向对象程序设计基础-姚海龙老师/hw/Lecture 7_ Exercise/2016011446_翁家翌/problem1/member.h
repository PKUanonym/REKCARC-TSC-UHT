#ifndef __MEMBER_H__
#define __MEMBER_H__

#include <string>

class Member
{
	const std::string name;
	const int age;
public:
	Member(const std::string __name = "???", const int __age = 0);
	void printInfo()const;
};

#endif //__MEMBER_H__