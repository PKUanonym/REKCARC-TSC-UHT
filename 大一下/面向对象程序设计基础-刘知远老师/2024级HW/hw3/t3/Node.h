#pragma once
#include <iostream>

struct Node
{
private:
	static int createTimes, copyCreateTimes, moveCreateTimes, copyAssignTimes, moveAssignTimes, delTimes;
	int val;
public:	
	Node(int v = 0);
	~Node();
	Node(const Node &y);
	Node(Node &&y);
	Node& operator=(const Node &y);
	Node& operator=(Node &&y);
	friend std::istream& operator>>(std::istream& in, Node& x);
	friend std::ostream& operator<<(std::ostream& out, const Node& x);
	static void outputResult();
};
