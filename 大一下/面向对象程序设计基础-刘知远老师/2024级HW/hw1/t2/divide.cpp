#include "functions.h"
#include <iostream>

int custom_divide(int a, int b)
{
#ifdef DEBUG
	std::cout << "running divide(a = " << a << ", b = " << b << ")" << std::endl; 
#endif
	return a / b;
}
