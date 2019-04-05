all: default grade

default: main.cpp bfs.cpp
	g++ -std=c++11 -fopenmp -O3 -g -o bfs main.cpp bfs.cpp ../common/graph.cpp ref_bfs.o
grade: grade.cpp bfs.cpp
	g++ -std=c++11 -fopenmp -O3 -g -o bfs_grader grade.cpp bfs.cpp ../common/graph.cpp ref_bfs.o
clean:
	rm -rf bfs_grader bfs  *~ *.*~
