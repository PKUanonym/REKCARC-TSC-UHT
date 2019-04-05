#include "mst.h"

int main(int argc, char const *argv[])
{
	std::cout << "0: detail message" << std::endl;
	std::cout << "1: only value" << std::endl << "0 or 1? :";
	std::cin >> CAS;
	std::cout << "0: init your graph (n, m, {x, y, v})" << std::endl;
	std::cout << "1: generate randomly" << std::endl << "0 or 1? :";
	std::cin >> CAS2;

	srand(time(0)); //printf("%ld\n", time(0));
	//init graph
	MST G;
	if (CAS2)
		for (int i = 0; i < 20; i++)
		{
			Point tmp = (Point) {rand() % 10000, rand() % 10000}
			+ (Point) {1.*rand() / RAND_MAX, 1.*rand() / RAND_MAX};
			G.Add_Point(tmp);
		}
	else
	{
		int n, m, x, y; ld v;
		std::cout << "Input n (max 20), m: ";
		std::cin >> n >> m;
		if (n <= 0 || m <= 0 || n > 20 || m > n * (n - 1) / 2)
		{
			std::cout << "Error!" << std::endl;
			return 0;
		}
		std::cout << "Input edges like 1 2 0.1" << std::endl;
		for (total_node = n; m--;)
		{
			std::cout << "No." << total_edge + 1 << ": ";
			std::cin >> x >> y >> v;
			if (v <= 0)
			{
				std::cout << "Error! v<=0" << std::endl;
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
	std::cout << "Enter the number of top k MST (max 20) you want." << std::endl;
	std::cout << "Make sure the graph has k different trees: ";
	std::cin >> CAS3;
	if (CAS3 > 20)
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