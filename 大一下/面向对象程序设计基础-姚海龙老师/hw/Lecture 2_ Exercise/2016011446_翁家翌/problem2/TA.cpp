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

#include "TA.h"
#include <bits/stdc++.h>

TeamAssigner::TeamAssigner()
{
	group_total = 0;
	srand(time(0));
}

void TeamAssigner::assign()
{
	memset(group_size, 0, sizeof group_size);
	for (int i=0; i<total; ++i)
	{
		group[i] = i;
	}
	std::random_shuffle(group, group+total);
	for (; group_size[group_total]<total; group_total++)
	{
		group_size[group_total+1] = group_size[group_total] + 3;
	}
	group_size[group_total] = total;
	if (total - group_size[group_total-1] == 1)
		group_size[group_total-1]--;
}

void TeamAssigner::output()
{
	std::cerr << "TeamAssigner is done!" << std::endl;
	std::ofstream out("team.txt");
	for (int i = 0; i < group_total; ++i)
	{
		int j = group_size[i], k = group_size[i+1];
		out << "Group " << i+1 << ": " << k-j << " members" << std::endl;
		for (; j < k; ++j)
		{
			out << "\t" << stu[group[j]];
		}
		out << std::endl;
	}
}
