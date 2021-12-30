all: main.out
main.out: const.h Server.o Client.o main.o
	g++ Server.o Client.o main.o -lglog -pthread -std=c++11 -o main.out

main.o: main.cpp

Server.o: const.h Server.cpp Server.h
	g++ -c -o Server.o Server.cpp -lglog -std=c++11

Client.o: const.h Client.cpp Client.h
	g++ -c -o Client.o Client.cpp -lglog -std=c++11

clean:
	rm *.o
