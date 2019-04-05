#include <iostream>
#include <cstdlib>

void posynomial(int argc, char const **argv)
{
	int n = argc - 2;
	double x = atof(argv[argc - 1]);
	if (x == 0)
	{
		std::cout << "Error: x == 0" << std::endl;
		return;
	}
	double ans = 0, pw = 1;
	for (int i = 0; i < n; ++i)
	{
		ans += atof(argv[i + 1]) * pw;
		pw /= x;
	}
	std::cout << "posynomial: " << ans << std::endl;
}
