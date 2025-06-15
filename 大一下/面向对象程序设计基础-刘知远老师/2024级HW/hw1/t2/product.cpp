#include "functions.h"
#include <iostream>

int custom_product(int a, int b)
{
#ifdef DEBUG
	std::cout << "running product(a = " << a << ", b = " << b << ")" << std::endl; 
#endif
	return a * b;
}
