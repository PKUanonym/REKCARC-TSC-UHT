#include <iostream>
#include "array.h"
using namespace std;
int main() {
	int tot = 0;
	MultiArray<int, 3> a({2, 3, 2}, {11, 2, 3, 4, 5, 6, 7, 18, 9, 10, 11, 12});
	MultiArray<int, 4> b({2, 3, 2, 4});
	MultiArray<int, 4> c({2, 3, 2, 4});
	for (int i = 0; i < 2; ++i) {
		for (int j = 0; j < 3; ++j) {
			for (int k = 0; k < 2; ++k) {
				for (int l = 0; l < 4; ++l) {
					b.set({i, j, k, l}, i * j * k * l);
					b.get({i, j, k, l}) += 2;
					c.set({i, j, k, l}, i + j + k + l);
					tot += b.get({i, j, k, l}) * b.get({i, j, k, l}) + a.get({i, j, k});
				}
			}
		}
	}
	cout << tot << endl;
	auto it = b.begin();
	while (it != b.end()) {
		cout << *it << '\n';
		it++;
	}
	cout <<"!!!!!"<< (it == b.begin()) << endl;
	cout <<"!!!!!"<< (it == b.end()) << endl;
	const MultiArray<int, 4> d = c;
	auto e = d.begin();
	while (e != d.end()) {
		cout << *e << '\n';
		++e;
	}
	cout <<"!!!!!"<< (e == d.begin()) << endl;
	cout <<"!!!!!"<< (e == d.end()) << endl;
	cout <<"!!!!!"<< (it == e) << endl;
	return 0;
}