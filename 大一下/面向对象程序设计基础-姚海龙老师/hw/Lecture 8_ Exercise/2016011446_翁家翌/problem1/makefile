all:main
main:main.o member.o
	g++ main.o member.o -omain
member.o:member.cpp member.h
	g++	-c -o member.o member.cpp
clear:
	rm -rf *.o main