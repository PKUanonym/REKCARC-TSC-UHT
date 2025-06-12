#pragma once
#include <iostream>
using ll = long long;
ll gcd(ll x, ll y) {
	if (x < y) std::swap(x, y);
	while (y) {
		x %= y;
		std::swap(x, y);
	}
	return x;
}

class Node {
public:
	static int count, c1, c2, c3;
	ll fm, fz;
	Node() : fm(0), fz(1) {c1++;}
	Node(ll fm_, ll fz_) : fm(fm_), fz(fz_) {
		c1++;
		if (fm < 0) {
			fm = -fm;
			fz = -fz;
		}
	}
	Node(const Node& x) : fm(x.fm), fz(x.fz) {c2++;}
	Node(Node&& x) : fm(x.fm), fz(x.fz) {c3++;}
	~Node() {++count;}
	static int get_count() {return c1 + c2 + c3 == count;}
	friend Node operator + (const Node &a, const Node &b) {
		ll z = b.fm * a.fz + b.fz * a.fm, m = b.fm * a.fm;
		ll g = gcd(z, m);
		return Node(m / g, z / g);
	}
	friend Node operator - (const Node &a, const Node &b) {
		ll z = b.fm * a.fz - b.fz * a.fm, m = b.fm * a.fm;
		ll g = gcd(z, m);
		return Node(m / g, z / g);
	}
	friend Node operator * (const Node &a, const Node &b) {
		ll z = a.fz * b.fz, m = b.fm * a.fm;
		ll g = gcd(z, m);
		return Node(m / g, z / g);
	}
	friend Node operator / (const Node &a, const Node &b) {
		ll z = a.fz * b.fm, m = b.fz * a.fm;
		ll g = gcd(z, m);
		return Node(m / g, z / g);
	}
	Node operator =(const Node &x) {
		fm = x.fm;
		fz = x.fz;
		return *this;
	}
	bool operator ==(const Node &x) const {
		return fm == x.fm && fz == x.fz;
	}
	bool operator !=(const Node &x) const {
		return fm != x.fm || fz != x.fz;
	}
};
int Node::count = 0;
int Node::c1 = 0;
int Node::c2 = 0;
int Node::c3 = 0;



std::ostream& operator << (std::ostream& os, const Node &x) {
	os << x.fz << "/" << x.fm;
	return os;
}