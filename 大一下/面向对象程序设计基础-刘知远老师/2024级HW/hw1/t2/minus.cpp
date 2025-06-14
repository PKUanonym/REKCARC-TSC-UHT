#include "functions.h"
#include <iostream>

int custom_minus(int a, int b)
{
#ifdef DEBUG
	std::cout << "running minus(a = " << a << ", b = " << b << ")" << std::endl; 
#endif
	return a - b;
}
