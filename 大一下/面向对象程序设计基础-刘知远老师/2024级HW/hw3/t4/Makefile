CXX = g++
CXXFLAGS = -std=c++17

all: main

main: main.o employee.o device.o
	$(CXX) $(CXXFLAGS) main.o employee.o device.o -o main

main.o: main.cpp _Employee.h Employee.h _Device.h Device.h
	$(CXX) -c main.cpp $(CXXFLAGS) -o main.o

employee.o: Employee.cpp _Employee.h Employee.h _Device.h
	$(CXX) -c Employee.cpp $(CXXFLAGS) -o employee.o

device.o: Device.cpp _Device.h Device.h
	$(CXX) -c Device.cpp $(CXXFLAGS) -o device.o

clean:
	rm -f *.o main