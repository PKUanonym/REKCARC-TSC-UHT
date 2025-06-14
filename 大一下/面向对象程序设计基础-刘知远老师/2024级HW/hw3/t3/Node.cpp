#include "Node.h"

int Node::createTimes = 0, Node::copyCreateTimes = 0, Node::moveCreateTimes = 0;
int Node::copyAssignTimes = 0, Node::moveAssignTimes = 0, Node::delTimes = 0;

Node::Node(int v): val(v) {
	createTimes++;
}
Node::~Node() {
	delTimes++;
}
Node::Node(const Node &y): val(y.val) {
	copyCreateTimes++;
}
Node::Node(Node &&y): val(y.val) {
	y.val = 0;
	moveCreateTimes++;
}
Node& Node::operator=(const Node &y) {
	val = y.val;
	copyAssignTimes++;
	return *this;
}
Node& Node::operator=(Node &&y) {
	val = y.val;
	y.val = 0;
	moveAssignTimes++;
	return *this;
}

std::istream& operator>>(std::istream& in, Node& x){
	in >> x.val;
	return in;
}
std::ostream& operator<<(std::ostream& out, const Node& x){
	out << x.val;
	return out;
}
	
void Node::outputResult() {
	std::cout << Node::createTimes << " " << 
		Node::copyCreateTimes << " " << 
		Node::moveCreateTimes << " " << 
		Node::copyAssignTimes << " " << 
		Node::moveAssignTimes << " " << 
		Node::delTimes << std::endl;
}