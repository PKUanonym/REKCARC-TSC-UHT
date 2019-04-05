obj = method.o kmp.o karp_rabin.o data.o raw_data.o pattern.o conf.o
all: main
main: $(obj) main.cpp
	g++ -O2 -std=c++11 -c main.cpp -o main.o
	g++ -O2 -std=c++11 $(obj) main.o -omain
%.o: %.cpp %.h
	g++ -O2 -std=c++11 -c $< -o $@
clean:
	rm *.o main
