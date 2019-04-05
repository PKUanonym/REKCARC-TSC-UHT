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
#include "RA.h"

ReviewerAssigner::ReviewerAssigner()
{
	srand(time(0));
}

void ReviewerAssigner::choose()
{
	int x, y, z;
	for (int i = 0; i < total; ++i)
	{
		do {
			x = rand() % total;
		} while (x == i);
		do {
			y = rand() % total;
		} while (y == i || y == x);
		do {
			z = rand() % total;
		} while (z == i || z == x || z == y);
		reviewer[i][0] = x;
		reviewer[i][1] = y;
		reviewer[i][2] = z;
	}
}

void ReviewerAssigner::output()
{
	std::cerr << "ReviewerAssigner is done!" << std::endl;
	std::ofstream out("reviewer.txt");
	for (int i = 0; i < total; ++i)
	{
		out << stu[i];
		out << "\t Reviewer 1: " << stu[reviewer[i][0]].id << std::endl;
		out << "\t Reviewer 2: " << stu[reviewer[i][1]].id << std::endl;
		out << "\t Reviewer 3: " << stu[reviewer[i][2]].id << std::endl;
		out << std::endl;
	}
}
