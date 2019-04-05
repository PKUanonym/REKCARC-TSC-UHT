#include "mst.h"

int main(int argc, char const *argv[])
{
	std::cout << "0: detail message" << std::endl;
	std::cout << "1: only value" << std::endl << "0 or 1? :";
	std::cin >> CAS;
	if (CAS < 0 || CAS > 1)
	{
		std::cout << "Error!" << std::endl;
		return 0;
	}
	std::cout << "0: init your graph (n, m, {x, y, v})" << std::endl;
	std::cout << "1: init your graph (n, {(x, y)})" << std::endl;
	std::cout << "2: generate randomly (" << MAX_POINT << " points)" << std::endl << "0 or 1 or 2? :";
	std::cin >> CAS2;
	if (CAS2 < 0 || CAS2 > 2)
	{
		std::cout << "Error!" << std::endl;
		return 0;
	}
	srand(time(0)); //printf("%ld\n", time(0));
	//init graph
	MST G;
	if (CAS2 == 1)
	{
		int n;
		std::cout << "Input n (max " << MAX_POINT << "): ";
		std::cin >> n;
		if (n <= 0 || n > MAX_POINT)
		{
			std::cout << "Error!" << std::endl;
			return 0;
		}
		for (int i = 0; i < n; i++)
		{
			Point tmp;
			std::cout << "No." << i + 1 << " point: ";
			std::cin >> tmp.x >> tmp.y;
			G.Add_Point(tmp);
		}
	}
	else if (CAS2 == 2)
	{
		for (int i = 0; i < MAX_POINT; i++)
		{
			Point tmp = (Point) {rand() % 10000, rand() % 10000}
			+ (Point) {1.*rand() / RAND_MAX, 1.*rand() / RAND_MAX};
			G.Add_Point(tmp);
		}
		CAS2 = 1;
	}
	else
	{
		int n, m, x, y; ld v;
		std::cout << "Input n (max " << MAX_POINT << "), m: ";
		std::cin >> n >> m;
		if (n <= 0 || m <= 0 || n > MAX_POINT || m > n * (n - 1) / 2)
		{
			std::cout << "Error!" << std::endl;
			return 0;
		}
		std::cout << "Input edges like 1 2 0.1" << std::endl;
		for (total_node = n; m--;)
		{
			std::cout << "No." << total_edge + 1 << ": ";
			std::cin >> x >> y >> v;
			if (v <= 0 || x < 0 || y < 0 || x > n || y > n)
			{
				std::cout << "Error!" << std::endl;
				return 0;
			}
			G.Add_Edge(x, y, v);
		}
	}
	G.Generate_Graph();
	//compute MST
	G.computeMST();
	G.Print(1);

	//calculate top k MST
	SOLVER sol;
	std::cout << "Enter the number of top k MST (max " << MAXK << ") you want." << std::endl;
	std::cout << "Make sure the graph has k different trees: ";
	std::cin >> CAS3;
	if (CAS3 > MAXK)
	{
		std::cout << "Error!" << std::endl;
		return 0;
	}
	int k = sol.Iterate(G);
	Graph *Arr = sol.Extract_Ans(k);
	//output
	for (int i = 1; i <= CAS3; i++)
		Arr[i].Print(i);
	return 0;
}