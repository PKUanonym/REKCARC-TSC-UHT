all: 1_1 1_2 2 3 4_1 4_2

1_1: 1_1.cpp util.hpp
	mpiicc -Ofast -march=native -fopenmp -std=c++11 1_1.cpp -o 1_1

1_2: 1_2.cpp util.hpp
	mpiicc -Ofast -march=native -fopenmp -std=c++11 1_2.cpp -o 1_2

2: 2.cpp util.hpp
	g++ -O2 -pthread -std=c++11 2.cpp -o 2

3: 3.cpp util.hpp
	icc -O3 -march=native -fopenmp -std=c++11 3.cpp -o 3

4_1: 4_1.cpp util.hpp
	g++ -Ofast -march=native -fopenmp -std=c++11 4_1.cpp -o 4_1

4_2: 4_2.cpp util.hpp
	g++ -Ofast -march=native -pthread -fopenmp -std=c++11 4_2.cpp -o 4_2

clean:
	rm 1_1 1_2 2 3 4_1 4_2
