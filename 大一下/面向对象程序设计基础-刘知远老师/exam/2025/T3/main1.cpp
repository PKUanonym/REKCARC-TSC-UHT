#include <iostream>
#include "array.h"
using namespace std;
int main() {
	int tot = 0;
	MultiArray<int, 3> a({2, 3, 2}, {11, 2, 3, 4, 5, 6, 7, 18, 9, 10, 11, 12});
	MultiArray<int, 4> b({2, 3, 2, 4});

	for (int i = 0; i < 2; ++i) {
		for (int j = 0; j < 3; ++j) {
			for (int k = 0; k < 2; ++k) {
				for (int l = 0; l < 4; ++l) {
					b.set({i, j, k, l}, i * j * k * l);
					b.get({i, j, k, l}) += 2;
					tot += b.get({i, j, k, l}) * b.get({i, j, k, l}) + a.get({i, j, k});
				}
			}
		}
	}

	cout<<a;
	cout<<b;

	cout << tot << endl;
	
	MultiArray<int, 3> c;
	for (int i = 0; i < 3; ++i) {
		cout << c.get_dims()[i] << endl;
	}
	return 0;
}