#include <iostream>
#include "node.h"
#include "array.h"
using namespace std;
void f() {
	int tot = 0;
	MultiArray<int, 3> a({2, 3, 2}, {11, 2, 3, 4, 5, 6, 7, 18, 9, 10, 11, 12});
	MultiArray<Node, 4> b({2, 3, 2, 4});
	for (int i = 0; i < 2; ++i) {
		for (int j = 0; j < 3; ++j) {
			for (int k = 0; k < 2; ++k) {
				for (int l = 0; l < 4; ++l) {
					int fz = 100 + i + j + k + l, fm = 96 - i - j - k - l;
					int g = gcd(fz, fm);
					b.set({i, j, k, l}, Node(fm / g, fz / g));
				}
			}
		}
	}
	cout << b << endl << endl;
	a.reshape({5, 2, 2});
	a.reshape({6, 2, 1});
	cout << a << endl << endl;
	b.resize({2, 3, 3, 4});
	cout << b << endl;
}

int main() {
	f();
	return 0;
}