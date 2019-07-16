PTH_FLAGS = -Ofast -pthread -std=c++11 -Wall -Wextra
OMP_FLAGS = -Ofast -fopenmp -std=c++11 -Wall -Wextra

all: 4_7_1 4_7_2 4_7_3 bin_pth bin_omp fib_pth fib_omp_task fib_omp_section

4_7_1: 4_7_1.cpp util.hpp
	g++ $(PTH_FLAGS) 4_7_1.cpp -o 4_7_1

4_7_2: 4_7_2.cpp util.hpp
	g++ $(PTH_FLAGS) 4_7_2.cpp -o 4_7_2

4_7_3: 4_7_3.cpp util.hpp
	g++ $(PTH_FLAGS) 4_7_3.cpp -o 4_7_3

bin_pth: bin_pth.cpp util.hpp
	g++ $(PTH_FLAGS) bin_pth.cpp -o bin_pth

bin_omp: bin_omp.cpp util.hpp
	g++ $(OMP_FLAGS) bin_omp.cpp -o bin_omp

fib_pth: fib_pth.cpp util.hpp
	g++ $(PTH_FLAGS) fib_pth.cpp -o fib_pth

fib_omp_task: fib_omp_task.cpp util.hpp
	g++ $(OMP_FLAGS) fib_omp_task.cpp -o fib_omp_task

fib_omp_section: fib_omp_section.cpp util.hpp
	g++ $(OMP_FLAGS) fib_omp_section.cpp -o fib_omp_section

clean:
	rm 4_7_1 4_7_2 4_7_3  bin_pth bin_omp fib_pth fib_omp_task fib_omp_section
	