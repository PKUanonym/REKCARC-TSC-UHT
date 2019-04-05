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
#include "student.h"

void student::init(std::string str)
{
	std::stringstream ss(str);
	ss >> id >> email;
}

std::ostream& operator<<(std::ostream& out, const student& stu)
{
	out << "ID: " << stu.id << "\tEmail: " << stu.email << std::endl;
	return out;
}

Assigner::Assigner() { total = 0; }

void Assigner::load()
{
	std::ifstream in("ContactEmail.txt");
	std::string tmp;
	std::getline(in, tmp);
	while(std::getline(in, tmp))
		stu[total++].init(tmp);
}
