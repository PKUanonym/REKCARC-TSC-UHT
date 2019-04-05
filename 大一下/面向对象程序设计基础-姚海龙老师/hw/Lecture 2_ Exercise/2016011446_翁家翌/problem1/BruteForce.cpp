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

#include "BruteForce.h"

double BF::polynomial(int argc, double *argv)
{
	int n = argc - 2;
	double x = argv[argc - 1];
	double ans = 0;
	for (int i = 1; i <= n; ++i)
	{
		double pw = 1;
		for (int j = 1; j < i; ++j)
			pw *= x;
		ans += argv[i] * pw;
	}
	return ans;
}

double BF::posynomial(int argc, double *argv)
{
	int n = argc - 2;
	double x = argv[argc - 1];
	if (x == 0)
		return 1 / x;
	double ans = 0;
	for (int i = 1; i <= n; ++i)
	{
		double pw = 1;
		for (int j = 1; j < i; ++j)
			pw /= x;
		ans += argv[i] * pw;
	}
	return ans;
}
