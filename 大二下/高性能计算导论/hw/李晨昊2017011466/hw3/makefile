.PHONY: all clean

all: 1 2 3 4

1: 1.c
	mpicc -O3 -std=c11 1.c -o 1

2: 2.c
	mpicc -O3 -std=c11 2.c -o 2

3: 3.cpp
	mpiicc -O3 -std=c++11 3.cpp -o 3

4: 4.cpp
	mpiicc -O3 -std=c++11 4.cpp -o 4

clean:
	rm 1 2 3 4