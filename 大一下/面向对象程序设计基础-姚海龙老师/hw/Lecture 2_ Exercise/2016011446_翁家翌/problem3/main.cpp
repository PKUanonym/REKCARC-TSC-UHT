/*
* Copyright (c) 2017 Trinkle
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

#include <bits/stdc++.h>
#include "videotape.h"

int main(int argc, char const *argv[])
{
	Stack s;
	int cas = 0;
	while (1)
	{
		std::cout << "0: Add new video\n1: Rent video\n2: Send back video\n3: Print video list\n4: Quit" << std::endl;
		std::cin >> cas;
		if (cas == 4)
		{
			std::cout << "Your GPA will be 4.0!" << std::endl;
			return 0;
		}
		if (cas < 0 || cas > 4)
			continue;
		if (cas == 0)
		{
			std::cout << "Please input this new video's name: ";
			std::string str;
			std::cin >> str;
			s.add(str);
		}
		else if (cas == 1)
		{
			std::cout << "Please input this video's name: ";
			std::string str;
			std::cin >> str;
			std::cout << "Please input customer's name: ";
			std::string name;
			std::cin >> name;
			s.require(str, name);
		}
		else if (cas == 2)
		{
			std::cout << "Please input this video's name: ";
			std::string str;
			std::cin >> str;
			std::cout << "Please input customer's name: ";
			std::string name;
			std::cin >> name;
			s.sendback(str, name);
		}
		else
			s.print();
	}
	return 0;
}
