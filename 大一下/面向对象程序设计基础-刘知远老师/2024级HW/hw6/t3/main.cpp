#include <iostream>

#include "MyList.h"

int main()
{
	int n;
	std::cin >> n; // perform until subtask n

	MyList x;
	//subtask 1
	#ifdef TASK1
	std::cout << x << std::endl;
	for(int i = 0; i < 5; i++)
		x.append(i);
	std::cout << x[0] << std::endl;
	std::cout << x << std::endl;
	#elif TASK2
	//subtask 2
	MyList y = x;
	y[0] += 5;
	std::cout << x << std::endl;
	#elif TASK3
	//subtask 3
	MyList z = x(1, 3);
	std::cout << z << std::endl;
	z[1] += 5;
	std::cout << z << std::endl;
	std::cout << x << std::endl;
	#elif TASK4
	//subtask 4
	MyList r = x(2, 4);
	std::cout << r << std::endl;
	r.append(-1);
	std::cout << r << std::endl;
	std::cout << x << std::endl;
	#endif
	return 0;
}
