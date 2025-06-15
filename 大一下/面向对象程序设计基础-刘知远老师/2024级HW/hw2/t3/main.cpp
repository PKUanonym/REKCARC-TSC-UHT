#include "Factor.h"
#include <iostream>

int main()
{
	using namespace std;
	Factor A, B;
	cin >> A;
	cin >> B;
	cout << A + B << endl;
	cout << A * B << endl;
	cout << A / B << endl;
	if (A < B)
		cout << "smaller" << endl;
	if (A > B)
		cout << "bigger" << endl;
	if (A == B)
		cout << "equal" << endl; 
	return 0;
}
