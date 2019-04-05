//main.cpp
#include "member.h"
int main()
{
	Member newMembers[5] = {
		Member("Zhang San", 22),
		Member("Li Si", 19),
		Member("Wang Wu", 18),
		Member("Zhao Liu", 24)
	};
	for (int i = 0; i < 5; i++)
		newMembers[i].printInfo();
	return 0;
}